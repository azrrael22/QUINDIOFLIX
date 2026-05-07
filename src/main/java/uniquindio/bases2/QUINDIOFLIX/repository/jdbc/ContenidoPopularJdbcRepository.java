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
    public List<ContenidoPopularResponse> findTopContenido(int limit) {
        String sql = """
            SELECT id_contenido, titulo, categoria, total_reproducciones, promedio_calificacion
            FROM mv_contenido_popular
            WHERE ROWNUM <= ?
            ORDER BY total_reproducciones DESC, promedio_calificacion DESC
            """;
        return jdbc.query(sql, (rs, i) -> ContenidoPopularResponse.builder()
                .idContenido(rs.getLong("id_contenido"))
                .titulo(rs.getString("titulo"))
                .categoria(rs.getString("categoria"))
                .totalReproducciones(rs.getLong("total_reproducciones"))
                .promedioCalificacion(rs.getDouble("promedio_calificacion"))
                .build(), limit);
    }
}
