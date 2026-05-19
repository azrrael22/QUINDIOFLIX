package uniquindio.bases2.QUINDIOFLIX.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import uniquindio.bases2.QUINDIOFLIX.entity.Reproduccion;

import java.time.LocalDateTime;
import java.util.List;

public interface ReproduccionRepository extends JpaRepository<Reproduccion, Long> {

    List<Reproduccion> findByPerfil_IdPerfilOrderByFechaHoraInicioDesc(Long idPerfil);

    List<Reproduccion> findByPerfil_IdPerfilAndFechaHoraInicioBetween(
        Long idPerfil, LocalDateTime desde, LocalDateTime hasta);

    // Máximo avance del perfil sobre un contenido (para validar calificación)
    @Query("""
        SELECT MAX(r.porcentajeAvance) FROM Reproduccion r
        WHERE r.perfil.idPerfil = :idPerfil
          AND r.contenido.idContenido = :idContenido
        """)
    Double findMaxAvanceByPerfilAndContenido(
        @Param("idPerfil") Long idPerfil,
        @Param("idContenido") Long idContenido);
}
