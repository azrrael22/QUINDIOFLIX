package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "FAVORITOS")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Favorito {

    @EmbeddedId
    private FavoritoId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idPerfil")
    @JoinColumn(name = "ID_PERFIL")
    private Perfil perfil;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idContenido")
    @JoinColumn(name = "ID_CONTENIDO")
    private Contenido contenido;
}
