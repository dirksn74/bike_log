"""Languages (DECISIONS 143): Settings → Language switches the whole app between English and German.

English stays exactly as before; German comes from bikelog/locales/de.json (backend) and
frontend/src/locales/de.json (screens). The choice is one row in app_setting, so an older database has no
row and reads English.
"""
from __future__ import annotations

import runpy
import sys
from pathlib import Path

import pytest
from fastapi.testclient import TestClient

from bikelog import i18n
from bikelog.api.app import create_app
from bikelog.db import make_session_factory, session_scope
from bikelog.services import inventory as inv
from bikelog.services import settings
from bikelog.services.reference import ensure_reference_data

ROOT = Path(__file__).resolve().parents[2]


@pytest.fixture(autouse=True)
def back_to_english():
    yield
    i18n.set_lang("en")       # the language is process-wide; other tests expect English


def client(factory, paths, static_dir=None) -> TestClient:
    c = TestClient(create_app(factory, paths, token="t", testing=True, static_dir=static_dir))
    c.headers["X-BikeLog-Token"] = "t"
    return c


@pytest.fixture()
def factory(engine):
    f = make_session_factory(engine)
    with session_scope(f) as s:
        ensure_reference_data(s)
        inv.create_bike(s, name="Roadmachine")
    return f


def test_default_is_english_and_the_choice_is_checked(factory, paths):
    c = client(factory, paths)
    assert c.get("/api/settings").json()["language"] == "en"
    r = c.patch("/api/settings", json={"language": "fr"})
    assert r.status_code == 400 and "Language must be one of" in r.json()["detail"]
    assert c.get("/api/settings").json()["language"] == "en"


def test_german_labels_messages_and_numbers(factory, paths):
    c = client(factory, paths)
    english = c.get("/api/meta").json()
    assert next(t for t in english["component_types"] if t["code"] == "CHAIN")["name"] == "Chain"

    assert c.patch("/api/settings", json={"language": "de"}).status_code == 200
    meta = c.get("/api/meta").json()
    assert next(t for t in meta["component_types"] if t["code"] == "CHAIN")["name"] == "Kette"
    # a message from the backend (a refused input) is German too
    r = c.patch("/api/settings", json={"language": "xx"})
    assert r.status_code == 400 and r.json()["detail"].startswith("Die Sprache muss")
    assert i18n.num(1234.5, 1) == "1.234,5" and i18n.dec(2.5) == "2,5"
    assert i18n.trn("{x} km from {n} ride", "{x} km from {n} rides", 2, x=i18n.num(80.5, 1)) == "80,5 km aus 2 Fahrten"

    # back to English: exactly the English texts again
    assert c.patch("/api/settings", json={"language": "en"}).status_code == 200
    assert c.get("/api/meta").json() == english
    assert i18n.num(1234.5, 1) == "1,234.5"


def test_the_choice_survives_a_restart(factory, paths):
    assert client(factory, paths).patch("/api/settings", json={"language": "de"}).status_code == 200
    i18n.set_lang("en")                                   # a new process starts in English ...
    c = client(factory, paths)                            # ... and reads the setting on start and per request
    assert c.get("/api/settings").json()["language"] == "de"
    assert next(t for t in c.get("/api/meta").json()["component_types"] if t["code"] == "CHAIN")["name"] == "Kette"
    with session_scope(factory) as s:
        assert settings.get(s, "language") == "de"


def test_the_page_tells_the_screens_the_language(factory, paths, tmp_path):
    static = tmp_path / "static"
    static.mkdir()
    (static / "index.html").write_text('<meta name="bikelog-token" content="%BIKELOG_TOKEN%" />'
                                       '<meta name="bikelog-lang" content="%BIKELOG_LANG%" />', encoding="utf-8")
    c = client(factory, paths, static_dir=static)
    assert 'name="bikelog-lang" content="en"' in c.get("/").text
    c.patch("/api/settings", json={"language": "de"})
    page = c.get("/")
    assert 'name="bikelog-lang" content="de"' in page.text and page.headers["cache-control"] == "no-store"


def test_user_data_is_never_translated(factory, paths):
    c = client(factory, paths)
    c.patch("/api/settings", json={"language": "de"})
    bike = c.get("/api/bikes").json()[0]
    assert bike["name"] == "Roadmachine"
    # a name that happens to be a dictionary word is still shown under "label" ... but stored unchanged
    with session_scope(factory) as s:
        comp = inv.create_component(s, component_type="CHAIN", label="Chain")
        cid = comp.id
    with session_scope(factory) as s:
        assert inv.get_component(s, cid).label == "Chain"


def test_every_text_has_german():
    """scripts/i18n_check.py: every tr()/trn() text (screens and backend) has a German entry with the same
    placeholders. New UI text needs a German entry (docs/PROJECT_GUIDE_FOR_AI_AGENTS.md)."""
    sys.argv = ["i18n_check.py"]
    mod = runpy.run_path(str(ROOT / "scripts" / "i18n_check.py"))
    assert mod["main"]() == 0
