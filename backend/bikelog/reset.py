"""Fresh start and restore while the app runs (Settings → Fresh start / Backups).

Nothing is lost: both first write a backup that is kept (never pruned), and that backup can be restored
from Settings. The database file stays in place (no rename/delete of an open file, which Windows
refuses); its contents are replaced through SQLite itself:

* reset: drop every table, view and trigger in one exclusive transaction (DROP TABLE does not fire the
  no-delete triggers), then run all migrations again and add the default service rules.
* restore (a backup) and import (a full export): copy the data into a temporary file, upgrade THAT copy to
  the current schema (so a failed upgrade never touches the live data), back up the live data (kept),
  then copy the upgraded data into the live database with SQLite's backup API.
Strava app details and login live in ``strava.env``, not in the database; a reset keeps them unless
asked to clear them.
"""
from __future__ import annotations

import logging
import sqlite3
import tempfile
import threading
from contextlib import closing
from pathlib import Path

from sqlalchemy.orm import Session, sessionmaker

from bikelog.backup import (
    KEPT_MARK,
    backup_database,
    copy_attachments_aside,
    extract_export,
    inspect_archive,
    replace_attachments,
)
from bikelog.db import session_scope
from bikelog.migrate import (
    head_revision,
    known_revisions,
    run_migrations,
)
from bikelog.paths import DataPaths
from bikelog.services.errors import DomainError

log = logging.getLogger(__name__)

CONFIRM_WORD = "RESET"
_lock = threading.Lock()


def _migrate_and_seed(factory: sessionmaker[Session]) -> None:
    engine = factory.kw["bind"]
    engine.dispose()          # pooled connections may have cached the old schema
    run_migrations(engine)
    from bikelog.services.reference import ensure_reference_data
    with session_scope(factory) as s:
        ensure_reference_data(s)


def _keep_strava_connection(factory: sessionmaker[Session], connected: bool) -> None:
    if not connected:
        return
    from bikelog.connectors.strava.sync import SOURCE_ACCOUNT
    from bikelog.models import StravaConnection
    with session_scope(factory) as s:
        s.add(StravaConnection(athlete_id=SOURCE_ACCOUNT, status="ACTIVE"))


def reset_database(factory: sessionmaker[Session], paths: DataPaths, *, confirm: str, clear_strava: bool = False,
                   strava_web=None) -> dict:
    if (confirm or "").strip() != CONFIRM_WORD:
        raise DomainError(f"Type {CONFIRM_WORD} to confirm the fresh start")
    if strava_web is not None and strava_web.job.get("running"):
        raise DomainError("A Strava sync is running; wait until it has finished")
    with _lock:
        backup = backup_database(paths, f"{KEPT_MARK}reset")
        engine = factory.kw["bind"]
        engine.dispose()
        raw = sqlite3.connect(paths.database, isolation_level=None, timeout=10)
        with closing(raw):
            raw.execute("PRAGMA foreign_keys = OFF")
            raw.execute("BEGIN EXCLUSIVE")
            try:
                objects = raw.execute("SELECT type, name FROM sqlite_master WHERE name NOT LIKE 'sqlite_%' "
                                      "AND type IN ('trigger', 'view', 'table')").fetchall()
                for kind in ("trigger", "view", "table"):
                    for t, name in objects:
                        if t == kind:
                            raw.execute(f'DROP {kind.upper()} IF EXISTS "{name}"')
                raw.execute("COMMIT")
            except Exception:
                raw.execute("ROLLBACK")
                raise
            raw.execute("VACUUM")
        _migrate_and_seed(factory)
        strava = _strava_after_reset(factory, strava_web, clear_strava)
    log.warning("Database reset (fresh start); kept backup %s; Strava %s", backup.name if backup else None,
                "cleared" if clear_strava else "kept")
    return {"backup": backup.name if backup else None, "backup_path": str(backup) if backup else None,
            "strava": strava}


def _strava_after_reset(factory: sessionmaker[Session], strava_web, clear: bool) -> str:
    if strava_web is None:
        return "not set up"
    env = strava_web._env()
    has_login = bool(env.get("STRAVA_REFRESH_TOKEN"))
    if clear:
        if has_login:
            try:
                strava_web.client().deauthorize()
            except Exception as e:  # offline or token expired: the local login is removed anyway
                log.warning("Strava deauthorize during reset failed: %s", e)
        from bikelog.connectors.strava import client as sc
        sc.update_env(strava_web.env_file, {k: None for k in env if k.startswith("STRAVA_")})
        return "cleared"
    _keep_strava_connection(factory, has_login)
    return "kept (connected)" if has_login else ("kept (app details only)" if env.get("STRAVA_CLIENT_ID") else
                                                 "not set up")


def _backup_file(paths: DataPaths, name: str) -> Path:
    f = (paths.backups / name).resolve()
    if f.parent != paths.backups.resolve() or not f.name.endswith(".db") or not f.exists():
        raise DomainError("No such backup")
    return f


def _export_file(paths: DataPaths, name: str) -> Path:
    f = (paths.exports / name).resolve()
    if f.parent != paths.exports.resolve() or not f.name.endswith(".zip") or not f.exists():
        raise DomainError("No such export")
    return f


