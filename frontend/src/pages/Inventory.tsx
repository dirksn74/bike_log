import { useState } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { api, newOpId } from '../api'
import ChangeLog from '../components/ChangeLog'
import EventLog from '../components/EventLog'
import { FoldedTimeline } from '../components/Timeline'
import GroupsetImport from '../components/GroupsetImport'
import Journal from '../components/Journal'
import LogMaintenance from '../components/LogMaintenance'
import MountPicker, { type MountTarget } from '../components/MountPicker'
import PartLife from '../components/PartLife'
import PartTree from '../components/PartTree'
import { RepairsCard, ReturnForm, SendOutForm, type IncidentPick } from '../components/ServiceOrders'
import ProductImport from '../components/ProductImport'
import ProductPicker from '../components/ProductPicker'
import ShopPicker from '../components/ShopPicker'
import { PropertiesCard, SpecInputs } from '../components/Properties'
import { specsFrom } from '../specs'
import { BrokenSpokes, SpokeCount } from '../components/Spokes'
import InstallHere from '../components/InstallHere'
import { DispositionForm, MoveForm, OutcomeChoice, RemoveForm, ReplaceForm } from '../components/PartChange'
import TaskList from '../components/TaskList'
import { PressureNote, TireSetupSelect } from '../components/TireSetup'
import { Card, ChangeNotice, Empty, ErrorBox, Field, FormError, Loading, Sheet, Tag } from '../components/ui'
import { useApp } from '../context'
import { centsInput, certaintyLabel, euro, km, setupLabel, slotName, toCents, today, usageText, when } from '../format'
import { INVENTORY_TABS, useCrumb } from '../crumbs'
import { useApi } from '../hooks'
import type { Bike, Change, ChainRow, ComponentSummary, EventRow, OpResult, PartNode, Rule, ServiceOrder, ShoppingItem, SpokeInfo, Task } from '../types'
import { tr, locale, codeText, trn, lc, unitWord } from '../i18n'

const SUPPLY_KINDS: Record<string, string> = { WAX: tr('Chain wax'), LUBE: tr('Chain lube'), SEALANT: tr('Tubeless sealant'), BRAKE_FLUID: tr('Brake fluid'), GREASE: tr('Grease'), OTHER: tr('Other') }
// "g" and "ml" stay as they are; "tube" becomes "tubes"
const unitPlural = (u: string) => (u.length <= 2 || u.endsWith('s') ? u : `${u}s`)

const CHAIN_TONE: Record<string, 'good' | 'warn' | 'info' | 'bad' | 'neutral'> = {
  READY_TO_INSTALL: 'good',
  INSTALLED: 'info',
  NEEDS_HOT_WAX: 'warn',
  NEW_UNWAXED: 'warn',
  WORN: 'bad',
  UNKNOWN: 'neutral',
  RETIRED: 'neutral',
}

export function ChainStateTag({ state }: { state: string }) {
  return <Tag tone={CHAIN_TONE[state] ?? 'neutral'}>{codeText(state)}</Tag>
}

// "Groupset" in the type list: several parts at once, through the same dialog as on the bike page
const GROUPSET = 'GROUPSET'

// Add part. With bikeId (bike page → Install a part → A new part) the part is created and installed on that
// bike in one step: "Where does it go?" lists only that bike and is required.
export function ComponentForm({ onSaved, presetType, onGroupset, onCancel, bikeId }: { onSaved: (c: ComponentSummary, typedLabel?: string) => void; presetType?: string; onGroupset?: (msg: string) => void; onCancel?: () => void; bikeId?: number }) {
  const { meta } = useApp()
  const [f, setF] = useState({ component_type: presetType ?? 'CHAIN', label: '', mark: '', history: 'NEW', start_km: '', start_date: today(), start_estimate: true, install_slot: '', install_at: today(), notes: '', price: '', purchase_date: '', shop: '', qty: '1', price_total: false, maker: '', model: '' })
  const [props, setProps] = useState<Record<string, string>>({})
  const [propsOpen, setPropsOpen] = useState(presetType === 'COCKPIT' || presetType === 'WHEELSET')
  const [mount, setMount] = useState<MountTarget | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [opId] = useState(newOpId)
  async function save() {
    setBusy(true)
    setError(null)
    try {
      if (qtyBad) throw new Error(tr('Enter a whole number from 1 to 50'))
      const body: Record<string, unknown> = { component_type: f.component_type, label: f.label, mark: qty > 1 ? null : f.mark.trim() || null, prior_usage: f.history === 'KNOWN' ? 'UNKNOWN' : f.history }
      if (f.notes) body.notes = f.notes
      const price = toCents(f.price)
      if (Number.isNaN(price)) throw new Error(tr('Price: enter an amount such as 49,90'))
      if (price !== null) body.price_cents = price
      if (f.purchase_date) body.purchase_date = f.purchase_date
      if (f.shop.trim()) body.shop = f.shop.trim()
      if (f.maker.trim() || f.model.trim()) Object.assign(body, { product_maker: f.maker.trim() || null, product_model: f.model.trim() || null })
      if (qty > 1) Object.assign(body, { quantity: qty, price_is_total: f.price_total })
      const specs = specsFrom(specFields, props)
      if (Object.keys(specs).length) body.specs = specs
      if (f.history === 'KNOWN') Object.assign(body, { starting_km: Number(f.start_km || 0), starting_date: f.start_date, starting_is_estimate: f.start_estimate })
      if (mount) {
        const slot = mount.slot ?? f.install_slot.trim().toUpperCase().replace(/\s+/g, '_')
        if (!slot) throw new Error(tr('Name the position on the bike, e.g. bottle cage 1'))
        body.install = { at: f.install_at, slot, ...(mount.parent_component_id ? { parent_component_id: mount.parent_component_id } : { bike_id: mount.bike_id }) }
      }
      onSaved(await api.post<ComponentSummary>('/components', body, opId), f.label.trim())
    } catch (e) {
      setError((e as Error).message)
    } finally {
      setBusy(false)
    }
  }
  const specFields = meta.component_types.find((t) => t.code === f.component_type)?.specs ?? []
  // several identical spares at once (Dirk 2026-11-15: "15 inner tubes in one go"); each becomes its own part
  const canMany = !bikeId && !mount
  const qtyNum = Number(f.qty)
  const qtyBad = canMany && f.qty.trim() !== '' && (!Number.isInteger(qtyNum) || qtyNum < 1 || qtyNum > 50)
  const qty = canMany && !qtyBad && f.qty.trim() !== '' ? qtyNum : 1
  const typeField = (
    <Field label={tr('Type')}>
      <select
        value={f.component_type}
        onChange={(e) => {
          setF({ ...f, component_type: e.target.value, install_slot: '', maker: '', model: '' })
          setProps({})
          setPropsOpen(e.target.value === 'COCKPIT' || e.target.value === 'WHEELSET')
          setMount(null)
        }}
      >
        {onGroupset && <option value={GROUPSET}>{tr('Groupset (all its parts at once)')}</option>}
        {[...meta.component_types].sort((a, b) => a.name.localeCompare(b.name)).map((t) => (
          <option key={t.code} value={t.code}>
            {t.name}
          </option>
        ))}
      </select>
    </Field>
  )
  if (onGroupset && f.component_type === GROUPSET) {
    return (
      <div className="form">
        {typeField}
        <GroupsetImport onDone={onGroupset} />
      </div>
    )
  }
  return (
    <div className="form">
      <div className="row">
        {typeField}
        <div className="row">
          <Field label={tr('Name / label')} hint={tr('e.g. the product name. Properties can be added later.')}>
            <input value={f.label} onChange={(e) => setF({ ...f, label: e.target.value })} autoFocus />
          </Field>
          {qty > 1 ? null : <Field label={tr('Mark (optional)')} hint={f.mark.trim() ? tr('Shown as "{x} [{trim}]"', { x: f.label.trim() || tr('Name'), trim: f.mark.trim() }) : f.component_type === 'CHAIN' ? tr('A, B …; a second chain of the same name gets the next letter by itself') : tr('A short tag to tell identical parts apart')}>
            <input value={f.mark} maxLength={20} onChange={(e) => setF({ ...f, mark: e.target.value })} />
          </Field>}
        </div>
      </div>
      <ProductPicker componentType={f.component_type} maker={f.maker} model={f.model} name={f.label} onChange={(maker, model) => setF({ ...f, maker, model, label: !f.label.trim() || f.label === [f.maker, f.model].filter(Boolean).join(' ') ? [maker, model].filter(Boolean).join(' ') : f.label })} />
      {canMany && (
        <div className="row">
          <Field label={tr('How many?')} hint={qtyBad ? tr('Enter a whole number from 1 to 50') : qty > 1 ? tr('Adds {n} separate spares; each one keeps its own km and history.', { n: qty }) : tr('Bought several? Enter the number to add them all at once.')}>
            <input inputMode="numeric" value={f.qty} aria-label={tr('How many?')} onChange={(e) => setF({ ...f, qty: e.target.value.replace(/[^0-9]/g, '') })} />
          </Field>
        </div>
      )}
      <div className="row">
        <Field label={tr('Price paid (optional)')} hint={tr('Counts as running cost of the bike it is first installed on.')}>
          <input inputMode="decimal" value={f.price} onChange={(e) => setF({ ...f, price: e.target.value })} placeholder="€" />
        </Field>
        {qty > 1 && (
          <Field label={tr('That price is')}>
            <select value={f.price_total ? 'TOTAL' : 'EACH'} onChange={(e) => setF({ ...f, price_total: e.target.value === 'TOTAL' })}>
              <option value="EACH">{tr('per piece')}</option>
              <option value="TOTAL">{tr('for all {n} together', { n: qty })}</option>
            </select>
          </Field>
        )}
        <Field label={tr('Bought on (optional)')}>
          <input type="date" value={f.purchase_date} onChange={(e) => setF({ ...f, purchase_date: e.target.value })} />
        </Field>
      </div>
      <div className="row">
        <ShopPicker value={f.shop} onChange={(v) => setF({ ...f, shop: v })} />
      </div>
      {specFields.length > 0 && (
        <details className="add-props" open={propsOpen} onToggle={(e) => setPropsOpen((e.target as HTMLDetailsElement).open)}>
          <summary>
            {tr('Properties')} <span className="muted small">{tr('(optional)')}</span>
          </summary>
          <SpecInputs fields={specFields} raw={props} onChange={setProps} />
        </details>
      )}
      <Field label={tr('Notes (optional)')}>
        <textarea rows={2} aria-label={tr('Notes (optional)')} value={f.notes} onChange={(e) => setF({ ...f, notes: e.target.value })} />
      </Field>
      <Field label={tr('Usage before tracking')}>
        <select value={f.history} onChange={(e) => setF({ ...f, history: e.target.value })}>
          <option value="NEW">{tr('New part (0 km)')}</option>
          <option value="KNOWN">{tr('I know (or can estimate) its km')}</option>
          <option value="UNKNOWN">{tr('Unknown')}</option>
        </select>
      </Field>
      {f.history === 'KNOWN' && (
        <>
          <div className="row">
            <Field label={tr('km at that date')}>
              <input inputMode="decimal" value={f.start_km} onChange={(e) => setF({ ...f, start_km: e.target.value })} />
            </Field>
            <Field label={tr('As of')}>
              <input type="date" value={f.start_date} onChange={(e) => setF({ ...f, start_date: e.target.value })} />
            </Field>
          </div>
          <label className="check">
            <input type="checkbox" checked={f.start_estimate} onChange={(e) => setF({ ...f, start_estimate: e.target.checked })} /> {tr('This is an estimate')}
          </label>
        </>
      )}
      <MountPicker key={f.component_type} componentType={f.component_type} bikeId={bikeId} value={mount} onChange={setMount} allowSpare={!bikeId} />
      <div className="row">
        {mount && mount.slot === null && (
          <Field label={tr('Position name')}>
            <input value={f.install_slot} onChange={(e) => setF({ ...f, install_slot: e.target.value })} placeholder={tr('e.g. bottle cage 1')} />
          </Field>
        )}
        {mount && (
          <Field label={bikeId ? tr('Installed on') : tr('Since')}>
            <input type="date" value={f.install_at} onChange={(e) => setF({ ...f, install_at: e.target.value })} />
          </Field>
        )}
      </div>
      <FormError error={error} />
      <div className="form-actions">
        <button className="btn btn-primary" disabled={busy || !f.label.trim() || (!!bikeId && !mount)} onClick={save}>
          {busy ? tr('Saving…') : bikeId ? tr('Save and install') : qty > 1 ? tr('Add {n} parts', { n: qty }) : tr('Save')}
        </button>
        {onCancel && (
          <button className="btn" onClick={onCancel}>
            {tr('Cancel')}
          </button>
        )}
      </div>
    </div>
  )
}

