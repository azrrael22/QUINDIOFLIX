-- =============================================================================
-- PROYECTO FINAL: QUINDIOFLIX
-- BASES DE DATOS II — UNIVERSIDAD DEL QUINDÍO — SEMESTRE 2026-1
-- NÚCLEO 2: PL/SQL — Procedimientos almacenados y disparadores
-- =============================================================================
-- Requiere que 01_quindioflix_schema.sql y 02_quindioflix_datos.sql
-- hayan sido ejecutados previamente.
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- =============================================================================
-- PASO PREVIO: Agregar columna popularidad a CONTENIDO
-- (usada por el cursor CUR_POPULARIDAD)
-- =============================================================================
ALTER TABLE contenido ADD popularidad NUMBER DEFAULT 0 NOT NULL;

COMMENT ON COLUMN contenido.popularidad IS
    'Contador de reproducciones completas (porcentaje_avance >= 90%). Actualizado por CUR_POPULARIDAD';


-- =============================================================================
-- 3.2.4 EXCEPCIONES PERSONALIZADAS
-- Se definen como paquete para que los SPs y la aplicación las reutilicen.
-- =============================================================================
CREATE OR REPLACE PACKAGE qflix_excepciones AS
    -- -20001: email ya registrado en USUARIOS
    e_email_duplicado    EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_email_duplicado, -20001);

    -- -20002: el id_plan recibido no existe en PLANES
    e_plan_invalido      EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_plan_invalido, -20002);

    -- -20003: el usuario tiene más perfiles de los que permite el nuevo plan
    e_perfiles_excedidos EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_perfiles_excedidos, -20003);
END qflix_excepciones;
/


-- =============================================================================
-- 3.2.1 CURSORES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- a) CUR_MOROSOS
--    Recorre todos los usuarios cuya suscripción está vencida (más de 30 días
--    sin pago exitoso o sin pago registrado) y genera un reporte con nombre,
--    email, plan, días de mora y monto adeudado.
-- -----------------------------------------------------------------------------
DECLARE
    CURSOR cur_morosos IS
        SELECT u.id_usuario,
               u.nombre || ' ' || u.apellido  AS nombre_completo,
               u.email,
               pl.nombre                       AS plan,
               pl.precio_mensual,
               TRUNC(SYSDATE - NVL(u.fecha_ultimo_pago, u.fecha_registro)) AS dias_mora
        FROM   usuarios u
        JOIN   planes pl ON u.id_plan = pl.id_plan
        WHERE  u.estado_cuenta = 'ACTIVO'
          AND  NVL(u.fecha_ultimo_pago, u.fecha_registro) < SYSDATE - 30
        ORDER BY dias_mora DESC;

    v_rec   cur_morosos%ROWTYPE;
    v_total NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== REPORTE DE USUARIOS MOROSOS ===');
    DBMS_OUTPUT.PUT_LINE(RPAD('Nombre',30) || RPAD('Email',35) ||
                         RPAD('Plan',10) || RPAD('Días mora',12) || 'Monto adeudado');
    DBMS_OUTPUT.PUT_LINE(RPAD('-',100,'-'));

    OPEN cur_morosos;
    LOOP
        FETCH cur_morosos INTO v_rec;
        EXIT WHEN cur_morosos%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_rec.nombre_completo, 30) ||
            RPAD(v_rec.email, 35) ||
            RPAD(v_rec.plan, 10) ||
            RPAD(v_rec.dias_mora, 12) ||
            TO_CHAR(v_rec.precio_mensual, 'FM$999,999,990.00')
        );
    END LOOP;
    v_total := cur_morosos%ROWCOUNT;
    CLOSE cur_morosos;

    DBMS_OUTPUT.PUT_LINE('Total morosos encontrados: ' || v_total);
END;
/


