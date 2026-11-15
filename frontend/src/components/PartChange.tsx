// Replace, remove, move and "what happened to it" forms. Each one asks for the effective date and
// keeps what was typed after a recoverable error. The server records each step as its own
// transaction inside one work session, which the Inventory history can undo as a whole.
import { useEffect, useState } from 'react'
import { api, newOpId } from '../api'
import { useApp } from '../context'
import { today, usageText } from '../format'
import { useApi } from '../hooks'
import type { Change, OpResult } from '../types'
import { ChangeNotice, Empty, ErrorBox, Field, FormError, Loading, Tag } from './ui'
import { tr } from '../i18n'

export interface Disposition {
  code: string
  label: string
}

interface SpareRow {
  id: number
  label: string
  product: string | null
  state_text: string
  readiness: string | null
  readiness_text: string | null
  usage: { total_km: number } & Parameters<typeof usageText>[0]
  storage_location: string | null
  mark: string | null
  fit: 'VERIFIED' | 'UNVERIFIED' | 'SAME_PRODUCT' | 'UNKNOWN'
  mounted: { component_id: number; label: string; slot: string }[]
}

interface StockRow {
  id: number
  name: string
  unit: string
  unit_note: string | null
  stock: { qty: number } | null
  storage_location: string | null
  fit: SpareRow['fit']
}

interface ReplaceOptions {
  component: { id: number; label: string; type_name: string; component_type: string; product: string | null; product_id: number | null }
  location: { text: string; slot?: string; bike?: string | null }
  suggested_outcome: string
  outcomes: Disposition[]
  spares: SpareRow[]
  stock: StockRow[]
  children: { component_id: number; label: string; type_name: string; slot: string; carry_over: boolean; note: string | null }[]
}

const FIT_TEXT: Record<SpareRow['fit'], [string, 'good' | 'info' | 'warn' | 'neutral']> = {
  VERIFIED: [tr('verified fit for this bike'), 'good'],
  UNVERIFIED: [tr('listed for this bike, not verified'), 'warn'],
  SAME_PRODUCT: [tr('same product as the old part'), 'info'],
  UNKNOWN: [tr('compatibility not recorded'), 'neutral'],
}

export function FitTag({ fit }: { fit: SpareRow['fit'] }) {
  const [text, tone] = FIT_TEXT[fit]
  return <Tag tone={tone}>{text}</Tag>
}

export function OutcomeChoice({ outcomes, value, suggested, onChange, name }: { outcomes: Disposition[]; value: string; suggested: string; onChange: (v: string) => void; name: string }) {
  return (
    <fieldset className="field">
      <legend className="field-label">{tr('What happened to the old item?')}</legend>
      <div className="chips">
        {outcomes.map((o) => (
          <label key={o.code} className={`chip ${value === o.code ? 'chip-on' : ''}`}>
            <input type="radio" name={name} value={o.code} checked={value === o.code} onChange={() => onChange(o.code)} className="sr-only" />
            {o.label}
            {o.code === suggested && <span className="muted small"> {tr('· suggested')}</span>}
          </label>
        ))}
      </div>
      <span className="field-hint">{tr('Its record, mileage and history are always kept, also when discarded.')}</span>
    </fieldset>
  )
}

type Source = { kind: 'spare'; id: number } | { kind: 'stock'; id: number } | { kind: 'same' } | { kind: 'new' }

