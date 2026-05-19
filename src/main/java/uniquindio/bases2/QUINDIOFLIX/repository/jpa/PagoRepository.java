package uniquindio.bases2.QUINDIOFLIX.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import uniquindio.bases2.QUINDIOFLIX.entity.Pago;

import java.util.List;

public interface PagoRepository extends JpaRepository<Pago, Long> {

    List<Pago> findByUsuario_IdUsuarioOrderByFechaPagoDesc(Long idUsuario);

    List<Pago> findByUsuario_IdUsuarioAndEstadoPago(Long idUsuario, String estadoPago);
}
