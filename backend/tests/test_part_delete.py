"""A part entered by mistake (Dirk 2026-11-15: a tire added twice) can be deleted from its page while it has
no history; with history it can only be retired. The detail says which (``deletable``)."""
import pytest
from fastapi.testclient import TestClient

from bikelog.api.app import create_app
from bikelog.db import make_session_factory, session_scope
from bikelog.services.reference import ensure_reference_data

TOKEN = "t"


@pytest.fixture()
def client(engine, paths):
    factory = make_session_factory(engine)
    with session_scope(factory) as s:
        ensure_reference_data(s)
    c = TestClient(create_app(factory, paths, token=TOKEN, testing=True, static_dir=None),
                   raise_server_exceptions=False)
    c.headers.update({"X-BikeLog-Token": TOKEN})
    return c


def test_spare_tire_added_by_mistake_can_be_deleted(client):
    r = client.post("/api/components", json={"component_type": "TIRE", "label": "GP5000 S TR 28", "prior_usage": "NEW",
                                             "price_cents": 5990, "purchase_date": "2026-11-15", "shop": "Bike24",
                                             "starting_km": 0, "starting_date": "2026-11-15"})
    assert r.status_code in (200, 201), r.text
    cid = r.json()["id"] if "id" in r.json() else r.json()[0]["id"]
    d = client.get(f"/api/components/{cid}").json()
    assert d["deletable"] is True
    assert client.delete(f"/api/components/{cid}").status_code == 200
    assert client.get(f"/api/components/{cid}").status_code == 404


def test_part_with_history_is_not_deletable(client):
    b = client.post("/api/bikes", json={"name": "B"}).json()
    r = client.post("/api/components", json={"component_type": "CHAIN", "label": "C", "prior_usage": "NEW"}).json()
    cid = r["id"] if "id" in r else r[0]["id"]
    assert client.post(f"/api/components/{cid}/install", json={"at": "2026-11-01", "bike_id": b["id"]}).status_code == 200
    assert client.get(f"/api/components/{cid}").json()["deletable"] is False
    assert client.delete(f"/api/components/{cid}").status_code in (400, 403, 409)


def test_part_with_its_own_rule_is_deleted_with_it_and_a_stored_disposition_change_blocks(client):
    r = client.post("/api/components", json={"component_type": "TIRE", "label": "X", "prior_usage": "NEW"}).json()
    cid = r["id"] if "id" in r else r[0]["id"]
    rr = client.post(f"/api/components/{cid}/rules", json={"rule_code": "TIRE_CHECK", "interval_km": 500})
    assert rr.status_code == 201, rr.text
    assert client.delete(f"/api/components/{cid}").status_code == 200
    r = client.post("/api/components", json={"component_type": "TIRE", "label": "Y", "prior_usage": "NEW"}).json()
    cid = r["id"] if "id" in r else r[0]["id"]
    assert client.post(f"/api/components/{cid}/disposition", json={"on": "2026-11-15", "disposition": "AWAITING_SERVICE"}).status_code == 200
    assert client.get(f"/api/components/{cid}").json()["deletable"] is False
