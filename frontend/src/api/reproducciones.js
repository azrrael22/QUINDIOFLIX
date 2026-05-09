import api from './axios'

export const registrarReproduccion = (data) => api.post('/reproducciones', data)
export const getHistorialPerfil = (idPerfil) => api.get(`/reproducciones/perfil/${idPerfil}`)
