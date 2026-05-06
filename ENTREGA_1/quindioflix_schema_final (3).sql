-- =============================================================================
-- PROYECTO FINAL: QUINDIOFLIX
-- BASES DE DATOS II - UNIVERSIDAD DEL QUINDIO
-- SEMESTRE 2026-1
-- =============================================================================

-- SCRIPT DE CREACIÓN DE TABLAS (SCHEMA) Y SECUENCIAS

-- 0. SECUENCIAS
CREATE SEQUENCE SEQ_PLANES         START WITH 1    NOCACHE;
CREATE SEQUENCE SEQ_DEPARTAMENTOS  START WITH 1    NOCACHE;
CREATE SEQUENCE SEQ_EMPLEADOS      START WITH 1    NOCACHE;
CREATE SEQUENCE SEQ_USUARIOS       START WITH 100  NOCACHE;
CREATE SEQUENCE SEQ_PERFILES       START WITH 100  NOCACHE;
CREATE SEQUENCE SEQ_CATEGORIAS     START WITH 1    NOCACHE;
CREATE SEQUENCE SEQ_GENEROS        START WITH 1    NOCACHE;
CREATE SEQUENCE SEQ_CONTENIDO      START WITH 100  NOCACHE;
CREATE SEQUENCE SEQ_TEMPORADAS     START WITH 100  NOCACHE;
CREATE SEQUENCE SEQ_EPISODIOS      START WITH 100  NOCACHE;
CREATE SEQUENCE SEQ_REPRODUCCIONES START WITH 1000 NOCACHE;
CREATE SEQUENCE SEQ_CALIFICACIONES START WITH 100  NOCACHE;
CREATE SEQUENCE SEQ_REPORTES       START WITH 100  NOCACHE;
CREATE SEQUENCE SEQ_PAGOS          START WITH 100  NOCACHE;

-- 1. PLANES DE SUSCRIPCIÓN
CREATE TABLE planes (

    id_plan        NUMBER        NOT NULL,

    nombre         VARCHAR2(20)  NOT NULL,
    precio_mensual NUMBER(10,2)  NOT NULL,
    calidad        VARCHAR2(5)   NOT NULL,
    max_pantallas  NUMBER(1)     NOT NULL,
    max_perfiles   NUMBER(1)     NOT NULL,

    CONSTRAINT pk_planes       PRIMARY KEY (id_plan),
    CONSTRAINT uq_plan_nombre  UNIQUE (nombre),
    CONSTRAINT ck_plan_nombre  CHECK (nombre IN ('Básico', 'Estándar', 'Premium')),
    CONSTRAINT ck_plan_calidad CHECK (calidad IN ('SD', 'HD', '4K')),
    CONSTRAINT ck_plan_precio  CHECK (precio_mensual > 0),
    CONSTRAINT ck_plan_pant    CHECK (max_pantallas IN (1, 2, 4)),
    CONSTRAINT ck_plan_perf    CHECK (max_perfiles IN (2, 3, 5))
);

COMMENT ON TABLE  planes               IS 'Catálogo de planes de suscripción: Básico, Estándar y Premium. Define límites de pantallas, perfiles y calidad de video';
COMMENT ON COLUMN planes.id_plan       IS 'PK. Identificador único del plan. Generado con SEQ_PLANES';
COMMENT ON COLUMN planes.nombre        IS 'Nombre del plan. Valores permitidos: Básico, Estándar, Premium. Único en el sistema';
COMMENT ON COLUMN planes.precio_mensual IS 'Precio mensual en pesos colombianos. Básico: 14900, Estándar: 24900, Premium: 34900. Siempre mayor a 0';
COMMENT ON COLUMN planes.calidad       IS 'Calidad máxima de video disponible. SD para Básico, HD para Estándar, 4K para Premium';
COMMENT ON COLUMN planes.max_pantallas IS 'Número máximo de reproducciones simultáneas permitidas por plan. Básico: 1, Estándar: 2, Premium: 4';
COMMENT ON COLUMN planes.max_perfiles  IS 'Número máximo de perfiles que puede crear el usuario según su plan. Básico: 2, Estándar: 3, Premium: 5';

-- 2. DEPARTAMENTOS
CREATE TABLE departamentos (

    id_departamento NUMBER       NOT NULL,

    nombre          VARCHAR2(50) NOT NULL,

    CONSTRAINT pk_departamentos PRIMARY KEY (id_departamento),
    CONSTRAINT uq_dept_nombre   UNIQUE (nombre),
    CONSTRAINT ck_dept_nombre   CHECK (nombre IN ('Tecnología', 'Contenido', 'Marketing', 'Soporte', 'Finanzas'))
);