export function ReplaceForm({ componentId, onDone }: { componentId: number; onDone: (c: Change, label: string) => void }) {
  const opts = useApi<ReplaceOptions>(`/components/${componentId}/replace-options`)
  const products = useApi<{ id: number; maker: string | null; model: string }[]>(opts.data ? `/products?component_type=${opts.data.component.component_type}` : null)
  const [source, setSource] = useState<Source | null>(null)
  const [f, setF] = useState({ at: today(), reason: '', outcome: '', label: '', product_id: '', price: '' })
  const [preview, setPreview] = useState<Change | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [opId] = useState(newOpId)
  const [carry, setCarry] = useState<Set<number> | null>(null)
  useEffect(() => {
    const d = opts.data
    if (!d) return
    setF((x) => (x.outcome ? x : { ...x, outcome: d.suggested_outcome }))
    setSource((s) => s ?? (d.stock[0] ? { kind: 'stock', id: d.stock[0].id } : d.spares[0] ? { kind: 'spare', id: d.spares[0].id } : { kind: 'same' }))
  }, [opts.data])
  // A spare that brings its own parts (a stored wheelset with its wheels, a spare wheel with its tire)
  // keeps them: the old part's children whose position is taken there stay behind by default.
  const spare = source?.kind === 'spare' ? opts.data?.spares.find((s) => s.id === source.id) : undefined
  const taken = new Map((spare?.mounted ?? []).map((m) => [m.slot, m.label]))
  const sourceKey = source ? `${source.kind}${'id' in source ? source.id : ''}` : ''
  useEffect(() => {
    const d = opts.data
    if (!d || !sourceKey) return
    const s = sourceKey.startsWith('spare') ? d.spares.find((x) => `spare${x.id}` === sourceKey) : undefined
    const busySlots = new Set((s?.mounted ?? []).map((m) => m.slot))
    setCarry(new Set(d.children.filter((x) => x.carry_over && !busySlots.has(x.slot)).map((x) => x.component_id)))
  }, [opts.data, sourceKey])
  if (opts.loading && !opts.data) return <Loading />
  if (opts.error) return <ErrorBox error={opts.error} onRetry={opts.reload} />
  const d = opts.data
  if (!d || !source) return null
  const body = () => {
    const b: Record<string, unknown> = { at: f.at, reason: f.reason || null, old_outcome: f.outcome, carry_over: [...(carry ?? [])] }
    if (source.kind === 'spare') b.new_component_id = source.id
    if (source.kind === 'stock') b.from_stock_id = source.id
    if (source.kind === 'same') {
      b.same_product = true
      if (f.price) b.new = { price_cents: Math.round(Number(f.price.replace(',', '.')) * 100) }
    }
    if (source.kind === 'new') b.new = { label: f.label || null, product_id: f.product_id ? Number(f.product_id) : null, price_cents: f.price ? Math.round(Number(f.price.replace(',', '.')) * 100) : null }
    return b
  }
  async function run(dry: boolean) {
    setError(null)
    setBusy(true)
    try {
      const r = await api.post<OpResult<{ new_label: string }>>(`/components/${componentId}/replace${dry ? '?dry_run=true' : ''}`, body(), dry ? undefined : opId)
      if (dry) setPreview(r.change)
      else onDone(r.change, r.result.new_label)
    } catch (e) {
      setError((e as Error).message)
      setPreview(null)
    } finally {
      setBusy(false)
    }
  }
  const is = (k: Source['kind'], id?: number) => source.kind === k && (id === undefined || ('id' in source && source.id === id))
  return (
    <div className="form">
      <p className="small">
        {tr('Outgoing:')} <strong>{d.component.label}</strong> {d.component.product && <span className="muted">({d.component.product})</span>} · {d.location.text}
      </p>
      <fieldset className="field">
        <legend className="field-label">{tr('Install instead')}</legend>
        <div className="pick-list">
          {d.stock.map((s) => (
            <label key={`s${s.id}`} className={`pick ${is('stock', s.id) ? 'pick-on' : ''}`}>
              <input type="radio" name="src" checked={is('stock', s.id)} onChange={() => setSource({ kind: 'stock', id: s.id })} />
              <span>
                <strong>{tr('One from stock:')} {s.name}</strong>
                <span className="small muted">
                  {' '}
                  {s.stock?.qty ?? 0} {s.unit}
                  {tr('left')}{s.storage_location ? ` · ${s.storage_location}` : ''}
                </span>
                <br />
                <FitTag fit={s.fit} />
              </span>
            </label>
          ))}
          {d.spares.map((s) => (
            <label key={`c${s.id}`} className={`pick ${is('spare', s.id) ? 'pick-on' : ''}`}>
              <input type="radio" name="src" checked={is('spare', s.id)} onChange={() => setSource({ kind: 'spare', id: s.id })} />
              <span>
                <strong>{s.label}</strong> <span className="small muted">{s.product ?? ''}</span>
                <br />
                <span className="small">
                  {s.state_text} · {s.readiness_text} · {usageText(s.usage)} {tr('lifetime')}
                  {s.mounted.length > 0 && tr(' · comes with {join}', { join: s.mounted.map((m) => m.label).join(', ') })}
                </span>{' '}
                <FitTag fit={s.fit} />
                {s.readiness !== 'READY' && <Tag tone="warn">{tr('not ready')}</Tag>}
              </span>
            </label>
          ))}
          <label className={`pick ${is('same') ? 'pick-on' : ''}`}>
            <input type="radio" name="src" checked={is('same')} onChange={() => setSource({ kind: 'same' })} />
            <span>
              <strong>{tr('New item, same product')}</strong>
              <span className="small muted"> {tr('· a new physical part')}{d.component.product ? ` (${d.component.product})` : ''}</span>
            </span>
          </label>
          <label className={`pick ${is('new') ? 'pick-on' : ''}`}>
            <input type="radio" name="src" checked={is('new')} onChange={() => setSource({ kind: 'new' })} />
            <span>
              <strong>{tr('Newly bought item')}</strong>
              <span className="small muted"> {tr('· name, product and price are optional')}</span>
            </span>
          </label>
        </div>
      </fieldset>
      {source.kind === 'same' && (
        <div className="row">
          <Field label={tr('Price € (optional)')}>
            <input inputMode="decimal" value={f.price} onChange={(e) => setF({ ...f, price: e.target.value })} />
          </Field>
        </div>
      )}
      {source.kind === 'new' && (
        <div className="row">
          <Field label={tr('Name (optional)')}>
            <input value={f.label} onChange={(e) => setF({ ...f, label: e.target.value })} placeholder={`${d.component.label} (2)`} />
          </Field>
          <Field label={tr('Product (optional)')}>
            <select value={f.product_id} onChange={(e) => setF({ ...f, product_id: e.target.value })}>
              <option value="">{tr('Not recorded')}</option>
              {products.data?.map((p) => (
                <option key={p.id} value={p.id}>
                  {[p.maker, p.model].filter(Boolean).join(' ')}
                </option>
              ))}
            </select>
          </Field>
          <Field label={tr('Price € (optional)')}>
            <input inputMode="decimal" value={f.price} onChange={(e) => setF({ ...f, price: e.target.value })} />
          </Field>
        </div>
      )}
      <div className="row">
        <Field label={tr('Installed on')}>
          <input type="date" value={f.at} onChange={(e) => setF({ ...f, at: e.target.value })} />
        </Field>
        <Field label={tr('Removal reason (optional)')}>
          <input value={f.reason} onChange={(e) => setF({ ...f, reason: e.target.value })} placeholder={tr('puncture, worn, rotation…')} />
        </Field>
      </div>
      <OutcomeChoice name="replace-outcome" outcomes={d.outcomes} value={f.outcome} suggested={d.suggested_outcome} onChange={(v) => setF({ ...f, outcome: v })} />
      {d.children.length > 0 && (
        <fieldset className="field">
          <legend className="field-label">{tr('Parts on {label}: move them to the new one?', { label: d.component.label })}</legend>
          {d.children.map((c) => (
            <label key={c.component_id} className="check">
              <input
                type="checkbox"
                aria-label={tr('Move {label} to the new part', { label: c.label })}
                checked={carry?.has(c.component_id) ?? false}
                onChange={(e) => {
                  const next = new Set(carry ?? [])
                  if (e.target.checked) next.add(c.component_id)
                  else next.delete(c.component_id)
                  setCarry(next)
                }}
              />{' '}
              {c.label} <span className="small muted">({c.type_name}){c.note ? ` · ${c.note}` : ''}{taken.has(c.slot) ? tr(' · {label} already has {get} there', { label: spare?.label, get: taken.get(c.slot) }) : ''}</span>
            </label>
          ))}
          <p className="small muted">{tr('Ticked parts move over and keep their own km. Unticked parts stay with the old part.')}</p>
          {taken.size > 0 && <p className="small muted">{tr('{spare} comes with its own parts, so the parts on {label} stay with it.', { spare: spare?.label, label: d.component.label })}</p>}
        </fieldset>
      )}
      <ChangeNotice change={preview} />
      <FormError error={error} />
      <div className="form-actions">
        <button className="btn" disabled={busy} onClick={() => run(true)}>
          {tr('Preview')}
        </button>
        <button className="btn btn-primary" disabled={busy} onClick={() => run(false)}>
          {tr('Replace')}
        </button>
      </div>
    </div>
  )
}

