package uniquindio.bases2.QUINDIOFLIX.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import uniquindio.bases2.QUINDIOFLIX.dto.response.ContenidoPopularResponse;
import uniquindio.bases2.QUINDIOFLIX.dto.response.IngresosResponse;
import uniquindio.bases2.QUINDIOFLIX.service.ReporteService;

import java.util.List;

@RestController
@RequestMapping("/api/reportes")
@RequiredArgsConstructor
public class ReporteController {

    private final ReporteService service;

    @GetMapping("/contenido-popular")
    public List<ContenidoPopularResponse> contenidoPopular(
            @RequestParam(defaultValue = "10") int limite) {
        return service.contenidoPopular(limite);
    }

    @GetMapping("/ingresos")
    public List<IngresosResponse> ingresos(
            @RequestParam(required = false) Integer mes,
            @RequestParam(required = false) Integer anio) {
        return service.ingresosMensuales(mes, anio);
    }
}
