package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "EPISODIOS")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Episodio {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_episodios")
    @SequenceGenerator(name = "seq_episodios", sequenceName = "SEQ_EPISODIOS", allocationSize = 1)
    @Column(name = "ID_EPISODIO")
    private Long idEpisodio;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_TEMPORADA", nullable = false)
    private Temporada temporada;

    @Column(name = "NUMERO_EPISODIO", nullable = false)
    private Integer numeroEpisodio;

    @Column(name = "TITULO", nullable = false, length = 200)
    private String titulo;

    @Column(name = "DURACION", nullable = false)
    private Integer duracion;
}
