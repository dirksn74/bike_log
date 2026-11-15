// One short way to put a part on (DECISIONS 107, 108): pick where (front or rear wheel, a position on the
// bike), then a spare from storage, a new part or a used one that is new to the app (with its km), a date,
// Save. Used for "Install a tire" on the wheel, wheelset and bike pages, and for "Install" on the page of a
// stored part (then the part is fixed and only "where" is asked). Where both wheels are listed, a tire can be
// moved to the other wheel, or the two tires swapped, in one click; each tire keeps its km.
import { useState } from 'react'
import { api, newOpId } from '../api'
import { useApp } from '../context'
import { km, toCents, today, usageText } from '../format'
import { useApi } from '../hooks'
import type { ComponentSummary } from '../types'
import type { MountTarget, MountTargets } from './MountPicker'
import ShopPicker from './ShopPicker'
import { Field, FormError, Loading } from './ui'
import { tr, lc } from '../i18n'

const pretty = (t: MountTarget) => {
  if (t.parent_type === 'FRONT_WHEEL') return tr('Front wheel · {parent_label}', { parent_label: t.parent_label })
  if (t.parent_type === 'REAR_WHEEL') return tr('Rear wheel · {parent_label}', { parent_label: t.parent_label })
  return t.text
}

// a date alone would be the start of the day and move that day's rides; today means now
const afterRides = (date: string) => (date === today() ? new Date().toISOString() : `${date}T23:59`)

type Source = 'spare' | 'stock' | 'new' | 'used'

interface StockLine {
  id: number
  name: string
  component_type: string | null
  tracking_mode: string
  stock: { qty: number } | null
}

