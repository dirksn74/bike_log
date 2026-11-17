"""Strava ids may be 64-bit from June 2027 (Strava API notice): ids above 2^53 must survive exactly,
``id_str`` is preferred over ``id``, and rides stored before the change keep matching on re-sync."""
import json

import pytest
from sqlalchemy import func, select

from bikelog.connectors.strava import sync as strava
from bikelog.connectors.strava import client as sc
from bikelog.connectors.strava.client import StravaClient, strava_id
from bikelog.db import make_session_factory
from bikelog.models import Ride, RideSource
from bikelog.services import inventory as inv
from bikelog.services import settings

from fake_strava import FakeStrava, act, client_for

BIG = 2**63 - 25            # largest-range 64-bit id; JavaScript would show it as ...800 (rounded)
JS_UNSAFE = 2**53 + 1       # first id a browser cannot hold exactly


def test_strava_id_prefers_id_str_and_falls_back_to_id():
    assert strava_id({"id": BIG, "id_str": str(BIG)}) == str(BIG)
    assert strava_id({"id": 123}) == "123"
    assert strava_id({"id": 123, "id_str": ""}) == "123"
    # a parser that rounded "id" can't hurt us when id_str is there
    assert strava_id({"id": float(BIG), "id_str": str(BIG)}) == str(BIG)
    with pytest.raises(ValueError):
        strava_id({"id": float(BIG)})


def test_json_from_strava_keeps_64bit_ids_exact():
    raw = b'{"id": 9223372036854775783, "id_str": "9223372036854775783"}'
    assert strava_id(json.loads(raw)) == "9223372036854775783"


@pytest.fixture()
def world(engine, session, tmp_path):
    inv.create_bike(session, name="BMC Roadmachine", strava_gear_id="90000001")
    settings.set_value(session, "import_start_date", "2026-10-01")
    session.commit()
    fake = FakeStrava([act(1, "2026-10-02T08:00:00Z", 50, id=BIG),
                       act(2, "2026-10-03T08:00:00Z", 30, id=JS_UNSAFE),
                       act(3, "2026-10-04T08:00:00Z", 20)], athlete_id=BIG)
    return make_session_factory(engine), fake, client_for(fake, tmp_path)


def refs(session):
    session.expire_all()
    return sorted(session.scalars(select(RideSource.source_ref).where(RideSource.source_kind == "STRAVA")))


def test_sync_stores_64bit_activity_ids_exactly_and_resync_matches(session, world):
    factory, fake, client = world
    res = strava.sync(factory, client, force=True)
    assert res["counts"] == {"CREATED": 3}
    assert refs(session) == sorted([str(BIG), str(JS_UNSAFE), "10000003"])
    session.commit()
    res = strava.sync(factory, client, force=True, rescan=True)
    assert "CREATED" not in res["counts"]
    assert session.scalar(select(func.count()).select_from(Ride)) == 3
    session.commit()


def test_rides_stored_from_old_numeric_id_match_new_id_str(session, world):
    """Before this change rides were stored as str(act["id"]); now Strava also sends id_str. Same ride."""
    factory, fake, client = world
    for a in fake.activities.values():
        a.pop("id_str")                       # old API answer: only the number
    strava.sync(factory, client, force=True)
    before = refs(session)
    session.commit()
    for a in fake.activities.values():
        a["id_str"] = str(a["id"])            # new API answer: both
    res = strava.sync(factory, client, force=True, rescan=True)
    assert "CREATED" not in res["counts"]
    assert refs(session) == before
    session.commit()


def test_id_str_wins_when_number_was_rounded(session, world):
    factory, fake, client = world
    for a in fake.activities.values():
        a["id_str"], a["id"] = str(a["id"]), float(a["id"])   # e.g. a lossy JSON parser on the way
    strava.sync(factory, client, force=True)
    assert str(BIG) in refs(session)
    session.commit()


def test_64bit_athlete_id_is_kept_as_text(tmp_path):
    fake = FakeStrava(athlete_id=BIG)
    env = tmp_path / "strava.env"
    c = StravaClient("cid", "secret", sc.EnvTokenStore(env), transport=fake, sleep=lambda s: None,
                     clock=lambda: fake.now)
    tok = c.exchange_code("code")
    assert tok["athlete_id"] == str(BIG)
    assert sc.read_env(env)["STRAVA_ATHLETE_ID"] == str(BIG)
    assert c.athlete_id() == str(BIG)
    # an id saved by an older version (plain number in strava.env) still loads
    sc.update_env(env, {"STRAVA_ATHLETE_ID": "43217313"})
    assert c.athlete_id() == "43217313"
