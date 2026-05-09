import { useEffect, useState } from 'react'
import { getContenido, getContenidoPopular, getContenidoById } from '../api/contenido'

/* ─── Paleta de clasificación ─── */
const CLASIF = {
  'TP':  'bg-emerald-500/20 text-emerald-300 ring-1 ring-emerald-500/30',
  '+7':  'bg-sky-500/20 text-sky-300 ring-1 ring-sky-500/30',
  '+13': 'bg-amber-500/20 text-amber-300 ring-1 ring-amber-500/30',
  '+16': 'bg-orange-500/20 text-orange-300 ring-1 ring-orange-500/30',
  '+18': 'bg-rose-500/20 text-rose-300 ring-1 ring-rose-500/30',
}

const CAT_ICON  = { 'Película': '🎬', 'Serie': '📺', 'Documental': '🎥', 'Música': '🎵', 'Podcast': '🎙️' }
const CAT_COLOR = {
  'Película':   'text-sky-400',
  'Serie':      'text-violet-400',
  'Documental': 'text-emerald-400',
  'Música':     'text-pink-400',
  'Podcast':    'text-amber-400',
}
const CAT_BAR = {
  'Película':   'from-sky-500',
  'Serie':      'from-violet-500',
  'Documental': 'from-emerald-500',
  'Música':     'from-pink-500',
  'Podcast':    'from-amber-500',
}

/* ─── Modal ─── */
function Modal({ id, onClose }) {
  const [item, setItem] = useState(null)

  useEffect(() => {
    getContenidoById(id).then(r => setItem(r.data)).catch(onClose)
    const fn = e => e.key === 'Escape' && onClose()
    window.addEventListener('keydown', fn)
    return () => window.removeEventListener('keydown', fn)
  }, [id])

  if (!item) return (
    <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center backdrop-blur-sm">
      <div className="w-10 h-10 border-[3px] border-brand-500 border-t-transparent rounded-full animate-spin" />
    </div>
  )

  return (
    <div
      className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4 backdrop-blur-sm"
      onClick={onClose}
    >
      <div
        className="bg-gray-900 rounded-2xl w-full max-w-lg overflow-hidden shadow-modal border border-white/10"
        onClick={e => e.stopPropagation()}
      >
        {/* Header */}
        <div className="relative p-7 bg-gradient-to-br from-gray-800 to-gray-900">
          {/* Close */}
          <button
            onClick={onClose}
            className="absolute top-4 right-4 w-8 h-8 rounded-full bg-white/10 hover:bg-white/20
                       text-gray-400 hover:text-white flex items-center justify-center text-sm transition"
          >✕</button>

          {/* Badges */}
          <div className="flex flex-wrap gap-2 mb-4">
            {CLASIF[item.clasificacionEdad] && (
              <span className={`text-xs font-semibold px-2.5 py-0.5 rounded-full ${CLASIF[item.clasificacionEdad]}`}>
                {item.clasificacionEdad}
              </span>
            )}
            {item.esOriginal && (
              <span className="text-xs font-semibold px-2.5 py-0.5 rounded-full bg-brand-500/20 text-brand-400 ring-1 ring-brand-500/30">
                ✦ QuindioFlix Original
              </span>
            )}
          </div>

          <h2 className="text-2xl font-black text-white leading-tight">{item.titulo}</h2>

          <div className="flex flex-wrap items-center gap-3 mt-3">
            <span className="text-sm font-medium text-gray-300">{item.anioLanzamiento}</span>
            <span className="w-1 h-1 rounded-full bg-gray-600" />
            <span className={`text-sm font-medium ${CAT_COLOR[item.categoria] ?? 'text-gray-400'}`}>
              {CAT_ICON[item.categoria]} {item.categoria}
            </span>
            {item.duracion && (
              <>
                <span className="w-1 h-1 rounded-full bg-gray-600" />
                <span className="text-sm text-gray-400">{item.duracion} min</span>
              </>
            )}
          </div>
        </div>

        {/* Body */}
        <div className="p-6 space-y-5 border-t border-white/5">
          {item.sinopsis
            ? <p className="text-gray-300 text-sm leading-relaxed">{item.sinopsis}</p>
            : <p className="text-gray-600 text-sm italic">Sin sinopsis disponible.</p>
          }

          {item.generos?.length > 0 && (
            <div>
              <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">Géneros</p>
              <div className="flex flex-wrap gap-2">
                {item.generos.map(g => (
                  <span key={g} className="text-xs text-gray-300 bg-white/5 hover:bg-white/10
                                           px-3 py-1 rounded-full border border-white/10 transition">
                    {g}
                  </span>
                ))}
              </div>
            </div>
          )}

          {item.fechaAgregado && (
            <p className="text-xs text-gray-600 pt-1 border-t border-white/5">
              Agregado el {new Date(item.fechaAgregado).toLocaleDateString('es-CO', {
                year: 'numeric', month: 'long', day: 'numeric'
              })}
            </p>
          )}
        </div>
      </div>
    </div>
  )
}