-- -----------------------------------------------------------------------------
-- b) CUR_POPULARIDAD
--    Recorre el catálogo y para cada contenido calcula cuántas reproducciones
--    completas (porcentaje_avance >= 90%) ha tenido y actualiza popularidad.
-- -----------------------------------------------------------------------------
DECLARE
    CURSOR cur_popularidad IS
        SELECT c.id_contenido,
               c.titulo,
               COUNT(r.id_reproduccion) AS reproducciones_completas
        FROM   contenido c
        LEFT JOIN reproducciones r
               ON  r.porcentaje_avance >= 90
               AND (r.id_contenido = c.id_contenido
                    OR r.id_episodio IN (
                           SELECT e.id_episodio
                           FROM   episodios e
                           JOIN   temporadas t ON e.id_temporada = t.id_temporada
                           WHERE  t.id_contenido = c.id_contenido
                       ))
        GROUP BY c.id_contenido, c.titulo;

    v_rec cur_popularidad%ROWTYPE;
    v_total NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ACTUALIZANDO POPULARIDAD DE CONTENIDOS ===');

    OPEN cur_popularidad;
    LOOP
        FETCH cur_popularidad INTO v_rec;
        EXIT WHEN cur_popularidad%NOTFOUND;

        UPDATE contenido
           SET popularidad = v_rec.reproducciones_completas
         WHERE id_contenido = v_rec.id_contenido;

        v_total := v_total + 1;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_rec.titulo, 50) || ' -> ' || v_rec.reproducciones_completas || ' reprod. completas'
        );
    END LOOP;
    CLOSE cur_popularidad;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Contenidos actualizados: ' || v_total);
END;
/


-- =============================================================================
-- 3.2.3 FUNCIONES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- a) FN_CALCULAR_MONTO
--    Retorna el monto a cobrar en el próximo mes considerando:
--      - Precio base del plan
--      - 10% de descuento si antigüedad > 12 meses
--      - 15% de descuento si antigüedad > 24 meses
--      - 5% adicional si tiene al menos un referido con cuenta ACTIVA
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_calcular_monto(p_id_usuario IN NUMBER)
    RETURN NUMBER
IS
    v_precio_base     planes.precio_mensual%TYPE;
    v_fecha_registro  usuarios.fecha_registro%TYPE;
    v_referidos_activos NUMBER;
    v_meses_antiguedad  NUMBER;
    v_descuento         NUMBER := 0;
    v_monto_final       NUMBER;
BEGIN
    -- Obtener precio del plan actual y fecha de registro
    SELECT pl.precio_mensual, u.fecha_registro
    INTO   v_precio_base, v_fecha_registro
    FROM   usuarios u
    JOIN   planes pl ON u.id_plan = pl.id_plan
    WHERE  u.id_usuario = p_id_usuario;

    -- Calcular antigüedad en meses
    v_meses_antiguedad := MONTHS_BETWEEN(SYSDATE, v_fecha_registro);

    -- Descuento por antigüedad (se aplica el mayor)
    IF v_meses_antiguedad > 24 THEN
        v_descuento := 15;
    ELSIF v_meses_antiguedad > 12 THEN
        v_descuento := 10;
    END IF;

    -- Descuento adicional del 5% si tiene referidos activos
    SELECT COUNT(*)
    INTO   v_referidos_activos
    FROM   usuarios
    WHERE  id_referido_por = p_id_usuario
      AND  estado_cuenta   = 'ACTIVO';

    IF v_referidos_activos > 0 THEN
        v_descuento := v_descuento + 5;
    END IF;

    -- Calcular monto final
    v_monto_final := v_precio_base * (1 - v_descuento / 100);

    RETURN ROUND(v_monto_final, 2);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'Usuario ' || p_id_usuario || ' no encontrado.');
END fn_calcular_monto;
/


-- -----------------------------------------------------------------------------
-- b) FN_CONTENIDO_RECOMENDADO
--    Retorna el título del contenido no reproducido aún por el perfil,
--    cuyo género sea el más frecuente en las reproducciones del perfil.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_contenido_recomendado(p_id_perfil IN NUMBER)
    RETURN VARCHAR2
IS
    v_titulo    contenido.titulo%TYPE;
    v_id_genero generos.id_genero%TYPE;
