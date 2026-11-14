"""Backups, export and restore.

* Backups are consistent SQLite snapshots (online backup API), safe while the app runs.
* An export is a zip with manifest.json, the database snapshot and all attachments,
  so it can be restored on another machine. Stable IDs (uuid columns) travel with it.
* Import (Settings → Import a full export, reset.restore_export) checks the archive completely, backs up the
  current data first, upgrades an older export to the current schema, then swaps the data in while the app
  runs. The command line restore (launcher --restore) does the same with the app closed.
"""
from __future__ import annotations

import csv
import hashlib
import io
import json
import logging
import shutil
import sqlite3
import tempfile
import zipfile
from contextlib import closing
from datetime import UTC, datetime
from pathlib import Path

from bikelog import __version__, buildinfo
from bikelog.paths import DataPaths

log = logging.getLogger(__name__)

EXPORT_FORMAT = 2          # 2 (2026-11-14): + checksum, row counts, CSV copy, README
READABLE_FORMATS = (1, 2)  # an import reads every format ever written
KEEP_AUTO_BACKUPS = 10
KEPT_MARK = "kept-before-"   # backups with this in the name (fresh start, restore) are never pruned


def _stamp() -> str:
    return datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")


def _free(path: Path) -> Path:
    """The path, or path-2, path-3 ... when one with that name exists already (two backups in one second)."""
    n, candidate = 2, path
    while candidate.exists():
        candidate = path.with_name(f"{path.stem}-{n}{path.suffix}") if path.suffix else path.with_name(f"{path.name}-{n}")
        n += 1
    return candidate


def snapshot_database(src: Path, dest: Path) -> Path:
    dest.parent.mkdir(parents=True, exist_ok=True)
    # sqlite3's own context manager does not close connections; an open handle would keep -wal/-shm alive
    with closing(sqlite3.connect(src)) as s, closing(sqlite3.connect(dest)) as d:
        s.backup(d)
    with closing(sqlite3.connect(dest)) as d:
        d.execute("PRAGMA journal_mode = DELETE")  # self-contained single file, no -wal needed to read it
        ok = d.execute("PRAGMA integrity_check").fetchone()[0]
    if ok != "ok":
        raise RuntimeError(f"Backup integrity check failed for {dest}: {ok}")
    return dest


def backup_database(paths: DataPaths, reason: str) -> Path | None:
    """Snapshot the live database into backups/. Returns None if there is no database yet."""
    if not paths.database.exists():
        return None
    dest = _free(paths.backups / f"bikelog-{_stamp()}-{reason}.db")
    snapshot_database(paths.database, dest)
    log.info("Database backup written: %s", dest.name)
    prune_backups(paths)
    return dest


def prune_backups(paths: DataPaths, keep: int = KEEP_AUTO_BACKUPS) -> None:
    files = sorted((p for p in paths.backups.glob("bikelog-*.db") if KEPT_MARK not in p.name),
                   key=lambda p: p.name, reverse=True)
    for old in files[keep:]:
        old.unlink(missing_ok=True)


MAX_UPLOAD_BYTES = 1024 * 1024 * 1024


def store_uploaded_backup(paths: DataPaths, data: bytes, file_name: str | None = None) -> dict:
    """Save an uploaded database backup into backups/ after checking it is a sound SQLite database with a
    Bike Log schema. Restoring it is a separate step (reset.restore_backup), which writes a safety backup first."""
    from bikelog.services.errors import DomainError
    if not data:
        raise DomainError("The file is empty")
    if len(data) > MAX_UPLOAD_BYTES:
        raise DomainError("The file is larger than 1 GB; that is not a Bike Log backup")
    if not data.startswith(b"SQLite format 3\x00"):
        raise DomainError("This is not a Bike Log backup file (pick a bikelog-....db file)")
    dest = paths.backups / f"bikelog-{_stamp()}-uploaded.db"
    paths.backups.mkdir(parents=True, exist_ok=True)
    tmp = dest.with_suffix(".part")
    tmp.write_bytes(data)
    try:
        with closing(sqlite3.connect(f"file:{tmp.as_posix()}?mode=ro", uri=True)) as c:
            ok = c.execute("PRAGMA integrity_check").fetchone()[0] == "ok"
            has_schema = c.execute("SELECT 1 FROM sqlite_master WHERE name = 'alembic_version'").fetchone()
    except sqlite3.DatabaseError:
        ok, has_schema = False, None
    if not ok or not has_schema:
        tmp.unlink(missing_ok=True)
        raise DomainError("This file is damaged or not a Bike Log database")
    tmp.replace(dest)
    log.info("Backup uploaded%s: %s", f" from {file_name}" if file_name else "", dest.name)
    return {"name": dest.name, "size": len(data)}


