import api from './axios'

export const getContenidoPopularReporte = (limite = 10) =>
  api.get(`/reportes/contenido-popular?limite=${limite}`)

export const getIngresos = (mes, anio) => {
  const params = new URLSearchParams()
  if (mes) params.append('mes', mes)
  if (anio) params.append('anio', anio)
  return api.get(`/reportes/ingresos?${params.toString()}`)
}