interface ItemRow {
  id: number
  label: string
  type_name: string
  component_type: string
  product: string | null
  state: string
  state_text: string
  readiness: string | null
  readiness_text: string | null
  condition: 'NEW' | 'USED'
  storage_location: string | null
  location: { text: string }
  usage: ComponentSummary['usage']
  compatibility: { bike: string | null; verified: boolean }[]
}

interface StockLine {
  id: number
  name: string
  kind: string
  unit: string
  unit_note: string | null
  tracking_mode: 'COUNTED' | 'BULK'
  component_type: string | null
  product_id: number | null
  product: string | null
  storage_location: string | null
  min_stock: number | null
  track_stock: boolean
  stock: { qty: number; known: boolean } | null
  individual_spares: { id: number; label: string }[]
  available_total: number | null
  low: boolean
  purchases: number
  uses: number
  spent_cents: number
  compatibility: { bike: string | null; verified: boolean }[]
}

interface WorkSessionRow {
  id: number
  performed_at: string
  title: string | null
  undone_at: string | null
  undo_reason: string | null
  cost_cents: number
  transactions: { kind: string; text: string; voided?: boolean }[]
}

interface InventoryView {
  stock: StockLine[]
  supplies: StockLine[]
  available: ItemRow[]
  needs_service: ItemRow[]
  installed: ItemRow[]
  out_of_use: ItemRow[]
  shopping_list: ShoppingItem[]
  history: { component_id: number; label: string; text: string; on: string; note: string | null; voided: boolean }[]
  sessions: WorkSessionRow[]
}

const TABS = INVENTORY_TABS

const plural = (n: number, unit: string) => `${n.toLocaleString(locale)} ${unitWord(unit, n)}`

function Compat({ rows }: { rows: { bike: string | null; verified: boolean }[] }) {
  if (!rows.length) return null
  return (
    <span className="small">
      {tr(' · fits ')}
      {rows.map((r, i) => (
        <span key={i}>
          {i > 0 && ', '}
          {r.bike}
          {!r.verified && <span className="muted"> {tr('(unverified)')}</span>}
        </span>
      ))}
    </span>
  )
}

function ItemList({ rows, empty }: { rows: ItemRow[]; empty: string }) {
  const [type, setType] = useState('')
  const [q, setQ] = useState('')
  const types = Array.from(new Set(rows.map((r) => r.type_name))).sort()
  const shown = rows.filter((r) => (!type || r.type_name === type) && (!q || `${r.label} ${r.product ?? ''} ${r.storage_location ?? ''}`.toLowerCase().includes(q.toLowerCase())))
  if (!rows.length) return <Empty title={empty} />
  return (
    <>
      <div className="filters">
        <select value={type} onChange={(e) => setType(e.target.value)} aria-label={tr('Type')}>
          <option value="">{tr('All types')}</option>
          {types.map((t) => (
            <option key={t}>{t}</option>
          ))}
        </select>
        <input value={q} onChange={(e) => setQ(e.target.value)} placeholder={tr('Search name, model, location')} aria-label={tr('Search')} />
      </div>
      <ul className="list rows">
        {groupRows(shown).map((g) => {
          const r = g[0]
          return (
            <li key={r.id}>
              <span>
                {g.length > 1 ? (
                  <strong>{tr('{n} × {label}', { n: g.length, label: r.label })}</strong>
                ) : (
                  <Link to={`/inventory/${r.id}`}>
                    <strong>{r.label}</strong>
                  </Link>
                )}
                {r.product && <span className="muted"> — {r.product}</span>}
                <br />
                <span className="small">
                  {r.state === 'INSTALLED' ? r.location.text : r.state_text}
                  {r.readiness_text && r.state !== 'INSTALLED' && ` · ${r.readiness_text}`}
                  {g.length > 1 ? tr(' · {usage} lifetime each', { usage: usageText(r.usage) }) : tr(' · {usage} lifetime', { usage: usageText(r.usage) })}
                  {r.storage_location && ` · ${r.storage_location}`}
                </span>
                <Compat rows={r.compatibility} />
                {g.length > 1 && (
                  <details className="small">
                    <summary>{tr('Show each one')}</summary>
                    {g.map((x, i) => (
                      <span key={x.id}>
                        {i > 0 && ' · '}
                        <Link to={`/inventory/${x.id}`}>{`#${i + 1}`}</Link>
                      </span>
                    ))}
                  </details>
                )}
              </span>
              {r.readiness === 'READY' && <Tag tone="good">{tr('ready')}</Tag>}
              {(r.readiness === 'NEEDS_PREPARATION' || r.readiness === 'NEEDS_REPAIR') && <Tag tone="warn">{r.readiness === 'NEEDS_REPAIR' ? 'repair' : 'prepare'}</Tag>}
              {r.readiness === 'WORN' && <Tag tone="bad">{tr('worn')}</Tag>}
            </li>
          )
        })}
      </ul>
    </>
  )
}

/** Identical parts (same name, product, state, km, place) shown as one line "15 × Conti Race 28"
 * (Dirk 2026-11-15). Each part keeps its own page and history; only the list folds them together. */
function groupRows(rows: ItemRow[]): ItemRow[][] {
  const groups = new Map<string, ItemRow[]>()
  for (const r of rows) {
    const key = JSON.stringify([r.component_type, r.label, r.product, r.state, r.state_text, r.readiness, r.storage_location,
      r.location.text, usageText(r.usage), r.compatibility])
    const g = groups.get(key)
    if (g) g.push(r)
    else groups.set(key, [r])
  }
  return [...groups.values()]
}

