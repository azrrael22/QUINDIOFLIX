import { useState } from 'react'
import * as demoApi from '../api/demo'

/* ─── Componente: tabla de resultados dinámica ─── */
function ResultTable({ data }) {
  if (!data || data.length === 0)
    return <p className="text-xs text-gray-500 italic px-1">Sin resultados.</p>

  const cols = Object.keys(data[0])
  return (
    <div className="overflow-x-auto rounded-xl border border-white/10 mt-3">
      <table className="w-full text-xs">
        <thead>
          <tr className="bg-white/5 border-b border-white/10">
            {cols.map(c => (
              <th key={c} className="text-left px-3 py-2 font-semibold text-gray-400 uppercase tracking-wider whitespace-nowrap">
                {c}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {data.map((row, i) => (
            <tr key={i} className="border-b border-white/5 last:border-0 hover:bg-white/[0.02]">
              {cols.map(c => (
                <td key={c} className="px-3 py-2 text-gray-300 whitespace-nowrap">
                  {row[c] != null ? String(row[c]) : '—'}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
      <p className="text-[10px] text-gray-600 px-3 py-1.5">{data.length} fila(s)</p>
    </div>
  )
}

/* ─── Componente: sección ejecutable ─── */
function DemoSection({ titulo, badge, color, items }) {
  const c = COLOR_MAP[color]
  return (
    <div className="bg-gray-800/40 border border-white/5 rounded-xl overflow-hidden">
      <div className="flex items-center justify-between px-5 py-3.5 border-b border-white/5">
        <h3 className="text-sm font-bold text-white">{titulo}</h3>
        <span className={`text-xs font-semibold px-2.5 py-0.5 rounded-full ring-1 ${c.badge}`}>
          {badge}
        </span>
      </div>
      <div className="divide-y divide-white/5">
        {items.map((item, i) => <DemoItem key={i} item={item} color={color} />)}
      </div>
    </div>
  )
}

/* ─── Componente: ítem con botón ejecutar ─── */
function DemoItem({ item, color }) {
  const [result, setResult]   = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError]     = useState(null)
  const [params, setParams]   = useState(item.defaultParams ?? {})
  const c = COLOR_MAP[color]

  const ejecutar = async () => {
    setLoading(true)
    setError(null)
    try {
      const res = await item.fn(params)
      setResult(res.data)
    } catch (e) {
      setError(e.response?.data?.message ?? 'Error al ejecutar la consulta.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="px-5 py-4">
      <div className="flex items-start justify-between gap-4">
        <div className="flex items-start gap-3 flex-1 min-w-0">
          <div className={`w-1.5 h-1.5 rounded-full mt-1.5 shrink-0 bg-current ${c.text}`} />
          <div className="min-w-0">
            <p className="text-sm font-semibold text-white">{item.label}</p>
            <p className="text-xs text-gray-500 mt-0.5 leading-relaxed">{item.desc}</p>

            {/* Parámetros opcionales */}
            {item.paramFields && (
              <div className="flex flex-wrap gap-2 mt-2">
                {item.paramFields.map(f => (
                  <div key={f.key} className="flex items-center gap-1.5">
                    <label className="text-[10px] text-gray-500 uppercase tracking-wider">{f.label}</label>
                    <input
                      type="text"
                      value={params[f.key] ?? ''}
                      onChange={e => setParams(p => ({ ...p, [f.key]: e.target.value }))}
                      placeholder={f.placeholder}
                      className="bg-gray-900 border border-white/10 rounded-lg px-2 py-1 text-xs text-white
                                 focus:outline-none focus:border-brand-500/60 w-24"
                    />
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>

        <button
          onClick={ejecutar}
          disabled={loading}
          className={`shrink-0 flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold
                      transition-all duration-150 disabled:opacity-50
                      ${c.bg} ${c.border} border ${c.text} hover:opacity-80`}
        >
          {loading
            ? <><span className="w-3 h-3 border-2 border-current border-t-transparent rounded-full animate-spin" /> Ejecutando...</>
            : <><span>▶</span> Ejecutar</>
          }
        </button>
      </div>

      {error && (
        <p className="mt-2 text-xs text-rose-400 bg-rose-500/10 border border-rose-500/20 rounded-lg px-3 py-2">
          {error}
        </p>
      )}

      {result && <ResultTable data={result} />}
    </div>
  )
}

/* ─── Paleta ─── */
const COLOR_MAP = {
  sky:    { bg: 'bg-sky-500/10',    border: 'border-sky-500/20',    text: 'text-sky-400',    badge: 'bg-sky-500/15 text-sky-300 ring-sky-500/20' },
  violet: { bg: 'bg-violet-500/10', border: 'border-violet-500/20', text: 'text-violet-400', badge: 'bg-violet-500/15 text-violet-300 ring-violet-500/20' },
}

/* ─── Definición de núcleos con sus funciones ─── */
const NUCLEOS = [
  {
    id: 'N1',
    titulo: 'Núcleo 1',
    subtitulo: 'Consultas avanzadas y almacenamiento',
    color: 'sky',
    icon: '🗄️',
    secciones: [
      {
        titulo: 'Consultas parametrizadas',
        badge: '3 consultas',
        items: [
          {
            label: 'Top 10 por ciudad',
            desc: 'Muestra el top 10 de contenido más reproducido en una ciudad, incluyendo series y podcasts vía episodios.',
            paramFields: [{ key: 'ciudad', label: 'Ciudad', placeholder: 'Armenia' }],
            defaultParams: { ciudad: 'Armenia' },
            fn: (p) => demoApi.getTop10Ciudad(p.ciudad || 'Armenia'),
          },
          {
            label: 'Ingresos por plan y periodo',
            desc: 'Ingresos por plan de suscripción en un mes y año específicos, filtrando pagos EXITOSOS.',
            paramFields: [
              { key: 'mes', label: 'Mes', placeholder: '03' },
              { key: 'anio', label: 'Año', placeholder: '2025' },
            ],
            defaultParams: { mes: '03', anio: '2025' },
            fn: (p) => demoApi.getIngresosPlan(p.mes || '03', p.anio || '2025'),
          },
          {
            label: 'Calificación promedio por género',
            desc: 'Calificación promedio por categoría para un género específico.',
            paramFields: [{ key: 'genero', label: 'Género', placeholder: 'Drama' }],
            defaultParams: { genero: 'Drama' },
            fn: (p) => demoApi.getCalificacionGenero(p.genero || 'Drama'),
          },
        ],
      },
      {
        titulo: 'PIVOT y UNPIVOT',
        badge: '2 PIVOTs',
        items: [
          {
            label: 'PIVOT — Usuarios activos por ciudad × plan',
            desc: 'Filas: ciudades. Columnas: Básico, Estándar, Premium. Cantidad de usuarios activos por combinación.',
            fn: () => demoApi.getPivotCiudades(),
          },
          {
            label: 'PIVOT — Reproducciones por categoría × dispositivo',
            desc: 'Filas: categorías. Columnas: CELULAR, TABLET, TV, COMPUTADOR.',
            fn: () => demoApi.getPivotDispositivos(),
          },
        ],
      },
      {
        titulo: 'GROUP BY avanzado',
        badge: '3 funciones',
        items: [
          {
            label: 'ROLLUP — Ingresos por ciudad y plan',
            desc: 'Ingresos con subtotales por ciudad y gran total al final.',
            fn: () => demoApi.getRollupIngresos(),
          },
          {
            label: 'CUBE — Reproducciones por categoría y dispositivo',
            desc: 'Todas las combinaciones posibles incluyendo totales parciales.',
            fn: () => demoApi.getCubeReproducciones(),
          },
          {
            label: 'GROUPING SETS — Totales por categoría y ciudad',
            desc: 'Solo los totales por categoría y por ciudad, sin detalle cruzado.',
            fn: () => demoApi.getGroupingSets(),
          },
        ],
      },
      {
        titulo: 'Vistas materializadas',
        badge: '2 vistas',
        items: [
          {
            label: 'MV_CONTENIDO_POPULAR',
            desc: 'Precalcula total de reproducciones y calificación promedio por contenido.',
            fn: () => demoApi.getMvContenidoPopular(),
          },
          {
            label: 'MV_INGRESOS_MENSUALES',
            desc: 'Precalcula ingresos mensuales por ciudad y plan de suscripción.',
            fn: () => demoApi.getMvIngresosMensuales(),
          },
        ],
      },
    ],
  },
  {
    id: 'N2',
    titulo: 'Núcleo 2',
    subtitulo: 'PL/SQL — Procedimientos almacenados y disparadores',
    color: 'violet',
    icon: '⚙️',
    secciones: [
      {
        titulo: 'Cursores',
        badge: '2 cursores',
        items: [
          {
            label: 'CUR_MOROSOS — Usuarios con suscripción vencida',
            desc: 'Usuarios con más de 30 días sin pago exitoso. Muestra nombre, email, plan, días de mora y monto adeudado.',
            fn: () => demoApi.getMorosos(),
          },
          {
            label: 'CUR_POPULARIDAD — Reproducciones completas por contenido',
            desc: 'Contenidos ordenados por reproducciones completas (avance ≥ 90%). Refleja el campo popularidad actualizado.',
            fn: () => demoApi.getPopularidad(),
          },
        ],
      },
      {
        titulo: 'Funciones PL/SQL',
        badge: '2 funciones',
        items: [
          {
            label: 'FN_CALCULAR_MONTO — Monto del próximo mes',
            desc: 'Calcula el monto a cobrar aplicando descuentos por antigüedad (10% >12 meses, 15% >24 meses) y 5% por referidos activos.',
            paramFields: [{ key: 'idUsuario', label: 'ID Usuario', placeholder: '1' }],
            defaultParams: { idUsuario: '1' },
            fn: (p) => demoApi.getCalcularMonto(p.idUsuario || 1),
          },
          {
            label: 'FN_CONTENIDO_RECOMENDADO — Recomendación por perfil',
            desc: 'Retorna el contenido más popular del género más frecuente del perfil, excluyendo lo ya reproducido.',
            paramFields: [{ key: 'idPerfil', label: 'ID Perfil', placeholder: '1' }],
            defaultParams: { idPerfil: '1' },
            fn: (p) => demoApi.getRecomendacion(p.idPerfil || 1),
          },
        ],
      },
      {
        titulo: 'Procedimientos almacenados',
        badge: '3 SPs',
        items: [
          {
            label: 'SP_REGISTRAR_USUARIO',
            desc: 'Valida email único (-20001) y plan válido (-20002). Crea cuenta, perfil ADULTO predeterminado y primer pago PENDIENTE. Se prueba desde la sección Usuarios.',
          },
          {
            label: 'SP_CAMBIAR_PLAN',
            desc: 'Valida que el nuevo plan soporte los perfiles existentes (-20003). Se prueba desde la sección Usuarios → Cambiar plan.',
          },
          {
            label: 'SP_REPORTE_CONSUMO',
            desc: 'Genera reporte detallado de reproducciones por perfil y categoría con totales de tiempo consumido. Se ejecuta directamente en Oracle.',
          },
        ],
      },
      {
        titulo: 'Disparadores',
        badge: '4 triggers',
        items: [
          {
            label: 'TRG_REPR_CUENTA_ACTIVA',
            desc: 'BEFORE INSERT FOR EACH ROW en REPRODUCCIONES. Rechaza si el usuario tiene estado_cuenta ≠ ACTIVO.',
          },
          {
            label: 'TRG_PERF_MAX_PERFILES',
            desc: 'BEFORE INSERT FOR EACH ROW en PERFILES. Rechaza si el usuario supera el límite de perfiles de su plan.',
          },
          {
            label: 'TRG_CAL_MIN_AVANCE',
            desc: 'BEFORE INSERT FOR EACH ROW en CALIFICACIONES. Rechaza si el perfil no ha reproducido al menos el 50% del contenido.',
          },
          {
            label: 'TRG_PAGO_ACTUALIZAR_ESTADO',
            desc: 'AFTER INSERT FOR EACH STATEMENT en PAGOS. Actualiza estado_cuenta=ACTIVO y fecha_ultimo_pago para usuarios con pagos EXITOSOS del día.',
          },
        ],
      },
    ],
  },
]

/* ─── Página principal ─── */
export default function Documentacion() {
  return (
    <div className="max-w-screen-xl mx-auto px-6 py-8 space-y-6">
      {/* Header */}
      <div className="bg-gray-800/40 border border-white/5 rounded-2xl p-8">
        <div className="flex items-start gap-5">
          <div className="w-14 h-14 rounded-2xl bg-brand-500/20 border border-brand-500/30 flex items-center justify-center text-2xl shrink-0">
            📋
          </div>
          <div>
            <p className="text-xs font-semibold text-brand-400 uppercase tracking-widest mb-1">
              Universidad del Quindío — Bases de Datos II — 2026-1
            </p>
            <h1 className="text-3xl font-black text-white">Proyecto Final: QuindioFlix</h1>
            <p className="text-gray-400 mt-2 text-sm leading-relaxed max-w-2xl">
              Plataforma de streaming de contenido multimedia. Haz clic en{' '}
              <span className="text-white font-semibold">▶ Ejecutar</span> en cada consulta
              para ver los resultados en tiempo real desde la base de datos Oracle.
            </p>
            <div className="flex flex-wrap gap-2 mt-4">
              {NUCLEOS.map(n => {
                const c = COLOR_MAP[n.color]
                return (
                  <a key={n.id} href={`#${n.id}`}
                    className={`text-xs font-semibold px-3 py-1 rounded-full ring-1 transition hover:opacity-80 ${c.badge}`}>
                    {n.icon} {n.titulo}
                  </a>
                )
              })}
            </div>
          </div>
        </div>
      </div>

      {/* Núcleos */}
      {NUCLEOS.map(nucleo => {
        const c = COLOR_MAP[nucleo.color]
        return (
          <section key={nucleo.id} id={nucleo.id} className="scroll-mt-20 space-y-4">
            {/* Encabezado */}
            <div className={`${c.bg} border ${c.border} rounded-2xl p-6`}>
              <div className="flex items-center gap-4">
                <div className={`w-12 h-12 rounded-xl ${c.bg} border ${c.border} flex items-center justify-center text-xl`}>
                  {nucleo.icon}
                </div>
                <div>
                  <p className={`text-xs font-bold uppercase tracking-widest ${c.text}`}>{nucleo.id}</p>
                  <h2 className="text-xl font-black text-white">{nucleo.titulo}</h2>
                  <p className="text-sm text-gray-400">{nucleo.subtitulo}</p>
                </div>
              </div>
            </div>

            {/* Secciones */}
            <div className="grid gap-4 md:grid-cols-2">
              {nucleo.secciones.map((sec, si) => (
                <DemoSection
                  key={si}
                  titulo={sec.titulo}
                  badge={sec.badge}
                  color={nucleo.color}
                  items={sec.items}
                />
              ))}
            </div>
          </section>
        )
      })}

      <div className="text-center py-6 text-xs text-gray-700 border-t border-white/5">
        QuindioFlix — Proyecto Final — Bases de Datos II — Universidad del Quindío — Semestre 2026-1
      </div>
    </div>
  )
}
