"""Timeline of a bike or a part: everything that happened to it, in date order, with the km at that moment.

One list built from the records that already exist (no new table): maintenance events (work and checks,
supplies used), installations (on, off, replaced), incidents and journal notes, starting values and
corrections, what happened to a part off the bike, and the purchase. Nothing is hidden: deleted and
corrected records come back with ``voided`` set and the reason, and the caller decides whether to show them.

The km at each entry are derived here, never stored (DECISIONS 142):

* bike: the odometer at the entry's instant = starting value + included rides before it (rides before
  the starting value are inside it; an entry before the starting value is counted back from it);
* part: its own lifetime km at that instant across every bike it was on = starting value + corrections
  + counted ride contributions before it (``usage.component_ledger`` rules).

Each km value carries a status: KNOWN, ESTIMATED (≈: estimated starting value, counted back, or rides
with an uncertain part assignment), MINIMUM (≥: usage before tracking unknown, or rides without a
distance) or MISSING (no value: the entry is before tracking started). An entry with a date only means
the start of that local day (or the end of it for a liquid-wax top-up, DECISIONS 137); km ridden later
that day are given as ``same_day_km`` so a reader sees the entry could be up to that much later.
"""
from __future__ import annotations

import bisect
import csv
import io
from dataclasses import dataclass, field

from sqlalchemy import or_, select
from sqlalchemy.orm import Session

from bikelog.catalog import ACTIONS, COMPONENT_TYPES, DISPOSITIONS, INCIDENT_TYPES
from bikelog.models import (
    Bike, Component, ComponentDisposition, Installation, JournalEntry, MaintenanceEvent, Ride,
    UsageAdjustment, UsageContribution,
)
from bikelog.services import settings
from bikelog.services.errors import DomainError
from bikelog.services.inventory import get_bike, get_component
from bikelog.timeutil import parse_utc, parse_when
from bikelog.i18n import code_text, lc, num, tr

# filter groups shown on screen, in this order
KINDS: dict[str, str] = {
    "WORK": "Work done",
    "CHECK": "Checks and measurements",
    "PARTS": "Parts on and off",
    "INCIDENT": "Incidents",
    "NOTE": "Notes and issues",
    "OTHER": "Km and status",
}
_CHECK_KINDS = {"INSPECT", "MEASURE"}
_NOTE_KINDS = {"NOTE"}


def _round(x: float | None) -> float | None:
    return None if x is None else round(x + 0.0, 3)


def _slot_name(slot: str | None) -> str:
    t = code_text(slot)
    return t[:1].upper() + t[1:]


# ---------------------------------------------------------------- km at an instant

@dataclass
class _BikeOdometer:
    start_km: float | None
    start_utc: str | None
    start_estimate: bool
    sorts: list[str] = field(default_factory=list)
    cum: list[float] = field(default_factory=list)       # km of rides[0..i] inclusive
    missing: list[int] = field(default_factory=list)     # count of rides without distance in rides[0..i]
    days: dict[str, list[tuple[str, float]]] = field(default_factory=dict)

    def _before(self, utc: str) -> tuple[float, int]:
        i = bisect.bisect_left(self.sorts, utc)       # rides strictly before the instant
        return (self.cum[i - 1], self.missing[i - 1]) if i else (0.0, 0)

    def at(self, utc: str) -> tuple[float | None, str]:
        km_before, miss_before = self._before(utc)
        if self.start_km is None:
            return _round(km_before), "MINIMUM"
        km_start, miss_start = self._before(self.start_utc)
        if utc >= self.start_utc:
            value = self.start_km + (km_before - km_start)
            status = "ESTIMATED" if self.start_estimate else ("MINIMUM" if miss_before > miss_start else "KNOWN")
            return _round(value), status
        value = self.start_km - (km_start - km_before)    # counted back from the starting value
        return (_round(value), "ESTIMATED") if value >= 0 else (None, "MISSING")

    def same_day(self, utc: str, local_day: str) -> float:
        return _round(sum(k for s, k in self.days.get(local_day, []) if s >= utc)) or 0.0


