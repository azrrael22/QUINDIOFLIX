-- =============================================================================
-- PROYECTO FINAL: QUINDIOFLIX
-- BASES DE DATOS II - UNIVERSIDAD DEL QUINDIO
-- SEMESTRE 2026-1
-- SCRIPT DE INSERCIÓN DE DATOS DE PRUEBA
-- =============================================================================
-- Cumple con los mínimos exigidos en la Sección 4 del enunciado:
--   PLANES: 3 | DEPARTAMENTOS: 5 | EMPLEADOS: 10
--   USUARIOS: 30 | PERFILES: 50 | CATEGORIAS: 5 | GENEROS: 10
--   CONTENIDO: 41 | TEMPORADAS: 15 | EPISODIOS: 50
--   REPRODUCCIONES: 200 | CALIFICACIONES: 60 | PAGOS: 82 | FAVORITOS: 40
-- Datos ASIMÉTRICOS: ciudades (Armenia, Pereira, Medellín), planes,
-- dispositivos y fechas distribuidas en 2024-2026 para activar todas
-- las particiones de la tabla REPRODUCCIONES.
-- =============================================================================

SET DEFINE OFF;

-- ============================================================
-- 1. PLANES (3 registros)
-- ============================================================
INSERT INTO planes (id_plan, nombre, precio_mensual, calidad, max_pantallas, max_perfiles)
VALUES (SEQ_PLANES.NEXTVAL, 'Básico',    14900, 'SD', 1, 2);

INSERT INTO planes (id_plan, nombre, precio_mensual, calidad, max_pantallas, max_perfiles)
VALUES (SEQ_PLANES.NEXTVAL, 'Estándar',  24900, 'HD', 2, 3);

INSERT INTO planes (id_plan, nombre, precio_mensual, calidad, max_pantallas, max_perfiles)
VALUES (SEQ_PLANES.NEXTVAL, 'Premium',   34900, '4K', 4, 5);

-- ============================================================
-- 2. DEPARTAMENTOS (5 registros)
-- ============================================================
INSERT INTO departamentos (id_departamento, nombre)
VALUES (SEQ_DEPARTAMENTOS.NEXTVAL, 'Tecnología');

INSERT INTO departamentos (id_departamento, nombre)
VALUES (SEQ_DEPARTAMENTOS.NEXTVAL, 'Contenido');

INSERT INTO departamentos (id_departamento, nombre)
VALUES (SEQ_DEPARTAMENTOS.NEXTVAL, 'Marketing');

INSERT INTO departamentos (id_departamento, nombre)
VALUES (SEQ_DEPARTAMENTOS.NEXTVAL, 'Soporte');

INSERT INTO departamentos (id_departamento, nombre)
VALUES (SEQ_DEPARTAMENTOS.NEXTVAL, 'Finanzas');

-- ============================================================
-- 3. EMPLEADOS (10 registros — jerarquía reflexiva)
-- Primero sin supervisor, luego se actualiza.
-- id_empleado: 1-10
-- ============================================================

-- Jefes de departamento (sin supervisor por ahora)
INSERT INTO empleados (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADOS.NEXTVAL, 'Carlos Herrera',    'c.herrera@quindioflix.co',    'Jefe de Tecnología',  DATE '2020-03-15', 1, NULL);

INSERT INTO empleados (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADOS.NEXTVAL, 'Maria Ospina',      'm.ospina@quindioflix.co',     'Jefe de Contenido',   DATE '2019-07-01', 2, NULL);

INSERT INTO empleados (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADOS.NEXTVAL, 'Luis Restrepo',     'l.restrepo@quindioflix.co',   'Jefe de Marketing',   DATE '2021-01-10', 3, NULL);

INSERT INTO empleados (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADOS.NEXTVAL, 'Diana Castaño',     'd.castano@quindioflix.co',    'Jefe de Soporte',     DATE '2020-09-20', 4, NULL);

INSERT INTO empleados (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADOS.NEXTVAL, 'Andres Gomez',      'a.gomez@quindioflix.co',      'Jefe de Finanzas',    DATE '2019-11-05', 5, NULL);

-- Subordinados
INSERT INTO empleados (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADOS.NEXTVAL, 'Valentina Torres',  'v.torres@quindioflix.co',     'Gestor de Contenido', DATE '2022-02-14', 2, 2);

INSERT INTO empleados (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADOS.NEXTVAL, 'Santiago Mejia',    's.mejia@quindioflix.co',      'Gestor de Contenido', DATE '2022-06-01', 2, 2);

INSERT INTO empleados (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADOS.NEXTVAL, 'Juliana Arias',     'j.arias@quindioflix.co',      'Moderador',           DATE '2023-01-15', 4, 4);

INSERT INTO empleados (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADOS.NEXTVAL, 'Felipe Salazar',    'f.salazar@quindioflix.co',    'Moderador',           DATE '2023-03-10', 4, 4);

INSERT INTO empleados (id_empleado, nombre, email, cargo, fecha_contratacion, id_departamento, id_supervisor)
VALUES (SEQ_EMPLEADOS.NEXTVAL, 'Natalia Bedoya',    'n.bedoya@quindioflix.co',     'Analista de Datos',   DATE '2021-08-20', 1, 1);

-- Asignar jefes a departamentos
UPDATE departamentos SET id_jefe = 1 WHERE id_departamento = 1;
UPDATE departamentos SET id_jefe = 2 WHERE id_departamento = 2;
UPDATE departamentos SET id_jefe = 3 WHERE id_departamento = 3;
UPDATE departamentos SET id_jefe = 4 WHERE id_departamento = 4;
UPDATE departamentos SET id_jefe = 5 WHERE id_departamento = 5;

-- ============================================================
-- 4. USUARIOS (30 registros — distribuidos en 3 ciudades y 3 planes)
-- Ciudades: Armenia (12), Pereira (10), Medellín (8)
-- Planes: Básico(1)=10, Estándar(2)=12, Premium(3)=8
-- id_usuario: 100-129
-- ============================================================

-- --- Armenia - Plan Básico ---
INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Juan',     'Duque',    'juan.duque@gmail.com',     '3001234567', DATE '1990-05-12', 'Armenia',  1, DATE '2024-01-10', 'ACTIVO',    DATE '2026-03-10', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Laura',    'Patiño',   'laura.patino@gmail.com',   '3002345678', DATE '1995-08-23', 'Armenia',  1, DATE '2024-02-15', 'ACTIVO',    DATE '2026-03-15', 100);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Miguel',   'Vargas',   'miguel.vargas@gmail.com',  '3003456789', DATE '1988-11-04', 'Armenia',  1, DATE '2024-03-01', 'INACTIVO',  DATE '2025-11-01', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Sofia',    'Londoño',  'sofia.londono@gmail.com',  '3004567890', DATE '2000-03-17', 'Armenia',  1, DATE '2024-04-20', 'ACTIVO',    DATE '2026-03-20', NULL);

-- --- Armenia - Plan Estándar ---
INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Camila',   'Rios',     'camila.rios@gmail.com',    '3005678901', DATE '1993-07-30', 'Armenia',  2, DATE '2023-06-05', 'ACTIVO',    DATE '2026-03-05', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Andres',   'Molina',   'andres.molina@gmail.com',  '3006789012', DATE '1985-12-09', 'Armenia',  2, DATE '2023-08-18', 'ACTIVO',    DATE '2026-03-18', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Isabella', 'Cano',     'isabella.cano@gmail.com',  '3007890123', DATE '1997-02-14', 'Armenia',  2, DATE '2024-01-25', 'ACTIVO',    DATE '2026-03-25', 104);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Mateo',    'Zuluaga',  'mateo.zuluaga@gmail.com',  '3008901234', DATE '1991-09-21', 'Armenia',  2, DATE '2024-05-10', 'ACTIVO',    DATE '2026-03-10', NULL);

-- --- Armenia - Plan Premium ---
INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Valeria',  'Gutierrez','valeria.g@gmail.com',       '3009012345', DATE '1987-04-08', 'Armenia',  3, DATE '2022-10-01', 'ACTIVO',    DATE '2026-03-01', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Daniel',   'Arango',   'daniel.arango@gmail.com',  '3010123456', DATE '1983-06-15', 'Armenia',  3, DATE '2022-12-20', 'ACTIVO',    DATE '2026-03-20', 108);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Mariana',  'Jimenez',  'mariana.j@gmail.com',      '3011234567', DATE '1996-10-28', 'Armenia',  3, DATE '2023-02-14', 'ACTIVO',    DATE '2026-03-14', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Sebastian','Moreno',   'sebastian.m@gmail.com',    '3012345678', DATE '1994-01-03', 'Armenia',  3, DATE '2023-05-09', 'SUSPENDIDO',DATE '2025-12-09', NULL);

-- --- Pereira - Plan Básico ---
INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Esteban',  'Cardona',  'esteban.c@gmail.com',      '3013456789', DATE '1992-03-22', 'Pereira',  1, DATE '2024-02-01', 'ACTIVO',    DATE '2026-03-01', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Juliana',  'Velez',    'juliana.v@gmail.com',      '3014567890', DATE '1998-07-11', 'Pereira',  1, DATE '2024-03-15', 'ACTIVO',    DATE '2026-03-15', 112);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Ricardo',  'Palacio',  'ricardo.p@gmail.com',      '3015678901', DATE '1986-09-05', 'Pereira',  1, DATE '2024-06-08', 'INACTIVO',  DATE '2025-10-08', NULL);

-- --- Pereira - Plan Estándar ---
INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Alejandra','Sierra',   'alejandra.s@gmail.com',    '3016789012', DATE '1990-11-17', 'Pereira',  2, DATE '2023-04-20', 'ACTIVO',    DATE '2026-03-20', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Nicolas',  'Henao',    'nicolas.h@gmail.com',      '3017890123', DATE '1999-04-25', 'Pereira',  2, DATE '2023-07-30', 'ACTIVO',    DATE '2026-03-30', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Daniela',  'Quintero', 'daniela.q@gmail.com',      '3018901234', DATE '1993-06-14', 'Pereira',  2, DATE '2024-01-05', 'ACTIVO',    DATE '2026-03-05', 115);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Manuela',  'Giraldo',  'manuela.g@gmail.com',      '3019012345', DATE '2001-12-02', 'Pereira',  2, DATE '2024-08-22', 'ACTIVO',    DATE '2026-03-22', NULL);

