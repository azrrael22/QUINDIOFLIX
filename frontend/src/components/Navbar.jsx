import { Link, useLocation } from 'react-router-dom'

const links = [
  { to: '/', label: 'Catálogo' },
  { to: '/usuarios', label: 'Usuarios' },
  { to: '/pagos', label: 'Pagos' },
  { to: '/reportes', label: 'Reportes' },
  { to: '/docs', label: 'Documentación' },
]

export default function Navbar() {
  const { pathname } = useLocation()

  return (
    <nav className="sticky top-0 z-40 h-16 flex items-center px-8 gap-10
                    bg-gray-900/80 backdrop-blur-md border-b border-white/5">
      {/* Logo */}
      <Link to="/" className="flex items-center gap-2 select-none">
        <div className="w-8 h-8 rounded-lg bg-brand-500 flex items-center justify-center shadow-lg shadow-brand-500/40">
          <span className="text-white font-black text-sm">Q</span>
        </div>
        <span className="font-black text-white text-lg tracking-tight">
          Quindio<span className="text-brand-400">Flix</span>
        </span>
      </Link>

      {/* Links */}
      <div className="flex items-center gap-1">
        {links.map(({ to, label }) => (
          <Link
            key={to}
            to={to}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition-all duration-150 ${
              pathname === to
                ? 'bg-brand-500/20 text-brand-400 font-semibold'
                : 'text-gray-400 hover:text-white hover:bg-white/5'
            }`}
          >
            {label}
          </Link>
        ))}
      </div>
    </nav>
  )
}