def _bike_odometer(session: Session, bike: Bike, tz: str) -> _BikeOdometer:
    from bikelog.services.usage import starting_value
    start = starting_value(session, bike_id=bike.id)
    odo = _BikeOdometer(start.km if start else None, start.effective_utc if start else None,
                        bool(start and start.is_estimate))
    total, missing = 0.0, 0
    for sort_utc, dist, day in session.execute(select(Ride.sort_utc, Ride.distance_km, Ride.ride_date).where(
            Ride.bike_id == bike.id, Ride.status == "ACTIVE", Ride.inclusion == "INCLUDED").order_by(Ride.sort_utc, Ride.id)):
        total += float(dist or 0)
        missing += dist is None
        odo.sorts.append(sort_utc)
        odo.cum.append(total)
        odo.missing.append(missing)
        odo.days.setdefault(day, []).append((sort_utc, float(dist or 0)))
    return odo


@dataclass
class _PartOdometer:
    comp: Component
    start_km: float | None
    start_utc: str | None
    start_estimate: bool
    corrections: list[tuple[str, float]]
    sorts: list[str] = field(default_factory=list)
    cum: list[float] = field(default_factory=list)
    uncertain: list[int] = field(default_factory=list)
    days: dict[str, list[tuple[str, float]]] = field(default_factory=dict)

    def at(self, utc: str) -> tuple[float | None, str]:
        if self.start_utc and utc < self.start_utc:
            return None, "MISSING"            # before tracking started: its km then are not known
        i = bisect.bisect_left(self.sorts, utc)
        rides_km = self.cum[i - 1] if i else 0.0
        uncertain = self.uncertain[i - 1] if i else 0
        value = (self.start_km or 0.0) + sum(k for s, k in self.corrections if s <= utc) + rides_km
        if self.start_km is None and self.comp.prior_usage == "UNKNOWN":
            status = "MINIMUM"
        elif self.start_estimate or uncertain:
            status = "ESTIMATED"
        else:
            status = "KNOWN"
        return _round(value), status

    def same_day(self, utc: str, local_day: str) -> float:
        return _round(sum(k for s, k in self.days.get(local_day, []) if s >= utc)) or 0.0


def _part_odometer(session: Session, comp: Component) -> _PartOdometer:
    adjustments = list(session.scalars(select(UsageAdjustment).where(
        UsageAdjustment.component_id == comp.id, UsageAdjustment.voided_at.is_(None))
        .order_by(UsageAdjustment.id)))
    start = next((a for a in reversed(adjustments) if a.kind == "STARTING"), None)
    odo = _PartOdometer(comp, start.km if start else None, start.effective_utc if start else None,
                        bool(start and start.is_estimate),
                        [(a.effective_utc, a.km) for a in adjustments if a.kind == "CORRECTION"])
    total, uncertain = 0.0, 0
    for sort_utc, km, certain, day in session.execute(
            select(UsageContribution.sort_utc, UsageContribution.km, UsageContribution.certain, Ride.ride_date)
            .join(Ride, Ride.id == UsageContribution.ride_id)
            .where(UsageContribution.component_id == comp.id, UsageContribution.state == "COUNTED")
            .order_by(UsageContribution.sort_utc, UsageContribution.ride_id)):
        total += float(km or 0)
        uncertain += not certain
        odo.sorts.append(sort_utc)
        odo.cum.append(total)
        odo.uncertain.append(uncertain)
        odo.days.setdefault(day, []).append((sort_utc, float(km or 0)))
    return odo


# ---------------------------------------------------------------- building the rows