-- --- Pereira - Plan Premium ---
INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Cristian', 'Muñoz',    'cristian.m@gmail.com',     '3020123456', DATE '1984-08-19', 'Pereira',  3, DATE '2022-05-11', 'ACTIVO',    DATE '2026-03-11', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Paola',    'Zapata',   'paola.z@gmail.com',        '3021234567', DATE '1989-02-06', 'Pereira',  3, DATE '2022-09-17', 'ACTIVO',    DATE '2026-03-17', 119);

-- --- Medellín - Plan Básico ---
INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Jorge',    'Montoya',  'jorge.montoya@gmail.com',  '3022345678', DATE '1991-10-30', 'Medellín', 1, DATE '2024-04-04', 'ACTIVO',    DATE '2026-03-04', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Carolina', 'Franco',   'carolina.f@gmail.com',     '3023456789', DATE '1996-05-16', 'Medellín', 1, DATE '2024-07-19', 'INACTIVO',  DATE '2025-09-19', 121);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Sergio',   'Naranjo',  'sergio.n@gmail.com',       '3024567890', DATE '1982-01-27', 'Medellín', 1, DATE '2024-09-01', 'ACTIVO',    DATE '2026-03-01', NULL);

-- --- Medellín - Plan Estándar ---
INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Luisa',    'Betancur', 'luisa.b@gmail.com',        '3025678901', DATE '1994-04-09', 'Medellín', 2, DATE '2023-03-12', 'ACTIVO',    DATE '2026-03-12', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Felipe',   'Escobar',  'felipe.e@gmail.com',       '3026789012', DATE '1988-07-23', 'Medellín', 2, DATE '2023-10-28', 'ACTIVO',    DATE '2026-03-28', 124);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Catalina', 'Agudelo',  'catalina.a@gmail.com',     '3027890123', DATE '2002-09-14', 'Medellín', 2, DATE '2024-02-03', 'ACTIVO',    DATE '2026-03-03', NULL);

-- --- Medellín - Plan Premium ---
INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Hernando', 'Vasquez',  'hernando.v@gmail.com',     '3028901234', DATE '1979-03-31', 'Medellín', 3, DATE '2021-11-15', 'ACTIVO',    DATE '2026-03-15', NULL);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Adriana',  'Perez',    'adriana.p@gmail.com',      '3029012345', DATE '1990-08-07', 'Medellín', 3, DATE '2022-01-22', 'ACTIVO',    DATE '2026-03-22', 127);

INSERT INTO usuarios (id_usuario, nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, fecha_registro, estado_cuenta, fecha_ultimo_pago, id_referido_por)
VALUES (SEQ_USUARIOS.NEXTVAL, 'Oscar',    'Castillo', 'oscar.castillo@gmail.com', '3030123456', DATE '1986-11-18', 'Medellín', 3, DATE '2022-07-06', 'ACTIVO',    DATE '2026-03-06', NULL);

-- ============================================================
-- 5. PERFILES (50+ registros)
-- Plan Básico  (max 2 perfiles): usuarios 100,101,103,112,113,121,122,123
-- Plan Estándar (max 3 perfiles): usuarios 104,105,106,107,115,116,117,118,124,125,126
-- Plan Premium (max 5 perfiles): usuarios 108,109,110,119,120,127,128,129
-- id_perfil: 100-149
-- ============================================================

-- Usuario 100 (Básico, 2 perfiles)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 100, 'Juan',        'avatar_01.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 100, 'Juanito',     'avatar_kid.png','INFANTIL');

-- Usuario 101 (Básico, 2 perfiles)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 101, 'Laura',       'avatar_02.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 101, 'Laurita',     'avatar_kid.png','INFANTIL');

-- Usuario 102 (Básico, 1 perfil — cuenta INACTIVA)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 102, 'Miguel',      'avatar_03.png', 'ADULTO');

-- Usuario 103 (Básico, 1 perfil)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 103, 'Sofia',       'avatar_04.png', 'ADULTO');

-- Usuario 104 (Estándar, 3 perfiles)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 104, 'Camila',      'avatar_05.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 104, 'Familia',     'avatar_06.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 104, 'Niños',       'avatar_kid.png','INFANTIL');

-- Usuario 105 (Estándar, 2 perfiles)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 105, 'Andres',      'avatar_07.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 105, 'Trabajo',     'avatar_08.png', 'ADULTO');

-- Usuario 106 (Estándar, 3 perfiles)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 106, 'Isabella',    'avatar_09.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 106, 'Isa2',        'avatar_10.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 106, 'Kids',        'avatar_kid.png','INFANTIL');

-- Usuario 107 (Estándar, 2 perfiles)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 107, 'Mateo',       'avatar_11.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 107, 'Mateo2',      'avatar_12.png', 'ADULTO');

-- Usuario 108 (Premium, 4 perfiles)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 108, 'Valeria',     'avatar_13.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 108, 'Pareja',      'avatar_14.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 108, 'Hijos',       'avatar_kid.png','INFANTIL');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 108, 'Trabajo',     'avatar_15.png', 'ADULTO');

-- Usuario 109 (Premium, 3 perfiles)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 109, 'Daniel',      'avatar_16.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 109, 'Familia',     'avatar_17.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 109, 'Peques',      'avatar_kid.png','INFANTIL');

-- Usuario 110 (Premium, 2 perfiles)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 110, 'Mariana',     'avatar_18.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 110, 'Novio',       'avatar_19.png', 'ADULTO');

-- Usuarios 112-129 (1 o 2 perfiles cada uno, para llegar a 50+)
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 112, 'Esteban',     'avatar_20.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 113, 'Juliana',     'avatar_21.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 115, 'Alejandra',   'avatar_22.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 115, 'AleKids',     'avatar_kid.png','INFANTIL');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 116, 'Nicolas',     'avatar_23.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 117, 'Daniela',     'avatar_24.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 117, 'DaKids',      'avatar_kid.png','INFANTIL');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 118, 'Manuela',     'avatar_25.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 119, 'Cristian',    'avatar_26.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 119, 'CristiKids',  'avatar_kid.png','INFANTIL');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 120, 'Paola',       'avatar_27.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 121, 'Jorge',       'avatar_28.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 123, 'Sergio',      'avatar_29.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 124, 'Luisa',       'avatar_30.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 124, 'LuisaKids',   'avatar_kid.png','INFANTIL');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 125, 'Felipe',      'avatar_31.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 126, 'Catalina',    'avatar_32.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 127, 'Hernando',    'avatar_33.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 127, 'HerKids',     'avatar_kid.png','INFANTIL');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 128, 'Adriana',     'avatar_34.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 129, 'Oscar',       'avatar_35.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 129, 'OscarKids',   'avatar_kid.png','INFANTIL');
-- Perfiles adicionales para alcanzar mínimo de 50
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 111, 'Sebastian',   'avatar_36.png', 'ADULTO');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 123, 'SergioKids',  'avatar_kid.png','INFANTIL');
INSERT INTO perfiles (id_perfil, id_usuario, nombre, avatar, tipo) VALUES (SEQ_PERFILES.NEXTVAL, 125, 'FelipeKids',  'avatar_kid.png','INFANTIL');

-- ============================================================
-- 6. CATEGORIAS (5 registros)
-- id_categoria: 1-5
-- ============================================================
INSERT INTO categorias (id_categoria, nombre) VALUES (SEQ_CATEGORIAS.NEXTVAL, 'Película');
INSERT INTO categorias (id_categoria, nombre) VALUES (SEQ_CATEGORIAS.NEXTVAL, 'Serie');
INSERT INTO categorias (id_categoria, nombre) VALUES (SEQ_CATEGORIAS.NEXTVAL, 'Documental');
INSERT INTO categorias (id_categoria, nombre) VALUES (SEQ_CATEGORIAS.NEXTVAL, 'Música');
INSERT INTO categorias (id_categoria, nombre) VALUES (SEQ_CATEGORIAS.NEXTVAL, 'Podcast');

-- ============================================================
-- 7. GENEROS (10 registros)
-- id_genero: 1-10
-- ============================================================
INSERT INTO generos (id_genero, nombre) VALUES (SEQ_GENEROS.NEXTVAL, 'Acción');
INSERT INTO generos (id_genero, nombre) VALUES (SEQ_GENEROS.NEXTVAL, 'Comedia');
INSERT INTO generos (id_genero, nombre) VALUES (SEQ_GENEROS.NEXTVAL, 'Drama');
INSERT INTO generos (id_genero, nombre) VALUES (SEQ_GENEROS.NEXTVAL, 'Suspenso');
INSERT INTO generos (id_genero, nombre) VALUES (SEQ_GENEROS.NEXTVAL, 'Romance');
INSERT INTO generos (id_genero, nombre) VALUES (SEQ_GENEROS.NEXTVAL, 'Ciencia Ficción');
INSERT INTO generos (id_genero, nombre) VALUES (SEQ_GENEROS.NEXTVAL, 'Terror');
INSERT INTO generos (id_genero, nombre) VALUES (SEQ_GENEROS.NEXTVAL, 'Infantil');
INSERT INTO generos (id_genero, nombre) VALUES (SEQ_GENEROS.NEXTVAL, 'Documental');
INSERT INTO generos (id_genero, nombre) VALUES (SEQ_GENEROS.NEXTVAL, 'Musical');

-- ============================================================
-- 8. CONTENIDO (40 registros)
-- Categorías: 1=Película, 2=Serie, 3=Documental, 4=Música, 5=Podcast
-- Empleados de Contenido: id 2 (Jefe), 6 (Valentina), 7 (Santiago)
-- id_contenido: 100-139
-- ============================================================

-- ---- PELÍCULAS (id_categoria=1) ----
INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'El Último Vuelo',         2022, 120, 'Un piloto debe salvar a sus pasajeros en una situación extrema.',                '+13', DATE '2024-01-15', 'N', 1, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Amor en Bogotá',          2021, 95,  'Una historia de amor entre dos jóvenes en la capital colombiana.',               '+13', DATE '2024-01-20', 'S', 1, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Risa Asegurada',          2023, 88,  'Comedia sobre las peripecias de tres amigos en un fin de semana.',               'TP',  DATE '2024-02-01', 'N', 1, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Sombras del Pasado',      2020, 110, 'Un detective investiga un crimen que lo lleva a sus propios secretos.',          '+16', DATE '2024-02-10', 'N', 1, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'La Grieta',               2019, 105, 'Terror psicológico: una familia descubre algo perturbador en su nueva casa.',    '+18', DATE '2024-02-15', 'N', 1, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Galaxia Perdida',         2023, 130, 'Aventura de ciencia ficción en los confines del universo.',                      '+7',  DATE '2024-03-01', 'S', 1, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Monstruo de Peluche',     2022, 80,  'Un niño descubre que su juguete favorito es mágico.',                            'TP',  DATE '2024-03-10', 'S', 1, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Código Rojo',             2021, 115, 'Thriller de acción donde un hacker salva el mundo.',                             '+13', DATE '2024-03-20', 'N', 1, 2);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Noches de Cartagena',     2022, 100, 'Romance apasionado en la ciudad amurallada de Cartagena.',                       '+16', DATE '2024-04-01', 'S', 1, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'El Gran Robo',            2023, 125, 'Un equipo de ladrones planea el atraco del siglo.',                              '+13', DATE '2024-04-15', 'N', 1, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Más Allá del Horizonte',  2020, 118, 'Drama familiar sobre la búsqueda de identidad.',                                 '+7',  DATE '2024-05-01', 'N', 1, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Risas sin Parar 2',       2024, 90,  'Segunda entrega de la comedia más vista de QuindioFlix.',                        'TP',  DATE '2024-05-20', 'S', 1, 7);

