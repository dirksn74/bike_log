import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { api, newOpId } from '../api'
import { centsInput, euro, toCents, when } from '../format'
import { useApi } from '../hooks'
import type { BundleCandidate, BundleRow } from '../types'
import { Card, Empty, ErrorBox, Field, FormError, Loading, Sheet, Tag } from './ui'
import ShopPicker from './ShopPicker'
import { tr } from '../i18n'

// Parts bought together at one price (e.g. a groupset bundle). The bundle carries the price, its parts
// none, so the money is counted once. Shares per part are an estimate shown for information only.
export default function Bundles({ bikeId, refresh, onChanged, className = '' }: { bikeId: number; refresh?: unknown; onChanged: (msg: string) => void; className?: string }) {
  const { data, error, loading, reload } = useApi<BundleRow[]>(`/bundles?bike_id=${bikeId}`)
  const [sheet, setSheet] = useState<null | { kind: 'new' } | { kind: 'edit'; row: BundleRow }>(null)
  const [open, setOpen] = useState<number | null>(null)
  useEffect(() => {
    if (refresh !== undefined) reload()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [refresh])
  const done = (msg: string) => {
    setSheet(null)
    reload()
    onChanged(msg)
  }
  return (
    <Card
      title={tr('Bought as a bundle')}
      className={className}
      actions={
        <button className="btn btn-small" onClick={() => setSheet({ kind: 'new' })}>
          {tr('Group parts as a bundle')}
        </button>
      }
    >
      {loading && !data && <Loading />}
      {error && <ErrorBox error={error} onRetry={reload} />}
      {data && data.length === 0 && (
        <Empty title={tr('No bundles')}>{tr('If you bought several parts together at one price (a groupset), group them here so the price is counted once.')}</Empty>
      )}
      {data && data.length > 0 && (
        <ul className="list bundles">
          {data.map((b) => (
            <li key={b.id} className="bundle">
              <div className="bundle-head">
                <strong>{b.name}</strong>
                <span>{b.price_cents !== null ? euro(b.price_cents) : <Tag tone="warn">{tr('no price')}</Tag>}</span>
                <span className="muted small">
                  {[b.merchant, b.purchased_on ? when(b.purchased_on) : null].filter(Boolean).join(' · ') || tr('shop and date not entered')}
                </span>
                <span className="small">
                  {tr('{in_use} of {count} parts in use', { in_use: b.in_use, count: b.member_count })}
                </span>
                <button className="btn btn-small" onClick={() => setOpen(open === b.id ? null : b.id)}>
                  {open === b.id ? tr('Hide parts') : tr('Show parts')}
                </button>
                <button className="btn btn-small" onClick={() => setSheet({ kind: 'edit', row: b })}>
                  {tr('Edit')}
                </button>
              </div>
              {open === b.id && (
                <>
                  <table className="table">
                    <thead>
                      <tr>
                        <th>{tr('Part')}</th>
                        <th>{tr('Where')}</th>
                        <th title={tr('Estimated share of the bundle price, for information only')}>{tr('≈ share')}</th>
                      </tr>
                    </thead>
                    <tbody>
                      {b.members.map((m) => (
                        <tr key={m.component_id} className={m.state === 'RETIRED' ? 'excluded' : ''}>
                          <td>
                            <Link to={`/inventory/${m.component_id}`}>{m.label}</Link> <span className="muted small">{m.type_name}</span>
                          </td>
                          <td>
                            {m.in_use ? <Tag tone="good">{tr('in use')}</Tag> : m.state === 'STORED' ? <Tag tone="info">{tr('in storage')}</Tag> : <Tag>{m.state.toLowerCase().replace('_', ' ')}</Tag>}{' '}
                            <span className="small muted">{m.where}</span>
                          </td>
                          <td>{m.share_cents !== null ? `≈ ${euro(m.share_cents)}` : '—'}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                  <p className="small muted">
                    {tr('Shares are an estimate (')}{b.share_basis}{tr(') and do not change the costs; the bundle price counts once')}
                    {b.bike ? tr(', for {bike} (where most of its parts were first installed)', { bike: b.bike }) : ''}{tr('. Parts bought later as replacements have their own price.')}
                  </p>
                </>
              )}
            </li>
          ))}
        </ul>
      )}
      {sheet?.kind === 'new' && (
        <Sheet title={tr('Group parts as a bundle')} onClose={() => setSheet(null)}>
          <NewBundleForm bikeId={bikeId} onDone={done} />
        </Sheet>
      )}
      {sheet?.kind === 'edit' && (
        <Sheet title={tr('Bundle · {name}', { name: sheet.row.name })} onClose={() => setSheet(null)}>
          <EditBundleForm row={sheet.row} onDone={done} />
        </Sheet>
      )}
    </Card>
  )
}

interface PriceFields {
  name: string
  price: string
  merchant: string
  purchased_on: string
}

function priceBody(f: PriceFields): { body: Record<string, unknown> } | { error: string } {
  const price = toCents(f.price)
  if (Number.isNaN(price)) return { error: tr('Price: enter an amount such as 1899,00') }
  if (!f.name.trim()) return { error: tr('Give the bundle a name, e.g. \'Ultegra Di2 R8100 groupset\'') }
  return { body: { name: f.name.trim(), price_cents: price, merchant: f.merchant.trim() || null, purchased_on: f.purchased_on || null } }
}

function PriceInputs({ f, setF }: { f: PriceFields; setF: (f: PriceFields) => void }) {
  return (
    <>
      <Field label={tr('Bundle name')}>
        <input value={f.name} onChange={(e) => setF({ ...f, name: e.target.value })} placeholder={tr('e.g. Ultegra Di2 R8100 groupset')} />
      </Field>
      <div className="row">
        <Field label={tr('Bundle price')} hint={tr('What you paid for the whole bundle.')}>
          <input inputMode="decimal" value={f.price} onChange={(e) => setF({ ...f, price: e.target.value })} placeholder="€" />
        </Field>
        <ShopPicker label={tr('Shop')} value={f.merchant} onChange={(v) => setF({ ...f, merchant: v })} />
        <Field label={tr('Bought on')}>
          <input type="date" value={f.purchased_on} onChange={(e) => setF({ ...f, purchased_on: e.target.value })} />
        </Field>
      </div>
    </>
  )
}

function NewBundleForm({ bikeId, onDone }: { bikeId: number; onDone: (msg: string) => void }) {
  const [all, setAll] = useState(false)
  const { data, error, loading } = useApi<BundleCandidate[]>(`/bundles/candidates${all ? '' : `?bike_id=${bikeId}`}`)
  const [f, setF] = useState<PriceFields>({ name: '', price: '', merchant: '', purchased_on: '' })
  const [picked, setPicked] = useState<Set<number>>(new Set())
  const [opId] = useState(newOpId)
  const [err, setErr] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const toggle = (id: number) => {
    const next = new Set(picked)
    if (next.has(id)) next.delete(id)
    else next.add(id)
    setPicked(next)
  }
  async function save() {
    setErr(null)
    const p = priceBody(f)
    if ('error' in p) return setErr(p.error)
    if (picked.size === 0) return setErr(tr('Tick the parts that were bought together'))
    setBusy(true)
    try {
      const b = await api.post<BundleRow>('/bundles', { ...p.body, component_ids: [...picked] }, opId)
      onDone(tr('Bundle "{name}" saved with {member_count} parts.', { name: b.name, member_count: b.member_count }))
    } catch (e) {
      setErr((e as Error).message)
    } finally {
      setBusy(false)
    }
  }
  return (
    <div className="form">
      <PriceInputs f={f} setF={setF} />
      <fieldset>
        <legend>{tr('Parts in the bundle')}</legend>
        <label className="check">
          <input type="checkbox" checked={all} onChange={(e) => setAll(e.target.checked)} /> {tr('Also show parts in storage and on other bikes')}
        </label>
        {loading && !data && <Loading />}
        {error && <ErrorBox error={error} />}
        {data && data.length === 0 && <p className="small muted">{tr('No parts without a price. A part with its own price cannot join a bundle; clear its price first.')}</p>}
        {data?.map((c) => (
          <label key={c.component_id} className="check">
            <input type="checkbox" aria-label={tr('Bundle part {label}', { label: c.label })} checked={picked.has(c.component_id)} onChange={() => toggle(c.component_id)} /> {c.label}{' '}
            <span className="muted small">
              {c.type_name} · {c.where}
            </span>
          </label>
        ))}
      </fieldset>
      <p className="small muted">{tr('Only parts without their own price are listed, so nothing is counted twice.')}</p>
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" disabled={busy} onClick={save}>
          {busy ? tr('Saving…') : tr('Save bundle ({size} parts)', { size: picked.size })}
        </button>
      </div>
    </div>
  )
}

function EditBundleForm({ row, onDone }: { row: BundleRow; onDone: (msg: string) => void }) {
  const [f, setF] = useState<PriceFields>({ name: row.name, price: centsInput(row.price_cents), merchant: row.merchant ?? '', purchased_on: row.purchased_on ?? '' })
  const [reason, setReason] = useState('')
  const [err, setErr] = useState<string | null>(null)
  async function save() {
    setErr(null)
    const p = priceBody(f)
    if ('error' in p) return setErr(p.error)
    try {
      await api.patch(`/bundles/${row.id}`, p.body)
      onDone(tr('Bundle saved.'))
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  async function voidIt() {
    setErr(null)
    try {
      await api.post(`/bundles/${row.id}/void`, { reason })
      onDone(tr('Bundle voided. Its parts can now be priced on their own.'))
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  async function removePart(cid: number) {
    setErr(null)
    try {
      await api.del(`/bundles/${row.id}/members/${cid}`)
      onDone(tr('Part taken out of the bundle.'))
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form">
      <PriceInputs f={f} setF={setF} />
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" onClick={save}>
          {tr('Save')}
        </button>
      </div>
      <fieldset>
        <legend>{tr('Added by mistake?')}</legend>
        <p className="small muted">{tr('A part that was bought in the bundle and later replaced stays in it. Only take out a part that was never part of this purchase.')}</p>
        <ul className="list">
          {row.members.map((m) => (
            <li key={m.component_id}>
              <span>{m.label}</span>
              <button className="btn btn-small" onClick={() => removePart(m.component_id)}>
                {tr('Take out')}
              </button>
            </li>
          ))}
        </ul>
      </fieldset>
      <fieldset>
        <legend>{tr('Bundle entered by mistake')}</legend>
        <p className="small muted">{tr('Voiding keeps the record (nothing is deleted) and stops counting its price.')}</p>
        <Field label={tr('Why is it wrong?')}>
          <input value={reason} onChange={(e) => setReason(e.target.value)} placeholder={tr('e.g. entered twice')} />
        </Field>
        <button className="btn btn-danger" disabled={!reason.trim()} onClick={voidIt}>
          {tr('Void bundle')}
        </button>
      </fieldset>
    </div>
  )
}