class _Builder:
    def __init__(self, session: Session, *, bike: Bike | None = None, comp: Component | None = None):
        self.s = session
        self.tz = settings.tz(session)
        self.bike, self.comp = bike, comp
        self.rows: list[dict] = []
        self._bike_odos: dict[int, _BikeOdometer] = {}
        self._part_odos: dict[int, _PartOdometer] = {}
        self._labels = dict(session.execute(select(Component.id, Component.label)).all())
        self._types = dict(session.execute(select(Component.id, Component.component_type)).all())
        self._bikes = dict(session.execute(select(Bike.id, Bike.name)).all())

    def bike_odo(self, bike_id: int) -> _BikeOdometer:
        if bike_id not in self._bike_odos:
            self._bike_odos[bike_id] = _bike_odometer(self.s, get_bike(self.s, bike_id), self.tz)
        return self._bike_odos[bike_id]

    def part_odo(self, component_id: int) -> _PartOdometer:
        if component_id not in self._part_odos:
            self._part_odos[component_id] = _part_odometer(self.s, get_component(self.s, component_id))
        return self._part_odos[component_id]

    def _when(self, raw: str) -> tuple[str, str | None, bool]:
        """(local date, local HH:MM or None, date_only) of a stored value: a date, or a UTC instant."""
        if len(raw) == 10:
            return raw, None, True
        try:
            instant = parse_utc(raw)
        except ValueError:
            instant = parse_utc(parse_when(raw, self.tz).utc)
        local = instant.astimezone(_zone(self.tz))
        return local.date().isoformat(), local.strftime("%H:%M"), False

    def add(self, *, ref: str, uuid: str | None, kind: str, type_code: str, title: str, raw_when: str, sort_utc: str,
            bike_id: int | None, component_id: int | None, detail: str | None = None, cost_cents: int | None = None,
            voided: bool = False, void_reason: str | None = None, ride_id: int | None = None,
            group: str | None = None, other_component_id: int | None = None) -> dict:
        day, clock, date_only = self._when(raw_when)
        row = {"ref": ref, "uuid": uuid, "kind": kind, "type": type_code, "title": title, "detail": detail or None,
               "date": day, "time": clock, "date_only": date_only, "sort_utc": sort_utc,
               "bike_id": bike_id, "bike": self._bikes.get(bike_id),
               "component_id": component_id, "component": self._labels.get(component_id),
               "component_type": self._types.get(component_id),
               "component_type_name": COMPONENT_TYPES[self._types[component_id]].name
               if component_id in self._types and self._types[component_id] in COMPONENT_TYPES else None,
               "other_component_id": other_component_id, "other_component": self._labels.get(other_component_id),
               "cost_cents": cost_cents, "voided": voided, "void_reason": void_reason if voided else None,
               "ride_id": ride_id, "group": group,
               "bike_km": None, "bike_km_status": None, "part_km": None, "part_km_status": None,
               "same_day_km": None}
        # the bike's odometer: on a bike timeline always that bike; on a part timeline the bike it was on
        odo_bike = self.bike.id if self.bike else bike_id
        same_day = 0.0
        if odo_bike is not None:
            odo = self.bike_odo(odo_bike)
            row["bike_km"], row["bike_km_status"] = odo.at(sort_utc)
            if date_only:
                same_day = max(same_day, odo.same_day(sort_utc, day))
        part = self.comp.id if self.comp else component_id
        if part is not None:
            podo = self.part_odo(part)
            row["part_km"], row["part_km_status"] = podo.at(sort_utc)
            if date_only:
                same_day = max(same_day, podo.same_day(sort_utc, day))
        row["same_day_km"] = same_day or None
        self.rows.append(row)
        return row


def _zone(tz: str):
    from zoneinfo import ZoneInfo
    return ZoneInfo(tz)


def _event_kind(code: str) -> str:
    a = ACTIONS.get(code)
    if a and a.kind in _CHECK_KINDS:
        return "CHECK"
    if a and a.kind in _NOTE_KINDS:
        return "NOTE"
    return "WORK"


def _event_detail(s: Session, e: MaintenanceEvent) -> str:
    from bikelog.models import Consumable
    bits = []
    if e.measurement_value is not None:
        bits.append(f"{e.measurement_value:g} {e.measurement_unit or ''}".strip())
    if e.outcome:
        bits.append(code_text(e.outcome))
    if e.consumable_id:
        c = s.get(Consumable, e.consumable_id)
        qty = f"{e.consumable_qty:g} {c.unit} " if c and e.consumable_qty is not None else ""
        bits.append(tr("used {qty}{name}", qty=qty, name=c.name if c else tr("supply")))
    if e.symptom:
        bits.append(tr("symptom: {symptom}", symptom=e.symptom))
    if e.work_done:
        bits.append(tr("work done: {work_done}", work_done=e.work_done))
    if e.shop:
        bits.append(tr("at {shop}", shop=e.shop))
    if e.notes:
        bits.append(e.notes)
    return " · ".join(bits)


def _add_events(b: _Builder, q) -> None:
    for e in b.s.scalars(q):
        a = ACTIONS.get(e.action_code)
        b.add(ref=f"maintenance_event:{e.id}", uuid=e.uuid, kind=_event_kind(e.action_code), type_code=e.action_code,
              title=tr(a.name) if a else e.action_code, raw_when=e.performed_at, sort_utc=e.sort_utc,
              bike_id=e.bike_id, component_id=e.component_id, detail=_event_detail(b.s, e), cost_cents=e.cost_cents,
              voided=bool(e.voided_at), void_reason=e.void_reason, group=e.batch_ref or (
                  f"ws:{e.work_session_id}" if e.work_session_id else None))