-- ---- SERIES (id_categoria=2) ----
INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'La Casa de los Secretos', 2023, 45,  'Drama familiar lleno de intrigas en una mansión colonial.',                     '+13', DATE '2024-01-10', 'S', 2, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Detectives del Quindío',  2022, 50,  'Investigadores locales resuelven los casos más difíciles del Eje Cafetero.',     '+13', DATE '2024-01-25', 'S', 2, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Aventuras Espaciales',    2024, 30,  'Serie infantil sobre un grupo de niños astronautas.',                            'TP',  DATE '2024-02-05', 'S', 2, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'La Red Oscura',           2023, 55,  'Thriller: un agente infiltrado en una organización criminal cibernética.',       '+16', DATE '2024-03-15', 'N', 2, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Corazones Rotos',         2022, 42,  'Romance dramático entre personajes con historias de vida complejas.',            '+13', DATE '2024-04-01', 'S', 2, 2);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'El Origen',               2023, 60,  'Ciencia ficción: la humanidad descubre el origen de la vida extraterrestre.',    '+13', DATE '2024-04-20', 'S', 2, 6);

-- ---- DOCUMENTALES (id_categoria=3) ----
INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Café: El Oro Verde',      2021, 75,  'Historia del café en el Eje Cafetero colombiano.',                               'TP',  DATE '2024-01-30', 'S', 3, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Océanos en Peligro',      2020, 90,  'Documental sobre el impacto del cambio climático en los océanos.',               'TP',  DATE '2024-02-20', 'N', 3, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Mente Humana',            2022, 60,  'Exploración científica del funcionamiento del cerebro.',                         '+7',  DATE '2024-03-05', 'N', 3, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Colombia Salvaje',        2023, 80,  'La biodiversidad única de Colombia a través de impresionantes imágenes.',        'TP',  DATE '2024-05-10', 'S', 3, 2);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Historia del Rock',       2019, 120, 'Evolución del rock desde sus orígenes hasta la actualidad.',                     '+7',  DATE '2024-06-01', 'N', 3, 6);

-- ---- MÚSICA (id_categoria=4) ----
INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Ritmos del Pacífico',     2023, 50,  'Compilado de música folclórica del Pacífico colombiano.',                        'TP',  DATE '2024-01-05', 'S', 4, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Pop Latino Hits 2024',    2024, 65,  'Las canciones de pop latino más escuchadas del año.',                            'TP',  DATE '2024-02-28', 'N', 4, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Clásicos Eternos',        2020, 90,  'Colección de música clásica de los grandes maestros.',                           'TP',  DATE '2024-04-10', 'N', 4, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Trap Colombiano',         2023, 55,  'Los mejores exponentes del trap nacional.',                                      '+16', DATE '2024-05-15', 'S', 4, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Salsa Caliente',          2022, 70,  'Compilado de salsa brava y contemporánea de Cali.',                              'TP',  DATE '2024-06-05', 'N', 4, 7);

-- ---- PODCASTS (id_categoria=5) ----
INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Tech Talk Colombia',      2023, 40,  'Debates sobre tecnología, startups e innovación en Colombia.',                   'TP',  DATE '2024-01-18', 'S', 5, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Crímenes Sin Resolver',   2022, 55,  'Podcast de true crime con casos colombianos.',                                   '+16', DATE '2024-02-22', 'N', 5, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Mentes Brillantes',       2023, 35,  'Entrevistas con emprendedores e innovadores colombianos.',                       'TP',  DATE '2024-03-25', 'S', 5, 2);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Historias de Terror',     2023, 45,  'Relatos de terror narrados por sus protagonistas.',                              '+13', DATE '2024-04-28', 'S', 5, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Finanzas para Todos',     2024, 30,  'Consejos prácticos de finanzas personales en Colombia.',                         'TP',  DATE '2024-05-30', 'S', 5, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Bienestar Total',         2024, 35,  'Podcast de salud física y mental con expertos.',                                 'TP',  DATE '2024-06-10', 'S', 5, 6);

-- Completar hasta 40: más películas/series
INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'El Milagro',              2024, 102, 'Historia real de superación en los Andes colombianos.',                          '+7',  DATE '2024-06-15', 'S', 1, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Furia en las Calles',     2023, 108, 'Acción urbana: pandillas y policías en una ciudad sin ley.',                     '+18', DATE '2024-07-01', 'N', 1, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Pequeños Gigantes',       2024, 75,  'Serie infantil de aventuras con valores de amistad.',                            'TP',  DATE '2024-07-15', 'S', 2, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'La Firma',                2022, 52,  'Serie jurídica sobre un bufete en Bogotá.',                                      '+13', DATE '2024-08-01', 'S', 2, 2);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Verdades Incómodas',      2023, 70,  'Documental político sobre la corrupción en Colombia.',                            '+13', DATE '2024-08-20', 'S', 3, 6);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Sonidos de la Selva',     2023, 60,  'Compilado de música amazónica y ritmos ancestrales.',                            'TP',  DATE '2024-09-01', 'S', 4, 7);

INSERT INTO contenido (id_contenido, titulo, anio_lanzamiento, duracion, sinopsis, clasificacion_edad, fecha_agregado, es_original, id_categoria, id_empleado_resp)
VALUES (SEQ_CONTENIDO.NEXTVAL, 'Emprender en Colombia',   2024, 45,  'Podcast con casos de éxito de emprendedores colombianos.',                       'TP',  DATE '2024-09-15', 'S', 5, 6);

-- ============================================================
-- 9. CONTENIDO_GENERO (múltiples géneros por contenido)
-- ============================================================
-- Películas
INSERT INTO contenido_genero VALUES (100, 1); -- El Último Vuelo: Acción
INSERT INTO contenido_genero VALUES (100, 4); -- El Último Vuelo: Suspenso
INSERT INTO contenido_genero VALUES (101, 3); -- Amor en Bogotá: Drama
INSERT INTO contenido_genero VALUES (101, 5); -- Amor en Bogotá: Romance
INSERT INTO contenido_genero VALUES (102, 2); -- Risa Asegurada: Comedia
INSERT INTO contenido_genero VALUES (103, 4); -- Sombras del Pasado: Suspenso
INSERT INTO contenido_genero VALUES (103, 3); -- Sombras del Pasado: Drama
INSERT INTO contenido_genero VALUES (104, 7); -- La Grieta: Terror
INSERT INTO contenido_genero VALUES (105, 6); -- Galaxia Perdida: Ciencia Ficción
INSERT INTO contenido_genero VALUES (105, 1); -- Galaxia Perdida: Acción
INSERT INTO contenido_genero VALUES (106, 8); -- Monstruo de Peluche: Infantil
INSERT INTO contenido_genero VALUES (107, 1); -- Código Rojo: Acción
INSERT INTO contenido_genero VALUES (107, 4); -- Código Rojo: Suspenso
INSERT INTO contenido_genero VALUES (108, 5); -- Noches de Cartagena: Romance
INSERT INTO contenido_genero VALUES (108, 3); -- Noches de Cartagena: Drama
INSERT INTO contenido_genero VALUES (109, 1); -- El Gran Robo: Acción
INSERT INTO contenido_genero VALUES (109, 4); -- El Gran Robo: Suspenso
INSERT INTO contenido_genero VALUES (110, 3); -- Más Allá del Horizonte: Drama
INSERT INTO contenido_genero VALUES (111, 2); -- Risas sin Parar 2: Comedia
INSERT INTO contenido_genero VALUES (134, 1); -- El Milagro: Acción (Drama)
INSERT INTO contenido_genero VALUES (134, 3);
INSERT INTO contenido_genero VALUES (135, 1); -- Furia en las Calles: Acción
INSERT INTO contenido_genero VALUES (136, 8); -- Pequeños Gigantes: Infantil
-- Series
INSERT INTO contenido_genero VALUES (112, 3); -- La Casa de los Secretos: Drama
INSERT INTO contenido_genero VALUES (112, 4); -- La Casa de los Secretos: Suspenso
INSERT INTO contenido_genero VALUES (113, 4); -- Detectives del Quindío: Suspenso
INSERT INTO contenido_genero VALUES (114, 8); -- Aventuras Espaciales: Infantil
INSERT INTO contenido_genero VALUES (114, 6); -- Aventuras Espaciales: Ciencia Ficción
INSERT INTO contenido_genero VALUES (115, 4); -- La Red Oscura: Suspenso
INSERT INTO contenido_genero VALUES (115, 6); -- La Red Oscura: Ciencia Ficción
INSERT INTO contenido_genero VALUES (116, 5); -- Corazones Rotos: Romance
INSERT INTO contenido_genero VALUES (116, 3); -- Corazones Rotos: Drama
INSERT INTO contenido_genero VALUES (117, 6); -- El Origen: Ciencia Ficción
INSERT INTO contenido_genero VALUES (137, 4); -- La Firma: Suspenso
INSERT INTO contenido_genero VALUES (137, 3);
-- Documentales
INSERT INTO contenido_genero VALUES (118, 9); -- Café: El Oro Verde: Documental
INSERT INTO contenido_genero VALUES (119, 9); -- Océanos en Peligro: Documental
INSERT INTO contenido_genero VALUES (120, 9); -- Mente Humana: Documental
INSERT INTO contenido_genero VALUES (121, 9); -- Colombia Salvaje: Documental
INSERT INTO contenido_genero VALUES (122, 9); -- Historia del Rock: Documental
INSERT INTO contenido_genero VALUES (122, 10);-- Historia del Rock: Musical
INSERT INTO contenido_genero VALUES (138, 9); -- Verdades Incómodas: Documental
-- Música
INSERT INTO contenido_genero VALUES (123, 10); -- Ritmos del Pacífico: Musical
INSERT INTO contenido_genero VALUES (124, 10); -- Pop Latino Hits: Musical
INSERT INTO contenido_genero VALUES (125, 10); -- Clásicos Eternos: Musical
INSERT INTO contenido_genero VALUES (126, 10); -- Trap Colombiano: Musical
INSERT INTO contenido_genero VALUES (127, 10); -- Salsa Caliente: Musical
INSERT INTO contenido_genero VALUES (139, 10); -- Sonidos de la Selva: Musical
-- Podcasts
INSERT INTO contenido_genero VALUES (128, 9); -- Tech Talk: Documental
INSERT INTO contenido_genero VALUES (129, 4); -- Crímenes Sin Resolver: Suspenso
INSERT INTO contenido_genero VALUES (130, 9); -- Mentes Brillantes: Documental
INSERT INTO contenido_genero VALUES (131, 7); -- Historias de Terror: Terror
INSERT INTO contenido_genero VALUES (132, 9); -- Finanzas para Todos: Documental
INSERT INTO contenido_genero VALUES (133, 9); -- Bienestar Total: Documental
INSERT INTO contenido_genero VALUES (140, 9); -- Emprender en Colombia: Documental

