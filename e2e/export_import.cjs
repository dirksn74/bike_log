// End-to-end: Settings → Full export (downloads a zip) → Import a full export (check, then replace) against
// the real running app. Usage: node e2e/export_import.cjs http://127.0.0.1:8790/ <screenshot-dir>
const { chromium } = require('playwright')
const fs = require('fs')
const path = require('path')

const BASE = process.argv[2] || 'http://127.0.0.1:8790/'
const OUT = process.argv[3] || 'e2e-out'
fs.mkdirSync(OUT, { recursive: true })
let failed = 0
function check(name, ok, info = '') {
  if (!ok) failed++
  console.log(`${ok ? 'PASS' : 'FAIL'}  ${name}${info ? ' — ' + info : ''}`)
}

;(async () => {
  const browser = await chromium.launch()
  const page = await browser.newPage({ viewport: { width: 1280, height: 900 }, acceptDownloads: true })
  page.on('dialog', (d) => d.accept())
  await page.goto(BASE + '#/settings')
  await page.getByRole('button', { name: 'Full export (zip)' }).waitFor()
  const before = await page.evaluate(async () => (await (await fetch('./api/bikes')).json()).length)

  const [download] = await Promise.all([page.waitForEvent('download'), page.getByRole('button', { name: 'Full export (zip)' }).click()])
  const zip = path.join(OUT, download.suggestedFilename())
  await download.saveAs(zip)
  check('full export downloads a zip', /bikelog-export-.*\.zip$/.test(zip) && fs.statSync(zip).size > 1000, zip)

  // change something after the export, then import the export: the change is gone again
  const token = await page.evaluate(() => window.__BIKELOG_TOKEN__ || document.querySelector('meta[name="bikelog-token"]')?.content || '')
  await page.evaluate(async (t) => {
    await fetch('./api/bikes', { method: 'POST', headers: { 'Content-Type': 'application/json', 'X-BikeLog-Token': t }, body: JSON.stringify({ name: 'Added after export' }) })
  }, token)
  await page.reload()
  await page.getByText('Import a full export').click()
  await page.getByLabel('Export file').setInputFiles(zip)
  await page.getByRole('button', { name: 'Check file' }).click()
  await page.getByText('The file is fine.').waitFor()
  await page.screenshot({ path: path.join(OUT, 'import-check.png') })
  check('check shows what is in the file', await page.getByText(/It holds \d+ bikes/).isVisible())
  await page.getByRole('button', { name: 'Replace all my data with this export' }).click()
  await page.getByText(/Export imported/).waitFor()
  await page.screenshot({ path: path.join(OUT, 'import-done.png') })
  const after = await page.evaluate(async () => (await (await fetch('./api/bikes')).json()).map((b) => b.name))
  check('import puts the exported data back', after.length === before && !after.includes('Added after export'), after.join(', '))
  await browser.close()
  console.log(failed ? `${failed} failed` : 'all passed')
  process.exit(failed ? 1 : 0)
})()
