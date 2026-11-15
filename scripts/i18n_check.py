"""Check the German texts: every text the code translates has a German entry, and no entry is left over.

    python scripts/i18n_check.py            # report; exit code 1 when a German text is missing
    python scripts/i18n_check.py --keys     # print every key (frontend, then backend)

Where the keys come from:
* frontend/src: tr('...') and trn('...', '...') (the English text is the key) → frontend/src/locales/de.json
* backend/bikelog: tr("...") and trn("...", "...") in the code, plus the reference data the API sends as
  labels (part types, actions, default rules, setups ...; see catalog_texts) → backend/bikelog/locales/de.json

Keys are English texts with {placeholders}; the German text must have the same placeholders.
"""
from __future__ import annotations

import ast
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FRONT = ROOT / "frontend" / "src"
BACK = ROOT / "backend" / "bikelog"
FRONT_DE = FRONT / "locales" / "de.json"
BACK_DE = BACK / "locales" / "de.json"

_JS_STR = r"""'((?:[^'\\\n]|\\.)*)'|"((?:[^"\\\n]|\\.)*)\""""
_JS_CALL = re.compile(r"\btrn?\(\s*(?:" + _JS_STR + r")(?:\s*,\s*(?:" + _JS_STR + r"))?")


def _js_unescape(s: str) -> str:
    return re.sub(r"\\(.)", lambda m: {"n": "\n", "t": "\t"}.get(m.group(1), m.group(1)), s)


def frontend_keys() -> set[str]:
    keys: set[str] = set()
    for f in FRONT.rglob("*.ts*"):
        if f.name == "i18n.ts":
            continue
        for m in _JS_CALL.finditer(f.read_text(encoding="utf-8")):
            a = m.group(1) if m.group(1) is not None else m.group(2)
            keys.add(_js_unescape(a))
            if m.group(0).startswith("trn("):
                b = m.group(3) if m.group(3) is not None else m.group(4)
                if b is not None:
                    keys.add(_js_unescape(b))
    return keys


def backend_code_keys() -> set[str]:
    keys: set[str] = set()
    for f in BACK.rglob("*.py"):
        if "migrations" in f.parts or f.name == "i18n.py":
            continue
        for n in ast.walk(ast.parse(f.read_text(encoding="utf-8"))):
            if isinstance(n, ast.Call) and isinstance(n.func, (ast.Name, ast.Attribute)):
                name = n.func.id if isinstance(n.func, ast.Name) else n.func.attr
                if name in ("tr", "trn"):
                    for a in n.args[: 2 if name == "trn" else 1]:
                        if isinstance(a, ast.Constant) and isinstance(a.value, str):
                            keys.add(a.value)
    return keys


def catalog_texts() -> set[str]:
    """Reference data the API sends under label-like keys (translated by i18n.translate_payload)."""
    sys.path.insert(0, str(ROOT / "backend"))
    from bikelog import catalog as c
    from bikelog.product_specs import fields_for
    from bikelog.services import maintenance as m
    out: set[str] = set()
    for t in c.COMPONENT_TYPES.values():
        out |= {t.name, t.category}
        out |= {f.description for f in fields_for(t.code) if f.description}
        out |= {f.unit for f in fields_for(t.code) if f.unit and re.search(r"[a-z]{2}", f.unit)}
    for a in c.ACTIONS.values():
        out.add(a.name)
        out |= set(a.checklist)
    for r in c.DEFAULT_RULES:
        out.add(r.name)
    for p in c.DEFAULT_PROFILES:
        out.add(p.name)
    for d in (c.DISPOSITIONS, c.TRACKING_MODES, c.TIRE_SETUPS, c.SHIFTING_TYPES, c.INCIDENT_TYPES, c.RIDE_CONDITIONS):
        out |= set(d.values())
    for opts in c.INCIDENT_OPTIONS.values():
        out |= {o.label for o in opts}
    for unit, note in c.STOCK_UNITS.values():
        out |= {unit, "plural:" + unit, note}      # i18n.unit_word: "1 tube", "2 tubes"
    out.add(m.SAFETY_NOTE)
    for r in c.DEFAULT_RULES:
        if r.notes:
            out.add(r.notes)
    for p in c.DEFAULT_PROFILES:
        if getattr(p, "notes", None):
            out.add(p.notes)
    from bikelog import changelog
    from bikelog.services import groupsets, picklists, service_orders, timeline
    out |= set(timeline.KINDS.values()) | set(service_orders.OUTCOMES.values()) | set(groupsets.OCCUPIED_MODES.values())
    out |= {x["name"] for x in picklists.LISTS.values()}
    out |= set(changelog.LABELS.values()) | set(changelog.SOURCES.values())
    return {x for x in out if x and re.search(r"[A-Za-z]{2}", x)}


def placeholders(s: str) -> set[str]:
    return set(re.findall(r"\{(\w+)\}", s))


def check(keys: set[str], file: Path, label: str) -> int:
    de = json.loads(file.read_text(encoding="utf-8")) if file.exists() else {}
    missing = sorted(k for k in keys if k not in de)
    unused = sorted(k for k in de if k not in keys and not k.startswith(("code:", "plural:", "unit:")))   # looked up by code
    bad = sorted(k for k in keys & de.keys() if placeholders(k) != placeholders(de[k]))
    print(f"{label}: {len(keys)} texts, {len(missing)} without German, {len(unused)} German entries not used, "
          f"{len(bad)} with other placeholders")
    for k in missing[:40]:
        print("  missing:", json.dumps(k, ensure_ascii=False))
    for k in bad:
        print("  placeholders differ:", json.dumps(k, ensure_ascii=False), "→", json.dumps(de[k], ensure_ascii=False))
    return 1 if missing or bad else 0


def main() -> int:
    fk = frontend_keys()
    bk = backend_code_keys() | catalog_texts()
    if "--keys" in sys.argv:
        print(json.dumps({"frontend": sorted(fk), "backend": sorted(bk)}, ensure_ascii=False, indent=1))
        return 0
    return check(fk, FRONT_DE, "screens (frontend)") | check(bk, BACK_DE, "messages (backend)")


if __name__ == "__main__":
    sys.exit(main())