export function RemoveForm({ componentId, suggested, onDone }: { componentId: number; suggested: string; onDone: (c: Change) => void }) {
  const { meta } = useApp()
  const [f, setF] = useState({ at: today(), reason: '', outcome: suggested === 'DISCARDED' ? 'DISCARDED' : 'STORED' })
  const [preview, setPreview] = useState<Change | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [opId] = useState(newOpId)
  async function run(dry: boolean) {
    setError(null)
    try {
      const r = await api.post<OpResult<unknown>>(`/components/${componentId}/remove${dry ? '?dry_run=true' : ''}`, { at: f.at, reason: f.reason || null, outcome: f.outcome }, dry ? undefined : opId)
      if (dry) setPreview(r.change)
      else onDone(r.change)
    } catch (e) {
      setError((e as Error).message)
    }
  }
  return (
    <div className="form">
      <div className="row">
        <Field label={tr('Removed on')}>
          <input type="date" value={f.at} onChange={(e) => setF({ ...f, at: e.target.value })} />
        </Field>
        <Field label={tr('Reason (optional)')}>
          <input value={f.reason} onChange={(e) => setF({ ...f, reason: e.target.value })} />
        </Field>
      </div>
      <OutcomeChoice name="remove-outcome" outcomes={meta.dispositions} value={f.outcome} suggested={suggested} onChange={(v) => setF({ ...f, outcome: v })} />
      <ChangeNotice change={preview} />
      <FormError error={error} />
      <div className="form-actions">
        <button className="btn" onClick={() => run(true)}>
          {tr('Preview')}
        </button>
        <button className="btn btn-primary" onClick={() => run(false)}>
          {tr('Remove')}
        </button>
      </div>
    </div>
  )
}

