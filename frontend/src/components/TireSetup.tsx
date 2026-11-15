import { useState } from 'react'
import { api } from '../api'
import { useApp } from '../context'
import type { TireSetup } from '../types'
import { tr } from '../i18n'

// Tube or tubeless is set on the wheel, so it moves with the wheel (wheelset) to another bike.
// The tire and tube on the wheel follow it; the sealant reminder only runs for tubeless.
export function TireSetupSelect({ wheelId, value, onSaved }: { wheelId: number; value: TireSetup | null; onSaved: () => void }) {
  const { meta, toast } = useApp()
  const [busy, setBusy] = useState(false)
  async function save(v: string) {
    setBusy(true)
    try {
      await api.patch(`/components/${wheelId}`, { tire_setup: v || null })
      onSaved()
    } catch (e) {
      toast((e as Error).message)
    } finally {
      setBusy(false)
    }
  }
  return (
    <select aria-label={tr('Tire setup')} className="select-small" disabled={busy} value={value ?? ''} onChange={(e) => save(e.target.value)} onClick={(e) => e.stopPropagation()}>
      <option value="">{tr('tube or tubeless?')}</option>
      {meta.tire_setups.map((s) => (
        <option key={s.code} value={s.code}>
          {s.label}
        </option>
      ))}
    </select>
  )
}

// The pressure you run on a tire, as a free-text note ("4.8 bar"). Shown on the bike page; no reminder.
export function PressureNote({ tireId, value, onSaved }: { tireId: number; value: string | null; onSaved: () => void }) {
  const { toast } = useApp()
  const [editing, setEditing] = useState(false)
  const [text, setText] = useState(value ?? '')
  const [busy, setBusy] = useState(false)
  async function save() {
    setBusy(true)
    try {
      await api.patch(`/components/${tireId}`, { pressure_note: text.trim() || null })
      setEditing(false)
      onSaved()
    } catch (e) {
      toast((e as Error).message)
    } finally {
      setBusy(false)
    }
  }
  if (!editing)
    return (
      <button type="button" className="btn btn-small" title={tr('Tire pressure (note only)')} onClick={() => { setText(value ?? ''); setEditing(true) }}>
        {value ? tr('Pressure: {value}', { value }) : tr('Add pressure')}
      </button>
    )
  return (
    <span className="inline-form">
      <input aria-label={tr('Tire pressure')} className="input-small" maxLength={80} value={text} placeholder={tr('e.g. 4.8 bar')} autoFocus
        onChange={(e) => setText(e.target.value)} onKeyDown={(e) => { if (e.key === 'Enter') save(); if (e.key === 'Escape') setEditing(false) }} />
      <button type="button" className="btn btn-small btn-primary" disabled={busy} onClick={save}>{tr('Save')}</button>
      <button type="button" className="btn btn-small" onClick={() => setEditing(false)}>{tr('Cancel')}</button>
    </span>
  )
}