function StockTxnForm({ line, onDone }: { line: StockLine; onDone: (msg: string) => void }) {
  const [f, setF] = useState({ kind: 'PURCHASE', qty: '', packages: '', price: '', note: '', on: today(), shop: '' })
  const [err, setErr] = useState<string | null>(null)
  const [opId, setOpId] = useState(newOpId)
  async function save() {
    setErr(null)
    try {
      const qty = f.qty === '' ? null : Number(f.qty.replace(',', '.'))
      await api.post(`/consumables/${line.id}/txn`, { kind: f.kind, qty, on: f.on, note: f.note || null, packages: f.packages ? Number(f.packages) : null, cost_cents: f.price ? Math.round(Number(f.price.replace(',', '.')) * 100) : null, shop: ['PURCHASE', 'RETURN'].includes(f.kind) ? f.shop.trim() || null : null }, opId)
      setOpId(newOpId())
      onDone({ PURCHASE: tr('Purchase recorded.'), RETURN: tr('Return recorded.'), ADJUST: tr('Stock corrected.'), USE: tr('Use recorded.') }[f.kind] ?? tr('Saved.'))
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form">
      <div className="chips">
        {[
          ['PURCHASE', tr('Bought')],
          ['RETURN', tr('Returned to shop')],
          ['ADJUST', tr('Correct the count')],
          ...(line.tracking_mode === 'BULK' ? [['USE', tr('Used')]] : []),
        ].map(([k, l]) => (
          <button key={k} className={`chip ${f.kind === k ? 'chip-on' : ''}`} onClick={() => setF({ ...f, kind: k })}>
            {l}
          </button>
        ))}
      </div>
      <div className="row">
        <Field label={f.kind === 'ADJUST' ? tr('Change (+/− {unitPlural})', { unitPlural: unitPlural(line.unit) }) : tr('Quantity ({unitPlural})', { unitPlural: unitPlural(line.unit) })} hint={line.unit_note ?? undefined}>
          <input inputMode="decimal" value={f.qty} onChange={(e) => setF({ ...f, qty: e.target.value })} placeholder={line.tracking_mode === 'BULK' ? 'optional' : ''} />
        </Field>
        {f.kind === 'PURCHASE' && line.tracking_mode === 'COUNTED' && (
          <Field label={tr('Packages (optional)')} hint={tr('A pack of 2 links = 1 package, 2 links.')}>
            <input inputMode="numeric" value={f.packages} onChange={(e) => setF({ ...f, packages: e.target.value })} />
          </Field>
        )}
        {(f.kind === 'PURCHASE' || f.kind === 'RETURN') && (
          <Field label={tr('Total € (optional)')}>
            <input inputMode="decimal" value={f.price} onChange={(e) => setF({ ...f, price: e.target.value })} />
          </Field>
        )}
      </div>
      <div className="row">
        <Field label={tr('On')}>
          <input type="date" value={f.on} onChange={(e) => setF({ ...f, on: e.target.value })} />
        </Field>
        <Field label={f.kind === 'ADJUST' ? tr('Why (required)') : tr('Note (optional)')}>
          <input value={f.note} onChange={(e) => setF({ ...f, note: e.target.value })} placeholder={f.kind === 'ADJUST' ? tr('counted the drawer') : ''} />
        </Field>
      </div>
      {(f.kind === 'PURCHASE' || f.kind === 'RETURN') && (
        <div className="row">
          <ShopPicker value={f.shop} onChange={(v) => setF({ ...f, shop: v })} label={f.kind === 'RETURN' ? tr('Returned to (optional)') : tr('Bought from (optional)')} />
        </div>
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

function InstallFromStock({ line, onDone }: { line: StockLine; onDone: (msg: string) => void }) {
  const bikes = useApi<Bike[]>('/bikes')
  const { meta } = useApp()
  const ctype = meta.component_types.find((t) => t.code === line.component_type)
  const [f, setF] = useState({ bike: '', slot: ctype?.slots[0] ?? '', parent: '', at: today() })
  const setup = useApi<{ setup: { component_id: number; label: string; component_type: string }[] }>(f.bike && ctype?.parent_types.length ? `/bikes/${f.bike}` : null)
  const [err, setErr] = useState<string | null>(null)
  const [opId] = useState(newOpId)
  async function save() {
    setErr(null)
    try {
      const r = await api.post<OpResult<{ label: string }>>(`/consumables/${line.id}/install`, { at: f.at, bike_id: f.parent ? null : Number(f.bike), parent_component_id: f.parent ? Number(f.parent) : null, slot: f.slot || null }, opId)
      onDone(tr('{label} installed from stock. {notice}', { label: r.result.label, notice: r.change.notice }))
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form">
      <p className="small muted">{tr('One {unit} leaves the stock count and becomes an individual part with its own history.', { unit: unitWord(line.unit, 1) })}</p>
      <div className="row">
        <Field label={tr('Bike')}>
          <select value={f.bike} onChange={(e) => setF({ ...f, bike: e.target.value, parent: '' })}>
            <option value="">{tr('Pick…')}</option>
            {bikes.data?.filter((b) => b.status === 'ACTIVE').map((b) => (
              <option key={b.id} value={b.id}>
                {b.name}
              </option>
            ))}
          </select>
        </Field>
        {ctype && ctype.parent_types.length > 0 && (
          <Field label={tr('Mounted on')}>
            <select value={f.parent} onChange={(e) => setF({ ...f, parent: e.target.value })}>
              <option value="">{tr('Pick…')}</option>
              {setup.data?.setup.filter((r) => ctype.parent_types.includes(r.component_type)).map((r) => (
                <option key={r.component_id} value={r.component_id}>
                  {r.label}
                </option>
              ))}
            </select>
          </Field>
        )}
        {ctype && ctype.slots.length > 1 && (
          <Field label={tr('Position')}>
            <select value={f.slot} onChange={(e) => setF({ ...f, slot: e.target.value })}>
              {ctype.slots.map((s) => (
                <option key={s} value={s}>
                  {slotName(s)}
                </option>
              ))}
            </select>
          </Field>
        )}
        <Field label={tr('Installed on')}>
          <input type="date" value={f.at} onChange={(e) => setF({ ...f, at: e.target.value })} />
        </Field>
      </div>
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" disabled={!f.bike} onClick={save}>
          {tr('Install one')}
        </button>
      </div>
    </div>
  )
}

function AddStockForm({ mode, onDone }: { mode: 'COUNTED' | 'BULK'; onDone: (msg: string) => void }) {
  const { meta } = useApp()
  const [f, setF] = useState({ component_type: mode === 'COUNTED' ? 'INNER_TUBE' : '', maker: '', model: '', name: '', kind: 'WAX', unit: mode === 'BULK' ? 'ml' : '', qty: '', location: '', min: '', track: true })
  const [err, setErr] = useState<string | null>(null)
  const [opId] = useState(newOpId)
  async function save() {
    setErr(null)
    try {
      let product_id: number | null = null
      if (f.component_type && f.model.trim()) {
        const p = await api.post<{ id: number }>('/products', { component_type: f.component_type, maker: f.maker || null, model: f.model })
        product_id = p.id
      }
      const body: Record<string, unknown> = { storage_location: f.location || null, min_stock: f.min ? Number(f.min) : null, name: f.name || null }
      if (mode === 'COUNTED') Object.assign(body, f.component_type ? { component_type: f.component_type, product_id } : { tracking_mode: 'COUNTED', kind: 'OTHER', unit: f.unit || 'pcs' })
      else Object.assign(body, { tracking_mode: 'BULK', kind: f.kind, unit: f.unit || 'ml', track_stock: f.track })
      const line = await api.post<{ id: number }>('/consumables', body, opId)
      // what is already on the shelf is a starting count, not a purchase (no price, no date of buying)
      if (f.qty) await api.post(`/consumables/${line.id}/txn`, { kind: 'ADJUST', qty: Number(f.qty.replace(',', '.')), on: today(), note: tr('Starting stock') })
      onDone(tr('Stock added.'))
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form">
      {mode === 'COUNTED' ? (
        <>
          <Field label={tr('What')} hint={tr('Spare parts get their own history when installed. Pick \'Other\' for patches or coin cells.')}>
            <select value={f.component_type} onChange={(e) => setF({ ...f, component_type: e.target.value })}>
              {meta.component_types.filter((t) => t.code !== 'OTHER').map((t) => (
                <option key={t.code} value={t.code}>
                  {t.name}
                </option>
              ))}
              <option value="">{tr('Other counted item (patches, coin cells…)')}</option>
            </select>
          </Field>
          {f.component_type ? (
            <div className="row">
              <Field label={tr('Maker (optional)')}>
                <input value={f.maker} onChange={(e) => setF({ ...f, maker: e.target.value })} />
              </Field>
              <Field label={tr('Model (optional)')}>
                <input value={f.model} onChange={(e) => setF({ ...f, model: e.target.value })} />
              </Field>
            </div>
          ) : (
            <div className="row">
              <Field label={tr('Name')}>
                <input value={f.name} onChange={(e) => setF({ ...f, name: e.target.value })} placeholder={tr('Park GP-2 patches')} />
              </Field>
              <Field label={tr('Unit')}>
                <input value={f.unit} onChange={(e) => setF({ ...f, unit: e.target.value })} placeholder="patch" />
              </Field>
            </div>
          )}
        </>
      ) : (
        <div className="row">
          <Field label={tr('Kind')}>
            <select value={f.kind} onChange={(e) => setF({ ...f, kind: e.target.value })}>
              {Object.entries(SUPPLY_KINDS).map(([k, label]) => (
                <option key={k} value={k}>
                  {label}
                </option>
              ))}
            </select>
          </Field>
          <Field label={tr('Product name')}>
            <input value={f.name} onChange={(e) => setF({ ...f, name: e.target.value })} />
          </Field>
          <Field label={tr('Unit')}>
            <input value={f.unit} onChange={(e) => setF({ ...f, unit: e.target.value })} />
          </Field>
        </div>
      )}
      <div className="row">
        <Field label={tr('In stock now (optional)')}>
          <input inputMode="decimal" value={f.qty} onChange={(e) => setF({ ...f, qty: e.target.value })} />
        </Field>
        <Field label={tr('Storage location (optional)')}>
          <input value={f.location} onChange={(e) => setF({ ...f, location: e.target.value })} placeholder={tr('Workshop drawer')} />
        </Field>
        <Field label={tr('Minimum stock (optional)')}>
          <input inputMode="decimal" value={f.min} onChange={(e) => setF({ ...f, min: e.target.value })} />
        </Field>
      </div>
      {mode === 'BULK' && (
        <label className="check">
          <input type="checkbox" checked={f.track} onChange={(e) => setF({ ...f, track: e.target.checked })} /> {tr('Track the amount in stock')}
        </label>
      )}
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" disabled={mode === 'BULK' ? !f.name : !f.component_type && !f.name} onClick={save}>
          {tr('Add')}
        </button>
      </div>
    </div>
  )
}

function StockLines({ lines, onChange, empty }: { lines: StockLine[]; onChange: (msg: string) => void; empty: string }) {
  const [sheet, setSheet] = useState<null | { txn: StockLine } | { install: StockLine }>(null)
  if (!lines.length) return <Empty title={empty} />
  return (
    <>
      <ul className="list rows">
        {lines.map((l) => (
          <li key={l.id}>
            <span>
              <strong>{l.name}</strong>
              <br />
              <span className="small">
                {l.stock ? (l.tracking_mode === 'COUNTED' ? tr('{n} new {units}', { n: l.stock.qty.toLocaleString(locale), units: unitWord(l.unit, l.stock.qty) }) : `${l.stock.qty.toLocaleString(locale)} ${l.unit}${l.stock.known ? '' : tr(' (some uses not measured)')}`) : tr('amount not tracked')}
                {l.individual_spares.length > 0 && trn(' + {n} individual spare', ' + {n} individual spares', l.individual_spares.length)}
                {l.storage_location && ` · ${l.storage_location}`}
                {l.min_stock !== null && tr(' · Minimum: {min_stock}', { min_stock: l.min_stock })}
                {l.spent_cents ? tr(' · spent {spent_cents}', { spent_cents: euro(l.spent_cents) }) : ''}
              </span>
              {l.unit_note && <span className="muted small"> · 1 {l.unit} = {l.unit_note}</span>}
              <Compat rows={l.compatibility} />
            </span>
            {l.low && <Tag tone="warn">{tr('below minimum')}</Tag>}
            <span className="row-actions">
              <button className="btn btn-small" onClick={() => setSheet({ txn: l })}>
                {tr('Stock change')}
              </button>
              {l.component_type && (l.stock?.qty ?? 0) >= 1 && (
                <button className="btn btn-small" onClick={() => setSheet({ install: l })}>
                  {tr('Install one')}
                </button>
              )}
            </span>
          </li>
        ))}
      </ul>
      {sheet && 'txn' in sheet && (
        <Sheet title={sheet.txn.name} onClose={() => setSheet(null)}>
          <StockTxnForm line={sheet.txn} onDone={(m) => { setSheet(null); onChange(m) }} />
        </Sheet>
      )}
      {sheet && 'install' in sheet && (
        <Sheet title={tr('Install from stock · {name}', { name: sheet.install.name })} onClose={() => setSheet(null)}>
          <InstallFromStock line={sheet.install} onDone={(m) => { setSheet(null); onChange(m) }} />
        </Sheet>
      )}
    </>
  )
}

function Sessions({ rows, onChange }: { rows: WorkSessionRow[]; onChange: (msg: string) => void }) {
  const [err, setErr] = useState<string | null>(null)
  async function undo(id: number) {
    const reason = window.prompt(tr('Undo this whole entry? Stock, installations and the old part come back. Reason (optional):'), '')
    if (reason === null) return
    setErr(null)
    try {
      const r = await api.post<OpResult<unknown>>(`/work-sessions/${id}/undo`, { reason: reason || null }, newOpId())
      onChange(tr('Undone. {notice}', { notice: r.change.notice }))
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  const meaningful = rows.filter((r) => r.transactions.length > 0)
  if (!meaningful.length) return <Empty title={tr('No changes recorded yet')} />
  return (
    <>
      <FormError error={err} form={false} />
      <ul className="list rows">
        {meaningful.map((w) => (
          <li key={w.id} className={w.undone_at ? 'excluded' : ''}>
            <span>
              <strong>{w.title ?? tr('Work')}</strong> <span className="muted small">{when(w.performed_at)}</span>
              {w.cost_cents ? <span className="small"> · {euro(w.cost_cents)}</span> : null}
              <br />
              <span className="small">{w.transactions.map((t) => t.text).join(' · ')}</span>
              {w.undone_at && <span className="small"> {tr('· undone')}{w.undo_reason ? `: ${w.undo_reason}` : ''}</span>}
            </span>
            {!w.undone_at && (
              <button className="btn btn-small" onClick={() => undo(w.id)}>
                {tr('Undo')}
              </button>
            )}
          </li>
        ))}
      </ul>
    </>
  )
}

export default function InventoryPage() {
  const { toast } = useApp()
  const [params, setParams] = useSearchParams()
  const tab = params.get('tab') ?? 'available'
  const [sheet, setSheet] = useState<null | 'part' | 'stock' | 'supply' | 'json'>(null)
  const nav = useNavigate()
  const view = useApi<InventoryView>(['chains', 'all', 'life'].includes(tab) ? null : '/inventory')
  const parts = useApi<ComponentSummary[]>(tab === 'all' ? '/components' : null)
  const chains = useApi<ChainRow[]>(tab === 'chains' ? '/chains' : null)
  const changed = (msg: string) => {
    setSheet(null)
    toast(msg)
    view.reload()
  }
  const v = view.data
  return (
    <Card
      title={tr('Inventory')}
      actions={
        <>
          <button className="btn btn-primary" onClick={() => setSheet('part')}>
            {tr('Add part')}
          </button>
          <button className="btn" onClick={() => setSheet('json')}>
            {tr('Import JSON')}
          </button>
          <button className="btn" onClick={() => setSheet('stock')}>
            {tr('Add spare stock')}
          </button>
          <button className="btn" onClick={() => setSheet('supply')}>
            {tr('Add supply')}
          </button>
        </>
      }
    >
      <div className="tabs" role="tablist">
        {TABS.map(([k, l]) => (
          <button key={k} role="tab" aria-selected={tab === k} className={`tab ${tab === k ? 'tab-on' : ''}`} onClick={() => setParams({ tab: k })}>
            {l}
            {k === 'shopping' && v && v.shopping_list.length > 0 && <span className="count">{v.shopping_list.length}</span>}
            {k === 'service' && v && v.needs_service.length > 0 && <span className="count">{v.needs_service.length}</span>}
          </button>
        ))}
      </div>
      {!['chains', 'all', 'life'].includes(tab) && view.loading && !v && <Loading />}
      {!['chains', 'all', 'life'].includes(tab) && view.error && <ErrorBox error={view.error} onRetry={view.reload} />}
      {tab === 'available' && v && (
        <>
          <h3>{tr('Spare stock')}</h3>
          <StockLines lines={v.stock} onChange={changed} empty={tr('No spare stock yet. Add tubes, pad sets or quick links as a count.')} />
          <h3>{tr('Individual spares')}</h3>
          <ItemList rows={v.available} empty={tr('No individual spares. Parts you take off and store appear here with their history.')} />
        </>
      )}
      {tab === 'service' && v && <ItemList rows={v.needs_service} empty={tr('Nothing waits for preparation or repair.')} />}
      {tab === 'installed' && v && <ItemList rows={v.installed} empty={tr('Nothing installed yet.')} />}
      {tab === 'shopping' && v && (
        <>
          <p className="small muted">{tr('Suggestions only, from the minimum stock you set and the spares to keep (Settings). Nothing is ordered.')}</p>
          {v.shopping_list.length === 0 ? (
            <Empty title={tr('Nothing below minimum')}>{tr('Set a minimum on a stock line to get reminders.')}</Empty>
          ) : (
            <ul className="list rows">
              {v.shopping_list.map((s) => (
                <li key={s.consumable_id ?? s.component_type}>
                  <span>
                    <strong>{s.name}</strong>
                    <br />
                    <span className="small">
                      {tr('Buy {qty} · {available} available, minimum {min}', { qty: plural(s.suggested_qty, s.unit), available: s.available, min: s.min_stock })}
                    </span>
                  </span>
                </li>
              ))}
            </ul>
          )}
        </>
      )}
      {tab === 'history' && v && (
        <>
          <h3>{tr('Changes (can be undone)')}</h3>
          <Sessions rows={v.sessions} onChange={changed} />
          <h3>{tr('What happened to parts')}</h3>
          {v.history.length === 0 ? (
            <Empty title={tr('No removed parts yet')} />
          ) : (
            <ul className="list">
              {v.history.map((h, i) => (
                <li key={i} className={h.voided ? 'excluded' : ''}>
                  <span>{when(h.on)}</span>
                  <Link to={`/inventory/${h.component_id}`}>{h.label}</Link>
                  <span className="small">
                    {h.text}
                    {h.note ? ` · ${h.note}` : ''}
                    {h.voided ? tr(' · undone') : ''}
                  </span>
                </li>
              ))}
            </ul>
          )}
          {v.out_of_use.length > 0 && (
            <>
              <h3>{tr('Out of use (kept for history)')}</h3>
              <ItemList rows={v.out_of_use} empty="" />
            </>
          )}
        </>
      )}
      {tab === 'life' && <PartLife />}
      {tab === 'supplies' && v && (
        <>
          <p className="small muted">{tr('Bulk supplies: wax, sealant, fluid, grease. The amount used per job is optional.')}</p>
          <StockLines lines={v.supplies} onChange={changed} empty={tr('No supplies yet.')} />
        </>
      )}
      {tab === 'chains' && (
        <>
          {chains.loading && !chains.data && <Loading />}
          {chains.error && <ErrorBox error={chains.error} onRetry={chains.reload} />}
          {chains.data?.length === 0 && <Empty title={tr('No chains yet')}>{tr('Add Chain A, B and C to rotate waxed chains.')}</Empty>}
          <div className="cards">
            {chains.data?.map((c) => (
              <Link to={`/inventory/${c.component_id}`} key={c.component_id} className="tile">
                <strong>
                  {c.label}
                </strong>
                <ChainStateTag state={c.state} />
                <span className="small">{c.text}</span>
                <span className="muted small">
                  {tr('Lifetime')} {km(c.lifetime_km, 0)}
                  {c.last_wear ? tr(' · wear {x}{x2} on {date}', { x: c.last_wear.value ?? '?', x2: c.last_wear.unit ?? '', date: when(c.last_wear.date) }) : tr(' · wear not measured')}
                </span>
              </Link>
            ))}
          </div>
        </>
      )}
      {tab === 'all' && (
        <>
          {parts.loading && !parts.data && <Loading />}
          {parts.error && <ErrorBox error={parts.error} onRetry={parts.reload} />}
          {parts.data?.length === 0 && <Empty title={tr('No parts here')}>{tr('Add a part with just a type and a name.')}</Empty>}
          {parts.data && parts.data.length > 0 && (
            <table className="table">
              <thead>
                <tr>
                  <th>{tr('Part')}</th>
                  <th>{tr('Type')}</th>
                  <th>{tr('Where')}</th>
                  <th className="num">{tr('Usage')}</th>
                </tr>
              </thead>
              <tbody>
                {parts.data.map((c) => (
                  <tr key={c.id} onClick={() => nav(`/inventory/${c.id}`)} className={c.status === 'RETIRED' ? 'excluded' : ''}>
                    <td>
                      <Link to={`/inventory/${c.id}`}>{c.label}</Link>
                    </td>
                    <td>{c.type_name}</td>
                    <td>{c.location.text}</td>
                    <td className="num" title={certaintyLabel(c.usage)}>
                      {usageText(c.usage)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </>
      )}
      {sheet === 'part' && (
        <Sheet title={tr('Add part')} onClose={() => setSheet(null)}>
          <ComponentForm
            presetType={tab === 'chains' ? 'CHAIN' : undefined}
            onSaved={(c, typed) => {
              // back to the Inventory list (Dirk 2026-11-01); the new part is one click away in the lists
              const n = c.created?.length ?? 1
              if (n > 1) changed(tr('{n} × {label} added as separate spares.', { n, label: typed || c.label }))
              else changed(tr('{label} added.', { label: c.label }))   // names may repeat (DECISIONS 144); a chain may get a letter
              parts.reload()
              chains.reload()
            }}
            onGroupset={changed}
            onCancel={() => setSheet(null)}
          />
        </Sheet>
      )}
      {sheet === 'json' && (
        <Sheet title={tr('Import products from JSON')} onClose={() => setSheet(null)}>
          <ProductImport onDone={changed} />
        </Sheet>
      )}
      {sheet === 'stock' && (
        <Sheet title={tr('Add spare stock')} onClose={() => setSheet(null)}>
          <AddStockForm mode="COUNTED" onDone={changed} />
        </Sheet>
      )}
      {sheet === 'supply' && (
        <Sheet title={tr('Add supply')} onClose={() => setSheet(null)}>
          <AddStockForm mode="BULK" onDone={changed} />
        </Sheet>
      )}
    </Card>
  )
}

interface ComponentDetail extends ComponentSummary {
  ledger: { kind: string; date: string; km: number; ride_id?: number; ride_name?: string | null; bike?: string; slot?: string; basis?: string; counted: boolean; certain: boolean; is_estimate?: boolean; detail: string | null; running_km: number; state?: string }[]
  history: { id: number; where: string; slot: string; installed_at: string; removed_at: string | null; removal_reason: string | null; removal_outcome: string | null; voided: boolean; void_reason: string | null; km: number | null; note: string | null }[]
  service_status: Task[]
  deletable?: boolean // nothing happened to it yet (never installed, no km, no work): can be deleted for good
  rules: Rule[]
  events: EventRow[]
  actions: { code: string; name: string }[]
  specs: Record<string, unknown>
  product_detail: { specs: Record<string, unknown> } | null
  dispositions: { id: number; disposition: string; label: string; effective_on: string; note: string | null; voided: boolean }[]
  inventory: ItemRow
  suggested_outcome: string
  parts: PartNode[]
  groupset_bike_id: number | null
  chain: (ChainRow & { cycles: WaxCycle[]; wax: { applications: WaxApplication[]; current: WaxCurrent | null } }) | null
  frame_history: FrameHistory | null
  spokes: SpokeInfo | null
  tire_tube: Record<'TIRE' | 'INNER_TUBE', { current: MountedRow | null; history: MountedRow[] }> | null
  charging: { charges: ChargeRow[]; since_last: ChargeRow | null; average: { km: number; hours: number; days: number; charges: number } | null } | null
  service_orders: ServiceOrder[]
  incident_choices: IncidentPick[]
}

interface MountedRow {
  component_id: number
  label: string
  installed_at: string
  removed_at: string | null
  km_here: number
  km_total: number
  punctures: number
  ended: string | null
  current: boolean
  defect: { since: string; group: string; ride_id: number | null } | null
}

// A wheel's tire and inner tube (Dirk 2026-11-02): the one on it now with its own km since it went in, and
// every one that was on this wheel before, with its km here, its punctures and how it came off.
interface ChargeRow {
  event_id: number
  charged_on: string
  until: string | null
  days: number
  km: number
  hours: number
  rides: number
  rides_without_time: number
}

// Charges of a battery-powered part with the riding in between (Dirk 2026-11-02: "when i charged them, i want
// to log it with a date and i want to see time and mileage between charges").
function ChargingCard({ data, onCharge }: { data: NonNullable<ComponentDetail['charging']>; onCharge: () => void }) {
  const h = (v: number) => `${v.toLocaleString(locale, { maximumFractionDigits: 1 })} h`
  const s = data.since_last
  return (
    <Card title={tr('Charging')} className="span-2" actions={<button className="btn btn-small" onClick={onCharge}>{tr('Log a charge')}</button>}>
      {s ? (
        <p className="small charge-now">
          <strong>{tr('Since the last charge')}</strong> {tr('on {date}', { date: when(s.charged_on) })}: {h(s.hours)} {tr('of riding ·')} {km(s.km, 0)} · {trn('{n} ride', '{n} rides', s.rides)} · {trn('{n} day', '{n} days', s.days)}
          {s.rides_without_time > 0 && <span className="muted"> ({s.rides_without_time} {tr('without a ride time)')}</span>}
        </p>
      ) : (
        <p className="small muted">{tr('No charge logged yet. Log the last one (a date is enough) to start counting.')}</p>
      )}
      {data.average && (
        <p className="small muted">
          {tr('On average between charges:')} {h(data.average.hours)} · {km(data.average.km, 0)} · {tr('{days} days', { days: data.average.days })} ({trn('{n} full period', '{n} full periods', data.average.charges)})
        </p>
      )}
      {data.charges.length > 0 && (
        <details>
          <summary className="small">{tr('All charges (')}{data.charges.length})</summary>
          <table className="table">
            <thead>
              <tr>
                <th>{tr('Charged')}</th>
                <th>{tr('Until')}</th>
                <th className="num">{tr('Riding')}</th>
                <th className="num">{tr('Km')}</th>
                <th className="num">{tr('Rides')}</th>
                <th className="num">{tr('Days')}</th>
              </tr>
            </thead>
            <tbody>
              {data.charges.map((c) => (
                <tr key={c.event_id}>
                  <td>{when(c.charged_on)}</td>
                  <td>{c.until ? when(c.until) : tr('now')}</td>
                  <td className="num">{h(c.hours)}</td>
                  <td className="num">{km(c.km, 0)}</td>
                  <td className="num">{c.rides}</td>
                  <td className="num">{c.days}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </details>
      )}
    </Card>
  )
}

function TireTubeCard({ data, onInstall, onReplace }: { data: NonNullable<ComponentDetail['tire_tube']>; onInstall: (kind: 'tire' | 'tube') => void; onReplace: (id: number) => void }) {
  const kinds = [
    ['INNER_TUBE', tr('Inner tube'), 'tube'],
    ['TIRE', tr('Tire'), 'tire'],
  ] as const
  return (
    <Card title={tr('Tire and inner tube')} className="span-2 tire-tube">
      {kinds.map(([code, name, kind]) => {
        const k = data[code]
        const cur = k.current
        const before = k.history.filter((h) => !h.current)
        return (
          <div key={code} className="tt-kind" data-kind={kind}>
            <h3 className="small muted">{name}</h3>
            {cur ? (
              <p className="tt-current">
                <Link to={`/inventory/${cur.component_id}`}>{cur.label}</Link> {tr('· in since')} {when(cur.installed_at)} · <strong>{km(cur.km_here, 0)}</strong> {tr('on this wheel')}
                {cur.km_total > cur.km_here + 0.5 && <span className="muted"> ({km(cur.km_total, 0)} {tr('in total)')}</span>}
                {cur.punctures > 0 && <span className="muted"> · {cur.punctures === 1 ? tr('1 puncture') : `${cur.punctures} punctures`}</span>}{' '}
                {cur.defect && (
                  <Tag tone="bad" title={tr('A puncture is logged and not fixed yet. Fix it on the ride (Fix → Replaced or Patched), or replace the tube here.')}>
                    {tr('defect · puncture')} {when(cur.defect.since)}
                  </Tag>
                )}{' '}
                <button className="btn btn-small" onClick={() => onReplace(cur.component_id)}>
                  {tr('Replace')} {kind}
                </button>
              </p>
            ) : (
              <p className="tt-current">
                <span className="muted">{tr(kind === 'tube' ? 'No tube recorded on this wheel.' : 'No tire recorded on this wheel.')}</span>{' '}
                <button className="btn btn-small" onClick={() => onInstall(kind)}>
                  {tr('Install')} {kind === 'tube' ? tr('an inner tube') : tr('a tire')}
                </button>
              </p>
            )}
            {before.length > 0 && (
              <details className="tt-history">
                <summary className="small">
                  {tr(kind === 'tube' ? 'Earlier tubes on this wheel ({n})' : 'Earlier tires on this wheel ({n})', { n: before.length })}
                </summary>
                <table className="table">
                  <thead>
                    <tr>
                      <th>{name}</th>
                      <th>{tr('On')}</th>
                      <th>{tr('Off')}</th>
                      <th className="num">{tr('Km here')}</th>
                      <th className="num">{tr('Punctures')}</th>
                      <th>{tr('Came off')}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {before.map((h, i) => (
                      <tr key={`${h.component_id}-${i}`}>
                        <td>
                          <Link to={`/inventory/${h.component_id}`}>{h.label}</Link>
                        </td>
                        <td>{when(h.installed_at)}</td>
                        <td>{h.removed_at ? when(h.removed_at) : '–'}</td>
                        <td className="num">{km(h.km_here, 0)}</td>
                        <td className="num">{h.punctures}</td>
                        <td className="small">
                          {h.ended ?? '–'}
                          {h.defect && <Tag tone="bad">{tr('defect')}</Tag>}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </details>
            )}
          </div>
        )
      })}
      <p className="small muted">{tr('Each tire and tube counts the rides from the day it went in until it comes off; the wheel keeps its own km.')}</p>
    </Card>
  )
}

interface FrameHistory {
  inspections: EventRow[]
  crashes: { group: string; on: string; label: string; text: string | null; bike: string | null; ride_id: number | null; ride_label: string | null; open: boolean }[]
}

// A wheel's broken spokes (DECISIONS 109): the count since it was laced, and a sheet to log one or see them all.
function SpokesCard({ wheelId, label, info, onChanged }: { wheelId: number; label: string; info: SpokeInfo; onChanged: () => void }) {
  const [open, setOpen] = useState(false)
  return (
    <Card title={tr('Spokes')}>
      <p className="small">
        <SpokeCount sp={info} />
      </p>
      {info.breaks.length > 0 && (
        <p className="small muted">
          {tr('Last broke')} {when(info.breaks[0].broke_on)}
          {info.breaks[0].replaced_on ? tr(', replaced {replaced_on}', { replaced_on: when(info.breaks[0].replaced_on) }) : tr(', not replaced yet')}.
        </p>
      )}
      <button className="btn btn-small" onClick={() => setOpen(true)}>
        {tr('Broken spoke…')}
      </button>
      {open && (
        <Sheet title={tr('Broken spokes · {label}', { label })} onClose={() => setOpen(false)}>
          <BrokenSpokes wheelId={wheelId} info={info} onChange={onChanged} />
        </Sheet>
      )}
    </Card>
  )
}

// A frame keeps its own record: inspections and crashes from the bikes it was on, while it was on them.
function FrameHistoryCard({ h, kind }: { h: FrameHistory; kind: string }) {
  return (
    <Card title={`${kind} history`}>
      <p className="small muted">{tr('Inspections and crashes while this {kind} was on a bike. They stay with it when it moves to another build.', { kind: lc(kind) })}</p>
      <details>
        <summary>
          {tr('Inspections (')}{h.inspections.length}){h.inspections[0] ? tr(' · last {performed_on}', { performed_on: when(h.inspections[0].performed_on) }) : ''}
        </summary>
        {h.inspections.length === 0 ? (
          <p className="small muted">{tr('None recorded. Record one on the bike with "Record work done" → Frame and fork inspection.')}</p>
        ) : (
          <ul className="list">
            {h.inspections.map((e) => (
              <li key={e.id} className="small">
                {when(e.performed_on)} · {e.bike}
                {e.outcome ? ` · ${e.outcome}` : ''}
                {e.notes ? ` · ${e.notes}` : ''}
              </li>
            ))}
          </ul>
        )}
      </details>
      <details>
        <summary>{tr('Crashes (')}{h.crashes.length})</summary>
        {h.crashes.length === 0 ? (
          <p className="small muted">{tr('No crashes recorded.')}</p>
        ) : (
          <ul className="list">
            {h.crashes.map((c) => (
              <li key={c.group} className="small">
                {when(c.on)} · {c.bike}
                {c.ride_id ? (
                  <>
                    {' · '}
                    <Link to={`/rides?open=${c.ride_id}`}>{c.ride_label ?? tr('ride')}</Link>
                  </>
                ) : null}
                {c.text ? ` · ${c.text}` : ''} {c.open ? <Tag tone="warn">{tr('open')}</Tag> : <Tag tone="good">{tr('solved')}</Tag>}
              </li>
            ))}
          </ul>
        )}
      </details>
    </Card>
  )
}

function RuleEditor({ rule, componentId, onDone }: { rule: Rule; componentId: number; onDone: () => void }) {
  const [f, setF] = useState({ interval_km: rule.interval_km?.toString() ?? '', interval_months: rule.interval_months?.toString() ?? '', interval_hours: rule.interval_hours?.toString() ?? '', interval_count: rule.interval_count?.toString() ?? '', window_min_km: rule.window_min_km?.toString() ?? '', window_max_km: rule.window_max_km?.toString() ?? '', after_top_up_km: rule.after_top_up_km?.toString() ?? '', origin: rule.origin === 'DEFAULT' ? 'PERSONAL' : rule.origin, scope: 'part' })
  const [err, setErr] = useState<string | null>(null)
  const num = (s: string) => (s.trim() === '' ? null : Number(s))
  async function save(active = true) {
    setErr(null)
    const body: Record<string, unknown> = { origin: f.origin, active }
    if (rule.trigger === 'INTERVAL') Object.assign(body, { interval_km: num(f.interval_km), interval_months: num(f.interval_months), interval_hours: num(f.interval_hours), ...(rule.action_code === 'WAX_HOT' ? { after_top_up_km: num(f.after_top_up_km) } : {}) })
    else if (rule.trigger === 'PARENT_COUNT') Object.assign(body, { interval_count: num(f.interval_count) })
    else Object.assign(body, { window_min_km: num(f.window_min_km), window_max_km: num(f.window_max_km) })
    try {
      if (f.scope === 'type' && rule.component_type) await api.patch(`/rules/${rule.id}`, body)
      else await api.post(`/components/${componentId}/rules`, { rule_code: rule.rule_code, ...body })
      onDone()
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form">
      {rule.notes && <p className="small muted">{rule.notes}</p>}
      {rule.trigger === 'INTERVAL' ? (
        <div className="row">
          <Field label={tr('Every … km')}>
            <input inputMode="decimal" value={f.interval_km} onChange={(e) => setF({ ...f, interval_km: e.target.value })} />
          </Field>
          <Field label={tr('or every … hours of riding')}>
            <input inputMode="decimal" aria-label={tr('Every … hours of riding')} value={f.interval_hours} onChange={(e) => setF({ ...f, interval_hours: e.target.value })} />
          </Field>
          <Field label={tr('or every … months')}>
            <input inputMode="numeric" value={f.interval_months} onChange={(e) => setF({ ...f, interval_months: e.target.value })} />
          </Field>
          {rule.action_code === 'WAX_HOT' && (
            <Field label={tr('After a liquid wax top-up: hot wax … km later')} hint={tr('e.g. 200: a top-up at 70 km moves the hot wax to 270 km. Empty: top-ups do not move it.')}>
              <input inputMode="decimal" aria-label={tr('Hot wax km after a top-up')} value={f.after_top_up_km} onChange={(e) => setF({ ...f, after_top_up_km: e.target.value })} />
            </Field>
          )}
        </div>
      ) : rule.trigger === 'PARENT_COUNT' ? (
        <div className="row">
          <Field label={tr('Replace after it has been on … parts')} hint={tr('e.g. a quick link after 2 chains')}>
            <input inputMode="numeric" value={f.interval_count} onChange={(e) => setF({ ...f, interval_count: e.target.value })} />
          </Field>
        </div>
      ) : (
        <div className="row">
          <Field label={tr('Window from … km')}>
            <input inputMode="decimal" value={f.window_min_km} onChange={(e) => setF({ ...f, window_min_km: e.target.value })} />
          </Field>
          <Field label={tr('to … km (after the cycle start)')}>
            <input inputMode="decimal" value={f.window_max_km} onChange={(e) => setF({ ...f, window_max_km: e.target.value })} />
          </Field>
        </div>
      )}
      <div className="row">
        <Field label={tr('Source')}>
          <select value={f.origin} onChange={(e) => setF({ ...f, origin: e.target.value })}>
            <option value="PERSONAL">{tr('Personal interval')}</option>
            <option value="MANUFACTURER">{tr('Manufacturer interval')}</option>
          </select>
        </Field>
        {rule.component_type && (
          <Field label={tr('Apply to')}>
            <select value={f.scope} onChange={(e) => setF({ ...f, scope: e.target.value })}>
              <option value="part">{tr('This part only')}</option>
              <option value="type">{tr('All parts of this type')}</option>
            </select>
          </Field>
        )}
      </div>
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn" onClick={() => save(false)}>
          {tr('Turn off for this part')}
        </button>
        <button className="btn btn-primary" onClick={() => save(true)}>
          {tr('Save rule')}
        </button>
      </div>
    </div>
  )
}

export function ComponentDetailPage() {
  const { id } = useParams()
  const navigate = useNavigate()
  const { toast, meta } = useApp()
  const actionName = (code: string | null) => lc(meta.actions.find((a) => a.code === code)?.name ?? code ?? '')
  const { data, error, loading, reload } = useApi<ComponentDetail>(`/components/${id}`)
  useCrumb(`/inventory/${id}`, data?.label)
  const [sheet, setSheet] = useState<null | 'log' | 'details' | 'start' | 'retire' | 'rule' | 'replace' | 'remove' | 'move' | 'disposition' | 'inuse' | 'sendout' | { rule: Rule } | { correct: number } | { back: ServiceOrder } | 'install' | 'tire' | 'tube' | { change: number }>(null)
  const [f, setF] = useState({ km: '', date: today(), estimate: true, reason: '', installed_at: '', removed_at: '', action_code: 'INSPECT', interval_km: '', interval_months: '', interval_hours: '', retire_as: '' })
  const [preview, setPreview] = useState<Change | null>(null)
  const [err, setErr] = useState<string | null>(null)
  if (loading && !data) return <Loading />
  if (error && !data) return <ErrorBox error={error} onRetry={reload} />
  if (!data) return null
  const close = () => {
    setSheet(null)
    setPreview(null)
    setErr(null)
  }
  async function op(path: string, body: unknown, dry = false) {
    setErr(null)
    try {
      const r = await api.post<OpResult<unknown>>(`${path}${dry ? '?dry_run=true' : ''}`, body)
      if (dry) return setPreview(r.change)
      toast(r.change?.notice ?? tr('Saved.'))
      close()
      reload()
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  async function plain(path: string, body: unknown) {
    setErr(null)
    try {
      await api.post(path, body)
      close()
      reload()
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  const u = data.usage
  const installed = data.location.state === 'INSTALLED'
  const ctype = meta.component_types.find((t) => t.code === data.component_type)
  const canMove = !!ctype && (ctype.parent_types.length > 0 || ctype.slots.length > 1)
  const inv = data.inventory
  const away = data.service_orders.find((o) => o.status === 'OUT' && o.component_id === data.id)
  const changed = (c: Change) => {
    toast(c.notice)
    close()
    reload()
  }
  // Km the part already had (e.g. a wheelset used on other bikes). Defaults to the day it was first
  // installed here, so rides from then on count on top of the value.
  const firstInstall = data.history.filter((h) => !h.voided).map((h) => h.installed_at.slice(0, 10)).sort()[0]
  const openStart = () => {
    setF({ ...f, km: u.starting_km !== null ? String(u.starting_km) : '', date: (u.starting_effective ?? firstInstall ?? today()).slice(0, 10), estimate: u.starting_km !== null ? u.starting_is_estimate : true })
    setSheet('start')
  }
  const ruleItem = (r: Rule) => (
              <li key={r.id}>
                <span>
                  {r.name}
                  {!r.active && <Tag>{tr('off')}</Tag>}
                </span>
                <span className="muted small">
                  {r.trigger === 'CYCLE_WINDOW' ? tr('once at {window_min_km}–{window_max_km} km after {actionName}', { window_min_km: r.window_min_km, window_max_km: r.window_max_km, actionName: actionName(r.cycle_action_code) }) : [r.interval_km && tr('every {interval_km} km', { interval_km: r.interval_km }), r.interval_months && tr('every {interval_months} months', { interval_months: r.interval_months })].filter(Boolean).join(tr(' or ')) + (r.after_top_up_km ? tr(', or {after_top_up_km} km after a liquid wax top-up', { after_top_up_km: r.after_top_up_km }) : '')}
                  {' · '}
                  {r.component_id ? tr('this part') : tr('type default')} · {r.origin.toLowerCase()}
                  {r.requires_setup && tr(' · only {toLowerCase}', { toLowerCase: lc(setupLabel(meta.tire_setups, r.requires_setup)) })}
                </span>
                <button className="btn btn-small" onClick={() => setSheet({ rule: r })}>
                  {tr('Edit')}
                </button>
              </li>
  )

  return (
    <div className="grid">
      <Card
        className="span-2"
        title={
          <>
            {data.label} <span className="muted small">{data.type_name}</span>
          </>
        }
        actions={
          data.status !== 'RETIRED' ? (
            <>
              {!installed && !away && !ctype?.rider_gear && (ctype?.slots.length || ctype?.parent_types.length) ? (
                <button className="btn btn-primary" onClick={() => setSheet('install')}>
                  {tr('Install')}
                </button>
              ) : null}
              {['FRONT_WHEEL', 'REAR_WHEEL', 'WHEELSET'].includes(data.component_type) && (
                <button className="btn" onClick={() => setSheet('tire')}>
                  {tr('Install a tire')}
                </button>
              )}
              {['FRONT_WHEEL', 'REAR_WHEEL', 'WHEELSET'].includes(data.component_type) && (
                <button className="btn" onClick={() => setSheet('tube')}>
                  {tr('Install an inner tube')}
                </button>
              )}
              {installed && (
                <button className="btn btn-primary" onClick={() => setSheet('replace')}>
                  {tr('Replace')}
                </button>
              )}
              <button className={installed || (!away && !ctype?.rider_gear && (ctype?.slots.length || ctype?.parent_types.length)) ? 'btn' : 'btn btn-primary'} onClick={() => setSheet('log')} title={tr('Cleaning, lubing, waxing, charging, checks, bleeds, repairs: anything you did to the bike or a part')}>
                {tr('Record work done')}
              </button>
              {ctype?.rider_gear && (
                <button className={data.disposition === 'IN_USE' ? 'btn' : 'btn btn-primary'} onClick={() => setSheet('inuse')}>
                  {data.disposition === 'IN_USE' ? tr('Stop using') : tr('Start using')}
                </button>
              )}
              {away && (
                <button className="btn btn-primary" onClick={() => setSheet({ back: away })}>
                  {tr('Back from repair')}
                </button>
              )}
              <button className="btn" onClick={() => setSheet('details')}>
                {tr('Edit details')}
              </button>
              {/* less frequent actions fold into one menu so the header stays short (phone: one row) */}
              <details className="more-menu">
                <summary className="btn">{tr('More…')}</summary>
                <div className="more-items" onClick={(e) => ((e.currentTarget.parentElement as HTMLDetailsElement).open = false)}>
                  {installed && (
                    <button className="btn" onClick={() => setSheet('remove')}>
                      {tr('Remove')}
                    </button>
                  )}
                  {installed && canMove && (
                    <button className="btn" onClick={() => setSheet('move')}>
                      {tr('Move')}
                    </button>
                  )}
                  {!installed && !ctype?.rider_gear && (
                    <button className="btn" onClick={() => setSheet('disposition')}>
                      {tr('Change status')}
                    </button>
                  )}
                  {!away && !ctype?.rider_gear && (
                    <button className="btn" onClick={() => setSheet('sendout')}>
                      {tr('Send away for repair')}
                    </button>
                  )}
                  <button className="btn" onClick={openStart}>
                    {tr('Starting km')}
                  </button>
                  <button className="btn" onClick={() => setSheet('retire')}>
                    {tr('Retire')}
                  </button>
                  {data.deletable && (
                    <button
                      className="btn btn-danger"
                      title={tr('Only while nothing happened to it yet: never installed, no km, no work, no notes')}
                      onClick={async () => {
                        if (!window.confirm(tr('Delete {label} for good? Use this only for a part entered by mistake.', { label: data.label }))) return
                        try {
                          await api.del(`/components/${data.id}`)
                          toast(tr('{label} deleted.', { label: data.label }))
                          navigate('/inventory')
                        } catch (e) {
                          toast((e as Error).message)
                        }
                      }}
                    >
                      {tr('Delete (entered by mistake)')}
                    </button>
                  )}
                </div>
              </details>
            </>
          ) : (
            data.disposition !== 'VOIDED' && (
              <button className="btn" onClick={() => setSheet('disposition')}>
                {tr('Back in stock…')}
              </button>
            )
          )
        }
      >
        <div className="stats">
          <div>
            <span className="stat">{usageText(u)}</span>
            <span className="muted small">{certaintyLabel(u)}</span>
          </div>
          <div>
            <span className="stat">{u.ride_count}</span>
            <span className="muted small">{tr('rides ·')} {u.hours.toLocaleString(locale, { maximumFractionDigits: 1 })} {tr('h riding')}</span>
          </div>
          <div>
            <span className="stat">{inv.state_text}</span>
            <span className="muted small">{installed || away ? data.location.text : [inv.readiness_text, data.storage_location].filter(Boolean).join(' · ')}</span>
          </div>
        </div>
        <p className="small">{u.summary}</p>
        {u.starting_km === null && data.status !== 'RETIRED' && (
          <p className="small muted">
            {tr('Already ridden before (on another bike or before Bike Log)?')}{' '}
            <button className="btn btn-small" onClick={openStart}>
              {tr('Add km from before')}
            </button>
          </p>
        )}
        {/* brand and model always visible (DECISIONS 149), with a way to set them */}
        <p className="small">
          <span className="muted">{tr('Brand and model:')}</span> {data.product ?? <span className="muted">{tr('not set')}</span>}{' '}
          <button className="btn btn-small" onClick={() => setSheet('details')}>
            {data.product ? tr('Change') : tr('Set brand and model')}
          </button>
        </p>
        {(data.component_type === 'FRONT_WHEEL' || data.component_type === 'REAR_WHEEL') && (
          <p className="small">
            {tr('Tire setup:')} <TireSetupSelect wheelId={data.id} value={data.tire_setup} onSaved={reload} />{' '}
            <span className="muted">{tr('Set on the wheel, so it moves with the wheel; the tire on it follows.')}</span>
          </p>
        )}
        {(data.component_type === 'TIRE' || data.component_type === 'INNER_TUBE') && (
          <p className="small muted">
            {tr('Tire setup:')} {data.tire_setup_from ? tr('{setupLabel} (set on {tire_setup_from})', { setupLabel: setupLabel(meta.tire_setups, data.effective_tire_setup), tire_setup_from: data.tire_setup_from }) : tr('follows the wheel it is mounted on')}
          </p>
        )}
        {data.component_type === 'TIRE' && (
          <p className="small">
            {tr('Tire pressure:')} <PressureNote tireId={data.id} value={data.pressure_note} onSaved={reload} />{' '}
            <span className="muted">{tr('A note, shown on the bike page. No reminder.')}</span>
          </p>
        )}
        {data.groupset_bike_id && (
          <p className="small">
            {tr('Part of the groupset of this bike:')} <Link to={`/bikes/${data.groupset_bike_id}/groupset`}>{tr('open the groupset page')}</Link>
          </p>
        )}
        <p className="small muted">
          {data.bundle ? (
            <>
              {tr('Bought in the bundle')} <strong>{data.bundle.name}</strong>
              {data.bundle.price_cents !== null ? ` (${euro(data.bundle.price_cents)}` : tr(' (no bundle price yet')}
              {data.bundle.merchant ? `, ${data.bundle.merchant}` : ''}
              {data.bundle.purchased_on ? `, ${when(data.bundle.purchased_on)}` : ''})
              {data.bundle.share_cents !== null ? tr(' · share ≈ {share_cents} (estimate)', { share_cents: euro(data.bundle.share_cents) }) : ''}
            </>
          ) : (
            <>
              {tr('Price:')} {data.price_cents !== null ? euro(data.price_cents) : tr('not entered')}
              {data.purchase_date ? tr(' · bought {purchase_date}', { purchase_date: when(data.purchase_date) }) : ''}
              {data.shop ? tr(' · from {shop}', { shop: data.shop }) : ''}
            </>
          )}
          {data.serial_number ? tr(' · serial {serial_number}', { serial_number: data.serial_number }) : ''}
          {data.warranty_until ? (
            <>
              {tr(' · warranty until {warranty_until} ', { warranty_until: when(data.warranty_until) })}
              {data.warranty_until < today() && <Tag>{tr('expired')}</Tag>}
            </>
          ) : (
            ''
          )}
        </p>
      </Card>
      {/* a wheel: the tire and tube on it come first (Dirk 2026-11-02) */}
      {data.tire_tube && <TireTubeCard data={data.tire_tube} onInstall={(k) => setSheet(k)} onReplace={(id) => setSheet({ change: id })} />}
      {data.charging && <ChargingCard data={data.charging} onCharge={() => setSheet('log')} />}
      <RepairsCard orders={data.service_orders} componentId={data.id} onBack={(o) => setSheet({ back: o })} />
      <Card title={tr('Service status')} className="span-2">
        <TaskList tasks={data.service_status} onChange={reload} emptyText={tr('No service rules for this part.')} />
        <div className="form-actions">
          <button className="btn btn-small" onClick={() => setSheet('rule')}>
            {tr('Add a rule for this part')}
          </button>
        </div>
      </Card>
      {data.spokes && <SpokesCard wheelId={data.id} label={data.label} info={data.spokes} onChanged={reload} />}
      {data.chain && <ChainCard comp={data} chain={data.chain} onChanged={reload} />}
      {data.parts.length > 0 && (
        <Card title={tr('Parts on it')} className="span-2">
          <p className="small muted">{tr('What is mounted on {label} now. Unfold a part to see what sits on it; open any part for its km, service and history.', { label: data.label })}</p>
          <PartTree nodes={data.parts} />
        </Card>
      )}
      <Card title={tr('Maintenance log')} className="span-2">
        <EventLog events={data.events} onChanged={reload} show="none" />
      </Card>
      {/* everything that happened to this part with its own km at each entry; folded so the page stays short */}
      <FoldedTimeline componentId={data.id} />
      <Card title={tr('Installation history')}>
        {data.history.length === 0 ? (
          <Empty title={tr('Never installed')} />
        ) : (
          <ul className="list">
            {data.history.map((h) => (
              <li key={h.id} className={h.voided ? 'excluded' : ''}>
                <span>{h.where}</span>
                <span className="small">
                  {when(h.installed_at)} → {h.removed_at ? when(h.removed_at) : 'now'}
                </span>
                <span className="small">
                  {h.voided ? tr('void: {void_reason}', { void_reason: h.void_reason }) : km(h.km)}
                  {!h.voided && h.removal_outcome && ` · ${h.removal_outcome === 'MOVED' ? 'moved' : (meta.dispositions.find((d) => d.code === h.removal_outcome)?.label ?? '').toLowerCase()}`}
                  {!h.voided && h.removal_reason && ` (${h.removal_reason})`}
                </span>
                {!h.voided && (
                  <button className="btn btn-small" onClick={() => { setF({ ...f, installed_at: h.installed_at.slice(0, 10), removed_at: h.removed_at?.slice(0, 10) ?? '' }); setSheet({ correct: h.id }) }}>
                    {tr('Correct')}
                  </button>
                )}
              </li>
            ))}
          </ul>
        )}
      </Card>
      <Card title={tr('Rules')}>
        {data.rules.length === 0 ? (
          <Empty title={tr('No rules')} />
        ) : (
          <>
            <ul className="list">{data.rules.filter((r) => r.applies !== false).map(ruleItem)}</ul>
            {/* rules for another setup (sealant on an inner-tube wheel) are kept but folded away (Dirk 2026-11-15) */}
            {data.rules.some((r) => r.applies === false) && (
              <details className="small">
                <summary>{tr('Not for this setup ({n})', { n: data.rules.filter((r) => r.applies === false).length })}</summary>
                <ul className="list">{data.rules.filter((r) => r.applies === false).map(ruleItem)}</ul>
              </details>
            )}
          </>
        )}
      </Card>
      {data.dispositions.length > 0 && (
        <Card title={tr('What happened to it')}>
          <ul className="list">
            {data.dispositions.map((d) => (
              <li key={d.id} className={d.voided ? 'excluded' : ''}>
                <span>{when(d.effective_on)}</span>
                <span>{d.label}</span>
                <span className="small">
                  {d.note}
                  {d.voided ? tr(' · undone') : ''}
                </span>
              </li>
            ))}
          </ul>
        </Card>
      )}
      <Card title={tr('Where the kilometres come from')} className="span-2">
        {data.ledger.length === 0 ? (
          <Empty title={tr('No usage recorded yet')} />
        ) : (
          <details className="task-group" data-group="ledger">
            <summary>
              <strong>
                {trn('{n} entry', '{n} entries', data.ledger.length)}
              </strong>{' '}
              <span className="muted small">
                {when(data.ledger[0].date)} → {when(data.ledger[data.ledger.length - 1].date)} · {usageText(u)} {tr('in total')}
              </span>
            </summary>
          <table className="table">
            <thead>
              <tr>
                <th>{tr('Date')}</th>
                <th>{tr('Source')}</th>
                <th>{tr('Bike')}</th>
                <th className="num">{tr('km')}</th>
                <th className="num">{tr('Running')}</th>
                <th>{tr('Note')}</th>
              </tr>
            </thead>
            <tbody>
              {data.ledger.map((e, i) => (
                <tr key={i} className={e.counted ? '' : 'excluded'}>
                  <td>{when(e.date)}</td>
                  <td>{e.kind === 'RIDE' ? <Link to={`/rides?open=${e.ride_id}`}>{e.ride_name || tr('Ride')}</Link> : e.kind === 'STARTING' ? tr('Starting value') : tr('Correction')}</td>
                  <td>{e.bike ?? ''}</td>
                  <td className="num">
                    {e.is_estimate ? '≈' : ''}
                    {km(e.km)}
                  </td>
                  <td className="num">{km(e.running_km, 0)}</td>
                  <td className="small">
                    {e.basis === 'EXPLICIT' && <Tag tone="info">{tr('confirmed')}</Tag>}
                    {!e.certain && <Tag tone="warn">{e.is_estimate ? 'estimate' : 'uncertain'}</Tag>}
                    {e.detail}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          </details>
        )}
      </Card>
      {ctype && ctype.specs.length > 0 && <PropertiesCard componentId={data.id} fields={ctype.specs} specs={data.specs} productSpecs={data.product_detail?.specs ?? null} notes={data.notes ?? null} onChanged={reload} />}
      {data.frame_history && <FrameHistoryCard h={data.frame_history} kind={data.type_name} />}
      <Journal componentId={data.id} className="span-2" />
      <ChangeLog componentId={data.id} refresh={data} className="span-2" />
      {sheet === 'log' && (
        <Sheet title={tr('Record work done · {label}', { label: data.label })} onClose={close}>
          <LogMaintenance componentId={data.id} onDone={(msg) => { close(); toast(msg); reload() }} />
        </Sheet>
      )}
      {(sheet === 'install' || sheet === 'tire' || sheet === 'tube') && (
        <Sheet title={sheet === 'tire' ? tr('Install a tire · {label}', { label: data.label }) : sheet === 'tube' ? tr('Install an inner tube · {label}', { label: data.label }) : tr('Install {label}', { label: data.label })} onClose={close}>
          <InstallHere
            componentType={sheet === 'tire' ? 'TIRE' : sheet === 'tube' ? 'INNER_TUBE' : data.component_type}
            part={sheet === 'install' ? data : undefined}
            // from a wheel: only that wheel (Dirk 2026-11-02); from a wheelset: its two wheels
            under={sheet === 'tire' || sheet === 'tube' ? (['FRONT_WHEEL', 'REAR_WHEEL'].includes(data.component_type) || data.component_type === 'WHEELSET' ? data.id : data.location.parent_component_id ?? undefined) : undefined}
            bikeId={(sheet === 'tire' || sheet === 'tube') && !['FRONT_WHEEL', 'REAR_WHEEL'].includes(data.component_type) && data.component_type !== 'WHEELSET' && data.location.bike_id ? data.location.bike_id : undefined}
            prefer={(sheet === 'tire' || sheet === 'tube') && ['FRONT_WHEEL', 'REAR_WHEEL'].includes(data.component_type) ? data.id : undefined}
            onCancel={close}
            onChange={(id) => setSheet({ change: id })}
            onDone={(msg) => {
              toast(msg)
              close()
              reload()
            }}
          />
        </Sheet>
      )}
      {sheet && typeof sheet === 'object' && 'change' in sheet && (
        <Sheet title={tr('Replace the part that is there')} onClose={close}>
          <ReplaceForm componentId={sheet.change} onDone={(c, label) => { changed(c); toast(`${label} installed. ${c.notice}`) }} />
        </Sheet>
      )}
      {sheet === 'replace' && (
        <Sheet title={tr('Replace {label}', { label: data.label })} onClose={close}>
          <ReplaceForm componentId={data.id} onDone={(c, label) => { changed(c); toast(`${label} installed. ${c.notice}`) }} />
        </Sheet>
      )}
      {sheet === 'remove' && (
        <Sheet title={tr('Remove {label}', { label: data.label })} onClose={close}>
          <RemoveForm componentId={data.id} suggested={data.suggested_outcome} onDone={changed} />
        </Sheet>
      )}
      {sheet === 'move' && (
        <Sheet title={tr('Move {label}', { label: data.label })} onClose={close}>
          <MoveForm componentId={data.id} onDone={changed} />
        </Sheet>
      )}
      {sheet === 'inuse' && (
        <Sheet title={data.disposition === 'IN_USE' ? tr('Stop using {label}', { label: data.label }) : tr('Start using {label}', { label: data.label })} onClose={close}>
          <InUseForm componentId={data.id} inUse={data.disposition === 'IN_USE'} onDone={(msg) => { close(); toast(msg); reload() }} />
        </Sheet>
      )}
      {sheet === 'disposition' && (
        <Sheet title={tr('Status of {label}', { label: data.label })} onClose={close}>
          <DispositionForm componentId={data.id} current={data.disposition} onDone={() => { close(); toast(tr('Saved.')); reload() }} />
        </Sheet>
      )}
      {sheet === 'sendout' && (
        <Sheet title={tr('Send {label} away for repair', { label: data.label })} onClose={close}>
          <SendOutForm componentId={data.id} label={data.label} incidents={data.incident_choices} onDone={(msg) => { close(); toast(msg); reload() }} />
        </Sheet>
      )}
      {sheet && typeof sheet === 'object' && 'back' in sheet && (
        <Sheet title={tr('Back from repair: {label}', { label: data.label })} onClose={close}>
          <ReturnForm order={sheet.back} onDone={(msg) => { close(); toast(msg); reload() }} />
        </Sheet>
      )}
      {sheet === 'details' && (
        <Sheet title={tr('Edit {label}', { label: data.label })} onClose={close}>
          <DetailsForm comp={data} onDone={() => (close(), reload(), toast(tr('Saved.')))} />
        </Sheet>
      )}
      {sheet === 'start' && (
        <Sheet title={tr('Starting mileage')} onClose={close}>
          <div className="form">
            <p className="small muted">
              {tr('The km the part already had on the given date, for example a wheelset used on other bikes. Rides recorded in Bike Log after that date are added on top; rides before it are treated as already inside this value. The date is set to the day the part was first installed here')}
              {firstInstall ? ` (${when(firstInstall)})` : ''}{tr(', so enter the km it had then.')}
            </p>
            <div className="row">
              <Field label="km">
                <input inputMode="decimal" value={f.km} onChange={(e) => setF({ ...f, km: e.target.value })} />
              </Field>
              <Field label={tr('As of')}>
                <input type="date" value={f.date} onChange={(e) => setF({ ...f, date: e.target.value })} />
              </Field>
            </div>
            <label className="check">
              <input type="checkbox" checked={f.estimate} onChange={(e) => setF({ ...f, estimate: e.target.checked })} /> {tr('Estimate')}
            </label>
            <ChangeNotice change={preview} />
            <FormError error={err} />
            <div className="form-actions">
              <button className="btn" onClick={() => op(`/components/${data.id}/starting-usage`, { km: Number(f.km), effective: f.date, is_estimate: f.estimate }, true)}>
                {tr('Preview')}
              </button>
              <button className="btn btn-primary" onClick={() => op(`/components/${data.id}/starting-usage`, { km: Number(f.km), effective: f.date, is_estimate: f.estimate })}>
                {tr('Save')}
              </button>
            </div>
          </div>
        </Sheet>
      )}
      {sheet === 'retire' && (
        <Sheet title={tr('Retire {label}', { label: data.label })} onClose={close}>
          <div className="form">
            <p className="small muted">{tr('The part and its history are kept. It is removed from its bike on that date.')}</p>
            <OutcomeChoice name="retire" outcomes={meta.dispositions.filter((d) => ['RETIRED', 'DISCARDED', 'SOLD'].includes(d.code))} value={f.retire_as || (data.suggested_outcome === 'DISCARDED' ? 'DISCARDED' : 'RETIRED')} suggested={data.suggested_outcome === 'DISCARDED' ? 'DISCARDED' : 'RETIRED'} onChange={(v) => setF({ ...f, retire_as: v })} />
            <Field label={tr('Retired on')}>
              <input type="date" value={f.date} onChange={(e) => setF({ ...f, date: e.target.value })} />
            </Field>
            <Field label={tr('Reason')}>
              <input value={f.reason} onChange={(e) => setF({ ...f, reason: e.target.value })} placeholder={tr('worn 0.5%')} />
            </Field>
            <FormError error={err} />
            <div className="form-actions">
              <button className="btn btn-danger" onClick={() => plain(`/components/${data.id}/retire`, { on: f.date, reason: f.reason || null, disposition: f.retire_as || (data.suggested_outcome === 'DISCARDED' ? 'DISCARDED' : 'RETIRED') })}>
                {tr('Retire')}
              </button>
            </div>
          </div>
        </Sheet>
      )}
      {sheet === 'rule' && (
        <Sheet title={tr('Add a rule for this part')} onClose={close}>
          <div className="form">
            <Field label={tr('Action')}>
              <select value={f.action_code} onChange={(e) => setF({ ...f, action_code: e.target.value })}>
                {data.actions.map((a) => (
                  <option key={a.code} value={a.code}>
                    {a.name}
                  </option>
                ))}
              </select>
            </Field>
            <div className="row">
              <Field label={tr('Every … km')}>
                <input inputMode="decimal" value={f.interval_km} onChange={(e) => setF({ ...f, interval_km: e.target.value })} />
              </Field>
              <Field label={tr('or every … hours of riding')}>
                <input inputMode="decimal" value={f.interval_hours} onChange={(e) => setF({ ...f, interval_hours: e.target.value })} />
              </Field>
              <Field label={tr('or every … months')}>
                <input inputMode="numeric" value={f.interval_months} onChange={(e) => setF({ ...f, interval_months: e.target.value })} />
              </Field>
            </div>
            <FormError error={err} />
            <div className="form-actions">
              <button
                className="btn btn-primary"
                onClick={() =>
                  plain(`/components/${data.id}/rules`, {
                    action_code: f.action_code,
                    interval_km: f.interval_km ? Number(f.interval_km) : null,
                    interval_months: f.interval_months ? Number(f.interval_months) : null,
                    interval_hours: f.interval_hours ? Number(f.interval_hours) : null,
                  })
                }
              >
                {tr('Add rule')}
              </button>
            </div>
          </div>
        </Sheet>
      )}
      {sheet && typeof sheet === 'object' && 'rule' in sheet && (
        <Sheet title={tr('Edit: {name}', { name: sheet.rule.name })} onClose={close}>
          <RuleEditor rule={sheet.rule} componentId={data.id} onDone={() => { close(); reload() }} />
        </Sheet>
      )}
      {sheet && typeof sheet === 'object' && 'correct' in sheet && (
        <Sheet title={tr('Correct installation record')} onClose={close}>
          <div className="form">
            <p className="small muted">{tr('Use this when the record is wrong (a correction), not when you swapped parts.')}</p>
            <div className="row">
              <Field label={tr('Installed on')}>
                <input type="date" value={f.installed_at} onChange={(e) => setF({ ...f, installed_at: e.target.value })} />
              </Field>
              <Field label={tr('Removed on')}>
                <input type="date" value={f.removed_at} onChange={(e) => setF({ ...f, removed_at: e.target.value })} />
              </Field>
            </div>
            <Field label={tr('Why')}>
              <input value={f.reason} onChange={(e) => setF({ ...f, reason: e.target.value })} />
            </Field>
            <ChangeNotice change={preview} />
            <FormError error={err} />
            <div className="form-actions">
              <button className="btn" onClick={() => op(`/installations/${sheet.correct}/correct`, { installed_at: f.installed_at || null, removed_at: f.removed_at || null, clear_removed: !f.removed_at, reason: f.reason }, true)}>
                {tr('Preview mileage impact')}
              </button>
              <button className="btn" onClick={() => op(`/installations/${sheet.correct}/void`, { reason: f.reason || tr('record was wrong') })}>
                {tr('Record was wrong: void it')}
              </button>
              <button className="btn btn-primary" onClick={() => op(`/installations/${sheet.correct}/correct`, { installed_at: f.installed_at || null, removed_at: f.removed_at || null, clear_removed: !f.removed_at, reason: f.reason })}>
                {tr('Save correction')}
              </button>
            </div>
          </div>
        </Sheet>
      )}
    </div>
  )
}

interface WaxCycle {
  cycle: number
  waxed_on: string
  km: number
  current: boolean
}

interface WaxApplication {
  n: number
  event_id: number
  date: string
  action_code: string
  type: string
  product: string | null
  at_km: number | null
  ridden_km: number
  days_on: number
  active: boolean
  ended_by: { n: number; type: string } | null
  next_due: string | null
}

interface WaxCurrent {
  type: string
  date: string
  at_km: number | null
  km_since: number
  chain_km_since_hot_wax: number | null
  hot_wax_due_at_km: number | null
  hot_wax_left_km: number | null
}

// "Current: liquid wax top-up 12 Oct at 79 km · 41 km since · hot wax due at 279 km (159 km left)"
function waxNow(c: WaxCurrent): string {
  let t = tr('{toLowerCase} {date}{x} · {km_since} since', { toLowerCase: lc(c.type), date: when(c.date), x: c.at_km != null ? tr(' at {km}', { km: km(c.at_km, 0) }) : '', km_since: km(c.km_since, 0) })
  if (c.hot_wax_due_at_km != null) {
    const left = c.hot_wax_left_km ?? 0
    t += tr(' · hot wax due at {hot_wax_due_at_km} ({x})', { hot_wax_due_at_km: km(c.hot_wax_due_at_km, 0), x: left >= 0 ? tr('{km} left', { km: km(left, 0) }) : tr('{km} over', { km: km(-left, 0) }) })
  }
  return t
}

// A chain's place in a rotation and its wax cycles: each hot wax, the liquid-wax top-ups in it and the km.
function ChainCard({ comp, chain, onChanged }: { comp: ComponentSummary; chain: NonNullable<ComponentDetail['chain']>; onChanged: () => void }) {
  const { toast } = useApp()
  const bikes = useApi<Bike[]>('/bikes')
  async function setRotation(v: string) {
    try {
      await api.patch(`/components/${comp.id}`, { rotation_bike_id: v ? Number(v) : null })
      toast(v ? tr('{label} is in the chain rotation of {name}.', { label: comp.label, name: bikes.data?.find((b) => b.id === Number(v))?.name }) : tr('{label} left the chain rotation.', { label: comp.label }))
      onChanged()
    } catch (e) {
      toast((e as Error).message)
    }
  }
  return (
    <Card title={tr('Chain rotation and wax cycles')} className="span-2">
      <p className="small">
        <ChainStateTag state={chain.state} /> {chain.text}
      </p>
      <label className="inline-field small">
        {tr('Chain rotation of')}{' '}
        <select aria-label={tr('Chain rotation')} value={chain.rotation_bike_id ?? ''} onChange={(e) => setRotation(e.target.value)}>
          <option value="">{tr('No rotation')}</option>
          {bikes.data?.filter((b) => b.status === 'ACTIVE').map((b) => (
            <option key={b.id} value={b.id}>
              {b.name}
            </option>
          ))}
        </select>
      </label>
      {chain.rotation_bike_id && (
        <span className="small">
          {' '}
          · <Link to={`/bikes/${chain.rotation_bike_id}`}>{tr('open the bike for swaps and waxing')}</Link>
        </span>
      )}
      {chain.wax.applications.length === 0 ? (
        <p className="small muted">{tr('No hot wax or liquid wax top-up recorded yet.')}</p>
      ) : (
        <>
          {chain.wax.current && (
            <p className="small wax-now">
              <strong>{tr('Current:')}</strong> {waxNow(chain.wax.current)}
            </p>
          )}
          <table className="table wax-apps">
            <thead>
              <tr>
                <th>#</th>
                <th>{tr('Date')}</th>
                <th>{tr('Type')}</th>
                <th>{tr('Product')}</th>
                <th className="num">{tr('At chain km')}</th>
                <th className="num">{tr('Ridden on it')}</th>
                <th className="num">{tr('Days on')}</th>
                <th>{tr('Active')}</th>
                <th>{tr('Ended by')}</th>
                <th>{tr('Next due')}</th>
              </tr>
            </thead>
            <tbody>
              {chain.wax.applications.map((w) => (
                <tr key={w.event_id} className={w.active ? 'wax-active' : ''}>
                  <td data-label="#">{w.n}</td>
                  <td data-label="Date">{when(w.date)}</td>
                  <td data-label="Type">{w.type}</td>
                  <td data-label="Product">{w.product ?? '—'}</td>
                  <td data-label="At chain km" className="num">{w.at_km != null ? km(w.at_km, 0) : '—'}</td>
                  <td data-label="Ridden on it" className="num">{km(w.ridden_km, 0)}</td>
                  <td data-label="Days on" className="num">{w.days_on} d</td>
                  <td data-label="Active">{w.active ? tr('Yes') : tr('No')}</td>
                  <td data-label="Ended by">{w.ended_by ? `${w.ended_by.type === 'Hot wax' ? tr('Hot wax') : tr('Top-up')} (#${w.ended_by.n})` : '—'}</td>
                  <td data-label="Next due">{w.next_due ?? '—'}</td>
                </tr>
              ))}
            </tbody>
          </table>
          <p className="small muted">
            {tr('At chain km: km since the last hot wax when it was applied. Ridden on it and Days on: while it was the latest application (the active one: until today).')}
          </p>
        </>
      )}
      <p className="small muted">
        {tr('After a liquid wax top-up the next hot wax is due a set distance after it (200 km unless you change it under Rules → Hot wax chain → Edit).')}
      </p>
    </Card>
  )
}

function DetailsForm({ comp, onDone }: { comp: ComponentSummary; onDone: () => void }) {
  const [f, setF] = useState({ label: comp.name ?? comp.label, mark: comp.mark ?? '', price: centsInput(comp.price_cents), purchase_date: comp.purchase_date ?? '', serial_number: comp.serial_number ?? '', warranty_until: comp.warranty_until ?? '', notes: comp.notes ?? '', shop: comp.shop ?? '', maker: comp.product_maker ?? '', model: comp.product_model ?? '' })
  const [err, setErr] = useState<string | null>(null)
  async function save() {
    setErr(null)
    const price = toCents(f.price)
    if (Number.isNaN(price)) return setErr(tr('Price: enter an amount such as 49,90'))
    // brand and model only when changed, so saving other details never swaps the product row
    const changed = f.maker.trim() !== (comp.product_maker ?? '').trim() || f.model.trim() !== (comp.product_model ?? '').trim()
    const productChange = changed ? { product_maker: f.maker.trim() || null, product_model: f.model.trim() || null } : {}
    try {
      await api.patch(`/components/${comp.id}`, { label: f.label, mark: f.mark || null, price_cents: price, purchase_date: f.purchase_date || null, serial_number: f.serial_number || null, warranty_until: f.warranty_until || null, notes: f.notes || null, shop: f.shop.trim() || null, ...productChange })
      onDone()
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form">
      <Field label={tr('Name / label')} hint={f.mark.trim() ? tr('Shown as "{trim} [{trim2}]"', { trim: f.label.trim(), trim2: f.mark.trim() }) : undefined}>
        <input value={f.label} onChange={(e) => setF({ ...f, label: e.target.value })} />
      </Field>
      <ProductPicker componentType={comp.component_type} maker={f.maker} model={f.model} name={f.label} onChange={(maker, model) => setF({ ...f, maker, model })} />
      <div className="row">
        {comp.bundle ? (
          <Field label={tr('Price paid')} hint={tr('Bought in the bundle "{name}": the bundle carries the price (change it on the bike page under "Bought as a bundle").', { name: comp.bundle.name })}>
            <input value="in bundle" disabled aria-label={tr('Price paid (in bundle)')} />
          </Field>
        ) : (
          <Field label={tr('Price paid')} hint={tr('Leave empty if it came with the bike (then it is part of the bike\'s price).')}>
            <input inputMode="decimal" value={f.price} onChange={(e) => setF({ ...f, price: e.target.value })} placeholder="€" />
          </Field>
        )}
        <Field label={tr('Bought on')}>
          <input type="date" value={f.purchase_date} onChange={(e) => setF({ ...f, purchase_date: e.target.value })} />
        </Field>
      </div>
      <div className="row">
        <ShopPicker value={f.shop} onChange={(v) => setF({ ...f, shop: v })} label={tr('Bought from')} />
      </div>
      <Field label={tr('Mark')} hint={comp.component_type === 'CHAIN' ? tr('A short tag such as A, B or 2 dots, shown after the name: "Chain [A]". Mark the chain itself with a punch or engraver on an outer plate; paint and nail polish come off in hot wax.') : tr('A short tag shown after the name, e.g. A or red sticker: "Name [A]". Two parts of one type cannot have the same name and mark (tires and tubes can).')}>
        <input value={f.mark} maxLength={20} onChange={(e) => setF({ ...f, mark: e.target.value })} />
      </Field>
      <div className="row">
        <Field label={tr('Serial number')}>
          <input value={f.serial_number} onChange={(e) => setF({ ...f, serial_number: e.target.value })} />
        </Field>
        <Field label={tr('Warranty until')}>
          <input type="date" value={f.warranty_until} onChange={(e) => setF({ ...f, warranty_until: e.target.value })} />
        </Field>
      </div>
      <Field label={tr('Notes')} hint={tr('For dated notes such as issues, use the journal below.')}>
        <textarea rows={2} value={f.notes} onChange={(e) => setF({ ...f, notes: e.target.value })} />
      </Field>
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" disabled={!f.label.trim()} onClick={save}>
          {tr('Save')}
        </button>
      </div>
    </div>
  )
}

// Shoes are worn, not mounted: while in use they (and the cleats on them) count every ride on any bike.
function InUseForm({ componentId, inUse, onDone }: { componentId: number; inUse: boolean; onDone: (msg: string) => void }) {
  const [on, setOn] = useState(today())
  const [error, setError] = useState<string | null>(null)
  const [opId] = useState(newOpId)
  async function run() {
    setError(null)
    try {
      await api.post(`/components/${componentId}/disposition`, { disposition: inUse ? 'STORED' : 'IN_USE', on, note: null }, opId)
      onDone(inUse ? tr('Stored: rides no longer count on these.') : tr('In use: every ride from that day counts on these and the cleats on them.'))
    } catch (e) {
      setError((e as Error).message)
    }
  }
  return (
    <div className="form">
      <p className="muted">
        {inUse
          ? tr('Rides after this day no longer count on these shoes and their cleats.')
          : tr('From this day every ride with a bike counts on these shoes and the cleats mounted on them, whichever bike you ride.')}
      </p>
      <Field label={inUse ? tr('Stopped on') : tr('In use since')}>
        <input type="date" value={on} onChange={(e) => setOn(e.target.value)} />
      </Field>
      <FormError error={error} />
      <div className="form-actions">
        <button className="btn btn-primary" onClick={run}>
          {inUse ? tr('Stop using') : tr('Start using')}
        </button>
      </div>
    </div>
  )
}
