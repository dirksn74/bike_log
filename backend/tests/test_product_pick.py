"""Brand and model on parts (DECISIONS 149; Dirk 2026-11-15: "where do i enter product? maybe we should add
brand and model for the spare parts and fill it with some common brands and models")."""
import pytest
from fastapi.testclient import TestClient

from bikelog.api.app import create_app
from bikelog.common_products import COMMON_PRODUCTS, COMMON_SOURCE, score
from bikelog.db import make_session_factory, session_scope
from bikelog.catalog import COMPONENT_TYPES
from bikelog.models import Product
from bikelog.services import inventory as inv
from bikelog.services import part_life, product_pick
from bikelog.services.errors import DomainError
from bikelog.services.reference import ensure_reference_data

from helpers import bike, part, ride

TOKEN = "test-token"
GP = "Continental Grand Prix 5000 S TR 28\" Transparent-Edition Faltreifen"


@pytest.fixture()
def client(engine, paths):
    factory = make_session_factory(engine)
    with session_scope(factory) as s:
        ensure_reference_data(s)
    c = TestClient(create_app(factory, paths, token=TOKEN, testing=True, static_dir=None))
    c.headers.update({"X-BikeLog-Token": TOKEN})
    return c


def test_common_list_types_exist_and_no_duplicates():
    for code, rows in COMMON_PRODUCTS.items():
        assert code in COMPONENT_TYPES
        keys = [(r.maker.lower(), r.model.lower()) for r in rows]
        assert len(keys) == len(set(keys)), code
    assert any(r.model == "Grand Prix 5000 S TR" for r in COMMON_PRODUCTS["TIRE"])


def test_score_prefers_longest_model_and_needs_brand_for_short_names():
    assert score(GP, "Continental", "Grand Prix 5000 S TR") > score(GP, "Continental", "Grand Prix 5000") > 0
    assert score("Conti GP5000 S TR 28", "Continental", "Grand Prix 5000 S TR", ("GP5000 S TR",)) > 100
    assert score("One 28 mm", "Schwalbe", "One") == 0          # too short without the brand
    assert score("Schwalbe One 28", "Schwalbe", "One") > 0
    assert score("Spare tire", "Continental", "Grand Prix 5000") == 0


def test_suggest_and_link_name_only_part(session):
    tire = part(session, "TIRE", GP)
    tube = part(session, "INNER_TUBE", "Conti Race 28 light")
    nothing = part(session, "TIRE", "Old front tire")
    rows = {r["id"]: r for r in product_pick.unlinked(session)}
    assert rows[tire.id]["suggestion"]["model"] == "Grand Prix 5000 S TR"
    assert rows[tube.id]["suggestion"]["maker"] == "Continental"
    assert rows[nothing.id]["suggestion"] is None
    product_pick.link_many(session, [{"component_id": tire.id, "maker": "continental", "model": "grand prix 5000 s tr"}])
    p = session.get(Product, tire.product_id)
    assert (p.maker, p.model, p.spec_source) == ("Continental", "Grand Prix 5000 S TR", COMMON_SOURCE)
    assert tire.label == GP                               # the name stays as typed
    assert tire.id not in {r["id"] for r in product_pick.unlinked(session)}
    # a second tire of that model reuses the same product row; your own product now wins suggestions
    other = part(session, "TIRE", "GP5000 S TR rear")
    assert product_pick.suggest(session, other) == {"product_id": p.id, "maker": "Continental",
                                                    "model": "Grand Prix 5000 S TR", "saved": True}
    product_pick.set_product(session, other.id, "Continental", "Grand Prix 5000 S TR")
    assert other.product_id == p.id
    assert session.query(Product).filter_by(component_type="TIRE").count() == 1


def test_free_entry_and_clear(session):
    c = part(session, "BRAKE_PADS", "Pads front")
    product_pick.set_product(session, c.id, "Trickstuff", "Power")
    assert c.product.spec_source == "manual" and c.product.maker == "Trickstuff"
    product_pick.set_product(session, c.id, "", "")
    assert c.product_id is None
    with pytest.raises(DomainError):
        product_pick.set_product(session, c.id, "Trickstuff", "")


