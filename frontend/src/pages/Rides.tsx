import { useEffect, useState } from "react";
import { Link, useSearchParams } from "react-router-dom";
import { api, newOpId } from "../api";
import { IncidentList, RideIncidents } from "../components/Incidents";
import Punctures from "../components/Punctures";
import {
  Card,
  ChangeNotice,
  Empty,
  ErrorBox,
  Field,
  FormError,
  Loading,
  Sheet,
  Tag,
} from "../components/ui";
import { useApp } from "../context";
import { duration, km, slotName, today, when } from "../format";
import { useApi } from "../hooks";
import type {
  Bike,
  Change,
  ComponentSummary,
  OpResult,
  RideDetail,
  RideRow,
} from "../types";
import { tr, codeText, trn } from '../i18n'

interface FormState {
  bike_id: string;
  date: string;
  time: string;
  distance: string;
  unit: "km" | "mi";
  minutes: string;
  name: string;
  sport_type: string;
  usage_profile_code: string;
  assignment_uncertain: boolean;
  uncertainty_note: string;
}

const empty = (bikeId?: number | null): FormState => ({
  bike_id: bikeId ? String(bikeId) : "",
  date: today(),
  time: "",
  distance: "",
  unit: "km",
  minutes: "",
  name: "",
  sport_type: tr('Ride'),
  usage_profile_code: "",
  assignment_uncertain: false,
  uncertainty_note: "",
});

function fromRide(r: RideRow): FormState {
  let time = "";
  if (r.start_time_utc) {
    const d = new Date(r.start_time_utc);
    time = d.toTimeString().slice(0, 5);
  }
  return {
    bike_id: r.bike_id ? String(r.bike_id) : "",
    date: r.ride_date,
    time,
    distance:
      r.distance_km !== null
        ? String(Math.round(r.distance_km * 1000) / 1000)
        : "",
    unit: "km",
    minutes: r.duration_s ? String(Math.round(r.duration_s / 60)) : "",
    name: r.name ?? "",
    sport_type: r.sport_type,
    usage_profile_code: r.usage_profile ?? "",
    assignment_uncertain: r.assignment_uncertain,
    uncertainty_note: r.uncertainty_note ?? "",
  };
}

