package uniquindio.bases2.QUINDIOFLIX.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import uniquindio.bases2.QUINDIOFLIX.dto.request.PagoRequest;
import uniquindio.bases2.QUINDIOFLIX.dto.response.PagoResponse;
import uniquindio.bases2.QUINDIOFLIX.entity.Pago;
import uniquindio.bases2.QUINDIOFLIX.entity.Usuario;
import uniquindio.bases2.QUINDIOFLIX.repository.jpa.PagoRepository;
import uniquindio.bases2.QUINDIOFLIX.repository.jpa.UsuarioRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PagoService {

    private final PagoRepository pagoRepo;
    private final UsuarioRepository usuarioRepo;

    @Transactional
    public PagoResponse registrar(PagoRequest req) {
        Usuario usuario = usuarioRepo.findById(req.idUsuario())
            .orElseThrow(() -> new jakarta.persistence.EntityNotFoundException(
                "Usuario no encontrado: " + req.idUsuario()));

        Pago pago = Pago.builder()
            .usuario(usuario)
            .fechaPago(LocalDate.now())
            .monto(usuario.getPlan().getPrecioMensual())
            .descuentoAplicado(BigDecimal.ZERO)
            .metodoPago(req.metodoPago())
            .estadoPago("EXITOSO")
            .build();

        // El trigger TRG_PAGO_ACTUALIZAR_ESTADO en Oracle actualiza el estado de la cuenta
        pago = pagoRepo.save(pago);
        return toResponse(pago);
    }

    public List<PagoResponse> historialUsuario(Long idUsuario) {
        return pagoRepo.findByUsuario_IdUsuarioOrderByFechaPagoDesc(idUsuario)
            .stream().map(this::toResponse).toList();
    }

    private PagoResponse toResponse(Pago p) {
        return PagoResponse.builder()
            .idPago(p.getIdPago())
            .idUsuario(p.getUsuario().getIdUsuario())
            .fechaPago(p.getFechaPago())
            .monto(p.getMonto())
            .descuentoAplicado(p.getDescuentoAplicado())
            .metodoPago(p.getMetodoPago())
            .estadoPago(p.getEstadoPago())
            .build();
    }
}
