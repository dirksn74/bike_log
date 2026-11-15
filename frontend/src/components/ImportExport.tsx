import { useRef, useState } from 'react'
import { api } from '../api'
import { useApp } from '../context'
import { when } from '../format'
import { FormError } from './ui'
import { tr } from '../i18n'

// Settings → Backups and export → Import a full export. Two steps: the file is uploaded and checked
// (nothing changes yet, the person sees what is in it), then "Replace all my data" restores it. The data
// from before is backed up first (kept), and an export from an older Bike Log is upgraded.
interface ExportInfo {
  name: string
  created_at: string | null
  app_version: string | null
  schema_revision: string
  needs_upgrade: boolean
  counts: Record<string, number>
  attachments: number
}

interface ImportResult {
  imported: string
  backup: string | null
  from_schema: string
  to_schema: string
}

function describeExport(e: ExportInfo): string {
  const parts = Object.entries(e.counts)
    .map(([label, n]) => `${n} ${label}`)
    .join(', ')
  return `${parts}${e.attachments ? tr(', {attachments} attached files', { attachments: e.attachments }) : ''}`
}

export default function ImportExport({ onChanged }: { onChanged: () => void }) {
  const { reloadMeta, toast } = useApp()
  const fileRef = useRef<HTMLInputElement>(null)
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<string | null>(null)
  const [info, setInfo] = useState<ExportInfo | null>(null)

  async function check() {
    const file = fileRef.current?.files?.[0]
    if (!file) return setErr(tr('Choose an export file first (bikelog-export-….zip).'))
    setBusy(true)
    setErr(null)
    setInfo(null)
    try {
      setInfo(await api.upload<ExportInfo>(`/exports/upload?file_name=${encodeURIComponent(file.name)}`, file, 'application/zip'))
      onChanged()
    } catch (e) {
      setErr((e as Error).message)
    } finally {
      setBusy(false)
    }
  }

  async function restore() {
    if (!info) return
    if (!window.confirm(tr('Replace ALL your current data with this export? Your current data is backed up first (kept), so this can be undone with Restore.'))) return
    setBusy(true)
    setErr(null)
    try {
      const r = await api.post<ImportResult>(`/exports/${encodeURIComponent(info.name)}/restore`)
      toast(tr('Export imported{x}. Your data from before is kept as {backup}.', { x: r.from_schema !== r.to_schema ? tr(' and upgraded to this version') : '', backup: r.backup }))
      setInfo(null)
      if (fileRef.current) fileRef.current.value = ''
      reloadMeta()
      onChanged()
    } catch (e) {
      setErr((e as Error).message)
    } finally {
      setBusy(false)
    }
  }

  return (
    <details>
      <summary>{tr('Import a full export')}</summary>
      <p className="small">
        {tr('Puts back everything from a full export (zip): bikes, parts, rides, work done, supplies, attachments. All your current data is replaced. It is backed up first and kept, so you can go back with')} <em>{tr('Restore')}</em>{tr('. An export from an older Bike Log version is upgraded to this version. Importing the same file twice gives the same result.')}
      </p>
      <div className="form-actions">
        <input ref={fileRef} type="file" accept=".zip" aria-label={tr('Export file')} onChange={() => setInfo(null)} />
        <button className="btn" disabled={busy} onClick={check}>
          {busy && !info ? tr('Checking…') : tr('Check file')}
        </button>
      </div>
      <FormError error={err} />
      {info && (
        <div className="notice small" role="status">
          <p>
            <strong>{tr('The file is fine.')}</strong> {tr('Export from')} {info.created_at ? when(info.created_at) : tr('an unknown date')}
            {info.app_version ? tr(', Bike Log {app_version}', { app_version: info.app_version }) : ''}{tr('. It holds')} {describeExport(info)}.
          </p>
          {info.needs_upgrade && <p>{tr('It was made by an older Bike Log version (database schema')} {info.schema_revision}{tr('); it is upgraded to this version during the import.')}</p>}
          <div className="form-actions">
            <button className="btn btn-primary" disabled={busy} onClick={restore}>
              {busy ? tr('Importing…') : tr('Replace all my data with this export')}
            </button>
            <button className="btn" disabled={busy} onClick={() => setInfo(null)}>
              {tr('Cancel')}
            </button>
          </div>
        </div>
      )}
    </details>
  )
}
