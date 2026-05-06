-- =============================================================================
-- V3: NÚCLEO 1 — FRAGMENTACIÓN DE REPRODUCCIONES Y VISTAS MATERIALIZADAS
-- QUINDIOFLIX | Bases de Datos II — Universidad del Quindío
-- Semestre 2026-1
-- =============================================================================
-- NOTA: Las secciones 3.1.1–3.1.3 NO se incluyen aquí porque Flyway no
--       las puede ejecutar; esas consultas se encuentran en:
--       ENTREGA_1/quindioflix_nucleo1.sql y se corren desde SQL Developer/SQLcl.
--
-- PRE-REQUISITOS (ejecutar como SYSTEM antes del primer flyway migrate):
--   GRANT CREATE TABLESPACE      TO quindioflix;
--   GRANT CREATE MATERIALIZED VIEW TO quindioflix;
--
-- ADVERTENCIA: El DROP TABLE de la sección 3.1.5 elimina los datos de V2.
--   Para repoblar en dev: flyway clean && flyway migrate (re-ejecuta V1→V2→V3).
-- =============================================================================

SET DEFINE OFF;

-- =============================================================================
-- 3.1.5 FRAGMENTACIÓN DE TABLAS (PARTICIONAMIENTO POR RANGO DE FECHAS)
-- Justificación: REPRODUCCIONES es la tabla de mayor volumen del sistema
-- (200+ registros iniciales, crecimiento diario constante). Particionar por
-- fecha_hora_inicio permite: (1) purgar datos históricos sin afectar particiones
-- activas, (2) mejorar rendimiento en consultas de historial reciente ya que
-- Oracle solo escanea la partición relevante, (3) facilitar el mantenimiento
-- (BACKUP, STATS) por periodos independientes.
-- =============================================================================

-- Tablespaces y datafiles dedicados por partición.
-- Ajustar la ruta de los datafiles según la instalación de Oracle.
CREATE TABLESPACE ts_repr_2024
    DATAFILE 'repr_2024.dbf'   SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE 500M;
CREATE TABLESPACE ts_repr_2025
    DATAFILE 'repr_2025.dbf'   SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE 500M;
CREATE TABLESPACE ts_repr_2026
    DATAFILE 'repr_2026.dbf'   SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE 500M;
CREATE TABLESPACE ts_repr_future
    DATAFILE 'repr_future.dbf' SIZE 20M AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

DROP TABLE reproducciones CASCADE CONSTRAINTS;

CREATE TABLE reproducciones (
    id_reproduccion   NUMBER        NOT NULL,
    id_perfil         NUMBER        NOT NULL,
    id_contenido      NUMBER        NULL,
    id_episodio       NUMBER        NULL,
    fecha_hora_inicio TIMESTAMP     DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_hora_fin    TIMESTAMP     NULL,
    dispositivo       VARCHAR2(15)  NOT NULL,
    porcentaje_avance NUMBER(5,2)   DEFAULT 0 NOT NULL,

    CONSTRAINT pk_reproducciones    PRIMARY KEY (id_reproduccion),
    CONSTRAINT ck_repr_disp         CHECK (dispositivo IN ('CELULAR','TABLET','TV','COMPUTADOR')),
    CONSTRAINT ck_repr_perc         CHECK (porcentaje_avance BETWEEN 0 AND 100),
    CONSTRAINT ck_repr_fin          CHECK (fecha_hora_fin IS NULL OR fecha_hora_fin > fecha_hora_inicio),
    CONSTRAINT ck_repr_exclu_mutua  CHECK (
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


-- =============================================================================
-- 3.1.4 VISTAS MATERIALIZADAS
-- =============================================================================

-- a) Contenido Más Popular: total de reproducciones y calificación promedio
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
CREATE MATERIALIZED VIEW mv_ingresos_mensuales
REFRESH COMPLETE ON DEMAND
AS
SELECT
    u.ciudad,
    pl.nombre              AS plan,
    TRUNC(pa.fecha_pago, 'MM') AS mes,
    SUM(pa.monto)          AS total_ingresos
FROM pagos pa
JOIN usuarios u  ON pa.id_usuario = u.id_usuario
JOIN planes   pl ON u.id_plan     = pl.id_plan
WHERE pa.estado_pago = 'EXITOSO'
GROUP BY u.ciudad, pl.nombre, TRUNC(pa.fecha_pago, 'MM');