COMMENT ON TABLE  departamentos                 IS 'Departamentos internos de QuindioFlix. Cada uno tiene un jefe que debe ser empleado del mismo departamento (RN-14)';
COMMENT ON COLUMN departamentos.id_departamento IS 'PK. Identificador único del departamento. Generado con SEQ_DEPARTAMENTOS';
COMMENT ON COLUMN departamentos.nombre          IS 'Nombre del departamento. Valores: Tecnología, Contenido, Marketing, Soporte, Finanzas. Único en el sistema';

-- 3. EMPLEADOS (Jerarquía reflexiva)
CREATE TABLE empleados (

    id_empleado        NUMBER        NOT NULL,

    nombre             VARCHAR2(100) NOT NULL,
    email              VARCHAR2(100) NOT NULL,
    cargo              VARCHAR2(50)  NOT NULL,
    fecha_contratacion DATE          NOT NULL,

    id_departamento    NUMBER        NOT NULL,
    id_supervisor      NUMBER        NULL,

    CONSTRAINT pk_empleados       PRIMARY KEY (id_empleado),
    CONSTRAINT uq_emp_email       UNIQUE (email),
    CONSTRAINT ck_emp_email       CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')),
    CONSTRAINT fk_emp_dept        FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento),
    CONSTRAINT fk_emp_supervisor  FOREIGN KEY (id_supervisor)   REFERENCES empleados(id_empleado)
);

COMMENT ON TABLE  empleados                  IS 'Personal de QuindioFlix. Incluye jerarquía reflexiva de supervisión intradepartamental (RN-15)';
COMMENT ON COLUMN empleados.id_empleado        IS 'PK. Identificador único del empleado. Generado con SEQ_EMPLEADOS';
COMMENT ON COLUMN empleados.nombre             IS 'Nombre completo del empleado';
COMMENT ON COLUMN empleados.email              IS 'Correo electrónico corporativo. Único en el sistema. Debe tener formato válido (ck_emp_email)';
COMMENT ON COLUMN empleados.cargo              IS 'Cargo del empleado en su departamento. Ej: Analista, Moderador, Gestor de Contenido';
COMMENT ON COLUMN empleados.fecha_contratacion IS 'Fecha de vinculación del empleado a la empresa. Validación de fecha no futura via trigger';
COMMENT ON COLUMN empleados.id_departamento    IS 'FK -> DEPARTAMENTOS. Departamento al que pertenece el empleado. No puede cambiar sin gestionar la supervisión';
COMMENT ON COLUMN empleados.id_supervisor      IS 'FK -> EMPLEADOS (reflexiva). Supervisor directo en el mismo departamento. NULL para el jefe máximo del departamento';

ALTER TABLE departamentos ADD (
    id_jefe NUMBER NULL
);

ALTER TABLE departamentos
    ADD CONSTRAINT fk_dept_jefe FOREIGN KEY (id_jefe) REFERENCES empleados(id_empleado);

COMMENT ON COLUMN departamentos.id_jefe IS 'FK -> EMPLEADOS. Empleado que dirige el departamento. Debe pertenecer al mismo departamento. NULL si aún no tiene jefe asignado';

-- 4. USUARIOS
CREATE TABLE usuarios (

    id_usuario        NUMBER        NOT NULL,

    nombre            VARCHAR2(100) NOT NULL,
    apellido          VARCHAR2(100) NOT NULL,
    email             VARCHAR2(150) NOT NULL,
    telefono          VARCHAR2(15)  NOT NULL,
    fecha_nacimiento  DATE          NOT NULL,
    ciudad            VARCHAR2(80)  NOT NULL,

    id_plan           NUMBER        NOT NULL,
    fecha_registro    DATE          NOT NULL,
    estado_cuenta     VARCHAR2(10)  NOT NULL,
    fecha_ultimo_pago DATE          NULL,

    id_referido_por   NUMBER        NULL,

    CONSTRAINT pk_usuarios     PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usu_email    UNIQUE (email),
    CONSTRAINT ck_usu_email    CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')),
    CONSTRAINT ck_usu_tel      CHECK (REGEXP_LIKE(telefono, '^\d{7,15}$')),
    CONSTRAINT ck_usu_estado   CHECK (estado_cuenta IN ('ACTIVO', 'INACTIVO', 'SUSPENDIDO')),
    CONSTRAINT fk_usu_plan       FOREIGN KEY (id_plan)         REFERENCES planes(id_plan),
    CONSTRAINT fk_usu_referido   FOREIGN KEY (id_referido_por) REFERENCES usuarios(id_usuario),
    CONSTRAINT ck_usu_no_self_ref CHECK (id_referido_por IS NULL OR id_referido_por != id_usuario)
);

