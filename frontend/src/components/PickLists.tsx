import { useState } from 'react'
import { api } from '../api'
import { useApp } from '../context'
import { useApi } from '../hooks'
import { Card, ErrorBox, FormError, Loading, Tag } from './ui'
import { tr, lc } from '../i18n'

interface Item {
  id: number
  name: string
  hidden: boolean
  merged_into: string | null
  uses: number
}

interface PickList {
  code: string
  name: string
  hint: string
  items: Item[]
}

// Settings → Lists (DECISIONS 106): the names offered in dropdowns, e.g. shops. Add, rename (every record
// using the name follows), merge duplicates, hide. Nothing is deleted.
export default function PickLists() {
  const { data, error, loading, reload } = useApi<PickList[]>('/lists')
  return (
    <Card title={tr('Lists')} className="span-2">
      <p className="small muted">{tr('The names you pick from dropdowns. A name you type in a form is added here when you save. Renaming changes it on every record that uses it; Merge makes two entries one (for a typo or a second spelling); Hide takes a name out of the dropdowns, records keep it.')}</p>
      {loading && !data && <Loading />}
      {error && <ErrorBox error={error} onRetry={reload} />}
      {data?.map((l) => <ListEditor key={l.code} list={l} onChanged={reload} />)}
    </Card>
  )
}

function ListEditor({ list, onChanged }: { list: PickList; onChanged: () => void }) {
  const { toast } = useApp()
  const [add, setAdd] = useState('')
  const [edit, setEdit] = useState<{ id: number; name: string } | null>(null)
  const [merge, setMerge] = useState<{ id: number; into: string } | null>(null)
  const [err, setErr] = useState<string | null>(null)
  const live = list.items.filter((i) => !i.merged_into)
  const merged = list.items.filter((i) => i.merged_into)
  async function run(fn: () => Promise<unknown>, msg: string) {
    setErr(null)
    try {
      await fn()
      toast(msg)
      setEdit(null)
      setMerge(null)
      onChanged()
    } catch (e) {
      setErr((e as Error).message)
    }
  }
  return (
    <details className="pick-list" data-list={list.code} open>
      <summary>
        <strong>{list.name}</strong> <span className="muted small">{live.filter((i) => !i.hidden).length} {tr('in the dropdowns ·')} {list.hint}</span>
      </summary>
      <FormError error={err} form={false} />
      {live.length === 0 && <p className="small muted">{tr('Nothing yet.')}</p>}
      <ul className="list rows">
        {live.map((i) => (
          <li key={i.id} data-item={i.name}>
            {edit?.id === i.id ? (
              <>
                <input aria-label={tr('New name for {name}', { name: i.name })} value={edit.name} onChange={(e) => setEdit({ id: i.id, name: e.target.value })} autoFocus />
                <span className="row-actions">
                  <button className="btn btn-small btn-primary" disabled={!edit.name.trim()} onClick={() => run(() => api.patch(`/lists/items/${i.id}`, { name: edit.name }), tr('Renamed to {trim}{x}.', { trim: edit.name.trim(), x: i.uses ? tr(' on {uses} record{x}', { uses: i.uses, x: i.uses === 1 ? '' : 's' }) : '' }))}>
                    {tr('Save')}
                  </button>
                  <button className="btn btn-small" onClick={() => setEdit(null)}>
                    {tr('Cancel')}
                  </button>
                </span>
              </>
            ) : merge?.id === i.id ? (
              <>
                <span>
                  {tr('Merge {name} into', { name: i.name })}
                </span>
                <select aria-label={tr('Merge {name} into', { name: i.name })} value={merge.into} onChange={(e) => setMerge({ id: i.id, into: e.target.value })}>
                  <option value="">{tr('Choose…')}</option>
                  {live
                    .filter((o) => o.id !== i.id)
                    .map((o) => (
                      <option key={o.id} value={o.id}>
                        {o.name}
                      </option>
                    ))}
                </select>
                <span className="row-actions">
                  <button className="btn btn-small btn-primary" disabled={!merge.into} onClick={() => run(() => api.post(`/lists/items/${i.id}/merge`, { into_id: Number(merge.into) }), `${i.name} merged.`)}>
                    {tr('Merge')}
                  </button>
                  <button className="btn btn-small" onClick={() => setMerge(null)}>
                    {tr('Cancel')}
                  </button>
                </span>
              </>
            ) : (
              <>
                <span>{i.name}</span>
                <span className="small muted">
                  {i.uses ? tr('used {uses}×', { uses: i.uses }) : tr('not used yet')}
                </span>
                {i.hidden && <Tag>{tr('hidden')}</Tag>}
                <span className="row-actions">
                  <button className="btn btn-small" onClick={() => setEdit({ id: i.id, name: i.name })}>
                    {tr('Rename')}
                  </button>
                  {live.length > 1 && (
                    <button className="btn btn-small" onClick={() => setMerge({ id: i.id, into: '' })}>
                      {tr('Merge')}
                    </button>
                  )}
                  <button className="btn btn-small" onClick={() => run(() => api.patch(`/lists/items/${i.id}`, { hidden: !i.hidden }), i.hidden ? tr('{name} is back in the dropdowns.', { name: i.name }) : tr('{name} hidden from the dropdowns.', { name: i.name }))}>
                    {i.hidden ? tr('Show') : tr('Hide')}
                  </button>
                </span>
              </>
            )}
          </li>
        ))}
      </ul>
      {merged.length > 0 && <p className="small muted">{tr('Merged:')} {merged.map((i) => `${i.name} → ${i.merged_into}`).join(' · ')}</p>}
      <div className="inline-add">
        <input aria-label={tr('Add to {name}', { name: list.name })} placeholder={tr('Add to {toLowerCase}…', { toLowerCase: lc(list.name) })} value={add} onChange={(e) => setAdd(e.target.value)} />
        <button className="btn btn-small" disabled={!add.trim()} onClick={() => run(() => api.post(`/lists/${list.code}`, { name: add }).then(() => setAdd('')), `${add.trim()} added.`)}>
          {tr('Add')}
        </button>
      </div>
    </details>
  )
}
