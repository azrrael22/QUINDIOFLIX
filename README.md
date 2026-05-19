# QuindioFlix

Plataforma de streaming desarrollada como proyecto final para la asignatura **Bases de Datos II** de la Universidad del Quindío — Semestre 2026-1.

El sistema gestiona suscripciones, catálogo de contenido multimedia, reproducciones, calificaciones, pagos y reportes de contenido inapropiado, con una base de datos Oracle como motor principal.

---

## Tecnologías

| Capa | Tecnología |
|---|---|
| Lenguaje | Java 21 |
| Framework | Spring Boot 4.0.6 |
| Persistencia | Spring Data JPA + JDBC |
| Base de datos | Oracle Database (ojdbc11) |
| Build | Gradle |
| Utilidades | Lombok, Spring DevTools |

---

## Estructura del proyecto

```
src/
└── main/
    ├── java/uniquindio/bases2/QUINDIOFLIX/
    │   ├── config/          # Configuración de beans y datasource
    │   ├── controller/      # Controladores REST
    │   ├── dto/
    │   │   ├── request/     # DTOs de entrada
    │   │   └── response/    # DTOs de salida
    │   ├── entity/          # Entidades JPA
    │   ├── exception/       # Manejo de excepciones
    │   ├── repository/
    │   │   ├── jdbc/        # Repositorios con JDBC puro
    │   │   └── jpa/         # Repositorios Spring Data JPA
    │   └── service/         # Lógica de negocio
    └── resources/
        ├── application.properties
E1/                          # Entregable 1: Schema, datos y consultas del Núcleo 1
E2/                          # Entregable 2: PL/SQL, procedimientos, funciones y disparadores (Núcleo 2)
```

---

## Modelo de datos

El esquema incluye las siguientes entidades principales:

- **Planes** — Básico, Estándar y Premium con límites de pantallas y perfiles
- **Usuarios y Perfiles** — Cuentas con múltiples perfiles (ADULTO / INFANTIL)
- **Contenido** — Películas, Series, Documentales, Música y Podcasts
- **Temporadas y Episodios** — Estructura jerárquica para series y podcasts
- **Reproducciones** — Historial por perfil, particionado por año en Oracle
- **Calificaciones** — Una por perfil por contenido, habilitada al superar el 50 % de avance
- **Favoritos** — Lista personal por perfil
- **Pagos** — Historial de suscripciones con soporte para PSE, Nequi, Daviplata y tarjetas
- **Reportes** — Moderación de contenido inapropiado
- **Empleados y Departamentos** — Estructura interna con jerarquía de supervisión

---

## Requisitos previos

- Java 21
- Oracle Database (con usuario y esquema configurados)
- Gradle 8+

---

## Configuración

Edita `src/main/resources/application.properties` con los datos de tu instancia Oracle:

```properties
spring.application.name=QUINDIOFLIX

spring.datasource.url=jdbc:oracle:thin:@localhost:1521:XE
spring.datasource.username=<usuario>
spring.datasource.password=<contraseña>
spring.datasource.driver-class-name=oracle.jdbc.OracleDriver

spring.jpa.hibernate.ddl-auto=validate
```

---

## Ejecución

```bash
# Compilar y ejecutar
./gradlew bootRun

# Solo compilar
./gradlew build

# Ejecutar tests
./gradlew test
```

---

## Entregables

| Carpeta | Contenido |
|---|---|
| `E1/` | Schema DDL, datos de prueba y consultas del Núcleo 1 |
| `E2/` | PL/SQL: Procedimientos almacenados, funciones, cursores y disparadores del Núcleo 2 |

### Núcleo 1 — Consultas avanzadas y almacenamiento

- Consultas parametrizadas (top reproducciones por ciudad, ingresos por plan, calificación promedio por género)
- Tablas de referencias cruzadas con `PIVOT` y `UNPIVOT`
- Funciones avanzadas de `GROUP BY`: `ROLLUP`, `CUBE`, `GROUPING SETS`
- Vistas materializadas (`mv_contenido_popular`, `mv_ingresos_mensuales`)
- Particionamiento por rango de fechas sobre la tabla `REPRODUCCIONES`

### Núcleo 2 — Lógica de negocio (PL/SQL)

- **Excepciones personalizadas:** Manejo de errores controlados (e.g., email duplicado, plan inválido).
- **Cursores:** Reportes de usuarios morosos y actualización de popularidad de contenidos.
- **Funciones:** Cálculo de montos de facturación con descuentos por antigüedad y recomendación de contenido basado en historial.
- **Procedimientos Almacenados:** Registro de nuevos usuarios, cambio de planes de suscripción y reportes de consumo.
- **Disparadores (Triggers):** Validación de cuenta activa al reproducir, control de perfiles según el plan, validación de avance para calificar contenido y actualización de estados tras pagos.

---

## Equipo

Proyecto desarrollado para **Bases de Datos II** — Universidad del Quindío, 2026-1.
