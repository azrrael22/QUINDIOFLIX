package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "CALIFICACIONES")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Calificacion {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_calificaciones")
    @SequenceGenerator(name = "seq_calificaciones", sequenceName = "SEQ_CALIFICACIONES", allocationSize = 1)
    @Column(name = "ID_CALIFICACION")
    private Long idCalificacion;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_PERFIL", nullable = false)
    private Perfil perfil;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_CONTENIDO", nullable = false)
    private Contenido contenido;

    @Column(name = "ESTRELLAS", nullable = false)
    private Integer estrellas;

    @Column(name = "RESENIA", length = 1000)
    private String resenia;

    @Column(name = "FECHA_CALIFICACION", nullable = false)
    private LocalDate fechaCalificacion;
}
