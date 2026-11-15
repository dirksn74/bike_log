// Chains that take turns on a bike (Chain A, Chain B ...): which one is on, which are waxed and ready, which
// wait for wax; a one-click swap to the next ready chain, "Wax chains" for all dirty ones at once, and the
// rotation history. The 500 km hot-wax rule of the chain on the bike drives the prompt (services/chains.py).
import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { api, newOpId } from '../api'
import { useApp } from '../context'
import { km, today, when } from '../format'
import { useApi } from '../hooks'
import type { ChainRotationData, ChainRow } from '../types'
import { Card, ErrorBox, Field, FormError, Loading, Sheet, Tag } from './ui'
import { tr, codeText, trn } from '../i18n'

const STATE: Record<string, [string, 'good' | 'warn' | 'bad' | 'info' | 'neutral']> = {
  INSTALLED: [tr('on the bike'), 'info'],
  READY_TO_INSTALL: [tr('waxed, ready'), 'good'],
  NEEDS_HOT_WAX: [tr('dirty, waiting for wax'), 'warn'],
  NEW_UNWAXED: [tr('new, wax before use'), 'warn'],
  UNKNOWN: [tr('no hot wax recorded'), 'neutral'],
  WORN: [tr('worn, do not use'), 'bad'],
  AWAITING_SERVICE: [tr('awaiting repair'), 'warn'],
  RETIRED: ['retired', 'neutral'],
}

export function ChainName({ c }: { c: Pick<ChainRow, 'component_id' | 'label' | 'mark'> }) {
  return (
    <>
      <Link to={`/inventory/${c.component_id}`}>{c.label}</Link>
    </>
  )
}

// A swap or wax happens after that day's rides: now for today, the end of the day for an earlier date
// (a date alone means the start of the day, which would move that day's rides to the new chain).
const afterRides = (date: string) => (date === today() ? new Date().toISOString() : `${date}T23:59`)

async function swapChain(bikeId: number, to: number) {
  return api.post<{ result: { text: string } }>(`/bikes/${bikeId}/chains/swap`, { to_component_id: to, at: afterRides(today()) }, newOpId())
}

