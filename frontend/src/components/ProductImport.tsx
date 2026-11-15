import { useState } from 'react'
import { api, newOpId } from '../api'
import { useApp } from '../context'
import { Field, FormError, Tag } from './ui'
import { tr, trn } from '../i18n'

interface Report {
  ok: boolean
  dry_run: boolean
  errors: string[]
  warnings: string[]
  counts: { CREATED: number; UPDATED: number; UNCHANGED: number; ITEMS_CREATED: number; ITEMS_EXISTING: number }
  products: { at: string; component_type: string; maker: string; model: string; status: string; changed: string[]; items: { label: string; status: string }[] }[]
}

interface FileResult {
  name: string
  report?: Report
  error?: string
}

// Product JSON files from scripts (e.g. scrapers). Each file is checked first; nothing is written until
// "Import". A file with any error is skipped as a whole. The templates are one schema + example per type.
export default function ProductImport({ onDone }: { onDone: (msg: string) => void }) {
  const { meta } = useApp()
  const [files, setFiles] = useState<File[]>([])
  const [results, setResults] = useState<FileResult[] | null>(null)
  const [checked, setChecked] = useState(false)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [type, setType] = useState('CHAIN')

  async function run(dry: boolean) {
    setBusy(true)
    setError(null)
    const out: FileResult[] = []
    const valid = new Set(results?.filter((r) => r.report?.ok).map((r) => r.name))
    for (const f of dry ? files : files.filter((x) => valid.has(x.name))) {
      try {
        const text = await f.text()
        const report = await api.post<Report>(`/imports/products${dry ? '?dry_run=true' : ''}`, JSON.parse(text), dry ? undefined : newOpId())
        out.push({ name: f.name, report })
      } catch (e) {
        out.push({ name: f.name, error: e instanceof SyntaxError ? tr('Not valid JSON: {message}', { message: e.message }) : (e as Error).message })
      }
    }
    setResults(out)
    setBusy(false)
    if (dry) setChecked(true)
    else {
      const ok = out.filter((r) => r.report?.ok)
      const c = (k: keyof Report['counts']) => ok.reduce((s, r) => s + (r.report?.counts[k] ?? 0), 0)
      onDone(trn('{length} of {n} file imported: {c} new, {c2} updated products, {c3} new parts.', '{length} of {n} files imported: {c} new, {c2} updated products, {c3} new parts.', out.length, { length: ok.length, c: c('CREATED'), c2: c('UPDATED'), c3: c('ITEMS_CREATED') }))
    }
  }
  const good = results?.filter((r) => r.report?.ok).length ?? 0
  return (
    <div className="form">
      <p className="small muted">
        {tr('Import product data made by a script, for example a scraper. One file can hold one product or a list. Importing the same file again changes nothing; changed data updates the product. Parts listed under')} <code>{tr('items')}</code> {tr('are added as spares.')}
      </p>
      <Field label={tr('JSON files')}>
        <input
          type="file"
          accept=".json,application/json"
          multiple
          aria-label={tr('JSON files')}
          onChange={(e) => {
            setFiles(Array.from(e.target.files ?? []))
            setResults(null)
            setChecked(false)
          }}
        />
      </Field>
      {results && (
        <ul className="list import-results">
          {results.map((r) => (
            <li key={r.name}>
              <span>
                <strong>{r.name}</strong>{' '}
                {r.error ? (
                  <Tag tone="bad">{tr('not readable')}</Tag>
                ) : r.report?.ok ? (
                  <Tag tone="good">
                    {tr(r.report.dry_run ? 'ready: {created} new · {updated} updated · {unchanged} unchanged' : 'imported: {created} new · {updated} updated · {unchanged} unchanged', { created: r.report.counts.CREATED, updated: r.report.counts.UPDATED, unchanged: r.report.counts.UNCHANGED })}
                    {r.report.counts.ITEMS_CREATED ? tr(' · {ITEMS_CREATED} new parts', { ITEMS_CREATED: r.report.counts.ITEMS_CREATED }) : ''}
                  </Tag>
                ) : (
                  <Tag tone="bad">{trn('{n} error, nothing will be imported', '{n} errors, nothing will be imported', r.report?.errors.length ?? 0)}</Tag>
                )}
                {r.error && <span className="small"> {r.error}</span>}
                {r.report && (
                  <span className="small import-lines">
                    {r.report.errors.map((e) => (
                      <span key={e} className="bad-text">
                        {e}
                      </span>
                    ))}
                    {r.report.ok &&
                      r.report.products.map((p) => (
                        <span key={p.at}>
                          {p.maker} {p.model}: {p.status.toLowerCase()}
                          {p.changed.length ? ` (${p.changed.join(', ')})` : ''}
                          {p.items.length ? tr(' · parts: {join}', { join: p.items.map((i) => `${i.label} ${i.status === 'EXISTS' ? tr('(exists)') : tr('(new)')}`).join(', ') }) : ''}
                        </span>
                      ))}
                    {r.report.warnings.map((w) => (
                      <span key={w} className="muted">
                        {w}
                      </span>
                    ))}
                  </span>
                )}
              </span>
            </li>
          ))}
        </ul>
      )}
      <FormError error={error} />
      <div className="form-actions">
        <button className="btn" disabled={busy || files.length === 0} onClick={() => run(true)}>
          {busy && !checked ? tr('Checking…') : tr('Check files')}
        </button>
        <button className="btn btn-primary" disabled={busy || !checked || good === 0} onClick={() => run(false)}>
          {tr('Import')} {good > 0 && good < (results?.length ?? 0) ? tr('{good} valid files', { good }) : ''}
        </button>
      </div>
      <fieldset className="field">
        <legend className="field-label">{tr('Templates for scripts')}</legend>
        <div className="row">
          <select aria-label={tr('Template type')} value={type} onChange={(e) => setType(e.target.value)}>
            {meta.component_types.map((t) => (
              <option key={t.code} value={t.code}>
                {t.name}
              </option>
            ))}
          </select>
          <a className="btn btn-small" href={`./api/product-templates/${type}/schema`} download>
            {tr('Schema')}
          </a>
          <a className="btn btn-small" href={`./api/product-templates/${type}/example`} download>
            {tr('Example')}
          </a>
        </div>
        <p className="small muted">
          {tr('Writing a script with an AI agent? Give it the')} <a href="./api/product-templates/instructions.md" download>{tr('instructions for script authors')}</a>{tr('; they cover every part type.')}
        </p>
      </fieldset>
    </div>
  )
}
