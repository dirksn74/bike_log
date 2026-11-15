"""Rotate tires in one step, tire and tube moves in the bike's installation history, and 0 km instead of
"unknown" for an installation period without rides (Dirk 2026-11-15)."""
import pytest

from bikelog.services import inventory as inv
from bikelog.services import repairs, stock, worksessions
from bikelog.services.errors import DomainError

from helpers import bike, km, part, ride


def setup(session):
    b = bike(session)
    fw, rw = part(session, "FRONT_WHEEL", "F wheel"), part(session, "REAR_WHEEL", "R wheel")
    inv.install(session, fw.id, at="2026-09-01", bike_id=b.id)
    inv.install(session, rw.id, at="2026-09-01", bike_id=b.id)
    ft, rt = part(session, "TIRE", "Tire A"), part(session, "TIRE", "Tire B")
    inv.install(session, ft.id, at="2026-09-01", parent_component_id=fw.id)
    inv.install(session, rt.id, at="2026-09-01", parent_component_id=rw.id)
    ride(session, b, "2026-11-14", 80)
    return b, fw, rw, ft, rt


def tire_on(session, b, wheel):
    rows = inv.bike_setup(session, b)
    return next(r for r in rows if r["component_type"] == "TIRE" and r["parent_component_id"] == wheel.id)


def test_front_to_rear_old_rear_discarded_new_front_each_keeps_its_km(session):
    b, fw, rw, ft, rt = setup(session)
    ws = worksessions.begin(session, at="2026-11-15", bike_id=b.id, title="Rotate tires")
    text = repairs.rotate_tires(session, bike_id=b.id, move_from="FRONT_WHEEL", at="2026-11-15",
                                source={"kind": "new", "label": "Tire C", "price_cents": 4990},
                                old_outcome="DISCARDED", work_session_id=ws.id)
    assert "Tire B" in text and "Tire A" in text and "Tire C" in text
    assert tire_on(session, b, rw)["label"] == "Tire A"
    new = inv.get_component(session, tire_on(session, b, fw)["component_id"])
    assert new.label == "Tire C" and new.price_cents == 4990
    assert inv.get_component(session, rt.id).disposition == "DISCARDED"
    ride(session, b, "2026-11-16", 50)
    assert km(session, ft) == 130 and km(session, rt) == 80 and km(session, new) == 50
    # one work session: undo puts everything back
    worksessions.undo(session, ws.id)
    assert tire_on(session, b, fw)["label"] == "Tire A" and tire_on(session, b, rw)["label"] == "Tire B"
    assert km(session, rt) == 130


def test_new_tire_from_stock_and_rear_to_front(session):
    b, fw, rw, ft, rt = setup(session)
    line = stock.add_consumable(session, name="GP5000 28", component_type="TIRE", tracking_mode="COUNTED")
    stock.consumable_txn(session, line.id, kind="PURCHASE", qty=2, on="2026-11-01")
    ws = worksessions.begin(session, at="2026-11-15", bike_id=b.id)
    repairs.rotate_tires(session, bike_id=b.id, move_from="REAR_WHEEL", at="2026-11-15",
                         source={"kind": "stock", "id": line.id}, old_outcome="STORED", work_session_id=ws.id)
    assert tire_on(session, b, fw)["label"] == "Tire B"
    assert tire_on(session, b, rw)["label"] == "GP5000 28"
    assert stock.level(session, line)["qty"] == 1


def test_needs_a_tire_to_move(session):
    b, fw, rw, ft, rt = setup(session)
    inv.remove(session, ft.id, at="2026-11-15", outcome="STORED")
    with pytest.raises(DomainError):
        repairs.rotate_tires(session, bike_id=b.id, move_from="FRONT_WHEEL", at="2026-11-15",
                             source={"kind": "new"}, old_outcome=None, work_session_id=None)


def test_bike_history_lists_tire_moves_on_wheels_and_periods_without_rides_show_0_km(session):
    b, fw, rw, ft, rt = setup(session)
    inv.move(session, ft.id, at="2026-11-15T10:00", parent_component_id=rw.id, slot="TIRE", swap=True)
    hist = inv.bike_installation_history(session, b)
    tires = [h for h in hist if h["label"] in ("Tire A", "Tire B")]
    assert len(tires) == 4 and {h["on_label"] for h in tires} == {"F wheel", "R wheel"}
    assert next(h for h in hist if h["label"] == "F wheel")["on_label"] is None
    # newest first
    assert hist[0]["installed_at"] >= hist[-1]["installed_at"]
    now = inv.installation_history(session, ft)[-1]
    assert now["removed_at"] is None and now["km"] == 0


def test_rotate_over_http(engine, paths):
    from fastapi.testclient import TestClient
    from bikelog.api.app import create_app
    from bikelog.db import make_session_factory, session_scope
    from bikelog.services.reference import ensure_reference_data
    factory = make_session_factory(engine)
    with session_scope(factory) as s:
        ensure_reference_data(s)
        b, fw, rw, ft, rt = setup(s)
        bike_id = b.id
    c = TestClient(create_app(factory, paths, token="t", testing=True, static_dir=None))
    c.headers.update({"X-BikeLog-Token": "t"})
    r = c.post(f"/api/bikes/{bike_id}/rotate-tires", json={"move_from": "FRONT_WHEEL", "at": "2026-11-15",
                                                          "source": {"kind": "new"}, "old_outcome": "DISCARDED"})
    assert r.status_code == 200, r.text
    assert "Tire A" in r.json()["text"]
    hist = c.get(f"/api/bikes/{bike_id}").json()["history"]
    assert any(h["label"] == "Tire A" and h["on_label"] == "R wheel" for h in hist)
    bad = c.post(f"/api/bikes/{bike_id}/rotate-tires", json={"move_from": "SIDE", "at": "2026-11-16", "source": {"kind": "new"}})
    assert bad.status_code in (400, 422)
