package uniquindio.bases2.QUINDIOFLIX.dto.response;

import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDate;

@Builder
public record PagoResponse(
    Long idPago,
    Long idUsuario,
    LocalDate fechaPago,
    BigDecimal monto,
    BigDecimal descuentoAplicado,
    String metodoPago,
    String estadoPago
) {}
