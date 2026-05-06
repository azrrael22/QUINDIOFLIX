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
ENTREGA_1/                   # Entregable 1: schema, datos y consultas SQL
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
| `ENTREGA_1/` | Schema DDL, datos de prueba y consultas del Núcleo 1 |

### Núcleo 1 — Consultas avanzadas y almacenamiento

- Consultas parametrizadas (top reproducciones por ciudad, ingresos por plan, calificación promedio por género)
- Tablas de referencias cruzadas con `PIVOT` y `UNPIVOT`
- Funciones avanzadas de `GROUP BY`: `ROLLUP`, `CUBE`, `GROUPING SETS`
- Vistas materializadas (`mv_contenido_popular`, `mv_ingresos_mensuales`)
- Particionamiento por rango de fechas sobre la tabla `REPRODUCCIONES`

---

## Equipo

Proyecto desarrollado para **Bases de Datos II** — Universidad del Quindío, 2026-1.