def _after_upgrade(factory: sessionmaker[Session]) -> None:
    """What the app does at every start after migrating (launcher.prepare), so restored data is complete."""
    from bikelog.services import frames, wheels
    from bikelog.services.reference import ensure_reference_data
    with session_scope(factory) as s:
        ensure_reference_data(s)
        frames.ensure_frames(s)
        wheels.ensure_wheels(s)


def _upgraded_copy(src: Path, workdir: Path) -> Path:
    """Copy a database into workdir and bring the COPY to the current schema. If that fails, the live data
    was never touched. Returns the upgraded copy."""
    from bikelog.db import make_engine, make_session_factory
    copy = workdir / "restore.db"
    with closing(sqlite3.connect(f"file:{src.as_posix()}?mode=ro", uri=True)) as s, closing(sqlite3.connect(copy)) as d:
        s.backup(d)
    engine = make_engine(copy)
    try:
        run_migrations(engine)
        _after_upgrade(make_session_factory(engine))
    finally:
        engine.dispose()
    with closing(sqlite3.connect(copy)) as c:
        c.execute("PRAGMA journal_mode = DELETE")
        if c.execute("PRAGMA integrity_check").fetchone()[0] != "ok" or c.execute("PRAGMA foreign_key_check").fetchall():
            raise DomainError("The restored data did not pass the database checks; nothing was changed")
    return copy


def _swap_in(factory: sessionmaker[Session], upgraded: Path, paths: DataPaths) -> None:
    """Replace the live database's contents with an upgraded copy (SQLite backup API: the file stays in place,
    which Windows needs while the app runs)."""
    engine = factory.kw["bind"]
    engine.dispose()
    with closing(sqlite3.connect(upgraded)) as s, closing(sqlite3.connect(paths.database, timeout=10)) as d:
        s.backup(d)
    engine.dispose()          # pooled connections may have cached the old schema


def _check_revision(rev: str | None, what: str) -> None:
    if rev is None:
        raise DomainError(f"{what} is not a Bike Log database this version can read")
    if rev not in known_revisions():
        raise DomainError(f"{what} was made by a newer Bike Log (database schema {rev}). Install the newer version first.")


def restore_backup(factory: sessionmaker[Session], paths: DataPaths, name: str, strava_web=None) -> dict:
    src = _backup_file(paths, name)
    if strava_web is not None and strava_web.job.get("running"):
        raise DomainError("A Strava sync is running; wait until it has finished")
    with closing(sqlite3.connect(f"file:{src.as_posix()}?mode=ro", uri=True)) as c:
        try:
            ok = c.execute("PRAGMA integrity_check").fetchone()[0] == "ok"
        except sqlite3.DatabaseError:
            ok = False
        if not ok:
            raise DomainError(f"{name} is damaged or not a database; pick another backup")
        try:
            rev = c.execute("SELECT version_num FROM alembic_version").fetchone()
        except sqlite3.Error:
            rev = None
    _check_revision(rev[0] if rev else None, name)
    with _lock, tempfile.TemporaryDirectory() as tmp:
        upgraded = _upgraded_copy(src, Path(tmp))
        safety = backup_database(paths, f"{KEPT_MARK}restore")
        _swap_in(factory, upgraded, paths)
    log.warning("Restored backup %s (backup of the data before: %s)", name, safety.name if safety else None)
    return {"restored": name, "backup": safety.name if safety else None,
            "backup_path": str(safety) if safety else None}


def check_export(paths: DataPaths, name: str) -> dict:
    try:
        return inspect_archive(_export_file(paths, name), known_revisions(), head_revision())
    except ValueError as e:
        raise DomainError(str(e)) from e


def restore_export(factory: sessionmaker[Session], paths: DataPaths, name: str, strava_web=None) -> dict:
    """Settings → Import a full export: replace all data and attachments with the export's, while the app runs.

    Safe in this order: check the whole file; unpack it and upgrade the unpacked database to the current
    schema (an export from an older version works); only then back up the current data (kept, never
    pruned) and swap the new data in. Importing the same file again gives the same result (idempotent)."""
    archive = _export_file(paths, name)
    if strava_web is not None and strava_web.job.get("running"):
        raise DomainError("A Strava sync is running; wait until it has finished")
    info = check_export(paths, name)
    with _lock, tempfile.TemporaryDirectory() as tmp:
        try:
            db, att = extract_export(archive, Path(tmp) / "x")
        except ValueError as e:
            raise DomainError(str(e)) from e
        upgraded = _upgraded_copy(db, Path(tmp))
        safety = backup_database(paths, f"{KEPT_MARK}import")
        kept_att = copy_attachments_aside(paths, "import")
        _swap_in(factory, upgraded, paths)
        replace_attachments(paths, att)
    log.warning("Imported full export %s (schema %s → %s; backup of the data before: %s)", name,
                info["schema_revision"], head_revision(), safety.name if safety else None)
    return {"imported": name, "from_schema": info["schema_revision"], "to_schema": head_revision(),
            "counts": info["counts"], "attachments": info["attachments"],
            "backup": safety.name if safety else None, "backup_path": str(safety) if safety else None,
            "attachments_backup": kept_att.name if kept_att else None}
