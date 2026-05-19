package uniquindio.bases2.QUINDIOFLIX.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import uniquindio.bases2.QUINDIOFLIX.repository.jdbc.DemoJdbcRepository;

import java.util.List;
import java.util.Map;

/**
 * Endpoints de demostración para la sustentación del proyecto.
 * Ejecutan las consultas de los Núcleos 1 y 2 y devuelven los resultados como JSON.
 */
@RestController
@RequestMapping("/api/demo")
@RequiredArgsConstructor
public class DemoController {

    private final DemoJdbcRepository repo;

    // ── Núcleo 1 ─────────────────────────────────────────────────────────────

    @GetMapping("/top10-ciudad")
    public List<Map<String, Object>> top10Ciudad(@RequestParam(defaultValue = "Armenia") String ciudad) {
        return repo.top10PorCiudad(ciudad);
    }

    @GetMapping("/ingresos-plan")
    public List<Map<String, Object>> ingresosPlan(
            @RequestParam(defaultValue = "03") String mes,
            @RequestParam(defaultValue = "2025") String anio) {
        return repo.ingresosPorPlan(mes, anio);
    }

    @GetMapping("/calificacion-genero")
    public List<Map<String, Object>> calificacionGenero(
            @RequestParam(defaultValue = "Drama") String genero) {
        return repo.calificacionPorGenero(genero);
    }

    @GetMapping("/pivot-ciudades")
    public List<Map<String, Object>> pivotCiudades() {
        return repo.pivotCiudadesPlan();
    }

    @GetMapping("/pivot-dispositivos")
    public List<Map<String, Object>> pivotDispositivos() {
        return repo.pivotCategoriasDispositivo();
    }

    @GetMapping("/rollup-ingresos")
    public List<Map<String, Object>> rollupIngresos() {
        return repo.rollupIngresos();
    }

    @GetMapping("/cube-reproducciones")
    public List<Map<String, Object>> cubeReproducciones() {
        return repo.cubeReproducciones();
    }

    @GetMapping("/grouping-sets")
    public List<Map<String, Object>> groupingSets() {
        return repo.groupingSetsConsumo();
    }

    @GetMapping("/mv-contenido-popular")
    public List<Map<String, Object>> mvContenidoPopular() {
        return repo.mvContenidoPopular();
    }

    @GetMapping("/mv-ingresos-mensuales")
    public List<Map<String, Object>> mvIngresosMensuales() {
        return repo.mvIngresosMensuales();
    }

    // ── Núcleo 2 ─────────────────────────────────────────────────────────────

    @GetMapping("/morosos")
    public List<Map<String, Object>> morosos() {
        return repo.usuariosMorosos();
    }

    @GetMapping("/popularidad")
    public List<Map<String, Object>> popularidad() {
        return repo.popularidadContenidos();
    }

    @GetMapping("/calcular-monto")
    public List<Map<String, Object>> calcularMonto(
            @RequestParam(defaultValue = "1") Long idUsuario) {
        return repo.calcularMonto(idUsuario);
    }

    /** Devuelve plan y monto a pagar para prellenar el formulario de pagos */
    @GetMapping("/info-pago")
    public Map<String, Object> infoPago(@RequestParam Long idUsuario) {
        var resultado = repo.calcularMonto(idUsuario);
        if (resultado.isEmpty()) throw new jakarta.persistence.EntityNotFoundException("Usuario no encontrado");
        return resultado.get(0);
    }

    @GetMapping("/recomendacion")
    public List<Map<String, Object>> recomendacion(
            @RequestParam(defaultValue = "1") Long idPerfil) {
        try {
            return repo.contenidoRecomendado(idPerfil);
        } catch (Exception e) {
            // Si la función Oracle lanza error (perfil sin reproducciones), devolvemos mensaje amigable
            return List.of(Map.of(
                "perfil", "Perfil " + idPerfil,
                "recomendacion", "Sin recomendación disponible (el perfil no tiene reproducciones registradas)"
            ));
        }
    }
}