/** Add or edit a ride. Bike + date + distance is enough. Entries survive a failed save. */
export function RideForm({
  ride,
  onSaved,
}: {
  ride?: RideRow;
  onSaved: (c: Change) => void;
}) {
  const { meta } = useApp();
  const bikes = useApi<Bike[]>("/bikes");
  const [f, setF] = useState<FormState>(() =>
    ride ? fromRide(ride) : empty(),
  );
  const [error, setError] = useState<string | null>(null);
  const [preview, setPreview] = useState<Change | null>(null);
  const [busy, setBusy] = useState(false);
  const [opId] = useState(newOpId);
  useEffect(() => {
    if (!ride && !f.bike_id && bikes.data?.length)
      setF((x) => ({
        ...x,
        bike_id: String(
          bikes.data!.find((b) => b.status === "ACTIVE")?.id ?? "",
        ),
      }));
  }, [bikes.data, ride, f.bike_id]);
  const set = <K extends keyof FormState>(k: K, v: FormState[K]) =>
    setF((x) => ({ ...x, [k]: v }));

  function body(): Record<string, unknown> {
    const whenValue = f.time ? `${f.date}T${f.time}` : f.date;
    const dist =
      f.distance.trim() === "" ? null : Number(f.distance.replace(",", "."));
    const common = {
      bike_id: f.bike_id ? Number(f.bike_id) : null,
      when: whenValue,
      duration_s: f.minutes ? Math.round(Number(f.minutes) * 60) : null,
      name: f.name || null,
      sport_type: f.sport_type,
      usage_profile_code: f.usage_profile_code || null,
      assignment_uncertain: f.assignment_uncertain,
      uncertainty_note: f.uncertainty_note || null,
    };
    return ride
      ? { ...common, distance_km: dist, unit: f.unit }
      : { ...common, distance: dist, unit: f.unit };
  }
  async function save(dry: boolean) {
    setBusy(true);
    setError(null);
    try {
      const r = ride
        ? await api.patch<OpResult<RideRow>>(
            `/rides/${ride.id}${dry ? "?dry_run=true" : ""}`,
            body(),
            dry ? undefined : opId,
          )
        : await api.post<OpResult<RideRow>>("/rides", body(), opId);
      if (dry) setPreview(r.change);
      else onSaved(r.change);
    } catch (e) {
      setError((e as Error).message);
    } finally {
      setBusy(false);
    }
  }
  return (
    <div className="form">
      <Field label={tr('Bike')}>
        <select
          value={f.bike_id}
          onChange={(e) => set("bike_id", e.target.value)}
        >
          <option value="">{tr('Unknown bike')}</option>
          {bikes.data?.map((b) => (
            <option key={b.id} value={b.id}>
              {b.name}
            </option>
          ))}
        </select>
      </Field>
      <div className="row">
        <Field label={tr('Date')}>
          <input
            type="date"
            value={f.date}
            onChange={(e) => set("date", e.target.value)}
          />
        </Field>
        <Field
          label={tr('Start time (optional)')}
          hint={tr('Leave empty if you don\'t know it.')}
        >
          <input
            type="time"
            value={f.time}
            onChange={(e) => set("time", e.target.value)}
          />
        </Field>
      </div>
      <div className="row">
        <Field label={tr('Distance')} hint={tr('Empty = unknown (not zero).')}>
          <input
            inputMode="decimal"
            value={f.distance}
            onChange={(e) => set("distance", e.target.value)}
            placeholder="42"
          />
        </Field>
        <Field label={tr('Unit')}>
          <select
            value={f.unit}
            onChange={(e) => set("unit", e.target.value as "km" | "mi")}
          >
            <option value="km">{tr('km')}</option>
            <option value="mi">{tr('mi')}</option>
          </select>
        </Field>
        <Field label={tr('Minutes (optional)')}>
          <input
            inputMode="numeric"
            value={f.minutes}
            onChange={(e) => set("minutes", e.target.value)}
          />
        </Field>
      </div>
      <Field label={tr('Name (optional)')}>
        <input value={f.name} onChange={(e) => set("name", e.target.value)} />
      </Field>
      <div className="row">
        <Field label={tr('Type')}>
          <select
            value={f.sport_type}
            onChange={(e) => set("sport_type", e.target.value)}
          >
            <option value="Ride">{tr('Outdoor ride')}</option>
            <option value="VirtualRide">{tr('Indoor / Zwift')}</option>
            <option value="GravelRide">{tr('Gravel')}</option>
          </select>
        </Field>
        <Field
          label={tr('Setup')}
          hint={tr('A trainer setup leaves removed parts (wheels, tires, pads) out.')}
        >
          <select
            value={f.usage_profile_code}
            onChange={(e) => set("usage_profile_code", e.target.value)}
          >
            <option value="">
              {f.sport_type === "VirtualRide" && !ride
                ? tr('Default trainer setup')
                : tr('Normal (outdoor)')}
            </option>
            {meta.profiles
              .filter((p) => p.kind === "TRAINER")
              .map((p) => (
                <option key={p.code} value={p.code}>
                  {p.name}
                </option>
              ))}
          </select>
        </Field>
      </div>
      <label className="check">
        <input
          type="checkbox"
          checked={f.assignment_uncertain}
          onChange={(e) => set("assignment_uncertain", e.target.checked)}
        />{" "}
        {tr('I\'m not sure about the bike or equipment')}
      </label>
      {f.assignment_uncertain && (
        <Field label={tr('What is uncertain?')}>
          <input
            value={f.uncertainty_note}
            onChange={(e) => set("uncertainty_note", e.target.value)}
            placeholder={tr('BMC or TIME?')}
          />
        </Field>
      )}
      <ChangeNotice change={preview} />
      <FormError error={error} />
      <div className="form-actions">
        {ride && (
          <button className="btn" disabled={busy} onClick={() => save(true)}>
            {tr('Preview mileage impact')}
          </button>
        )}
        <button
          className="btn btn-primary"
          disabled={busy}
          onClick={() => save(false)}
        >
          {busy ? tr('Saving…') : ride ? tr('Save changes') : tr('Add ride')}
        </button>
      </div>
    </div>
  );
}

function hours(h: number | null | undefined): string {
  if (h === null || h === undefined) return "—";
  return h ? duration(h * 3600) : "0 h";
}

