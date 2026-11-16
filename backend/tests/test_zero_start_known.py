"""A starting value of 0 km is known, never an estimate (DECISIONS 151, Dirk 2026-11-16: "it is 0")."""
import sqlite3

from alembic import command
from fastapi.testclient import TestClient
from sqlalchemy import select

from bikelog.api.app import create_app
from bikelog.db import make_engine, make_session_factory, session_scope
from bikelog.migrate import alembic_config, upgrade_database
from bikelog.models import Component, UsageAdjustment
from bikelog.paths import DataPaths
from bikelog.services.reference import ensure_reference_data
from bikelog.services.usage import bike_usage

from helpers import bike, part, ride


def _client(engine, paths):
    factory = make_session_factory(engine)
    with session_scope(factory) as s:
        ensure_reference_data(s)
    c = TestClient(create_app(factory, paths, token="t", testing=True, static_dir=None))
    c.headers.update({"X-BikeLog-Token": "t"})
    return c


def _to(engine, rev, down=False):
    cfg = alembic_config()
    with engine.begin() as conn:
        cfg.attributes["connection"] = conn
        (command.downgrade if down else command.upgrade)(cfg, rev)


def test_new_bike_with_0_km_ticked_as_estimate_is_stored_as_known(session):
    b = bike(session, starting_km=0, starting_date="2026-10-01", starting_is_estimate=True)
    ride(session, b, "2026-10-05", 100)
    u = bike_usage(session, b)
    assert u["starting_km"] == 0 and u["starting_is_estimate"] is False and u["certainty"] == "KNOWN"
    frame = session.scalar(select(Component).where(Component.component_type == "FRAME"))
    adj = session.scalar(select(UsageAdjustment).where(UsageAdjustment.component_id == frame.id))
    assert adj.km == 0 and adj.is_estimate is False


def test_a_part_with_0_km_from_before_is_known(session):
    p = part(session, "CHAIN", "Chain A", prior_usage="RECORDED", starting_km=0, starting_is_estimate=True)
    adj = session.scalar(select(UsageAdjustment).where(UsageAdjustment.component_id == p.id))
    assert adj.is_estimate is False


def test_estimate_above_0_stays_an_estimate(session):
    b = bike(session, starting_km=17000, starting_date="2026-10-01", starting_is_estimate=True)
    assert bike_usage(session, b)["starting_is_estimate"] is True


def test_changing_the_odometer_keeps_history_and_the_auto_frame_follows(engine, paths):
    c = _client(engine, paths)
    b = c.post("/api/bikes", json={"name": "TIME NXR", "starting_km": 300, "starting_date": "2026-10-01",
                                   "starting_is_estimate": True}).json()
    r = c.post(f"/api/bikes/{b['id']}/starting-usage", json={"km": 300, "effective": "2026-10-01", "is_estimate": False})
    assert r.status_code == 200, r.text
    assert r.json()["usage"]["starting_is_estimate"] is False and r.json()["usage"]["certainty"] == "KNOWN"
    # the automatic frame got the same value; the old values are voided, not deleted
    raw = sqlite3.connect(paths.database)
    rows = raw.execute("SELECT bike_id IS NOT NULL, km, is_estimate, voided_at IS NOT NULL FROM usage_adjustment "
                       "ORDER BY id").fetchall()
    raw.close()
    assert sorted(rows) == sorted([(1, 300, 1, 1), (0, 300, 1, 1), (1, 300, 0, 0), (0, 300, 0, 0)])


def test_frame_with_its_own_value_is_left_alone(engine, paths):
    c = _client(engine, paths)
    b = c.post("/api/bikes", json={"name": "TIME NXR", "starting_km": 300, "starting_date": "2026-10-01"}).json()
    raw = sqlite3.connect(paths.database)
    frame_id = raw.execute("SELECT id FROM component WHERE component_type = 'FRAME'").fetchone()[0]
    raw.close()
    c.post(f"/api/components/{frame_id}/starting-usage", json={"km": 5000, "effective": "2026-10-01"})
    c.post(f"/api/bikes/{b['id']}/starting-usage", json={"km": 0, "effective": "2026-10-01"})
    raw = sqlite3.connect(paths.database)
    km = raw.execute("SELECT km FROM usage_adjustment WHERE component_id = ? AND voided_at IS NULL", (frame_id,)).fetchone()
    raw.close()
    assert km == (5000,)


def test_upgrade_to_0025_marks_0_km_estimates_known_and_downgrade_puts_them_back(tmp_path):
    paths = DataPaths(tmp_path / "d").ensure()
    eng = make_engine(paths.database)
    _to(eng, "0024")
    raw = sqlite3.connect(paths.database)
    raw.executescript("""
        INSERT INTO bike (id, uuid, name, status, created_at, updated_at) VALUES (1, 'b-1', 'TIME NXR', 'ACTIVE', 'x', 'x');
        INSERT INTO component (id, uuid, component_type, label, prior_usage, status, created_at, updated_at)
            VALUES (1, 'c-1', 'FRAME', 'TIME NXR frame', 'RECORDED', 'ACTIVE', 'x', 'x');
        INSERT INTO usage_adjustment (uuid, bike_id, component_id, kind, effective_at, effective_utc, km, is_estimate,
                                      note, voided_at, created_at) VALUES
            ('a-1', 1, NULL, 'STARTING', '2026-10-01', '2026-09-30T22:00:00Z', 0, 1, NULL, NULL, 'x'),
            ('a-2', NULL, 1, 'STARTING', '2026-10-01', '2026-09-30T22:00:00Z', 0, 1, 'from TIME NXR''s starting km', NULL, 'x'),
            ('a-3', 1, NULL, 'STARTING', '2026-09-01', '2026-08-31T22:00:00Z', 0, 1, NULL, '2026-10-01T00:00:00Z', 'x'),
            ('a-4', NULL, 1, 'STARTING', '2026-10-01', '2026-09-30T22:00:00Z', 1200, 1, NULL, NULL, 'x');
    """)
    raw.commit()
    raw.close()
    upgrade_database(eng, paths)
    q = "SELECT uuid, km, is_estimate, note FROM usage_adjustment ORDER BY uuid"
    raw = sqlite3.connect(paths.database)
    after = raw.execute(q).fetchall()
    raw.close()
    mark = "[0 km marked known by update 0025]"
    assert after == [("a-1", 0, 0, mark), ("a-2", 0, 0, "from TIME NXR's starting km " + mark),
                     ("a-3", 0, 1, None),          # voided history: untouched
                     ("a-4", 1200, 1, None)]       # a real estimate: untouched
    _to(eng, "0024", down=True)
    raw = sqlite3.connect(paths.database)
    back = raw.execute(q).fetchall()
    raw.close()
    assert back == [("a-1", 0, 1, None), ("a-2", 0, 1, "from TIME NXR's starting km"), ("a-3", 0, 1, None),
                    ("a-4", 1200, 1, None)]
