"""Existing data is production data: databases made by OLDER Bike Log versions must upgrade without loss.

Each file in fixtures/upgrade/ is a database written by an older version's own code
(scripts/make_upgrade_fixture.py). For each one this test upgrades it with today's migrations, the way
the app does at start, and checks:

* every row and every stable id (uuid) is still there, in every table that existed before;
* the database is sound (integrity check, no broken references);
* the km each part had stays the same after all totals are rebuilt from the rides;
* the app opens and shows the data (overview, bikes, parts).

The same files also go through Settings → Restore (an older backup) and Import (an older full export).
"""
from __future__ import annotations

import json
import sqlite3
import zipfile
from contextlib import closing
from pathlib import Path

import pytest
from bikelog import launcher, reset
from bikelog.api.app import create_app
from bikelog.db import make_session_factory, session_scope
from bikelog.migrate import head_revision, upgrade_database
from bikelog.paths import DataPaths
from bikelog.services.rebuild import rebuild_everything
from fastapi.testclient import TestClient

FIXTURES = sorted((Path(__file__).parent / "fixtures" / "upgrade").glob("*.sql"))
TOKEN = "t"

# Tables a migration deliberately replaced; key = old table, value = where its rows went.
RENAMED: dict[str, str] = {}


def intentional_drops(c: sqlite3.Connection) -> dict[str, dict]:
    """Rows the app removes on purpose at start, with the reason in DECISIONS. Nothing a person entered.
    * DECISIONS 98: fork parts that commit 9842a2a added automatically (frame and fork are one part);
      frames.drop_auto_forks removes them only when nothing of the person's own is attached."""
    from bikelog.services.frames import AUTO_NOTE
    forks = c.execute("SELECT c.id, c.uuid FROM component c JOIN installation i ON i.component_id = c.id "
                      "WHERE c.component_type = 'FORK' AND i.note = ? AND c.notes IS NULL AND c.price_cents IS NULL "
                      "AND (SELECT COUNT(*) FROM installation j WHERE j.component_id = c.id) = 1", (AUTO_NOTE,)).fetchall()
    ids = ",".join(str(i) for i, _ in forks) or "0"
    return {
        "component": {"uuids": {u for _, u in forks}, "n": len(forks)},
        "installation": {"uuids": {r[0] for r in c.execute(f"SELECT uuid FROM installation WHERE component_id IN ({ids})")},
                         "n": c.execute(f"SELECT COUNT(*) FROM installation WHERE component_id IN ({ids})").fetchone()[0]},
        "usage_contribution": {"uuids": set(), "n": c.execute(
            f"SELECT COUNT(*) FROM usage_contribution WHERE component_id IN ({ids})").fetchone()[0]},
        "usage_adjustment": {"uuids": {r[0] for r in c.execute(f"SELECT uuid FROM usage_adjustment WHERE component_id IN ({ids})")},
                             "n": c.execute(f"SELECT COUNT(*) FROM usage_adjustment WHERE component_id IN ({ids})").fetchone()[0]},
    }


def load_fixture(fixture: Path, db: Path) -> str:
    db.parent.mkdir(parents=True, exist_ok=True)
    with closing(sqlite3.connect(db)) as c:
        c.executescript(fixture.read_text(encoding="utf-8"))
        return c.execute("SELECT version_num FROM alembic_version").fetchone()[0]


def snapshot(db: Path) -> dict:
    """Row counts and uuids per table, and the counted km per part (from the stored ride ledger)."""
    with closing(sqlite3.connect(db)) as c:
        tables = [r[0] for r in c.execute("SELECT name FROM sqlite_master WHERE type = 'table' "
                                          "AND name NOT LIKE 'sqlite_%' AND name <> 'alembic_version'")]
        out = {"counts": {}, "uuids": {}}
        for t in tables:
            out["counts"][t] = c.execute(f'SELECT COUNT(*) FROM "{t}"').fetchone()[0]
            cols = [r[1] for r in c.execute(f'PRAGMA table_info("{t}")')]
            if "uuid" in cols:
                out["uuids"][t] = {r[0] for r in c.execute(f'SELECT uuid FROM "{t}"')}
        out["km"] = dict(c.execute("SELECT c.uuid, ROUND(COALESCE(SUM(u.km), 0), 3) FROM component c "
                                   "LEFT JOIN usage_contribution u ON u.component_id = c.id AND u.state = 'COUNTED' "
                                   "GROUP BY c.uuid"))
        out["dropped"] = intentional_drops(c) if "component" in tables else {}
        out["integrity"] = c.execute("PRAGMA integrity_check").fetchone()[0]
        out["broken_refs"] = c.execute("PRAGMA foreign_key_check").fetchall()
    return out