-- ============================================================
-- 10. CONTENIDO_RELACIONADO (secuelas, etc.)
-- ============================================================
INSERT INTO contenido_relacionado VALUES (102, 111, 'SECUELA');   -- Risa Asegurada -> Risas sin Parar 2
INSERT INTO contenido_relacionado VALUES (100, 107, 'SPIN-OFF');  -- El Último Vuelo -> Código Rojo
INSERT INTO contenido_relacionado VALUES (105, 117, 'SECUELA');   -- Galaxia Perdida -> El Origen
INSERT INTO contenido_relacionado VALUES (104, 103, 'PRECUELA');  -- Sombras del Pasado <-> precuela

-- ============================================================
-- 11. TEMPORADAS (15+ registros — para series y podcasts)
-- ============================================================
-- Serie: La Casa de los Secretos (id=112) — 2 temporadas
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 112, 1, 'La Herencia');
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 112, 2, 'Los Secretos Afloran');

-- Serie: Detectives del Quindío (id=113) — 2 temporadas
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 113, 1, 'Primer Caso');
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 113, 2, 'La Conspiración');

-- Serie: Aventuras Espaciales (id=114) — 2 temporadas
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 114, 1, 'El Despegue');
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 114, 2, 'Nuevas Galaxias');

-- Serie: La Red Oscura (id=115) — 1 temporada
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 115, 1, 'Infiltración');

-- Serie: Corazones Rotos (id=116) — 2 temporadas
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 116, 1, 'El Encuentro');
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 116, 2, 'La Ruptura');

-- Serie: El Origen (id=117) — 1 temporada
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 117, 1, 'Primer Contacto');

-- Podcast: Tech Talk Colombia (id=128) — 1 temporada
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 128, 1, 'Temporada 2024');

-- Podcast: Crímenes Sin Resolver (id=129) — 1 temporada
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 129, 1, 'Casos Emblemáticos');

-- Podcast: Historias de Terror (id=131) — 1 temporada
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 131, 1, 'Relatos Oscuros');

-- Serie: Pequeños Gigantes (id=139) — 1 temporada
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 136, 1, 'Aventuras en el Bosque');

-- Serie: La Firma (id=140) — 1 temporada
INSERT INTO temporadas (id_temporada, id_contenido, numero_temporada, titulo)
VALUES (SEQ_TEMPORADAS.NEXTVAL, 137, 1, 'El Caso del Siglo');

-- ============================================================
-- 12. EPISODIOS (50+ registros)
-- id_temporada: 100-114 (según secuencia)
-- ============================================================

-- La Casa de los Secretos T1 (id_temp=100)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 100, 1, 'El Testamento',           44);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 100, 2, 'Voces en la Noche',       45);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 100, 3, 'La Llave Perdida',        43);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 100, 4, 'Sangre y Oro',            46);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 100, 5, 'El Retrato',              44);

-- La Casa de los Secretos T2 (id_temp=101)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 101, 1, 'Regreso a Casa',          47);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 101, 2, 'La Traición',             45);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 101, 3, 'Todo se Revela',          50);

-- Detectives del Quindío T1 (id_temp=102)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 102, 1, 'El Primer Caso',          48);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 102, 2, 'Pistas Falsas',           50);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 102, 3, 'El Sospechoso',           52);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 102, 4, 'La Resolución',           55);

-- Detectives del Quindío T2 (id_temp=103)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 103, 1, 'La Red Corrupta',         51);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 103, 2, 'Contacto Peligroso',      49);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 103, 3, 'La Verdad Oculta',        53);

-- Aventuras Espaciales T1 (id_temp=104)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 104, 1, 'Despegue',                28);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 104, 2, 'El Asteroide',            30);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 104, 3, 'Amigos del Espacio',      29);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 104, 4, 'La Luna de Hielo',        31);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 104, 5, 'Vuelta a Casa',           28);

-- Aventuras Espaciales T2 (id_temp=105)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 105, 1, 'Nueva Misión',            30);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 105, 2, 'Planetas Gemelos',        29);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 105, 3, 'El Robot Rebelde',        32);

-- La Red Oscura T1 (id_temp=106)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 106, 1, 'Infiltrado',              54);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 106, 2, 'Doble Agente',            56);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 106, 3, 'La Trampa',               55);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 106, 4, 'Código Roto',             58);

-- Corazones Rotos T1 (id_temp=107)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 107, 1, 'El Encuentro Casual',     40);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 107, 2, 'Primera Cita',            42);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 107, 3, 'Malentendidos',           41);

-- Corazones Rotos T2 (id_temp=108)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 108, 1, 'Segundas Oportunidades', 43);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 108, 2, 'El Final',               45);

-- El Origen T1 (id_temp=109)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 109, 1, 'La Señal',               58);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 109, 2, 'Contacto',               60);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 109, 3, 'El Mensaje',             62);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 109, 4, 'Primera Respuesta',      59);

-- Tech Talk Colombia T1 (id_temp=110)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 110, 1, 'IA en Colombia',          38);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 110, 2, 'Startups exitosas',       40);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 110, 3, 'El Futuro Digital',       42);

-- Crímenes Sin Resolver T1 (id_temp=111)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 111, 1, 'Caso 001: La Hacienda',   53);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 111, 2, 'Caso 002: El Testigo',    55);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 111, 3, 'Caso 003: Sin Rastro',    50);

-- Historias de Terror T1 (id_temp=112... ajustar al índice real de SEQ)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 113, 1, 'La Casa del Cerro',       43);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 113, 2, 'El Espejo',               45);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 113, 3, 'Voces del Pasado',        47);

-- Relatos Oscuros — episodios adicionales (id_temp=112)
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 112, 1, 'El Faro Olvidado',        46);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 112, 2, 'Susurros del Bosque',     48);

-- El Caso del Siglo (id_temp=114) — 3 episodios
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 114, 1, 'El Expediente Inicial',   52);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 114, 2, 'Pistas Cruzadas',         54);
INSERT INTO episodios (id_episodio, id_temporada, numero_episodio, titulo, duracion) VALUES (SEQ_EPISODIOS.NEXTVAL, 114, 3, 'Veredicto',               58);

-- ============================================================
-- 13. REPRODUCCIONES (200+ registros)
-- Nota: solo perfiles de cuentas ACTIVAS para la mayoría
-- id_reproduccion: 1000+
-- Perfiles activos principales: 100,101,103,104,106,107,108,109,
--   110,111,112,114,116,117,118,120,121,122,124,125,126,127,
--   128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149
-- Usamos perfiles: 100-101 (usr100), 102-103 (usr101), 105 (usr103),
--   106-108 (usr104), 109-110 (usr105), 111-113 (usr106), 114-115 (usr107),
--   116-119 (usr108), 120-122 (usr109), 123-124 (usr110), etc.
-- Para simplificar usamos IDs de perfil conocidos.
-- ============================================================

-- Reproducciones de contenido directo (películas, docs, música)
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 100, NULL, TIMESTAMP '2025-01-05 20:00:00', TIMESTAMP '2025-01-05 22:00:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 101, NULL, TIMESTAMP '2025-01-10 21:00:00', TIMESTAMP '2025-01-10 22:35:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 103, NULL, TIMESTAMP '2025-01-15 22:00:00', TIMESTAMP '2025-01-15 23:50:00', 'COMPUTADOR', 95);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 107, NULL, TIMESTAMP '2025-02-02 21:30:00', TIMESTAMP '2025-02-02 23:25:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 109, NULL, TIMESTAMP '2025-02-14 20:00:00', TIMESTAMP '2025-02-14 21:40:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 118, NULL, TIMESTAMP '2025-03-01 18:00:00', TIMESTAMP '2025-03-01 19:15:00', 'CELULAR',    100);

INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 101, 106, NULL, TIMESTAMP '2025-01-07 15:00:00', TIMESTAMP '2025-01-07 17:10:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 101, 119, NULL, TIMESTAMP '2025-02-20 10:00:00', TIMESTAMP '2025-02-20 11:30:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 101, 120, NULL, TIMESTAMP '2025-03-05 16:00:00', TIMESTAMP '2025-03-05 17:00:00', 'COMPUTADOR', 100);

-- Perfil infantil (100+1=101 es Juanito, infantil)
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 101, 106, NULL, TIMESTAMP '2025-01-20 09:00:00', TIMESTAMP '2025-01-20 10:20:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 101, 102, NULL, TIMESTAMP '2025-02-08 10:00:00', TIMESTAMP '2025-02-08 11:28:00', 'TV',         100);

-- Perfiles de usuario 104 (Estándar, 3 perfiles: 106,107,108)
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 106, 100, NULL, TIMESTAMP '2025-01-03 21:00:00', TIMESTAMP '2025-01-03 23:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 106, 104, NULL, TIMESTAMP '2025-01-18 22:00:00', TIMESTAMP '2025-01-18 23:50:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 106, 109, NULL, TIMESTAMP '2025-02-01 20:00:00', TIMESTAMP '2025-02-01 21:40:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 106, 110, NULL, TIMESTAMP '2025-02-22 21:00:00', TIMESTAMP '2025-02-22 22:58:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 107, 101, NULL, TIMESTAMP '2025-01-25 20:30:00', TIMESTAMP '2025-01-25 22:05:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 107, 108, NULL, TIMESTAMP '2025-03-10 21:00:00', TIMESTAMP '2025-03-10 22:55:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 108, 106, NULL, TIMESTAMP '2025-01-12 11:00:00', TIMESTAMP '2025-01-12 13:10:00', 'TABLET',     100);

