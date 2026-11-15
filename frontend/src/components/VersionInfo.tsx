import { useApp } from '../context'
import { versionProblem } from '../version'
import { tr } from '../i18n'

export default function VersionInfo() {
  const { meta } = useApp()
  const problem = versionProblem(meta)
  return (
    <>
      {problem && (
        <p className="form-error" role="alert">
          {problem}
        </p>
      )}
      <p className="small muted">
        <strong>{tr('Bike Log')} {meta.full_version}</strong>
        {meta.release ? tr(' (release)') : tr(' (build between releases; the part after + is the commit)')} {tr('· database schema')} {meta.schema} {tr('· app commit')} <code>{meta.commit}</code> {tr('· screens commit')} <code>{meta.ui_commit}</code>
      </p>
    </>
  )
}