// This ride, and its bike in total, this year and this month (km and recorded ride time).
function RideSummaryStats({ summary }: { summary: RideDetail["summary"] }) {
  const b = summary.bike;
  return (
    <div className="ride-stats">
      <div>
        <span className="muted small">{tr('This ride')}</span>
        <span className="stat">{km(summary.km)}</span>
        <span className="small">
          {summary.hours ? hours(summary.hours) : tr('no time recorded')}
        </span>
      </div>
      {b && (
        <>
          <div>
            <span className="muted small">{b.name} {tr('in total')}</span>
            <span className="stat">
              {b.starting_is_estimate ? "≈ " : ""}
              {km(b.total_km, 0)}
            </span>
            <span className="small" title={tr('Recorded ride time; km from before tracking have no hours')}>
              {hours(b.total_hours)}
            </span>
          </div>
          {[b.year, b.month].map((p) => (
            <div key={p.label}>
              <span className="muted small">{p.label}</span>
              <span className="stat">{km(p.km, 0)}</span>
              <span className="small">
                {hours(p.hours)} · {trn('{n} ride', '{n} rides', p.rides)}
              </span>
            </div>
          ))}
        </>
      )}
    </div>
  );
}

const NOTES_MAX = 2000;

// Free-text notes on a ride (up to 2000 characters). Never set or changed by a Strava or CSV import.
function RideNotes({
  id,
  notes,
  onSaved,
}: {
  id: number;
  notes: string | null;
  onSaved: () => void;
}) {
  const { toast } = useApp();
  const [text, setText] = useState<string | null>(null);
  const [err, setErr] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  async function save() {
    if (text === null) return;
    setErr(null);
    setBusy(true);
    try {
      await api.patch(`/rides/${id}`, { notes: text.trim() || null });
      toast(tr('Notes saved.'));
      setText(null);
      onSaved();
    } catch (e) {
      setErr((e as Error).message);
    } finally {
      setBusy(false);
    }
  }
  return (
    <section className="ride-section ride-notes">
      <div className="ride-section-head">
        <h3>{tr('Notes')}</h3>
        {text === null && (
          <button className="btn btn-small" onClick={() => setText(notes ?? "")}>
            {notes ? tr('Edit notes') : tr('Add notes')}
          </button>
        )}
      </div>
      {text === null ? (
        notes ? (
          <p className="ride-notes-text">{notes}</p>
        ) : (
          <p className="small muted">{tr('None yet.')}</p>
        )
      ) : (
        <div className="form">
          <Field
            label={tr('Notes')}
            hint={`${text.length} / ${NOTES_MAX} characters. Kept when Strava syncs again.`}
          >
            <textarea
              aria-label={tr('Ride notes')}
              rows={6}
              maxLength={NOTES_MAX}
              value={text}
              onChange={(e) => setText(e.target.value)}
              placeholder={tr('How it went, route, weather, what to check on the bike ...')}
              autoFocus
            />
          </Field>
          <FormError error={err} />
          <div className="form-actions">
            <button className="btn btn-primary" disabled={busy} onClick={save}>
              {tr('Save notes')}
            </button>
            <button className="btn" onClick={() => setText(null)}>
              {tr('Cancel')}
            </button>
          </div>
        </div>
      )}
    </section>
  );
}

