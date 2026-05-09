import { useState } from 'react'
import { getContenidoPopularReporte, getIngresos } from '../api/reportes'
import { PageHeader, TabBar, Alert, Input, Button, Table, Tr, Td } from '../components/ui'

export default function Reportes() {
  const [tab, setTab]         = useState('popular')
  const [popular, setPopular] = useState([])
  const [ingresos, setIngresos] = useState([])
  const currentYear = new Date().getFullYear()
  const years = Array.from({ length: 5 }, (_, i) => currentYear - i)
  const meses = [
    { value: '01', label: 'Enero' }, { value: '02', label: 'Febrero' },
    { value: '03', label: 'Marzo' }, { value: '04', label: 'Abril' },
    { value: '05', label: 'Mayo' },  { value: '06', label: 'Junio' },
    { value: '07', label: 'Julio' }, { value: '08', label: 'Agosto' },
    { value: '09', label: 'Septiembre' }, { value: '10', label: 'Octubre' },
    { value: '11', label: 'Noviembre' }, { value: '12', label: 'Diciembre' },
  ]
  const [filtro, setFiltro] = useState({ mes: '', anio: '' })
  const [msg, setMsg]         = useState(null)
  const [loadingP, setLoadingP] = useState(false)
  const [loadingI, setLoadingI] = useState(false)

  const cargarPopular = async () => {
    setLoadingP(true)
    try {
      const r = await getContenidoPopularReporte(10)
      setPopular(r.data)
      setMsg(null)
    } catch {
      setMsg({ type: 'err', text: 'Error al cargar reporte.' })
    } finally { setLoadingP(false) }
  }

  const cargarIngresos = async e => {
    e.preventDefault()
    setLoadingI(true)
    try {
      const r = await getIngresos(filtro.mes || undefined, filtro.anio || undefined)
      setIngresos(r.data)
      setMsg(null)
    } catch {
      setMsg({ type: 'err', text: 'Error al cargar ingresos.' })
    } finally { setLoadingI(false) }
  }

  const tabs = [
    { key: 'popular',  label: 'Contenido popular' },
    { key: 'ingresos', label: 'Ingresos' },
  ]

  return (
    <div className="max-w-screen-xl mx-auto px-6 py-8">
      <PageHeader title="Reportes" subtitle="Analítica y reportes financieros" />
      <TabBar tabs={tabs} active={tab} onChange={t => { setTab(t); setMsg(null) }} />
      <Alert type={msg?.type} message={msg?.text} />

      {/* ── Popular ── */}
      {tab === 'popular' && (
        <div className="space-y-5">
          <Button onClick={cargarPopular} disabled={loadingP}>
            {loadingP ? 'Cargando...' : 'Generar reporte'}
          </Button>

          {popular.length > 0 && (
            <Table headers={['#', 'Título', 'Reproducciones', 'Calificación promedio']}>
              {popular.map((c, i) => (
                <Tr key={c.idContenido}>
                  <Td muted>{i + 1}</Td>
                  <Td><span className="font-semibold text-white">{c.titulo}</span></Td>
                  <Td muted>{c.totalReproducciones?.toLocaleString()}</Td>
                  <Td>
                    <span className="text-amber-400 font-semibold">
                      ★ {c.calificacionPromedio ? c.calificacionPromedio.toFixed(1) : '—'}
                    </span>
                  </Td>
                </Tr>
              ))}
            </Table>
          )}
        </div>
      )}

      {/* ── Ingresos ── */}
      {tab === 'ingresos' && (
        <div className="space-y-5">
          <form onSubmit={cargarIngresos} className="flex flex-wrap gap-3 items-end">
            <div className="w-44">
              <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-1.5">Mes</label>
              <select
                value={filtro.mes}
                onChange={e => setFiltro({ ...filtro, mes: e.target.value })}
                className="w-full bg-gray-800/60 border border-white/10 focus:border-brand-500/60
                           rounded-xl px-4 py-2.5 text-sm text-white focus:outline-none
                           focus:ring-2 focus:ring-brand-500/20 transition"
              >
                <option value="">Todos los meses</option>
                {meses.map(m => <option key={m.value} value={m.value}>{m.label}</option>)}
              </select>
            </div>
            <div className="w-36">
              <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-1.5">Año</label>
              <select
                value={filtro.anio}
                onChange={e => setFiltro({ ...filtro, anio: e.target.value })}
                className="w-full bg-gray-800/60 border border-white/10 focus:border-brand-500/60
                           rounded-xl px-4 py-2.5 text-sm text-white focus:outline-none
                           focus:ring-2 focus:ring-brand-500/20 transition"
              >
                <option value="">Todos los años</option>
                {years.map(y => <option key={y} value={y}>{y}</option>)}
              </select>
            </div>
            <Button type="submit" disabled={loadingI}>
              {loadingI ? 'Cargando...' : 'Consultar'}
            </Button>
          </form>

          {ingresos.length > 0 && (
            <>
              {/* Resumen */}
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                {['Básico', 'Estándar', 'Premium'].map(plan => {
                  const total = ingresos
                    .filter(r => r.plan === plan)
                    .reduce((s, r) => s + (r.totalIngresos ?? 0), 0)
                  return total > 0 ? (
                    <div key={plan} className="bg-gray-800/40 border border-white/5 rounded-xl p-4">
                      <p className="text-xs text-gray-500 font-semibold uppercase tracking-wider">{plan}</p>
                      <p className="text-xl font-black text-white mt-1">${total.toLocaleString('es-CO')}</p>
                    </div>
                  ) : null
                })}
                <div className="bg-brand-500/10 border border-brand-500/20 rounded-xl p-4">
                  <p className="text-xs text-brand-400 font-semibold uppercase tracking-wider">Total</p>
                  <p className="text-xl font-black text-white mt-1">
                    ${ingresos.reduce((s, r) => s + (r.totalIngresos ?? 0), 0).toLocaleString('es-CO')}
                  </p>
                </div>
              </div>

              <Table headers={['Ciudad', 'Plan', 'Mes', 'Año', 'Total ingresos']}>
                {ingresos.map((r, i) => (
                  <Tr key={i}>
                    <Td><span className="font-medium text-white">{r.ciudad}</span></Td>
                    <Td muted>{r.plan}</Td>
                    <Td muted>{r.mes}</Td>
                    <Td muted>{r.anio}</Td>
                    <Td>
                      <span className="font-semibold text-emerald-400">
                        ${r.totalIngresos?.toLocaleString('es-CO')}
                      </span>
                    </Td>
                  </Tr>
                ))}
              </Table>
            </>
          )}
        </div>
      )}
    </div>
  )
}
