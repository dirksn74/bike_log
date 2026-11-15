import { useEffect, useMemo, useState } from 'react'
import { api, newOpId } from '../api'
import { useApi } from '../hooks'
import { euro, toCents, today } from '../format'
import type { Bike, GroupsetPlan, GroupsetTemplate, OpResult } from '../types'
import { Empty, ErrorBox, Field, FormError, Loading, Tag } from './ui'
import ShopPicker from './ShopPicker'
import { tr, trn } from '../i18n'

const ACTION_TEXT: Record<string, string> = { INSTALL: 'install', REPLACE: 'replace', SPARE: 'spare' }

// Adds every part of a groupset in one step. All logic (positions, occupied slots, products) is in
// the backend; this form only collects the choices and shows the plan before anything is saved.
export default function GroupsetImport({ bikeId, onDone, initialOccupied = 'KEEP' }: { bikeId?: number; onDone: (msg: string) => void; initialOccupied?: 'KEEP' | 'REPLACE' }) {
  const templates = useApi<GroupsetTemplate[]>('/groupsets')
  const bikes = useApi<Bike[]>('/bikes')
  const [code, setCode] = useState('')
  const [bike, setBike] = useState(bikeId ? String(bikeId) : '')
  const [options, setOptions] = useState<Record<string, string>>({})
  const [include, setInclude] = useState<Set<string>>(new Set())
  const [occupied, setOccupied] = useState<string>(initialOccupied)
  const [at, setAt] = useState(today())
  const [priorUsage, setPriorUsage] = useState('NEW')
  const [prices, setPrices] = useState<Record<string, string>>({})
  // How it was bought: one price for the whole set (a bundle) or a price per part.
  const [priceMode, setPriceMode] = useState<'BUNDLE' | 'PARTS'>('BUNDLE')
  const [bundle, setBundle] = useState({ price: '', merchant: '', purchased_on: today() })
  const [spares, setSpares] = useState<Set<string>>(new Set())
  const [plan, setPlan] = useState<GroupsetPlan | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [opId] = useState(newOpId)
  const t = templates.data?.find((x) => x.code === code)

  useEffect(() => {
    if (!code && templates.data?.length) setCode(templates.data[0].code)
  }, [code, templates.data])
  useEffect(() => {
    if (!t) return
    setOptions(Object.fromEntries(t.options.map((o) => [o.key, o.default])))
    setInclude(new Set(t.items.filter((i) => i.default).map((i) => i.key)))
  }, [t])

  const offered = useMemo(
    () => (t ? t.items.filter((i) => !i.when || Object.entries(i.when).every(([k, v]) => v.includes(options[k]))) : []),
    [t, options],
  )
  const body = () => ({
    bike_id: bike ? Number(bike) : null,
    options,
    include: offered.filter((i) => include.has(i.key)).map((i) => i.key),
    occupied,
    to_spares: [...spares].filter((k) => include.has(k)),
  })

  // The preview follows every change, so what you see is what "Add" will do.
  useEffect(() => {
    // skip the render in which the options still belong to the previously picked groupset
    if (!t || Object.keys(options).length === 0 || t.options.some((o) => !(o.key in options))) return
    let live = true
    api
      .post<GroupsetPlan>(`/groupsets/${t.code}/plan`, body())
      .then((p) => live && (setPlan(p), setError(null)))
      .catch((e: Error) => live && (setPlan(null), setError(e.message)))
    return () => {
      live = false
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [t, bike, options, include, occupied, offered, spares])

  async function add() {
    if (!t) return
    setBusy(true)
    setError(null)
    try {
      const paid: Record<string, number> = {}
      let bundleBody = null
      if (priceMode === 'PARTS') {
        for (const key of body().include) {
          const c = toCents(prices[key] ?? '')
          if (Number.isNaN(c)) throw new Error(tr('Prices: enter amounts such as 49,90'))
          if (c !== null) paid[key] = c
        }
      } else {
        const c = toCents(bundle.price)
        if (Number.isNaN(c)) throw new Error(tr('Bundle price: enter an amount such as 1899,00'))
        bundleBody = { price_cents: c, merchant: bundle.merchant || null, purchased_on: bundle.purchased_on || null }
      }
      const r = await api.post<OpResult<GroupsetPlan & { created: { label: string }[]; bundle: { name: string } | null }>>(
        `/groupsets/${t.code}/import`,
        { ...body(), at, prior_usage: priorUsage, prices: paid, bundle: bundleBody, purchase_date: priceMode === 'BUNDLE' ? bundle.purchased_on || null : null },
        opId,
      )
      onDone(
        tr('{length} parts added ({x} installed){x2}. Undo is under Inventory → History.', { length: r.result.created.length, x: r.result.counts.INSTALL + r.result.counts.REPLACE, x2: r.result.bundle ? tr(', recorded as the bundle "{name}"', { name: r.result.bundle.name }) : '' }),
      )
    } catch (e) {
      setError((e as Error).message)
    } finally {
      setBusy(false)
    }
  }

  if (templates.loading && !templates.data) return <Loading />
  if (templates.error) return <ErrorBox error={templates.error} onRetry={templates.reload} />
  if (!t) return <Empty title={tr('No groupset templates')} />
  const paidTotal = offered.filter((i) => include.has(i.key)).reduce((sum, i) => sum + (toCents(prices[i.key] ?? '') || 0), 0)
  const toggleSpare = (key: string) => {
    const next = new Set(spares)
    if (next.has(key)) next.delete(key)
    else next.add(key)
    setSpares(next)
  }
  const toggle = (key: string) => {
    const next = new Set(include)
    if (next.has(key)) next.delete(key)
    else next.add(key)
    setInclude(next)
  }
  return (
    <div className="form">
      {(templates.data?.length ?? 0) > 1 && (
        <Field label={tr('Groupset')}>
          <select value={code} onChange={(e) => setCode(e.target.value)}>
            {[...new Set(templates.data?.map((x) => x.maker))].map((maker) => (
              <optgroup key={maker} label={maker}>
                {templates.data
                  ?.filter((x) => x.maker === maker)
                  .map((x) => (
                    <option key={x.code} value={x.code}>
                      {x.name}
                    </option>
                  ))}
              </optgroup>
            ))}
          </select>
        </Field>
      )}
      <p className="small">
        <strong>{t.name}</strong> {!t.verified && <Tag tone="warn" title={t.source}>{tr('specs not verified with {maker} yet', { maker: t.maker })}</Tag>}
        <br />
        <span className="muted">{t.notes}</span>
      </p>
      <div className="row">
        <Field label={tr('Bike')}>
          <select value={bike} onChange={(e) => setBike(e.target.value)}>
            <option value="">{tr('No bike: add everything as spares')}</option>
            {bikes.data
              ?.filter((b) => b.status === 'ACTIVE')
              .map((b) => (
                <option key={b.id} value={b.id}>
                  {b.name}
                </option>
              ))}
          </select>
        </Field>
        <Field label={tr('Installed on')} hint={tr('Rides from this date count on the new parts.')}>
          <input type="date" value={at} onChange={(e) => setAt(e.target.value)} />
        </Field>
      </div>
      <div className="row options">
        {t.options.map((o) => (
          <Field key={o.key} label={o.label}>
            <select value={options[o.key] ?? o.default} onChange={(e) => setOptions({ ...options, [o.key]: e.target.value })}>
              {o.choices.map((c) => (
                <option key={c.value} value={c.value}>
                  {c.label}
                </option>
              ))}
            </select>
          </Field>
        ))}
        <Field label={tr('Condition')}>
          <select value={priorUsage} onChange={(e) => setPriorUsage(e.target.value)}>
            <option value="NEW">{tr('New')}</option>
            <option value="UNKNOWN">{tr('Used, mileage unknown')}</option>
          </select>
        </Field>
      </div>
      {bike && (
        <fieldset className="field">
          <legend className="field-label">{tr('If a position already has a part')}</legend>
          <div className="pick-list">
            {t.occupied_modes.map((m) => (
              <label key={m.code} className={`pick ${occupied === m.code ? 'pick-on' : ''}`}>
                <input type="radio" name="occupied" checked={occupied === m.code} onChange={() => setOccupied(m.code)} />
                <span>
                  {m.label}
                  {m.code === 'REPLACE' && <span className="small muted"> {tr('(old parts keep their history; worn ones are marked discarded, others go to spares)')}</span>}
                </span>
              </label>
            ))}
          </div>
        </fieldset>
      )}
      <fieldset className="field">
        <legend className="field-label">{tr('How was it bought?')}</legend>
        <div className="pick-list">
          <label className={`pick ${priceMode === 'BUNDLE' ? 'pick-on' : ''}`}>
            <input type="radio" name="priceMode" checked={priceMode === 'BUNDLE'} onChange={() => setPriceMode('BUNDLE')} />
            <span>
              {tr('As one bundle (one price for the whole set)')}
              <span className="small muted"> {tr('The price counts once. Parts replaced later get their own price; the originals stay in the bundle.')}</span>
            </span>
          </label>
          <label className={`pick ${priceMode === 'PARTS' ? 'pick-on' : ''}`}>
            <input type="radio" name="priceMode" checked={priceMode === 'PARTS'} onChange={() => setPriceMode('PARTS')} />
            <span>{tr('Part by part (a price per part)')}</span>
          </label>
        </div>
        {priceMode === 'BUNDLE' && (
          <div className="row">
            <Field label={tr('Bundle price')} hint={tr('Optional; can be added later.')}>
              <input inputMode="decimal" placeholder="€" value={bundle.price} onChange={(e) => setBundle({ ...bundle, price: e.target.value })} />
            </Field>
            <ShopPicker label={tr('Shop')} value={bundle.merchant} onChange={(v) => setBundle({ ...bundle, merchant: v })} />
            <Field label={tr('Bought on')}>
              <input type="date" value={bundle.purchased_on} onChange={(e) => setBundle({ ...bundle, purchased_on: e.target.value })} />
            </Field>
          </div>
        )}
      </fieldset>
      <fieldset className="field">
        <legend className="field-label">
          {tr('Parts ({n} of {total})', { n: offered.filter((i) => include.has(i.key)).length, total: offered.length })}
          {priceMode === 'PARTS' ? tr(' · prices are optional{x}', { x: paidTotal > 0 ? tr(', {paidTotal} entered', { paidTotal: euro(paidTotal) }) : '' }) : ''}
          {bike ? tr(' · tick "spare" for parts that go into storage instead of onto the bike') : ''}
        </legend>
        <ul className="list groupset-items">
          {offered.map((i) => {
            const row = plan?.items.find((r) => r.key === i.key)
            return (
              <li key={i.key}>
                <label className="check">
                  <input type="checkbox" checked={include.has(i.key)} onChange={() => toggle(i.key)} />
                  <span>
                    <strong>{row?.label ?? i.name}</strong>
                    <span className="small muted"> {row ? `${row.model} · ${row.text}` : i.type_name}</span>
                  </span>
                </label>
                {row && <Tag tone={row.action === 'SPARE' ? 'neutral' : row.action === 'REPLACE' ? 'warn' : 'good'}>{ACTION_TEXT[row.action]}</Tag>}
                {bike && include.has(i.key) && (
                  <label className="check small" title={tr('Keep this part in storage instead of installing it')}>
                    <input type="checkbox" aria-label={tr('Keep {name} as spare', { name: i.name })} checked={spares.has(i.key)} onChange={() => toggleSpare(i.key)} /> {tr('spare')}
                  </label>
                )}
                {priceMode === 'PARTS' && include.has(i.key) && (
                  <input
                    className="price-input"
                    aria-label={tr('Price {name}', { name: i.name })}
                    inputMode="decimal"
                    value={prices[i.key] ?? ''}
                    placeholder={row?.list_price_cents ? euro(row.list_price_cents) : '€'}
                    onChange={(e) => setPrices({ ...prices, [i.key]: e.target.value })}
                  />
                )}
              </li>
            )
          })}
        </ul>
      </fieldset>
      {plan && (
        <div className="notice notice-preview">
          {tr('{install} to install, {replace} to replace, {spare} as spares', { install: plan.counts.INSTALL, replace: plan.counts.REPLACE, spare: plan.counts.SPARE })}
          {plan.new_products ? trn('; {n} new product with Shimano specs', '; {n} new products with Shimano specs', plan.new_products) : ''}{tr('. Nothing is saved until you press Add.')}
        </div>
      )}
      <FormError error={error} />
      <div className="form-actions">
        <button className="btn btn-primary" disabled={!plan || busy} onClick={add}>
          {busy ? tr('Adding…') : tr('Add {x} parts', { x: plan?.items.length ?? '' })}
        </button>
      </div>
    </div>
  )
}
