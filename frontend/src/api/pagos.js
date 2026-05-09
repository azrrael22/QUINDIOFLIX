import api from './axios'

export const registrarPago = (data) => api.post('/pagos', data)
export const getHistorialPagos = (idUsuario) => api.get(`/pagos/usuario/${idUsuario}`)
