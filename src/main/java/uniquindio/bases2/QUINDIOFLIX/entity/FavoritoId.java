package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serializable;

@Embeddable
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @EqualsAndHashCode
public class FavoritoId implements Serializable {

    @Column(name = "ID_PERFIL")
    private Long idPerfil;

    @Column(name = "ID_CONTENIDO")
    private Long idContenido;
}
