import { useState, type ReactNode } from 'react'
import { useApi } from '../hooks'
import { Field } from './ui'
import { tr } from '../i18n'

const NEW = '__new__'

// "Bought from": pick a shop you used before, or type a new one (it joins the list when saved).
// The list is managed in Settings → Lists (DECISIONS 106).
export default function ShopPicker({ value, onChange, label = tr('Bought from (optional)'), list = 'SHOP', hint }: { value: string; onChange: (v: string) => void; label?: string; list?: string; hint?: ReactNode }) {
  const names = useApi<string[]>(`/lists/${list}`)
  const known = names.data ?? []
  const [typing, setTyping] = useState(false)
  const options = value && !known.some((n) => n.toLowerCase() === value.toLowerCase()) && !typing ? [value, ...known] : known
  return (
    <>
      <Field label={label} hint={hint}>
        <select
          aria-label={label}
          value={typing ? NEW : options.find((n) => n.toLowerCase() === value.toLowerCase()) ?? ''}
          onChange={(e) => {
            if (e.target.value === NEW) {
              setTyping(true)
              onChange('')
            } else {
              setTyping(false)
              onChange(e.target.value)
            }
          }}
        >
          <option value="">{tr('— not entered —')}</option>
          {options.map((n) => (
            <option key={n} value={n}>
              {n}
            </option>
          ))}
          <option value={NEW}>{tr('New shop…')}</option>
        </select>
      </Field>
      {typing && (
        <Field label={tr('New shop name')} hint={tr('It is added to your shop list when you save.')}>
          <input autoFocus value={value} onChange={(e) => onChange(e.target.value)} placeholder={tr('e.g. bike-components.de')} />
        </Field>
      )}
    </>
  )
}
