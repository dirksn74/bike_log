import { useState } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { api, newOpId } from '../api'
import Bundles from '../components/Bundles'
import { BikeIncidents } from '../components/Incidents'
import GroupsetImport from '../components/GroupsetImport'
import ChangeLog from '../components/ChangeLog'
import Journal from '../components/Journal'
import LogMaintenance from '../components/LogMaintenance'
import { MoveForm, RemoveForm, ReplaceForm } from '../components/PartChange'
import { SwapTube } from '../components/Repairs'
import MountPicker, { type MountTarget } from '../components/MountPicker'
import ChainRotation from '../components/ChainRotation'
import EventLog from '../components/EventLog'
import Timeline from '../components/Timeline'
import { AwayCard } from '../components/ServiceOrders'
import ShopPicker from '../components/ShopPicker'
import { BrokenSpokes, SpokeCount } from '../components/Spokes'
import InstallHere from '../components/InstallHere'
import { GroupedTasks } from '../components/TaskList'
import { PressureNote, TireSetupSelect } from '../components/TireSetup'
import { Card, ChangeNotice, Empty, ErrorBox, Field, FormError, Loading, Sheet, StatusBadge, Tag } from '../components/ui'
import { useApp } from '../context'
import { centsInput, certaintyLabel, duration, euro, km, slotName, toCents, today, usageText, when } from '../format'
import { BIKE_TABS, useCrumb } from '../crumbs'
import { useApi } from '../hooks'
import { RideDetailView } from './Rides'
import { ComponentForm } from './Inventory'
import type { Bike, BikeCosts, BrakeRow, Change, ComponentSummary, EventRow, GroupsetSummary, OpResult, RideIncident, RideRow, ServiceOrder, SetupRow, Task } from '../types'
import { tr, codeText, trn, lc } from '../i18n'

export function BikeForm({ onSaved }: { onSaved: (b: Bike) => void }) {
  const { meta } = useApp()
  const [f, setF] = useState({ name: '', maker: '', model: '', strava_gear_id: '', starting_km: '', starting_date: today(), starting_is_estimate: true, price: '', purchase_date: '', shifting: '', shop: '' })
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [opId] = useState(newOpId)
  async function save() {
    setBusy(true)
    setError(null)
    try {
      const body: Record<string, unknown> = { name: f.name }
      if (f.maker) body.maker = f.maker
      if (f.model) body.model = f.model
      if (f.strava_gear_id) body.strava_gear_id = f.strava_gear_id
      const price = toCents(f.price)
      if (Number.isNaN(price)) throw new Error(tr('Price: enter an amount such as 3.499,00 or 3499'))
      if (price !== null) body.purchase_price_cents = price
      if (f.purchase_date) body.purchase_date = f.purchase_date
      if (f.shop.trim()) body.shop = f.shop.trim()
      if (f.shifting) body.shifting = f.shifting
      if (f.starting_km) Object.assign(body, { starting_km: Number(f.starting_km), starting_date: f.starting_date, starting_is_estimate: f.starting_is_estimate })
      onSaved(await api.post<Bike>('/bikes', body, opId))
    } catch (e) {
      setError((e as Error).message)
    } finally {
      setBusy(false)
    }
  }
  return (
    <div className="form">
      <Field label={tr('Name')}>
        <input value={f.name} onChange={(e) => setF({ ...f, name: e.target.value })} placeholder={tr('TIME NXR')} autoFocus />
      </Field>
      <div className="row">
        <Field label={tr('Maker (optional)')}>
          <input value={f.maker} onChange={(e) => setF({ ...f, maker: e.target.value })} />
        </Field>
        <Field label={tr('Model (optional)')}>
          <input value={f.model} onChange={(e) => setF({ ...f, model: e.target.value })} />
        </Field>
      </div>
      <div className="row">
        <Field label={tr('Purchase price (optional)')} hint={tr('Initial cost of the bike.')}>
          <input inputMode="decimal" value={f.price} onChange={(e) => setF({ ...f, price: e.target.value })} placeholder="€" />
        </Field>
        <Field label={tr('Bought on (optional)')}>
          <input type="date" value={f.purchase_date} onChange={(e) => setF({ ...f, purchase_date: e.target.value })} />
        </Field>
      </div>
      <div className="row">
        <ShopPicker value={f.shop} onChange={(v) => setF({ ...f, shop: v })} />
      </div>
      <Field label={tr('Shifting')} hint={tr('Decides which reminders apply (Di2 checks or cable checks). Not set: electronic once a Di2/AXS battery is fitted.')}>
        <select aria-label={tr('Shifting')} value={f.shifting} onChange={(e) => setF({ ...f, shifting: e.target.value })}>
          <option value="">{tr('Not set')}</option>
          {meta.shifting_types.map((t) => (
            <option key={t.code} value={t.code}>
              {t.label}
            </option>
          ))}
        </select>
      </Field>
      <Field label={tr('Odometer when you start tracking (optional)')} hint={tr('Leave empty if unknown. Rides before this date are inside this value.')}>
        <div className="row">
          <input inputMode="decimal" value={f.starting_km} onChange={(e) => setF({ ...f, starting_km: e.target.value })} placeholder="km" />
          <input type="date" value={f.starting_date} onChange={(e) => setF({ ...f, starting_date: e.target.value })} />
        </div>
      </Field>
      <label className="check">
        <input type="checkbox" checked={f.starting_is_estimate} onChange={(e) => setF({ ...f, starting_is_estimate: e.target.checked })} /> {tr('The odometer value is an estimate')}
      </label>
      <Field label={tr('Strava gear id (optional)')} hint={tr('Only used to match imported rides to this bike.')}>
        <input value={f.strava_gear_id} onChange={(e) => setF({ ...f, strava_gear_id: e.target.value })} placeholder="90000001" />
      </Field>
      <FormError error={error} />
      <div className="form-actions">
        <button className="btn btn-primary" disabled={busy || !f.name.trim()} onClick={save}>
          {busy ? tr('Saving…') : tr('Add bike')}
        </button>
      </div>
    </div>
  )
}

export function BikesPage() {
  const { data, error, loading, reload } = useApi<Bike[]>('/bikes')
  const [adding, setAdding] = useState(false)
  const nav = useNavigate()
  return (
    <Card title={tr('Bikes')} actions={<button className="btn btn-primary" onClick={() => setAdding(true)}>{tr('Add bike')}</button>}>
      {loading && !data && <Loading />}
      {error && <ErrorBox error={error} onRetry={reload} />}
      {data && data.length === 0 && <Empty title={tr('No bikes yet')}>{tr('Add a bike to start logging rides and parts.')}</Empty>}
      {data && data.length > 0 && (
        <div className="cards">
          {data.filter((b) => b.status !== 'RETIRED').map((b) => (
            <Link key={b.id} to={`/bikes/${b.id}`} className="tile">
              <strong>{b.name}</strong>
              <span title={certaintyLabel(b.usage)}>{usageText(b.usage)}</span>
              <span className="muted small">
                {trn('{n} ride', '{n} rides', b.usage.ride_count)} · {certaintyLabel(b.usage)}
              </span>
              <span className="small">
                {tr('Initial {cost}', { cost: b.costs.initial_known ? euro(b.costs.initial_cents) : tr('not entered') })} {tr('· running')} {b.costs.estimated ? '≈' : ''}
                {euro(b.costs.running_cents)}
              </span>
              {b.open_tasks > 0 && <Tag tone="warn">{b.open_tasks} {tr('due')}</Tag>}
            </Link>
          ))}
        </div>
      )}
      {data && data.some((b) => b.status === 'RETIRED') && (
        <details className="task-group" data-group="retired-bikes">
          <summary>
            <strong>{tr('Retired bikes')}</strong>
            <span className="muted small">{data.filter((b) => b.status === 'RETIRED').length}</span>
          </summary>
          <ul className="list">
            {data
              .filter((b) => b.status === 'RETIRED')
              .map((b) => (
                <li key={b.id}>
                  <Link to={`/bikes/${b.id}`}>{b.name}</Link>
                  <span className="muted small">
                    {usageText(b.usage)} · {trn('{n} ride', '{n} rides', b.usage.ride_count)}
                  </span>
                </li>
              ))}
          </ul>
        </details>
      )}
      {adding && (
        <Sheet title={tr('Add bike')} onClose={() => setAdding(false)}>
          <BikeForm onSaved={(b) => nav(`/bikes/${b.id}`)} />
        </Sheet>
      )}
    </Card>
  )
}

