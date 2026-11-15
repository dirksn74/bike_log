import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { euro, when } from '../format'
import { useApi } from '../hooks'
import { Card, Empty, ErrorBox, Loading, Tag } from './ui'
import { tr, locale, lc } from '../i18n'

// Timeline of a bike or of one part (services/timeline.py, DECISIONS 142): everything done to it, newest
// first, with the km at that moment. The km come from the backend (never added up here) and carry a status:
// ≈ estimated, ≥ a minimum, "km unknown" before tracking started. Filters fold away; Export CSV downloads
// exactly what is shown (oldest first).

type KmStatus = 'KNOWN' | 'ESTIMATED' | 'MINIMUM' | 'MISSING' | null

export interface TimelineRow {
  ref: string
  uuid: string | null
  kind: string
  type: string
  title: string
  detail: string | null
  date: string
  time: string | null
  date_only: boolean
  bike_id: number | null
  bike: string | null
  component_id: number | null
  component: string | null
  component_type_name: string | null
  other_component_id: number | null
  other_component: string | null
  cost_cents: number | null
  voided: boolean
  void_reason: string | null
  ride_id: number | null
  group: string | null
  bike_km: number | null
  bike_km_status: KmStatus
  part_km: number | null
  part_km_status: KmStatus
  same_day_km: number | null
}

interface TimelineData {
  subject: 'BIKE' | 'COMPONENT'
  name: string
  kinds: { code: string; label: string; count: number }[]
  voided_count: number
  total: number
  rows: TimelineRow[]
  first_date: string | null
  last_date: string | null
}

function kmText(v: number | null, status: KmStatus): string {
  if (v === null || status === 'MISSING') return tr('km unknown')
  const prefix = status === 'ESTIMATED' ? '≈' : status === 'MINIMUM' ? '≥' : ''
  return `${prefix}${v.toLocaleString(locale, { maximumFractionDigits: 0 })} km`
}

const STATUS_HINT: Record<string, string> = {
  KNOWN: tr('known'),
  ESTIMATED: tr('estimated (estimated starting value, counted back, or rides with an uncertain part)'),
  MINIMUM: tr('a minimum (use before tracking unknown, or rides without a distance)'),
  MISSING: tr('not known: before tracking started'),
}

function dayText(r: TimelineRow): string {
  return r.time ? `${when(r.date)}, ${r.time}` : when(r.date)
}

// three or more part changes of one work session on one day (a groupset going on) fold into one line
type Block = { kind: 'row'; row: TimelineRow } | { kind: 'group'; rows: TimelineRow[] }
function blocks(rows: TimelineRow[]): Block[] {
  const out: Block[] = []
  let i = 0
  while (i < rows.length) {
    const r = rows[i]
    let j = i + 1
    if (r.group && r.kind === 'PARTS') while (j < rows.length && rows[j].group === r.group && rows[j].date === r.date && rows[j].kind === 'PARTS') j++
    if (j - i >= 3) out.push({ kind: 'group', rows: rows.slice(i, j) })
    else for (let k = i; k < j; k++) out.push({ kind: 'row', row: rows[k] })
    i = j
  }
  return out
}

