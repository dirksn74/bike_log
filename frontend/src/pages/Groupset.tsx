// The groupset of a bike as one thing: the parts in its groupset positions now (drivetrain, shifting, brakes,
// the Di2 / AXS battery, plus the cassette and rotors on the wheels). Combined km, service tasks, incidents,
// maintenance log and journal; the parts unfold to their own parts, each linking to its page.
import { Link, useParams } from 'react-router-dom'
import { IncidentRows } from '../components/Incidents'
import PartTree from '../components/PartTree'
import TaskList from '../components/TaskList'
import { Card, Empty, ErrorBox, Loading, Tag } from '../components/ui'
import { km, when } from '../format'
import { useCrumb } from '../crumbs'
import { useApi } from '../hooks'
import EventLog from '../components/EventLog'
import type { GroupsetPageData } from '../types'
import { tr } from '../i18n'

export function GroupsetPage() {
  const { id } = useParams()
  const { data, error, loading, reload } = useApi<GroupsetPageData>(`/bikes/${id}/groupset`)
  useCrumb(`/bikes/${id}/groupset`, data ? tr('Groupset') : null, data ? { [`/bikes/${data.bike_id}`]: data.bike } : undefined)
  if (loading && !data) return <Loading />
  if (error && !data) return <ErrorBox error={error} onRetry={reload} />
  if (!data) return null
  const back = <Link to={`/bikes/${data.bike_id}`}>{data.bike}</Link>
  if (!data.parts.length)
    return (
      <Card title={tr('Groupset')} className="span-2">
        <Empty title={tr('No groupset parts on this bike')}>{tr('Add them on {page} → Manage parts → Add groupset.', { page: back })}</Empty>
      </Card>
    )
  const open = data.tasks.filter((t) => !['OK', 'SNOOZED', 'INSUFFICIENT_INFO'].includes(t.status))
  const rest = data.tasks.filter((t) => !open.includes(t))
  return (
    <div className="grid">
      <Card title={data.name} className="span-2">
        <p className="small muted">
          {tr('Groupset on')} {back}
          {data.since ? tr(', parts on it since {since}', { since: when(data.since) }) : ''}{tr('. It is the parts in the groupset positions now: a part you swap in joins it, a part you take off leaves it.')}
        </p>
        <div className="stats">
          <div>
            <span className="stat">{km(data.stats.km, 0)}</span>
            <span className="muted small">{tr('on this bike since then')}</span>
          </div>
          <div>
            <span className="stat">{data.stats.hours.toFixed(0)} h</span>
            <span className="muted small">{tr('ride time')}{data.stats.rides_without_time ? tr(' ({rides_without_time} rides without time)', { rides_without_time: data.stats.rides_without_time }) : ''}</span>
          </div>
          <div>
            <span className="stat">{data.stats.parts}</span>
            <span className="muted small">{tr('parts')}</span>
          </div>
          <div>
            <span className="stat">{data.stats.due}</span>
            <span className="muted small">{tr('need attention')}</span>
          </div>
        </div>
        <p className="small">
          <Link to={`/bikes/${data.bike_id}?add=groupset`}>{tr('Replace whole groupset')}</Link> {tr('· change single parts under the bike\'s Manage parts')}
        </p>
        <p className="small muted">{tr('Each part keeps its own km (a chain swapped in later has fewer); open a part for its own numbers.')}</p>
      </Card>
      <Card title={tr('Parts')} className="span-2">
        <details className="task-group" data-group="groupset-parts">
          <summary>
            <strong>{tr('Show the {n} parts', { n: data.stats.parts })}</strong>
            <span className="muted small">{data.parts.map((n) => n.label).slice(0, 3).join(', ')}, …</span>
          </summary>
          <PartTree nodes={data.parts} />
        </details>
      </Card>
      <Card title={tr('Service tasks')} className="span-2">
        <TaskList tasks={open} onChange={reload} emptyText={tr('Nothing due on the groupset.')} />
        {rest.length > 0 && (
          <details className="task-group">
            <summary>
              <strong>{tr('Up to date, snoozed or needing a first entry')}</strong>
              <span className="muted small">{rest.length}</span>
            </summary>
            <TaskList tasks={rest} onChange={reload} />
          </details>
        )}
      </Card>
      <Card title={tr('Incidents')} className="span-2">
        {data.incidents.length ? (
          <IncidentRows incidents={data.incidents} bikeName={data.bike} showRide onChanged={reload} />
        ) : (
          <Empty title={tr('No incidents on the groupset parts')} />
        )}
      </Card>
      <Card title={tr('Maintenance log')}>
        <EventLog events={data.events} onChanged={reload} show="part" limit={50} />
      </Card>
      <Card title={tr('Journal')}>
        {data.journal.length === 0 ? (
          <Empty title={tr('No notes yet')}>{tr('Add a note on a part\'s page.')}</Empty>
        ) : (
          <ul className="list">
            {data.journal.map((j) => (
              <li key={j.id}>
                <span>{when(j.on)}</span>
                {j.kind === 'ISSUE' && <Tag tone={j.open_issue ? 'warn' : 'neutral'}>{j.open_issue ? tr('open issue') : tr('issue solved')}</Tag>}
                <span>{j.text}</span>
                {j.component_id && <Link to={`/inventory/${j.component_id}`}>{j.component_label}</Link>}
              </li>
            ))}
          </ul>
        )}
      </Card>
    </div>
  )
}
