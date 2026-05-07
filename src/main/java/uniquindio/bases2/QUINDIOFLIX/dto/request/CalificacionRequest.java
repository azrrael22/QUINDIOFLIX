package uniquindio.bases2.QUINDIOFLIX.dto.request;

import jakarta.validation.constraints.*;
import lombok.Builder;

@Builder
public record CalificacionRequest(
    @NotNull @Positive Long idPerfil,
    @NotNull @Positive Long idContenido,
    @NotNull @Min(1) @Max(5) Integer estrellas,
    @Size(max = 1000) String resenia
) {}