ALTER TABLE usuarios MODIFY fecha_registro DATE DEFAULT SYSDATE NOT NULL;
ALTER TABLE usuarios MODIFY estado_cuenta  VARCHAR2(10) DEFAULT 'ACTIVO' NOT NULL;

COMMENT ON TABLE  usuarios                IS 'Suscriptores registrados en QuindioFlix. Cada usuario tiene plan, estado de cuenta y perfiles asociados';
COMMENT ON COLUMN usuarios.id_usuario     IS 'PK. Identificador único del usuario. Generado con SEQ_USUARIOS';
COMMENT ON COLUMN usuarios.nombre         IS 'Primer nombre del usuario';
COMMENT ON COLUMN usuarios.apellido       IS 'Primer apellido del usuario';
COMMENT ON COLUMN usuarios.email          IS 'Correo electrónico del usuario. Único en el sistema. Formato validado con ck_usu_email';
COMMENT ON COLUMN usuarios.telefono       IS 'Teléfono del usuario. Solo dígitos, mínimo 7 y máximo 15 caracteres (ck_usu_tel)';
COMMENT ON COLUMN usuarios.fecha_nacimiento IS 'Fecha de nacimiento';
COMMENT ON COLUMN usuarios.ciudad         IS 'Ciudad colombiana de residencia.';
COMMENT ON COLUMN usuarios.id_plan        IS 'FK -> PLANES. Plan de suscripción activo que determina los límites de pantallas y perfiles del usuario';
COMMENT ON COLUMN usuarios.fecha_registro IS 'Fecha de registro en la plataforma. Asignada automáticamente con SYSDATE. NOT NULL';
COMMENT ON COLUMN usuarios.estado_cuenta  IS 'Estado de la cuenta. ACTIVO: puede reproducir. INACTIVO: bloqueado por mora. SUSPENDIDO: bloqueado por otra razón. Por defecto ACTIVO';
COMMENT ON COLUMN usuarios.fecha_ultimo_pago IS 'Fecha del último pago exitoso registrado. NULL al momento del registro.';
COMMENT ON COLUMN usuarios.id_referido_por IS 'FK -> USUARIOS (reflexiva). Usuario que refirió a este suscriptor. NULL si no fue referido. Distinto al propio id_usuario';