/* ─── Tarjeta ─── */
function Card({ item, onClick }) {
  return (
    <button
      onClick={() => onClick(item.idContenido)}
      className="group text-left w-full bg-gray-800/60 hover:bg-gray-800 border border-white/5
                 hover:border-brand-500/40 rounded-xl p-4 transition-all duration-200
                 shadow-card hover:shadow-card-hover hover:-translate-y-0.5 focus:outline-none"
    >
      {/* Top */}
      <div className="flex items-start justify-between gap-2 mb-3">
        <span className={`text-xs font-semibold px-2 py-0.5 rounded-full shrink-0
                          ${CLASIF[item.clasificacionEdad] ?? 'bg-gray-700/50 text-gray-400'}`}>
          {item.clasificacionEdad}
        </span>
        {item.esOriginal && (
          <span className="text-[10px] font-bold text-brand-400 shrink-0">✦ Original</span>
        )}
      </div>

      {/* Título */}
      <h3 className="font-bold text-white text-sm leading-snug line-clamp-2
                     group-hover:text-brand-400 transition-colors duration-150">
        {item.titulo}
      </h3>

      {/* Meta */}
      <div className="flex items-center gap-1.5 mt-2 text-xs text-gray-500">
        <span>{item.anioLanzamiento}</span>
        {item.duracion && <><span>·</span><span>{item.duracion}m</span></>}
      </div>

      {/* Géneros */}
      {item.generos?.length > 0 && (
        <div className="flex flex-wrap gap-1 mt-3">
          {[...item.generos].slice(0, 2).map(g => (
            <span key={g} className="text-[10px] text-gray-500 bg-white/5 px-2 py-0.5 rounded-full">
              {g}
            </span>
          ))}
        </div>
      )}
    </button>
  )
}

/* ─── Top 5 card ─── */
function PopularCard({ item, rank, onClick }) {
  return (
    <button
      onClick={() => onClick(item.idContenido)}
      className="group text-left relative bg-gray-800/60 hover:bg-gray-800 border border-white/5
                 hover:border-brand-500/40 rounded-xl p-5 transition-all duration-200
                 shadow-card hover:shadow-card-hover hover:-translate-y-0.5 overflow-hidden focus:outline-none"
    >
      {/* Número de fondo */}
      <span className="absolute -bottom-3 -right-1 text-8xl font-black text-white/[0.04] select-none leading-none">
        {rank}
      </span>

      <p className="font-bold text-white text-sm leading-snug line-clamp-2 group-hover:text-brand-400 transition-colors relative z-10">
        {item.titulo}
      </p>
      <p className="text-xs text-gray-500 mt-2 relative z-10">{item.totalReproducciones} reproducciones</p>
      <p className="text-xs text-amber-400 mt-1 relative z-10">
        ★ {item.calificacionPromedio ? item.calificacionPromedio.toFixed(1) : '—'}
      </p>
    </button>
  )
}

const ORDEN = ['Película', 'Serie', 'Documental', 'Música', 'Podcast']