def assert_nothing_lost(before: dict, after: dict, where: str) -> None:
    assert after["integrity"] == "ok", where
    assert after["broken_refs"] == [], where
    drops = before.get("dropped", {})
    for table, n in before["counts"].items():
        target = RENAMED.get(table, table)
        assert target in after["counts"], f"{where}: table {table} disappeared"
        n -= drops.get(table, {}).get("n", 0)
        assert after["counts"][target] >= n, f"{where}: {table} had {n} rows, now {after['counts'][target]}"
    for table, ids in before["uuids"].items():
        ids = ids - drops.get(table, {}).get("uuids", set())
        missing = ids - after["uuids"].get(RENAMED.get(table, table), set())
        assert not missing, f"{where}: {table} lost {len(missing)} records, e.g. {sorted(missing)[:3]}"


def assert_same_km(before: dict, after: dict, where: str) -> None:
    gone = before.get("dropped", {}).get("component", {}).get("uuids", set())
    changed = {u: (km, after["km"].get(u)) for u, km in before["km"].items()
               if u not in gone and after["km"].get(u) != km}
    assert not changed, f"{where}: km per part changed after the upgrade: {list(changed.items())[:5]}"


def assert_app_shows_it(paths: DataPaths, factory) -> None:
    c = TestClient(create_app(factory, paths, token=TOKEN, testing=True, static_dir=None))
    c.headers["X-BikeLog-Token"] = TOKEN
    assert c.get("/api/overview").status_code == 200
    bikes = c.get("/api/bikes").json()
    assert bikes, "no bikes after the upgrade"
    for b in bikes:
        assert c.get(f"/api/bikes/{b['id']}").status_code == 200
    comps = c.get("/api/components").json()
    for comp in comps[:40]:
        assert c.get(f"/api/components/{comp['id']}").status_code == 200


def test_there_are_fixtures_from_older_versions():
    assert len(FIXTURES) >= 3


@pytest.mark.parametrize("fixture", FIXTURES, ids=[f.stem for f in FIXTURES])
def test_start_of_new_version_upgrades_older_database_without_loss(fixture, tmp_path):
    paths = DataPaths(tmp_path / "d").ensure()
    rev = load_fixture(fixture, paths.database)
    before = snapshot(paths.database)

    engine, factory, info = launcher.prepare(paths)      # exactly what the app does when it starts
    try:
        assert info["from"] == rev and info["to"] == head_revision()
        if rev != head_revision():
            assert info["backup"] and (paths.backups / info["backup"]).exists()   # backup before the change
        after = snapshot(paths.database)
        assert_nothing_lost(before, after, fixture.stem)

        with session_scope(factory) as s:                # cached totals are rebuildable: same km per part
            rebuild_everything(s)
        assert_same_km(before, snapshot(paths.database), fixture.stem)
        assert_app_shows_it(paths, factory)
        assert upgrade_database(engine, paths)["backup"] is None     # second start: nothing to do
    finally:
        engine.dispose()


@pytest.mark.parametrize("fixture", FIXTURES, ids=[f.stem for f in FIXTURES])
def test_restore_of_an_older_backup_upgrades_it_without_loss(fixture, tmp_path, engine, paths):
    old = tmp_path / "old" / "bikelog.db"
    load_fixture(fixture, old)
    before = snapshot(old)
    name = "bikelog-20260101T000000Z-uploaded.db"
    (paths.backups / name).write_bytes(old.read_bytes())

    factory = make_session_factory(engine)
    res = reset.restore_backup(factory, paths, name)
    assert res["backup"]
    after = snapshot(paths.database)
    assert_nothing_lost(before, after, fixture.stem)
    assert_app_shows_it(paths, factory)


def old_export_zip(db: Path, dest: Path, revision: str) -> Path:
    """A full export as the older versions wrote it (format 1: manifest + database + attachments)."""
    with zipfile.ZipFile(dest, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("manifest.json", json.dumps({"format": 1, "app_version": "0.2.0", "schema_revision": revision,
                                                "created_at": "2026-10-26T10:00:00Z"}))
        z.write(db, "bikelog.db")
        z.writestr("attachments/receipts/r1.txt", "receipt")
    return dest


@pytest.mark.parametrize("fixture", FIXTURES, ids=[f.stem for f in FIXTURES])
def test_import_of_an_older_full_export_upgrades_it_without_loss(fixture, tmp_path, engine, paths):
    old = tmp_path / "old" / "bikelog.db"
    rev = load_fixture(fixture, old)
    before = snapshot(old)
    archive = old_export_zip(old, tmp_path / "old-export.zip", rev)

    factory = make_session_factory(engine)
    c = TestClient(create_app(factory, paths, token=TOKEN, testing=True, static_dir=None))
    c.headers["X-BikeLog-Token"] = TOKEN
    up = c.post("/api/exports/upload?file_name=old-export.zip", content=archive.read_bytes(),
                headers={"Content-Type": "application/zip"})
    assert up.status_code == 201, up.text
    info = up.json()
    assert info["schema_revision"] == rev and info["needs_upgrade"] == (rev != head_revision())
    r = c.post(f"/api/exports/{info['name']}/restore")
    assert r.status_code == 200, r.text
    after = snapshot(paths.database)
    assert_nothing_lost(before, after, fixture.stem)
    assert (paths.attachments / "receipts" / "r1.txt").read_text() == "receipt"
    assert_app_shows_it(paths, factory)