-- Reproducciones de episodios de series
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 109, NULL, 100, TIMESTAMP '2025-01-05 19:00:00', TIMESTAMP '2025-01-05 19:44:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 109, NULL, 101, TIMESTAMP '2025-01-06 19:00:00', TIMESTAMP '2025-01-06 19:45:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 109, NULL, 102, TIMESTAMP '2025-01-07 19:00:00', TIMESTAMP '2025-01-07 19:43:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 109, NULL, 103, TIMESTAMP '2025-01-08 19:30:00', TIMESTAMP '2025-01-08 20:16:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 109, NULL, 104, TIMESTAMP '2025-01-09 19:00:00', TIMESTAMP '2025-01-09 19:44:00', 'TV',         100);

INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 110, NULL, 108, TIMESTAMP '2025-02-05 21:00:00', TIMESTAMP '2025-02-05 21:47:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 110, NULL, 109, TIMESTAMP '2025-02-07 21:00:00', TIMESTAMP '2025-02-07 22:00:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 110, NULL, 110, TIMESTAMP '2025-02-09 21:00:00', TIMESTAMP '2025-02-09 21:52:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 110, NULL, 111, TIMESTAMP '2025-02-11 21:00:00', TIMESTAMP '2025-02-11 21:55:00', 'COMPUTADOR', 100);

-- Reproducciones de múltiples perfiles Premium (108-123)
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, 100, NULL, TIMESTAMP '2025-01-10 20:00:00', TIMESTAMP '2025-01-10 22:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, 105, NULL, TIMESTAMP '2025-02-15 21:00:00', TIMESTAMP '2025-02-15 23:10:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, 110, NULL, TIMESTAMP '2025-03-20 22:00:00', TIMESTAMP '2025-03-20 23:58:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 117, 101, NULL, TIMESTAMP '2025-01-15 21:00:00', TIMESTAMP '2025-01-15 22:35:00', 'CELULAR',    80);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 117, 109, NULL, TIMESTAMP '2025-02-20 20:30:00', TIMESTAMP '2025-02-20 22:10:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 118, 118, NULL, TIMESTAMP '2025-01-18 09:00:00', TIMESTAMP '2025-01-18 10:15:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 118, 119, NULL, TIMESTAMP '2025-02-23 10:00:00', TIMESTAMP '2025-02-23 11:30:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 119, 102, NULL, TIMESTAMP '2025-03-01 16:00:00', TIMESTAMP '2025-03-01 17:28:00', 'TV',         100);

-- Bloques de reproducciones para alcanzar 200 (variados dispositivos y fechas)
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 120, 123, NULL, TIMESTAMP '2025-01-05 08:00:00', TIMESTAMP '2025-01-05 08:50:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 120, 124, NULL, TIMESTAMP '2025-02-10 07:30:00', TIMESTAMP '2025-02-10 08:35:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 121, 125, NULL, TIMESTAMP '2025-01-12 22:00:00', TIMESTAMP '2025-01-12 23:30:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 122, 100, NULL, TIMESTAMP '2025-02-14 21:00:00', TIMESTAMP '2025-02-14 23:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 123, 127, NULL, TIMESTAMP '2025-01-20 19:00:00', TIMESTAMP '2025-01-20 20:10:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 124, 107, NULL, TIMESTAMP '2025-03-03 21:00:00', TIMESTAMP '2025-03-03 22:55:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 125, 104, NULL, TIMESTAMP '2025-02-25 22:00:00', TIMESTAMP '2025-02-25 23:50:00', 'CELULAR',    95);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 126, 103, NULL, TIMESTAMP '2025-01-30 20:00:00', TIMESTAMP '2025-01-30 21:48:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 127, 110, NULL, TIMESTAMP '2025-03-15 21:00:00', TIMESTAMP '2025-03-15 22:58:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 128, 119, NULL, TIMESTAMP '2025-02-18 10:00:00', TIMESTAMP '2025-02-18 11:30:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 129, 121, NULL, TIMESTAMP '2025-01-22 16:00:00', TIMESTAMP '2025-01-22 17:20:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 130, 120, NULL, TIMESTAMP '2025-03-08 11:00:00', TIMESTAMP '2025-03-08 12:00:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 131, 122, NULL, TIMESTAMP '2025-02-05 09:00:00', TIMESTAMP '2025-02-05 11:00:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 132, 126, NULL, TIMESTAMP '2025-03-12 22:00:00', TIMESTAMP '2025-03-12 22:55:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 133, 128, NULL, TIMESTAMP '2025-01-28 07:00:00', TIMESTAMP '2025-01-28 07:38:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 134, 130, NULL, TIMESTAMP '2025-02-12 06:30:00', TIMESTAMP '2025-02-12 07:05:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 135, 100, NULL, TIMESTAMP '2025-03-20 21:00:00', TIMESTAMP '2025-03-20 23:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 136, 105, NULL, TIMESTAMP '2025-01-16 21:30:00', TIMESTAMP '2025-01-16 23:40:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 137, 103, NULL, TIMESTAMP '2025-02-08 22:00:00', TIMESTAMP '2025-02-08 23:50:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 138, 109, NULL, TIMESTAMP '2025-03-25 20:00:00', TIMESTAMP '2025-03-25 21:40:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 139, 101, NULL, TIMESTAMP '2025-01-19 21:00:00', TIMESTAMP '2025-01-19 22:35:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 140, 108, NULL, TIMESTAMP '2025-02-28 21:00:00', TIMESTAMP '2025-02-28 22:55:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 141, 100, NULL, TIMESTAMP '2025-01-07 21:00:00', TIMESTAMP '2025-01-07 23:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 142, 123, NULL, TIMESTAMP '2025-03-18 08:00:00', TIMESTAMP '2025-03-18 08:50:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 143, 104, NULL, TIMESTAMP '2025-02-03 22:00:00', TIMESTAMP '2025-02-03 23:50:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 144, 110, NULL, TIMESTAMP '2025-01-14 21:00:00', TIMESTAMP '2025-01-14 22:58:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 145, 105, NULL, TIMESTAMP '2025-03-10 22:00:00', TIMESTAMP '2025-03-10 23:10:00', 'TV',          45);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 146, 107, NULL, TIMESTAMP '2025-02-17 21:00:00', TIMESTAMP '2025-02-17 22:55:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 147, 109, NULL, TIMESTAMP '2025-03-22 20:30:00', TIMESTAMP '2025-03-22 22:10:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 148, 119, NULL, TIMESTAMP '2025-01-25 15:00:00', TIMESTAMP '2025-01-25 16:30:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 149, 121, NULL, TIMESTAMP '2025-02-22 11:00:00', TIMESTAMP '2025-02-22 12:20:00', 'COMPUTADOR', 100);

-- Más reproducciones de episodios para varios perfiles
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, NULL, 116, TIMESTAMP '2025-01-05 20:00:00', TIMESTAMP '2025-01-05 21:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, NULL, 117, TIMESTAMP '2025-01-06 20:00:00', TIMESTAMP '2025-01-06 21:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, NULL, 118, TIMESTAMP '2025-01-07 20:00:00', TIMESTAMP '2025-01-07 21:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 120, NULL, 125, TIMESTAMP '2025-02-15 21:00:00', TIMESTAMP '2025-02-15 21:54:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 120, NULL, 126, TIMESTAMP '2025-02-16 21:00:00', TIMESTAMP '2025-02-16 21:56:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 120, NULL, 127, TIMESTAMP '2025-02-17 21:00:00', TIMESTAMP '2025-02-17 21:55:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 125, NULL, 133, TIMESTAMP '2025-03-01 07:00:00', TIMESTAMP '2025-03-01 07:53:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 125, NULL, 134, TIMESTAMP '2025-03-03 07:00:00', TIMESTAMP '2025-03-03 07:55:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 125, NULL, 135, TIMESTAMP '2025-03-05 07:00:00', TIMESTAMP '2025-03-05 07:50:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 127, NULL, 119, TIMESTAMP '2025-01-10 21:00:00', TIMESTAMP '2025-01-10 22:40:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 127, NULL, 120, TIMESTAMP '2025-01-11 21:00:00', TIMESTAMP '2025-01-11 22:43:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 127, NULL, 121, TIMESTAMP '2025-01-12 21:00:00', TIMESTAMP '2025-01-12 22:44:00', 'TV',         100);

