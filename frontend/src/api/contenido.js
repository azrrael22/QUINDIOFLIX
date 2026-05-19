import api from './axios'

export const getContenido = () => api.get('/contenido')
export const getContenidoById = (id) => api.get(`/contenido/${id}`)
export const getContenidoPorCategoria = (id) => api.get(`/contenido/categoria/${id}`)
export const getContenidoPopular = (limite = 10) => api.get(`/contenido/popular?limite=${limite}`)
