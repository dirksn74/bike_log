import { useCallback, useEffect, useState } from 'react'
import { versionProblem } from './version'
import { HashRouter, Link, NavLink, Route, Routes } from 'react-router-dom'
import Breadcrumbs from './components/Breadcrumbs'
import { ErrorBox, Loading } from './components/ui'
import { Ctx } from './context'
import { setTimezone } from './format'
import { useApi } from './hooks'
import { BikeDetailPage, BikesPage } from './pages/Bikes'
import { GroupsetPage } from './pages/Groupset'
import InventoryPage, { ComponentDetailPage } from './pages/Inventory'
import MaintenancePage from './pages/Maintenance'
import OverviewPage from './pages/Overview'
import RidesPage from './pages/Rides'
import SettingsPage from './pages/Settings'
import type { Meta } from './types'
import { tr, checkLanguage } from './i18n'

const NAV = [
  ['/', tr('Overview'), '◎'],
  ['/bikes', tr('Bikes'), '🚲'],
  ['/maintenance', tr('Maintenance'), '🔧'],
  ['/rides', tr('Rides'), '↗'],
  ['/inventory', tr('Inventory'), '▤'],
  ['/settings', tr('Settings'), '⚙'],
] as const

export default function App() {
  const meta = useApi<Meta>('/meta')
  const [toastMsg, setToastMsg] = useState<string | null>(null)
  const toast = useCallback((m: string) => setToastMsg(m), [])
  useEffect(() => {
    if (!toastMsg) return
    const t = setTimeout(() => setToastMsg(null), 5000)
    return () => clearTimeout(t)
  }, [toastMsg])
  useEffect(() => {
    if (meta.data) setTimezone(meta.data.settings.timezone)
    if (meta.data) checkLanguage(meta.data.settings.language)
  }, [meta.data])

  if (meta.loading && !meta.data)
    return (
      <div className="boot">
        <Loading what={tr('Starting Bike Log')} />
      </div>
    )
  if (!meta.data)
    return (
      <div className="boot">
        <ErrorBox error={meta.error ?? tr('No data')} onRetry={meta.reload} />
      </div>
    )
  return (
    <Ctx.Provider value={{ meta: meta.data, reloadMeta: meta.reload, toast }}>
      <HashRouter>
        <div className="shell">
          <header className="topbar">
            <div className="topbar-inner">
              <Link to="/" className="brand" aria-label={tr('Bike Log, overview')}>
                <img src="./logo.svg" alt="" width={32} height={32} />
                <span>{tr('Bike Log')}</span>
              </Link>
              <nav aria-label={tr('Main')}>
                {NAV.map(([to, label, icon]) => (
                  <NavLink key={to} to={to} end={to === '/'} className={({ isActive }) => `navlink ${isActive ? 'active' : ''}`}>
                    <span className="navicon" aria-hidden>
                      {icon}
                    </span>
                    <span className="navlabel">{label}</span>
                  </NavLink>
                ))}
              </nav>
              <span className="brand-version" title={tr('Bike Log {full_version}', { full_version: meta.data.full_version })}>
                v{meta.data.full_version}
              </span>
            </div>
          </header>
          <main className="main">
            {versionProblem(meta.data) && (
              <div className="demo-banner version-banner" role="alert">
                {versionProblem(meta.data)}
              </div>
            )}
            {meta.data.demo && <div className="demo-banner">{tr('Demo mode: sample data in a separate demo database. Your own data is not touched.')}</div>}
            {meta.data.sample && !meta.data.demo && (
              <div className="demo-banner" role="status">
                <strong>{tr('Sample data.')}</strong> {tr('These two bikes, their rides and incidents are made up so you can look around. Ready for your own bikes?')}{' '}
                <Link to="/settings?section=fresh-start">{tr('Settings → Fresh start')}</Link> {tr('removes all of it.')}
              </div>
            )}
            <Breadcrumbs />
            <Routes>
              <Route path="/" element={<OverviewPage />} />
              <Route path="/bikes" element={<BikesPage />} />
              <Route path="/bikes/:id" element={<BikeDetailPage />} />
              <Route path="/bikes/:id/groupset" element={<GroupsetPage />} />
              <Route path="/maintenance" element={<MaintenancePage />} />
              <Route path="/rides" element={<RidesPage />} />
              <Route path="/inventory" element={<InventoryPage />} />
              <Route path="/inventory/:id" element={<ComponentDetailPage />} />
              <Route path="/settings" element={<SettingsPage />} />
              <Route path="*" element={<p>{tr('Page not found.')}</p>} />
            </Routes>
          </main>
        </div>
        {toastMsg && (
          <div className="toast" role="status" onClick={() => setToastMsg(null)}>
            {toastMsg}
          </div>
        )}
      </HashRouter>
    </Ctx.Provider>
  )
}
