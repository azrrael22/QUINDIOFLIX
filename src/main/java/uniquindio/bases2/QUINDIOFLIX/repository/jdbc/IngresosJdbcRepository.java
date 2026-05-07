package uniquindio.bases2.QUINDIOFLIX.repository.jdbc;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uniquindio.bases2.QUINDIOFLIX.dto.response.IngresosResponse;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class IngresosJdbcRepository {

    private final JdbcTemplate jdbc;

    public List<IngresosResponse> findIngresosMensuales(Integer mes, Integer anio) {
        String sql = """
            SELECT ciudad, plan, mes, anio, total_ingresos, total_pagos
            FROM mv_ingresos_mensuales
            WHERE (? IS NULL OR mes  = ?)
              AND (? IS NULL OR anio = ?)
            ORDER BY anio DESC, mes DESC, total_ingresos DESC
            """;
        return jdbc.query(sql,
            (rs, i) -> IngresosResponse.builder()
                .ciudad(rs.getString("ciudad"))
                .plan(rs.getString("plan"))
                .mes(rs.getInt("mes"))
                .anio(rs.getInt("anio"))
                .totalIngresos(rs.getBigDecimal("total_ingresos"))
                .totalPagos(rs.getLong("total_pagos"))
                .build(),
            mes, mes, anio, anio);
    }
}