-- 5. PERFILES
CREATE TABLE perfiles (

    id_perfil  NUMBER        NOT NULL,

    id_usuario NUMBER        NOT NULL,
    nombre     VARCHAR2(50)  NOT NULL,
    avatar     VARCHAR2(255) NULL,
    tipo       VARCHAR2(10)  NOT NULL,

    CONSTRAINT pk_perfiles   PRIMARY KEY (id_perfil),
    CONSTRAINT ck_perf_tipo  CHECK (tipo IN ('ADULTO', 'INFANTIL')),
    CONSTRAINT fk_perf_usu   FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

COMMENT ON TABLE  perfiles      IS 'Perfiles de usuario dentro de una cuenta. Historial, favoritos y calificaciones son independientes por perfil';
COMMENT ON COLUMN perfiles.id_perfil  IS 'PK. Identificador único del perfil. Generado con SEQ_PERFILES';
COMMENT ON COLUMN perfiles.id_usuario IS 'FK -> USUARIOS. Usuario propietario de la cuenta a la que pertenece el perfil';
COMMENT ON COLUMN perfiles.nombre     IS 'Nombre visible del perfil. NOT NULL garantiza mínimo 1 carácter';
COMMENT ON COLUMN perfiles.avatar     IS 'Ruta o identificador del avatar seleccionado. NULL si no se ha configurado ninguno';
COMMENT ON COLUMN perfiles.tipo       IS 'Tipo del perfil. ADULTO: acceso completo al catálogo. INFANTIL: solo contenido TP, +7 y +13';

-- 6. CATEGORIAS DE CONTENIDO
CREATE TABLE categorias (

    id_categoria NUMBER        NOT NULL,

    nombre       VARCHAR2(30)  NOT NULL,

    CONSTRAINT pk_categorias    PRIMARY KEY (id_categoria),
    CONSTRAINT uq_cat_nombre    UNIQUE (nombre),
    CONSTRAINT ck_cat_nombre    CHECK (nombre IN ('Película', 'Serie', 'Documental', 'Música', 'Podcast'))
);

COMMENT ON TABLE  categorias          IS 'Categorías de contenido de la plataforma: Película, Serie, Documental, Música, Podcast';
COMMENT ON COLUMN categorias.id_categoria IS 'PK. Identificador único de la categoría. Generado con SEQ_CATEGORIAS';
COMMENT ON COLUMN categorias.nombre   IS 'Nombre de la categoría. Valores permitidos: Película, Serie, Documental, Música, Podcast. Único en el sistema';

-- 7. GENEROS
CREATE TABLE generos (

    id_genero NUMBER        NOT NULL,

    nombre    VARCHAR2(30)  NOT NULL,

    CONSTRAINT pk_generos    PRIMARY KEY (id_genero),
    CONSTRAINT uq_gen_nombre UNIQUE (nombre)
);

COMMENT ON TABLE  generos          IS 'Géneros de contenido disponibles. Un contenido puede pertenecer a múltiples géneros simultáneamente (relación N:M)';
COMMENT ON COLUMN generos.id_genero IS 'PK. Identificador único del género. Generado con SEQ_GENEROS';
COMMENT ON COLUMN generos.nombre    IS 'Nombre del género. Ej: Acción, Comedia, Drama, Suspenso, Romance, Ciencia Ficción, Terror, Infantil, Musical. Único en el sistema';

-- 8. CONTENIDO
CREATE TABLE contenido (

    id_contenido       NUMBER        NOT NULL,

    titulo             VARCHAR2(200) NOT NULL,
    anio_lanzamiento   NUMBER(4)     NOT NULL,
    duracion           NUMBER        NOT NULL,
    sinopsis           CLOB          NULL,
    clasificacion_edad VARCHAR2(5)   NOT NULL,
    fecha_agregado     DATE          NOT NULL,
    es_original        CHAR(1)       NOT NULL,

    id_categoria       NUMBER        NOT NULL,
    id_empleado_resp   NUMBER        NOT NULL,

    CONSTRAINT pk_contenido    PRIMARY KEY (id_contenido),
    CONSTRAINT ck_cont_edad    CHECK (clasificacion_edad IN ('TP', '+7', '+13', '+16', '+18')),
    CONSTRAINT ck_cont_orig    CHECK (es_original IN ('S', 'N')),
    CONSTRAINT ck_cont_anio    CHECK (anio_lanzamiento BETWEEN 1900 AND 2100),
    CONSTRAINT ck_cont_dur     CHECK (duracion > 0),
    CONSTRAINT fk_cont_cat     FOREIGN KEY (id_categoria)     REFERENCES categorias(id_categoria),
    CONSTRAINT fk_cont_emp     FOREIGN KEY (id_empleado_resp) REFERENCES empleados(id_empleado)
);

ALTER TABLE contenido MODIFY fecha_agregado DATE DEFAULT SYSDATE NOT NULL;
ALTER TABLE contenido MODIFY es_original    CHAR(1) DEFAULT 'N'  NOT NULL;

COMMENT ON TABLE  contenido                  IS 'Catálogo general de contenido multimedia: películas, series, documentales, música y podcasts';
COMMENT ON COLUMN contenido.id_contenido     IS 'PK. Identificador único del contenido. Generado con SEQ_CONTENIDO';
COMMENT ON COLUMN contenido.titulo           IS 'Título del contenido. NOT NULL garantiza mínimo 1 carácter';
COMMENT ON COLUMN contenido.anio_lanzamiento IS 'Año de lanzamiento original. Válido entre 1900 y 2100 (ck_cont_anio)';
COMMENT ON COLUMN contenido.duracion         IS 'Duración total';
COMMENT ON COLUMN contenido.sinopsis         IS 'Descripción argumental del contenido.';
COMMENT ON COLUMN contenido.clasificacion_edad IS 'Clasificación de edad. Valores: TP, +7, +13, +16, +18. Determina qué perfiles pueden acceder. Para series y podcasts, esta clasificación aplica a todas sus temporadas y episodios, los cuales no almacenan clasificación propia';
COMMENT ON COLUMN contenido.fecha_agregado   IS 'Fecha en que el contenido fue incorporado al catálogo. Asignada automáticamente con SYSDATE. NOT NULL';
COMMENT ON COLUMN contenido.es_original      IS 'Indicador de producción propia. S = original de QuindioFlix; N = contenido licenciado de terceros. Por defecto N';
COMMENT ON COLUMN contenido.id_categoria     IS 'FK -> CATEGORIAS. Tipo de contenido: Película, Serie, Documental, Música o Podcast';
COMMENT ON COLUMN contenido.id_empleado_resp IS 'FK -> EMPLEADOS. Empleado del departamento de Contenido responsable de publicar y gestionar este título';

-- 9. CONTENIDO_GENERO (Relación N:M)
CREATE TABLE contenido_genero (

    id_contenido NUMBER NOT NULL,
    id_genero    NUMBER NOT NULL,

    CONSTRAINT pk_cont_gen PRIMARY KEY (id_contenido, id_genero),
    CONSTRAINT fk_cg_cont  FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido),
    CONSTRAINT fk_cg_gen   FOREIGN KEY (id_genero)    REFERENCES generos(id_genero)
);

