import { useRef, useState } from 'react'
import { api } from '../api'
import Diagnostics from '../components/Diagnostics'
import FreshStart from '../components/FreshStart'
import ImportExport from '../components/ImportExport'
import PickLists from '../components/PickLists'
import StravaSettings from '../components/StravaSettings'
import VersionInfo from '../components/VersionInfo'
import { Card, Field, FormError, Tag } from '../components/ui'
import { useApp } from '../context'
import { when } from '../format'
import { useApi } from '../hooks'
import ServiceIntervals from '../components/ServiceIntervals'
import { tr, codeText, lang, LANGS, switchLanguage, type Lang } from '../i18n'

interface ImportResult {
  batch_id: number
  source_kind: string
  resumed: boolean
  rows: number
  counts: Record<string, number>
  errors: { row: number; error: string }[]
  unknown_bikes?: Record<string, number>
}

interface Batch {
  id: number
  source_kind: string
  file_name: string | null
  status: string
  rows_total: number | null
  cursor_row: number
  counts: Record<string, unknown>
  started_at: string
  finished_at: string | null
}

export default function SettingsPage() {
  const { meta, reloadMeta, toast } = useApp()
  const [f, setF] = useState({ timezone: meta.settings.timezone, import_start_date: meta.settings.import_start_date, trainer_profile_for_virtual: meta.settings.trainer_profile_for_virtual, default_tire_setup: meta.settings.default_tire_setup ?? 'TUBE', spoke_relace_after: meta.settings.spoke_relace_after ?? '3' })
  const [err, setErr] = useState<string | null>(null)
  const [saving, setSaving] = useState(false)
  const batches = useApi<Batch[]>('/imports')
  const backups = useApi<{ directory: string; backup_dir: string; backups: { name: string; size: number; kept: boolean }[]; exports: { name: string; size: number; uploaded?: boolean }[] }>('/backups')
  const fileRef = useRef<HTMLInputElement>(null)
  const backupFileRef = useRef<HTMLInputElement>(null)
  const [uploading, setUploading] = useState(false)
  const [importing, setImporting] = useState(false)
  const [result, setResult] = useState<ImportResult | null>(null)
  const [importErr, setImportErr] = useState<string | null>(null)

  async function save() {
    setSaving(true)
    setErr(null)
    try {
      await api.patch('/settings', f)
      reloadMeta()
      toast(tr('Settings saved.'))
    } catch (e) {
      setErr((e as Error).message)
    } finally {
      setSaving(false)
    }
  }
  async function upload() {
    const file = fileRef.current?.files?.[0]
    if (!file) return setImportErr(tr('Choose a CSV file first.'))
    setImporting(true)
    setImportErr(null)
    setResult(null)
    try {
      setResult(await api.upload<ImportResult>(`/imports/csv?file_name=${encodeURIComponent(file.name)}`, file))
      batches.reload()
    } catch (e) {
      setImportErr((e as Error).message)
      batches.reload()
    } finally {
      setImporting(false)
    }
  }
  async function restore(name: string) {
    if (!window.confirm(tr('Replace all current data with the backup {name}? A backup of the current data is made first, so this can be undone.', { name }))) return
    try {
      await api.post(`/backups/${encodeURIComponent(name)}/restore`)
      toast(tr('Restored {name}.', { name }))
      reloadMeta()
      backups.reload()
    } catch (e) {
      toast((e as Error).message)
    }
  }
  // Bring a backup file from another computer (e.g. the desktop app to the server). It only joins the
  // list; "Restore" next to it replaces the data, after a safety backup.
  async function uploadBackup() {
    const file = backupFileRef.current?.files?.[0]
    if (!file) return
    setUploading(true)
    try {
      const r = await api.upload<{ name: string }>(`/backups/upload?file_name=${encodeURIComponent(file.name)}`, file, 'application/octet-stream')
      toast(tr('Uploaded as {name}. Click Restore next to it to use it.', { name: r.name }))
      if (backupFileRef.current) backupFileRef.current.value = ''
      backups.reload()
    } catch (e) {
      toast((e as Error).message)
    } finally {
      setUploading(false)
    }
  }
  async function backupNow(kind: 'backups' | 'exports') {
    try {
      const r = await api.post<{ name: string }>(`/${kind}`)
      toast(tr('{x} written: {name}', { x: kind === 'backups' ? tr('Backup') : tr('Export'), name: r.name }))
      if (kind === 'exports') window.location.assign(`./api/exports/${encodeURIComponent(r.name)}`) // straight to Downloads
      backups.reload()
    } catch (e) {
      toast((e as Error).message)
    }
  }
  return (
    <div className="grid">
      <LanguageCard />
      <Card title={tr('Settings')}>
        <div className="form">
          <Field label={tr('Timezone')} hint={tr('Dates are shown in this timezone. Changing it recomputes date-only boundaries.')}>
            <input value={f.timezone} onChange={(e) => setF({ ...f, timezone: e.target.value })} />
          </Field>
          <Field label={tr('Import start date')} hint={tr('Imported rides before this local date are skipped. Empty = import everything.')}>
            <input type="date" value={f.import_start_date} onChange={(e) => setF({ ...f, import_start_date: e.target.value })} />
          </Field>
          <Field label={tr('Default tire setup')} hint={tr('Used for wheels where tube or tubeless is not set, so tubeless reminders (sealant, valves) stay off for tubes.')}>
            <select aria-label={tr('Default tire setup')} value={f.default_tire_setup} onChange={(e) => setF({ ...f, default_tire_setup: e.target.value })}>
              {meta.tire_setups.map((t) => (
                <option key={t.code} value={t.code}>
                  {t.label}
                </option>
              ))}
            </select>
          </Field>
          <Field label={tr('Replace or re-lace a wheel after this many broken spokes')} hint={tr('Broken spokes on one wheel since it was laced. A new wheel, a re-lace or a new spoke set starts again.')}>
            <input inputMode="numeric" aria-label={tr('Re-lace after broken spokes')} value={f.spoke_relace_after} onChange={(e) => setF({ ...f, spoke_relace_after: e.target.value })} />
          </Field>
          <Field label={tr('Setup for indoor (Virtual) rides')}>
            <select value={f.trainer_profile_for_virtual} onChange={(e) => setF({ ...f, trainer_profile_for_virtual: e.target.value })}>
              <option value="">{tr('Treat like outdoor')}</option>
              {meta.profiles
                .filter((p) => p.kind === 'TRAINER')
                .map((p) => (
                  <option key={p.code} value={p.code}>
                    {p.name}
                  </option>
                ))}
            </select>
          </Field>
          {meta.profiles
            .filter((p) => p.kind === 'TRAINER')
            .map((p) => (
              <p key={p.code} className="small muted">
                {p.name}{tr(': excludes')} {[...p.excluded_slots, ...p.excluded_types].map((s) => codeText(s)).join(', ')}. {p.notes}
              </p>
            ))}
          <FormError error={err} />
          <div className="form-actions">
            <button className="btn btn-primary" disabled={saving} onClick={save}>
              {tr('Save settings')}
            </button>
          </div>
        </div>
      </Card>
      <ServiceIntervals />
      <SpareMinimums />
      <PickLists />
      <Card title={tr('Import rides (CSV)')}>
        <p className="small">
          {tr('Bike Log CSV: columns')} <code>{tr('source_id, date, distance_km')}</code> {tr('(or')} <code>{tr('distance_mi')}</code>{tr('), optional')} <code>{tr('duration_min, name, bike, sport_type, trainer')}</code>.{' '}
          <a href="./api/imports/template">{tr('Download a template')}</a>{tr('. Strava\'s own export (')}<em>{tr('Download your data → activities.csv')}</em>{tr(') is recognised too. Re-importing a file never duplicates rides; your corrections and removals are kept.')}
        </p>
        <div className="row">
          <input ref={fileRef} type="file" accept=".csv,text/csv" aria-label={tr('CSV file')} />
          <button className="btn btn-primary" disabled={importing} onClick={upload}>
            {importing ? tr('Importing…') : tr('Import')}
          </button>
        </div>
        <FormError error={importErr} />
        {result && (
          <div className="notice">
            {result.resumed && tr('Resumed an interrupted import. ')}
            {Object.entries(result.counts)
              .map(([k, v]) => `${v} ${codeText(k)}`)
              .join(', ') || tr('Nothing to import.')}
            {Object.keys(result.unknown_bikes ?? {}).length > 0 && (
              <p>
                {tr('No bike with this name, so these rides have no bike yet (the name is kept on each ride; add the bike or assign the rides on the Rides page):')}{' '}
                {Object.entries(result.unknown_bikes ?? {})
                  .map(([name, n]) => `${name} (${n} ${n === 1 ? 'ride' : 'rides'})`)
                  .join(', ')}
              </p>
            )}
            {result.errors.length > 0 && (
              <ul>
                {result.errors.slice(0, 10).map((e) => (
                  <li key={e.row}>
                    {tr('Row')} {e.row}: {e.error}
                  </li>
                ))}
              </ul>
            )}
          </div>
        )}
        {batches.data && batches.data.length > 0 && (
          <ul className="list">
            {batches.data.map((b) => (
              <li key={b.id}>
                <span>{when(b.started_at)}</span>
                <span>{b.file_name ?? b.source_kind}</span>
                <Tag tone={b.status === 'COMPLETED' ? 'good' : b.status === 'FAILED' ? 'bad' : 'warn'}>{b.status.toLowerCase()}</Tag>
                <span className="small muted">
                  {b.cursor_row}/{b.rows_total ?? '?'} {tr('rows')}
                </span>
              </li>
            ))}
          </ul>
        )}
      </Card>
      <StravaSettings />
      {meta.server && (
        <Card title={tr('Account')}>
          <p>
            {tr('Signed in with Google as')} <strong>{meta.server.user}</strong>.{' '}
            <a href="/auth/logout">{tr('Sign out')}</a>
          </p>
        </Card>
      )}
      <Card title={tr('Backups and export')}>
        {backups.data && (
          <>
            <p className="small">
              {meta.server ? (
                <>{tr('Your data is stored on your Bike Log server in')} <code>{backups.data.directory}</code>{tr('. A backup is made automatically before every upgrade and once a day; download one now and then to keep a copy at home.')}</>
              ) : (
                <>{tr('Your data is stored in')} <code>{backups.data.directory}</code>{tr(', outside the program folder. A backup is made automatically before every upgrade and once a day.')}</>
              )}
            </p>
            <div className="form-actions">
              <button className="btn" onClick={() => backupNow('backups')}>
                {tr('Back up now')}
              </button>
              <button className="btn" onClick={() => backupNow('exports')}>
                {tr('Full export (zip)')}
              </button>
            </div>
            <p className="small muted">
              {tr('A full export holds all your data and attachments, with the database version, so you can import it here or on another computer. Keep it private: it includes prices, serial numbers and receipts (no Strava login).')}
            </p>
            <ul className="list small">
              {backups.data.exports.slice(0, 3).map((e) => (
                <li key={e.name}>
                  <a href={`./api/exports/${encodeURIComponent(e.name)}`}>{e.name}</a> <span className="muted">({Math.round(e.size / 1024)} KB{e.uploaded ? tr(', imported file') : ''})</span>
                </li>
              ))}
              {backups.data.backups
                .filter((b, i) => i < 5 || b.kept)
                .map((b) => (
                  <li key={b.name}>
                    {b.name} <span className="muted">({Math.round(b.size / 1024)} KB{b.kept ? tr(', kept') : ''})</span>{' '}
                    <a className="small" href={`./api/backups/${encodeURIComponent(b.name)}/download`} download>
                      {tr('Download')}
                    </a>{' '}
                    <button className="btn btn-small" aria-label={tr('Restore {name}', { name: b.name })} onClick={() => restore(b.name)}>
                      {tr('Restore')}
                    </button>
                  </li>
                ))}
            </ul>
            <ImportExport onChanged={backups.reload} />
            <details>
              <summary>{tr('Bring data from another computer')}</summary>
              <p className="small">
                {tr('On the other Bike Log, click')} <em>{tr('Back up now')}</em> {tr('and then')} <em>{tr('Download')}</em> {tr('next to the new backup. Upload that file here; it appears in the list above. Then click')} <em>{tr('Restore')}</em> {tr('next to it. The data here is backed up first, so this can be undone.')}
              </p>
              <div className="form-actions">
                <input ref={backupFileRef} type="file" accept=".db" aria-label={tr('Backup file')} />
                <button className="btn" disabled={uploading} onClick={uploadBackup}>
                  {uploading ? tr('Uploading…') : tr('Upload backup')}
                </button>
              </div>
            </details>
          </>
        )}
        <VersionInfo />
      </Card>
      <FreshStart onChanged={backups.reload} />
      <Diagnostics />
    </div>
  )
}

