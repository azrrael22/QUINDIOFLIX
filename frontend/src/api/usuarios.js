import api from './axios'

export const getUsuarios = () => api.get('/usuarios')
export const getUsuariosMorosos = () => api.get('/usuarios/morosos')
export const buscarPorEmail = (email) => api.get(`/usuarios/buscar?email=${email}`)
export const registrarUsuario = (data) => api.post('/usuarios', data)
export const cambiarPlan = (data) => api.post('/usuarios/cambiar-plan', data)