def _root_bike(s: Session, component_id: int, utc: str, *, at_end: bool = False, depth: int = 0) -> int | None:
    """The bike a part was (directly or through its parents) on at an instant."""
    if depth > 8:
        return None
    for i in s.scalars(select(Installation).where(Installation.component_id == component_id,
                                                  Installation.voided_at.is_(None))):
        end_ok = i.removed_utc is None or (i.removed_utc >= utc if at_end else i.removed_utc > utc)
        if i.installed_utc <= utc and end_ok:
            if i.bike_id is not None:
                return i.bike_id
            return _root_bike(s, i.parent_component_id, utc, at_end=at_end, depth=depth + 1)
    return None


def _where(b: _Builder, i: Installation) -> str:
    target = b._bikes.get(i.bike_id) if i.bike_id else b._labels.get(i.parent_component_id)
    return f"{target} · {_slot_name(i.slot)}"


def _add_installations(b: _Builder, installs: list[Installation], *, merge_replacements: bool) -> None:
    """On / off rows. On a bike timeline a part taken off and another put on in the same place at the same
    moment is one "Replaced" row (km of both parts are given)."""
    removed_by_key: dict[tuple, Installation] = {}
    if merge_replacements:
        for i in installs:
            if i.removed_utc and not i.voided_at:
                removed_by_key[(i.bike_id, i.parent_component_id, i.slot, i.removed_utc)] = i
    merged: set[int] = set()
    for i in installs:
        bike_of_install = i.bike_id or (b.bike.id if b.bike else _root_bike(b.s, i.component_id, i.installed_utc))
        old = removed_by_key.get((i.bike_id, i.parent_component_id, i.slot, i.installed_utc)) if not i.voided_at else None
        if old is not None and old.id != i.id:
            merged.add(old.id)
            okm, ostat = b.part_odo(old.component_id).at(old.removed_utc)
            okm_txt = "" if okm is None else tr(" at {km}", km=_km_text(okm, ostat))
            detail = tr("{label} off{at}", label=b._labels.get(old.component_id), at=okm_txt) + (
                f" ({old.removal_reason})" if old.removal_reason else "")
            b.add(ref=f"installation:{i.id}", uuid=i.uuid, kind="PARTS", type_code="REPLACED",
                  title=tr("Replaced: {old} → {new}", old=b._labels.get(old.component_id), new=b._labels.get(i.component_id)),
                  raw_when=i.installed_at, sort_utc=i.installed_utc, bike_id=bike_of_install,
                  component_id=i.component_id, other_component_id=old.component_id,
                  detail=f"{_where(b, i)} · {detail}", group=f"ws:{i.install_session_id}" if i.install_session_id else None)
            continue
        b.add(ref=f"installation:{i.id}", uuid=i.uuid, kind="PARTS", type_code="INSTALLED",
              title=tr("Installed: {label}", label=b._labels.get(i.component_id)), raw_when=i.installed_at, sort_utc=i.installed_utc,
              bike_id=bike_of_install, component_id=i.component_id,
              detail=" · ".join(p for p in (_where(b, i), i.note) if p),
              voided=bool(i.voided_at), void_reason=i.void_reason,
              group=f"ws:{i.install_session_id}" if i.install_session_id else None)
    for i in installs:
        if not i.removed_utc or i.id in merged:
            continue
        bike_of_removal = i.bike_id or (b.bike.id if b.bike else _root_bike(b.s, i.component_id, i.removed_utc, at_end=True))
        outcome = i.removal_outcome
        out_txt = tr("moved") if outcome == "MOVED" else (tr(DISPOSITIONS.get(outcome, "")) if outcome else "")
        b.add(ref=f"installation:{i.id}:removed", uuid=i.uuid, kind="PARTS", type_code="REMOVED",
              title=tr("Removed: {label}", label=b._labels.get(i.component_id)), raw_when=i.removed_at, sort_utc=i.removed_utc,
              bike_id=bike_of_removal, component_id=i.component_id,
              detail=" · ".join(p for p in (_where(b, i), lc(out_txt) if out_txt else None, i.removal_reason) if p),
              voided=bool(i.voided_at), void_reason=i.void_reason,
              group=f"ws:{i.removal_session_id}" if i.removal_session_id else None)