export default function Timeline({ bikeId, componentId, className = 'span-2' }: { bikeId?: number; componentId?: number; className?: string }) {
  const [from, setFrom] = useState('')
  const [to, setTo] = useState('')
  const [kinds, setKinds] = useState<string[]>([])
  const [voided, setVoided] = useState(false)
  const [style, setStyle] = useState<'excel' | 'standard'>('excel')
  const base = bikeId !== undefined ? `/bikes/${bikeId}/timeline` : `/components/${componentId}/timeline`
  const query = useMemo(() => {
    const p = new URLSearchParams()
    if (from) p.set('from', from)
    if (to) p.set('to', to)
    if (kinds.length) p.set('kinds', kinds.join(','))
    if (voided) p.set('voided', 'true')
    return p
  }, [from, to, kinds, voided])
  const data = useApi<TimelineData>(`${base}?${query.toString()}`)
  const csvQuery = new URLSearchParams(query)
  csvQuery.set('style', style)
  const csvHref = `./api${base}.csv?${csvQuery.toString()}`
  const onBike = bikeId !== undefined
  const filtered = !!(from || to || kinds.length || voided)
  const toggle = (k: string) => setKinds((ks) => (ks.includes(k) ? ks.filter((x) => x !== k) : [...ks, k]))
  const d = data.data

  const filterSummary = [
    kinds.length ? d?.kinds.filter((k) => kinds.includes(k.code)).map((k) => lc(k.label)).join(', ') : tr('all entries'),
    from || to ? `${from ? when(from) : tr('start')} → ${to ? when(to) : tr('today')}` : null,
    voided ? tr('with deleted entries') : null,
  ]
    .filter(Boolean)
    .join(' · ')

  return (
    <Card
      title={tr('Timeline')}
      className={`${className} timeline-card`}
      actions={
        <a className="btn btn-small" href={csvHref} download data-testid="timeline-csv">
          {tr('Export CSV')}
        </a>
      }
    >
      <p className="small muted">
        {onBike
          ? tr('Everything done on this bike, newest first, with the bike’s km at that moment (and the part’s own km).')
          : tr('Everything that happened to this part, newest first, with its own km at that moment (all bikes together).')}{' '}
        {tr('≈ estimated, ≥ at least.')}
      </p>
      <details className="timeline-filters">
        <summary className="small">
          {tr('Filter:')} <strong>{filterSummary}</strong>
        </summary>
        <div className="chips mt" role="group" aria-label={tr('Entry types')}>
          {(d?.kinds ?? []).map((k) => (
            <button key={k.code} type="button" className={`chip ${kinds.includes(k.code) ? 'chip-on' : ''}`} aria-pressed={kinds.includes(k.code)} onClick={() => toggle(k.code)}>
              {k.label} <span className="muted">{k.count}</span>
            </button>
          ))}
        </div>
        <div className="filters mt">
          <label className="inline-field">
            {tr('From')} <input type="date" value={from} onChange={(e) => setFrom(e.target.value)} aria-label={tr('From date')} />
          </label>
          <label className="inline-field">
            {tr('To')} <input type="date" value={to} onChange={(e) => setTo(e.target.value)} aria-label={tr('To date')} />
          </label>
          <label className="chip-check small">
            <input type="checkbox" checked={voided} onChange={(e) => setVoided(e.target.checked)} />
            {tr('Show deleted and corrected entries')}{d ? ` (${d.voided_count})` : ''}
          </label>
          <label className="inline-field small">
            {tr('CSV for')}{' '}
            <select value={style} onChange={(e) => setStyle(e.target.value as 'excel' | 'standard')} aria-label={tr('CSV format')}>
              <option value="excel">{tr('Excel (semicolon, decimal comma)')}</option>
              <option value="standard">{tr('Other tools (comma, decimal point)')}</option>
            </select>
          </label>
          {filtered && (
            <button type="button" className="btn btn-small" onClick={() => { setFrom(''); setTo(''); setKinds([]); setVoided(false) }}>
              {tr('Clear filter')}
            </button>
          )}
        </div>
      </details>
      {data.error && <ErrorBox error={data.error} onRetry={data.reload} />}
      {!d && data.loading && <Loading what={tr('Loading the timeline')} />}
      {d && d.rows.length === 0 && <Empty title={d.total ? tr('Nothing matches the filter') : tr('Nothing recorded yet')} />}
      {d && d.rows.length > 0 && (
        <ul className="list timeline" data-testid="timeline">
          {blocks(d.rows).map((b) =>
            b.kind === 'row' ? (
              <TimelineItem key={b.row.ref} r={b.row} onBike={onBike} />
            ) : (
              <li key={b.rows[0].ref} className="timeline-group">
                <details>
                  <summary>
                    <span className="tl-date">{dayText(b.rows[0])}</span> <strong>{b.rows.length} {tr('part changes')}</strong>{' '}
                    <span className="small muted">{tr('{on} on, {off} off', { on: b.rows.filter((r) => r.type !== 'REMOVED').length, off: b.rows.filter((r) => r.type !== 'INSTALLED').length })}</span>
                  </summary>
                  <ul className="list">
                    {b.rows.map((r) => (
                      <TimelineItem key={r.ref} r={r} onBike={onBike} />
                    ))}
                  </ul>
                </details>
              </li>
            ),
          )}
        </ul>
      )}
      {d && d.rows.length > 0 && <p className="footnote">{d.rows.length === d.total ? `${d.total} entries` : tr('{length} of {total} entries', { length: d.rows.length, total: d.total })}{tr('. The CSV has the same entries, oldest first, with stable record ids.')}</p>}
    </Card>
  )
}

