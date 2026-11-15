import { useState } from 'react'
import { Link } from 'react-router-dom'
import { api, newOpId } from '../api'
import { centsInput, euro, toCents, today, when } from '../format'
import type { ServiceOrder } from '../types'
import { useApp } from '../context'
import { Card, Field, FormError, Sheet, Tag } from './ui'
import ShopPicker from './ShopPicker'
import { tr } from '../i18n'

// Sent after that day's rides: a date alone would be the start of the day and take that day's rides away.
const afterRides = (date: string) => (date === today() ? new Date().toISOString() : `${date}T23:59`)

export interface IncidentPick {
  group: string
  label: string
  on: string
  bike: string | null
  affected: string
}

// Any part can go away for service or repair: it comes off the bike (no km while away) until it is back.
export function SendOutForm({ componentId, label, incidents, onDone }: { componentId: number; label: string; incidents: IncidentPick[]; onDone: (msg: string) => void }) {
  const [f, setF] = useState({ at: today(), shop: '', reason: '', incident: incidents.length === 1 ? incidents[0].group : '' })
  const [err, setErr] = useState<string | null>(null)
  const [opId] = useState(newOpId)
  async function send() {
    setErr(null)
    try {
      await api.post(`/components/${componentId}/send-out`, { at: afterRides(f.at), shop: f.shop || null, reason: f.reason || null, incident_group: f.incident || null }, opId)
      onDone(tr('{label} is away for repair. Record "Back from repair" when it returns.', { label }))
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form">
      <p className="small muted">{tr('It comes off the bike after that day\'s rides and collects no km while it is away. Parts mounted on it go along.')}</p>
      <div className="row">
        <Field label={tr('Sent on')}>
          <input type="date" value={f.at} onChange={(e) => setF({ ...f, at: e.target.value })} />
        </Field>
        <ShopPicker label={tr('Shop or maker')} value={f.shop} onChange={(v) => setF({ ...f, shop: v })} />
      </div>
      <Field label={tr('What is wrong')}>
        <textarea rows={2} value={f.reason} onChange={(e) => setF({ ...f, reason: e.target.value })} />
      </Field>
      {incidents.length > 0 && (
        <Field label={tr('Because of this incident')} hint={tr('Its fix is recorded when the part comes back.')}>
          <select value={f.incident} onChange={(e) => setF({ ...f, incident: e.target.value })}>
            <option value="">{tr('No incident')}</option>
            {incidents.map((i) => (
              <option key={i.group} value={i.group}>
                {when(i.on)} · {i.label} · {i.affected}
              </option>
            ))}
          </select>
        </Field>
      )}
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" onClick={send}>
          {tr('Send away')}
        </button>
      </div>
    </div>
  )
}

const OUTCOMES: [string, string, string][] = [
  ['REPAIRED_PAID', tr('Repaired, I paid'), tr('The cost counts in the bike and part costs.')],
  ['REPAIRED_WARRANTY', tr('Repaired under warranty'), tr('Free; enter a cost only for something like shipping.')],
  ['REPLACED_WARRANTY', tr('Replaced under warranty'), tr('The old part is "returned under warranty" and keeps its km; the new one starts at 0 km.')],
  ['NOT_REPAIRED', tr('Not repaired'), tr('It comes back as it went (or you discard it).')],
]

export function ReturnForm({ order, onDone }: { order: ServiceOrder; onDone: (msg: string) => void }) {
  const [f, setF] = useState({ at: today(), outcome: 'REPAIRED_PAID', cost: centsInput(null), receipt: '', notes: '', putBack: !!order.from_slot, keepAs: 'STORED', newLabel: '', newSerial: '', newWarranty: '' })
  const [err, setErr] = useState<string | null>(null)
  const [opId] = useState(newOpId)
  async function save() {
    setErr(null)
    const cost = toCents(f.cost)
    if (Number.isNaN(cost)) return setErr(tr('Cost: enter an amount such as 500 or 49,90'))
    try {
      await api.post(`/service-orders/${order.id}/return`, { at: f.at === today() ? new Date().toISOString() : f.at, outcome: f.outcome, cost_cents: cost, receipt_ref: f.receipt || null, notes: f.notes || null, put_back: f.putBack, keep_as: f.keepAs, new_label: f.newLabel || null, new_serial: f.newSerial || null, new_warranty_until: f.newWarranty || null }, opId)
      onDone(tr('{label}: back from repair.', { label: order.label }))
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form">
      <p className="small muted">
        {tr('Sent')} {when(order.sent_on)}
        {order.shop ? tr(' to {shop}', { shop: order.shop }) : ''}
        {order.reason ? ` · ${order.reason}` : ''}
      </p>
      <div role="radiogroup" aria-label={tr('What came back')}>
        {OUTCOMES.map(([code, label, hint]) => (
          <label key={code} className="check">
            <input type="radio" name="outcome" checked={f.outcome === code} onChange={() => setF({ ...f, outcome: code })} /> {label} <span className="small muted">{hint}</span>
          </label>
        ))}
      </div>
      <div className="row">
        <Field label={tr('Back on')}>
          <input type="date" value={f.at} onChange={(e) => setF({ ...f, at: e.target.value })} />
        </Field>
        <Field label={tr('Cost (optional)')}>
          <input inputMode="decimal" value={f.cost} onChange={(e) => setF({ ...f, cost: e.target.value })} placeholder="€" />
        </Field>
      </div>
      {f.outcome === 'REPLACED_WARRANTY' && (
        <>
          <Field label={tr('Name of the new part')} hint={tr('Empty: a name is made from the old one.')}>
            <input value={f.newLabel} onChange={(e) => setF({ ...f, newLabel: e.target.value })} />
          </Field>
          <div className="row">
            <Field label={tr('Serial number')}>
              <input value={f.newSerial} onChange={(e) => setF({ ...f, newSerial: e.target.value })} />
            </Field>
            <Field label={tr('Warranty until')}>
              <input type="date" value={f.newWarranty} onChange={(e) => setF({ ...f, newWarranty: e.target.value })} />
            </Field>
          </div>
        </>
      )}
      <div className="row">
        <Field label={tr('Receipt or reference')}>
          <input value={f.receipt} onChange={(e) => setF({ ...f, receipt: e.target.value })} placeholder={tr('e.g. invoice number')} />
        </Field>
        <Field label={tr('Notes')}>
          <input value={f.notes} onChange={(e) => setF({ ...f, notes: e.target.value })} placeholder={tr('what was done')} />
        </Field>
      </div>
      {f.outcome === 'NOT_REPAIRED' ? (
        <label className="check">
          <input type="checkbox" checked={f.keepAs === 'DISCARDED'} onChange={(e) => setF({ ...f, keepAs: e.target.checked ? 'DISCARDED' : 'STORED' })} /> {tr('Discard it (otherwise it is stored)')}
        </label>
      ) : (
        order.from_slot && (
          <label className="check">
            <input type="checkbox" checked={f.putBack} onChange={(e) => setF({ ...f, putBack: e.target.checked })} /> {tr(f.outcome === 'REPLACED_WARRANTY' ? 'Put the new part back on {from} (a part fitted there meanwhile is stored)' : 'Put it back on {from} (a part fitted there meanwhile is stored)', { from: order.from })}
          </label>
        )
      )}
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" onClick={save}>
          {tr('Save')}
        </button>
      </div>
    </div>
  )
}

export function OrderLine({ o, showPart = false }: { o: ServiceOrder; showPart?: boolean }) {
  return (
    <>
      {showPart && (
        <>
          <Link to={`/inventory/${o.component_id}`}>{o.label}</Link>
          {' · '}
        </>
      )}
      {tr('Sent')} {when(o.sent_on)}
      {o.shop ? tr(' to {shop}', { shop: o.shop }) : ''}
      {o.reason ? ` · ${o.reason}` : ''}
      {o.status === 'OUT' ? (
        <>
          {' '}
          <Tag tone="warn">{tr('away')}</Tag>
        </>
      ) : (
        <>
          {tr(' · back {returned_on}: {outcome_text}', { returned_on: when(o.returned_on), outcome_text: o.outcome_text })}
          {o.cost_cents ? ` · ${euro(o.cost_cents)}` : ''}
          {o.receipt_ref ? tr(' · receipt {receipt_ref}', { receipt_ref: o.receipt_ref }) : ''}
          {o.notes ? ` · ${o.notes}` : ''}
          {o.replacement_id && (
            <>
              {tr(' · new part ')}
              <Link to={`/inventory/${o.replacement_id}`}>{o.replacement}</Link>
            </>
          )}
        </>
      )}
      {o.incident && (
        <>
          {' · '}
          {o.incident.ride_id ? <Link to={`/rides?open=${o.incident.ride_id}`}>{o.incident.label}</Link> : o.incident.label} {when(o.incident.on)} {o.incident.open ? <Tag tone="warn">{tr('open')}</Tag> : <Tag tone="good">{tr('solved')}</Tag>}
        </>
      )}
    </>
  )
}

// Part page: the whole repair story of this part (and, for a warranty replacement, why it exists).
export function RepairsCard({ orders, componentId, onBack }: { orders: ServiceOrder[]; componentId: number; onBack: (o: ServiceOrder) => void }) {
  if (orders.length === 0) return null
  return (
    <Card title={tr('Sent away for repair')}>
      <ul className="list">
        {orders.map((o) => (
          <li key={o.id} className="small">
            {o.component_id !== componentId && <>{tr('Replacement for')} <Link to={`/inventory/${o.component_id}`}>{o.label}</Link>: </>}
            <OrderLine o={o} />{' '}
            {o.status === 'OUT' && o.component_id === componentId && (
              <button className="btn btn-small btn-primary" onClick={() => onBack(o)}>
                {tr('Back from repair')}
              </button>
            )}
          </li>
        ))}
      </ul>
    </Card>
  )
}

// Bike page: parts of this bike that are away for repair now, with their return.
export function AwayCard({ orders, onChanged }: { orders: ServiceOrder[]; onChanged: () => void }) {
  const { toast } = useApp()
  const [back, setBack] = useState<ServiceOrder | null>(null)
  if (orders.length === 0) return null
  return (
    <Card title={tr('Away for repair')}>
      <ul className="list">
        {orders.map((o) => (
          <li key={o.id} className="small">
            <OrderLine o={o} showPart />{' '}
            <button className="btn btn-small btn-primary" onClick={() => setBack(o)}>
              {tr('Back from repair')}
            </button>
          </li>
        ))}
      </ul>
      {back && (
        <Sheet title={tr('Back from repair: {label}', { label: back.label })} onClose={() => setBack(null)}>
          <ReturnForm order={back} onDone={(msg) => { setBack(null); toast(msg); onChanged() }} />
        </Sheet>
      )}
    </Card>
  )
}
