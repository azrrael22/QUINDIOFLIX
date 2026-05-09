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
        // mv_ingresos_mensuales columnas: ciudad, plan, mes (DATE), total_ingresos
        // Extraemos mes y año numérico desde la columna DATE
        String sql = """
            SELECT ciudad, plan,
                   EXTRACT(MONTH FROM mes) AS mes_num,
                   EXTRACT(YEAR  FROM mes) AS anio_num,
                   total_ingresos
            FROM mv_ingresos_mensuales
            WHERE (? IS NULL OR EXTRACT(MONTH FROM mes) = ?)
              AND (? IS NULL OR EXTRACT(YEAR  FROM mes) = ?)
            ORDER BY anio_num DESC, mes_num DESC, total_ingresos DESC
            """;
        return jdbc.query(sql,
            (rs, i) -> IngresosResponse.builder()
                .ciudad(rs.getString("ciudad"))
                .plan(rs.getString("plan"))
                .mes(rs.getInt("mes_num"))
                .anio(rs.getInt("anio_num"))
                .totalIngresos(rs.getBigDecimal("total_ingresos"))
                .build(),
            mes, mes, anio, anio);
    }
}