# What a person sees about an export before restoring it (table name -> label).
SUMMARY_TABLES = {"bike": "bikes", "component": "parts", "ride": "rides", "maintenance_event": "maintenance entries",
                  "consumable": "supplies", "journal_entry": "journal entries"}
PRIVACY_NOTE = ("This file holds ALL your Bike Log data: bikes, parts, rides, work done, prices, serial numbers, "
                "receipts and other attachments, and ride details such as Strava ids. Keep it private. Strava login "
                "details are NOT in it (after restoring on another computer, connect Strava again).")
README = """Bike Log full export
====================

What is in this zip
  manifest.json   when, by which app version, which database schema (schema_revision), row counts, checksum
  bikelog.db      the whole database (SQLite). This is what Settings -> Import full export restores.
  attachments/    receipts and other files you attached
  tables/*.csv    a readable copy of every table (open with Excel or any text editor). Only for reading;
                  the import uses bikelog.db.

Every record keeps its stable id (the uuid column), so the same record has the same id after a restore.

Restore: Bike Log -> Settings -> Backups and export -> Import a full export. Your current data is backed up
first, and an export from an older Bike Log version is upgraded to the current one.

{privacy}
"""


def _sha256(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for block in iter(lambda: f.read(1 << 20), b""):
            h.update(block)
    return h.hexdigest()


def _table_counts(db: Path) -> dict[str, int]:
    with closing(sqlite3.connect(f"file:{db.as_posix()}?mode=ro", uri=True)) as c:
        names = [r[0] for r in c.execute("SELECT name FROM sqlite_master WHERE type = 'table' "
                                         "AND name NOT LIKE 'sqlite_%' ORDER BY name")]
        return {n: c.execute(f'SELECT COUNT(*) FROM "{n}"').fetchone()[0] for n in names}


def _write_table_csvs(db: Path, z: zipfile.ZipFile) -> None:
    with closing(sqlite3.connect(f"file:{db.as_posix()}?mode=ro", uri=True)) as c:
        names = [r[0] for r in c.execute("SELECT name FROM sqlite_master WHERE type = 'table' "
                                         "AND name NOT LIKE 'sqlite_%' ORDER BY name")]
        for n in names:
            cur = c.execute(f'SELECT * FROM "{n}"')
            buf = io.StringIO()
            w = csv.writer(buf)
            w.writerow([d[0] for d in cur.description])
            for row in cur:
                w.writerow(["" if v is None else (v.hex() if isinstance(v, bytes) else v) for v in row])
            z.writestr(f"tables/{n}.csv", "\ufeff" + buf.getvalue())   # BOM: Excel reads umlauts right


def export_archive(paths: DataPaths, schema_revision: str | None, dest: Path | None = None) -> Path:
    """Full export: manifest, the whole database, attachments, and a readable CSV copy of every table."""
    dest = dest or _free(paths.exports / f"bikelog-export-{_stamp()}.zip")
    dest.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        snap = snapshot_database(paths.database, Path(tmp) / "bikelog.db")
        attachments = [f for f in sorted(paths.attachments.rglob("*")) if f.is_file()] if paths.attachments.exists() else []
        manifest = {
            "format": EXPORT_FORMAT,
            "app_version": __version__, "app_build": buildinfo.full_version(),
            "schema_revision": schema_revision,
            "created_at": datetime.now(UTC).strftime("%Y-%m-%dT%H:%M:%SZ"),
            "database_sha256": _sha256(snap),
            "tables": _table_counts(snap),
            "attachments": len(attachments),
            "privacy": PRIVACY_NOTE,
        }
        part = dest.with_name(dest.name + ".part")
        with zipfile.ZipFile(part, "w", zipfile.ZIP_DEFLATED) as z:
            z.writestr("manifest.json", json.dumps(manifest, indent=2))
            z.writestr("README.txt", README.format(privacy=PRIVACY_NOTE))
            z.write(snap, "bikelog.db")
            for f in attachments:
                z.write(f, "attachments/" + f.relative_to(paths.attachments).as_posix())
            _write_table_csvs(snap, z)
        part.replace(dest)            # a half-written zip never shows up in the list
    log.info("Export written: %s", dest.name)
    return dest


MAX_EXPORT_BYTES = 2 * 1024 * 1024 * 1024      # upload limit for an export zip
MAX_UNPACKED_BYTES = 8 * 1024 * 1024 * 1024    # refuses zip bombs


def read_manifest(archive: Path) -> dict:
    """Open the zip and check its shape (no database checks; see inspect_archive)."""
    try:
        z = zipfile.ZipFile(archive)
    except (zipfile.BadZipFile, OSError) as e:
        raise ValueError("This is not a Bike Log export (not a zip file)") from e
    with z:
        names = set(z.namelist())
        if "manifest.json" not in names or "bikelog.db" not in names:
            raise ValueError("Not a Bike Log export: manifest.json or bikelog.db missing")
        for n in names:  # refuse path traversal
            if n.startswith(("/", "\\")) or ".." in Path(n.replace("\\", "/")).parts or ":" in n:
                raise ValueError(f"Unsafe path in archive: {n}")
        if sum(i.file_size for i in z.infolist()) > MAX_UNPACKED_BYTES:
            raise ValueError("The export unpacks to more than 8 GB; that is not a Bike Log export")
        try:
            manifest = json.loads(z.read("manifest.json"))
        except ValueError as e:
            raise ValueError("The export's manifest.json is damaged") from e
    if not isinstance(manifest, dict) or manifest.get("format") not in READABLE_FORMATS:
        fmt = manifest.get("format") if isinstance(manifest, dict) else None
        if isinstance(fmt, int) and fmt > EXPORT_FORMAT:
            raise ValueError("This export comes from a newer Bike Log. Install the newer version first.")
        raise ValueError(f"Unsupported export format {fmt}")
    return manifest


def extract_export(archive: Path, dest: Path) -> tuple[Path, Path | None]:
    """Unpack only the database and attachments (never the CSV copies). Returns (database, attachments dir)."""
    read_manifest(archive)
    with zipfile.ZipFile(archive) as z:
        for info in z.infolist():
            if info.is_dir() or not (info.filename == "bikelog.db" or info.filename.startswith("attachments/")):
                continue
            target = (dest / info.filename).resolve()
            if dest.resolve() not in target.parents:
                raise ValueError(f"Unsafe path in archive: {info.filename}")
            target.parent.mkdir(parents=True, exist_ok=True)
            with z.open(info) as src, open(target, "wb") as out:
                shutil.copyfileobj(src, out)
    att = dest / "attachments"
    return dest / "bikelog.db", (att if att.exists() else None)


def inspect_archive(archive: Path, known_revisions: set[str] | None = None, head: str | None = None) -> dict:
    """Check everything an import needs, without changing anything. Raises ValueError with a plain reason.
    Returns what the export holds, for the person to look at before restoring."""
    manifest = read_manifest(archive)
    with tempfile.TemporaryDirectory() as tmp:
        db, att = extract_export(archive, Path(tmp))
        want = manifest.get("database_sha256")
        if want and _sha256(db) != want:
            raise ValueError("The database in this export does not match its checksum; the file is damaged")
        try:
            with closing(sqlite3.connect(f"file:{db.as_posix()}?mode=ro", uri=True)) as c:
                if c.execute("PRAGMA integrity_check").fetchone()[0] != "ok":
                    raise ValueError("The database in this export is damaged (integrity check failed)")
                row = c.execute("SELECT version_num FROM alembic_version").fetchone()
        except sqlite3.DatabaseError as e:
            raise ValueError("The database in this export is damaged or not a Bike Log database") from e
        revision = row[0] if row else None
        if revision is None:
            raise ValueError("The database in this export has no schema version; it is not a Bike Log database")
        if known_revisions is not None and revision not in known_revisions:
            raise ValueError(f"This export was made by a newer Bike Log (database schema {revision}). "
                             "Install the newer version first.")
        counts = _table_counts(db)
        if manifest.get("tables"):
            off = {t: (n, counts.get(t)) for t, n in manifest["tables"].items() if counts.get(t) != n}
            if off:
                raise ValueError(f"The export is incomplete: row counts differ from its manifest ({len(off)} tables)")
        n_att = sum(1 for f in att.rglob("*") if f.is_file()) if att else 0
    return {
        "name": archive.name,
        "format": manifest.get("format"),
        "created_at": manifest.get("created_at"),
        "app_version": manifest.get("app_version"),
        "schema_revision": revision,
        "needs_upgrade": head is not None and revision != head,
        "counts": {label: counts.get(t, 0) for t, label in SUMMARY_TABLES.items()},
        "attachments": n_att,
        "privacy": PRIVACY_NOTE,
    }


def store_uploaded_export(paths: DataPaths, data: bytes, file_name: str | None = None,
                          known_revisions: set[str] | None = None, head: str | None = None) -> dict:
    """Save an uploaded full export into exports/ after checking it completely. Restoring it is a separate
    step (reset.restore_export), which backs up the current data first."""
    from bikelog.services.errors import DomainError
    if not data:
        raise DomainError("The file is empty")
    if len(data) > MAX_EXPORT_BYTES:
        raise DomainError("The file is larger than 2 GB; that is not a Bike Log export")
    if not data.startswith(b"PK"):
        raise DomainError("This is not a Bike Log full export (pick a bikelog-export-....zip file)")
    paths.exports.mkdir(parents=True, exist_ok=True)
    dest = _free(paths.exports / f"bikelog-export-{_stamp()}-uploaded.zip")
    tmp = dest.with_name(dest.name + ".part")
    tmp.write_bytes(data)
    try:
        info = inspect_archive(tmp, known_revisions, head)
    except ValueError as e:
        tmp.unlink(missing_ok=True)
        raise DomainError(str(e)) from e
    tmp.replace(dest)
    log.info("Export uploaded%s: %s", f" from {file_name}" if file_name else "", dest.name)
    return {**info, "name": dest.name, "size": len(data)}


def copy_attachments_aside(paths: DataPaths, reason: str) -> Path | None:
    """Keep a copy of the current attachments in backups/ (never pruned) before they are replaced."""
    if not paths.attachments.exists() or not any(paths.attachments.rglob("*")):
        return None
    dest = _free(paths.backups / f"attachments-{_stamp()}-{KEPT_MARK}{reason}")
    shutil.copytree(paths.attachments, dest)
    return dest


def replace_attachments(paths: DataPaths, src: Path | None) -> None:
    if paths.attachments.exists():
        shutil.rmtree(paths.attachments)
    if src is not None and src.exists():
        shutil.copytree(src, paths.attachments)
    else:
        paths.attachments.mkdir(parents=True, exist_ok=True)


def restore_archive(paths: DataPaths, archive: Path) -> dict:
    """Command line restore (launcher --restore, app closed): replace database and attachments with the
    archive's. The next start upgrades an older database. Settings → Import uses reset.restore_export."""
    from bikelog.migrate import head_revision, known_revisions
    inspect_archive(archive, known_revisions(), head_revision())
    manifest = read_manifest(archive)
    safety = backup_database(paths, f"{KEPT_MARK}restore")
    copy_attachments_aside(paths, "restore")
    with tempfile.TemporaryDirectory() as tmp:
        db, att = extract_export(archive, Path(tmp))
        for suffix in ("-wal", "-shm"):
            Path(str(paths.database) + suffix).unlink(missing_ok=True)
        paths.database.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(db, paths.database)
        replace_attachments(paths, att)
    log.info("Restored export from %s (safety backup: %s)", archive.name, safety.name if safety else "none")
    return manifest