def _km_text(value: float | None, status: str | None) -> str:
    if value is None:
        return tr("km unknown")
    prefix = {"ESTIMATED": "≈", "MINIMUM": "≥"}.get(status or "", "")
    return f"{prefix}{num(value)} km"


def _add_journal(b: _Builder, q) -> None:
    groups: dict[str, list[JournalEntry]] = {}
    for e in b.s.scalars(q):
        if e.incident_type and e.incident_group:
            groups.setdefault(e.incident_group, []).append(e)
            continue
        utc = parse_when(e.entry_on, b.tz).utc
        b.add(ref=f"journal_entry:{e.id}", uuid=e.uuid, kind="INCIDENT" if e.incident_type else "NOTE",
              type_code=e.incident_type or e.kind,
              title=tr(INCIDENT_TYPES.get(e.incident_type, e.incident_type)) if e.incident_type else (
                  tr("Issue") if e.kind == "ISSUE" else tr("Note")),
              raw_when=e.entry_on, sort_utc=utc, bike_id=e.bike_id, component_id=e.component_id,
              detail=" · ".join(p for p in (e.text, e.affected,
                                            (tr("solved {resolved_on}", resolved_on=e.resolved_on) if e.resolved_on else (tr("open") if e.kind == "ISSUE" else None))) if p),
              voided=bool(e.voided_at), void_reason=e.void_reason, ride_id=e.ride_id)
    for gid, entries in groups.items():
        first = min(entries, key=lambda x: x.id)
        live = [x for x in entries if not x.voided_at] or entries
        affected = ", ".join(dict.fromkeys(
            (b._labels.get(x.component_id) if x.component_id else (x.affected or tr("whole bike"))) for x in live))
        fixes = [f"{b._labels.get(x.component_id) or x.affected or 'bike'}: {x.repair.lower()}"
                 + (f" ({x.repair_text})" if x.repair_text else "") for x in live if x.repair]
        resolved = next((x.resolved_on for x in live if x.resolved_on), None)
        on_part = b.comp is not None
        utc = parse_when(first.entry_on, b.tz).utc
        b.add(ref=f"incident:{gid}", uuid=gid, kind="INCIDENT", type_code=first.incident_type,
              title=tr(INCIDENT_TYPES.get(first.incident_type, first.incident_type)), raw_when=first.entry_on, sort_utc=utc,
              bike_id=first.bike_id, component_id=b.comp.id if on_part else (live[0].component_id if len(live) == 1 else None),
              detail=" · ".join(p for p in (tr("affected: {affected}", affected=affected) if affected else None, first.text,
                                            "; ".join(fixes) if fixes else None,
                                            tr("solved {resolved_on}", resolved_on=resolved) if resolved else tr("open")) if p),
              voided=all(x.voided_at for x in entries), void_reason=first.void_reason, ride_id=first.ride_id)


def _add_adjustments(b: _Builder, q, *, unit: str) -> None:
    for a in b.s.scalars(q):
        est = tr(" (estimate)") if a.is_estimate else ""
        title = (tr("Starting value: {km} km{est}", km=num(a.km), est=est) if a.kind == "STARTING"
                 else tr("Km correction: {km} km", km=("+" if a.km >= 0 else "") + num(a.km, 1)))
        b.add(ref=f"usage_adjustment:{a.id}", uuid=a.uuid, kind="OTHER", type_code=a.kind, title=title,
              raw_when=a.effective_at, sort_utc=a.effective_utc, bike_id=a.bike_id,
              component_id=a.component_id, detail=a.note or (tr(unit) if a.kind == "STARTING" else None),
              voided=bool(a.voided_at), void_reason=tr("replaced or removed") if a.voided_at else None)


# ---------------------------------------------------------------- public

def _filter(rows: list[dict], *, date_from: str | None, date_to: str | None, kinds: list[str] | None,
            include_voided: bool) -> list[dict]:
    out = []
    for r in rows:
        if date_from and r["date"] < date_from:
            continue
        if date_to and r["date"] > date_to:
            continue
        if kinds and r["kind"] not in kinds:
            continue
        if r["voided"] and not include_voided:
            continue
        out.append(r)
    return out


def _check_args(date_from: str | None, date_to: str | None, kinds: list[str] | None) -> None:
    from datetime import date
    for v in (date_from, date_to):
        if v:
            try:
                date.fromisoformat(v)
            except ValueError as e:
                raise DomainError(tr("Not a date: {v} (use YYYY-MM-DD)", v=repr(v))) from e
    if date_from and date_to and date_from > date_to:
        raise DomainError(tr("The start date is after the end date"))
    bad = [k for k in kinds or [] if k not in KINDS]
    if bad:
        raise DomainError(tr("Unknown entry type: {items}", items=', '.join(bad)))


