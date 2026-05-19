package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "GENEROS")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Genero {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_generos")
    @SequenceGenerator(name = "seq_generos", sequenceName = "SEQ_GENEROS", allocationSize = 1)
    @Column(name = "ID_GENERO")
    private Long idGenero;

    @Column(name = "NOMBRE", nullable = false, unique = true, length = 30)
    private String nombre;
}