-- Reproducciones adicionales para alcanzar 200 (bloques variados 2025 y 2026)
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 134, NULL, TIMESTAMP '2025-04-05 21:00:00', TIMESTAMP '2025-04-05 22:42:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 106, 135, NULL, TIMESTAMP '2025-04-10 22:00:00', TIMESTAMP '2025-04-10 23:48:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 108, 138, NULL, TIMESTAMP '2025-04-15 10:00:00', TIMESTAMP '2025-04-15 11:10:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, 100, NULL, TIMESTAMP '2025-04-20 21:00:00', TIMESTAMP '2025-04-20 23:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 120, 140, NULL, TIMESTAMP '2025-05-01 07:00:00', TIMESTAMP '2025-05-01 07:45:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 127, 134, NULL, TIMESTAMP '2025-05-05 21:00:00', TIMESTAMP '2025-05-05 22:42:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 133, 128, NULL, TIMESTAMP '2025-05-10 07:00:00', TIMESTAMP '2025-05-10 07:38:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 134, 132, NULL, TIMESTAMP '2025-05-15 06:30:00', TIMESTAMP '2025-05-15 07:00:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 109, NULL, 105, TIMESTAMP '2025-05-20 19:00:00', TIMESTAMP '2025-05-20 19:44:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 110, NULL, 112, TIMESTAMP '2025-05-22 21:00:00', TIMESTAMP '2025-05-22 21:43:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, NULL, 122, TIMESTAMP '2025-06-01 20:00:00', TIMESTAMP '2025-06-01 21:02:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 120, NULL, 128, TIMESTAMP '2025-06-05 20:00:00', TIMESTAMP '2025-06-05 21:00:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 105, NULL, TIMESTAMP '2025-06-10 22:00:00', TIMESTAMP '2025-06-10 23:10:00', 'TV',         60);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 106, 109, NULL, TIMESTAMP '2025-06-15 20:30:00', TIMESTAMP '2025-06-15 22:10:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, 138, NULL, TIMESTAMP '2025-07-01 10:00:00', TIMESTAMP '2025-07-01 11:10:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 127, 105, NULL, TIMESTAMP '2025-07-05 21:30:00', TIMESTAMP '2025-07-05 23:40:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 138, 100, NULL, TIMESTAMP '2025-07-10 21:00:00', TIMESTAMP '2025-07-10 23:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 139, 110, NULL, TIMESTAMP '2025-07-15 21:00:00', TIMESTAMP '2025-07-15 22:58:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 140, 101, NULL, TIMESTAMP '2025-08-01 20:00:00', TIMESTAMP '2025-08-01 21:35:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 141, 105, NULL, TIMESTAMP '2025-08-10 21:00:00', TIMESTAMP '2025-08-10 23:10:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 142, 107, NULL, TIMESTAMP '2025-09-01 21:00:00', TIMESTAMP '2025-09-01 22:55:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 143, 103, NULL, TIMESTAMP '2025-09-10 22:00:00', TIMESTAMP '2025-09-10 23:50:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 144, 134, NULL, TIMESTAMP '2025-09-20 21:00:00', TIMESTAMP '2025-09-20 22:42:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 145, 108, NULL, TIMESTAMP '2025-10-01 21:00:00', TIMESTAMP '2025-10-01 22:55:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 146, 109, NULL, TIMESTAMP '2025-10-15 20:30:00', TIMESTAMP '2025-10-15 22:10:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 147, 119, NULL, TIMESTAMP '2025-11-01 15:00:00', TIMESTAMP '2025-11-01 16:30:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 148, 121, NULL, TIMESTAMP '2025-11-10 11:00:00', TIMESTAMP '2025-11-10 12:20:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 149, 100, NULL, TIMESTAMP '2025-11-20 21:00:00', TIMESTAMP '2025-11-20 23:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 110, NULL, TIMESTAMP '2025-12-01 21:00:00', TIMESTAMP '2025-12-01 22:58:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 106, 105, NULL, TIMESTAMP '2025-12-10 22:00:00', TIMESTAMP '2025-12-10 23:10:00', 'TV',          50);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, 107, NULL, TIMESTAMP '2025-12-15 21:00:00', TIMESTAMP '2025-12-15 22:55:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 127, 110, NULL, TIMESTAMP '2025-12-20 21:00:00', TIMESTAMP '2025-12-20 22:58:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 138, 109, NULL, TIMESTAMP '2026-01-05 20:30:00', TIMESTAMP '2026-01-05 22:10:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 139, 101, NULL, TIMESTAMP '2026-01-10 21:00:00', TIMESTAMP '2026-01-10 22:35:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 140, 108, NULL, TIMESTAMP '2026-01-15 21:00:00', TIMESTAMP '2026-01-15 22:55:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 141, 100, NULL, TIMESTAMP '2026-01-20 21:00:00', TIMESTAMP '2026-01-20 23:00:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 142, 119, NULL, TIMESTAMP '2026-02-01 10:00:00', TIMESTAMP '2026-02-01 11:30:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 143, 121, NULL, TIMESTAMP '2026-02-05 16:00:00', TIMESTAMP '2026-02-05 17:20:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 109, NULL, 106, TIMESTAMP '2026-02-10 19:00:00', TIMESTAMP '2026-02-10 19:44:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 109, NULL, 107, TIMESTAMP '2026-02-11 19:00:00', TIMESTAMP '2026-02-11 19:45:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, NULL, 123, TIMESTAMP '2026-02-15 20:00:00', TIMESTAMP '2026-02-15 21:43:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 120, NULL, 129, TIMESTAMP '2026-03-01 21:00:00', TIMESTAMP '2026-03-01 21:53:00', 'COMPUTADOR', 100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 125, NULL, 136, TIMESTAMP '2026-03-05 07:00:00', TIMESTAMP '2026-03-05 07:53:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 127, NULL, 122, TIMESTAMP '2026-03-10 21:00:00', TIMESTAMP '2026-03-10 22:43:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 133, 140, NULL, TIMESTAMP '2026-03-15 07:00:00', TIMESTAMP '2026-03-15 07:45:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 144, 138, NULL, TIMESTAMP '2026-03-18 10:00:00', TIMESTAMP '2026-03-18 11:10:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 149, 107, NULL, TIMESTAMP '2026-03-20 21:00:00', TIMESTAMP '2026-03-20 22:55:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 138, NULL, TIMESTAMP '2026-03-25 10:00:00', TIMESTAMP '2026-03-25 11:10:00', 'TABLET',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 106, 140, NULL, TIMESTAMP '2026-03-28 07:00:00', TIMESTAMP '2026-03-28 07:45:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, 134, NULL, TIMESTAMP '2026-04-01 21:00:00', TIMESTAMP '2026-04-01 22:42:00', 'TV',         100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 120, 123, NULL, TIMESTAMP '2026-04-02 08:00:00', TIMESTAMP '2026-04-02 08:50:00', 'CELULAR',    100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 127, 135, NULL, TIMESTAMP '2026-04-03 22:00:00', TIMESTAMP '2026-04-03 23:48:00', 'TV',         100);
-- Reproducciones sin terminar (porcentaje_avance < 100)
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 103, 100, NULL, TIMESTAMP '2025-03-10 21:00:00', NULL,                             'CELULAR',    30);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 105, 107, NULL, TIMESTAMP '2025-04-01 22:00:00', NULL,                             'TV',         15);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 112, 103, NULL, TIMESTAMP '2025-05-15 21:00:00', NULL,                             'COMPUTADOR', 45);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 114, 118, NULL, TIMESTAMP '2025-07-20 18:00:00', NULL,                             'TABLET',     70);

-- ============================================================
-- 13.b REPRODUCCIONES ADICIONALES (66 registros más para llegar a 200+)
-- Datos asimétricos: dispositivos TV/CELULAR predominan, mezcla
-- contenido directo y episodios, distribución 2024-2026 para activar
-- todas las particiones del rango de fragmentación.
-- ============================================================

-- --- 2024 (partición p_2024): 5 registros ---
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 100, NULL, TIMESTAMP '2024-11-12 20:00:00', TIMESTAMP '2024-11-12 21:55:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 104, NULL, 110, TIMESTAMP '2024-11-25 21:30:00', TIMESTAMP '2024-11-25 22:20:00', 'COMPUTADOR',  98);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, 105, NULL, TIMESTAMP '2024-12-08 19:00:00', TIMESTAMP '2024-12-08 20:30:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 120, NULL, 100, TIMESTAMP '2024-12-18 18:00:00', TIMESTAMP '2024-12-18 18:50:00', 'CELULAR',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 128, 132, NULL, TIMESTAMP '2024-12-28 22:00:00', TIMESTAMP '2024-12-28 23:35:00', 'TV',          100);

-- --- 2025 Q1 (partición p_2025): 8 registros ---
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 101, NULL, 105, TIMESTAMP '2025-01-08 21:00:00', TIMESTAMP '2025-01-08 21:48:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 103, 117, NULL, TIMESTAMP '2025-01-15 22:00:00', TIMESTAMP '2025-01-15 23:30:00', 'COMPUTADOR',  100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 106, NULL, 117, TIMESTAMP '2025-01-22 19:00:00', TIMESTAMP '2025-01-22 19:53:00', 'TABLET',      100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 109, 122, NULL, TIMESTAMP '2025-02-03 20:00:00', TIMESTAMP '2025-02-03 21:35:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 111, 100, NULL, TIMESTAMP '2025-02-12 21:30:00', TIMESTAMP '2025-02-12 23:25:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 117, NULL, 125, TIMESTAMP '2025-02-25 18:00:00', TIMESTAMP '2025-02-25 18:55:00', 'CELULAR',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 122, 136, NULL, TIMESTAMP '2025-03-05 07:00:00', TIMESTAMP '2025-03-05 07:38:00', 'CELULAR',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 125, 113, NULL, TIMESTAMP '2025-03-18 22:00:00', TIMESTAMP '2025-03-18 23:48:00', 'TV',          100);

-- --- 2025 Q2: 12 registros ---
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, NULL, 109, TIMESTAMP '2025-04-02 19:30:00', TIMESTAMP '2025-04-02 20:25:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 102, 119, NULL, TIMESTAMP '2025-04-10 21:00:00', TIMESTAMP '2025-04-10 22:30:00', 'COMPUTADOR',  100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 107, 128, NULL, TIMESTAMP '2025-04-15 09:00:00', TIMESTAMP '2025-04-15 09:42:00', 'CELULAR',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 110, NULL, 134, TIMESTAMP '2025-04-22 20:00:00', TIMESTAMP '2025-04-22 20:53:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 113, 102, NULL, TIMESTAMP '2025-05-04 22:00:00', TIMESTAMP '2025-05-04 23:47:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 118, NULL, 113, TIMESTAMP '2025-05-12 21:30:00', TIMESTAMP '2025-05-12 22:18:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 121, 124, NULL, TIMESTAMP '2025-05-20 08:00:00', TIMESTAMP '2025-05-20 08:55:00', 'CELULAR',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 124, 137, NULL, TIMESTAMP '2025-05-28 19:00:00', TIMESTAMP '2025-05-28 20:42:00', 'COMPUTADOR',  100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 127, NULL, 120, TIMESTAMP '2025-06-05 21:00:00', TIMESTAMP '2025-06-05 21:54:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 130, 106, NULL, TIMESTAMP '2025-06-12 22:30:00', TIMESTAMP '2025-06-12 23:58:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 133, 130, NULL, TIMESTAMP '2025-06-20 18:00:00', TIMESTAMP '2025-06-20 19:38:00', 'TABLET',      100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 135, NULL, 142, TIMESTAMP '2025-06-28 20:00:00', TIMESTAMP '2025-06-28 20:58:00', 'TV',          100);