function TimelineItem({ r, onBike }: { r: TimelineRow; onBike: boolean }) {
  // the main km: the bike's odometer on a bike page, the part's own km on a part page
  const mainKm = onBike ? [r.bike_km, r.bike_km_status] as const : [r.part_km, r.part_km_status] as const
  const otherKm = onBike ? (r.component_id ? ['part', r.part_km, r.part_km_status] as const : null) : r.bike ? [r.bike, r.bike_km, r.bike_km_status] as const : null
  return (
    <li className={`tl-row tl-${r.kind.toLowerCase()} ${r.voided ? 'excluded' : ''}`} data-ref={r.ref}>
      <span className="tl-date">{dayText(r)}</span>
      <span className="tl-what">
        <strong>{r.component_id && onBike && r.component && r.title.endsWith(r.component) ? (
          <>
            {r.title.slice(0, r.title.length - r.component.length)}
            <Link to={`/inventory/${r.component_id}`}>{r.component}</Link>
          </>
        ) : (
          r.title
        )}</strong>
        {onBike && r.component_id && !r.title.includes(r.component ?? '\u0000') && (
          <>
            {' · '}
            <Link to={`/inventory/${r.component_id}`}>{r.component}</Link>
          </>
        )}
        {!onBike && r.bike && r.bike_id && (
          <span className="small muted"> {tr('· on')} <Link to={`/bikes/${r.bike_id}`}>{r.bike}</Link></span>
        )}
        {r.detail && <span className="small muted tl-detail">{r.detail}</span>}
        {r.voided && <Tag tone="bad">{r.void_reason ?? 'deleted'}</Tag>}
      </span>
      <span className="tl-km" title={mainKm[1] ? `km ${STATUS_HINT[mainKm[1]]}` : undefined}>
        {mainKm[1] ? kmText(mainKm[0], mainKm[1]) : ''}
        {otherKm && otherKm[2] && (
          <span className="small muted">
            {otherKm[0]} {kmText(otherKm[1], otherKm[2])}
          </span>
        )}
        {r.same_day_km ? <span className="small muted" title={tr('Recorded with a date only: it counts from the start of that day, and this much was ridden later that day')}>{tr('+ up to')} {kmText(r.same_day_km, 'KNOWN')} {tr('that day')}</span> : null}
        {r.cost_cents !== null && <span className="small muted">{euro(r.cost_cents)}</span>}
      </span>
    </li>
  )
}

// part page: folded until opened (and only then loaded), so the page stays short
export function FoldedTimeline({ componentId }: { componentId: number }) {
  const [open, setOpen] = useState(false)
  return (
    <details className="span-2 timeline-fold" data-testid="part-timeline" onToggle={(e) => setOpen((e.target as HTMLDetailsElement).open)}>
      <summary className="btn">{tr('Timeline with km · CSV export')}</summary>
      {open && <Timeline componentId={componentId} className="" />}
    </details>
  )
}