// How many spares of a part type to keep at home (default 2 tubes, 1 tire). Below that the type goes on
// the shopping list (Overview and Inventory). Counted stock and stored individual spares both count.
// Language of the screens and messages (Settings → Language). Saved in the database, so it survives a restart;
// the page is drawn again in the new language right away.
function LanguageCard() {
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<string | null>(null)
  async function change(to: Lang) {
    if (to === lang) return
    setBusy(true)
    setErr(null)
    try {
      await api.patch('/settings', { language: to })
      switchLanguage(to)
    } catch (e) {
      setErr((e as Error).message)
      setBusy(false)
    }
  }
  return (
    <Card title={tr('Language')}>
      <div className="form">
        <Field label={tr('Language of the app')} hint={tr('Screens, reminders and messages. What you typed yourself (names, notes) stays as it is.')}>
          <select aria-label="Language / Sprache" value={lang} disabled={busy} onChange={(e) => change(e.target.value as Lang)}>
            {LANGS.map((l) => (
              <option key={l.code} value={l.code}>
                {l.name}
              </option>
            ))}
          </select>
        </Field>
        <FormError error={err} />
      </div>
    </Card>
  )
}

function SpareMinimums() {
  const { meta, reloadMeta, toast } = useApp()
  const parse = (): [string, string][] => {
    try {
      return Object.entries(JSON.parse(meta.settings.spare_minimums || '{}') as Record<string, number>).map(([k, v]) => [k, String(v)])
    } catch {
      return []
    }
  }
  const [rows, setRows] = useState<[string, string][]>(parse)
  const [add, setAdd] = useState('')
  const [err, setErr] = useState<string | null>(null)
  const name = (code: string) => meta.component_types.find((t) => t.code === code)?.name ?? code
  async function save() {
    setErr(null)
    const data: Record<string, number> = {}
    for (const [k, v] of rows) {
      const n = Number(v || '0')
      if (!Number.isInteger(n) || n < 0) return setErr(tr('Enter a whole number for {name}.', { name: name(k) }))
      data[k] = n
    }
    try {
      await api.patch('/settings', { spare_minimums: JSON.stringify(data) })
      reloadMeta()
      toast(tr('Spares to keep saved.'))
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <Card title={tr('Spares to keep')}>
      <p className="small muted">{tr('When you have fewer spares than this, the part goes on the shopping list. 0 turns the check off.')}</p>
      <div className="form">
        {rows.map(([k, v], i) => (
          <Field key={k} label={name(k)}>
            <input
              inputMode="numeric"
              aria-label={tr('Spares to keep: {name}', { name: name(k) })}
              value={v}
              onChange={(e) => setRows(rows.map((r, j) => (j === i ? [k, e.target.value] : r)))}
            />
          </Field>
        ))}
        <Field label={tr('Add a part type')}>
          <select
            value={add}
            onChange={(e) => {
              if (e.target.value) setRows([...rows, [e.target.value, '1']])
              setAdd('')
            }}
          >
            <option value="">{tr('Choose…')}</option>
            {meta.component_types
              .filter((t) => !rows.some(([k]) => k === t.code))
              .map((t) => (
                <option key={t.code} value={t.code}>
                  {t.name}
                </option>
              ))}
          </select>
        </Field>
        <FormError error={err} />
        <div className="form-actions">
          <button className="btn btn-primary" onClick={save}>
            {tr('Save spares to keep')}
          </button>
        </div>
      </div>
    </Card>
  )
}