BEGIN
    -- Identificar el género más reproducido por el perfil
    SELECT id_genero
    INTO   v_id_genero
    FROM (
        SELECT cg.id_genero, COUNT(*) AS total
        FROM   reproducciones r
        JOIN   contenido c  ON c.id_contenido = r.id_contenido   -- reproducciones directas
        JOIN   contenido_genero cg ON cg.id_contenido = c.id_contenido
        WHERE  r.id_perfil = p_id_perfil
        UNION ALL
        SELECT cg2.id_genero, COUNT(*) AS total
        FROM   reproducciones r2
        JOIN   episodios  e  ON e.id_episodio = r2.id_episodio   -- reproducciones de episodios
        JOIN   temporadas t  ON t.id_temporada = e.id_temporada
        JOIN   contenido_genero cg2 ON cg2.id_contenido = t.id_contenido
        WHERE  r2.id_perfil = p_id_perfil
        GROUP BY cg2.id_genero
    )
    GROUP BY id_genero
    ORDER BY SUM(total) DESC
    FETCH FIRST 1 ROWS ONLY;

    -- Buscar el contenido más popular de ese género no reproducido por el perfil
    SELECT titulo
    INTO   v_titulo
    FROM (
        SELECT c.titulo, c.popularidad
        FROM   contenido c
        JOIN   contenido_genero cg ON cg.id_contenido = c.id_contenido
        WHERE  cg.id_genero = v_id_genero
          -- Excluir contenido ya reproducido directamente
          AND  c.id_contenido NOT IN (
                   SELECT r.id_contenido
                   FROM   reproducciones r
                   WHERE  r.id_perfil = p_id_perfil
                     AND  r.id_contenido IS NOT NULL
               )
          -- Excluir series cuyos episodios ya se reprodujeron
          AND  c.id_contenido NOT IN (
                   SELECT t.id_contenido
                   FROM   reproducciones r2
                   JOIN   episodios  e ON e.id_episodio = r2.id_episodio
                   JOIN   temporadas t ON t.id_temporada = e.id_temporada
                   WHERE  r2.id_perfil = p_id_perfil
               )
        ORDER BY c.popularidad DESC
    )
    WHERE ROWNUM = 1;

    RETURN v_titulo;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Sin recomendación disponible';
END fn_contenido_recomendado;
/


-- =============================================================================
-- 3.2.2 PROCEDIMIENTOS ALMACENADOS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- a) SP_REGISTRAR_USUARIO
--    Recibe los datos del nuevo usuario y el id del plan elegido.
--    Valida email único (-20001) y plan válido (-20002).
--    Crea la cuenta, el perfil ADULTO por defecto y el primer pago PENDIENTE.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_registrar_usuario(
    p_nombre          IN usuarios.nombre%TYPE,
    p_apellido        IN usuarios.apellido%TYPE,
    p_email           IN usuarios.email%TYPE,
    p_telefono        IN usuarios.telefono%TYPE,
    p_fecha_nac       IN usuarios.fecha_nacimiento%TYPE,
    p_ciudad          IN usuarios.ciudad%TYPE,
    p_id_plan         IN usuarios.id_plan%TYPE,
    p_id_referido_por IN usuarios.id_referido_por%TYPE DEFAULT NULL,
    p_metodo_pago     IN pagos.metodo_pago%TYPE        DEFAULT 'PSE'
)
IS
    v_id_usuario  usuarios.id_usuario%TYPE;
    v_id_perfil   perfiles.id_perfil%TYPE;
    v_id_pago     pagos.id_pago%TYPE;
    v_precio      planes.precio_mensual%TYPE;
    v_count_email NUMBER;
    v_count_plan  NUMBER;
BEGIN
    -- Validar que el email no exista
    SELECT COUNT(*) INTO v_count_email
    FROM   usuarios
    WHERE  email = p_email;

    IF v_count_email > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El email ' || p_email || ' ya está registrado.');
    END IF;

    -- Validar que el plan exista
    SELECT COUNT(*), MAX(precio_mensual)
    INTO   v_count_plan, v_precio
    FROM   planes
    WHERE  id_plan = p_id_plan;

    IF v_count_plan = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El plan con id=' || p_id_plan || ' no existe.');
    END IF;

    -- Insertar usuario
    v_id_usuario := seq_usuarios.NEXTVAL;
    INSERT INTO usuarios (
        id_usuario, nombre, apellido, email, telefono,
        fecha_nacimiento, ciudad, id_plan, fecha_registro,
        estado_cuenta, fecha_ultimo_pago, id_referido_por
    ) VALUES (
        v_id_usuario, p_nombre, p_apellido, p_email, p_telefono,
        p_fecha_nac, p_ciudad, p_id_plan, SYSDATE,
        'ACTIVO', NULL, p_id_referido_por
    );

    -- Crear perfil ADULTO predeterminado
    v_id_perfil := seq_perfiles.NEXTVAL;
    INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo)
    VALUES (v_id_perfil, v_id_usuario, p_nombre, NULL, 'ADULTO');

    -- Registrar primer pago como PENDIENTE
    v_id_pago := seq_pagos.NEXTVAL;
    INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
    VALUES (v_id_pago, v_id_usuario, SYSDATE, v_precio, 0, p_metodo_pago, 'PENDIENTE');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Usuario registrado correctamente. ID=' || v_id_usuario ||
                         ', Perfil ID=' || v_id_perfil || ', Pago ID=' || v_id_pago);

