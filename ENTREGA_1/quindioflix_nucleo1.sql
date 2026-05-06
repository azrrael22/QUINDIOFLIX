-- =============================================================================
-- NÚCLEO 1: CONSULTAS AVANZADAS Y ALMACENAMIENTO
-- QUINDIOFLIX — CORREGIDO
-- =============================================================================

-- 3.1.1 CONSULTAS PARAMETRIZADAS

-- a) Top 10 contenido más reproducido en una ciudad específica
--    CORREGIDO: ahora cuenta también las reproducciones de episodios
--    (series y podcasts) resolviendo la cadena episodio -> temporada -> contenido.
SELECT * FROM (
    SELECT c.titulo, COUNT(r.id_reproduccion) AS total_reproducciones
    FROM reproducciones r
    LEFT JOIN contenido  c1 ON r.id_contenido = c1.id_contenido
    LEFT JOIN episodios  e  ON r.id_episodio  = e.id_episodio
    LEFT JOIN temporadas t  ON e.id_temporada = t.id_temporada
    LEFT JOIN contenido  c2 ON t.id_contenido = c2.id_contenido
    JOIN contenido c       ON NVL(c1.id_contenido, c2.id_contenido) = c.id_contenido
    JOIN perfiles  p       ON r.id_perfil    = p.id_perfil
    JOIN usuarios  u       ON p.id_usuario   = u.id_usuario
    WHERE u.ciudad = '&ciudad'
    GROUP BY c.titulo
    ORDER BY total_reproducciones DESC
) WHERE ROWNUM <= 10;

-- b) Ingresos por plan de suscripción en un mes y año específico
SELECT pl.nombre AS plan, SUM(pa.monto) AS total_ingresos
FROM pagos pa
JOIN usuarios u ON pa.id_usuario = u.id_usuario
JOIN planes pl  ON u.id_plan     = pl.id_plan
WHERE TO_CHAR(pa.fecha_pago, 'MM')   = '&mes'
  AND TO_CHAR(pa.fecha_pago, 'YYYY') = '&anio'
  AND pa.estado_pago = 'EXITOSO'        -- CORREGIDO: era 'exitoso'
GROUP BY pl.nombre;

-- c) Calificación promedio por categoría para un género específico
SELECT cat.nombre AS categoria, AVG(cal.estrellas) AS promedio_calificacion
FROM calificaciones cal
JOIN contenido       cont ON cal.id_contenido  = cont.id_contenido
JOIN categorias      cat  ON cont.id_categoria = cat.id_categoria
JOIN contenido_genero cg  ON cont.id_contenido = cg.id_contenido
JOIN generos         gen  ON cg.id_genero      = gen.id_genero
WHERE gen.nombre = '&genero'
GROUP BY cat.nombre;


-- =============================================================================
-- 3.1.2 TABLAS DE REFERENCIAS CRUZADAS — PIVOT / UNPIVOT
-- =============================================================================

-- a) PIVOT: Ciudades (filas) × Planes (columnas) con cantidad de usuarios activos
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
);

-- b) PIVOT: Categorías (filas) × Dispositivos (columnas) con total de reproducciones
--    CORREGIDO: valores del FOR IN en MAYÚSCULAS para coincidir con el CHECK constraint
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
        'CELULAR'    AS CEL,   -- CORREGIDO: era 'celular'
        'TABLET'     AS TAB,   -- CORREGIDO: era 'tablet'
        'TV'         AS TV,
        'COMPUTADOR' AS PC     -- CORREGIDO: era 'computador'
    )
);

-- c) UNPIVOT: Características de los planes como filas (Atributo, Valor)
SELECT plan, caracteristica, valor
FROM (
    SELECT nombre AS plan, max_pantallas, precio_mensual
    FROM planes
)
UNPIVOT (
    valor FOR caracteristica IN (
        max_pantallas   AS 'Pantallas Simultáneas',
        precio_mensual  AS 'Costo Mensual'
    )
);