export default function ChainRotation({ bikeId, refresh, onChanged }: { bikeId: number; refresh: unknown; onChanged: () => void }) {
  const { toast } = useApp()
  const { data, error, loading, reload } = useApi<ChainRotationData>(`/bikes/${bikeId}/chains`)
  const [waxing, setWaxing] = useState(false)
  const [err, setErr] = useState<string | null>(null)
  useEffect(() => {
    reload()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [refresh])
  if (loading && !data) return <Loading />
  if (error) return <ErrorBox error={error} onRetry={reload} />
  if (!data || data.chains.length === 0) return null
  const done = (text: string) => {
    toast(text)
    reload()
    onChanged()
  }
  async function swap(to: number) {
    setErr(null)
    try {
      done((await swapChain(bikeId, to)).result.text)
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  async function add(key: string) {
    if (!key) return
    setErr(null)
    const [kind, id] = key.split(':')
    try {
      const r = await api.post<{ result: { text: string } }>(
        `/bikes/${bikeId}/chains/add`,
        { [kind === 's' ? 'consumable_id' : 'component_id']: Number(id), at: today() },
        newOpId(),
      )
      done(r.result.text)
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  const addPicker = (
    <>
      <label className="inline-field small">
        {data.chains.length < 2 ? tr('Add a chain to rotate with: ') : tr('Add a chain: ')}
        <select aria-label={tr('Add a chain to the rotation')} value="" onChange={(e) => add(e.target.value)}>
          <option value="">{data.candidates.length ? tr('pick a chain') : tr('no chain off a bike (Inventory → Add part)')}</option>
          {data.candidates.map((c) => (
            <option key={c.component_id ? `c${c.component_id}` : `s${c.consumable_id}`} value={c.component_id ? `c:${c.component_id}` : `s:${c.consumable_id}`}>
              {c.label}
              {c.note ? ` · ${c.note}` : ''}
            </option>
          ))}
        </select>
      </label>
      {data.elsewhere.length > 0 && (
        <details className="small muted">
          <summary>{tr('Other chains (')}{data.elsewhere.length})</summary>
          <ul>
            {data.elsewhere.map((c) => (
              <li key={c.component_id}>
                <Link to={`/inventory/${c.component_id}`}>{c.label}</Link>: {c.text}
              </li>
            ))}
          </ul>
        </details>
      )}
    </>
  )
  if (data.chains.length < 2)
    return (
      <Card title={tr('Chain rotation')} className="span-2">
        <p className="small muted">
          {tr('Only {label} rotates on this bike. With two or more chains, this card shows which one is on, which are waxed and ready, and when to swap.', { label: data.chains[0].label })}
        </p>
        {addPicker}
        <FormError error={err} />
      </Card>
    )
  const p = data.prompt
  return (
    <Card title={tr('Chain rotation')} className="span-2" actions={<button className="btn btn-small" onClick={() => setWaxing(true)}>{tr('Wax chains')}</button>}>
      {p && (
        <div className={`rotation-prompt ${p.kind === 'WAX' ? 'warn' : ''}`}>
          <span>{p.text}</span>
          {p.to ? (
            <button className="btn btn-primary btn-small" onClick={() => swap(p.to!)}>
              {p.kind === 'INSTALL' ? tr('Put {to_label} on', { to_label: p.to_label }) : tr('Swap to {to_label}', { to_label: p.to_label })}
            </button>
          ) : (
            <button className="btn btn-primary btn-small" onClick={() => setWaxing(true)}>
              {tr('Wax chains')}
            </button>
          )}
        </div>
      )}
      <FormError error={err} />
      <ul className="list rotation">
        {data.chains.map((c) => {
          const [word, tone] = STATE[c.state] ?? [c.state.toLowerCase(), 'neutral']
          const ws = c.wax_status
          return (
            <li key={c.component_id} data-chain={c.label}>
              <strong>
                <ChainName c={c} />
              </strong>
              <Tag tone={tone}>{word}</Tag>
              <span className="small">
                {c.km_since_hot_wax !== null ? tr('{km_since_hot_wax} since hot wax', { km_since_hot_wax: km(c.km_since_hot_wax, 0) }) : tr('no hot wax yet')}
                {ws && ws.status !== 'OK' && <span className="muted"> ({codeText(ws.status)})</span>}
              </span>
              <span className="muted small">
                {km(c.lifetime_km, 0)} {tr('lifetime ·')} {trn('{n} wax cycle', '{n} wax cycles', c.wax_cycles)}
                {c.last_wear ? tr(' · wear {x}{x2} on {date}', { x: c.last_wear.value ?? '?', x2: c.last_wear.unit ?? '', date: when(c.last_wear.date) }) : tr(' · wear not measured')}
              </span>
              {c.state === 'READY_TO_INSTALL' && c.component_id !== data.on && (
                <button className="btn btn-small" onClick={() => swap(c.component_id)}>
                  {tr('Put on')}
                </button>
              )}
            </li>
          )
        })}
      </ul>
      <details className="task-group" data-group="rotation-history">
        <summary>
          <strong>{tr('Rotation history')}</strong>
          <span className="muted small">{data.timeline.filter((t) => t.kind === 'ON').length} {tr('turns on the bike')}</span>
        </summary>
        <ul className="list">
          {data.timeline.map((t, i) => (
            <li key={i}>
              <span>{when(t.date)}</span>
              {t.kind === 'ON' ? (
                <span>
                  <Link to={`/inventory/${t.component_id}`}>{t.label}</Link> {tr('on')}{t.until ? ` until ${when(t.until)}` : tr(', still on')} · {km(t.km ?? 0, 0)}
                </span>
              ) : (
                <span>
                  <Link to={`/inventory/${t.component_id}`}>{t.label}</Link> {t.kind === 'TOP_UP' ? tr('liquid wax top-up') : tr('hot waxed')}
                </span>
              )}
            </li>
          ))}
        </ul>
      </details>
      {data.candidates.length > 0 && <p>{addPicker}</p>}
      <p className="small muted">{tr('A chain joins this rotation when it first goes on this bike, or here. Give each chain a mark under Edit details (A, B …): it is shown after the name, e.g. "Chain [A]".')}</p>
      {waxing && (
        <Sheet title={tr('Wax chains')} onClose={() => setWaxing(false)}>
          <WaxForm data={data} onDone={(t) => (setWaxing(false), done(t))} />
        </Sheet>
      )}
    </Card>
  )
}

function WaxForm({ data, onDone }: { data: ChainRotationData; onDone: (text: string) => void }) {
  const supplies = useApi<{ id: number; name: string; kind: string; unit: string }[]>('/consumables')
  const [ids, setIds] = useState<number[]>(data.dirty)
  const otherTicked = (list: number[]) => list.find((i) => i !== data.on) ?? null
  // until picked by hand, follow the ticks: when the chain on the bike is waxed, another ticked one goes on
  const [picked, setPicked] = useState<number | null | undefined>(undefined)
  const then = picked !== undefined ? picked : data.on !== null && ids.includes(data.on) ? otherTicked(ids) : null
  const [at, setAt] = useState(today())
  const [supply, setSupply] = useState('')
  const [err, setErr] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [opId] = useState(newOpId)
  const toggle = (id: number) => setIds(ids.includes(id) ? ids.filter((x) => x !== id) : [...ids, id])
  async function save() {
    setErr(null)
    setBusy(true)
    try {
      const r = await api.post<{ result: { text: string } }>(`/bikes/${data.bike_id}/chains/wax`, { component_ids: ids, at: afterRides(at), then_install: then, consumable_id: supply ? Number(supply) : null }, opId)
      onDone(r.result.text)
    } catch (e) {
      setErr((e as Error).message)
    } finally {
      setBusy(false)
    }
  }
  const onChain = data.chains.find((c) => c.component_id === data.on)
  return (
    <div className="form">
      <fieldset className="field">
        <legend className="field-label">{tr('Chains you hot waxed')}</legend>
        {data.chains
          .filter((c) => !['RETIRED', 'WORN'].includes(c.state))
          .map((c) => (
            <label key={c.component_id} className="check">
              <input type="checkbox" checked={ids.includes(c.component_id)} onChange={() => toggle(c.component_id)} /> {c.label} <span className="muted small">· {STATE[c.state]?.[0] ?? c.state}</span>
            </label>
          ))}
      </fieldset>
      <Field label={tr('Waxed on')}>
        <input type="date" value={at} onChange={(e) => setAt(e.target.value)} />
      </Field>
      <Field label={tr('Then put on the bike')}>
        <select value={then ?? ''} onChange={(e) => setPicked(e.target.value ? Number(e.target.value) : null)}>
          <option value="">{onChain ? tr('Keep {label} on', { label: onChain.label }) : tr('Nothing for now')}</option>
          {data.chains
            .filter((c) => c.component_id !== data.on && (ids.includes(c.component_id) || c.state === 'READY_TO_INSTALL'))
            .map((c) => (
              <option key={c.component_id} value={c.component_id}>
                {c.label}
              </option>
            ))}
        </select>
      </Field>
      {onChain && then !== null && <p className="small muted">{onChain.label} {tr('comes off first (stored, keeps its km) and is waxed with the others if ticked.')}</p>}
      <Field
        label={tr('Wax used (optional)')}
        hint={
          <>
            {tr('Your wax is kept under')} <Link to="/inventory?tab=supplies">{tr('Inventory → Supplies')}</Link> {tr('(add one there with Add supply).')}
          </>
        }
      >
        <select aria-label={tr('Wax used')} value={supply} onChange={(e) => setSupply(e.target.value)}>
          <option value="">{tr('Not recorded')}</option>
          {supplies.data?.filter((c) => ['WAX', 'LUBE', 'OTHER'].includes(c.kind)).map((c) => (
            <option key={c.id} value={c.id}>
              {c.name}
            </option>
          ))}
        </select>
      </Field>
      <FormError error={err} />
      <div className="form-actions">
        <button className="btn btn-primary" disabled={busy || ids.length === 0} onClick={save}>
          {busy ? tr('Saving…') : trn('Hot wax {n} chain', 'Hot wax {n} chains', ids.length)}
        </button>
      </div>
    </div>
  )
}