export default function InstallHere({ componentType, bikeId, under, prefer, part, onDone, onCancel, onChange }: {
  componentType: string
  bikeId?: number // only positions of this bike
  under?: number // only positions on this part or parts mounted on it (a wheel, a wheelset)
  prefer?: number // preselect the position on this part (the wheel you clicked) when it is free
  part?: ComponentSummary // install this stored part (no "spare, new or used" question)
  onDone: (msg: string) => void
  onCancel: () => void
  onChange?: (occupiedId: number) => void // a taken position: change the part that is there instead
}) {
  const { meta } = useApp()
  const ctype = meta.component_types.find((t) => t.code === componentType)
  const noun = lc(ctype?.name) || tr('part')
  const q = useApi<MountTargets>(`/mount-targets?component_type=${componentType}${bikeId ? `&bike_id=${bikeId}` : ''}${under ? `&under=${under}` : ''}`)
  const spares = useApi<ComponentSummary[]>(part ? null : `/components?state=STORED&component_type=${componentType}`)
  const targets = q.data?.targets ?? []
  const free = targets.filter((t) => !t.occupied_by)
  const [pick, setPick] = useState<number | null>(null)
  const preferred = prefer ? free.find((t) => t.parent_component_id === prefer) : undefined
  const chosen = pick ?? (preferred ? targets.indexOf(preferred) : free.length === 1 ? targets.indexOf(free[0]) : null)
  const spareList = (spares.data ?? []).filter((c) => c.status === 'ACTIVE')
  // counted stock of this type ("Conti Race 28, 3 at home"): one comes out and gets its own record and km
  const stockQ = useApi<StockLine[]>(part ? null : '/consumables')
  const stockList = (stockQ.data ?? []).filter((l) => l.component_type === componentType && l.tracking_mode === 'COUNTED' && (l.stock?.qty ?? 0) >= 1)
  const [src, setSrc] = useState<Source | null>(null)
  const source: Source = part ? 'spare' : src ?? (spareList.length ? 'spare' : stockList.length ? 'stock' : 'new')
  const [f, setF] = useState({ stock: '', spare: '', label: '', price: '', purchase_date: '', shop: '', at: today(), km: '' })
  const [err, setErr] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [opId] = useState(newOpId)
  const groups = [...new Set(targets.map((t) => t.group))]
  const spare = part ?? spareList.find((c) => String(c.id) === f.spare)
  const spareKmUnknown = !!spare && spare.usage.starting_km === null && spare.prior_usage !== 'NEW'
  // front and rear of one wheelset (or of one bike): tires can move between them
  const front = targets.find((t) => t.parent_type === 'FRONT_WHEEL')
  const rear = targets.find((t) => t.parent_type === 'REAR_WHEEL')
  const pair = componentType === 'TIRE' || componentType === 'INNER_TUBE' ? (front && rear && front.group === rear.group ? { front, rear } : null) : null

  const kmValue = () => {
    if (f.km.trim() === '') return null
    const v = Number(f.km.replace(',', '.'))
    if (Number.isNaN(v) || v < 0) throw new Error(tr('km from before: enter a number such as 1200'))
    return v
  }

  async function save() {
    setErr(null)
    if (chosen === null) return setErr(targets.length ? tr('Pick where the {noun} goes.', { noun }) : tr('There is no wheel to put the {noun} on yet.', { noun }))
    const t = targets[chosen]
    // today = now (a tire taken off earlier today leaves its position free from then); a past day = from its start
    const where: Record<string, unknown> = { at: f.at === today() ? new Date().toISOString() : f.at, slot: t.slot ?? undefined }
    if (t.parent_component_id) where.parent_component_id = t.parent_component_id
    else where.bike_id = t.bike_id
    try {
      setBusy(true)
      const before = kmValue()
      if (source === 'stock') {
        const line = stockList.find((l) => String(l.id) === f.stock) ?? (stockList.length === 1 ? stockList[0] : undefined)
        if (!line) return setErr(tr('Pick the {noun} from stock.', { noun }))
        const body: Record<string, unknown> = { ...where, label: f.label.trim() || line.name }
        const r = await api.post<{ result: { label: string } }>(`/consumables/${line.id}/install`, body, opId)
        onDone(tr('{label} installed from stock: {pretty}. Its km count from now on.', { label: r.result.label, pretty: pretty(t) }))
      } else if (source === 'spare') {
        if (!spare) return setErr(tr('Pick the {noun} from storage.', { noun }))
        if (before !== null && spareKmUnknown) await api.post(`/components/${spare.id}/starting-usage`, { km: before, effective: f.at, is_estimate: true, note: tr('km from before, entered when installing') })
        await api.post(`/components/${spare.id}/install`, where, opId)
        onDone(tr('{label} installed: {pretty}.', { label: spare.label, pretty: pretty(t) }))
      } else {
        if (!f.label.trim()) return setErr(tr('Give the {noun} a name, e.g. "GP5000 front".', { noun }))
        if (source === 'used' && before === null) return setErr(tr('Enter the km the used {noun} already has (an estimate is fine).', { noun }))
        const price = toCents(f.price)
        if (Number.isNaN(price)) return setErr(tr('Price: enter an amount such as 49,90'))
        const body: Record<string, unknown> = { component_type: componentType, label: f.label.trim(), prior_usage: source === 'used' ? 'RECORDED' : 'NEW', install: where }
        if (source === 'used') Object.assign(body, { starting_km: before, starting_date: f.at, starting_is_estimate: true })
        if (price !== null) body.price_cents = price
        if (f.purchase_date) body.purchase_date = f.purchase_date
        if (f.shop.trim()) body.shop = f.shop.trim()
        const c = await api.post<ComponentSummary>('/components', body, opId)
        onDone(tr('{label} installed: {pretty}{x}.', { label: c.label, pretty: pretty(t), x: source === 'used' ? tr(', starting at {km}', { km: km(before ?? 0, 0) }) : '' }))
      }
    } catch (e) {
      setErr((e as Error).message)
    } finally {
      setBusy(false)
    }
  }

  // front tire to the rear wheel (or back), or both swapped: same tires, their km carry on
  async function move(from: MountTarget, to: MountTarget) {
    setErr(null)
    try {
      setBusy(true)
      await api.post(`/components/${from.occupied_id}/move`, { at: afterRides(f.at), parent_component_id: to.parent_component_id, slot: to.slot, swap: !!to.occupied_by }, newOpId())
      onDone(to.occupied_by ? tr('Swapped: {occupied_by} is now on the {x} wheel, {occupied_by2} on the {x2} wheel.', { occupied_by: from.occupied_by, x: to.parent_type === 'REAR_WHEEL' ? 'rear' : 'front', occupied_by2: to.occupied_by, x2: from.parent_type === 'REAR_WHEEL' ? 'rear' : 'front' }) : tr('{occupied_by} moved to the {x} wheel.', { occupied_by: from.occupied_by, x: to.parent_type === 'REAR_WHEEL' ? 'rear' : 'front' }))
    } catch (e) {
      setErr((e as Error).message)
    } finally {
      setBusy(false)
    }
  }

  if (q.loading && !q.data) return <Loading />
  return (
    <div className="form install-here">
      <div className="field">
        <span className="field-label">{tr('Where does it go?')}</span>
        <div role="radiogroup" aria-label={tr('Where does it go?')} className="where-list">
          {targets.length === 0 && (
            <span className="small muted">
              {tr('There is no {what} to put it on yet. Add the wheelset (or the wheels) first: Inventory → Add part → Wheelset; a wheelset comes with its front and rear wheel.', { what: ctype?.parent_types.length ? ctype.parent_types.map((p) => lc(meta.component_types.find((x) => x.code === p)?.name) || p).join(tr(' or ')) : tr('place') })}
            </span>
          )}
          {groups.map((g) => (
            <div key={g}>
              {groups.length > 1 && <div className="small muted">{g}</div>}
              {targets.map((t, i) =>
                t.group !== g ? null : (
                  <div key={i} className="where-row">
                    <label className={`check ${t.occupied_by ? 'muted' : ''}`}>
                      <input type="radio" name="where" disabled={!!t.occupied_by} checked={chosen === i} onChange={() => setPick(i)} /> {pretty(t)}
                    </label>
                    {t.occupied_by && (
                      <span className="small">
                        {tr('already has')} <strong>{t.occupied_by}</strong>{tr('. To put a different {noun} there, replace that one:', { noun })}{' '}
                        {onChange && t.occupied_id && (
                          <button type="button" className="btn btn-small" onClick={() => onChange(t.occupied_id!)}>
                            {tr('Replace')} {t.occupied_by}
                          </button>
                        )}
                      </span>
                    )}
                  </div>
                ),
              )}
            </div>
          ))}
        </div>
      </div>
      {pair && (pair.front.occupied_by || pair.rear.occupied_by) && (
        <div className="chips move-tires">
          {pair.front.occupied_by && pair.rear.occupied_by ? (
            <button type="button" className="btn" disabled={busy} onClick={() => move(pair.front, pair.rear)}>
              {tr('Swap front and rear {noun}', { noun })}
            </button>
          ) : pair.front.occupied_by ? (
            <button type="button" className="btn" disabled={busy} onClick={() => move(pair.front, pair.rear)}>
              {tr('Move the front {noun} to the rear wheel', { noun })}
            </button>
          ) : (
            <button type="button" className="btn" disabled={busy} onClick={() => move(pair.rear, pair.front)}>
              {tr('Move the rear {noun} to the front wheel', { noun })}
            </button>
          )}
          <span className="small muted">{tr('Same {noun}s, their km carry on. Date: “Installed on” below.', { noun })}</span>
        </div>
      )}
      {!part && (
        <div className="chips" role="radiogroup" aria-label={tr('Which {noun}', { noun })}>
          <button type="button" className={`chip ${source === 'spare' ? 'chip-on' : ''}`} disabled={!spareList.length} onClick={() => setSrc('spare')}>
            {tr('A spare from storage')}{spareList.length ? ` (${spareList.length})` : tr(' (none)')}
          </button>
          {stockList.length > 0 && (
            <button type="button" className={`chip ${source === 'stock' ? 'chip-on' : ''}`} onClick={() => setSrc('stock')}>
              {tr('From stock (')}{stockList.map((l) => `${l.name}: ${l.stock?.qty ?? 0}`).join(', ')})
            </button>
          )}
          <button type="button" className={`chip ${source === 'new' ? 'chip-on' : ''}`} onClick={() => setSrc('new')}>
            {tr('A new {noun}', { noun })}
          </button>
          <button type="button" className={`chip ${source === 'used' ? 'chip-on' : ''}`} onClick={() => setSrc('used')}>
            {tr('A used {noun} (not in the app yet)', { noun })}
          </button>
        </div>
      )}
      {source === 'spare' && !part && (
        <Field label={tr('{x} from storage', { x: ctype?.name ?? tr('Part') })}>
          <select value={f.spare} onChange={(e) => setF({ ...f, spare: e.target.value })}>
            <option value="">{tr('Pick…')}</option>
            {spareList.map((c) => (
              <option key={c.id} value={c.id}>
                {c.label} ({usageText(c.usage)})
              </option>
            ))}
          </select>
        </Field>
      )}
      {source === 'stock' && (
        <>
          <Field label={tr('{x} from stock', { x: ctype?.name ?? tr('Part') })} hint={tr('One comes off the stock count. It gets its own record, so its km count from the install date.')}>
            <select value={f.stock || (stockList.length === 1 ? String(stockList[0].id) : '')} onChange={(e) => setF({ ...f, stock: e.target.value })}>
              {stockList.length > 1 && <option value="">{tr('Pick…')}</option>}
              {stockList.map((l) => (
                <option key={l.id} value={l.id}>
                  {l.name} ({l.stock?.qty ?? 0} {tr('in stock)')}
                </option>
              ))}
            </select>
          </Field>
          <Field label={tr('Name / label (optional)')} hint={tr('Leave empty to use the stock name; a second one gets “(2)”.')}>
            <input value={f.label} onChange={(e) => setF({ ...f, label: e.target.value })} />
          </Field>
        </>
      )}
      {source !== 'spare' && source !== 'stock' && (
        <>
          <Field label={tr('Name / label')} hint={source === 'new' ? tr('e.g. GP5000 front. It is new, so it starts at 0 km.') : tr('e.g. GP5000 old rear.')}>
            <input value={f.label} onChange={(e) => setF({ ...f, label: e.target.value })} />
          </Field>
          <div className="row">
            <Field label={tr('Price paid (optional)')}>
              <input inputMode="decimal" value={f.price} onChange={(e) => setF({ ...f, price: e.target.value })} placeholder="€" />
            </Field>
            <Field label={tr('Bought on (optional)')}>
              <input type="date" value={f.purchase_date} onChange={(e) => setF({ ...f, purchase_date: e.target.value })} />
            </Field>
          </div>
          <div className="row">
            <ShopPicker value={f.shop} onChange={(v) => setF({ ...f, shop: v })} />
          </div>
        </>
      )}
      {(source === 'used' || spareKmUnknown) && (
        <Field label={tr('km from before')} hint={source === 'used' ? tr('What it has done so far (an estimate is fine). Rides from the install date count on top.') : tr('This spare has no km recorded. Enter what it has done so far, or leave empty if unknown.')}>
          <input inputMode="decimal" value={f.km} onChange={(e) => setF({ ...f, km: e.target.value })} placeholder="km" />
        </Field>
      )}
      <Field label={tr('Installed on')} hint={tr('Today: rides from now on count on it. A past day: rides from that day on.')}>
        <input type="date" value={f.at} onChange={(e) => setF({ ...f, at: e.target.value })} />
      </Field>
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" disabled={busy} onClick={save}>
          {tr('Save')}
        </button>
        <button className="btn" onClick={onCancel}>
          {tr('Cancel')}
        </button>
      </div>
    </div>
  )
}
