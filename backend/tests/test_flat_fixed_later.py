"""Two flats on one tube although Dirk always replaces tubes (2026-11-15): both flats were marked solved
without a Fix. Recording the Fix afterwards (Replaced) moves the later flat onto the new tube, so each tube
has one puncture; undo moves it back. Fixed on the road, the flat ride's km stay on the punctured tube."""
from bikelog.services import incidents as inc
from bikelog.services import inventory as inv
from bikelog.services import punctures, repairs, worksessions

from helpers import bike, km, part, ride


def setup(session):
    b = bike(session)
    rw = part(session, "REAR_WHEEL", "R wheel")
    inv.install(session, rw.id, at="2026-09-01", bike_id=b.id)
    tube = part(session, "INNER_TUBE", "Tube 1")
    inv.install(session, tube.id, at="2026-09-01", parent_component_id=rw.id)
    r1 = ride(session, b, "2026-10-31", 60)
    g1 = inc.log(session, r1.id, incident_type="FLAT", affected=[_key(session, r1)])
    ride(session, b, "2026-11-05", 40)
    r2 = ride(session, b, "2026-11-14", 70)
    g2 = inc.log(session, r2.id, incident_type="FLAT", affected=[_key(session, r2)])
    # both marked solved without a fix
    for g in (g1, g2):
        inc.update(session, g, resolved_on="2026-11-15", fields={"resolved_on"})
    return b, tube, g1, g2


def _key(session, r):
    return next(o["key"] for o in inc.choices(session, r, "FLAT") if o["label"].startswith("Rear tube"))


def _tube_entry(session, g):
    return next(p for p in repairs.fix_options(session, g)["parts"] if p["damage"] == "TUBE")


def _entries_tube(session, g):
    from bikelog.services.incidents import _entries
    return _entries(session, g)[0].component_id


def test_fix_after_solved_moves_later_flat_to_new_tube_and_undo_moves_it_back(session):
    b, tube, g1, g2 = setup(session)
    assert _entries_tube(session, g2) == tube.id
    p = _tube_entry(session, g1)
    assert p["options"]["replace"]
    res = repairs.fix(session, g1, at="2026-10-31", parts=[
        {"entry_id": p["entry_id"], "action": "REPLACED", "source": {"kind": "new", "label": "Tube 2"}}])
    new_id = _entries_tube(session, g2)
    assert new_id != tube.id and inv.get_component(session, new_id).label == "Tube 2"
    # on the road: the flat ride's 60 km stay on the punctured tube
    assert km(session, tube) == 60 and km(session, inv.get_component(session, new_id)) == 110
    items = {i["label"]: i for t in punctures.report(session)["by_tube"] for i in t["items"]}
    assert items["Tube 1"]["punctures"] == 1 and items["Tube 2"]["punctures"] == 1
    # the second flat can now be fixed on the new tube
    p2 = _tube_entry(session, g2)
    assert p2["options"]["replace"]
    # undo the first fix: the later flat goes back to the first tube
    worksessions.undo(session, res["work_session_id"])
    assert _entries_tube(session, g2) == tube.id


def test_second_fix_gives_each_tube_one_puncture(session):
    b, tube, g1, g2 = setup(session)
    p = _tube_entry(session, g1)
    repairs.fix(session, g1, at="2026-10-31", parts=[
        {"entry_id": p["entry_id"], "action": "REPLACED", "source": {"kind": "new", "label": "Tube 2"}}])
    p2 = _tube_entry(session, g2)
    repairs.fix(session, g2, at="2026-11-14", parts=[
        {"entry_id": p2["entry_id"], "action": "REPLACED", "source": {"kind": "new", "label": "Tube 3"}}])
    items = {i["label"]: i for t in punctures.report(session)["by_tube"] for i in t["items"]}
    assert {k: v["punctures"] for k, v in items.items()} == {"Tube 1": 1, "Tube 2": 1, "Tube 3": 0}
    assert items["Tube 2"]["km"] == 110
