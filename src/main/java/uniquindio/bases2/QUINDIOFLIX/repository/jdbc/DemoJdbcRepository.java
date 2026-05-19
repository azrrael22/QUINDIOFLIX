package uniquindio.bases2.QUINDIOFLIX.repository.jdbc;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class DemoJdbcRepository {

    private final JdbcTemplate jdbc;

    // ── Núcleo 1 ────────────────────────────────────────────────────────────

    /** 3.1.1a — Top 10 contenido más reproducido en una ciudad */
    public List<Map<String, Object>> top10PorCiudad(String ciudad) {
        String sql = """
            SELECT * FROM (
                SELECT c.titulo,
                       COUNT(r.id_reproduccion) AS total_reproducciones
                FROM reproducciones r
                LEFT JOIN contenido  c1 ON r.id_contenido = c1.id_contenido
                LEFT JOIN episodios  e  ON r.id_episodio  = e.id_episodio
                LEFT JOIN temporadas t  ON e.id_temporada = t.id_temporada
                LEFT JOIN contenido  c2 ON t.id_contenido = c2.id_contenido
                JOIN contenido c        ON NVL(c1.id_contenido, c2.id_contenido) = c.id_contenido
                JOIN perfiles  p        ON r.id_perfil    = p.id_perfil
                JOIN usuarios  u        ON p.id_usuario   = u.id_usuario
                WHERE UPPER(u.ciudad) = UPPER(?)
                GROUP BY c.titulo
                ORDER BY total_reproducciones DESC
            ) WHERE ROWNUM <= 10
            """;
        return jdbc.queryForList(sql, ciudad);
    }

    /** 3.1.1b — Ingresos por plan en un mes/año */
    public List<Map<String, Object>> ingresosPorPlan(String mes, String anio) {
        String sql = """
            SELECT pl.nombre AS plan, SUM(pa.monto) AS total_ingresos
            FROM pagos pa
            JOIN usuarios u ON pa.id_usuario = u.id_usuario
            JOIN planes pl  ON u.id_plan     = pl.id_plan
            WHERE TO_CHAR(pa.fecha_pago, 'MM')   = ?
              AND TO_CHAR(pa.fecha_pago, 'YYYY') = ?
              AND pa.estado_pago = 'EXITOSO'
            GROUP BY pl.nombre
            ORDER BY total_ingresos DESC
            """;
        return jdbc.queryForList(sql, mes, anio);
    }

    /** 3.1.1c — Calificación promedio por categoría para un género */
    public List<Map<String, Object>> calificacionPorGenero(String genero) {
        String sql = """
            SELECT cat.nombre AS categoria,
                   ROUND(AVG(cal.estrellas), 2) AS promedio_calificacion
            FROM calificaciones cal
            JOIN contenido       cont ON cal.id_contenido  = cont.id_contenido
            JOIN categorias      cat  ON cont.id_categoria = cat.id_categoria
            JOIN contenido_genero cg  ON cont.id_contenido = cg.id_contenido
            JOIN generos         gen  ON cg.id_genero      = gen.id_genero
            WHERE UPPER(gen.nombre) = UPPER(?)
            GROUP BY cat.nombre
            ORDER BY promedio_calificacion DESC
            """;
        return jdbc.queryForList(sql, genero);
    }

    /** 3.1.2a — PIVOT: usuarios activos por ciudad × plan */
    public List<Map<String, Object>> pivotCiudadesPlan() {
        String sql = """
            SELECT *
            FROM (
                SELECT u.ciudad, p.nombre AS plan
                FROM usuarios u
                JOIN planes p ON u.id_plan = p.id_plan
                WHERE u.estado_cuenta = 'ACTIVO'
            )
            PIVOT (
                COUNT(*) FOR plan IN (
                    'Básico'   AS BASICO,
                    'Estándar' AS ESTANDAR,
                    'Premium'  AS PREMIUM
                )
            )
            ORDER BY ciudad
            """;
        return jdbc.queryForList(sql);
    }

    /** 3.1.2b — PIVOT: reproducciones por categoría × dispositivo */
    public List<Map<String, Object>> pivotCategoriasDispositivo() {
        String sql = """
            SELECT *
            FROM (
                SELECT cat.nombre AS categoria, r.dispositivo
                FROM reproducciones r
                LEFT JOIN contenido  c  ON r.id_contenido  = c.id_contenido
                LEFT JOIN episodios  e  ON r.id_episodio   = e.id_episodio
                LEFT JOIN temporadas t  ON e.id_temporada  = t.id_temporada
                LEFT JOIN contenido  c2 ON t.id_contenido  = c2.id_contenido
                JOIN categorias cat ON NVL(c.id_categoria, c2.id_categoria) = cat.id_categoria
            )
            PIVOT (
                COUNT(*) FOR dispositivo IN (
                    'CELULAR'    AS CELULAR,
                    'TABLET'     AS TABLET,
                    'TV'         AS TV,
                    'COMPUTADOR' AS COMPUTADOR
                )
            )
            ORDER BY categoria
            """;
        return jdbc.queryForList(sql);
    }

    /** 3.1.3a — ROLLUP: ingresos por ciudad y plan con subtotales */
    public List<Map<String, Object>> rollupIngresos() {
        String sql = """
            SELECT
                NVL(u.ciudad, '** TOTAL **')  AS ciudad,
                NVL(p.nombre, '** SUBTOTAL **') AS plan,
                SUM(pa.monto)                  AS ingresos,
                GROUPING(u.ciudad)             AS es_subtotal_ciudad,
                GROUPING(p.nombre)             AS es_gran_total
            FROM pagos pa
            JOIN usuarios u ON pa.id_usuario = u.id_usuario
            JOIN planes   p ON u.id_plan     = p.id_plan
            WHERE pa.estado_pago = 'EXITOSO'
            GROUP BY ROLLUP(u.ciudad, p.nombre)
            ORDER BY u.ciudad NULLS LAST, p.nombre NULLS LAST
            """;
        return jdbc.queryForList(sql);
    }

    /** 3.1.3b — CUBE: reproducciones por categoría y dispositivo */
    public List<Map<String, Object>> cubeReproducciones() {
        String sql = """
            SELECT
                NVL(cat.nombre,    '** TOTAL **') AS categoria,
                NVL(r.dispositivo, '** TOTAL **') AS dispositivo,
                COUNT(*)                           AS total,
                GROUPING(cat.nombre)               AS es_total_categoria,
                GROUPING(r.dispositivo)            AS es_total_dispositivo
            FROM reproducciones r
            LEFT JOIN contenido  c  ON r.id_contenido  = c.id_contenido
            LEFT JOIN episodios  e  ON r.id_episodio   = e.id_episodio
            LEFT JOIN temporadas t  ON e.id_temporada  = t.id_temporada
            LEFT JOIN contenido  c2 ON t.id_contenido  = c2.id_contenido
            JOIN categorias cat ON NVL(c.id_categoria, c2.id_categoria) = cat.id_categoria
            GROUP BY CUBE(cat.nombre, r.dispositivo)
            ORDER BY es_total_categoria DESC, es_total_dispositivo DESC, categoria, dispositivo
            """;
        return jdbc.queryForList(sql);
    }

    /** 3.1.3c — GROUPING SETS: totales por categoría y por ciudad */
    public List<Map<String, Object>> groupingSetsConsumo() {
        String sql = """
            SELECT
                u.ciudad,
                cat.nombre                       AS categoria,
                COUNT(r.id_reproduccion)         AS total_reproducciones
            FROM reproducciones r
            LEFT JOIN contenido  c  ON r.id_contenido  = c.id_contenido
            LEFT JOIN episodios  e  ON r.id_episodio   = e.id_episodio
            LEFT JOIN temporadas t  ON e.id_temporada  = t.id_temporada
            LEFT JOIN contenido  c2 ON t.id_contenido  = c2.id_contenido
            JOIN categorias cat ON NVL(c.id_categoria, c2.id_categoria) = cat.id_categoria
            JOIN perfiles   p   ON r.id_perfil   = p.id_perfil
            JOIN usuarios   u   ON p.id_usuario  = u.id_usuario
            GROUP BY GROUPING SETS (cat.nombre, u.ciudad)
            ORDER BY ciudad NULLS LAST, categoria NULLS LAST
            """;
        return jdbc.queryForList(sql);
    }

    /** 3.1.4a — Vista materializada: contenido más popular */
    public List<Map<String, Object>> mvContenidoPopular() {
        return jdbc.queryForList("""
            SELECT id_contenido, titulo,
                   total_reproducciones,
                   ROUND(calif_promedio, 2) AS calif_promedio
            FROM mv_contenido_popular
            ORDER BY total_reproducciones DESC, calif_promedio DESC
            FETCH FIRST 20 ROWS ONLY
            """);
    }

    /** 3.1.4b — Vista materializada: ingresos mensuales */
    public List<Map<String, Object>> mvIngresosMensuales() {
        return jdbc.queryForList("""
            SELECT ciudad, plan,
                   TO_CHAR(mes, 'MM/YYYY') AS periodo,
                   total_ingresos
            FROM mv_ingresos_mensuales
            ORDER BY mes DESC, total_ingresos DESC
            """);
    }

    // ── Núcleo 2 ────────────────────────────────────────────────────────────

    /** 3.2.1a — Usuarios morosos (>30 días sin pago) */
    public List<Map<String, Object>> usuariosMorosos() {
        String sql = """
            SELECT u.nombre || ' ' || u.apellido AS nombre_completo,
                   u.email,
                   pl.nombre                     AS plan,
                   pl.precio_mensual,
                   TRUNC(SYSDATE - NVL(u.fecha_ultimo_pago, u.fecha_registro)) AS dias_mora
            FROM usuarios u
            JOIN planes pl ON u.id_plan = pl.id_plan
            WHERE u.estado_cuenta = 'ACTIVO'
              AND NVL(u.fecha_ultimo_pago, u.fecha_registro) < SYSDATE - 30
            ORDER BY dias_mora DESC
            """;
        return jdbc.queryForList(sql);
    }

    /** 3.2.1b — Popularidad de contenidos (reproducciones completas ≥ 90%) */
    public List<Map<String, Object>> popularidadContenidos() {
        String sql = """
            SELECT c.titulo,
                   c.popularidad AS reproducciones_completas
            FROM contenido c
            ORDER BY c.popularidad DESC
            FETCH FIRST 20 ROWS ONLY
            """;
        return jdbc.queryForList(sql);
    }

    /** 3.2.3a — FN_CALCULAR_MONTO para un usuario */
    public List<Map<String, Object>> calcularMonto(Long idUsuario) {
        String sql = """
            SELECT u.nombre || ' ' || u.apellido AS usuario,
                   pl.nombre                     AS plan,
                   pl.precio_mensual             AS precio_base,
                   fn_calcular_monto(u.id_usuario) AS monto_a_cobrar
            FROM usuarios u
            JOIN planes pl ON u.id_plan = pl.id_plan
            WHERE u.id_usuario = ?
            """;
        return jdbc.queryForList(sql, idUsuario);
    }

    /** 3.2.3b — FN_CONTENIDO_RECOMENDADO para un perfil */
    public List<Map<String, Object>> contenidoRecomendado(Long idPerfil) {
        // Usamos NVL para que si la función retorna NULL o lanza NO_DATA_FOUND
        // devolvamos un mensaje amigable en lugar de propagar el error
        String sql = """
            SELECT p.nombre AS perfil,
                   NVL(
                       fn_contenido_recomendado(p.id_perfil),
                       'Sin recomendación disponible'
                   ) AS recomendacion
            FROM perfiles p
            WHERE p.id_perfil = ?
            """;
        return jdbc.queryForList(sql, idPerfil);
    }
}