-- --- 2025 Q3: 12 registros ---
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 116, NULL, TIMESTAMP '2025-07-03 21:00:00', TIMESTAMP '2025-07-03 22:38:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 105, NULL, 145, TIMESTAMP '2025-07-09 19:30:00', TIMESTAMP '2025-07-09 20:16:00', 'CELULAR',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 108, 121, NULL, TIMESTAMP '2025-07-16 22:00:00', TIMESTAMP '2025-07-16 23:48:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 112, NULL, 147, TIMESTAMP '2025-07-23 20:00:00', TIMESTAMP '2025-07-23 20:52:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 115, 134, NULL, TIMESTAMP '2025-08-02 09:00:00', TIMESTAMP '2025-08-02 09:48:00', 'CELULAR',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 119, NULL, 130, TIMESTAMP '2025-08-10 21:00:00', TIMESTAMP '2025-08-10 21:48:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 123, 108, NULL, TIMESTAMP '2025-08-17 18:30:00', TIMESTAMP '2025-08-17 20:08:00', 'COMPUTADOR',  100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 126, NULL, 103, TIMESTAMP '2025-08-25 19:00:00', TIMESTAMP '2025-08-25 19:48:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 129, 139, NULL, TIMESTAMP '2025-09-04 22:00:00', TIMESTAMP '2025-09-04 23:30:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 132, 110, NULL, TIMESTAMP '2025-09-12 20:30:00', TIMESTAMP '2025-09-12 22:08:00', 'COMPUTADOR',  100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 137, NULL, 115, TIMESTAMP '2025-09-20 21:00:00', TIMESTAMP '2025-09-20 21:54:00', 'TABLET',      100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 140, 127, NULL, TIMESTAMP '2025-09-28 19:00:00', TIMESTAMP '2025-09-28 20:38:00', 'TV',          100);

-- --- 2025 Q4: 8 registros ---
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 101, 135, NULL, TIMESTAMP '2025-10-05 21:30:00', TIMESTAMP '2025-10-05 23:08:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 104, NULL, 148, TIMESTAMP '2025-10-14 20:00:00', TIMESTAMP '2025-10-14 20:54:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 110, 102, NULL, TIMESTAMP '2025-10-22 22:00:00', TIMESTAMP '2025-10-22 23:47:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 116, NULL, 149, TIMESTAMP '2025-11-02 19:00:00', TIMESTAMP '2025-11-02 19:58:00', 'COMPUTADOR',  100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 122, 131, NULL, TIMESTAMP '2025-11-12 18:00:00', TIMESTAMP '2025-11-12 18:38:00', 'CELULAR',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 128, NULL, 124, TIMESTAMP '2025-11-22 21:00:00', TIMESTAMP '2025-11-22 21:54:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 134, 114, NULL, TIMESTAMP '2025-12-03 20:30:00', TIMESTAMP '2025-12-03 22:18:00', 'COMPUTADOR',  100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 141, 125, NULL, TIMESTAMP '2025-12-18 22:00:00', TIMESTAMP '2025-12-18 23:35:00', 'TV',          100);

-- --- 2026 Q1 (partición p_2026): 13 registros ---
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 100, 100, NULL, TIMESTAMP '2026-01-04 21:00:00', TIMESTAMP '2026-01-04 22:55:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 103, NULL, 132, TIMESTAMP '2026-01-09 19:30:00', TIMESTAMP '2026-01-09 20:25:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 107, 135, NULL, TIMESTAMP '2026-01-15 22:00:00', TIMESTAMP '2026-01-15 23:48:00', 'COMPUTADOR',  100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 111, NULL, 100, TIMESTAMP '2026-01-22 20:00:00', TIMESTAMP '2026-01-22 20:44:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 117, 105, NULL, TIMESTAMP '2026-02-02 21:30:00', TIMESTAMP '2026-02-02 23:00:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 121, NULL, 119, TIMESTAMP '2026-02-08 09:00:00', TIMESTAMP '2026-02-08 09:48:00', 'CELULAR',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 124, 113, NULL, TIMESTAMP '2026-02-14 20:00:00', TIMESTAMP '2026-02-14 21:48:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 129, NULL, 144, TIMESTAMP '2026-02-21 18:00:00', TIMESTAMP '2026-02-21 18:53:00', 'TABLET',      100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 132, 136, NULL, TIMESTAMP '2026-03-02 07:30:00', TIMESTAMP '2026-03-02 08:05:00', 'CELULAR',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 138, NULL, 128, TIMESTAMP '2026-03-09 21:00:00', TIMESTAMP '2026-03-09 21:48:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 142, 117, NULL, TIMESTAMP '2026-03-16 22:00:00', TIMESTAMP '2026-03-16 23:30:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 145, NULL, 122, TIMESTAMP '2026-03-23 19:00:00', TIMESTAMP '2026-03-23 19:55:00', 'COMPUTADOR',  100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 148, 129, NULL, TIMESTAMP '2026-03-30 20:00:00', TIMESTAMP '2026-03-30 21:42:00', 'TV',          100);

-- --- 2026 Abril (partición p_2026, parciales): 8 registros ---
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 102, 100, NULL, TIMESTAMP '2026-04-05 21:00:00', NULL,                             'CELULAR',     35);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 106, NULL, 110, TIMESTAMP '2026-04-08 19:00:00', TIMESTAMP '2026-04-08 19:30:00', 'TV',           75);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 113, 121, NULL, TIMESTAMP '2026-04-11 22:00:00', TIMESTAMP '2026-04-11 23:30:00', 'COMPUTADOR',   90);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 119, NULL, 147, TIMESTAMP '2026-04-15 20:00:00', TIMESTAMP '2026-04-15 20:42:00', 'TABLET',      100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 125, 134, NULL, TIMESTAMP '2026-04-19 09:00:00', TIMESTAMP '2026-04-19 09:48:00', 'CELULAR',     100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 131, NULL, 139, TIMESTAMP '2026-04-22 21:00:00', TIMESTAMP '2026-04-22 21:48:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 136, 108, NULL, TIMESTAMP '2026-04-26 22:00:00', TIMESTAMP '2026-04-26 23:35:00', 'TV',          100);
INSERT INTO reproducciones (id_reproduccion, id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance)
VALUES (SEQ_REPRODUCCIONES.NEXTVAL, 144, NULL, 145, TIMESTAMP '2026-04-29 18:30:00', TIMESTAMP '2026-04-29 19:14:00', 'COMPUTADOR',  100);

-- ============================================================
-- 14. CALIFICACIONES (60+ registros)
-- Solo perfiles con reproducciones >= 50% del contenido
-- ============================================================
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 100, 100, 5, 'Increíble película, mucha tensión.', DATE '2025-01-06');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 100, 101, 4, 'Bonita historia de amor.', DATE '2025-01-11');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 100, 103, 3, NULL, DATE '2025-01-16');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 100, 107, 5, 'Acción de primer nivel.', DATE '2025-02-03');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 100, 109, 4, NULL, DATE '2025-02-15');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 100, 118, 5, 'Excelente documental sobre el café.', DATE '2025-03-02');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 101, 106, 5, 'Espectacular película de ciencia ficción.', DATE '2025-01-08');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 101, 119, 4, NULL, DATE '2025-02-21');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 101, 120, 3, 'Interesante pero muy técnico.', DATE '2025-03-06');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 106, 100, 4, NULL, DATE '2025-01-04');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 106, 104, 2, 'No me convenció mucho.', DATE '2025-01-19');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 106, 109, 5, 'De las mejores románticas.', DATE '2025-02-02');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 106, 110, 4, NULL, DATE '2025-02-23');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 107, 101, 4, NULL, DATE '2025-01-26');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 107, 108, 5, 'Obra maestra del suspenso.', DATE '2025-03-11');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 108, 106, 5, NULL, DATE '2025-01-13');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 116, 100, 3, 'Esperaba más acción.', DATE '2025-01-11');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 116, 105, 5, 'La mejor de ciencia ficción.', DATE '2025-02-16');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 116, 110, 4, NULL, DATE '2025-03-21');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 117, 101, 3, NULL, DATE '2025-01-16');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 117, 109, 5, 'Romanticismo al máximo.', DATE '2025-02-21');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 118, 118, 5, 'El mejor documental del café.', DATE '2025-01-19');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 118, 119, 4, NULL, DATE '2025-02-24');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 119, 102, 4, 'Muy divertida.', DATE '2025-03-02');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 120, 123, 5, NULL, DATE '2025-01-06');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 120, 124, 4, 'Buenas canciones.', DATE '2025-02-11');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 121, 125, 3, NULL, DATE '2025-01-13');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 122, 100, 5, 'Excelente película.', DATE '2025-02-15');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 123, 127, 4, NULL, DATE '2025-01-21');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 124, 107, 5, 'Acción no para.', DATE '2025-03-04');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 125, 104, 1, 'No me gustó para nada.', DATE '2025-02-26');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 126, 103, 4, NULL, DATE '2025-01-31');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 127, 110, 5, NULL, DATE '2025-03-16');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 128, 119, 4, 'Muy informativo.', DATE '2025-02-19');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 129, 121, 5, 'Colombia es hermosa.', DATE '2025-01-23');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 130, 120, 3, NULL, DATE '2025-03-09');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 131, 122, 4, 'Historia del rock muy completa.', DATE '2025-02-06');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 132, 126, 2, NULL, DATE '2025-03-13');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 133, 128, 5, 'El mejor podcast tech de Colombia.', DATE '2025-01-29');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 134, 130, 4, NULL, DATE '2025-02-13');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 135, 100, 4, NULL, DATE '2025-03-21');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 136, 105, 5, 'Masterpiece.', DATE '2025-01-17');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 137, 103, 3, NULL, DATE '2025-02-09');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 138, 109, 4, NULL, DATE '2025-03-26');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 139, 101, 5, 'Historia de amor perfecta.', DATE '2025-01-20');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 140, 108, 4, NULL, DATE '2025-03-01');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 141, 100, 3, NULL, DATE '2025-01-08');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 142, 123, 5, 'Folklore puro.', DATE '2025-03-19');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 143, 104, 2, NULL, DATE '2025-02-04');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 144, 110, 4, NULL, DATE '2025-01-15');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 145, 108, 3, NULL, DATE '2025-10-02');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 146, 109, 5, 'Simplemente perfecta.', DATE '2025-10-16');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 147, 119, 4, NULL, DATE '2025-11-02');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 148, 121, 5, 'Biodiversidad increíble.', DATE '2025-11-11');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 149, 100, 4, NULL, DATE '2025-11-21');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 100, 134, 5, 'Historia inspiradora.', DATE '2025-04-06');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 106, 135, 4, NULL, DATE '2025-04-11');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 108, 138, 5, 'Documental muy revelador.', DATE '2025-04-16');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 116, 138, 4, NULL, DATE '2025-07-02');
INSERT INTO calificaciones (id_calificacion, id_perfil, id_contenido, estrellas, resenia, fecha_calificacion)
VALUES (SEQ_CALIFICACIONES.NEXTVAL, 127, 134, 5, 'Muy emotiva.', DATE '2025-05-06');