-- d) UNPIVOT: Conteo de reproducciones por categoría desnormalizado a filas
--    (categoria, dispositivo, total). Útil para alimentar reportes en formato largo.
WITH conteo AS (
    SELECT
        cat.nombre AS categoria,
        SUM(CASE WHEN r.dispositivo = 'CELULAR'    THEN 1 ELSE 0 END) AS celular,
        SUM(CASE WHEN r.dispositivo = 'TABLET'     THEN 1 ELSE 0 END) AS tablet,
        SUM(CASE WHEN r.dispositivo = 'TV'         THEN 1 ELSE 0 END) AS tv,
        SUM(CASE WHEN r.dispositivo = 'COMPUTADOR' THEN 1 ELSE 0 END) AS computador
    FROM reproducciones r
    LEFT JOIN contenido  c  ON r.id_contenido  = c.id_contenido
    LEFT JOIN episodios  e  ON r.id_episodio   = e.id_episodio
    LEFT JOIN temporadas t  ON e.id_temporada  = t.id_temporada
    LEFT JOIN contenido  c2 ON t.id_contenido  = c2.id_contenido
    JOIN categorias cat ON NVL(c.id_categoria, c2.id_categoria) = cat.id_categoria
    GROUP BY cat.nombre
)
SELECT categoria, dispositivo, total_reproducciones
FROM conteo
UNPIVOT (
    total_reproducciones FOR dispositivo IN (
        celular    AS 'CELULAR',
        tablet     AS 'TABLET',
        tv         AS 'TV',
        computador AS 'COMPUTADOR'
    )
);


-- =============================================================================
-- 3.1.3 FUNCIONES AVANZADAS DEL GROUP BY
-- =============================================================================

-- a) ROLLUP: Ingresos por ciudad y plan con subtotales por ciudad y gran total
--    CORREGIDO: estado_pago = 'EXITOSO' (era 'exitoso')
SELECT
    u.ciudad,
    p.nombre AS plan,
    SUM(pa.monto) AS ingresos,
    GROUPING(u.ciudad)   AS es_subtotal_ciudad,
    GROUPING(p.nombre)   AS es_gran_total
FROM pagos pa
JOIN usuarios u ON pa.id_usuario = u.id_usuario
JOIN planes   p ON u.id_plan     = p.id_plan
WHERE pa.estado_pago = 'EXITOSO'   -- CORREGIDO: era 'exitoso'
GROUP BY ROLLUP(u.ciudad, p.nombre);

-- b) CUBE: Reproducciones por categoría y dispositivo con todas las combinaciones posibles
SELECT
    cat.nombre    AS categoria,
    r.dispositivo,
    COUNT(*)      AS total,
    GROUPING(cat.nombre)   AS es_total_categoria,
    GROUPING(r.dispositivo) AS es_total_dispositivo
FROM reproducciones r
LEFT JOIN contenido  c  ON r.id_contenido  = c.id_contenido
LEFT JOIN episodios  e  ON r.id_episodio   = e.id_episodio
LEFT JOIN temporadas t  ON e.id_temporada  = t.id_temporada
LEFT JOIN contenido  c2 ON t.id_contenido  = c2.id_contenido
JOIN categorias cat ON NVL(c.id_categoria, c2.id_categoria) = cat.id_categoria
GROUP BY CUBE(cat.nombre, r.dispositivo);

-- c) GROUPING SETS: Solo totales por categoría y por ciudad (sin detalle cruzado)
SELECT
    u.ciudad,
    cat.nombre AS categoria,
    COUNT(r.id_reproduccion) AS total_reproducciones
FROM reproducciones r
LEFT JOIN contenido  c  ON r.id_contenido  = c.id_contenido
LEFT JOIN episodios  e  ON r.id_episodio   = e.id_episodio
LEFT JOIN temporadas t  ON e.id_temporada  = t.id_temporada
LEFT JOIN contenido  c2 ON t.id_contenido  = c2.id_contenido
JOIN categorias cat ON NVL(c.id_categoria, c2.id_categoria) = cat.id_categoria
JOIN perfiles   p   ON r.id_perfil   = p.id_perfil
JOIN usuarios   u   ON p.id_usuario  = u.id_usuario
GROUP BY GROUPING SETS (cat.nombre, u.ciudad);


-- =============================================================================
-- 3.1.4 VISTAS MATERIALIZADAS
-- =============================================================================

-- a) Contenido Más Popular: total de reproducciones y calificación promedio
-- Nota: Requiere el privilegio CREATE MATERIALIZED VIEW
CREATE MATERIALIZED VIEW mv_contenido_popular
REFRESH COMPLETE ON DEMAND
AS
SELECT
    c.id_contenido,
    c.titulo,
    COUNT(DISTINCT r.id_reproduccion) AS total_reproducciones,
    AVG(cal.estrellas)                AS calif_promedio
FROM contenido c
LEFT JOIN reproducciones r   ON c.id_contenido = r.id_contenido
LEFT JOIN calificaciones cal ON c.id_contenido = cal.id_contenido
GROUP BY c.id_contenido, c.titulo;

