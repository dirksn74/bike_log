"""Several identical spares in one go (Dirk 2026-11-15: "enter 15 inner tubes into the inventory in one go").
Each is its own part: own id, own km, own history; nothing is summed per product."""
import pytest
from fastapi.testclient import TestClient

from bikelog.api.app import create_app
from bikelog.db import make_session_factory, session_scope
from bikelog.services import inventory as inv
from bikelog.services import stock
from bikelog.services.errors import DomainError
from bikelog.services.reference import ensure_reference_data

TOKEN = "test-token"


@pytest.fixture()
def client(engine, paths):
    factory = make_session_factory(engine)
    with session_scope(factory) as s:
        ensure_reference_data(s)
    c = TestClient(create_app(factory, paths, token=TOKEN, testing=True, static_dir=None))
    c.headers.update({"X-BikeLog-Token": TOKEN})
    return c


def test_fifteen_tubes_with_total_price(client):
    r = client.post("/api/components", json={
        "component_type": "INNER_TUBE", "label": "Conti Race 28", "prior_usage": "NEW", "quantity": 15,
        "price_is_total": True, "price_cents": 10000, "purchase_date": "2026-11-15", "shop": "Bike shop"},
        headers={"X-Client-Op-Id": "tubes-1"})
    assert r.status_code == 201, r.text
    created = r.json()["created"]
    assert len(created) == 15 and len({c["id"] for c in created}) == 15
    assert {c["label"] for c in created} == {"Conti Race 28"}          # tubes share the name
    parts = [client.get(f"/api/components/{c['id']}").json() for c in created]
    prices = [p["price_cents"] for p in parts]
    assert sum(prices) == 10000 and set(prices) == {666, 667}          # 100 € split, remainder on the first ones
    assert all(p["purchase_date"] == "2026-11-15" and p["shop"] == "Bike shop" for p in parts)
    assert all(p["location"]["state"] == "STORED" for p in parts)
    # a retry of the same submit makes nothing new
    again = client.post("/api/components", json={
        "component_type": "INNER_TUBE", "label": "Conti Race 28", "quantity": 15}, headers={"X-Client-Op-Id": "tubes-1"})
    assert again.json()["repeated"]
    tubes = client.get("/api/components", params={"component_type": "INNER_TUBE"}).json()
    assert len(tubes) == 15


def test_price_per_piece_and_names(session):
    ensure_reference_data(session)
    chains = inv.create_components(session, quantity=3, component_type="CHAIN", label="KMC X12", price_cents=3000)
    assert [c.price_cents for c in chains] == [3000, 3000, 3000]
    assert sorted(c.mark for c in chains) == ["A", "B", "C"]           # each chain its own letter
    bbs = inv.create_components(session, quantity=2, component_type="BOTTOM_BRACKET", label="BB")
    assert [c.label for c in bbs] == ["BB", "BB"]                      # names may repeat (0023)
    assert stock.spare_check(session)  # still works with many spares


def test_limits(session):
    ensure_reference_data(session)
    with pytest.raises(DomainError):
        inv.create_components(session, quantity=0, component_type="INNER_TUBE", label="T")
    with pytest.raises(DomainError):
        inv.create_components(session, quantity=51, component_type="INNER_TUBE", label="T")
    with pytest.raises(DomainError):
        inv.create_components(session, quantity=2, component_type="CHAIN", label="C", mark="X")


def test_several_cannot_be_installed(client):
    bike = client.post("/api/bikes", json={"name": "TIME NXR"}).json()
    r = client.post("/api/components", json={"component_type": "BRAKE_PADS", "label": "Pads", "quantity": 2,
                                             "install": {"at": "2026-11-01", "bike_id": bike["id"], "slot": "FRONT_PADS"}})
    assert r.status_code == 400 and "one by one" in r.json()["detail"]
    assert client.get("/api/components", params={"component_type": "BRAKE_PADS"}).json() == []
    one = client.post("/api/components", json={"component_type": "INNER_TUBE", "label": "Single"}).json()
    assert len(one["created"]) == 1 and one["created"][0]["id"] == one["id"]


def test_older_database_upgrades_and_names_may_repeat(tmp_path):
    """Dirk's rename error (UNIQUE constraint failed: component.component_type, component.label): a database from
    0.3.0 upgrades through 0023, keeps every part, and then a part can take another part's name."""
    import sqlite3
    from contextlib import closing
    from pathlib import Path
    from bikelog import launcher
    from bikelog.paths import DataPaths
    fixture = Path(__file__).parent / "fixtures" / "upgrade" / "v0.3.0.sql"
    paths = DataPaths(tmp_path / "d").ensure()
    with closing(sqlite3.connect(paths.database)) as c:
        c.executescript(fixture.read_text(encoding="utf-8"))
        before = c.execute("SELECT id, component_type, label FROM component ORDER BY id").fetchall()
    engine, factory, _info = launcher.prepare(paths)
    try:
        with closing(sqlite3.connect(paths.database)) as c:
            assert c.execute("SELECT id, component_type, label FROM component ORDER BY id").fetchall() == before
            idx = {r[0] for r in c.execute("SELECT name FROM sqlite_master WHERE type='index' AND tbl_name='component'")}
            assert "uq_component_type_label" not in idx and "ix_component_type_label" in idx
        cl = TestClient(create_app(factory, paths, token=TOKEN, testing=True, static_dir=None))
        cl.headers.update({"X-BikeLog-Token": TOKEN})
        by_type: dict[str, list] = {}
        for cid, ctype, label in before:
            by_type.setdefault(ctype, []).append((cid, label))
        ctype, rows = next((t, r) for t, r in by_type.items() if len(r) >= 2 and t not in ("TIRE", "INNER_TUBE"))
        r = cl.patch(f"/api/components/{rows[1][0]}", json={"label": rows[0][1]})
        assert r.status_code == 200, r.text
        two = cl.post("/api/components", json={"component_type": ctype, "label": rows[0][1], "quantity": 2}).json()
        assert {c["label"] for c in two["created"]} <= {rows[0][1], *(f"{rows[0][1]} [{x}]" for x in "ABCDEFG")}
    finally:
        engine.dispose()
