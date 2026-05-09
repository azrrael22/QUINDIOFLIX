import { useEffect, useState } from 'react'
import { getUsuarios, registrarUsuario, cambiarPlan } from '../api/usuarios'
import { PageHeader, TabBar, Alert, Input, Select, Button, Table, Tr, Td, Badge } from '../components/ui'

const PLANES = [
  { id: 1, nombre: 'Básico — $14.900/mes' },
  { id: 2, nombre: 'Estándar — $24.900/mes' },
  { id: 3, nombre: 'Premium — $34.900/mes' },
]

export default function Usuarios() {
  const [usuarios, setUsuarios] = useState([])
  const [loading, setLoading]   = useState(true)
  const [tab, setTab]           = useState('lista')
  const [msg, setMsg]           = useState(null)
  const [form, setForm] = useState({
    nombre: '', apellido: '', email: '', telefono: '',
    fechaNacimiento: '', ciudad: '', idPlan: 1, metodoPago: 'PSE',
  })
  const [planForm, setPlanForm] = useState({ idUsuario: '', idNuevoPlan: 1 })

  const cargar = () => {
    setLoading(true)
    getUsuarios().then(r => setUsuarios(r.data)).finally(() => setLoading(false))
  }
  useEffect(() => { cargar() }, [])

  const handleRegistrar = async e => {
    e.preventDefault()
    try {
      await registrarUsuario(form)
      setMsg({ type: 'ok', text: 'Usuario registrado correctamente.' })
      cargar()
    } catch (err) {
      setMsg({ type: 'err', text: err.response?.data?.message ?? 'Error al registrar.' })
    }
  }

  const handleCambiarPlan = async e => {
    e.preventDefault()
    try {
      await cambiarPlan(planForm)
      setMsg({ type: 'ok', text: 'Plan actualizado correctamente.' })
      cargar()
    } catch (err) {
      setMsg({ type: 'err', text: err.response?.data?.message ?? 'Error al cambiar plan.' })
    }
  }

  const tabs = [
    { key: 'lista', label: 'Lista de usuarios' },
    { key: 'registrar', label: 'Registrar' },
    { key: 'cambiarPlan', label: 'Cambiar plan' },
  ]

  return (
    <div className="max-w-screen-xl mx-auto px-6 py-8">
      <PageHeader title="Usuarios" subtitle="Gestión de cuentas y suscripciones" />
      <TabBar tabs={tabs} active={tab} onChange={t => { setTab(t); setMsg(null) }} />
      <Alert type={msg?.type} message={msg?.text} />

      {/* ── Lista ── */}
      {tab === 'lista' && (
        loading
          ? <div className="flex justify-center py-16"><div className="w-8 h-8 border-[3px] border-brand-500 border-t-transparent rounded-full animate-spin" /></div>
          : (
            <Table
              headers={['Nombre', 'Email', 'Ciudad', 'Plan', 'Estado', 'Último pago']}
              empty={usuarios.length === 0 ? 'No hay usuarios registrados.' : null}
            >
              {usuarios.map(u => (
                <Tr key={u.idUsuario}>
                  <Td>
                    <div>
                      <p className="font-semibold text-white">{u.nombre} {u.apellido}</p>
                    </div>
                  </Td>
                  <Td muted>{u.email}</Td>
                  <Td muted>{u.ciudad}</Td>
                  <Td>
                    <Badge color="purple">{u.plan}</Badge>
                  </Td>
                  <Td>
                    <Badge color={u.estadoCuenta === 'ACTIVO' ? 'green' : 'red'}>
                      {u.estadoCuenta}
                    </Badge>
                  </Td>
                  <Td muted>{u.fechaUltimoPago ?? '—'}</Td>
                </Tr>
              ))}
            </Table>
          )
      )}

      {/* ── Registrar ── */}
      {tab === 'registrar' && (
        <form onSubmit={handleRegistrar} className="max-w-lg bg-gray-800/40 border border-white/5 rounded-2xl p-6 space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <Input label="Nombre" type="text" value={form.nombre} onChange={e => setForm({...form, nombre: e.target.value})} required />
            <Input label="Apellido" type="text" value={form.apellido} onChange={e => setForm({...form, apellido: e.target.value})} required />
          </div>
          <Input label="Email" type="email" value={form.email} onChange={e => setForm({...form, email: e.target.value})} required />
          <div className="grid grid-cols-2 gap-4">
            <Input label="Teléfono" type="text" value={form.telefono} onChange={e => setForm({...form, telefono: e.target.value})} required />
            <Input label="Fecha de nacimiento" type="date" value={form.fechaNacimiento} onChange={e => setForm({...form, fechaNacimiento: e.target.value})} required />
          </div>
          <Input label="Ciudad" type="text" value={form.ciudad} onChange={e => setForm({...form, ciudad: e.target.value})} required />
          <div className="grid grid-cols-2 gap-4">
            <Select label="Plan" value={form.idPlan} onChange={e => setForm({...form, idPlan: Number(e.target.value)})}>
              {PLANES.map(p => <option key={p.id} value={p.id}>{p.nombre}</option>)}
            </Select>
            <Select label="Método de pago" value={form.metodoPago} onChange={e => setForm({...form, metodoPago: e.target.value})}>
              {['PSE','NEQUI','DAVIPLATA','TARJETA_CREDITO','TARJETA_DEBITO'].map(m => <option key={m}>{m}</option>)}
            </Select>
          </div>
          <div className="pt-2">
            <Button type="submit">Registrar usuario</Button>
          </div>
        </form>
      )}

      {/* ── Cambiar plan ── */}
      {tab === 'cambiarPlan' && (
        <form onSubmit={handleCambiarPlan} className="max-w-sm bg-gray-800/40 border border-white/5 rounded-2xl p-6 space-y-4">
          <Input label="ID de usuario" type="number" value={planForm.idUsuario}
            onChange={e => setPlanForm({...planForm, idUsuario: Number(e.target.value)})} required />
          <Select label="Nuevo plan" value={planForm.idNuevoPlan}
            onChange={e => setPlanForm({...planForm, idNuevoPlan: Number(e.target.value)})}>
            {PLANES.map(p => <option key={p.id} value={p.id}>{p.nombre}</option>)}
          </Select>
          <div className="pt-2">
            <Button type="submit">Actualizar plan</Button>
          </div>
        </form>
      )}
    </div>
  )
}