interface BikeDetail extends Bike {
  cost_detail: BikeCosts
  setup: SetupRow[]
  history_counts: { rides: number; installations: number; maintenance: number; journal: number; usage: number }
  history: { id: number; component_id: number; label: string; slot: string; installed_at: string; removed_at: string | null; removal_reason: string | null; voided: boolean }[]
  queue: Task[]
  brakes: BrakeRow[]
  rides: RideRow[]
  events: EventRow[]
  groupset: GroupsetSummary | null
  away: ServiceOrder[]
}

// Install a part: one from storage, or a new part created and installed in one step (Dirk 2026-11-01:
// "i dont want to add something to the inventory first").
export function InstallForm({ bikeId, onDone }: { bikeId: number; onDone: (c: Change) => void }) {
  const stored = useApi<ComponentSummary[]>('/components?state=STORED')
  const [source, setSource] = useState<'stored' | 'new' | null>(null)
  if (stored.loading) return <Loading />
  const n = stored.data?.length ?? 0
  const src = source ?? (n ? 'stored' : 'new')
  return (
    <div className="form">
      <div className="chips" role="group" aria-label={tr('Which part?')}>
        <button className={`chip ${src === 'new' ? 'chip-on' : ''}`} onClick={() => setSource('new')}>
          {tr('A new part')}
        </button>
        <button className={`chip ${src === 'stored' ? 'chip-on' : ''}`} onClick={() => setSource('stored')} disabled={!n}>
          {tr('A part from storage (')}{n})
        </button>
      </div>
      {src === 'new' ? (
        <ComponentForm bikeId={bikeId} onSaved={(c) => onDone({ preview: false, deltas: [], notice: tr('{label} added and installed.', { label: c.label }) })} />
      ) : (
        <InstallStored bikeId={bikeId} stored={stored.data ?? []} onDone={onDone} />
      )}
    </div>
  )
}

function InstallStored({ bikeId, stored, onDone }: { bikeId: number; stored: ComponentSummary[]; onDone: (c: Change) => void }) {
  const { meta } = useApp()
  const [f, setF] = useState({ component_id: '', slot: '', at: today(), until: '' })
  const [mount, setMount] = useState<MountTarget | null>(null)
  const [preview, setPreview] = useState<Change | null>(null)
  const [error, setError] = useState<string | null>(null)
  const comp = stored.find((c) => String(c.id) === f.component_id)
  const ctype = meta.component_types.find((t) => t.code === comp?.component_type)
  const body = () => {
    const b: Record<string, unknown> = { at: f.at }
    if (mount?.parent_component_id) b.parent_component_id = mount.parent_component_id
    else b.bike_id = bikeId
    const slot = mount?.slot ?? f.slot
    if (slot) b.slot = slot
    if (f.until) b.until = f.until
    return b
  }
  async function run(dry: boolean) {
    setError(null)
    try {
      const r = await api.post<OpResult<unknown>>(`/components/${f.component_id}/install${dry ? '?dry_run=true' : ''}`, body())
      if (dry) setPreview(r.change)
      else onDone(r.change)
    } catch (e) {
      setError((e as Error).message)
      setPreview(null)
    }
  }
  return (
    <div className="form">
      <Field label={tr('Part from storage')}>
        <select
          value={f.component_id}
          onChange={(e) => {
            setF({ ...f, component_id: e.target.value, slot: '' })
            setMount(null)
          }}
        >
          <option value="">{tr('Pick a part…')}</option>
          {stored.map((c) => (
            <option key={c.id} value={c.id}>
              {c.label} ({c.type_name}, {usageText(c.usage)})
            </option>
          ))}
        </select>
      </Field>
      {ctype && <MountPicker key={ctype.code} componentType={ctype.code} bikeId={bikeId} value={mount} onChange={setMount} />}
      {mount && mount.slot === null && (
        <Field label={tr('Position name')}>
          <input value={f.slot} onChange={(e) => setF({ ...f, slot: e.target.value.toUpperCase().replace(/\s+/g, '_') })} placeholder={tr('e.g. BOTTLE_CAGE_1')} />
        </Field>
      )}
      <div className="row">
        <Field label={tr('Installed on')} hint={tr('Effective date; history before today is fine.')}>
          <input type="date" value={f.at} onChange={(e) => setF({ ...f, at: e.target.value })} />
        </Field>
        <Field label={tr('Removed on (only for past periods)')}>
          <input type="date" value={f.until} onChange={(e) => setF({ ...f, until: e.target.value })} />
        </Field>
      </div>
      <ChangeNotice change={preview} />
      <FormError error={error} />
      <div className="form-actions">
        <button className="btn" disabled={!f.component_id || !mount} onClick={() => run(true)}>
          {tr('Preview mileage impact')}
        </button>
        <button className="btn btn-primary" disabled={!f.component_id || !mount} onClick={() => run(false)}>
          {tr('Install')}
        </button>
      </div>
    </div>
  )
}

function PartActions({ row, onDone }: { row: SetupRow; onDone: (c: Change) => void }) {
  const { meta } = useApp()
  const ctype = meta.component_types.find((t) => t.code === row.component_type)
  const canMove = !!ctype && (ctype.parent_types.length > 0 || ctype.slots.length > 1)
  const [mode, setMode] = useState<'replace' | 'remove' | 'move'>('replace')
  return (
    <div className="form">
      <div className="chips">
        <button className={`chip ${mode === 'replace' ? 'chip-on' : ''}`} onClick={() => setMode('replace')}>
          {tr('Replace')}
        </button>
        <button className={`chip ${mode === 'remove' ? 'chip-on' : ''}`} onClick={() => setMode('remove')}>
          {tr('Remove')}
        </button>
        {canMove && (
          <button className={`chip ${mode === 'move' ? 'chip-on' : ''}`} onClick={() => setMode('move')}>
            {tr('Move position')}
          </button>
        )}
      </div>
      {mode === 'replace' && <ReplaceForm componentId={row.component_id} onDone={(c) => onDone(c)} />}
      {mode === 'remove' && <RemoveForm componentId={row.component_id} suggested={ctype?.removed_default ?? 'STORED'} onDone={onDone} />}
      {mode === 'move' && <MoveForm componentId={row.component_id} onDone={onDone} />}
      <p className="muted small">{tr('This is a real change of parts. If the record itself is wrong, open the part and correct its installation instead.')}</p>
    </div>
  )
}

