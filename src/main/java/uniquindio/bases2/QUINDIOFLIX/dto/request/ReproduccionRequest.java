package uniquindio.bases2.QUINDIOFLIX.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Positive;
import lombok.Builder;

@Builder
public record ReproduccionRequest(
    @NotNull @Positive Long idPerfil,
    Long idContenido,   // XOR con idEpisodio — validado en el servicio
    Long idEpisodio,
    @NotBlank @Pattern(regexp = "CELULAR|TABLET|TV|COMPUTADOR")
    String dispositivo
) {}