-- b) Ingresos Mensuales por Ciudad y Plan
--    CORREGIDO: estado_pago = 'EXITOSO' (era 'exitoso')
CREATE MATERIALIZED VIEW mv_ingresos_mensuales
REFRESH COMPLETE ON DEMAND
AS
SELECT
    u.ciudad,
    pl.nombre              AS plan,
    TRUNC(pa.fecha_pago, 'MM') AS mes,
    SUM(pa.monto)          AS total_ingresos
FROM pagos pa
JOIN usuarios u ON pa.id_usuario = u.id_usuario
JOIN planes   pl ON u.id_plan    = pl.id_plan
WHERE pa.estado_pago = 'EXITOSO'   -- CORREGIDO: era 'exitoso'
GROUP BY u.ciudad, pl.nombre, TRUNC(pa.fecha_pago, 'MM');


-- =============================================================================
-- 3.1.5 FRAGMENTACIÓN DE TABLAS (PARTICIONAMIENTO POR RANGO DE FECHAS)
-- Justificación: REPRODUCCIONES es la tabla de mayor volumen del sistema
-- (200+ registros iniciales, crecimiento diario constante). Particionar por
-- fecha_hora_inicio permite: (1) purgar datos históricos sin afectar particiones
-- activas, (2) mejorar rendimiento en consultas de historial reciente ya que
-- Oracle solo escanea la partición relevante, (3) facilitar el mantenimiento
-- (BACKUP, STATS) por periodos independientes.
-- =============================================================================

DROP TABLE reproducciones CASCADE CONSTRAINTS;

-- Tablespaces y datafiles dedicados por partición.
-- Ejecutar como usuario con privilegio CREATE TABLESPACE (p.ej. SYSTEM).
-- Ajustar la ruta de los datafiles según la instalación de Oracle.
CREATE TABLESPACE ts_repr_2024
    DATAFILE 'repr_2024.dbf'   SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE 500M;
CREATE TABLESPACE ts_repr_2025
    DATAFILE 'repr_2025.dbf'   SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE 500M;
CREATE TABLESPACE ts_repr_2026
    DATAFILE 'repr_2026.dbf'   SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE 500M;
CREATE TABLESPACE ts_repr_future
    DATAFILE 'repr_future.dbf' SIZE 20M AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

CREATE TABLE reproducciones (
    id_reproduccion   NUMBER        NOT NULL,
    id_perfil         NUMBER        NOT NULL,
    id_contenido      NUMBER        NULL,
    id_episodio       NUMBER        NULL,
    fecha_hora_inicio TIMESTAMP     DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_hora_fin    TIMESTAMP     NULL,
    dispositivo       VARCHAR2(15)  NOT NULL,
    porcentaje_avance NUMBER(5,2)   DEFAULT 0 NOT NULL,

    CONSTRAINT pk_reproducciones     PRIMARY KEY (id_reproduccion),
    CONSTRAINT ck_repr_disp          CHECK (dispositivo IN ('CELULAR','TABLET','TV','COMPUTADOR')),
    CONSTRAINT ck_repr_perc          CHECK (porcentaje_avance BETWEEN 0 AND 100),
    CONSTRAINT ck_repr_fin           CHECK (fecha_hora_fin IS NULL OR fecha_hora_fin > fecha_hora_inicio),
    CONSTRAINT ck_repr_exclu_mutua   CHECK (
        (id_contenido IS NOT NULL AND id_episodio IS NULL) OR
        (id_contenido IS NULL     AND id_episodio IS NOT NULL)
    ),
    CONSTRAINT fk_repr_perf  FOREIGN KEY (id_perfil)    REFERENCES perfiles(id_perfil),
    CONSTRAINT fk_repr_cont  FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido),
    CONSTRAINT fk_repr_epi   FOREIGN KEY (id_episodio)  REFERENCES episodios(id_episodio)
)
PARTITION BY RANGE (fecha_hora_inicio) (
    PARTITION p_2024   VALUES LESS THAN (TIMESTAMP '2025-01-01 00:00:00') TABLESPACE ts_repr_2024,
    PARTITION p_2025   VALUES LESS THAN (TIMESTAMP '2026-01-01 00:00:00') TABLESPACE ts_repr_2025,
    PARTITION p_2026   VALUES LESS THAN (TIMESTAMP '2027-01-01 00:00:00') TABLESPACE ts_repr_2026,
    PARTITION p_future VALUES LESS THAN (MAXVALUE)                        TABLESPACE ts_repr_future
);
