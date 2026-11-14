import { useRef, useState } from 'react'
import { api } from '../api'
import { useApp } from '../context'
import { when } from '../format'
import { FormError } from './ui'

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
  return `${parts}${e.attachments ? `, ${e.attachments} attached files` : ''}`
}

export default function ImportExport({ onChanged }: { onChanged: () => void }) {
  const { reloadMeta, toast } = useApp()
  const fileRef = useRef<HTMLInputElement>(null)
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<string | null>(null)
  const [info, setInfo] = useState<ExportInfo | null>(null)

  async function check() {
    const file = fileRef.current?.files?.[0]
    if (!file) return setErr('Choose an export file first (bikelog-export-….zip).')
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
    if (!window.confirm('Replace ALL your current data with this export? Your current data is backed up first (kept), so this can be undone with Restore.')) return
    setBusy(true)
    setErr(null)
    try {
      const r = await api.post<ImportResult>(`/exports/${encodeURIComponent(info.name)}/restore`)
      toast(`Export imported${r.from_schema !== r.to_schema ? ' and upgraded to this version' : ''}. Your data from before is kept as ${r.backup}.`)
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
      <summary>Import a full export</summary>
      <p className="small">
        Puts back everything from a full export (zip): bikes, parts, rides, work done, supplies, attachments. All your current data is replaced. It is backed up first and kept, so you can go back with <em>Restore</em>. An
        export from an older Bike Log version is upgraded to this version. Importing the same file twice gives the same result.
      </p>
      <div className="form-actions">
        <input ref={fileRef} type="file" accept=".zip" aria-label="Export file" onChange={() => setInfo(null)} />
        <button className="btn" disabled={busy} onClick={check}>
          {busy && !info ? 'Checking…' : 'Check file'}
        </button>
      </div>
      <FormError error={err} />
      {info && (
        <div className="notice small" role="status">
          <p>
            <strong>The file is fine.</strong> Export from {info.created_at ? when(info.created_at) : 'an unknown date'}
            {info.app_version ? `, Bike Log ${info.app_version}` : ''}. It holds {describeExport(info)}.
          </p>
          {info.needs_upgrade && <p>It was made by an older Bike Log version (database schema {info.schema_revision}); it is upgraded to this version during the import.</p>}
          <div className="form-actions">
            <button className="btn btn-primary" disabled={busy} onClick={restore}>
              {busy ? 'Importing…' : 'Replace all my data with this export'}
            </button>
            <button className="btn" disabled={busy} onClick={() => setInfo(null)}>
              Cancel
            </button>
          </div>
        </div>
      )}
    </details>
  )
}
