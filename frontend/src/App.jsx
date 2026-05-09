import { BrowserRouter, Routes, Route } from 'react-router-dom'
import Navbar from './components/Navbar'
import Catalogo from './pages/Catalogo'
import Usuarios from './pages/Usuarios'
import Pagos from './pages/Pagos'
import Reportes from './pages/Reportes'
import Documentacion from './pages/Documentacion'

export default function App() {
  return (
    <BrowserRouter>
      <div className="min-h-screen bg-gray-900 text-white">
        <Navbar />
        <main>
          <Routes>
            <Route path="/" element={<Catalogo />} />
            <Route path="/usuarios" element={<Usuarios />} />
            <Route path="/pagos" element={<Pagos />} />
            <Route path="/reportes" element={<Reportes />} />
            <Route path="/docs" element={<Documentacion />} />
          </Routes>
        </main>
      </div>
    </BrowserRouter>
  )
}
