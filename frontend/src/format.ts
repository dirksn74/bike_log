import type { Status, Usage } from './types'
import { tr, locale, codeText } from './i18n'

let tz = tr('Europe/Berlin')
export function setTimezone(z: string) {
  tz = z || tz
}

export function km(v: number | null | undefined, digits = 1): string {
  if (v === null || v === undefined) return tr('unknown')
  return `${v.toLocaleString(locale, { maximumFractionDigits: digits, minimumFractionDigits: 0 })} km`
}

/** Date-only values stay date-only; instants are shown in the user's timezone. */
export function when(value: string | null | undefined): string {
  if (!value) return '—'
  if (value.length === 10) return new Date(value + 'T12:00:00Z').toLocaleDateString(locale, { timeZone: 'UTC', year: 'numeric', month: 'short', day: 'numeric' })
  const d = new Date(value)
  return d.toLocaleString(locale, { timeZone: tz, year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' })
}

export function duration(s: number | null | undefined): string {
  if (!s) return '—'
  const h = Math.floor(s / 3600)
  const m = Math.round((s % 3600) / 60)
  return h ? tr('{h} h {padStart} min', { h, padStart: m.toString().padStart(2, '0') }) : `${m} min`
}

export function today(): string {
  const parts = new Intl.DateTimeFormat('en-CA', { timeZone: tz, year: 'numeric', month: '2-digit', day: '2-digit' }).format(new Date())
  return parts
}

export const STATUS_LABEL: Record<Status, string> = {
  OVERDUE: tr('Overdue'),
  DUE: tr('Due'),
  ATTENTION: tr('Attention'),
  DUE_SOON: tr('Due soon'),
  INSUFFICIENT_INFO: tr('Not enough info'),
  SNOOZED: tr('Snoozed'),
  OK: 'OK',
  DONE_THIS_CYCLE: tr('Done this cycle'),
  DISABLED: tr('Off'),
  NOT_APPLICABLE: tr('Not for this setup'),
}

export function usageText(u: Usage): string {
  const total = km(u.total_km, 0)
  if (u.certainty === 'ESTIMATED') return `≈ ${total}`
  if (u.is_minimum || u.certainty === 'INCOMPLETE') return `≥ ${total}`
  return total
}

export function certaintyLabel(u: Usage): string {
  switch (u.certainty) {
    case 'ESTIMATED':
      return tr('includes an estimated starting value')
    case 'INCOMPLETE':
      return tr('earlier usage unknown: this is a minimum')
    case 'PARTLY_UNCERTAIN':
      return tr('some rides are uncertain or missing distance')
    default:
      return tr('known')
  }
}

export const slotName = (s: string | null | undefined) => (s ? codeText(s).replace(/^\w/, (c) => c.toUpperCase()) : '')

/** Euro amount from cents; empty for unknown. */
export function euro(cents: number | null | undefined): string {
  if (cents === null || cents === undefined) return ''
  return (cents / 100).toLocaleString(locale, { style: 'currency', currency: 'EUR' })
}

/** "12,50" or "12.50" → 1250; empty → null. */
export function toCents(value: string): number | null {
  const v = value.trim().replace(/\s/g, '').replace(',', '.')
  if (!v) return null
  const n = Number(v)
  return Number.isFinite(n) ? Math.round(n * 100) : NaN
}

export function centsInput(cents: number | null | undefined): string {
  return cents === null || cents === undefined ? '' : (cents / 100).toFixed(2)
}

export function setupLabel(setups: { code: string; label: string }[], code: string | null): string {
  return setups.find((s) => s.code === code)?.label ?? tr('not set')
}