def _result(rows: list[dict], *, date_from, date_to, kinds, include_voided, subject: dict) -> dict:
    rows.sort(key=lambda r: (r["sort_utc"], r["ref"]), reverse=True)    # newest first
    counts = {k: 0 for k in KINDS}
    voided = 0
    for r in _filter(rows, date_from=date_from, date_to=date_to, kinds=None, include_voided=True):
        if r["voided"]:
            voided += 1
            if not include_voided:
                continue
        counts[r["kind"]] += 1
    shown = _filter(rows, date_from=date_from, date_to=date_to, kinds=kinds, include_voided=include_voided)
    return {**subject, "kinds": [{"code": k, "label": v, "count": counts[k]} for k, v in KINDS.items()],
            "voided_count": voided, "total": len(rows), "rows": shown,
            "first_date": rows[-1]["date"] if rows else None, "last_date": rows[0]["date"] if rows else None}


def bike_timeline(session: Session, bike_id: int, *, date_from: str | None = None, date_to: str | None = None,
                  kinds: list[str] | None = None, include_voided: bool = False) -> dict:
    """Everything done on a bike, newest first, with the odometer (and the part's own km) at each entry."""
    _check_args(date_from, date_to, kinds)
    bike = get_bike(session, bike_id)
    b = _Builder(session, bike=bike)
    if bike.purchase_date:
        b.add(ref=f"bike:{bike.id}:bought", uuid=bike.uuid, kind="OTHER", type_code="BOUGHT", title=tr("Bike bought"),
              raw_when=bike.purchase_date, sort_utc=parse_when(bike.purchase_date, b.tz).utc, bike_id=bike.id,
              component_id=None, cost_cents=bike.purchase_price_cents, detail=bike.shop and tr("at {shop}", shop=bike.shop))
    _add_events(b, select(MaintenanceEvent).where(MaintenanceEvent.bike_id == bike.id))
    # parts directly on the bike, plus parts put on / taken off a part while that part was on this bike
    direct = list(session.scalars(select(Installation).where(Installation.bike_id == bike.id)))
    nested = []
    for i in session.scalars(select(Installation).where(Installation.parent_component_id.is_not(None))):
        on_install = _root_bike(session, i.parent_component_id, i.installed_utc) == bike.id
        on_removal = bool(i.removed_utc) and _root_bike(session, i.parent_component_id, i.removed_utc, at_end=True) == bike.id
        if on_install or on_removal:
            nested.append((i, on_install, on_removal))
    _add_installations(b, direct, merge_replacements=True)
    halves = {i.id: (on_install, on_removal) for i, on_install, on_removal in nested}
    before = len(b.rows)
    _add_installations(b, [i for i, _, _ in nested], merge_replacements=True)
    added = b.rows[before:]
    del b.rows[before:]
    for r in added:      # keep only the halves that happened while the parent part was on this bike
        on_install, on_removal = halves[int(r["ref"].split(":")[1])]
        if (r["type"] in ("INSTALLED", "REPLACED") and on_install) or (r["type"] == "REMOVED" and on_removal):
            r["bike_id"], r["bike"] = bike.id, bike.name
            b.rows.append(r)
    _add_journal(b, select(JournalEntry).where(JournalEntry.bike_id == bike.id))
    _add_adjustments(b, select(UsageAdjustment).where(UsageAdjustment.bike_id == bike.id), unit="odometer")
    return _result(b.rows, date_from=date_from, date_to=date_to, kinds=kinds, include_voided=include_voided,
                   subject={"subject": "BIKE", "bike_id": bike.id, "name": bike.name})


