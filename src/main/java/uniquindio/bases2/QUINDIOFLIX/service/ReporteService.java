package uniquindio.bases2.QUINDIOFLIX.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import uniquindio.bases2.QUINDIOFLIX.dto.response.ContenidoPopularResponse;
import uniquindio.bases2.QUINDIOFLIX.dto.response.IngresosResponse;
import uniquindio.bases2.QUINDIOFLIX.repository.jdbc.ContenidoPopularJdbcRepository;
import uniquindio.bases2.QUINDIOFLIX.repository.jdbc.IngresosJdbcRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReporteService {

    private final ContenidoPopularJdbcRepository popularRepo;
    private final IngresosJdbcRepository ingresosRepo;

    public List<ContenidoPopularResponse> contenidoPopular(int limite) {
        return popularRepo.findTopContenido(limite);
    }

    // Consulta mv_ingresos_mensuales — mes y anio opcionales (null = todos)
    public List<IngresosResponse> ingresosMensuales(Integer mes, Integer anio) {
        return ingresosRepo.findIngresosMensuales(mes, anio);
    }
}