/* ─── Página principal ─── */
export default function Catalogo() {
  const [contenido, setContenido]   = useState([])
  const [popular, setPopular]       = useState([])
  const [loading, setLoading]       = useState(true)
  const [error, setError]           = useState(null)
  const [selectedId, setSelectedId] = useState(null)
  const [filtro, setFiltro]         = useState('')

  useEffect(() => {
    Promise.all([getContenido(), getContenidoPopular(5)])
      .then(([c, p]) => { setContenido(c.data); setPopular(p.data) })
      .catch(() => setError('No se pudo conectar con el servidor.'))
      .finally(() => setLoading(false))
  }, [])

  const porCategoria = ORDEN.reduce((acc, cat) => {
    const q = filtro.toLowerCase()
    const items = contenido.filter(c =>
      c.categoria === cat &&
      (!q || c.titulo?.toLowerCase().includes(q) || c.categoria?.toLowerCase().includes(q))
    )
    if (items.length) acc[cat] = items
    return acc
  }, {})

  if (loading) return (
    <div className="flex items-center justify-center h-64">
      <div className="w-10 h-10 border-[3px] border-brand-500 border-t-transparent rounded-full animate-spin" />
    </div>
  )
  if (error) return (
    <div className="flex flex-col items-center justify-center h-64 gap-3">
      <span className="text-4xl">⚠️</span>
      <p className="text-gray-400 text-sm">{error}</p>
    </div>
  )

  return (
    <div className="max-w-screen-xl mx-auto px-6 py-8 space-y-12">
      {selectedId && <Modal id={selectedId} onClose={() => setSelectedId(null)} />}

      {/* ── Hero / Top 5 ── */}
      {popular.length > 0 && (
        <section>
          <div className="flex items-center gap-3 mb-5">
            <span className="text-lg">🔥</span>
            <h2 className="text-base font-bold text-white">Más populares</h2>
            <div className="flex-1 h-px bg-gradient-to-r from-white/10 to-transparent" />
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-3">
            {popular.map((c, i) => (
              <PopularCard key={c.idContenido} item={c} rank={i + 1} onClick={setSelectedId} />
            ))}
          </div>
        </section>
      )}

      {/* ── Buscador ── */}
      <div className="relative max-w-sm">
        <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-500 text-sm pointer-events-none">
          🔍
        </span>
        <input
          type="text"
          placeholder="Buscar título o categoría..."
          value={filtro}
          onChange={e => setFiltro(e.target.value)}
          className="w-full bg-gray-800/60 border border-white/10 focus:border-brand-500/60
                     rounded-xl pl-10 pr-4 py-2.5 text-sm text-white placeholder-gray-500
                     focus:outline-none focus:ring-2 focus:ring-brand-500/20 transition"
        />
        {filtro && (
          <button
            onClick={() => setFiltro('')}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-white transition text-xs"
          >✕</button>
        )}
      </div>

      {/* ── Catálogo por categoría ── */}
      {Object.entries(porCategoria).map(([cat, items]) => (
        <section key={cat}>
          {/* Encabezado de sección */}
          <div className="flex items-center gap-3 mb-5">
            <div className={`w-1 h-6 rounded-full bg-gradient-to-b ${CAT_BAR[cat]} to-transparent`} />
            <h2 className={`text-base font-bold ${CAT_COLOR[cat] ?? 'text-white'}`}>
              {CAT_ICON[cat]}{' '}
              {cat === 'Película' ? 'Películas' : cat === 'Serie' ? 'Series' : cat === 'Podcast' ? 'Podcasts' : cat}
            </h2>
            <span className="text-xs text-gray-600 bg-gray-800 px-2 py-0.5 rounded-full border border-white/5">
              {items.length}
            </span>
            <div className="flex-1 h-px bg-gradient-to-r from-white/10 to-transparent" />
          </div>

          {/* Grid */}
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-3">
            {items.map(c => <Card key={c.idContenido} item={c} onClick={setSelectedId} />)}
          </div>
        </section>
      ))}

      {/* Sin resultados */}
      {Object.keys(porCategoria).length === 0 && (
        <div className="flex flex-col items-center justify-center py-24 gap-3">
          <span className="text-5xl">🎬</span>
          <p className="text-gray-400 text-sm">
            Sin resultados para "<span className="text-white font-medium">{filtro}</span>"
          </p>
          <button onClick={() => setFiltro('')} className="text-xs text-brand-400 hover:text-brand-300 transition mt-1">
            Ver todo el catálogo
          </button>
        </div>
      )}
    </div>
  )
}
