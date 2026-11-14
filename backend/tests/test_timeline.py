"""Timeline of a bike and of a part: what was done, at what km, filters and CSV export (DECISIONS 142)."""
import csv
import io

import pytest
from fastapi.testclient import TestClient

from bikelog.api.app import create_app
from bikelog.db import make_session_factory, session_scope
from bikelog.services import inventory as inv
from bikelog.services import journal
from bikelog.services import maintenance as m
from bikelog.services import timeline
from bikelog.services.errors import DomainError
from bikelog.services.reference import ensure_reference_data

from helpers import bike, part, ride


def setup(session):
    """A bike with a known odometer (1,000 km on 1 Sep), Chain A (new) on it, two rides, a lube, a swap to
    Chain B, a wear check on Chain A after it came off, a note and a deleted lube."""
    b = bike(session, starting_km=1000, starting_date="2026-09-01")
    a = part(session, "CHAIN", "Chain A")
    c = part(session, "CHAIN", "Chain B")
    inv.install(session, a.id, at="2026-09-01", bike_id=b.id, slot="CHAIN")
    ride(session, b, "2026-09-05T09:00", 100)
    m.log_event(session, action_code="LUBE", at="2026-09-06", component_id=a.id)
    ride(session, b, "2026-09-07T09:00", 50)
    inv.replace(session, a.id, at="2026-09-08", new_component_id=c.id, reason="rotation")
    m.log_event(session, action_code="CHAIN_MEASURE_WEAR", at="2026-09-09", component_id=a.id,
                measurement_value=0.25, measurement_unit="%")
    ride(session, b, "2026-09-10T09:00", 30)
    journal.add(session, text="Creak from the bottom bracket", on="2026-09-11", bike_id=b.id, kind="ISSUE")
    wrong = m.log_event(session, action_code="LUBE", at="2026-09-12", component_id=c.id)
    m.void_event(session, wrong.id, "logged on the wrong chain")
    session.flush()
    return b, a, c, wrong


def test_bike_timeline_has_work_parts_and_notes_with_odometer(session):
    b, a, c, _ = setup(session)
    t = timeline.bike_timeline(session, b.id)
    rows = t["rows"]
    assert [r["date"] for r in rows] == sorted((r["date"] for r in rows), reverse=True)   # newest first
    lube = next(r for r in rows if r["type"] == "LUBE" and r["component_id"] == a.id)
    assert lube["kind"] == "WORK" and lube["bike_km"] == 1100 and lube["bike_km_status"] == "KNOWN"
    assert lube["part_km"] == 100 and lube["part_km_status"] == "KNOWN"
    assert lube["date_only"] and lube["time"] is None
    swap = next(r for r in rows if r["type"] == "REPLACED")
    assert swap["title"] == "Replaced: Chain A → Chain B" and swap["bike_km"] == 1150
    assert "Chain A off at 150 km" in swap["detail"]
    assert not any(r["type"] == "REMOVED" and r["component_id"] == a.id for r in rows)   # merged into Replaced
    # the wear check on Chain A after it came off is not on the bike any more
    assert not any(r["type"] == "CHAIN_MEASURE_WEAR" for r in rows)
    issue = next(r for r in rows if r["kind"] == "NOTE")
    assert issue["bike_km"] == 1180 and "open" in issue["detail"]
    start = next(r for r in rows if r["type"] == "STARTING")
    assert start["kind"] == "OTHER" and start["bike_km"] == 1000


def test_component_timeline_uses_its_own_km_across_bikes(session):
    b, a, c, _ = setup(session)
    other = bike(session, name="BMC Roadmachine")
    inv.install(session, a.id, at="2026-09-15", bike_id=other.id, slot="CHAIN")
    ride(session, other, "2026-09-16T09:00", 40)
    m.log_event(session, action_code="LUBE", at="2026-09-17", component_id=a.id)
    session.flush()
    t = timeline.component_timeline(session, a.id)
    lubes = sorted((r for r in t["rows"] if r["type"] == "LUBE"), key=lambda r: r["date"])
    assert [r["part_km"] for r in lubes] == [100, 190]          # 150 on the TIME, then 40 on the BMC
    assert lubes[1]["bike"] == "BMC Roadmachine" and lubes[1]["bike_km_status"] == "MINIMUM"   # BMC: no start
    wear = next(r for r in t["rows"] if r["type"] == "CHAIN_MEASURE_WEAR")
    assert wear["kind"] == "CHECK" and wear["part_km"] == 150 and "0.25 %" in wear["detail"]
    types = [r["type"] for r in t["rows"]]
    assert types.count("INSTALLED") == 2 and types.count("REMOVED") == 1