-- ============================================================
-- 15. FAVORITOS (40 registros)
-- ============================================================
INSERT INTO favoritos VALUES (100, 100);
INSERT INTO favoritos VALUES (100, 101);
INSERT INTO favoritos VALUES (100, 107);
INSERT INTO favoritos VALUES (100, 118);
INSERT INTO favoritos VALUES (101, 106);
INSERT INTO favoritos VALUES (101, 119);
INSERT INTO favoritos VALUES (106, 100);
INSERT INTO favoritos VALUES (106, 109);
INSERT INTO favoritos VALUES (106, 110);
INSERT INTO favoritos VALUES (107, 101);
INSERT INTO favoritos VALUES (107, 108);
INSERT INTO favoritos VALUES (108, 106);
INSERT INTO favoritos VALUES (109, 112);
INSERT INTO favoritos VALUES (110, 113);
INSERT INTO favoritos VALUES (116, 100);
INSERT INTO favoritos VALUES (116, 105);
INSERT INTO favoritos VALUES (117, 109);
INSERT INTO favoritos VALUES (118, 118);
INSERT INTO favoritos VALUES (119, 102);
INSERT INTO favoritos VALUES (120, 123);
INSERT INTO favoritos VALUES (120, 124);
INSERT INTO favoritos VALUES (121, 125);
INSERT INTO favoritos VALUES (122, 100);
INSERT INTO favoritos VALUES (123, 127);
INSERT INTO favoritos VALUES (124, 107);
INSERT INTO favoritos VALUES (126, 103);
INSERT INTO favoritos VALUES (127, 110);
INSERT INTO favoritos VALUES (128, 119);
INSERT INTO favoritos VALUES (129, 121);
INSERT INTO favoritos VALUES (130, 120);
INSERT INTO favoritos VALUES (131, 122);
INSERT INTO favoritos VALUES (133, 128);
INSERT INTO favoritos VALUES (134, 130);
INSERT INTO favoritos VALUES (135, 100);
INSERT INTO favoritos VALUES (136, 105);
INSERT INTO favoritos VALUES (138, 109);
INSERT INTO favoritos VALUES (140, 108);
INSERT INTO favoritos VALUES (142, 123);
INSERT INTO favoritos VALUES (144, 110);
INSERT INTO favoritos VALUES (149, 100);

-- ============================================================
-- 16. PAGOS (80+ registros)
-- Varios meses, algunos fallidos, distribuidos entre usuarios
-- Métodos variados, descuentos aplicados a usuarios con referidos
-- ============================================================

-- Usuario 100 (desde ene 2024) - Armenia Básico
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 100, DATE '2024-01-10', 14900, 0,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 100, DATE '2024-02-10', 14900, 0,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 100, DATE '2024-03-10', 14900, 0,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 100, DATE '2025-01-10', 14900, 0,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 100, DATE '2025-02-10', 14900, 0,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 100, DATE '2026-03-10', 14900, 0,   'NEQUI',           'EXITOSO');

-- Usuario 101 (referido, descuento 5%)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 101, DATE '2024-02-15', 14155, 5,   'DAVIPLATA',       'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 101, DATE '2025-01-15', 14155, 5,   'DAVIPLATA',       'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 101, DATE '2026-03-15', 14155, 5,   'DAVIPLATA',       'EXITOSO');

-- Usuario 102 (INACTIVO — últimos pagos fallidos)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 102, DATE '2025-09-01', 14900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 102, DATE '2025-10-01', 14900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 102, DATE '2025-11-01', 14900, 0,   'PSE',             'FALLIDO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 102, DATE '2025-12-01', 14900, 0,   'PSE',             'FALLIDO');

-- Usuario 104 (Estándar Armenia) - varios meses
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 104, DATE '2024-06-05', 24900, 0,   'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 104, DATE '2025-01-05', 24900, 0,   'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 104, DATE '2025-06-05', 24900, 0,   'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 104, DATE '2026-03-05', 24900, 0,   'TARJETA_CREDITO', 'EXITOSO');

-- Usuario 105 (Estándar Armenia)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 105, DATE '2024-08-18', 24900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 105, DATE '2025-03-18', 24900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 105, DATE '2026-03-18', 24900, 0,   'PSE',             'EXITOSO');

-- Usuario 106 (referido)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 106, DATE '2024-01-25', 23655, 5,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 106, DATE '2025-01-25', 23655, 5,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 106, DATE '2026-03-25', 23655, 5,   'NEQUI',           'EXITOSO');

-- Usuario 108 (Premium Armenia, >24 meses: 15% descuento)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 108, DATE '2024-01-01', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 108, DATE '2025-01-01', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 108, DATE '2025-07-01', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 108, DATE '2026-03-01', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');

-- Usuario 109 (Premium Armenia, referido)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 109, DATE '2024-12-20', 29665, 15,  'TARJETA_DEBITO',  'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 109, DATE '2026-03-20', 29665, 15,  'TARJETA_DEBITO',  'EXITOSO');

-- Usuario 113 (Básico Pereira)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 113, DATE '2024-03-15', 14155, 5,   'DAVIPLATA',       'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 113, DATE '2025-03-15', 14155, 5,   'DAVIPLATA',       'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 113, DATE '2026-03-15', 14155, 5,   'DAVIPLATA',       'EXITOSO');

-- Usuario 114 (Básico Pereira - INACTIVO)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 114, DATE '2025-08-08', 14900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 114, DATE '2025-10-08', 14900, 0,   'PSE',             'FALLIDO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 114, DATE '2025-11-08',     0, 0,   'PSE',             'FALLIDO');

-- Usuario 115 (Estándar Pereira)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 115, DATE '2024-04-20', 24900, 0,   'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 115, DATE '2025-04-20', 24900, 0,   'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 115, DATE '2026-03-20', 24900, 0,   'TARJETA_CREDITO', 'EXITOSO');

-- Usuario 117 (referido)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 117, DATE '2024-01-05', 23655, 5,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 117, DATE '2025-01-05', 23655, 5,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 117, DATE '2026-03-05', 23655, 5,   'NEQUI',           'EXITOSO');

-- Usuario 119 (Premium Pereira, >24 meses)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 119, DATE '2024-05-11', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 119, DATE '2025-05-11', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 119, DATE '2026-03-11', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');

-- Usuario 120 (referido Premium)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 120, DATE '2024-09-17', 32155, 8,   'TARJETA_DEBITO',  'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 120, DATE '2026-03-17', 32155, 8,   'TARJETA_DEBITO',  'EXITOSO');

-- Usuario 121 (Básico Medellín)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 121, DATE '2025-03-04', 14900, 0,   'DAVIPLATA',       'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 121, DATE '2026-03-04', 14900, 0,   'DAVIPLATA',       'EXITOSO');

-- Usuario 122 (referido - INACTIVO)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 122, DATE '2025-07-19', 14155, 5,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 122, DATE '2025-09-19', 14155, 5,   'NEQUI',           'FALLIDO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 122, DATE '2025-10-19',     0, 5,   'NEQUI',           'FALLIDO');

-- Usuario 124 (Estándar Medellín)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 124, DATE '2024-03-12', 24900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 124, DATE '2025-03-12', 24900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 124, DATE '2026-03-12', 24900, 0,   'PSE',             'EXITOSO');

-- Usuario 125 (referido)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 125, DATE '2024-10-28', 23655, 5,   'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 125, DATE '2026-03-28', 23655, 5,   'TARJETA_CREDITO', 'EXITOSO');

-- Usuario 127 (Premium Medellín, >24 meses)
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 127, DATE '2024-11-15', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 127, DATE '2025-05-15', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 127, DATE '2025-11-15', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 127, DATE '2026-03-15', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');

-- Pagos adicionales para otros usuarios hasta llegar a 80+
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 107, DATE '2025-05-10', 24900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 107, DATE '2026-03-10', 24900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 110, DATE '2024-02-14', 29665, 15,  'TARJETA_DEBITO',  'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 110, DATE '2025-02-14', 29665, 15,  'TARJETA_DEBITO',  'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 110, DATE '2026-03-14', 29665, 15,  'TARJETA_DEBITO',  'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 116, DATE '2024-04-20', 24900, 0,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 116, DATE '2025-04-20', 24900, 0,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 116, DATE '2026-03-20', 24900, 0,   'NEQUI',           'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 118, DATE '2024-01-05', 24900, 0,   'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 118, DATE '2025-01-05', 24900, 0,   'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 118, DATE '2026-03-05', 24900, 0,   'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 126, DATE '2024-02-03', 24900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 126, DATE '2026-03-03', 24900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 128, DATE '2022-01-22', 29665, 15,  'TARJETA_DEBITO',  'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 128, DATE '2025-01-22', 29665, 15,  'TARJETA_DEBITO',  'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 128, DATE '2026-03-22', 29665, 15,  'TARJETA_DEBITO',  'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 129, DATE '2022-07-06', 34900, 0,   'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 129, DATE '2025-07-06', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 129, DATE '2026-03-06', 29665, 15,  'TARJETA_CREDITO', 'EXITOSO');
-- Pago reembolsado
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 103, DATE '2025-01-20', 14900, 0,   'PSE',             'REEMBOLSADO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 103, DATE '2025-02-20', 14900, 0,   'PSE',             'EXITOSO');
INSERT INTO pagos (id_pago, id_usuario, fecha_pago, monto, descuento_aplicado, metodo_pago, estado_pago)
VALUES (SEQ_PAGOS.NEXTVAL, 103, DATE '2026-03-20', 14900, 0,   'PSE',             'EXITOSO');

-- ============================================================
-- 17. REPORTES DE CONTENIDO INAPROPIADO
-- ============================================================
INSERT INTO reportes (id_reporte, id_usuario, id_contenido, id_moderador, descripcion, estado, fecha_reporte, fecha_resolucion)
VALUES (SEQ_REPORTES.NEXTVAL, 100, 135, 8, 'Escenas de violencia excesiva sin clasificación adecuada.', 'ACEPTADO', DATE '2025-05-01', DATE '2025-05-03');

INSERT INTO reportes (id_reporte, id_usuario, id_contenido, id_moderador, descripcion, estado, fecha_reporte, fecha_resolucion)
VALUES (SEQ_REPORTES.NEXTVAL, 106, 126, 9, 'Contenido con lenguaje inapropiado para menores.', 'RECHAZADO', DATE '2025-06-10', DATE '2025-06-12');

INSERT INTO reportes (id_reporte, id_usuario, id_contenido, id_moderador, descripcion, estado, fecha_reporte, fecha_resolucion)
VALUES (SEQ_REPORTES.NEXTVAL, 116, 104, NULL, 'Escena perturbadora sin advertencia previa.', 'PENDIENTE', DATE '2026-04-01', NULL);

COMMIT;
-- =============================================================================
-- FIN DEL SCRIPT DE INSERCIÓN DE DATOS
-- =============================================================================
