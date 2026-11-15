import { useEffect, useId, useState } from 'react'
import { useApi } from '../hooks'
import { Field } from './ui'
import { tr } from '../i18n'

export interface ProductChoice {
  product_id: number | null
  maker: string | null
  model: string
  saved: boolean
  unverified: boolean
}

export interface ProductSuggestion {
  product_id: number | null
  maker: string | null
  model: string
  saved: boolean
}

const same = (a: string | null | undefined, b: string | null | undefined) => (a ?? '').trim().toLowerCase() === (b ?? '').trim().toLowerCase()

// Brand and model of a part (DECISIONS 149). Two text boxes with suggestions: your own products first,
// then Bike Log's list of common road bike products (unverified). Anything can be typed. On save the
// backend finds the product with that brand and model or makes one; both empty = no product.
export default function ProductPicker({ componentType, maker, model, onChange, name }: { componentType: string; maker: string; model: string; onChange: (maker: string, model: string) => void; name?: string }) {
  const id = useId()
  // what the part's name suggests (e.g. "Conti GP5000 S TR 28" -> Continental Grand Prix 5000 S TR), asked once typing pauses
  const [asked, setAsked] = useState('')
  useEffect(() => {
    const t = setTimeout(() => setAsked((name ?? '').trim()), 400)
    return () => clearTimeout(t)
  }, [name])
  const empty = !maker.trim() && !model.trim()
  const guess = useApi<ProductSuggestion | null>(empty && asked.length >= 3 ? `/product-suggest?component_type=${encodeURIComponent(componentType)}&name=${encodeURIComponent(asked)}` : null)
  const suggestion = empty && asked.length >= 3 ? guess.data : null
  const choices = useApi<{ makers: string[]; products: ProductChoice[] }>(`/product-choices?component_type=${encodeURIComponent(componentType)}`)
  const products = choices.data?.products ?? []
  const models = products.filter((p) => !maker.trim() || same(p.maker, maker))
  const known = products.find((p) => same(p.maker, maker) && same(p.model, model))
  function pickModel(v: string) {
    // picking a listed model with the brand still empty fills the brand in
    if (!maker.trim()) {
      const hits = products.filter((p) => same(p.model, v))
      if (hits.length === 1 && hits[0].maker) return onChange(hits[0].maker, hits[0].model)
    }
    onChange(maker, v)
  }
  return (
    <>
      <div className="row">
        <Field label={tr('Brand (optional)')}>
          <input list={`${id}-makers`} value={maker} aria-label={tr('Brand (optional)')} placeholder={tr('e.g. Continental')} onChange={(e) => onChange(e.target.value, model)} />
          <datalist id={`${id}-makers`}>
            {(choices.data?.makers ?? []).map((m) => (
              <option key={m} value={m} />
            ))}
          </datalist>
        </Field>
        <Field
          label={tr('Model (optional)')}
          hint={known ? (known.saved ? tr('One of your products.') : tr('From Bike Log\'s list of common products (not checked against the maker).')) : model.trim() ? tr('New product: it is added to your products when you save.') : tr('Pick from the list or type your own.')}
        >
          <input list={`${id}-models`} value={model} aria-label={tr('Model (optional)')} placeholder={tr('e.g. Grand Prix 5000 S TR')} onChange={(e) => pickModel(e.target.value)} />
          <datalist id={`${id}-models`}>
            {models.map((p) => (
              <option key={`${p.maker}|${p.model}`} value={p.model}>
                {maker.trim() ? undefined : p.maker ?? undefined}
              </option>
            ))}
          </datalist>
        </Field>
      </div>
      {suggestion && (
        <p className="small">
          {tr('From the name this looks like {product}.', { product: `${suggestion.maker ?? ''} ${suggestion.model}`.trim() })}{' '}
          <button type="button" className="btn btn-small" onClick={() => onChange(suggestion.maker ?? '', suggestion.model)}>
            {tr('Use it')}
          </button>
        </p>
      )}
    </>
  )
}
