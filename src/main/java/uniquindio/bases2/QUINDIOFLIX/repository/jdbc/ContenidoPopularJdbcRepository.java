package uniquindio.bases2.QUINDIOFLIX.repository.jdbc;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uniquindio.bases2.QUINDIOFLIX.dto.response.ContenidoPopularResponse;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class ContenidoPopularJdbcRepository {

    private final JdbcTemplate jdbc;

    // Consulta la vista materializada mv_contenido_popular
    // Columnas reales: id_contenido, titulo, total_reproducciones, calif_promedio
    public List<ContenidoPopularResponse> findTopContenido(int limit) {
        String sql = """
            SELECT id_contenido, titulo, total_reproducciones, calif_promedio
            FROM (
                SELECT id_contenido, titulo, total_reproducciones, calif_promedio
                FROM mv_contenido_popular
                ORDER BY total_reproducciones DESC, calif_promedio DESC
            )
            WHERE ROWNUM <= ?
            """;
        return jdbc.query(sql, (rs, i) -> ContenidoPopularResponse.builder()
                .idContenido(rs.getLong("id_contenido"))
                .titulo(rs.getString("titulo"))
                .totalReproducciones(rs.getLong("total_reproducciones"))
                .calificacionPromedio(rs.getDouble("calif_promedio"))
                .build(), limit);
    }
}