EXCEPTION
    WHEN qflix_excepciones.e_email_duplicado THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[ERROR -20001] ' || SQLERRM);
        RAISE;
    WHEN qflix_excepciones.e_plan_invalido THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[ERROR -20002] ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[ERROR INESPERADO] ' || SQLCODE || ': ' || SQLERRM);
        RAISE;
END sp_registrar_usuario;
/


-- -----------------------------------------------------------------------------
-- b) SP_CAMBIAR_PLAN
--    Recibe el id del usuario y el id del nuevo plan.
--    Valida que el nuevo plan permita la cantidad de perfiles actuales.
--    Actualiza el plan y registra el cambio.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_cambiar_plan(
    p_id_usuario IN usuarios.id_usuario%TYPE,
    p_id_plan_nuevo IN planes.id_plan%TYPE
)
IS
    v_max_perfiles_nuevo planes.max_perfiles%TYPE;
    v_perfiles_actuales  NUMBER;
    v_plan_nuevo_nombre  planes.nombre%TYPE;
    v_plan_actual_nombre planes.nombre%TYPE;
BEGIN
    -- Obtener datos del plan nuevo
    SELECT max_perfiles, nombre
    INTO   v_max_perfiles_nuevo, v_plan_nuevo_nombre
    FROM   planes
    WHERE  id_plan = p_id_plan_nuevo;

    -- Contar perfiles actuales del usuario
    SELECT COUNT(*)
    INTO   v_perfiles_actuales
    FROM   perfiles
    WHERE  id_usuario = p_id_usuario;

    -- Obtener nombre del plan actual
    SELECT pl.nombre INTO v_plan_actual_nombre
    FROM   usuarios u JOIN planes pl ON u.id_plan = pl.id_plan
    WHERE  u.id_usuario = p_id_usuario;

    -- Validar que el nuevo plan soporte los perfiles existentes
    IF v_perfiles_actuales > v_max_perfiles_nuevo THEN
        RAISE_APPLICATION_ERROR(-20003,
            'No se puede cambiar al plan "' || v_plan_nuevo_nombre ||
            '" (máx. ' || v_max_perfiles_nuevo || ' perfiles). ' ||
            'El usuario tiene ' || v_perfiles_actuales || ' perfiles activos.');
    END IF;

    -- Actualizar el plan
    UPDATE usuarios
       SET id_plan = p_id_plan_nuevo
     WHERE id_usuario = p_id_usuario;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Plan cambiado de "' || v_plan_actual_nombre ||
                         '" a "' || v_plan_nuevo_nombre ||
                         '" para usuario ID=' || p_id_usuario);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Plan o usuario no encontrado.');
    WHEN qflix_excepciones.e_perfiles_excedidos THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[ERROR -20003] ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[ERROR INESPERADO] ' || SQLCODE || ': ' || SQLERRM);
        RAISE;
END sp_cambiar_plan;
/