COMMENT ON TABLE  contenido_genero             IS 'Tabla intermedia N:M entre CONTENIDO y GENEROS. Un contenido puede tener múltiples géneros simultáneamente';
COMMENT ON COLUMN contenido_genero.id_contenido IS 'FK -> CONTENIDO. Parte de la PK compuesta (id_contenido, id_genero)';
COMMENT ON COLUMN contenido_genero.id_genero    IS 'FK -> GENEROS. Parte de la PK compuesta (id_contenido, id_genero)';

-- 10. RELACIONES DE CONTENIDO (Secuelas, remakes, etc.)
CREATE TABLE contenido_relacionado (

    id_origen     NUMBER        NOT NULL,
    id_destino    NUMBER        NOT NULL,

    tipo_relacion VARCHAR2(50)  NOT NULL,

    CONSTRAINT pk_cont_rel    PRIMARY KEY (id_origen, id_destino),
    CONSTRAINT fk_cr_orig     FOREIGN KEY (id_origen)  REFERENCES contenido(id_contenido),
    CONSTRAINT fk_cr_dest     FOREIGN KEY (id_destino) REFERENCES contenido(id_contenido),
    CONSTRAINT ck_cr_no_self  CHECK (id_origen != id_destino),
    CONSTRAINT ck_cr_tipo_rel CHECK (tipo_relacion IN ('SECUELA', 'PRECUELA', 'REMAKE', 'SPIN-OFF', 'VERSION_EXTENDIDA'))
);

COMMENT ON TABLE  contenido_relacionado              IS 'Asociaciones entre contenidos del catálogo. No se permite que un contenido se relacione consigo mismo';
COMMENT ON COLUMN contenido_relacionado.id_origen     IS 'FK -> CONTENIDO. Contenido de origen. Parte de la PK compuesta';
COMMENT ON COLUMN contenido_relacionado.id_destino    IS 'FK -> CONTENIDO. Contenido de destino.';
COMMENT ON COLUMN contenido_relacionado.tipo_relacion IS 'Tipo de asociación. Valores: SECUELA, PRECUELA, REMAKE, SPIN-OFF, VERSION_EXTENDIDA';

-- 11. TEMPORADAS (Series y Podcasts)
CREATE TABLE temporadas (

    id_temporada     NUMBER        NOT NULL,

    id_contenido     NUMBER        NOT NULL,
    numero_temporada NUMBER        NOT NULL,
    titulo           VARCHAR2(100) NULL,

    CONSTRAINT pk_temporadas   PRIMARY KEY (id_temporada),
    CONSTRAINT uq_temp_num     UNIQUE (id_contenido, numero_temporada),
    CONSTRAINT ck_temp_num     CHECK (numero_temporada > 0),
    CONSTRAINT fk_temp_cont    FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido)
);

COMMENT ON TABLE  temporadas                  IS 'Temporadas de series y podcasts. Contenidos de tipo Serie o Podcast deben tener al menos una';
COMMENT ON COLUMN temporadas.id_temporada     IS 'PK. Identificador único de la temporada.';
COMMENT ON COLUMN temporadas.id_contenido     IS 'FK -> CONTENIDO. Serie o podcast al que pertenece esta temporada';
COMMENT ON COLUMN temporadas.numero_temporada IS 'Número ordinal de la temporada (1, 2, 3...). Positivo y único dentro del mismo contenido';
COMMENT ON COLUMN temporadas.titulo           IS 'Título opcional de la temporada. Ej: "La caída del reino". NULL si no tiene nombre propio';

-- 12. EPISODIOS
CREATE TABLE episodios (

    id_episodio     NUMBER        NOT NULL,

    id_temporada    NUMBER        NOT NULL,
    numero_episodio NUMBER        NOT NULL,
    titulo          VARCHAR2(200) NOT NULL,
    duracion        NUMBER        NOT NULL,

    CONSTRAINT pk_episodios    PRIMARY KEY (id_episodio),
    CONSTRAINT uq_epi_num      UNIQUE (id_temporada, numero_episodio),
    CONSTRAINT ck_epi_num      CHECK (numero_episodio > 0),
    CONSTRAINT ck_epi_dur      CHECK (duracion > 0),
    CONSTRAINT fk_epi_temp     FOREIGN KEY (id_temporada) REFERENCES temporadas(id_temporada)
);