def component_timeline(session: Session, component_id: int, *, date_from: str | None = None,
                       date_to: str | None = None, kinds: list[str] | None = None,
                       include_voided: bool = False) -> dict:
    """Everything that happened to one physical part, newest first, with its own lifetime km (across bikes)
    and the odometer of the bike it was on at each entry."""
    _check_args(date_from, date_to, kinds)
    comp = get_component(session, component_id)
    b = _Builder(session, comp=comp)
    if comp.purchase_date:
        b.add(ref=f"component:{comp.id}:bought", uuid=comp.uuid, kind="OTHER", type_code="BOUGHT", title=tr("Bought"),
              raw_when=comp.purchase_date, sort_utc=parse_when(comp.purchase_date, b.tz).utc, bike_id=None,
              component_id=comp.id, cost_cents=comp.price_cents, detail=comp.shop and tr("at {shop}", shop=comp.shop))
    _add_events(b, select(MaintenanceEvent).where(MaintenanceEvent.component_id == comp.id))
    installs = list(session.scalars(select(Installation).where(Installation.component_id == comp.id)))
    _add_installations(b, installs, merge_replacements=False)
    removal_sessions = {i.removal_session_id for i in installs if i.removal_session_id}
    removal_days = {(i.removed_at or "")[:10] for i in installs if i.removed_at}
    for d in session.scalars(select(ComponentDisposition).where(ComponentDisposition.component_id == comp.id)):
        if d.disposition == "MOVED":
            continue
        if (d.work_session_id and d.work_session_id in removal_sessions) or (
                not d.work_session_id and d.effective_on in removal_days):
            continue    # the "Removed" row already says it
        b.add(ref=f"component_disposition:{d.id}", uuid=None, kind="OTHER", type_code=d.disposition,
              title=tr(DISPOSITIONS.get(d.disposition, d.disposition)), raw_when=d.effective_on,
              sort_utc=parse_when(d.effective_on, b.tz).utc, bike_id=None, component_id=comp.id, detail=d.note,
              voided=bool(d.voided_at), void_reason=tr("undone") if d.voided_at else None)
    _add_journal(b, select(JournalEntry).where(JournalEntry.component_id == comp.id))
    _add_adjustments(b, select(UsageAdjustment).where(UsageAdjustment.component_id == comp.id), unit="lifetime km")
    return _result(b.rows, date_from=date_from, date_to=date_to, kinds=kinds, include_voided=include_voided,
                   subject={"subject": "COMPONENT", "component_id": comp.id, "name": comp.label,
                            "component_type": comp.component_type})


# ---------------------------------------------------------------- CSV

CSV_COLUMNS = ["date", "time", "date_only", "kind", "type", "title", "detail", "bike", "bike_id", "part", "part_id",
               "part_type", "other_part", "other_part_id", "bike_km", "bike_km_status", "part_km", "part_km_status",
               "same_day_km", "cost_eur", "voided", "void_reason", "ride_id", "record", "record_uuid"]


def to_csv(result: dict, *, style: str = "excel") -> str:
    """CSV of a timeline, oldest first. ``excel``: semicolon and decimal comma (what Excel expects on a German
    Windows); ``standard``: comma and decimal point. Text with a byte order mark so Excel reads UTF-8.
    Dates are local dates; ``time`` is empty for entries recorded with a date only (no invented time)."""
    if style not in ("excel", "standard"):
        raise DomainError(tr("CSV style must be excel or standard"))
    sep, dec = (";", ",") if style == "excel" else (",", ".")

    def num(v: float | None, places: int = 1) -> str:
        return "" if v is None else f"{v:.{places}f}".replace(".", dec)

    buf = io.StringIO()
    w = csv.writer(buf, delimiter=sep, lineterminator="\r\n")
    w.writerow(CSV_COLUMNS)
    for r in sorted(result["rows"], key=lambda r: (r["sort_utc"], r["ref"])):
        w.writerow([r["date"], r["time"] or "", "yes" if r["date_only"] else "no", tr(KINDS[r["kind"]]), r["type"],
                    tr(r["title"]), r["detail"] or "", r["bike"] or "", r["bike_id"] or "", r["component"] or "",
                    r["component_id"] or "", r["component_type"] or "", r["other_component"] or "",
                    r["other_component_id"] or "", num(r["bike_km"]), r["bike_km_status"] or "",
                    num(r["part_km"]), r["part_km_status"] or "", num(r["same_day_km"]),
                    num(r["cost_cents"] / 100, 2) if r["cost_cents"] is not None else "",
                    "yes" if r["voided"] else "no", r["void_reason"] or "", r["ride_id"] or "",
                    r["ref"], r["uuid"] or ""])
    return "﻿" + buf.getvalue()


def csv_filename(result: dict) -> str:
    import re
    name = re.sub(r"[^A-Za-z0-9._-]+", "-", result["name"]).strip("-") or "timeline"
    return f"bikelog-timeline-{name}.csv"
