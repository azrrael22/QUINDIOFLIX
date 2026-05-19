package uniquindio.bases2.QUINDIOFLIX.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Positive;
import lombok.Builder;

@Builder
public record PagoRequest(
    @NotNull @Positive Long idUsuario,
    @NotNull @Pattern(regexp = "TARJETA_CREDITO|TARJETA_DEBITO|PSE|NEQUI|DAVIPLATA")
    String metodoPago
) {}