COMMENT ON TABLE  episodios                 IS 'Episodios de cada temporada de series y podcasts. Cadena FK: EPISODIO -> TEMPORADA -> CONTENIDO. Los episodios heredan la clasificación de edad de su contenido padre';
COMMENT ON COLUMN episodios.id_episodio     IS 'PK. Identificador único del episodio. Generado con SEQ_EPISODIOS';
COMMENT ON COLUMN episodios.id_temporada    IS 'FK -> TEMPORADAS. Temporada a la que pertenece este episodio';
COMMENT ON COLUMN episodios.numero_episodio IS 'Número ordinal del episodio en su temporada (1, 2, 3...). Positivo y único por temporada';
COMMENT ON COLUMN episodios.titulo          IS 'Título del episodio tal como aparece en la plataforma. NOT NULL garantiza mínimo 1 carácter';
COMMENT ON COLUMN episodios.duracion        IS 'Duración del episodio en minutos. Siempre mayor a 0';

-- 13. REPRODUCCIONES
CREATE TABLE reproducciones (

    id_reproduccion   NUMBER        NOT NULL,

    id_perfil         NUMBER        NOT NULL,
    id_contenido      NUMBER        NULL,
    id_episodio       NUMBER        NULL,

    fecha_hora_inicio TIMESTAMP     NOT NULL,
    fecha_hora_fin    TIMESTAMP     NULL,
    dispositivo       VARCHAR2(15)  NOT NULL,
    porcentaje_avance NUMBER(5, 2)  NOT NULL,

    CONSTRAINT pk_reproducciones  PRIMARY KEY (id_reproduccion),
    CONSTRAINT ck_repr_disp       CHECK (dispositivo IN ('CELULAR', 'TABLET', 'TV', 'COMPUTADOR')),
    CONSTRAINT ck_repr_perc       CHECK (porcentaje_avance BETWEEN 0 AND 100),
    CONSTRAINT ck_repr_fin        CHECK (fecha_hora_fin IS NULL OR fecha_hora_fin > fecha_hora_inicio),
    CONSTRAINT ck_repr_excl_mut   CHECK (
        (id_contenido IS NOT NULL AND id_episodio IS NULL) OR
        (id_contenido IS NULL     AND id_episodio IS NOT NULL)
    ),
    CONSTRAINT fk_repr_perf       FOREIGN KEY (id_perfil)    REFERENCES perfiles(id_perfil),
    CONSTRAINT fk_repr_cont       FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido),
    CONSTRAINT fk_repr_epi        FOREIGN KEY (id_episodio)  REFERENCES episodios(id_episodio)
);

ALTER TABLE reproducciones MODIFY fecha_hora_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL;
ALTER TABLE reproducciones MODIFY porcentaje_avance NUMBER(5,2) DEFAULT 0 NOT NULL;

COMMENT ON TABLE  reproducciones                  IS 'Historial completo de reproducciones por perfil. Mayor volumen del sistema';
COMMENT ON COLUMN reproducciones.id_reproduccion  IS 'PK. Identificador único de la reproducción. Generado con SEQ_REPRODUCCIONES';
COMMENT ON COLUMN reproducciones.id_perfil        IS 'FK -> PERFILES. Perfil que realizó la reproducción. La cuenta del usuario asociado debe estar ACTIVA';
COMMENT ON COLUMN reproducciones.id_contenido     IS 'FK -> CONTENIDO. Contenido reproducido para películas, documentales y música. NULL cuando la reproducción es de un episodio (ck_repr_excl_mut)';
COMMENT ON COLUMN reproducciones.id_episodio      IS 'FK -> EPISODIOS. Episodio reproducido para series y podcasts. NULL cuando la reproducción es de contenido directo (ck_repr_excl_mut)';
COMMENT ON COLUMN reproducciones.fecha_hora_inicio IS 'Marca temporal de inicio de la reproducción. Asignada automáticamente con CURRENT_TIMESTAMP. NOT NULL';
COMMENT ON COLUMN reproducciones.fecha_hora_fin   IS 'Marca temporal de fin de la reproducción. NULL si el usuario no terminó. Debe ser posterior al inicio';
COMMENT ON COLUMN reproducciones.dispositivo      IS 'Dispositivo desde el que se realizó la reproducción. Valores: CELULAR, TABLET, TV, COMPUTADOR';
COMMENT ON COLUMN reproducciones.porcentaje_avance IS 'Porcentaje del contenido reproducido, de 0.00 a 100.00. Un valor >= 50.00 habilita al perfil a calificar el contenido. Por defecto 0';

