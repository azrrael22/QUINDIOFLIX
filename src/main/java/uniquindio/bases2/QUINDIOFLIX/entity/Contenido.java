package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "CONTENIDO")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Contenido {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_contenido")
    @SequenceGenerator(name = "seq_contenido", sequenceName = "SEQ_CONTENIDO", allocationSize = 1)
    @Column(name = "ID_CONTENIDO")
    private Long idContenido;

    @Column(name = "TITULO", nullable = false, length = 200)
    private String titulo;

    @Column(name = "ANIO_LANZAMIENTO", nullable = false)
    private Integer anioLanzamiento;

    @Column(name = "DURACION", nullable = false)
    private Integer duracion;

    @Lob
    @Column(name = "SINOPSIS")
    private String sinopsis;

    @Column(name = "CLASIFICACION_EDAD", nullable = false, length = 5)
    private String clasificacionEdad;

    @Column(name = "FECHA_AGREGADO", nullable = false)
    private LocalDate fechaAgregado;

    @Column(name = "ES_ORIGINAL", nullable = false, columnDefinition = "CHAR(1)")
    @Builder.Default
    private String esOriginal = "N";

    @Column(name = "POPULARIDAD", nullable = false)
    @Builder.Default
    private Long popularidad = 0L;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_CATEGORIA", nullable = false)
    private Categoria categoria;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_EMPLEADO_RESP", nullable = false)
    private Empleado empleadoResponsable;

    // Relación N:M con géneros via tabla CONTENIDO_GENERO
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "CONTENIDO_GENERO",
        joinColumns        = @JoinColumn(name = "ID_CONTENIDO"),
        inverseJoinColumns = @JoinColumn(name = "ID_GENERO")
    )
    @Builder.Default
    private Set<Genero> generos = new HashSet<>();
}
