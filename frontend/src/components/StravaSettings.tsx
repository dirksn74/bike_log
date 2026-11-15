import { useEffect, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { api } from '../api'
import { when } from '../format'
import { useApi } from '../hooks'
import { Card, ErrorBox, Field, FormError, Loading, Tag } from './ui'
import { tr } from '../i18n'

interface StravaStatus {
  connected: boolean
  live_connection_verified: boolean
  last_error: string | null
  last_success_at: string | null
  alternative: string
  callback_domain: string
  server: boolean
  credentials: { client_id: string | null; secret_saved: boolean; tokens_saved: boolean; athlete_id: string | null; scope: string | null; env_file: string }
  job: { running: boolean; rescan?: boolean; page?: number; counts?: Record<string, number>; error?: string | null; finished_at?: string | null }
}

const COUNT_LABEL: Record<string, string> = { CREATED: tr('new'), UPDATED: tr('updated'), UNCHANGED: tr('unchanged'), SKIPPED_NOT_CYCLING: tr('not cycling'), BIKES_CREATED: tr('bikes created'), BIKES_LINKED: tr('bikes linked'), SKIPPED_UNKNOWN_BIKE: tr('skipped (bike not in Bike Log)') }
const countsText = (c?: Record<string, number>) =>
  Object.entries(c ?? {})
    .map(([k, v]) => `${v} ${COUNT_LABEL[k] ?? k.toLowerCase().replace(/_/g, ' ')}`)
    .join(', ') || tr('nothing new')

// Everything for Strava without the command line: app details, connect (browser), sync, disconnect.
// The secret is sent once and never shown again; it is stored only in strava.env in the data folder.
export default function StravaSettings() {
  const st = useApi<StravaStatus>('/strava/status')
  const cfg = useApi<Record<string, string>>('/settings')
  const knownOnly = cfg.data?.strava_known_bikes_only === '1'
  const [params, setParams] = useSearchParams()
  const [f, setF] = useState({ client_id: '', client_secret: '' })
  const [err, setErr] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [notice, setNotice] = useState<string | null>(null)
  const d = st.data
  const running = !!d?.job.running

  useEffect(() => {
    const result = params.get('strava')
    if (!result) return
    if (result === 'connected') setNotice(params.get('private') === '1' ? tr('Strava connected, including private rides. Now press "Sync now".') : tr('Strava connected. Private rides were not allowed, so only public rides will be imported. Now press "Sync now".'))
    else setErr(params.get('message') ?? tr('Strava connection failed'))
    params.delete('strava')
    params.delete('message')
    params.delete('private')
    setParams(params, { replace: true })
  }, [params, setParams])
  useEffect(() => {
    if (d?.credentials.client_id && !f.client_id) setF((x) => ({ ...x, client_id: d.credentials.client_id ?? '' }))
  }, [d, f.client_id])
  useEffect(() => {
    if (!running) return
    const t = window.setInterval(st.reload, 2000)
    return () => window.clearInterval(t)
  }, [running, st.reload])

  async function act(fn: () => Promise<unknown>, done?: string) {
    setBusy(true)
    setErr(null)
    setNotice(null)
    try {
      await fn()
      if (done) setNotice(done)
      st.reload()
    } catch (e) {
      setErr((e as Error).message)
    } finally {
      setBusy(false)
    }
  }
  async function connect() {
    setBusy(true)
    setErr(null)
    try {
      const r = await api.post<{ authorize_url: string }>('/strava/connect')
      window.location.href = r.authorize_url
    } catch (e) {
      setErr((e as Error).message)
      setBusy(false)
    }
  }

  if (st.loading && !d) return <Card title={tr('Strava')}><Loading /></Card>
  if (st.error && !d) return <Card title={tr('Strava')}><ErrorBox error={st.error} onRetry={st.reload} /></Card>
  if (!d) return null
  const c = d.credentials
  const job = d.job
  return (
    <Card title={tr('Strava')}>
      <p>
        {c.tokens_saved ? <Tag tone="good">{tr('Connected')}</Tag> : <Tag tone="warn">{tr('Not connected')}</Tag>}{' '}
        {d.last_success_at ? tr('Last successful sync: {last_success_at}.', { last_success_at: when(d.last_success_at) }) : c.tokens_saved ? tr('No sync yet.') : tr('No successful sync with Strava yet.')}
      </p>
      {notice && <p className="notice">{notice}</p>}
      <FormError error={err} />

      {!c.tokens_saved && (
        <>
          <p className="small">
            <strong>1.</strong> {tr('On')}{' '}
            <a href="https://www.strava.com/settings/api" target="_blank" rel="noreferrer">
              {tr('strava.com/settings/api')}
            </a>{' '}
            {tr('create (or open) your API application and set')} <strong>{tr('Authorization Callback Domain')}</strong> {tr('to')} <code>{d.callback_domain}</code>{tr('. Copy the Client ID and Client Secret here.')}
          </p>
          <div className="row">
            <Field label={tr('Client ID')}>
              <input inputMode="numeric" autoComplete="off" value={f.client_id} onChange={(e) => setF({ ...f, client_id: e.target.value })} />
            </Field>
            <Field label={tr('Client Secret')} hint={c.secret_saved ? tr('Saved. Leave empty to keep it.') : d.server ? tr('Stored only on your Bike Log server; never shown again.') : tr('Stored only on this computer; never shown again.')}>
              <input type="password" autoComplete="new-password" value={f.client_secret} placeholder={c.secret_saved ? tr('•••••••• saved') : ''} onChange={(e) => setF({ ...f, client_secret: e.target.value })} />
            </Field>
          </div>
          <div className="form-actions">
            {c.secret_saved && (
              <button className="btn btn-small" disabled={busy} onClick={() => act(() => api.del('/strava/credentials'), tr('Saved app details removed.')).then(() => setF({ client_id: '', client_secret: '' }))}>
                {tr('Remove saved details')}
              </button>
            )}
            <button
              className="btn"
              disabled={busy || !f.client_id.trim() || (!c.secret_saved && !f.client_secret.trim())}
              onClick={() => act(() => api.put('/strava/credentials', { client_id: f.client_id, client_secret: f.client_secret || null }), tr('Saved. Now connect with Strava.')).then(() => setF((x) => ({ ...x, client_secret: '' })))}
            >
              {tr('Save app details')}
            </button>
          </div>
          <p className="small">
            <strong>2.</strong> {tr('Connect: Strava opens, you click')} <em>{tr('Authorize')}</em>{tr(', and you come back here.')}
          </p>
          <div className="form-actions">
            <button className="btn btn-primary" disabled={busy || !(c.client_id && c.secret_saved)} onClick={connect}>
              {tr('Connect with Strava')}
            </button>
          </div>
        </>
      )}

      {c.tokens_saved && (
        <>
          <p className="small muted">
            {tr('Strava athlete')} {c.athlete_id ?? '?'} · {c.scope?.includes('activity:read_all') ? tr('private rides included') : tr('public rides only')}{tr('. Rides are matched to bikes by their Strava gear.')}
          </p>
          {running ? (
            <p className="notice">
              {tr('Syncing')}{job.rescan ? tr(' (re-reading everything)') : ''}{tr('… page')} {job.page ?? 0}: {countsText(job.counts)}
            </p>
          ) : (
            job.finished_at && (job.error ? <p className="small form-error">{tr('Sync failed:')} {job.error}</p> : <p className="small">{tr('Last sync:')} {countsText(job.counts)}.</p>)
          )}
          <div className="form-actions">
            <button
              className="btn btn-small"
              disabled={busy || running}
              onClick={() => {
                if (window.confirm(tr('Disconnect Strava? Bike Log stops syncing and Strava access is revoked. All rides stay in Bike Log.')))
                  act(() => api.post<{ kept_rides: number }>('/strava/disconnect').then((r) => setNotice(tr('Disconnected. All {kept_rides} rides imported from Strava are kept.', { kept_rides: r.kept_rides }))))
              }}
            >
              {tr('Disconnect')}
            </button>
            <button className="btn" disabled={busy || running} onClick={() => act(() => api.post('/strava/sync', { rescan: true }))}>
              {tr('Re-read all since start date')}
            </button>
            <button className="btn btn-primary" disabled={busy || running} onClick={() => act(() => api.post('/strava/sync', { rescan: false }))}>
              {running ? tr('Syncing…') : tr('Sync now')}
            </button>
          </div>
        </>
      )}
      <label className="switch-row">
        <input
          type="checkbox"
          aria-label={tr('Import only rides with known bikes')}
          checked={knownOnly}
          disabled={busy || running || !cfg.data}
          onChange={(e) => act(() => api.patch('/settings', { strava_known_bikes_only: e.target.checked ? '1' : '0' }).then(cfg.reload), e.target.checked ? tr('Only rides with bikes known here will be imported.') : tr('All cycling rides will be imported again.'))}
        />{' '}
        <span>
          <strong>{tr('Import only rides with known bikes')}</strong>
          <span className="small muted">
            {' '}
            {knownOnly
              ? tr('On: a ride whose Strava bike is not in Bike Log (or that has no bike) is skipped and no bike is created. Rides already here stay. Add the bike later with the same name as on Strava (or its Strava gear id) and press "Re-read all since start date" to bring its rides in.')
              : tr('Off: a ride with an unknown Strava bike links to the bike with the same name here, or creates that bike.')}
          </span>
        </span>
      </label>
      {d.last_error && !running && !job.finished_at && <p className="small form-error">{tr('Last attempt failed:')} {d.last_error}</p>}
      <p className="small muted">
        {tr('Not yet tested against the real Strava; tell me if anything fails.')} {d.alternative} {tr('The app works fully without Strava.')}
      </p>
    </Card>
  )
}
