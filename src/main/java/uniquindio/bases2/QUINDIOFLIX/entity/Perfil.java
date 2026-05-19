package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "PERFILES")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Perfil {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_perfiles")
    @SequenceGenerator(name = "seq_perfiles", sequenceName = "SEQ_PERFILES", allocationSize = 1)
    @Column(name = "ID_PERFIL")
    private Long idPerfil;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_USUARIO", nullable = false)
    private Usuario usuario;

    @Column(name = "NOMBRE", nullable = false, length = 50)
    private String nombre;

    @Column(name = "AVATAR", length = 255)
    private String avatar;

    @Column(name = "TIPO", nullable = false, length = 10)
    private String tipo;
}
