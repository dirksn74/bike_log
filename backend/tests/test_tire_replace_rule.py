"""Tires are replaced by their own total km (Dirk 2026-11-15: "a tire lasts 6000km", DECISIONS 150).

The TIRE_REPLACE rule (trigger LIFETIME) counts each physical tire's own km on every wheel and bike, km from
before included; logging work (an inspection) does not reset it; a new tire starts at 0."""
import sqlite3

from alembic import command

from bikelog.migrate import alembic_config
from bikelog.models import ServiceRule
from bikelog.services import inventory as inv
from bikelog.services import maintenance as m
from bikelog.services.errors import DomainError

from helpers import bike, part, ride

import pytest


def setup(session):
    b = bike(session)
    fw, rw = part(session, "FRONT_WHEEL", "F wheel"), part(session, "REAR_WHEEL", "R wheel")
    inv.install(session, fw.id, at="2026-01-01", bike_id=b.id)
    inv.install(session, rw.id, at="2026-01-01", bike_id=b.id)
    ft, rt = part(session, "TIRE", "Tire A"), part(session, "TIRE", "Tire B")
    inv.install(session, ft.id, at="2026-01-01", parent_component_id=fw.id)
    inv.install(session, rt.id, at="2026-01-01", parent_component_id=rw.id)
    return b, fw, rw, ft, rt


def row(session, comp, today=None):
    session.flush()
    return next(r for r in m.component_status(session, comp, today) if r["rule_code"] == "TIRE_REPLACE")


def test_default_rule_is_6000_km_and_not_reset_by_anything_logged(session):
    rule = session.query(ServiceRule).filter_by(component_type="TIRE", rule_code="TIRE_REPLACE").one()
    assert rule.trigger == "LIFETIME" and rule.interval_km == 6000
    assert m.rule_row(rule)["reset_actions"] == []


def test_counts_each_tires_own_km_across_a_front_rear_swap(session):
    b, fw, rw, ft, rt = setup(session)
    ride(session, b, "2026-03-01", 3000)
    inv.move(session, ft.id, at="2026-04-01T10:00", parent_component_id=rw.id, slot="TIRE", swap=True)
    ride(session, b, "2026-05-01", 2700)
    r = row(session, ft)
    assert r["used_km"] == 5700 and r["remaining_km"] == 300 and r["status"] == "DUE_SOON"
    assert "6,000" in r["explanation"] and "300 km left" in r["explanation"]
    assert "km do not say it is safe" in r["explanation"]
    ride(session, b, "2026-06-01", 400)
    assert row(session, ft)["status"] == "DUE" and row(session, rt)["used_km"] == 6100
    # shown in the bike's service queue
    q = [x for x in m.queue(session, bike_id=b.id) if x["rule_code"] == "TIRE_REPLACE"]
    assert {x["component"] for x in q} == {"Tire A", "Tire B"}


def test_inspection_is_quoted_but_does_not_reset(session):
    b, fw, rw, ft, rt = setup(session)
    ride(session, b, "2026-03-01", 5800)
    m.log_event(session, action_code="TIRE_INSPECT", at="2026-03-02", component_id=ft.id, outcome="OK")
    r = row(session, ft)
    assert r["used_km"] == 5800 and r["status"] == "DUE_SOON"
    assert "Last inspection 2026-03-02: ok" in r["explanation"]


def test_replacing_the_tire_starts_the_new_one_at_0_and_old_one_leaves_the_queue(session):
    b, fw, rw, ft, rt = setup(session)
    ride(session, b, "2026-03-01", 6200)
    assert row(session, ft)["status"] == "DUE"
    out = inv.replace(session, ft.id, at="2026-03-05", new={"label": "Tire C"}, old_outcome="DISCARDED")
    new = inv.get_component(session, out["new_component_id"])
    assert row(session, new)["used_km"] == 0 and row(session, new)["status"] == "OK"
    q = [x for x in m.queue(session, bike_id=b.id) if x["rule_code"] == "TIRE_REPLACE" and x["status"] == "DUE"]
    assert [x["component"] for x in q] == ["Tire B"]


def test_km_from_before_count_and_unknown_history_is_not_shown_as_fine(session):
    b, fw, rw, ft, rt = setup(session)
    used = part(session, "TIRE", "Old tire", prior_usage="UNKNOWN")
    assert row(session, used)["status"] == "INSUFFICIENT_INFO"
    inv.set_starting_usage(session, km=5600, effective="2026-01-01", is_estimate=True, component_id=used.id)
    r = row(session, used)
    assert r["used_km"] == 5600 and r["status"] == "DUE_SOON" and "from before" in r["explanation"]


def test_own_value_per_part_and_validation(session):
    b, fw, rw, ft, rt = setup(session)
    ride(session, b, "2026-03-01", 4000)
    m.set_component_rule(session, ft.id, rule_code="TIRE_REPLACE", interval_km=4000)
    assert row(session, ft)["status"] == "DUE" and row(session, rt)["status"] == "OK"
    with pytest.raises(DomainError):
        m.set_component_rule(session, rt.id, rule_code="TIRE_REPLACE", interval_km=None)


def test_migration_keeps_every_rule_and_index_and_downgrades(engine, paths):
    db = str(paths.database)
    with sqlite3.connect(db) as c:
        before = c.execute("SELECT id, uuid, rule_code FROM service_rule ORDER BY id").fetchall()
        idx = c.execute("SELECT name, sql FROM sqlite_master WHERE tbl_name = 'service_rule' "
                        "AND type IN ('index', 'trigger') ORDER BY name").fetchall()
    with engine.connect() as conn:
        conn.exec_driver_sql("PRAGMA foreign_keys = OFF")
        cfg = alembic_config()
        cfg.attributes["connection"] = conn
        command.downgrade(cfg, "0023")
        command.upgrade(cfg, "head")
        conn.commit()
    with sqlite3.connect(db) as c:
        assert c.execute("SELECT id, uuid, rule_code FROM service_rule ORDER BY id").fetchall() == before
        assert c.execute("SELECT name, sql FROM sqlite_master WHERE tbl_name = 'service_rule' "
                         "AND type IN ('index', 'trigger') ORDER BY name").fetchall() == idx
        sql = c.execute("SELECT sql FROM sqlite_master WHERE name = 'service_rule'").fetchone()[0]
        assert "'LIFETIME'" in sql and "ck_rule_lifetime" in sql
