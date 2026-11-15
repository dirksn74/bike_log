import { useState } from 'react'
import { useApi } from '../hooks'
import { Card, ErrorBox, Field, Loading } from './ui'
import { tr } from '../i18n'

interface LogTail {
  directory: string
  file: string
  lines: string[]
  size_bytes: number
  files: string[]
}

// The diagnostic log (what Bike Log did, warnings and errors), newest at the bottom. Secrets are
// removed before anything is written, and again before it is shown or downloaded.
export default function Diagnostics() {
  const [level, setLevel] = useState('INFO')
  const [lines, setLines] = useState(200)
  const log = useApi<LogTail>(`/logs?lines=${lines}&level=${level}`)
  return (
    <Card
      title={tr('Diagnostics')}
      actions={
        <button className="btn btn-small" onClick={log.reload}>
          {tr('Refresh')}
        </button>
      }
    >
      <p className="small muted">
        {tr('What Bike Log did: starts, imports, syncs, refused actions, warnings and errors. Passwords, tokens and the Strava secret are never shown. If something goes wrong, download the log and send it along with your question.')}
      </p>
      <div className="row">
        <Field label={tr('Show')}>
          <select aria-label={tr('Log level')} value={level} onChange={(e) => setLevel(e.target.value)}>
            <option value="INFO">{tr('Everything')}</option>
            <option value="WARNING">{tr('Warnings and errors')}</option>
            <option value="ERROR">{tr('Errors only')}</option>
          </select>
        </Field>
        <Field label={tr('Lines')}>
          <select aria-label={tr('Log lines')} value={lines} onChange={(e) => setLines(Number(e.target.value))}>
            {[100, 200, 1000, 5000].map((n) => (
              <option key={n} value={n}>
                {tr('last')} {n}
              </option>
            ))}
          </select>
        </Field>
      </div>
      {log.loading && !log.data && <Loading what={tr('Reading the log')} />}
      {log.error && <ErrorBox error={log.error} onRetry={log.reload} />}
      {log.data && (
        <>
          <pre className="log-view" aria-label={tr('Log lines')}>
            {log.data.lines.length ? log.data.lines.join('\n') : tr('Nothing logged at this level.')}
          </pre>
          <p className="small muted">
            {tr('Log files:')} <code>{log.data.directory}</code> ({Math.round(log.data.size_bytes / 1024)} {tr('KB, kept small automatically).')}{' '}
            <a href="./api/logs/download" download>
              {tr('Download log')}
            </a>
          </p>
        </>
      )}
    </Card>
  )
}