-- 14. CALIFICACIONES Y RESEÑAS
CREATE TABLE calificaciones (

    id_calificacion    NUMBER        NOT NULL,

    id_perfil          NUMBER        NOT NULL,
    id_contenido       NUMBER        NOT NULL,

    estrellas          NUMBER(1)     NOT NULL,
    resenia            VARCHAR2(1000) NULL,
    fecha_calificacion DATE          NOT NULL,

    CONSTRAINT pk_calificaciones    PRIMARY KEY (id_calificacion),
    CONSTRAINT uq_cal_perfil_cont   UNIQUE (id_perfil, id_contenido),
    CONSTRAINT ck_cal_est           CHECK (estrellas BETWEEN 1 AND 5),
    CONSTRAINT fk_cal_perf          FOREIGN KEY (id_perfil)    REFERENCES perfiles(id_perfil),
    CONSTRAINT fk_cal_cont          FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido)
);

ALTER TABLE calificaciones MODIFY fecha_calificacion DATE DEFAULT SYSDATE NOT NULL;

COMMENT ON TABLE  calificaciones                  IS 'Calificaciones y reseñas de contenido por perfil. Máximo una por perfil por contenido.';
COMMENT ON COLUMN calificaciones.id_calificacion  IS 'PK. Identificador único de la calificación. Generado con SEQ_CALIFICACIONES';
COMMENT ON COLUMN calificaciones.id_perfil        IS 'FK -> PERFILES. Perfil que emite la calificación. Único junto con id_contenido (RN-13, uq_cal_perfil_cont)';
COMMENT ON COLUMN calificaciones.id_contenido     IS 'FK -> CONTENIDO. Contenido calificado.';
COMMENT ON COLUMN calificaciones.estrellas        IS 'Puntuación del contenido. Entero entre 1 (mínimo) y 5 (máximo) estrellas (ck_cal_est)';
COMMENT ON COLUMN calificaciones.resenia          IS 'Reseña escrita opcional. Máximo 1000 caracteres. NULL si el usuario solo otorgó estrellas';
COMMENT ON COLUMN calificaciones.fecha_calificacion IS 'Fecha en que se registró la calificación. Asignada automáticamente con SYSDATE. NOT NULL';

-- 15. FAVORITOS
CREATE TABLE favoritos (

    id_perfil    NUMBER NOT NULL,
    id_contenido NUMBER NOT NULL,

    CONSTRAINT pk_favoritos  PRIMARY KEY (id_perfil, id_contenido),
    CONSTRAINT fk_fav_perf   FOREIGN KEY (id_perfil)    REFERENCES perfiles(id_perfil),
    CONSTRAINT fk_fav_cont   FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido)
);

COMMENT ON TABLE  favoritos             IS 'Lista personal de contenidos favoritos por perfil. Relación N:M entre PERFILES y CONTENIDO. Cada perfil gestiona su lista de forma independiente';
COMMENT ON COLUMN favoritos.id_perfil    IS 'FK -> PERFILES. Perfil propietario de la lista de favoritos. Parte de la PK compuesta (id_perfil, id_contenido)';
COMMENT ON COLUMN favoritos.id_contenido IS 'FK -> CONTENIDO. Contenido marcado como favorito. Parte de la PK compuesta (id_perfil, id_contenido)';

-- 16. REPORTES DE CONTENIDO INAPROPIADO
CREATE TABLE reportes (

    id_reporte        NUMBER         NOT NULL,

    id_usuario        NUMBER         NOT NULL,
    id_contenido      NUMBER         NOT NULL,
    id_moderador      NUMBER         NULL,

    descripcion       VARCHAR2(1000) NOT NULL,
    estado            VARCHAR2(15)   NOT NULL,
    fecha_reporte     DATE           NOT NULL,
    fecha_resolucion  DATE           NULL,

    CONSTRAINT pk_reportes     PRIMARY KEY (id_reporte),
    CONSTRAINT ck_rep_est      CHECK (estado IN ('PENDIENTE', 'ACEPTADO', 'RECHAZADO')),
    CONSTRAINT ck_rep_fecha    CHECK (fecha_resolucion IS NULL OR fecha_resolucion >= fecha_reporte),
    CONSTRAINT fk_rep_usu      FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_rep_cont     FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido),
    CONSTRAINT fk_rep_mod      FOREIGN KEY (id_moderador) REFERENCES empleados(id_empleado)
);

ALTER TABLE reportes MODIFY estado        VARCHAR2(15) DEFAULT 'PENDIENTE' NOT NULL;
ALTER TABLE reportes MODIFY fecha_reporte DATE DEFAULT SYSDATE NOT NULL;

