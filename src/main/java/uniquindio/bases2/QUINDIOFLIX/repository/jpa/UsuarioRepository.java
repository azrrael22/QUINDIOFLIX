package uniquindio.bases2.QUINDIOFLIX.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import uniquindio.bases2.QUINDIOFLIX.entity.Usuario;

import java.util.List;
import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    Optional<Usuario> findByEmail(String email);

    boolean existsByEmail(String email);

    List<Usuario> findByEstadoCuenta(String estadoCuenta);

    List<Usuario> findByPlan_IdPlan(Long idPlan);

    List<Usuario> findByCiudad(String ciudad);

    // Usuarios con suscripción vencida (más de 30 días sin pago)
    @Query("""
        SELECT u FROM Usuario u
        WHERE u.estadoCuenta = 'ACTIVO'
          AND (u.fechaUltimoPago IS NULL OR u.fechaUltimoPago < current_date - 30 day)
        ORDER BY u.fechaUltimoPago ASC NULLS FIRST
        """)
    List<Usuario> findMorosos();
}
