// Languages of the screens. The English text in the code is the key; locales/de.json maps it to German.
// A text without a translation is shown in English, never as an error.
//
//   tr('Bikes')                              → "Räder" in German
//   tr('Every {km} km', { km: 300 })         → placeholders in {braces}, filled after translating
//   trn('{n} ride', '{n} rides', n)          → singular or plural, then translated ({n} is filled in)
//
// The language is a setting (Settings → Language, stored in the database). The backend writes it into the
// page (<meta name="bikelog-lang">), so it is known before the first screen is drawn; changing it reloads the
// page. Texts that come from the backend (reminder explanations, messages) are translated by the backend.
import de from './locales/de.json'

export type Lang = 'en' | 'de'
export const LANGS: { code: Lang; name: string }[] = [
  { code: 'en', name: 'English' },
  { code: 'de', name: 'Deutsch' },
]
const STORE = 'bikelog-lang'

function detect(): Lang {
  let v: string | null | undefined
  try {
    v = document.querySelector('meta[name="bikelog-lang"]')?.getAttribute('content')
  } catch {
    v = null
  }
  if (v !== 'en' && v !== 'de') {
    // the page was not served by the backend (vite dev server): remember the last choice in this browser
    try {
      v = localStorage.getItem(STORE)
    } catch {
      v = null
    }
  }
  return v === 'de' ? 'de' : 'en'
}

export const lang: Lang = detect()
try {
  document.documentElement.lang = lang       // screen readers and hyphenation
} catch {
  /* no document (tests) */
}
/** Locale for numbers and dates: German formats in German; the system's own otherwise (as before). */
export const locale: string | undefined = lang === 'de' ? 'de-DE' : undefined

const dict: Record<string, string> = lang === 'de' ? (de as Record<string, string>) : {}

export function tr(text: string, vars?: Record<string, unknown>): string {
  let out = dict[text] ?? text
  if (vars) {
    for (const [k, v] of Object.entries(vars)) out = out.split(`{${k}}`).join(v === null || v === undefined ? '' : String(v))
  }
  return out
}

/** Singular or plural, then translated. {n} is filled in with the count. */
export function trn(one: string, many: string, n: number, vars?: Record<string, unknown>): string {
  return tr(Math.abs(n) === 1 ? one : many, { n, ...vars })
}

/** After saving a new language: remember it in this browser too and draw every screen again. */
export function switchLanguage(to: Lang) {
  try {
    localStorage.setItem(STORE, to)
  } catch {
    /* private mode: the page from the backend still carries the language */
  }
  window.location.reload()
}

/** The language the backend says is saved; reload once if this page was drawn in another one (dev server). */
export function checkLanguage(saved: string | undefined) {
  if ((saved === 'en' || saved === 'de') && saved !== lang) {
    try {
      if (sessionStorage.getItem('bikelog-lang-reloaded') === saved) return
      sessionStorage.setItem('bikelog-lang-reloaded', saved)
    } catch {
      return
    }
    switchLanguage(saved)
  }
}

/** Lower-case a name used inside a sentence ("a chain"). German nouns keep their capital letter. */
export function lc(s: string | null | undefined): string {
  if (!s) return ''
  return lang === 'de' ? s : s.toLowerCase()
}

/** A code from the backend shown as words: WORN_LIMIT → "worn limit" (German from the "code:WORN_LIMIT" entry). */
export function codeText(code: string | null | undefined): string {
  if (!code) return ''
  const own = dict['code:' + code]
  return own ?? code.replace(/_/g, ' ').toLowerCase()
}

/** A stock unit for a count: "1 tube", "2 tubes" ("plural:<unit>" entries give the German plural). */
export function unitWord(unit: string | null | undefined, n: number): string {
  const u = unit ?? ''
  if (lang === 'en') return n === 1 || /s$/.test(u) ? u : `${u}${/(ch|sh|x)$/.test(u) ? 'es' : 's'}`
  return n === 1 ? (dict['unit:' + u] ?? dict[u] ?? u) : (dict['plural:' + u] ?? dict['unit:' + u] ?? dict[u] ?? u)
}
