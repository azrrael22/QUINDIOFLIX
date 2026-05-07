package uniquindio.bases2.QUINDIOFLIX.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Builder;

@Builder
public record CambiarPlanRequest(
    @NotNull @Positive Long idUsuario,
    @NotNull @Positive Long idNuevoPlan
) {}