export function BikeDetailPage() {
  const { id } = useParams()
  const { toast } = useApp()
  const [params, setParams] = useSearchParams()
  const tab = params.get('tab') ?? 'overview'
  const { data, error, loading, reload } = useApi<BikeDetail>(`/bikes/${id}`)
  useCrumb(`/bikes/${id}`, data?.name)
  const incidents = useApi<RideIncident[]>(`/bikes/${id}/incidents`)
  const openIncidents = incidents.data?.filter((r) => r.open && !r.removed).length ?? 0
  const [sheet, setSheet] = useState<null | { kind: 'install' } | { kind: 'groupset'; replace?: boolean } | { kind: 'wheelset' } | { kind: 'costs' } | { kind: 'frameCost' } | { kind: 'part'; row: SetupRow } | { kind: 'swap'; title: string; rows: SetupRow[]; remove?: boolean } | { kind: 'spokes'; row: SetupRow } | { kind: 'brokenSpokes'; row: SetupRow } | { kind: 'log' } | { kind: 'retire' } | { kind: 'installType'; type: string; prefer?: number }>(params.get('add') === 'groupset' ? { kind: 'groupset', replace: true } : null)
  if (loading && !data) return <Loading />
  if (error && !data) return <ErrorBox error={error} onRetry={reload} />
  if (!data) return null
  const done = (c: Change) => {
    setSheet(null)
    toast(c.notice)
    reload()
  }
  return (
    <div className="grid">
      <Card
        title={data.name}
        className="span-2"
        actions={
          <>
            {data.status === 'RETIRED' ? (
              <button
                className="btn btn-primary"
                onClick={async () => {
                  await api.post(`/bikes/${data.id}/restore`, {})
                  toast(tr('{name} is active again.', { name: data.name }))
                  reload()
                }}
              >
                {tr('Restore bike')}
              </button>
            ) : (
              <button className="btn btn-primary" title={tr('Cleaning, lubing, waxing, charging, checks, bleeds, repairs: anything you did to the bike or a part')} onClick={() => setSheet({ kind: 'log' })}>
                {tr('Record work done')}
              </button>
            )}
            {data.status !== 'RETIRED' && (
              <button className="btn" onClick={() => setSheet({ kind: 'retire' })}>
                {tr('Retire or delete')}
              </button>
            )}
          </>
        }
      >
        <div className="stats">
          <div>
            <span className="stat">{usageText(data.usage)}</span>
            <span className="muted small">{certaintyLabel(data.usage)}</span>
          </div>
          <div>
            <span className="stat">{data.usage.ride_count}</span>
            <span className="muted small">
              {data.usage.ride_count === 1 ? tr('ride') : tr('rides')}
              {(data.usage.rides_before_start ?? 0) > 0 &&
                tr(' (+{rides_before_start} before tracking, inside the starting km)', { rides_before_start: data.usage.rides_before_start })}
            </span>
          </div>
          <div>
            <span className="stat">{data.usage.hours.toFixed(0)} h</span>
            <span className="muted small">{tr('ride time')}</span>
          </div>
        </div>
        {data.usage.starting_km !== null && (
          <p className="small muted">
            {tr('Odometer')} {data.usage.starting_is_estimate ? '≈' : ''}
            {km(data.usage.starting_km, 0)} {tr('as of')} {when(data.usage.starting_effective)}
            {data.usage.starting_is_estimate ? tr(' (estimate)') : ''}{tr(', plus')} {km(data.usage.ride_km)} {tr('from rides since.')}
          </p>
        )}
        {data.status === 'RETIRED' && <p className="small"><Tag>{tr('retired')}</Tag> {tr('Hidden from the bike list; its rides, km and history are kept. Restore brings it back.')}</p>}
        <ShiftingSelect bike={data} onSaved={reload} />
      </Card>
      <div className="tabs span-2" role="tablist" aria-label={tr('Bike sections')}>
        {BIKE_TABS.map(([k, l]) => (
          <button key={k} role="tab" aria-selected={tab === k} className={`tab ${tab === k ? 'tab-on' : ''}`} onClick={() => setParams(k === 'overview' ? {} : { tab: k })}>
            {l}
            {k === 'incidents' && openIncidents > 0 && <span className="count">{openIncidents}</span>}
          </button>
        ))}
      </div>
      {tab === 'overview' && (
        <>
          <AwayCard orders={data.away} onChanged={reload} />
          <ServiceStatus tasks={data.queue} reload={reload} />
          <Card
            title={tr('Installed now')}
            className="span-2"
            actions={
              // first setup of a bike: all parts of a groupset in one go; later changes are under Manage parts
              !data.groupset && (
                <button className="btn btn-small" title={tr('Set up the bike: all parts of a groupset template in one go')} onClick={() => setSheet({ kind: 'groupset' })}>
                  {tr('Add groupset')}
                </button>
              )
            }
          >
            {data.setup.length === 0 ? (
              <Empty title={tr('Nothing installed yet')}>{tr('Tell the app what is on the bike: Add groupset puts a whole group on in one go; Manage parts → Install a part adds single parts.')}</Empty>
            ) : (
              <SetupGroups setup={data.setup} groupset={data.groupset} bikeId={data.id} onChange={(row) => setSheet({ kind: 'part', row })} reload={reload} onAddSpokes={(row) => setSheet({ kind: 'spokes', row })} onBrokenSpoke={(row) => setSheet({ kind: 'brokenSpokes', row })} onInstallTire={(row) => setSheet({ kind: 'installType', type: 'TIRE', prefer: row.component_id })} onInstallTube={(row) => setSheet({ kind: 'installType', type: 'INNER_TUBE', prefer: row.component_id })} />
            )}
          </Card>
          <ManageParts
            setup={data.setup}
            onSwap={(title, rows) => setSheet({ kind: 'swap', title, rows })}
            onInstall={() => setSheet({ kind: 'install' })}
            onRemove={(rows) => setSheet({ kind: 'swap', title: tr('Remove a part'), rows, remove: true })}
            onReplaceGroupset={() => setSheet({ kind: 'groupset', replace: true })}
            onWheelset={() => setSheet({ kind: 'wheelset' })}
            onInstallTire={() => setSheet({ kind: 'installType', type: 'TIRE' })}
            onInstallTube={() => setSheet({ kind: 'installType', type: 'INNER_TUBE' })}
          />
          <ChainRotation bikeId={data.id} refresh={data} onChanged={reload} />
        </>
      )}
      {tab === 'rides' && <BikeRides bikeId={data.id} onChanged={reload} />}
      {tab === 'incidents' && (
        <Card title={tr('Incidents')} className="span-2">
          <BikeIncidents incidents={incidents.data} error={incidents.error} loading={incidents.loading} reload={incidents.reload} bikeName={data.name} />
        </Card>
      )}
      {tab === 'maintenance' && (
        <>
          <Card title={tr('Recent maintenance')}>
            <EventLog events={data.events} onChanged={reload} show="part" />
          </Card>
          <Card title={tr('Brake circuits')}>
            {data.brakes.length === 0 ? (
              <Empty title={tr('No brake circuits installed')} />
            ) : (
              <ul className="list">
                {data.brakes.map((b) => (
                  <li key={b.component_id}>
                    <strong>{b.position}</strong>
                    <Link to={`/inventory/${b.component_id}`}>{b.label}</Link>
                    {b.fluid && <StatusBadge status={b.fluid.status} />}
                    <span className="small muted">{b.last_bleed ? tr('Last bleed {date}: {x} → {x2}', { date: when(b.last_bleed.date), x: b.last_bleed.symptom ?? '', x2: b.last_bleed.outcome ?? '?' }) : tr('No bleed recorded')}</span>
                  </li>
                ))}
              </ul>
            )}
          </Card>
        </>
      )}
      {tab === 'timeline' && <Timeline bikeId={data.id} />}
      {tab === 'costs' && (
        <>
          <CostCard bike={data} onEdit={() => setSheet({ kind: 'costs' })} onFrame={() => setSheet({ kind: 'frameCost' })} />
          <Bundles bikeId={data.id} refresh={data} onChanged={(msg) => { toast(msg); reload() }} className="span-2" />
        </>
      )}
      {tab === 'history' && (
        <>
          <Journal bikeId={data.id} className="span-2" />
          <ChangeLog bikeId={data.id} refresh={data} className="span-2" />
          <Card title={tr('Installation history')} className="span-2">
            <table className="table">
              <thead>
                <tr>
                  <th>{tr('Part')}</th>
                  <th>{tr('Slot')}</th>
                  <th>{tr('From')}</th>
                  <th>{tr('Until')}</th>
                  <th>{tr('Reason')}</th>
                </tr>
              </thead>
              <tbody>
                {data.history.map((h) => (
                  <tr key={h.id} className={h.voided ? 'excluded' : ''}>
                    <td>
                      <Link to={`/inventory/${h.component_id}`}>{h.label}</Link>
                    </td>
                    <td>{slotName(h.slot)}</td>
                    <td>{when(h.installed_at)}</td>
                    <td>{h.removed_at ? when(h.removed_at) : tr('now')}</td>
                    <td>{h.voided ? tr('corrected (void)') : h.removal_reason}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </Card>
        </>
      )}
      {sheet?.kind === 'installType' && (
        <Sheet title={tr('Install {x} · {name}', { x: sheet.type === 'TIRE' ? tr('a tire') : sheet.type === 'INNER_TUBE' ? tr('an inner tube') : tr('a part'), name: data.name })} onClose={() => setSheet(null)}>
          <InstallHere
            componentType={sheet.type}
            bikeId={data.id}
            prefer={sheet.prefer}
            onCancel={() => setSheet(null)}
            onChange={(id) => {
              const row = data.setup.find((r) => r.component_id === id)
              setSheet(row ? { kind: 'part', row } : null)
            }}
            onDone={(msg) => {
              setSheet(null)
              toast(msg)
              reload()
            }}
          />
        </Sheet>
      )}
      {sheet?.kind === 'install' && (
        <Sheet title={tr('Install a part')} onClose={() => setSheet(null)}>
          <InstallForm bikeId={data.id} onDone={done} />
        </Sheet>
      )}
      {sheet?.kind === 'frameCost' && data.cost_detail.frame && (
        <Sheet title={tr('Frame purchase · {name}', { name: data.name })} onClose={() => setSheet(null)}>
          <FramePurchaseForm
            frame={data.cost_detail.frame}
            bikePriced={data.purchase_price_cents !== null}
            onDone={() => {
              setSheet(null)
              toast(tr('Saved.'))
              reload()
            }}
          />
        </Sheet>
      )}
      {sheet?.kind === 'costs' && (
        <Sheet title={tr('Purchase price · {name}', { name: data.name })} onClose={() => setSheet(null)}>
          <PurchaseForm
            bike={data}
            onDone={() => {
              setSheet(null)
              toast(tr('Saved.'))
              reload()
            }}
          />
        </Sheet>
      )}
      {sheet?.kind === 'groupset' && (
        <Sheet title={`${sheet.replace ? tr('Replace whole groupset') : tr('Add a groupset')} · ${data.name}`} onClose={() => setSheet(null)}>
          <GroupsetImport
            bikeId={data.id}
            initialOccupied={sheet.replace ? 'REPLACE' : 'KEEP'}
            onDone={(msg) => {
              setSheet(null)
              toast(msg)
              reload()
            }}
          />
        </Sheet>
      )}
      {sheet?.kind === 'wheelset' && (
        <Sheet title={tr('Group wheels into a wheelset · {name}', { name: data.name })} onClose={() => setSheet(null)}>
          <WheelsetForm bikeId={data.id} onDone={done} />
        </Sheet>
      )}
      {sheet?.kind === 'part' && (
        <Sheet title={tr('Change {label}', { label: sheet.row.label })} onClose={() => setSheet(null)}>
          <PartActions row={sheet.row} onDone={done} />
        </Sheet>
      )}
      {sheet?.kind === 'swap' && (
        <Sheet title={`${sheet.title} · ${data.name}`} onClose={() => setSheet(null)}>
          {sheet.title === 'Swap tube' ? (
            <SwapTube
              bikeId={data.id}
              onDone={(text) => {
                setSheet(null)
                toast(text)
                reload()
              }}
            />
          ) : (
            <SwapPart rows={sheet.rows} setup={data.setup} remove={sheet.remove} onDone={done} />
          )}
        </Sheet>
      )}
      {sheet?.kind === 'spokes' && (
        <Sheet title={tr('Spokes · {label}', { label: sheet.row.label })} onClose={() => setSheet(null)}>
          <SpokesForm
            wheel={sheet.row}
            onDone={() => {
              setSheet(null)
              toast(tr('Spokes added.'))
              reload()
            }}
          />
        </Sheet>
      )}
      {sheet?.kind === 'brokenSpokes' && (
        <Sheet title={tr('Broken spokes · {label}', { label: sheet.row.label })} onClose={() => setSheet(null)}>
          <BrokenSpokes wheelId={sheet.row.component_id} info={data.setup.find((r) => r.component_id === sheet.row.component_id)?.spokes ?? sheet.row.spokes!} onChange={reload} />
        </Sheet>
      )}
      {sheet?.kind === 'retire' && (
        <Sheet title={tr('Retire or delete · {name}', { name: data.name })} onClose={() => setSheet(null)}>
          <RetireBike bike={data} onRetired={() => (setSheet(null), toast(tr('{name} retired. Bikes → Retired bikes shows it; Restore brings it back.', { name: data.name })), reload())} />
        </Sheet>
      )}
      {sheet?.kind === 'log' && (
        <Sheet title={tr('Record work done · {name}', { name: data.name })} onClose={() => setSheet(null)}>
          <LogMaintenance
            bikeId={data.id}
            onDone={(msg) => {
              setSheet(null)
              toast(msg)
              reload()
            }}
          />
        </Sheet>
      )}
    </div>
  )
}

const isWheel = (r: SetupRow) => r.component_type === 'FRONT_WHEEL' || r.component_type === 'REAR_WHEEL'

// The spokes on a wheel as one part (a set): type, count and lengths (drive / non-drive side on the rear).
function SpokesForm({ wheel, onDone }: { wheel: SetupRow; onDone: () => void }) {
  const rear = wheel.component_type === 'REAR_WHEEL'
  const [f, setF] = useState({ label: tr('Spokes {label}', { label: wheel.label }), model: '', count: '', length: '', drive: '', nondrive: '', nipples: '', at: wheel.spokes?.laced_default ?? wheel.since })
  const [err, setErr] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [opId] = useState(newOpId)
  const num = (v: string) => (v.trim() ? Number(v.replace(',', '.')) : undefined)
  async function save() {
    setErr(null)
    setBusy(true)
    try {
      const specs = Object.fromEntries(
        Object.entries({ model: f.model.trim() || undefined, count: num(f.count), length_mm: num(f.length), length_drive_mm: num(f.drive), length_non_drive_mm: num(f.nondrive), nipples: f.nipples.trim() || undefined }).filter(([, v]) => v !== undefined),
      )
      if (Object.values(specs).some((v) => typeof v === 'number' && Number.isNaN(v))) throw new Error(tr('Count and lengths are numbers, e.g. 24 or 288'))
      await api.post('/components', { component_type: 'SPOKES', label: f.label, prior_usage: 'UNKNOWN', specs, install: { parent_component_id: wheel.component_id, slot: 'SPOKES', at: f.at } }, opId)
      onDone()
    } catch (e) {
      setErr((e as Error).message)
    } finally {
      setBusy(false)
    }
  }
  return (
    <div className="form">
      <div className="row">
        <Field label={tr('Name')}>
          <input value={f.label} onChange={(e) => setF({ ...f, label: e.target.value })} />
        </Field>
        <Field label={tr('Spoke model')}>
          <input value={f.model} onChange={(e) => setF({ ...f, model: e.target.value })} placeholder={tr('e.g. Sapim CX-Ray, DT Aerolite')} />
        </Field>
      </div>
      <div className="row">
        <Field label={tr('Number of spokes')}>
          <input inputMode="numeric" value={f.count} onChange={(e) => setF({ ...f, count: e.target.value })} placeholder="e.g. 24" />
        </Field>
        {rear ? (
          <>
            <Field label={tr('Length drive side (mm)')}>
              <input inputMode="decimal" value={f.drive} onChange={(e) => setF({ ...f, drive: e.target.value })} />
            </Field>
            <Field label={tr('Length non-drive side (mm)')}>
              <input inputMode="decimal" value={f.nondrive} onChange={(e) => setF({ ...f, nondrive: e.target.value })} />
            </Field>
          </>
        ) : (
          <Field label={tr('Length (mm)')}>
            <input inputMode="decimal" value={f.length} onChange={(e) => setF({ ...f, length: e.target.value })} />
          </Field>
        )}
      </div>
      <Field label={tr('Nipples (optional)')}>
        <input value={f.nipples} onChange={(e) => setF({ ...f, nipples: e.target.value })} placeholder={tr('e.g. alloy, 14 mm')} />
      </Field>
      <details className="small">
        <summary>
          {tr('In the wheel since')} {f.at ? when(f.at) : '—'} {wheel.spokes?.laced_default && f.at === wheel.spokes.laced_default ? tr('(the day the wheel was bought)') : ''}{tr('. Wheel re-built later?')}
        </summary>
        <Field label={tr('On the wheel since')} hint={tr('Only if the wheel was re-laced after you bought it. Broken spokes count from here.')}>
          <input type="date" value={f.at} onChange={(e) => setF({ ...f, at: e.target.value })} />
        </Field>
      </details>
      <p className="small muted">{tr('Leave what you don\'t know empty. Spare spokes for repairs go under Inventory → Add spare stock (type Spokes), so a broken spoke can take one from there.')}</p>
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" disabled={busy || !f.label.trim()} onClick={save}>
          {tr('Add spokes')}
        </button>
      </div>
    </div>
  )
}

// A bike created by mistake (nothing recorded on it) is deleted for good; any other bike is retired:
// hidden from the list, rides and km kept, restorable. Its parts can come off into storage.
function RetireBike({ bike, onRetired }: { bike: BikeDetail; onRetired: () => void }) {
  const nav = useNavigate()
  const { toast } = useApp()
  const c = bike.history_counts
  const empty = Object.values(c).every((n) => n === 0)
  const [partsOff, setPartsOff] = useState(bike.setup.length > 0)
  const [at, setAt] = useState(today())
  const [err, setErr] = useState<string | null>(null)
  const [opId] = useState(newOpId)
  async function retire() {
    setErr(null)
    try {
      await api.post(`/bikes/${bike.id}/retire`, partsOff ? { parts_off_at: at } : {}, opId)
      onRetired()
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  async function del() {
    if (!window.confirm(tr('Delete {name} for good? This cannot be undone.', { name: bike.name }))) return
    try {
      await api.del(`/bikes/${bike.id}`)
      toast(`${bike.name} deleted.`)
      nav('/bikes')
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form">
      {empty ? (
        <>
          <p>{tr('Nothing is recorded on {name} yet (no rides, parts, maintenance or notes), so it can be deleted for good.', { name: bike.name })}{bike.strava_gear_id ? tr(' Strava sync will not create it again; its rides come in without a bike.') : ''}</p>
          <div className="form-actions">
            <button className="btn btn-danger" onClick={del}>
              {tr('Delete bike')}
            </button>
          </div>
          <p className="small muted">{tr('Or retire it below if you want to keep it.')}</p>
        </>
      ) : (
        <p className="small muted">
          {tr('{name} has {rides} and {installations} on record. Retire it to hide it with its rides, km and history kept (you can restore it any time), or delete it for good below.', { name: bike.name, rides: trn('{n} ride', '{n} rides', c.rides), installations: trn('{n} part installation', '{n} part installations', c.installations) })}
        </p>
      )}
      {bike.setup.length > 0 && (
        <label className="check">
          <input type="checkbox" checked={partsOff} onChange={(e) => setPartsOff(e.target.checked)} /> {tr('Take its parts off and store them (they keep their km; the frame stays with the bike)')}
        </label>
      )}
      {partsOff && bike.setup.length > 0 && (
        <Field label={tr('Parts off on')}>
          <input type="date" value={at} onChange={(e) => setAt(e.target.value)} />
        </Field>
      )}
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" onClick={retire}>
          {tr('Retire bike')}
        </button>
      </div>
      {!empty && <PurgeBike bike={bike} />}
    </div>
  )
}

interface PurgePreview {
  name: string
  rides: number
  rides_km: number
  imported_rides: number
  parts: { id: number; label: string; km_on_bike: number }[]
  maintenance: number
  notes: number
}

// Delete a bike WITH its history (Dirk 2026-11-02, DECISIONS 128): what goes is listed, the name must be typed,
// a backup is kept first (Settings → Backups → Restore undoes it). The bike and its rides are shown nowhere
// any more (the history stays in the file, append-only). Parts are never deleted.
function PurgeBike({ bike }: { bike: BikeDetail }) {
  const nav = useNavigate()
  const { toast } = useApp()
  const [open, setOpen] = useState(false)
  const pv = useApi<PurgePreview>(open ? `/bikes/${bike.id}/purge-preview` : null)
  const [name, setName] = useState('')
  const [retireParts, setRetireParts] = useState(false)
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<string | null>(null)
  async function go() {
    setErr(null)
    setBusy(true)
    try {
      const r = await api.post<{ name: string; backup: string | null }>(`/bikes/${bike.id}/purge`, { confirm_name: name, retire_parts: retireParts })
      toast(tr('{name} deleted for good.{x}', { name: r.name, x: r.backup ? tr(' A backup was kept first (Settings → Backups).') : '' }))
      nav('/bikes')
    } catch (e) {
      setErr((e as Error).message)
      setBusy(false)
    }
  }
  const d = pv.data
  return (
    <details className="purge-bike" onToggle={(e) => setOpen((e.target as HTMLDetailsElement).open)}>
      <summary className="small">{tr('Delete {name} for good…', { name: bike.name })}</summary>
      {pv.loading && !d && <Loading />}
      {d && (
        <div className="form">
          <p className="small">{d.name} {tr('disappears from Bike Log for good: from the bike list, the overview, every picker and report.')}</p>
          <ul className="small">
            <li>
              {trn('Its {n} ride ({km}) no longer counts and is not listed; rides from Strava or a CSV file are not imported again.', 'Its {n} rides ({km}) no longer count and are not listed; rides from Strava or a CSV file are not imported again.', d.rides, { km: km(d.rides_km, 0) })}
            </li>
            <li>
              {tr('Its {maintenance} and {notes} go with it (entries on a part stay with the part).', { maintenance: trn('{n} maintenance entry', '{n} maintenance entries', d.maintenance), notes: trn('{n} note / incident', '{n} notes / incidents', d.notes) })}
            </li>
            <li>
              {trn('Its {n} part is not deleted: it comes off into storage and keeps the km it rode on {name}.', 'Its {n} parts are not deleted: they come off into storage and keep the km they rode on {name}.', d.parts.length, { name: d.name })}
            </li>
          </ul>
          {d.parts.length > 0 && (
            <label className="check">
              <input type="checkbox" checked={retireParts} onChange={(e) => setRetireParts(e.target.checked)} /> {tr('Also retire its parts (they leave the Inventory lists; Part life still shows them)')}
            </label>
          )}
          <Field label={tr('Type "{name}" to confirm', { name: d.name })} hint={tr('A backup is made first. Settings → Backups → Restore brings everything back.')}>
            <input aria-label={tr('Bike name to confirm')} value={name} onChange={(e) => setName(e.target.value)} />
          </Field>
          <FormError error={err} />
          <div className="form-actions">
            <button className="btn btn-danger" disabled={busy || name.trim().toLowerCase() !== d.name.trim().toLowerCase()} onClick={go}>
              {tr('Delete for good')}
            </button>
          </div>
        </div>
      )}
    </details>
  )
}

// Everyday part changes in one place. A swap opens the normal Replace dialog for the part of that type
// on this bike (after a pick when there are several), so spares, stock and carried-over parts work as usual.
// wheels on this bike without a tire on them
const bareOf = (setup: SetupRow[], type = 'TIRE') => setup.filter((w) => isWheel(w) && !setup.some((r) => r.component_type === type && r.parent_component_id === w.component_id))
// wheels without a recorded inner tube (Dirk rides tubes; tubeless wheels need none)
const tubelessOf = (setup: SetupRow[]) => bareOf(setup, 'INNER_TUBE').filter((w) => w.tire_setup !== 'TUBELESS' && w.tire_setup !== 'TUBULAR')

function ManageParts({ setup, onSwap, onRemove, onInstall, onWheelset, onReplaceGroupset, onInstallTire, onInstallTube }: { setup: SetupRow[]; onSwap: (title: string, rows: SetupRow[]) => void; onRemove: (rows: SetupRow[]) => void; onInstall: () => void; onWheelset: () => void; onReplaceGroupset: () => void; onInstallTire: () => void; onInstallTube: () => void }) {
  const { meta } = useApp()
  // same grouping as Installed now: drivetrain, brakes, controls and the Di2 / AXS battery
  const groupsetParts = setup.filter((r) => r.component_type === 'BATTERY' || CATEGORY_GROUP[meta.component_types.find((t) => t.code === r.component_type)?.category ?? ''] === 'GROUPSET')
  const of = (t: string) => setup.filter((r) => r.component_type === t)
  const wheelsets = of('WHEELSET')
  const looseWheels = setup.filter((r) => r.depth === 0 && isWheel(r))
  const bareWheels = bareOf(setup)
  const noTube = tubelessOf(setup)
  const swaps: [string, string, SetupRow[], string][] = [
    [tr('Swap chain'), tr('Swap chain'), of('CHAIN'), tr('No chain installed')],
    wheelsets.length > 0
      ? [tr('Swap wheelset'), tr('Swap wheelset'), wheelsets, '']
      : [tr('Swap wheels'), tr('Swap a wheel'), setup.filter(isWheel), tr('No wheels installed')],
    [tr('Swap tire'), tr('Swap a tire'), of('TIRE'), tr('No tires installed')],
    [tr('Swap tube'), tr('Swap tube'), [], ''],
    [tr('Swap another part'), tr('Swap a part'), setup, tr('Nothing installed yet')],
  ]
  return (
    <Card title={tr('Manage parts')} className="span-2">
      <div className="manage-parts">
        <div>
          <h3 className="small muted">{tr('Change parts')}</h3>
          <div className="chips">
            {swaps.map(([label, title, rows, none]) =>
              label === 'Swap tire' && rows.length === 0 && bareWheels.length > 0 ? (
                <button key={label} className="btn" onClick={onInstallTire}>
                  {tr('Install a tire')}
                </button>
              ) : (
                <button key={label} className="btn" disabled={rows.length === 0 && label !== 'Swap tube'} title={rows.length === 0 ? none || undefined : undefined} onClick={() => onSwap(title, rows)}>
                  {label}
                </button>
              ),
            )}
          </div>
        </div>
        <div>
          <h3 className="small muted">{tr('Groupset')}</h3>
          <div className="chips">
            <button className="btn" disabled={groupsetParts.length === 0} title={groupsetParts.length === 0 ? tr('No groupset parts on this bike') : tr('Change one part, e.g. an Ultegra crankset for a Dura-Ace one')} onClick={() => onSwap(tr('Change a groupset part'), groupsetParts)}>
              {tr('Change a groupset part')}
            </button>
            <button className="btn" disabled={groupsetParts.length === 0} title={tr('Put a different groupset on: the old parts come off and keep their km')} onClick={onReplaceGroupset}>
              {tr('Replace whole groupset')}
            </button>
          </div>
        </div>
        <div>
          <h3 className="small muted">{tr('Add parts')}</h3>
          <div className="chips">
            <button className="btn" onClick={onInstall}>
              {tr('Install a part')}
            </button>
            {bareWheels.length > 0 && (
              <button className="btn" onClick={onInstallTire} title={tr('No tire on {join}', { join: bareWheels.map((w) => w.label).join(' and ') })}>
                {tr('Install a tire')}
              </button>
            )}
            {noTube.length > 0 && (
              <button className="btn" onClick={onInstallTube} title={tr('No inner tube recorded on {join}. Once it is in, its km count.', { join: noTube.map((w) => w.label).join(' and ') })}>
                {tr('Install an inner tube')}
              </button>
            )}
            {looseWheels.length > 0 && (
              <button className="btn" onClick={onWheelset}>
                {tr('Group wheels into a wheelset')}
              </button>
            )}
          </div>
        </div>
        <div>
          <h3 className="small muted">{tr('Remove parts')}</h3>
          <div className="chips">
            <button className="btn" disabled={setup.length === 0} title={setup.length === 0 ? tr('Nothing installed yet') : tr('Take a part off without putting another one on')} onClick={() => onRemove(setup)}>
              {tr('Remove a part')}
            </button>
          </div>
        </div>
      </div>
      <p className="small muted">
        {tr('A swap takes a stored spare, one from stock or a new item, and the old part keeps its km for next time.')}
        {wheelsets.length === 0 && looseWheels.length > 0 && tr(' Wheels swap one at a time; group them into a wheelset to swap both in one go.')} {tr('To change one particular part, you can also click it under Installed now.')}
      </p>
    </Card>
  )
}

function SwapPart({ rows, setup, remove, onDone }: { rows: SetupRow[]; setup: SetupRow[]; remove?: boolean; onDone: (c: Change) => void }) {
  const { meta } = useApp()
  const [picked, setPicked] = useState<number | null>(rows.length === 1 ? rows[0].component_id : null)
  const where = (r: SetupRow) => {
    const parent = setup.find((p) => p.component_id === r.parent_component_id)
    return parent ? tr('on {label}', { label: parent.label }) : slotName(r.slot)
  }
  return (
    <div className="form">
      {rows.length > 1 && (
        <fieldset className="field">
          <legend className="field-label">{tr('Which one?')}</legend>
          <div className="pick-list">
            {rows.map((r) => (
              <label key={r.component_id} className={`pick ${picked === r.component_id ? 'pick-on' : ''}`}>
                <input type="radio" name="swap-pick" checked={picked === r.component_id} onChange={() => setPicked(r.component_id)} />
                <span>
                  <strong>{r.label}</strong> <span className="small muted">· {r.type_name} · {where(r)}</span>
                </span>
              </label>
            ))}
          </div>
        </fieldset>
      )}
      {picked !== null &&
        (remove ? (
          <RemoveForm key={picked} componentId={picked} suggested={meta.component_types.find((t) => t.code === rows.find((r) => r.component_id === picked)?.component_type)?.removed_default ?? 'STORED'} onDone={(c) => onDone(c)} />
        ) : (
          <ReplaceForm key={picked} componentId={picked} onDone={(c) => onDone(c)} />
        ))}
    </div>
  )
}

// The bike's rides, newest first; a click opens the ride (same view as Rides → ride).
function BikeRides({ bikeId, onChanged }: { bikeId: number; onChanged: () => void }) {
  const { toast } = useApp()
  const { data, error, loading, reload } = useApi<RideRow[]>(`/rides?limit=1000&view=active&bike_id=${bikeId}`)
  const [open, setOpen] = useState<number | null>(null)
  if (loading && !data) return <Loading />
  if (error) return <ErrorBox error={error} onRetry={reload} />
  const rides = data ?? []
  const totalKm = rides.reduce((a, r) => a + (r.distance_km ?? 0), 0)
  const totalS = rides.reduce((a, r) => a + (r.duration_s ?? 0), 0)
  return (
    <Card title={tr('Rides')} className="span-2">
      {rides.length === 0 ? (
        <Empty title={tr('No rides on this bike yet')}>{tr('Add a ride, import a CSV or sync Strava under Rides.')}</Empty>
      ) : (
        <>
          <p className="small muted">
            {trn('{n} ride', '{n} rides', rides.length)} · {km(totalKm, 0)} · {duration(totalS)} {tr('recorded ride time')}
            {rides.length >= 1000 ? tr(' (latest 1000 shown)') : ''}
          </p>
          <table className="table rides bike-rides">
            <thead>
              <tr>
                <th>{tr('Date')}</th>
                <th>{tr('Name')}</th>
                <th className="num">{tr('Distance')}</th>
                <th className="num">{tr('Time')}</th>
                <th>{tr('Notes')}</th>
              </tr>
            </thead>
            <tbody>
              {rides.map((r) => (
                <tr key={r.id} onClick={() => setOpen(r.id)}>
                  <td>{when(r.start_time_utc ?? r.ride_date)}</td>
                  <td>
                    <button className="linklike">{r.name || tr('Ride')}</button>
                  </td>
                  <td className="num">{km(r.distance_km)}</td>
                  <td className="num">{duration(r.duration_s)}</td>
                  <td>
                    {r.sport_type === 'VirtualRide' && <Tag>{tr('indoor')}</Tag>}
                    {r.conditions === 'WET' && <Tag tone="info">{tr('wet')}</Tag>}
                    {r.incidents > 0 && <Tag tone="bad">{trn('{n} incident', '{n} incidents', r.incidents)}</Tag>}
                    {r.flags.length > 0 && <Tag tone="warn">{codeText(r.flags[0].code)}</Tag>}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}
      {open !== null && (
        <Sheet title={tr('Ride')} onClose={() => setOpen(null)}>
          <RideDetailView
            id={open}
            onChanged={(c) => {
              if (c?.notice) toast(c.notice)
              reload()
              onChanged()
            }}
          />
        </Sheet>
      )}
    </Card>
  )
}

// Service status: what needs doing first; reminders that need a first entry and those that are fine fold away.

function ServiceStatus({ tasks, reload }: { tasks: Task[]; reload: () => void }) {
  return (
    <Card title={tr('Service status')} className="span-2">
      {tasks.length === 0 ? <Empty title={tr('No rules apply to the installed parts yet.')} /> : <GroupedTasks tasks={tasks} onChange={reload} />}
    </Card>
  )
}

// "Installed now" in groups (groupset, wheels, cockpit ...): one line each, unfolded with the triangle.
// A part mounted on another part (tire on a wheel) stays with the part it is mounted on.
const SETUP_GROUPS: [string, string][] = [
  ['GROUPSET', tr('Groupset')],
  ['WHEELS', tr('Wheels and tires')],
  ['COCKPIT', tr('Cockpit')],
  ['CONTACT', tr('Contact points')],
  ['FRAME', tr('Frame')],
  ['ELECTRONICS', tr('Electronics')],
  ['OTHER', tr('Other')],
]
// inside the groupset: one branch per area (catalog categories)
const GROUPSET_SUBS: [string, string][] = [
  [tr('Drivetrain'), tr('Drivetrain')],
  [tr('Controls'), tr('Shifting and controls')],
  [tr('Brakes'), tr('Brakes')],
  ['OTHER', tr('Other')],
]
const CATEGORY_GROUP: Record<string, string> = {
  Drivetrain: 'GROUPSET',
  Brakes: 'GROUPSET',
  Controls: 'GROUPSET',
  Wheels: 'WHEELS',
  Cockpit: 'COCKPIT',
  'Contact points': 'CONTACT',
  Frame: 'FRAME',
  Electronics: 'ELECTRONICS',
}

// One line under each wheel: its spokes (type, count, lengths) and the broken spokes since it was laced.
function SpokeLine({ row, onAdd, onBroken }: { row: SetupRow; onAdd: () => void; onBroken: () => void }) {
  const sp = row.spokes
  if (!sp) return null
  const s = sp.specs
  const lengths = row.component_type === 'REAR_WHEEL' && (s.length_drive_mm || s.length_non_drive_mm)
    ? tr('{x} mm drive side / {x2} mm non-drive', { x: s.length_drive_mm ?? '?', x2: s.length_non_drive_mm ?? '?' })
    : s.length_mm
      ? `${s.length_mm} mm`
      : null
  const what = [s.count ? `${s.count} ×` : null, s.model ?? sp.product ?? sp.label, lengths].filter(Boolean).join(' ')
  return (
    <span className="spoke-line small">
      {tr('Spokes:')}{' '}
      {sp.component_id ? (
        <>
          <Link to={`/inventory/${sp.component_id}`}>{what}</Link>
          {sp.from_product.length > 0 && <span className="muted"> {tr('(from product data, check)')}</span>}
        </>
      ) : (
        <>
          <span className="muted">{tr('not recorded')}</span>{' '}
          <button className="btn btn-small" onClick={onAdd}>
            {tr('Add spokes')}
          </button>
        </>
      )}{' '}
      <SpokeCount sp={sp} />{' '}
      <button className="btn btn-small" onClick={onBroken}>
        {tr('Broken spoke…')}
      </button>
    </span>
  )
}

function SetupGroups({ setup, groupset, bikeId, onChange, reload, onAddSpokes, onBrokenSpoke, onInstallTire, onInstallTube }: { setup: SetupRow[]; groupset: GroupsetSummary | null; bikeId: number; onChange: (row: SetupRow) => void; reload: () => void; onAddSpokes: (row: SetupRow) => void; onBrokenSpoke: (row: SetupRow) => void; onInstallTire: (wheel: SetupRow) => void; onInstallTube: (wheel: SetupRow) => void }) {
  const bare = new Set(bareOf(setup).map((w) => w.component_id))
  const noTube = new Set(tubelessOf(setup).map((w) => w.component_id))
  const { meta } = useApp()
  const groupOf = (type: string) => {
    if (type === 'BATTERY') return 'GROUPSET' // Di2 / AXS battery belongs to the shifting
    const cat = meta.component_types.find((t) => t.code === type)?.category ?? ''
    return CATEGORY_GROUP[cat] ?? 'OTHER'
  }
  const groups: Record<string, SetupRow[]> = {}
  let current = 'OTHER'
  for (const s of setup) {
    if (s.depth === 0) current = groupOf(s.component_type)
    ;(groups[current] ??= []).push(s)
  }
  // groupset parts by area (a part mounted on another stays with it, e.g. chainrings under the crankset)
  const subs: Record<string, SetupRow[]> = {}
  let sub = 'OTHER'
  for (const s of groups.GROUPSET ?? []) {
    if (s.depth === 0) sub = s.component_type === 'BATTERY' ? tr('Controls') : (meta.component_types.find((t) => t.code === s.component_type)?.category ?? 'OTHER')
    ;(subs[sub] ??= []).push(s)
  }
  const row = (s: SetupRow) => (
    <li key={s.installation_id} style={{ paddingLeft: `${s.depth * 1.2}rem` }}>
      <span className="muted small">{slotName(s.slot)}</span>
      <Link to={`/inventory/${s.component_id}`}>{s.label}</Link>
      <span className="muted small">{tr('since')} {when(s.since)}</span>
      {(s.component_type === 'FRONT_WHEEL' || s.component_type === 'REAR_WHEEL') && <TireSetupSelect wheelId={s.component_id} value={s.tire_setup} onSaved={reload} />}
      {s.component_type === 'TIRE' && <PressureNote tireId={s.component_id} value={s.pressure_note} onSaved={reload} />}
      <button className="btn btn-small" onClick={() => onChange(s)}>
        {tr('Change')}
      </button>
      {bare.has(s.component_id) && (
        <button className="btn btn-small" onClick={() => onInstallTire(s)}>
          {tr('Install a tire')}
        </button>
      )}
      {noTube.has(s.component_id) && (
        <button className="btn btn-small" onClick={() => onInstallTube(s)}>
          {tr('Install a tube')}
        </button>
      )}
      {s.spokes && <SpokeLine row={s} onAdd={() => onAddSpokes(s)} onBroken={() => onBrokenSpoke(s)} />}
    </li>
  )
  return (
    <div className="setup-groups">
      {SETUP_GROUPS.filter(([k]) => groups[k]?.length).map(([k, label]) => {
        const rows = groups[k]
        const top = rows.filter((r) => r.depth === 0).map((r) => r.label)
        return (
          <details key={k} className="setup-group" data-group={k}>
            {k === 'GROUPSET' && groupset ? (
              // same shape as the other groups (Dirk 2026-11-01): "Groupset 17 parts · Shimano Ultegra Di2 …", no link here
              <summary>
                <strong>{label}</strong>
                <span className="muted small">
                  {trn('{n} part', '{n} parts', groupset.parts)}
                  {groupset.name !== tr('Groupset') ? ` · ${groupset.name}` : ''}
                </span>
              </summary>
            ) : (
              <summary>
                <strong>{label}</strong>
                <span className="muted small">
                  {trn('{n} part', '{n} parts', rows.length)} · {top.slice(0, 3).join(', ')}
                  {top.length > 3 ? ', …' : ''}
                </span>
              </summary>
            )}
            {k === 'GROUPSET' ? (
              // the groupset as a tree, like a wheelset: drivetrain, brakes, shifting, each with its parts
              <div className="setup-tree">
                {GROUPSET_SUBS.filter(([sk]) => subs[sk]?.length).map(([sk, sl]) => (
                  <details key={sk} className="setup-sub" data-sub={sk}>
                    <summary>
                      <strong>{sl}</strong>{' '}
                      <span className="muted small">
                        {trn('{n} part', '{n} parts', subs[sk].length)} ·{' '}
                        {subs[sk]
                          .filter((r) => r.depth === 0)
                          .slice(0, 3)
                          .map((r) => r.label)
                          .join(', ')}
                        {subs[sk].filter((r) => r.depth === 0).length > 3 ? ', …' : ''}
                      </span>
                    </summary>
                    <ul className="list setup">{subs[sk].map(row)}</ul>
                  </details>
                ))}
                {groupset && (
                  <p className="small">
                    <Link to={`/bikes/${bikeId}/groupset`}>{tr('Groupset page')}</Link> <span className="muted">{tr('(km, tasks and history of the whole groupset)')}</span>
                  </p>
                )}
              </div>
            ) : (
              <ul className="list setup">{rows.map(row)}</ul>
            )}
          </details>
        )
      })}
    </div>
  )
}

const COST_KIND: Record<string, string> = { PART: 'part', BUNDLE: 'bundle', STOCK: tr('from stock'), SERVICE: 'service' }

// Electronic or mechanical shifting: decides whether Di2 checks or cable checks apply to this bike.
function ShiftingSelect({ bike, onSaved }: { bike: BikeDetail; onSaved: () => void }) {
  const { meta, toast } = useApp()
  const label = (code: string | null) => lc(meta.shifting_types.find((t) => t.code === code)?.label)
  async function save(v: string) {
    try {
      await api.patch(`/bikes/${bike.id}`, { shifting: v || null })
      toast(v ? tr('Shifting set to {label}.', { label: label(v) }) : tr('Shifting not set.'))
      onSaved()
    } catch (e) {
      toast((e as Error).message)
    }
  }
  return (
    <label className="inline-field small">
      {tr('Shifting')}{' '}
      <select aria-label={tr('Shifting')} value={bike.shifting ?? ''} onChange={(e) => save(e.target.value)}>
        <option value="">{bike.shifting_effective ? tr('Not set ({label}: battery fitted)', { label: label(bike.shifting_effective) }) : tr('Not set')}</option>
        {meta.shifting_types.map((t) => (
          <option key={t.code} value={t.code}>
            {t.label}
          </option>
        ))}
      </select>
    </label>
  )
}

function CostCard({ bike, onEdit, onFrame }: { bike: BikeDetail; onEdit: () => void; onFrame: () => void }) {
  const c = bike.cost_detail
  const fr = c.frame
  const perKm = bike.usage.total_km > 0 && c.total_cents ? Math.round(c.total_cents / bike.usage.total_km) : null
  const [open, setOpen] = useState(false)
  return (
    <Card
      title={tr('Costs')}
      className="span-2"
      actions={
        <>
          <button className="btn btn-small" onClick={onEdit}>
            {tr('Bike purchase price')}
          </button>
          {fr && (
            <button className="btn btn-small" onClick={onFrame}>
              {tr('Frame price')}
            </button>
          )}
        </>
      }
    >
      <div className="stats">
        <div>
          <span className="stat">{c.initial_known ? euro(c.initial_cents) : '—'}</span>
          <span className="muted small">
            {tr('initial cost')}{c.initial_source === 'FRAME' ? tr(' (the frame)') : ''}
            {c.purchase_date ? ` · ${when(c.purchase_date)}` : c.initial_known ? '' : tr(' · not entered')}
            {c.initial_source === 'FRAME' ? (fr?.shop ? ` · ${fr.shop}` : '') : bike.shop ? ` · ${bike.shop}` : ''}
          </span>
        </div>
        <div>
          <span className="stat">
            {c.estimated ? '≈' : ''}
            {euro(c.running_cents) || euro(0)}
          </span>
          <span className="muted small">
            {tr('running cost:')} {c.bundles_cents > 0 ? tr('bundles {bundles_cents} · ', { bundles_cents: euro(c.bundles_cents) }) : ''}{tr('parts')} {euro(c.parts_cents) || euro(0)} {tr('· from stock')} {euro(c.stock_cents) || euro(0)} {tr('· services')} {euro(c.services_cents) || euro(0)}
          </span>
        </div>
        <div>
          <span className="stat">{euro(c.total_cents) || euro(0)}</span>
          <span className="muted small">{tr('total')}{perKm !== null ? tr(' · {x}{perKm} per km', { x: bike.usage.certainty === 'INCOMPLETE' ? tr('at most ') : '', perKm: euro(perKm) }) : ''}</span>
        </div>
      </div>
      {fr && (
        <p className="small frame-cost">
          {tr('Frame:')} <Link to={`/inventory/${fr.component_id}`}>{fr.label}</Link>
          {fr.price_cents !== null ? ` · ${euro(fr.price_cents)}` : ''}
          {fr.purchase_date ? tr(' · bought {purchase_date}', { purchase_date: when(fr.purchase_date) }) : ''}
          {fr.shop ? ` · ${fr.shop}` : ''}
          <span className="muted">
            {' '}
            ·{' '}
            {
              {
                INITIAL: tr('counts as the initial cost (no bike purchase price entered)'),
                INCLUDED: tr('included in the bike purchase price, not counted again'),
                PART: tr('a later frame: counts as running cost'),
                NO_PRICE: c.initial_known ? tr('came with the bike') : tr('no price yet: enter it with Frame price (or the bike purchase price if you bought it complete)'),
                OTHER_BIKE: tr('counted on the bike it came from'),
              }[fr.counted]
            }
          </span>
        </p>
      )}
      {(c.unpriced_parts > 0 || c.estimated || c.unpriced_bundles > 0) && (
        <p className="small muted">
          {c.unpriced_bundles > 0 && tr('{unpriced_bundles} bundle{x} no price yet. ', { unpriced_bundles: c.unpriced_bundles, x: c.unpriced_bundles === 1 ? ' has' : tr('s have') })}
          {c.unpriced_parts > 0 &&
            tr('{unpriced_parts} installed part{x} no price{x2}; fine for parts that came with the bike. ', { unpriced_parts: c.unpriced_parts, x: c.unpriced_parts === 1 ? ' has' : tr('s have'), x2: c.unpriced_labels?.length ? ` (${c.unpriced_labels.slice(0, 5).join(', ')}${c.unpriced_labels.length > 5 ? ', …' : ''})` : '' })}
          {c.estimated && tr('≈: parts taken from stock are valued at the average price paid for that stock.')}
        </p>
      )}
      {(c.items?.length ?? 0) > 0 && (
        <>
          <button className="btn btn-small" onClick={() => setOpen(!open)}>
            {open ? tr('Hide') : tr('Show')} {c.items?.length} {tr('cost entries')}
          </button>
          {open && (
            <ul className="list">
              {c.items?.map((i, n) => (
                <li key={n}>
                  <span className="muted small">{when(i.date)}</span>
                  <span>{i.groupset ? <Link to={`/bikes/${bike.id}/groupset`}>{i.text}</Link> : i.component_id ? <Link to={`/inventory/${i.component_id}`}>{i.text}</Link> : i.text}</span>
                  <Tag>{COST_KIND[i.kind]}</Tag>
                  <span>
                    {i.estimated ? '≈' : ''}
                    {euro(i.cents)}
                  </span>
                </li>
              ))}
            </ul>
          )}
        </>
      )}
    </Card>
  )
}

function FramePurchaseForm({ frame, bikePriced, onDone }: { frame: NonNullable<BikeCosts['frame']>; bikePriced: boolean; onDone: () => void }) {
  const [f, setF] = useState({ price: centsInput(frame.price_cents), date: frame.purchase_date ?? '', shop: frame.shop ?? '' })
  const [err, setErr] = useState<string | null>(null)
  async function save() {
    setErr(null)
    const price = toCents(f.price)
    if (Number.isNaN(price)) return setErr(tr('Price: enter an amount such as 1999,00'))
    try {
      await api.patch(`/components/${frame.component_id}`, { price_cents: price, purchase_date: f.date || null, shop: f.shop.trim() || null })
      onDone()
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form frame-purchase">
      <p className="small">
        <Link to={`/inventory/${frame.component_id}`}>{frame.label}</Link>
      </p>
      <div className="row">
        <Field label={tr('Frame price')} hint={tr('What you paid for the frame (and fork).')}>
          <input aria-label={tr('Frame price')} inputMode="decimal" value={f.price} onChange={(e) => setF({ ...f, price: e.target.value })} placeholder="€" autoFocus />
        </Field>
        <Field label={tr('Bought on')}>
          <input aria-label={tr('Frame bought on')} type="date" value={f.date} onChange={(e) => setF({ ...f, date: e.target.value })} />
        </Field>
      </div>
      <div className="row">
        <ShopPicker value={f.shop} onChange={(v) => setF({ ...f, shop: v })} label={tr('Bought from')} />
      </div>
      <p className="small muted">
        {bikePriced
          ? tr('This bike has a bike purchase price, so the frame is shown as included in it and not counted twice.')
          : tr('Built up from a frame: the frame price is the initial cost. If you bought the bike complete, enter the bike purchase price instead.')}{' '}
        {tr('Serial number, size and the rest are on the frame\'s page (Edit details, Properties).')}
      </p>
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" onClick={save}>
          {tr('Save')}
        </button>
      </div>
    </div>
  )
}

function PurchaseForm({ bike, onDone }: { bike: Bike; onDone: () => void }) {
  const [f, setF] = useState({ price: centsInput(bike.purchase_price_cents), date: bike.purchase_date ?? '', shop: bike.shop ?? '' })
  const [err, setErr] = useState<string | null>(null)
  async function save() {
    setErr(null)
    const price = toCents(f.price)
    if (Number.isNaN(price)) return setErr(tr('Price: enter an amount such as 3499,00'))
    try {
      await api.patch(`/bikes/${bike.id}`, { purchase_price_cents: price, purchase_date: f.date || null, shop: f.shop.trim() || null })
      onDone()
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form">
      <div className="row">
        <Field label={tr('Purchase price')} hint={tr('What you paid for the bike, including the parts it came with.')}>
          <input inputMode="decimal" value={f.price} onChange={(e) => setF({ ...f, price: e.target.value })} placeholder="€" autoFocus />
        </Field>
        <Field label={tr('Bought on')}>
          <input type="date" value={f.date} onChange={(e) => setF({ ...f, date: e.target.value })} />
        </Field>
      </div>
      <div className="row">
        <ShopPicker value={f.shop} onChange={(v) => setF({ ...f, shop: v })} label={tr('Bought from')} />
      </div>
      <p className="small muted">{tr('Running cost is added up from part prices, stock used on this bike and service costs; it is never typed in.')}</p>
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" onClick={save}>
          {tr('Save')}
        </button>
      </div>
    </div>
  )
}

function WheelsetForm({ bikeId, onDone }: { bikeId: number; onDone: (c: Change) => void }) {
  const [f, setF] = useState({ label: '', at: today() })
  const [preview, setPreview] = useState<Change | null>(null)
  const [err, setErr] = useState<string | null>(null)
  const [opId] = useState(newOpId)
  async function run(dry: boolean) {
    setErr(null)
    try {
      const r = await api.post<OpResult<unknown>>(`/bikes/${bikeId}/group-wheels${dry ? '?dry_run=true' : ''}`, { at: f.at, label: f.label || null }, dry ? undefined : opId)
      if (dry) setPreview(r.change)
      else onDone(r.change)
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <div className="form">
      <p className="small muted">
        {tr('The front and rear wheel go into one wheelset with everything on them (tires, tubes, rotors, cassette, sensors). Each part keeps its own km. From then on you can move the whole wheelset to another bike in one step. The wheelset itself counts km from this date; add its km from before on its page if you know them.')}
      </p>
      <div className="row">
        <Field label={tr('Wheelset name')}>
          <input value={f.label} onChange={(e) => setF({ ...f, label: e.target.value })} placeholder={tr('e.g. Reynolds AR58')} />
        </Field>
        <Field label={tr('From')}>
          <input type="date" value={f.at} onChange={(e) => setF({ ...f, at: e.target.value })} />
        </Field>
      </div>
      <ChangeNotice change={preview} />
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn" onClick={() => run(true)}>
          {tr('Preview')}
        </button>
        <button className="btn btn-primary" onClick={() => run(false)}>
          {tr('Group wheels')}
        </button>
      </div>
    </div>
  )
}