-- -----------------------------------------------------------------------------
-- c) SP_REPORTE_CONSUMO
--    Recibe un id de usuario y un rango de fechas. Genera un reporte detallado
--    con las reproducciones de cada perfil, agrupadas por categoría, con
--    totales de tiempo consumido en minutos.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_reporte_consumo(
    p_id_usuario IN usuarios.id_usuario%TYPE,
    p_fecha_ini  IN DATE,
    p_fecha_fin  IN DATE
)
IS
    -- Cursor que resuelve la cadena episodio->temporada->contenido->categoría
    CURSOR cur_consumo IS
        SELECT
            pf.nombre                          AS perfil,
            cat.nombre                         AS categoria,
            NVL(c_dir.titulo, c_ep.titulo)     AS titulo_contenido,
            r.dispositivo,
            r.porcentaje_avance,
            ROUND(
                (CAST(r.fecha_hora_fin AS DATE) - CAST(r.fecha_hora_inicio AS DATE)) * 1440
            , 1)                               AS minutos_vistos
        FROM   reproducciones r
        JOIN   perfiles pf  ON pf.id_perfil = r.id_perfil
        -- Ruta directa (película, documental, música)
        LEFT JOIN contenido  c_dir  ON c_dir.id_contenido = r.id_contenido
        LEFT JOIN categorias cat_d  ON cat_d.id_categoria = c_dir.id_categoria
        -- Ruta por episodio (serie, podcast)
        LEFT JOIN episodios  ep     ON ep.id_episodio = r.id_episodio
        LEFT JOIN temporadas tm     ON tm.id_temporada = ep.id_temporada
        LEFT JOIN contenido  c_ep   ON c_ep.id_contenido = tm.id_contenido
        LEFT JOIN categorias cat_e  ON cat_e.id_categoria = c_ep.id_categoria
        -- Categoría unificada
        JOIN categorias cat ON cat.id_categoria = NVL(cat_d.id_categoria, cat_e.id_categoria)
        WHERE  pf.id_usuario = p_id_usuario
          AND  CAST(r.fecha_hora_inicio AS DATE) BETWEEN p_fecha_ini AND p_fecha_fin
          AND  r.fecha_hora_fin IS NOT NULL
        ORDER BY pf.nombre, cat.nombre;

    v_perfil_ant    VARCHAR2(50) := '';
    v_cat_ant       VARCHAR2(30) := '';
    v_total_cat     NUMBER       := 0;
    v_total_perfil  NUMBER       := 0;
    v_total_global  NUMBER       := 0;
    v_nombre_usu    VARCHAR2(200);
BEGIN
    -- Encabezado
    SELECT nombre || ' ' || apellido INTO v_nombre_usu
    FROM   usuarios WHERE id_usuario = p_id_usuario;

    DBMS_OUTPUT.PUT_LINE('=== REPORTE DE CONSUMO: ' || v_nombre_usu || ' ===');
    DBMS_OUTPUT.PUT_LINE('Periodo: ' || TO_CHAR(p_fecha_ini,'DD/MM/YYYY') ||
                         ' al '     || TO_CHAR(p_fecha_fin, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE(RPAD('-',90,'-'));

    FOR v_rec IN cur_consumo LOOP

        -- Ruptura de control: nuevo perfil
        IF v_rec.perfil <> v_perfil_ant AND v_perfil_ant <> '' THEN
            DBMS_OUTPUT.PUT_LINE('   Subtotal categoría [' || v_cat_ant || ']: ' ||
                                 v_total_cat || ' min');
            DBMS_OUTPUT.PUT_LINE('  TOTAL PERFIL [' || v_perfil_ant || ']: ' ||
                                 v_total_perfil || ' min');
            DBMS_OUTPUT.PUT_LINE(RPAD('-',90,'-'));
            v_total_cat    := 0;
            v_total_perfil := 0;
        END IF;

        -- Ruptura de control: nueva categoría
        IF v_rec.categoria <> v_cat_ant AND v_cat_ant <> '' AND v_rec.perfil = v_perfil_ant THEN
            DBMS_OUTPUT.PUT_LINE('   Subtotal categoría [' || v_cat_ant || ']: ' ||
                                 v_total_cat || ' min');
            v_total_cat := 0;
        END IF;

        -- Imprimir fila
        DBMS_OUTPUT.PUT_LINE(
            '  ' || RPAD(v_rec.perfil,15) ||
            ' | ' || RPAD(v_rec.categoria,12) ||
            ' | ' || RPAD(v_rec.titulo_contenido,35) ||
            ' | ' || RPAD(v_rec.dispositivo,12) ||
            ' | ' || NVL(v_rec.minutos_vistos,0) || ' min'
        );

        v_total_cat    := v_total_cat    + NVL(v_rec.minutos_vistos, 0);
        v_total_perfil := v_total_perfil + NVL(v_rec.minutos_vistos, 0);
        v_total_global := v_total_global + NVL(v_rec.minutos_vistos, 0);
        v_perfil_ant   := v_rec.perfil;
        v_cat_ant      := v_rec.categoria;
    END LOOP;

    -- Último grupo
    IF v_perfil_ant <> '' THEN
        DBMS_OUTPUT.PUT_LINE('   Subtotal categoría [' || v_cat_ant || ']: ' ||
                             v_total_cat || ' min');
        DBMS_OUTPUT.PUT_LINE('  TOTAL PERFIL [' || v_perfil_ant || ']: ' ||
                             v_total_perfil || ' min');
    END IF;

    DBMS_OUTPUT.PUT_LINE(RPAD('=',90,'='));
    DBMS_OUTPUT.PUT_LINE('TOTAL GLOBAL CONSUMIDO: ' || v_total_global || ' minutos');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR] Usuario ID=' || p_id_usuario || ' no encontrado.');
END sp_reporte_consumo;
/


-- =============================================================================
-- 3.2.5 DISPARADORES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- a) TRG_REPR_CUENTA_ACTIVA
--    BEFORE INSERT FOR EACH ROW en REPRODUCCIONES.
--    Verifica que el usuario propietario del perfil tenga estado_cuenta = 'ACTIVO'.
--    Si no, rechaza la inserción.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_repr_cuenta_activa
    BEFORE INSERT ON reproducciones
    FOR EACH ROW
