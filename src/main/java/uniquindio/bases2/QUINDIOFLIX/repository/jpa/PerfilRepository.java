package uniquindio.bases2.QUINDIOFLIX.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import uniquindio.bases2.QUINDIOFLIX.entity.Perfil;

import java.util.List;

public interface PerfilRepository extends JpaRepository<Perfil, Long> {

    List<Perfil> findByUsuario_IdUsuario(Long idUsuario);

    long countByUsuario_IdUsuario(Long idUsuario);
}
