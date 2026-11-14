"""Settings → Backups and export: full export (zip) and Import a full export, while the app runs."""
from __future__ import annotations

import io
import json
import sqlite3
import zipfile
from contextlib import closing

import pytest
from bikelog import backup
from bikelog.api.app import create_app
from bikelog.db import make_session_factory
from bikelog.migrate import head_revision
from bikelog.models import Bike, Ride
from bikelog.services.reference import ensure_reference_data
from fastapi.testclient import TestClient
from sqlalchemy import select

TOKEN = "t"


@pytest.fixture()
def app(engine, paths):
    factory = make_session_factory(engine)
    with factory() as s:
        ensure_reference_data(s)
        s.commit()
    c = TestClient(create_app(factory, paths, token=TOKEN, testing=True, static_dir=None))
    c.headers["X-BikeLog-Token"] = TOKEN
    return c, factory


def names(factory, model=Bike):
    with factory() as s:
        return sorted(s.scalars(select(model.name if model is Bike else model.uuid)))


def export(c) -> tuple[str, bytes]:
    name = c.post("/api/exports").json()["name"]
    r = c.get(f"/api/exports/{name}")
    assert r.status_code == 200
    return name, r.content


def upload(c, data: bytes):
    return c.post("/api/exports/upload?file_name=x.zip", content=data, headers={"Content-Type": "application/zip"})


def test_export_holds_everything_with_schema_version_checksum_and_readable_tables(app, paths):
    c, _ = app
    c.post("/api/bikes", json={"name": "TIME NXR"})
    (paths.attachments / "receipts").mkdir(parents=True)
    (paths.attachments / "receipts" / "chain.pdf").write_bytes(b"%PDF receipt")
    _, data = export(c)
    z = zipfile.ZipFile(io.BytesIO(data))
    m = json.loads(z.read("manifest.json"))
    assert m["format"] == backup.EXPORT_FORMAT and m["schema_revision"] == head_revision()
    assert m["tables"]["bike"] == 1 and m["attachments"] == 1 and len(m["database_sha256"]) == 64
    assert "Keep it private" in m["privacy"] and "Strava login" in m["privacy"]
    assert {"bikelog.db", "README.txt", "attachments/receipts/chain.pdf", "tables/bike.csv"} <= set(z.namelist())
    assert "TIME NXR" in z.read("tables/bike.csv").decode("utf-8-sig")
    assert not any(n.endswith(".part") for n in z.namelist())


def test_import_restores_the_export_backs_up_first_and_is_idempotent(app, paths):
    c, factory = app
    c.post("/api/bikes", json={"name": "Cube"})
    (paths.attachments / "a.txt").write_text("old")
    _, data = export(c)
    uuid_before = names(factory, Ride) , names(factory)

    c.post("/api/bikes", json={"name": "Added after the export"})
    (paths.attachments / "a.txt").write_text("changed")
    up = upload(c, data)
    assert up.status_code == 201, up.text
    info = up.json()
    assert info["counts"]["bikes"] == 1 and info["needs_upgrade"] is False and info["name"].endswith("-uploaded.zip")
    assert names(factory) == ["Added after the export", "Cube"]          # upload alone changes nothing

    r = c.post(f"/api/exports/{info['name']}/restore").json()
    assert names(factory) == ["Cube"]
    assert (paths.attachments / "a.txt").read_text() == "old"
    kept = paths.backups / r["backup"]
    assert kept.exists() and backup.KEPT_MARK in kept.name                 # the data from before is kept
    assert (paths.backups / r["attachments_backup"] / "a.txt").read_text() == "changed"
    with closing(sqlite3.connect(kept)) as k:
        assert k.execute("SELECT COUNT(*) FROM bike").fetchone()[0] == 2

    r2 = c.post(f"/api/exports/{info['name']}/restore")                    # same file again: same result
    assert r2.status_code == 200 and names(factory) == ["Cube"]
    assert (names(factory, Ride), names(factory)) == uuid_before
    assert c.get("/api/bikes").status_code == 200                          # the app keeps working


def test_bad_files_are_refused_and_change_nothing(app, paths):
    c, factory = app
    c.post("/api/bikes", json={"name": "Cube"})
    _, good = export(c)

    def zipped(files: dict[str, bytes]) -> bytes:
        buf = io.BytesIO()
        with zipfile.ZipFile(buf, "w") as z:
            for n, b in files.items():
                z.writestr(n, b)
        return buf.getvalue()

    src = zipfile.ZipFile(io.BytesIO(good))
    manifest = json.loads(src.read("manifest.json"))
    db = src.read("bikelog.db")
    cases = {
        "not a zip": b"hello",
        "empty": b"",
        "no database": zipped({"manifest.json": json.dumps(manifest).encode()}),
        "unsafe path": zipped({"manifest.json": json.dumps(manifest).encode(), "bikelog.db": db, "../evil.txt": b"x"}),
        "checksum": zipped({"manifest.json": json.dumps(manifest).encode(), "bikelog.db": db[:-10] + b"0" * 10}),
        "newer format": zipped({"manifest.json": json.dumps({**manifest, "format": 99}).encode(), "bikelog.db": db}),
    }
    for label, data in cases.items():
        r = upload(c, data)
        assert r.status_code == 400, label
    # a database from a newer app version (unknown schema revision)
    tmp = paths.root / "newer.db"
    tmp.write_bytes(db)
    with closing(sqlite3.connect(tmp)) as k:
        k.execute("UPDATE alembic_version SET version_num = '9999'")
        k.commit()
    newer = zipped({"manifest.json": json.dumps({**manifest, "database_sha256": None, "tables": None}).encode(),
                    "bikelog.db": tmp.read_bytes()})
    r = upload(c, newer)
    assert r.status_code == 400 and "newer Bike Log" in r.json()["detail"]
    assert names(factory) == ["Cube"]
    assert not list(paths.exports.glob("*-uploaded.zip")) and not list(paths.exports.glob("*.part"))
    assert c.post("/api/exports/nope.zip/restore").status_code == 400


def test_a_failed_upgrade_leaves_the_live_data_untouched(app, paths, monkeypatch):
    c, factory = app
    c.post("/api/bikes", json={"name": "Cube"})
    _, data = export(c)
    name = upload(c, data).json()["name"]
    c.post("/api/bikes", json={"name": "Mine now"})

    from bikelog import reset

    def boom(engine):
        raise RuntimeError("migration failed")
    monkeypatch.setattr(reset, "run_migrations", boom)
    with pytest.raises(RuntimeError):
        c.post(f"/api/exports/{name}/restore")
    assert names(factory) == ["Cube", "Mine now"]


def test_command_line_restore_reads_the_new_format(app, paths):
    c, factory = app
    c.post("/api/bikes", json={"name": "Cube"})
    name, _ = export(c)
    c.post("/api/bikes", json={"name": "Later"})
    factory.kw["bind"].dispose()
    backup.restore_archive(paths, paths.exports / name)
    with closing(sqlite3.connect(paths.database)) as k:
        assert [r[0] for r in k.execute("SELECT name FROM bike")] == ["Cube"]
