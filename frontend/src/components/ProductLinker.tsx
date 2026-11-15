import { useState } from 'react'
import { Link } from 'react-router-dom'
import { api, newOpId } from '../api'
import { useApi } from '../hooks'
import { FormError } from './ui'
import type { ProductSuggestion } from './ProductPicker'
import { tr, trn } from '../i18n'

interface Unlinked {
  id: number
  label: string
  component_type: string
  type_name: string
  status: string
  suggestion: ProductSuggestion | null
}

const productName = (s: ProductSuggestion) => `${s.maker ?? ''} ${s.model}`.trim()

// Parts with a name but no brand and model (DECISIONS 149). Where the name gives the product away
// ("Continental Grand Prix 5000 S TR 28" Faltreifen"), it is suggested and can be linked in one go;
// the name itself stays as typed. The others are set on the part's page under Edit details.
export default function ProductLinker({ onLinked }: { onLinked?: () => void }) {
  const { data, reload } = useApi<Unlinked[]>('/components-without-product')
  const [skip, setSkip] = useState<Set<number>>(new Set())
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<string | null>(null)
  const [done, setDone] = useState<string | null>(null)
  if (!data || (data.length === 0 && !done)) return null
  const suggested = data.filter((r) => r.suggestion)
  const rest = data.filter((r) => !r.suggestion)
  const chosen = suggested.filter((r) => !skip.has(r.id))
  async function link() {
    setBusy(true)
    setErr(null)
    try {
      await api.post('/components-without-product/link', { links: chosen.map((r) => ({ component_id: r.id, maker: r.suggestion!.maker, model: r.suggestion!.model })) }, newOpId())
      setDone(trn('Brand and model set on {n} part.', 'Brand and model set on {n} parts.', chosen.length))
      setSkip(new Set())
      reload()
      onLinked?.()
    } catch (e) {
      setErr((e as Error).message)
    } finally {
      setBusy(false)
    }
  }
  return (
    <details className="card product-linker">
      <summary>
        <strong>{tr('Parts without brand and model')}</strong> <span className="muted small">({data.length})</span>
      </summary>
      {done && <p className="small">{done}</p>}
      <p className="small muted">{tr('Brand and model let the part life report compare products. The part names stay as they are.')}</p>
      {suggested.length > 0 && (
        <>
          <h4>{tr('Suggested from the name')}</h4>
          <ul className="list">
            {suggested.map((r) => (
              <li key={r.id} className="small">
                <label className="check">
                  <input
                    type="checkbox"
                    checked={!skip.has(r.id)}
                    onChange={(e) => {
                      const next = new Set(skip)
                      if (e.target.checked) next.delete(r.id)
                      else next.add(r.id)
                      setSkip(next)
                    }}
                  />{' '}
                  <span>
                    <Link to={`/inventory/${r.id}`}>{r.label}</Link> <span className="muted">({r.type_name})</span> → <strong>{productName(r.suggestion!)}</strong>
                  </span>
                </label>
              </li>
            ))}
          </ul>
          <FormError error={err} />
          <div className="form-actions">
            <button className="btn btn-primary" disabled={busy || chosen.length === 0} onClick={link}>
              {busy ? tr('Saving…') : trn('Set brand and model on {n} part', 'Set brand and model on {n} parts', chosen.length)}
            </button>
          </div>
        </>
      )}
      {rest.length > 0 && (
        <details>
          <summary>
            {tr('No suggestion')} <span className="muted small">({rest.length})</span>
          </summary>
          <p className="small muted">{tr('Open a part and set its brand and model under Edit details.')}</p>
          <ul className="list">
            {rest.map((r) => (
              <li key={r.id} className="small">
                <Link to={`/inventory/${r.id}`}>{r.label}</Link> <span className="muted">({r.type_name})</span>
              </li>
            ))}
          </ul>
        </details>
      )}
    </details>
  )
}