def test_choices_list_saved_first_without_duplicates(session):
    inv.create_product(session, component_type="TIRE", maker="Continental", model="Grand Prix 5000 S TR")
    inv.create_product(session, component_type="TIRE", maker="Rene Herse", model="Bon Jon Pass")
    ch = product_pick.choices(session, "TIRE")
    models = [(r["maker"], r["model"]) for r in ch["products"]]
    assert models[:2] == [("Continental", "Grand Prix 5000 S TR"), ("Rene Herse", "Bon Jon Pass")]
    assert models.count(("Continental", "Grand Prix 5000 S TR")) == 1
    assert "Rene Herse" in ch["makers"] and "Pirelli" in ch["makers"]
    assert product_pick.choices(session, "OTHER") == {"makers": [], "products": []}


def test_part_life_groups_by_linked_product(session):
    b = bike(session, purchase_date="2026-01-01")
    old = part(session, "CHAIN", "KMC X11 EL silver")
    inv.install(session, old.id, at="2026-01-01", bike_id=b.id, slot="CHAIN")
    ride(session, b, "2026-02-01", 1500)
    new = part(session, "CHAIN", "Chain new")
    inv.replace(session, old.id, at="2026-03-01", new_component_id=new.id, old_outcome="DISCARDED")
    t = next(x for x in part_life.report(session)["types"] if x["code"] == "CHAIN")
    assert t["products"][0]["product"] == "No product recorded"
    sug = product_pick.suggest(session, old)
    assert (sug["maker"], sug["model"]) == ("KMC", "X11 EL")
    product_pick.set_product(session, old.id, sug["maker"], sug["model"])
    t = next(x for x in part_life.report(session)["types"] if x["code"] == "CHAIN")
    assert t["products"][0]["product"] == "KMC X11 EL" and t["products"][0]["avg_km"] == 1500


def test_api_create_edit_and_link(client):
    g = client.get("/api/product-suggest", params={"component_type": "TIRE", "name": "conti gp5000 s tr 28"}).json()
    assert (g["maker"], g["model"]) == ("Continental", "Grand Prix 5000 S TR")
    assert client.get("/api/product-suggest", params={"component_type": "TIRE", "name": "front"}).json() is None
    ch = client.get("/api/product-choices", params={"component_type": "INNER_TUBE"}).json()
    assert any(r["model"] == "Race 28" for r in ch["products"])
    r = client.post("/api/components", json={"component_type": "INNER_TUBE", "label": "Tube", "quantity": 3,
                                             "product_maker": "Continental", "product_model": "Race 28"})
    assert r.status_code == 201, r.text
    ids = [x["id"] for x in r.json()["created"]]
    prods = {client.get(f"/api/components/{i}").json()["product_id"] for i in ids}
    assert len(prods) == 1 and None not in prods
    c = client.get(f"/api/components/{ids[0]}").json()
    assert (c["product_maker"], c["product_model"], c["product"]) == ("Continental", "Race 28", "Continental Race 28")
    r = client.patch(f"/api/components/{ids[0]}", json={"product_maker": "Schwalbe", "product_model": "SV15"})
    assert r.json()["product"] == "Schwalbe SV15"
    r = client.patch(f"/api/components/{ids[0]}", json={"product_maker": "", "product_model": ""})
    assert r.json()["product_id"] is None
    # a patch without the product fields leaves the product alone
    r = client.patch(f"/api/components/{ids[1]}", json={"notes": "x"})
    assert r.json()["product"] == "Continental Race 28"
    t = client.post("/api/components", json={"component_type": "TIRE", "label": GP}).json()
    rows = client.get("/api/components-without-product").json()
    row = next(x for x in rows if x["id"] == t["id"])
    assert row["suggestion"]["model"] == "Grand Prix 5000 S TR"
    r = client.post("/api/components-without-product/link",
                    json={"links": [{"component_id": t["id"], **{k: row["suggestion"][k] for k in ("maker", "model")}}]},
                    headers={"X-Client-Op-Id": "link-1"})
    assert r.status_code == 200, r.text
    assert client.get(f"/api/components/{t['id']}").json()["product"] == "Continental Grand Prix 5000 S TR"