DECLARE
    v_estado usuarios.estado_cuenta%TYPE;
BEGIN
    SELECT u.estado_cuenta
    INTO   v_estado
    FROM   perfiles pf
    JOIN   usuarios u ON u.id_usuario = pf.id_usuario
    WHERE  pf.id_perfil = :NEW.id_perfil;

    IF v_estado <> 'ACTIVO' THEN
        RAISE_APPLICATION_ERROR(-20011,
            'Reproducción rechazada: la cuenta del usuario está en estado "' ||
            v_estado || '". Solo cuentas ACTIVAS pueden reproducir.');
    END IF;
END trg_repr_cuenta_activa;
/


-- -----------------------------------------------------------------------------
-- b) TRG_PERF_MAX_PERFILES
--    BEFORE INSERT FOR EACH ROW en PERFILES.
--    Verifica que el usuario no supere el límite de perfiles de su plan.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_perf_max_perfiles
    BEFORE INSERT ON perfiles
    FOR EACH ROW
DECLARE
    v_max_perfiles  planes.max_perfiles%TYPE;
    v_perf_actuales NUMBER;
BEGIN
    -- Obtener máximo de perfiles según plan actual del usuario
    SELECT pl.max_perfiles
    INTO   v_max_perfiles
    FROM   usuarios u
    JOIN   planes pl ON pl.id_plan = u.id_plan
    WHERE  u.id_usuario = :NEW.id_usuario;

    -- Contar perfiles existentes
    SELECT COUNT(*)
    INTO   v_perf_actuales
    FROM   perfiles
    WHERE  id_usuario = :NEW.id_usuario;

    IF v_perf_actuales >= v_max_perfiles THEN
        RAISE_APPLICATION_ERROR(-20003,
            'Límite de perfiles alcanzado. El plan permite máximo ' ||
            v_max_perfiles || ' perfil(es). Cuenta actual: ' || v_perf_actuales || '.');
    END IF;
END trg_perf_max_perfiles;
/


-- -----------------------------------------------------------------------------
-- c) TRG_CAL_MIN_AVANCE
--    BEFORE INSERT FOR EACH ROW en CALIFICACIONES.
--    Verifica que el perfil haya reproducido el contenido al menos al 50%
--    antes de permitir la calificación.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_cal_min_avance
    BEFORE INSERT ON calificaciones
    FOR EACH ROW
DECLARE
    v_max_avance NUMBER;
