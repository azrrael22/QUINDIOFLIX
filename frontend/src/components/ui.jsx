/* Componentes UI reutilizables */

export function PageHeader({ title, subtitle }) {
  return (
    <div className="mb-8">
      <h1 className="text-2xl font-black text-white">{title}</h1>
      {subtitle && <p className="text-sm text-gray-500 mt-1">{subtitle}</p>}
    </div>
  )
}

export function TabBar({ tabs, active, onChange }) {
  return (
    <div className="flex gap-1 bg-gray-800/50 p-1 rounded-xl w-fit mb-6 border border-white/5">
      {tabs.map(({ key, label }) => (
        <button
          key={key}
          onClick={() => onChange(key)}
          className={`px-4 py-2 rounded-lg text-sm font-medium transition-all duration-150 ${
            active === key
              ? 'bg-brand-500 text-white shadow-lg shadow-brand-500/30'
              : 'text-gray-400 hover:text-white'
          }`}
        >
          {label}
        </button>
      ))}
    </div>
  )
}

export function Alert({ type, message }) {
  if (!message) return null
  const styles = {
    ok:  'bg-emerald-500/10 border-emerald-500/20 text-emerald-300',
    err: 'bg-rose-500/10 border-rose-500/20 text-rose-300',
  }
  return (
    <div className={`text-sm px-4 py-3 rounded-xl border mb-4 ${styles[type]}`}>
      {type === 'ok' ? '✓ ' : '✕ '}{message}
    </div>
  )
}

export function Input({ label, ...props }) {
  return (
    <div>
      {label && <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-1.5">{label}</label>}
      <input
        {...props}
        className="w-full bg-gray-800/60 border border-white/10 focus:border-brand-500/60
                   rounded-xl px-4 py-2.5 text-sm text-white placeholder-gray-600
                   focus:outline-none focus:ring-2 focus:ring-brand-500/20 transition"
      />
    </div>
  )
}

export function Select({ label, children, ...props }) {
  return (
    <div>
      {label && <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-1.5">{label}</label>}
      <select
        {...props}
        className="w-full bg-gray-800/60 border border-white/10 focus:border-brand-500/60
                   rounded-xl px-4 py-2.5 text-sm text-white
                   focus:outline-none focus:ring-2 focus:ring-brand-500/20 transition"
      >
        {children}
      </select>
    </div>
  )
}

export function Button({ children, variant = 'primary', ...props }) {
  const styles = {
    primary: 'bg-brand-500 hover:bg-brand-600 text-white shadow-lg shadow-brand-500/25',
    ghost:   'bg-white/5 hover:bg-white/10 text-gray-300 hover:text-white border border-white/10',
  }
  return (
    <button
      {...props}
      className={`px-5 py-2.5 rounded-xl text-sm font-semibold transition-all duration-150 ${styles[variant]} disabled:opacity-40`}
    >
      {children}
    </button>
  )
}

export function Table({ headers, children, empty }) {
  return (
    <div className="bg-gray-800/40 border border-white/5 rounded-2xl overflow-hidden">
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b border-white/5">
            {headers.map(h => (
              <th key={h} className="text-left text-xs font-semibold text-gray-500 uppercase tracking-wider px-5 py-3.5">
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>{children}</tbody>
      </table>
      {empty && (
        <div className="text-center py-12 text-gray-600 text-sm">{empty}</div>
      )}
    </div>
  )
}

export function Tr({ children }) {
  return (
    <tr className="border-b border-white/5 last:border-0 hover:bg-white/[0.02] transition-colors">
      {children}
    </tr>
  )
}

export function Td({ children, muted }) {
  return (
    <td className={`px-5 py-3.5 ${muted ? 'text-gray-500' : 'text-gray-200'}`}>
      {children}
    </td>
  )
}

export function Badge({ color, children }) {
  const colors = {
    green:  'bg-emerald-500/15 text-emerald-300 ring-1 ring-emerald-500/25',
    red:    'bg-rose-500/15 text-rose-300 ring-1 ring-rose-500/25',
    yellow: 'bg-amber-500/15 text-amber-300 ring-1 ring-amber-500/25',
    gray:   'bg-gray-500/15 text-gray-400 ring-1 ring-gray-500/25',
    purple: 'bg-brand-500/15 text-brand-400 ring-1 ring-brand-500/25',
  }
  return (
    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold ${colors[color] ?? colors.gray}`}>
      {children}
    </span>
  )
}
