import api from './axios'

// Núcleo 1
export const getTop10Ciudad       = (ciudad)         => api.get(`/demo/top10-ciudad?ciudad=${ciudad}`)
export const getIngresosPlan      = (mes, anio)      => api.get(`/demo/ingresos-plan?mes=${mes}&anio=${anio}`)
export const getCalificacionGenero= (genero)         => api.get(`/demo/calificacion-genero?genero=${genero}`)
export const getPivotCiudades     = ()               => api.get('/demo/pivot-ciudades')
export const getPivotDispositivos = ()               => api.get('/demo/pivot-dispositivos')
export const getRollupIngresos    = ()               => api.get('/demo/rollup-ingresos')
export const getCubeReproducciones= ()               => api.get('/demo/cube-reproducciones')
export const getGroupingSets      = ()               => api.get('/demo/grouping-sets')
export const getMvContenidoPopular= ()               => api.get('/demo/mv-contenido-popular')
export const getMvIngresosMensuales=()               => api.get('/demo/mv-ingresos-mensuales')

// Núcleo 2
export const getMorosos           = ()               => api.get('/demo/morosos')
export const getPopularidad       = ()               => api.get('/demo/popularidad')
export const getCalcularMonto     = (idUsuario)      => api.get(`/demo/calcular-monto?idUsuario=${idUsuario}`)
export const getInfoPago          = (idUsuario)      => api.get(`/demo/info-pago?idUsuario=${idUsuario}`)
export const getRecomendacion     = (idPerfil)       => api.get(`/demo/recomendacion?idPerfil=${idPerfil}`)
