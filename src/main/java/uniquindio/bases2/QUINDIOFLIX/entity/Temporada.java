package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "TEMPORADAS")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Temporada {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_temporadas")
    @SequenceGenerator(name = "seq_temporadas", sequenceName = "SEQ_TEMPORADAS", allocationSize = 1)
    @Column(name = "ID_TEMPORADA")
    private Long idTemporada;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_CONTENIDO", nullable = false)
    private Contenido contenido;

    @Column(name = "NUMERO_TEMPORADA", nullable = false)
    private Integer numeroTemporada;

    @Column(name = "TITULO", length = 100)
    private String titulo;
}