def test_km_status_estimated_minimum_missing(session):
    b = bike(session, name="Cube", starting_km=5000, starting_date="2026-09-10", starting_is_estimate=True)
    used = part(session, "CHAIN", "Old chain", prior_usage="UNKNOWN")
    inv.install(session, used.id, at="2026-09-01", bike_id=b.id, slot="CHAIN")
    ride(session, b, "2026-09-05T09:00", 60)
    m.log_event(session, action_code="CHAIN_MEASURE_WEAR", at="2026-09-06", component_id=used.id,
                measurement_value=0.1, measurement_unit="%")
    session.flush()
    rows = timeline.bike_timeline(session, b.id)["rows"]
    check = next(r for r in rows if r["kind"] == "CHECK")
    assert check["bike_km_status"] == "ESTIMATED"         # before an estimated starting value: counted back
    assert check["bike_km"] == 5000                       # the 60 km ride on 5 Sep is inside the starting value
    assert check["part_km_status"] == "MINIMUM"           # its use before tracking is unknown


def test_same_day_km_for_date_only_entries(session):
    b = bike(session, starting_km=0, starting_date="2026-09-01")
    a = part(session, "CHAIN", "Chain A")
    inv.install(session, a.id, at="2026-09-01", bike_id=b.id, slot="CHAIN")
    ride(session, b, "2026-09-05T09:00", 70)
    m.log_event(session, action_code="LUBE", at="2026-09-05", component_id=a.id)
    session.flush()
    lube = next(r for r in timeline.bike_timeline(session, b.id)["rows"] if r["type"] == "LUBE")
    assert lube["bike_km"] == 0 and lube["same_day_km"] == 70    # start of day; up to 70 km later


def test_filters_and_voided(session):
    b, *_ = setup(session)
    t = timeline.bike_timeline(session, b.id, kinds=["PARTS"])
    assert t["rows"] and all(r["kind"] == "PARTS" for r in t["rows"])
    assert not any(r["voided"] for r in timeline.bike_timeline(session, b.id)["rows"])
    t = timeline.bike_timeline(session, b.id, include_voided=True)
    gone = next(r for r in t["rows"] if r["voided"])
    assert gone["type"] == "LUBE" and gone["void_reason"] == "logged on the wrong chain" and t["voided_count"] == 1
    t = timeline.bike_timeline(session, b.id, date_from="2026-09-06", date_to="2026-09-08")
    assert {r["date"] for r in t["rows"]} <= {"2026-09-06", "2026-09-07", "2026-09-08"}
    with pytest.raises(DomainError):
        timeline.bike_timeline(session, b.id, date_from="2026-09-09", date_to="2026-09-01")
    with pytest.raises(DomainError):
        timeline.bike_timeline(session, b.id, kinds=["NOPE"])


def test_csv_excel_and_standard(session):
    b, *_ = setup(session)
    res = timeline.bike_timeline(session, b.id)
    text = timeline.to_csv(res, style="excel")
    assert text.startswith("﻿")
    rows = list(csv.reader(io.StringIO(text[1:]), delimiter=";"))
    assert rows[0] == timeline.CSV_COLUMNS and len(rows) == len(res["rows"]) + 1
    assert rows[1][0] <= rows[-1][0]                                # oldest first
    lube = next(r for r in rows if r[4] == "LUBE")
    assert lube[14] == "1100,0" and lube[15] == "KNOWN" and lube[1] == "" and lube[2] == "yes"
    assert lube[23].startswith("maintenance_event:") and len(lube[24]) == 36
    std = list(csv.reader(io.StringIO(timeline.to_csv(res, style="standard")[1:])))
    assert next(r for r in std if r[4] == "LUBE")[14] == "1100.0"


def test_http_endpoints(engine, paths):
    factory = make_session_factory(engine)
    with session_scope(factory) as s:
        ensure_reference_data(s)
        b, a, *_ = setup(s)
        bike_id, comp_id = b.id, a.id
    c = TestClient(create_app(factory, paths, token="t", testing=True, static_dir=None))
    c.headers.update({"X-BikeLog-Token": "t"})
    r = c.get(f"/api/bikes/{bike_id}/timeline?kinds=WORK,PARTS&from=2026-09-01")
    assert r.status_code == 200 and {x["kind"] for x in r.json()["rows"]} <= {"WORK", "PARTS"}
    assert [k["code"] for k in r.json()["kinds"]] == list(timeline.KINDS)
    r = c.get(f"/api/bikes/{bike_id}/timeline.csv?style=standard")
    assert r.status_code == 200 and r.headers["content-type"].startswith("text/csv")
    assert 'filename="bikelog-timeline-TIME-NXR.csv"' in r.headers["content-disposition"]
    assert c.get(f"/api/components/{comp_id}/timeline").json()["name"] == "Chain A"
    assert c.get(f"/api/components/{comp_id}/timeline.csv").text.startswith("﻿date;time")
    assert c.get(f"/api/bikes/{bike_id}/timeline?from=nope").status_code in (400, 409, 422)