BEGIN
    -- Busca la reproducción de mayor avance del perfil sobre ese contenido.
    -- Considera reproducciones directas y a través de episodios.
    SELECT MAX(avance)
    INTO   v_max_avance
    FROM (
        -- Reproducciones directas
        SELECT r.porcentaje_avance AS avance
        FROM   reproducciones r
        WHERE  r.id_perfil    = :NEW.id_perfil
          AND  r.id_contenido = :NEW.id_contenido
        UNION ALL
        -- Reproducciones de episodios (agrupadas como 100% si completaron un episodio)
        SELECT r2.porcentaje_avance AS avance
        FROM   reproducciones r2
        JOIN   episodios  e ON e.id_episodio = r2.id_episodio
        JOIN   temporadas t ON t.id_temporada = e.id_temporada
        WHERE  r2.id_perfil    = :NEW.id_perfil
          AND  t.id_contenido  = :NEW.id_contenido
    );

    IF NVL(v_max_avance, 0) < 50 THEN
        RAISE_APPLICATION_ERROR(-20012,
            'Calificación rechazada: se requiere haber reproducido al menos el 50% del contenido. ' ||
            'Avance máximo registrado: ' || NVL(v_max_avance, 0) || '%.');
    END IF;
END trg_cal_min_avance;
/


-- -----------------------------------------------------------------------------
-- d) TRG_PAGO_ACTUALIZAR_ESTADO
--    AFTER INSERT FOR EACH STATEMENT en PAGOS.
--    Después de insertar pagos, actualiza estado_cuenta='ACTIVO' y
--    fecha_ultimo_pago=SYSDATE para todos los usuarios con pagos EXITOSOS
--    recién insertados.
--    Se usa FOR EACH STATEMENT porque puede llegar un INSERT masivo en la
--    renovación mensual (TX_RENOVACION_MASIVA del Núcleo 3).
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_pago_actualizar_estado
    AFTER INSERT ON pagos
DECLARE
BEGIN
    -- Actualiza los usuarios que tienen pagos EXITOSOS recientes (del día)
    UPDATE usuarios u
       SET u.estado_cuenta     = 'ACTIVO',
           u.fecha_ultimo_pago = SYSDATE
     WHERE u.id_usuario IN (
               SELECT DISTINCT pa.id_usuario
               FROM   pagos pa
               WHERE  pa.estado_pago = 'EXITOSO'
                 AND  TRUNC(pa.fecha_pago) = TRUNC(SYSDATE)
           );

    DBMS_OUTPUT.PUT_LINE('[TRG_PAGO] Cuentas actualizadas a ACTIVO: ' || SQL%ROWCOUNT);
END trg_pago_actualizar_estado;
/


-- =============================================================================
-- BLOQUE DE PRUEBA
-- Descomentar para probar en SQL*Plus / SQL Developer
-- =============================================================================

/*
-- Prueba SP_REGISTRAR_USUARIO (caso válido)
BEGIN
    sp_registrar_usuario(
        p_nombre     => 'Prueba',
        p_apellido   => 'Nucleo2',
        p_email      => 'prueba.nucleo2@test.com',
        p_telefono   => '3001234567',
        p_fecha_nac  => DATE '1995-06-15',
        p_ciudad     => 'Bogotá',
        p_id_plan    => 1,
        p_metodo_pago => 'NEQUI'
    );
END;
/

-- Prueba SP_REGISTRAR_USUARIO (email duplicado — debe lanzar -20001)
BEGIN
    sp_registrar_usuario(
        p_nombre     => 'Prueba2',
        p_apellido   => 'Duplicada',
        p_email      => 'prueba.nucleo2@test.com',
        p_telefono   => '3007654321',
        p_fecha_nac  => DATE '1990-01-01',
        p_ciudad     => 'Cali',
        p_id_plan    => 2
    );
END;
/

-- Prueba FN_CALCULAR_MONTO
SELECT fn_calcular_monto(100) AS monto_usuario_100 FROM dual;

-- Prueba FN_CONTENIDO_RECOMENDADO
SELECT fn_contenido_recomendado(100) AS recomendado_perfil_100 FROM dual;

-- Prueba SP_CAMBIAR_PLAN (caso válido: subir de plan)
BEGIN
    sp_cambiar_plan(p_id_usuario => 100, p_id_plan_nuevo => 3);
END;
/

-- Prueba SP_REPORTE_CONSUMO
BEGIN
    sp_reporte_consumo(
        p_id_usuario => 100,
        p_fecha_ini  => DATE '2024-01-01',
        p_fecha_fin  => DATE '2026-12-31'
    );
END;
/
*/