COMMENT ON TABLE  reportes                  IS 'Reportes de contenido inapropiado enviados por usuarios y resueltos por moderadores de Soporte';
COMMENT ON COLUMN reportes.id_reporte       IS 'PK. Identificador único del reporte. Generado con SEQ_REPORTES';
COMMENT ON COLUMN reportes.id_usuario       IS 'FK -> USUARIOS. Usuario que genera el reporte. No puede tener dos reportes PENDIENTES sobre el mismo contenido';
COMMENT ON COLUMN reportes.id_contenido     IS 'FK -> CONTENIDO. Contenido reportado como inapropiado';
COMMENT ON COLUMN reportes.id_moderador     IS 'FK -> EMPLEADOS. Moderador del departamento de Soporte que resuelve el reporte. NULL mientras el estado sea PENDIENTE';
COMMENT ON COLUMN reportes.descripcion      IS 'Motivo detallado del reporte. Máximo 1000 caracteres. Obligatorio';
COMMENT ON COLUMN reportes.estado           IS 'Estado del reporte. PENDIENTE: sin resolver. ACEPTADO: contenido confirmado como inapropiado. RECHAZADO: reporte descartado. Por defecto PENDIENTE';
COMMENT ON COLUMN reportes.fecha_reporte    IS 'Fecha en que el usuario envió el reporte. Asignada automáticamente con SYSDATE. NOT NULL';
COMMENT ON COLUMN reportes.fecha_resolucion IS 'Fecha en que el moderador resolvió el reporte. NULL mientras el estado sea PENDIENTE. Debe ser >= fecha_reporte (ck_rep_fecha)';

-- 17. PAGOS
CREATE TABLE pagos (

    id_pago     NUMBER        NOT NULL,

    id_usuario  NUMBER        NOT NULL,

    fecha_pago        DATE          NOT NULL,
    monto             NUMBER(10, 2) NOT NULL,
    descuento_aplicado NUMBER(5, 2) NOT NULL,
    metodo_pago       VARCHAR2(20)  NOT NULL,
    estado_pago       VARCHAR2(15)  NOT NULL,

    CONSTRAINT pk_pagos       PRIMARY KEY (id_pago),
    CONSTRAINT ck_pago_met    CHECK (metodo_pago IN ('TARJETA_CREDITO', 'TARJETA_DEBITO', 'PSE', 'NEQUI', 'DAVIPLATA')),
    CONSTRAINT ck_pago_est    CHECK (estado_pago IN ('EXITOSO', 'FALLIDO', 'PENDIENTE', 'REEMBOLSADO')),
    CONSTRAINT ck_pago_monto  CHECK (monto >= 0),
    CONSTRAINT ck_pago_desc   CHECK (descuento_aplicado BETWEEN 0 AND 100),
    CONSTRAINT fk_pago_usu    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

ALTER TABLE pagos MODIFY fecha_pago         DATE         DEFAULT SYSDATE NOT NULL;
ALTER TABLE pagos MODIFY descuento_aplicado NUMBER(5, 2) DEFAULT 0       NOT NULL;

COMMENT ON TABLE  pagos                    IS 'Historial de pagos de suscripción. Base para reportes financieros por ciudad y por plan (PN-08, PN-12)';
COMMENT ON COLUMN pagos.id_pago             IS 'PK. Identificador único del pago. Generado con SEQ_PAGOS';
COMMENT ON COLUMN pagos.id_usuario          IS 'FK -> USUARIOS. Usuario que realiza o intenta el pago mensual';
COMMENT ON COLUMN pagos.fecha_pago          IS 'Fecha en que se registró el pago o intento de pago. Asignada automáticamente con SYSDATE. NOT NULL';
COMMENT ON COLUMN pagos.monto               IS 'Monto final cobrado en pesos colombianos, ya con descuentos aplicados. Siempre >= 0 (RN-20)';
COMMENT ON COLUMN pagos.descuento_aplicado  IS 'Porcentaje total de descuento aplicado a este pago (0.00 a 100.00).';
COMMENT ON COLUMN pagos.metodo_pago         IS 'Método de pago utilizado. Valores habilitados en Colombia (RN-24): TARJETA_CREDITO, TARJETA_DEBITO, PSE, NEQUI, DAVIPLATA';
COMMENT ON COLUMN pagos.estado_pago         IS 'Resultado del intento de pago. EXITOSO: cobro confirmado. FALLIDO: cobro rechazado. PENDIENTE: en proceso. REEMBOLSADO: monto devuelto al usuario';