interface MoveTarget {
  parent_component_id: number | null
  bike_id: number | null
  slot: string
  text: string
  occupied_by: string | null
}

export function MoveForm({ componentId, onDone }: { componentId: number; onDone: (c: Change) => void }) {
  const targets = useApi<MoveTarget[]>(`/components/${componentId}/move-targets`)
  const [pick, setPick] = useState(0)
  const [at, setAt] = useState(today())
  const [error, setError] = useState<string | null>(null)
  const [opId] = useState(newOpId)
  if (targets.loading && !targets.data) return <Loading />
  if (targets.error) return <ErrorBox error={targets.error} onRetry={targets.reload} />
  if (!targets.data?.length) return <Empty title={tr('No other position on this bike')}>{tr('Use Replace or Remove instead.')}</Empty>
  const t = targets.data[pick]
  async function run() {
    setError(null)
    try {
      const r = await api.post<OpResult<unknown>>(`/components/${componentId}/move`, { at, bike_id: t.bike_id, parent_component_id: t.parent_component_id, slot: t.slot, swap: !!t.occupied_by }, opId)
      onDone(r.change)
    } catch (e) {
      setError((e as Error).message)
    }
  }
  return (
    <div className="form">
      <p className="small muted">{tr('A position change keeps the part\'s identity and its kilometres.')}</p>
      <Field label={tr('Move to')}>
        <select value={pick} onChange={(e) => setPick(Number(e.target.value))}>
          {targets.data.map((x, i) => (
            <option key={i} value={i}>
              {x.text}
              {x.occupied_by ? tr(' (swap with {occupied_by})', { occupied_by: x.occupied_by }) : ''}
            </option>
          ))}
        </select>
      </Field>
      <Field label={tr('On')}>
        <input type="date" value={at} onChange={(e) => setAt(e.target.value)} />
      </Field>
      <FormError error={error} />
      <div className="form-actions">
        <button className="btn btn-primary" onClick={run}>
          {t.occupied_by ? tr('Swap positions') : tr('Move')}
        </button>
      </div>
    </div>
  )
}

export function DispositionForm({ componentId, current, onDone }: { componentId: number; current: string; onDone: () => void }) {
  const { meta } = useApp()
  const [f, setF] = useState({ on: today(), disposition: current === 'STORED' ? 'AWAITING_SERVICE' : 'STORED', note: '' })
  const [error, setError] = useState<string | null>(null)
  const [opId] = useState(newOpId)
  async function run() {
    setError(null)
    try {
      await api.post(`/components/${componentId}/disposition`, f, opId)
      onDone()
    } catch (e) {
      setError((e as Error).message)
    }
  }
  return (
    <div className="form">
      <OutcomeChoice name="disp" outcomes={meta.dispositions.filter((d) => d.code !== 'IN_USE')} value={f.disposition} suggested={current} onChange={(v) => setF({ ...f, disposition: v })} />
      <div className="row">
        <Field label={tr('On')}>
          <input type="date" value={f.on} onChange={(e) => setF({ ...f, on: e.target.value })} />
        </Field>
        <Field label={tr('Note (optional)')}>
          <input value={f.note} onChange={(e) => setF({ ...f, note: e.target.value })} />
        </Field>
      </div>
      <FormError error={error} />
      <div className="form-actions">
        <button className="btn btn-primary" onClick={run}>
          {tr('Save')}
        </button>
      </div>
    </div>
  )
}

