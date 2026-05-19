import { useState, useRef } from 'react'
import { registrarPago, getHistorialPagos } from '../api/pagos'
import { getInfoPago } from '../api/demo'
import { PageHeader, TabBar, Alert, Input, Select, Button, Table, Tr, Td, Badge } from '../components/ui'

const METODOS = ['PSE', 'NEQUI', 'DAVIPLATA', 'TARJETA_CREDITO', 'TARJETA_DEBITO']

const ESTADO_COLOR = {
  'EXITOSO':     'green',
  'FALLIDO':     'red',
  'PENDIENTE':   'yellow',
  'REEMBOLSADO': 'gray',
}

export default function Pagos() {
  const [tab, setTab]     = useState('registrar')
  const [msg, setMsg]     = useState(null)
  const [form, setForm]   = useState({ idUsuario: '', monto: '', metodoPago: 'PSE' })
  const [infoUsuario, setInfoUsuario] = useState(null)  // { usuario, plan, precio_base, monto_a_cobrar }
  const [loadingInfo, setLoadingInfo] = useState(false)
  const [historialId, setHistorialId] = useState('')
  const [historial, setHistorial]     = useState([])
  const debounceRef = useRef(null)

  // Al cambiar el ID de usuario, busca automáticamente plan y monto
  const handleIdChange = (e) => {
    const val = e.target.value
    setForm(f => ({ ...f, idUsuario: val, monto: '' }))
    setInfoUsuario(null)

    if (debounceRef.current) clearTimeout(debounceRef.current)
    if (!val || isNaN(val)) return

    debounceRef.current = setTimeout(async () => {
      setLoadingInfo(true)
      try {
        const res = await getInfoPago(val)
        const data = res.data
        setInfoUsuario(data)
        // Prellenar el monto con el calculado por FN_CALCULAR_MONTO
        setForm(f => ({ ...f, monto: data.MONTO_A_COBRAR ?? data.monto_a_cobrar ?? '' }))
      } catch {
        setInfoUsuario(null)
      } finally {
        setLoadingInfo(false)
      }
    }, 600)
  }

  const handleRegistrar = async e => {
    e.preventDefault()
    try {
      await registrarPago({
        idUsuario: Number(form.idUsuario),
        monto: Number(form.monto),
        metodoPago: form.metodoPago,
      })
      setMsg({ type: 'ok', text: 'Pago registrado correctamente.' })
      setForm({ idUsuario: '', monto: '', metodoPago: 'PSE' })
      setInfoUsuario(null)
    } catch (err) {
      setMsg({ type: 'err', text: err.response?.data?.message ?? 'Error al registrar pago.' })
    }
  }

  const handleHistorial = async e => {
    e.preventDefault()
    try {
      const r = await getHistorialPagos(historialId)
      setHistorial(r.data)
      setMsg(null)
    } catch {
      setMsg({ type: 'err', text: 'No se encontró historial para ese usuario.' })
    }
  }

  const tabs = [
    { key: 'registrar', label: 'Registrar pago' },
    { key: 'historial', label: 'Historial' },
  ]

  // Normaliza claves que Oracle puede devolver en mayúsculas o minúsculas
  const get = (obj, key) => obj?.[key] ?? obj?.[key.toUpperCase()] ?? obj?.[key.toLowerCase()]

  return (
    <div className="max-w-screen-xl mx-auto px-6 py-8">
      <PageHeader title="Pagos" subtitle="Registro e historial de pagos" />
      <TabBar tabs={tabs} active={tab} onChange={t => { setTab(t); setMsg(null) }} />
      <Alert type={msg?.type} message={msg?.text} />

      {/* ── Registrar ── */}
      {tab === 'registrar' && (
        <form onSubmit={handleRegistrar} className="max-w-md space-y-4">

          {/* ID Usuario con lookup automático */}
          <div>
            <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-1.5">
              ID de usuario
            </label>
            <div className="relative">
              <input
                type="number"
                value={form.idUsuario}
                onChange={handleIdChange}
                placeholder="Ingresa el ID del usuario..."
                required
                className="w-full bg-gray-800/60 border border-white/10 focus:border-brand-500/60
                           rounded-xl px-4 py-2.5 text-sm text-white placeholder-gray-600
                           focus:outline-none focus:ring-2 focus:ring-brand-500/20 transition"
              />
              {loadingInfo && (
                <div className="absolute right-3 top-1/2 -translate-y-1/2">
                  <div className="w-4 h-4 border-2 border-brand-500 border-t-transparent rounded-full animate-spin" />
                </div>
              )}
            </div>
          </div>

          {/* Card de info del usuario — aparece automáticamente */}
          {infoUsuario && (
            <div className="bg-brand-500/10 border border-brand-500/20 rounded-xl p-4 space-y-2">
              <div className="flex items-center gap-2">
                <span className="text-brand-400 text-sm">✓</span>
                <p className="text-sm font-bold text-white">
                  {get(infoUsuario, 'usuario')}
                </p>
              </div>
              <div className="grid grid-cols-2 gap-3 mt-2">
                <div className="bg-gray-900/60 rounded-lg p-3">
                  <p className="text-xs text-gray-500 uppercase tracking-wider mb-0.5">Plan</p>
                  <p className="text-sm font-semibold text-white">{get(infoUsuario, 'plan')}</p>
                </div>
                <div className="bg-gray-900/60 rounded-lg p-3">
                  <p className="text-xs text-gray-500 uppercase tracking-wider mb-0.5">Precio base</p>
                  <p className="text-sm font-semibold text-white">
                    ${Number(get(infoUsuario, 'precio_base')).toLocaleString('es-CO')}
                  </p>
                </div>
              </div>
              <div className="bg-emerald-500/10 border border-emerald-500/20 rounded-lg p-3">
                <p className="text-xs text-emerald-400 uppercase tracking-wider mb-0.5">Monto a cobrar (con descuentos)</p>
                <p className="text-xl font-black text-white">
                  ${Number(get(infoUsuario, 'monto_a_cobrar')).toLocaleString('es-CO')}
                </p>
              </div>
            </div>
          )}

          {/* Monto editable (prellenado automáticamente) */}
          <div>
            <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-1.5">
              Monto a pagar
            </label>
            <input
              type="number"
              value={form.monto}
              onChange={e => setForm(f => ({ ...f, monto: e.target.value }))}
              placeholder="Se llena automáticamente..."
              required
              className="w-full bg-gray-800/60 border border-white/10 focus:border-brand-500/60
                         rounded-xl px-4 py-2.5 text-sm text-white placeholder-gray-600
                         focus:outline-none focus:ring-2 focus:ring-brand-500/20 transition"
            />
          </div>

          <Select
            label="Método de pago"
            value={form.metodoPago}
            onChange={e => setForm(f => ({ ...f, metodoPago: e.target.value }))}
          >
            {METODOS.map(m => <option key={m}>{m}</option>)}
          </Select>

          <div className="pt-1">
            <Button type="submit" disabled={!form.idUsuario || !form.monto}>
              Registrar pago
            </Button>
          </div>
        </form>
      )}

      {/* ── Historial ── */}
      {tab === 'historial' && (
        <div className="space-y-5">
          <form onSubmit={handleHistorial} className="flex gap-3 max-w-sm">
            <Input
              label=""
              type="number"
              placeholder="ID de usuario"
              value={historialId}
              onChange={e => setHistorialId(e.target.value)}
              required
            />
            <div className="flex items-end">
              <Button type="submit">Buscar</Button>
            </div>
          </form>

          {historial.length > 0 && (
            <Table headers={['Fecha', 'Monto', 'Descuento', 'Método', 'Estado']}>
              {historial.map((p, i) => (
                <Tr key={i}>
                  <Td muted>{p.fechaPago}</Td>
                  <Td><span className="font-semibold text-white">${p.monto?.toLocaleString('es-CO')}</span></Td>
                  <Td muted>{p.descuentoAplicado ? `$${p.descuentoAplicado.toLocaleString('es-CO')}` : '—'}</Td>
                  <Td muted>{p.metodoPago}</Td>
                  <Td>
                    <Badge color={ESTADO_COLOR[p.estadoPago] ?? 'gray'}>{p.estadoPago}</Badge>
                  </Td>
                </Tr>
              ))}
            </Table>
          )}
        </div>
      )}
    </div>
  )
}
