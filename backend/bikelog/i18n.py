"""Languages. The English text in the code is the key; bikelog/locales/<code>.json maps it to the translation.

A text without a translation is shown in English, never as an error.

    tr("Bikes")                               → "Räder" in German
    tr("Every {km} km", km=num(300))          → placeholders in {braces}, filled after translating
    trn("{n} ride", "{n} rides", n)           → singular or plural, then translated ({n} is filled in)

Which language: the setting ``language`` (Settings → Language, table app_setting; no row = English). It is one
choice for the whole app (desktop app and single-user server mode), read again at the start of every request
(``set_lang``), so a restore or fresh start that brings another value takes effect on the next request.

Besides the texts wrapped in tr() in the code, every API answer goes through ``translate_payload``: a string under
a label-like key ("name", "label", "explanation" ...) that is exactly a dictionary key is translated. That covers
the reference data (part types, actions, default rule names) without changing the catalog. Codes (UPPER_CASE)
are never dictionary keys, so they pass unchanged.
"""
from __future__ import annotations

import json
from functools import lru_cache

LANGS = {"en": "English", "de": "Deutsch"}
DEFAULT = "en"

_lang = DEFAULT


def valid(code: str | None) -> bool:
    return code in LANGS


def set_lang(code: str | None) -> None:
    global _lang
    _lang = code if valid(code) else DEFAULT


def lang() -> str:
    return _lang


@lru_cache(maxsize=None)
def dictionary(code: str) -> dict[str, str]:
    if code == "en":
        return {}
    from bikelog.paths import resource_root
    f = resource_root() / "locales" / f"{code}.json"     # bundled next to the migrations in the Windows build
    if not f.exists():
        return {}
    return json.loads(f.read_text(encoding="utf-8"))


def tr(text: str, /, **vars) -> str:
    """Translate a UI text. Placeholders like {name} are filled after translating, so the order can change.

    In another language than English, a filled-in value that is itself a known text is translated too: the
    names of part types, actions and setups ("chain", "Hot wax") come from the catalog in English."""
    if _lang != "en":
        d = dictionary(_lang)
        text = d.get(text, text)
        vars = {k: _value(d, v) for k, v in vars.items()}
    for k, v in vars.items():
        text = text.replace("{" + k + "}", "" if v is None else str(v))
    return text


def _value(d: dict[str, str], v):
    if not isinstance(v, str) or not v:
        return v
    if v in d:
        return d[v]
    if v[0].islower() and (v[0].upper() + v[1:]) in d:   # "chain" → "Kette" (German nouns keep their capital)
        return d[v[0].upper() + v[1:]]
    return v


def trn(one: str, many: str, n: int | float, /, **vars) -> str:
    """Singular or plural, then translated. {n} is filled in with the count."""
    return tr(one if abs(n) == 1 else many, n=n, **vars)


def num(v: float | int | None, digits: int = 0) -> str:
    """A number with thousands separators: 1,234.5 in English, 1.234,5 in German."""
    if v is None:
        return "?"
    s = f"{v:,.{digits}f}"
    if _lang == "de":
        s = s.replace(",", "\u0000").replace(".", ",").replace("\u0000", ".")
    return s


def dec(v: float | int | None, digits: int = 1) -> str:
    """A number without thousands separators: 2.5 in English, 2,5 in German."""
    if v is None:
        return "?"
    s = f"{v:.{digits}f}"
    return s.replace(".", ",") if _lang == "de" else s


def unit_word(unit: str, n: int | float) -> str:
    """A stock unit for a count: "1 tube", "2 tubes" / "1 Schlauch", "2 Schläuche" ("plural:<unit>" entries)."""
    if _lang == "en":
        return unit if abs(n) == 1 or unit.endswith("s") else unit + "s"
    d = dictionary(_lang)
    return d.get(unit, unit) if abs(n) == 1 else d.get("plural:" + unit, d.get(unit, unit))


def code_text(code: str | None) -> str:
    """A code as words: "FRONT_WHEEL" → "front wheel", or the German "code:FRONT_WHEEL" entry."""
    if not code:
        return ""
    if _lang != "en":
        hit = dictionary(_lang).get("code:" + code)
        if hit:
            return hit
    return code.replace("_", " ").lower()


def lc(s: str) -> str:
    """Lower-case a name used inside a sentence ("since last hot wax"). German nouns keep their capital letter."""
    return s if _lang == "de" else s.lower()


# ------------------------------------------------------------------ API answers

_KEYS = {"name", "label", "title", "text", "explanation", "message", "hint", "note", "notice", "description", "notes",
         "detail", "reason", "summary", "why", "basis", "category", "safety_note", "headline", "what",
         "status_text", "warning", "warnings", "checklist", "kind_label", "subject", "problems", "errors", "lines"}
_SUFFIXES = ("_name", "_label", "_text", "_note", "_hint", "_title", "_explanation", "_message", "_warning", "_category")


def _label_key(key: str) -> bool:
    return key in _KEYS or key.endswith(_SUFFIXES)


def translate_payload(obj, _key: str | None = None):
    """Translate label-like strings of an API answer (see the module docstring). English: returned unchanged."""
    if _lang == "en":
        return obj
    d = dictionary(_lang)
    if not d:
        return obj

    def walk(o, key):
        if isinstance(o, dict):
            return {k: walk(v, k) for k, v in o.items()}
        if isinstance(o, list):
            return [walk(v, key) for v in o]
        if isinstance(o, str) and key is not None and _label_key(key):
            return d.get(o, o)
        return o
    return walk(obj, _key)
