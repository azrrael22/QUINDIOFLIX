package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "REPORTES")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Reporte {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_reportes")
    @SequenceGenerator(name = "seq_reportes", sequenceName = "SEQ_REPORTES", allocationSize = 1)
    @Column(name = "ID_REPORTE")
    private Long idReporte;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_USUARIO", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_CONTENIDO", nullable = false)
    private Contenido contenido;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_MODERADOR")
    private Empleado moderador;

    @Column(name = "DESCRIPCION", nullable = false, length = 1000)
    private String descripcion;

    @Column(name = "ESTADO", nullable = false, length = 15)
    @Builder.Default
    private String estado = "PENDIENTE";

    @Column(name = "FECHA_REPORTE", nullable = false)
    private LocalDate fechaReporte;

    @Column(name = "FECHA_RESOLUCION")
    private LocalDate fechaResolucion;
}