export function RideDetailView({
  id,
  onChanged,
}: {
  id: number;
  onChanged: (c: Change | null) => void;
}) {
  const { meta } = useApp();
  const { data, error, loading, reload } = useApi<RideDetail>(`/rides/${id}`);
  const comps = useApi<ComponentSummary[]>("/components");
  const [editing, setEditing] = useState(false);
  const [err, setErr] = useState<string | null>(null);
  const [equip, setEquip] = useState({ slot: "CHAIN", component_id: "" });
  const [showParts, setShowParts] = useState(false);
  if (loading && !data) return <Loading />;
  if (error || !data)
    return <ErrorBox error={error ?? tr('not found')} onRetry={reload} />;
  if (editing)
    return (
      <RideForm
        ride={data}
        onSaved={(c) => {
          setEditing(false);
          reload();
          onChanged(c);
        }}
      />
    );
  async function act(
    path: string,
    body?: unknown,
    method: "post" | "put" | "del" = "post",
  ) {
    setErr(null);
    try {
      const r =
        method === "put"
          ? await api.put<OpResult<unknown>>(path, body)
          : method === "del"
            ? await api.del<OpResult<unknown>>(path)
            : await api.post<OpResult<unknown>>(path, body);
      reload();
      onChanged(r.change);
    } catch (e) {
      setErr((e as Error).message);
    }
  }
  async function setConditions(conditions: RideRow["conditions"]) {
    setErr(null);
    try {
      await api.patch(`/rides/${id}`, { conditions });
      reload();
      onChanged(null);
    } catch (e) {
      setErr((e as Error).message);
    }
  }
  const slots = [
    ...new Set(
      data.equipment
        .map((e) => e.slot)
        .concat(["CHAIN", "REAR_WHEEL", "FRONT_WHEEL"]),
    ),
  ];
  return (
    <div className="form ride-view">
      <header className="ride-summary">
        <p>
          <strong>{data.name || tr('Ride')}</strong> ·{" "}
          {when(data.start_time_utc ?? data.ride_date)}
          {data.date_only && (
            <Tag title={tr('No start time recorded')}>{tr('date only')}</Tag>
          )}{" "}
          · {km(data.distance_km)} · {duration(data.duration_s)} ·{" "}
          {data.bike ?? <Tag tone="warn">{tr('no bike')}</Tag>}
        </p>
        <p className="small muted">
          {tr('Source:')} {data.source_kind.toLowerCase()}
          {data.overridden_fields.length > 0 &&
            tr(' · locally corrected: {join}', { join: data.overridden_fields.join(", ") })}
          {data.usage_profile_name && tr(' · setup: {usage_profile_name}', { usage_profile_name: data.usage_profile_name })}
        </p>
        {data.inclusion === "EXCLUDED" && (
          <div className="notice">
            {tr('Removed (')}{data.exclusion_reason}{tr('). It counts no km and is never imported again from Strava or CSV. Restore it to count it again.')}
          </div>
        )}
        {data.flags.map((f, i) => (
          <div key={i} className="flag">
            <Tag tone="warn">{codeText(f.code)}</Tag>{" "}
            {f.detail}
          </div>
        ))}
      </header>
      <section className="ride-section">
        <div className="ride-section-head">
          <h3>{tr('Conditions')}</h3>
        </div>
        <div className="row conditions" role="group" aria-label={tr('Conditions')}>
          {[{ code: null, label: tr('not set') }, ...meta.ride_conditions].map(
            (c) => (
              <button
                key={c.code ?? "none"}
                className={`btn btn-small ${data.conditions === c.code ? "btn-primary" : ""}`}
                aria-pressed={data.conditions === c.code}
                onClick={() => setConditions(c.code as RideRow["conditions"])}
              >
                {c.label}
              </button>
            ),
          )}
        </div>
      </section>
      <RideNotes
        id={id}
        notes={data.notes}
        onSaved={() => {
          reload();
          onChanged(null);
        }}
      />
      <RideIncidents
        ride={data}
        onChanged={() => {
          reload();
          onChanged(null);
        }}
      />
      <section className="ride-section">
        <div className="ride-section-head">
          <h3>{tr('Distance and time')}</h3>
          <button
            className="btn btn-small"
            aria-expanded={showParts}
            onClick={() => setShowParts(!showParts)}
          >
            {showParts ? tr('Hide details') : tr('Show details')}
          </button>
        </div>
        <RideSummaryStats summary={data.summary} />
        {data.counting_note && <p className="notice">{data.counting_note}</p>}
        {showParts && (
          <div className="ride-parts">
            <h4>{tr('Distance and time given to parts')}</h4>
            {data.equipment.length === 0 ? (
              <p className="muted">{tr('No parts received mileage from this ride.')}</p>
            ) : (
              <table className="table">
                <thead>
                  <tr>
                    <th>{tr('Part')}</th>
                    <th>{tr('Slot')}</th>
                    <th>{tr('km')}</th>
                    <th>{tr('Hours')}</th>
                    <th>{tr('Basis')}</th>
                  </tr>
                </thead>
                <tbody>
                  {data.equipment.map((e) => (
                    <tr key={e.component_id}>
                      <td>
                        <Link to={`/inventory/${e.component_id}`}>{e.label}</Link>
                      </td>
                      <td>{slotName(e.slot)}</td>
                      <td>
                        {e.state === "COUNTED" ? (
                          km(e.km)
                        ) : (
                          <span className="muted">{tr('inside starting value')}</span>
                        )}
                      </td>
                      <td>{e.state === "COUNTED" ? hours(e.hours) : "—"}</td>
                      <td>
                        {e.basis === "EXPLICIT"
                          ? "confirmed"
                          : tr('installation history')}
                        {!e.certain && <Tag tone="warn">{tr('uncertain')}</Tag>}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
            <details>
              <summary>{tr('Confirm which part was used')}</summary>
              <div className="row">
                <Field label={tr('Slot')}>
                  <select
                    value={equip.slot}
                    onChange={(e) => setEquip({ ...equip, slot: e.target.value })}
                  >
                    {slots.map((s) => (
                      <option key={s} value={s}>
                        {slotName(s)}
                      </option>
                    ))}
                  </select>
                </Field>
                <Field label={tr('Part')}>
                  <select
                    value={equip.component_id}
                    onChange={(e) =>
                      setEquip({ ...equip, component_id: e.target.value })
                    }
                  >
                    <option value="">{tr('None used')}</option>
                    {comps.data
                      ?.filter((c) => c.status === "ACTIVE")
                      .map((c) => (
                        <option key={c.id} value={c.id}>
                          {c.label} ({c.type_name})
                        </option>
                      ))}
                  </select>
                </Field>
              </div>
              <div className="form-actions">
                <button
                  className="btn"
                  onClick={() =>
                    act(
                      `/rides/${id}/equipment/${equip.slot}`,
                      {
                        component_id: equip.component_id
                          ? Number(equip.component_id)
                          : null,
                      },
                      "put",
                    )
                  }
                >
                  {tr('Confirm')}
                </button>
                {data.explicit_equipment.map((e) => (
                  <button
                    key={e.slot}
                    className="btn btn-small"
                    onClick={() =>
                      act(`/rides/${id}/equipment/${e.slot}`, undefined, "del")
                    }
                  >
                    {tr('Back to history for')} {slotName(e.slot)}
                  </button>
                ))}
              </div>
            </details>
          </div>
        )}
      </section>
      <FormError error={err} />
      <div className="form-actions ride-actions">
        <button className="btn" onClick={() => setEditing(true)}>
          {tr('Edit ride')}
        </button>
        {data.inclusion === "INCLUDED" ? (
          <button
            className="btn btn-danger"
            title={tr('Moves it to Removed rides: it counts no km and is never imported again. You can restore it.')}
            onClick={() =>
              act(`/rides/${id}/exclude`, { reason: tr('removed by user') })
            }
          >
            {tr('Remove ride')}
          </button>
        ) : (
          <button className="btn" onClick={() => act(`/rides/${id}/restore`)}>
            {tr('Restore')}
          </button>
        )}
      </div>
    </div>
  );
}

const RIDE_TABS: [string, string][] = [
  ["active", tr('Rides')],
  ["unassigned", tr('No bike')],
  ["removed", tr('Removed rides')],
  ["incidents", tr('Incidents')],
  ["punctures", tr('Punctures')],
];

function BikeSelect({
  value,
  bikes,
  onChange,
  label,
}: {
  value: number | null;
  bikes: Bike[];
  onChange: (id: number | null) => void;
  label: string;
}) {
  return (
    <select
      aria-label={label}
      value={value ?? ""}
      onClick={(e) => e.stopPropagation()}
      onChange={(e) => onChange(e.target.value ? Number(e.target.value) : null)}
    >
      <option value="">{tr('— no bike —')}</option>
      {bikes.map((b) => (
        <option key={b.id} value={b.id}>
          {b.name}
          {b.status === "RETIRED" ? tr(' (retired)') : ""}
        </option>
      ))}
    </select>
  );
}

// Rides → tick rides → Remove rides (Dirk 2026-11-02, DECISIONS 124): the same soft removal as one ride.
// The sheet shows the count, the km and (from a dry run) what that does to each part before you confirm.
function RemoveRides({
  ids,
  rows,
  onClose,
  onDone,
}: {
  ids: number[];
  rows: RideRow[];
  onClose: () => void;
  onDone: (msg: string) => void;
}) {
  const [preview, setPreview] = useState<string | null>(null);
  const [err, setErr] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [opId] = useState(newOpId);
  const total = rows.reduce((a, r) => a + (r.distance_km ?? 0), 0);
  const idKey = ids.join(",");
  useEffect(() => {
    api
      .post<OpResult<unknown>>("/rides/remove?dry_run=true", {
        ride_ids: idKey.split(",").map(Number),
      })
      .then((r) => setPreview(r.change?.notice ?? ""))
      .catch((e) => setErr((e as Error).message));
  }, [idKey]);
  async function go() {
    setBusy(true);
    try {
      const r = await api.post<OpResult<{ removed: number; km: number }>>(
        "/rides/remove",
        { ride_ids: ids, reason: tr('removed by user') },
        opId,
      );
      onDone(
        trn('{n} ride removed ({km}). {x2}', '{n} rides removed ({km}). {x2}', r.result.removed, { km: km(r.result.km), x2: r.change?.notice ?? "" }),
      );
    } catch (e) {
      setErr((e as Error).message);
      setBusy(false);
    }
  }
  const n = ids.length;
  return (
    <Sheet title={n === 1 ? tr('Remove 1 ride') : tr('Remove {n} rides', { n })} onClose={onClose}>
      <div className="remove-rides">
        <p>
          <strong>
            {trn('{n} ride', '{n} rides', n)} · {km(total)}
          </strong>
        </p>
        <p className="small muted">
          {tr('They move to Removed rides: they count no km for the bike and its parts and are never imported again from Strava or a CSV file. You can restore them there at any time.')}
        </p>
        {preview === null && !err && <Loading what={tr('Working out the km change')} />}
        {preview && <p className="small remove-preview">{preview.replace(/^Preview: /, "")}</p>}
        <FormError error={err} />
        <div className="form-actions">
          <button className="btn btn-danger" disabled={busy} onClick={go}>
            {n === 1 ? tr('Remove ride') : tr('Remove {n} rides', { n })}
          </button>
          <button className="btn" onClick={onClose}>
            {tr('Cancel')}
          </button>
        </div>
      </div>
    </Sheet>
  );
}

export default function RidesPage() {
  const { toast } = useApp();
  const [params, setParams] = useSearchParams();
  const tab = params.get("tab") ?? "active";
  const [bike, setBike] = useState("");
  const [flagged, setFlagged] = useState(false);
  const [selected, setSelected] = useState<Set<number>>(new Set());
  const [bulkBike, setBulkBike] = useState<number | null>(null);
  const [removing, setRemoving] = useState<number[] | null>(null);
  const bikes = useApi<Bike[]>("/bikes");
  const query = `/rides?limit=300&view=${tab === "removed" ? "removed" : "active"}${tab === "unassigned" ? "&unassigned=true" : ""}${bike && tab !== "unassigned" ? `&bike_id=${bike}` : ""}${flagged ? "&flagged=true" : ""}`;
  const { data, error, loading, reload } = useApi<RideRow[]>(query);
  const [adding, setAdding] = useState(false);
  const open = params.get("open");
  const go = (next: Record<string, string>) =>
    setParams({ ...(tab !== "active" ? { tab } : {}), ...next });
  const close = () => go({});
  const changed = (c: Change | null) => {
    if (c?.notice) toast(c.notice);
    reload();
  };
  useEffect(() => setSelected(new Set()), [query]);

  async function assign(ids: number[], bikeId: number | null) {
    try {
      const r = await api.post<OpResult<{ changed: number }>>(
        "/rides/assign-bike",
        { ride_ids: ids, bike_id: bikeId },
        newOpId(),
      );
      const name = bikeId
        ? bikes.data?.find((b) => b.id === bikeId)?.name
        : null;
      toast(
        trn('{n} ride {x2}. {x3}', '{n} rides {x2}. {x3}', r.result.changed, { x2: name ? tr('assigned to {name}', { name }) : tr('now without a bike'), x3: r.change?.notice ?? "" }),
      );
      setSelected(new Set());
      reload();
    } catch (e) {
      toast((e as Error).message);
    }
  }
  async function restoreMany(ids: number[]) {
    try {
      const r = await api.post<OpResult<{ restored: number; km: number }>>(
        "/rides/restore",
        { ride_ids: ids },
        newOpId(),
      );
      toast(
        trn('{n} ride restored ({km}). {x2}', '{n} rides restored ({km}). {x2}', r.result.restored, { km: km(r.result.km), x2: r.change?.notice ?? "" }),
      );
      setSelected(new Set());
      reload();
    } catch (e) {
      toast((e as Error).message);
    }
  }
  async function restore(id: number) {
    try {
      const r = await api.post<OpResult<unknown>>(`/rides/${id}/restore`, {});
      toast(r.change?.notice ?? tr('Restored.'));
      reload();
    } catch (e) {
      toast((e as Error).message);
    }
  }
  const toggle = (id: number) => {
    const next = new Set(selected);
    if (next.has(id)) next.delete(id);
    else next.add(id);
    setSelected(next);
  };
  const allBikes = bikes.data ?? [];
  // in Removed rides only rides you removed can be ticked (a ride deleted at the source stays out)
  const selectable = (data ?? []).filter(
    (r) => tab !== "removed" || r.inclusion === "EXCLUDED",
  );
  return (
    <Card
      title={tr('Rides')}
      actions={
        <button className="btn btn-primary" onClick={() => setAdding(true)}>
          {tr('Add ride')}
        </button>
      }
    >
      <div className="tabs" role="tablist">
        {RIDE_TABS.map(([k, l]) => (
          <button
            key={k}
            role="tab"
            aria-selected={tab === k}
            className={`tab ${tab === k ? "tab-on" : ""}`}
            onClick={() => setParams(k === "active" ? {} : { tab: k })}
          >
            {l}
          </button>
        ))}
      </div>
      {tab === "removed" && (
        <p className="small muted">
          {tr('Removed rides count no kilometres and are never imported again from Strava or a CSV file. Restore one to count it again.')}
        </p>
      )}
      {tab === "unassigned" && (
        <p className="small muted">
          {tr('Rides without a bike count for no part. Pick the bike for each ride, or tick several and assign them together.')}
        </p>
      )}
      {tab === "incidents" && <IncidentList bikes={allBikes} />}
      {tab === "punctures" && <Punctures />}
      {tab !== "incidents" && tab !== "punctures" && (
        <>
          <div className="filters">
            {tab !== "unassigned" && (
              <select
                value={bike}
                onChange={(e) => setBike(e.target.value)}
                aria-label={tr('Filter by bike')}
              >
                <option value="">{tr('All bikes')}</option>
                {allBikes.map((b) => (
                  <option key={b.id} value={b.id}>
                    {b.name}
                  </option>
                ))}
              </select>
            )}
            <label className="check">
              <input
                type="checkbox"
                checked={flagged}
                onChange={(e) => setFlagged(e.target.checked)}
              />{" "}
              {tr('Only rides to review')}
            </label>
          </div>
          {tab === "removed" && selected.size > 0 && (
            <div className="bulk-bar">
              <span>{selected.size} {tr('selected')}</span>
              <button
                className="btn btn-primary btn-small"
                onClick={() => restoreMany([...selected])}
              >
                {tr('Restore rides')}
              </button>
              <button
                className="btn btn-small"
                onClick={() => setSelected(new Set())}
              >
                {tr('Clear')}
              </button>
            </div>
          )}
          {tab !== "removed" && selected.size > 0 && (
            <div className="bulk-bar">
              <span>{selected.size} {tr('selected')}</span>
              <BikeSelect
                label={tr('Bike for selected rides')}
                value={bulkBike}
                bikes={allBikes.filter((b) => b.status === "ACTIVE")}
                onChange={setBulkBike}
              />
              <button
                className="btn btn-primary btn-small"
                onClick={() => assign([...selected], bulkBike)}
              >
                {bulkBike ? tr('Assign bike') : tr('Remove bike')}
              </button>
              <button
                className="btn btn-danger btn-small"
                onClick={() => setRemoving([...selected])}
              >
                {tr('Remove rides')}
              </button>
              <button
                className="btn btn-small"
                onClick={() => setSelected(new Set())}
              >
                {tr('Clear')}
              </button>
            </div>
          )}
          {loading && !data && <Loading what={tr('Loading rides')} />}
          {error && <ErrorBox error={error} onRetry={reload} />}
          {data && data.length === 0 && (
            <Empty
              title={
                tab === "removed"
                  ? tr('No removed rides')
                  : tab === "unassigned"
                    ? tr('Every ride has a bike')
                    : flagged
                      ? tr('No rides need review')
                      : tr('No rides yet')
              }
            >
              {tab === "active" &&
                !flagged &&
                tr('Add a ride (bike, date and distance are enough), import a CSV or connect Strava under Settings.')}
            </Empty>
          )}
          {data && data.length > 0 && (
            <table className="table rides">
              <thead>
                <tr>
                  {(
                    <th>
                      <input
                        type="checkbox"
                        aria-label={tr('Select all rides')}
                        checked={selected.size > 0 && selected.size === selectable.length}
                        onChange={(e) =>
                          setSelected(
                            e.target.checked
                              ? new Set(selectable.map((r) => r.id))
                              : new Set(),
                          )
                        }
                      />
                    </th>
                  )}
                  <th>{tr('Date')}</th>
                  <th>{tr('Name')}</th>
                  <th>{tr('Bike')}</th>
                  <th className="num">{tr('Distance')}</th>
                  <th>{tr('Notes')}</th>
                </tr>
              </thead>
              <tbody>
                {data.map((r) => (
                  <tr
                    key={r.id}
                    className={r.removed ? "excluded" : ""}
                    onClick={() => go({ open: String(r.id) })}
                  >
                    {(
                      <td onClick={(e) => e.stopPropagation()}>
                        <input
                          type="checkbox"
                          disabled={tab === "removed" && r.inclusion !== "EXCLUDED"}
                          aria-label={tr('Select {x} {ride_date}', { x: r.name || "ride", ride_date: r.ride_date })}
                          checked={selected.has(r.id)}
                          onChange={() => toggle(r.id)}
                        />
                      </td>
                    )}
                    <td>{when(r.start_time_utc ?? r.ride_date)}</td>
                    <td>
                      <button className="linklike">{r.name || tr('Ride')}</button>
                    </td>
                    <td onClick={(e) => e.stopPropagation()}>
                      {r.removed ? (
                        (r.bike ?? "—")
                      ) : (
                        <BikeSelect
                          label={tr('Bike for {x} {ride_date}', { x: r.name || "ride", ride_date: r.ride_date })}
                          value={r.bike_id}
                          bikes={allBikes}
                          onChange={(id) => assign([r.id], id)}
                        />
                      )}
                      {r.bike_overridden && (
                        <span
                          className="small muted"
                          title={tr('Your choice is kept when Strava or a CSV import is read again.')}
                        >
                          {" "}
                          {tr('changed by you ·')} {r.source_kind.toLowerCase()}:{" "}
                          {r.source_bike ?? tr('no bike')}
                        </span>
                      )}
                      {!r.bike_id && !r.bike_overridden && r.uncertainty_note && (
                        <span className="small muted"> {r.uncertainty_note}</span>
                      )}
                    </td>
                    <td className="num">{km(r.distance_km)}</td>
                    <td>
                      {r.removed && (
                        <Tag>
                          {r.status === "SOURCE_DELETED"
                            ? tr('deleted at source')
                            : "removed"}
                        </Tag>
                      )}
                      {r.removed && r.inclusion === "EXCLUDED" && (
                        <button
                          className="btn btn-small"
                          onClick={(e) => {
                            e.stopPropagation();
                            restore(r.id);
                          }}
                        >
                          {tr('Restore')}
                        </button>
                      )}
                      {r.sport_type === "VirtualRide" && (
                        <Tag tone="info">{tr('indoor')}</Tag>
                      )}
                      {r.conditions === "WET" && <Tag tone="info">{tr('wet')}</Tag>}
                      {r.incidents > 0 && (
                        <Tag tone="bad">
                          {r.incidents === 1
                            ? tr('1 incident')
                            : `${r.incidents} incidents`}
                        </Tag>
                      )}
                      {r.source_kind !== "MANUAL" && (
                        <Tag>{r.source_kind.toLowerCase()}</Tag>
                      )}
                      {r.notes && (
                        <span className="small muted ride-note-snippet" title={r.notes}>
                          {" "}
                          {r.notes.length > 60 ? `${r.notes.slice(0, 60)}…` : r.notes}
                        </span>
                      )}
                      {r.flags.map((f, i) => (
                        <Tag key={i} tone="warn" title={f.detail}>
                          {codeText(f.code)}
                        </Tag>
                      ))}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </>
      )}
      {removing && (
        <RemoveRides
          ids={removing}
          rows={(data ?? []).filter((r) => removing.includes(r.id))}
          onClose={() => setRemoving(null)}
          onDone={(msg) => {
            setRemoving(null);
            setSelected(new Set());
            toast(msg);
            reload();
          }}
        />
      )}
      {adding && (
        <Sheet title={tr('Add ride')} onClose={() => setAdding(false)}>
          <RideForm
            onSaved={(c) => {
              setAdding(false);
              changed(c);
            }}
          />
        </Sheet>
      )}
      {open && (
        <Sheet title={tr('Ride')} onClose={close}>
          <RideDetailView id={Number(open)} onChanged={changed} />
        </Sheet>
      )}
    </Card>
  );
}
