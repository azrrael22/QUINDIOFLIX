package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "REPRODUCCIONES")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Reproduccion {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_reproducciones")
    @SequenceGenerator(name = "seq_reproducciones", sequenceName = "SEQ_REPRODUCCIONES", allocationSize = 1)
    @Column(name = "ID_REPRODUCCION")
    private Long idReproduccion;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_PERFIL", nullable = false)
    private Perfil perfil;

    // XOR: id_contenido XOR id_episodio — validado por trigger en Oracle
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CONTENIDO")
    private Contenido contenido;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_EPISODIO")
    private Episodio episodio;

    @Column(name = "FECHA_HORA_INICIO", nullable = false)
    private LocalDateTime fechaHoraInicio;

    @Column(name = "FECHA_HORA_FIN")
    private LocalDateTime fechaHoraFin;

    @Column(name = "DISPOSITIVO", nullable = false, length = 15)
    private String dispositivo;

    @Column(name = "PORCENTAJE_AVANCE", nullable = false, precision = 5, scale = 2)
    @Builder.Default
    private BigDecimal porcentajeAvance = BigDecimal.ZERO;
}
