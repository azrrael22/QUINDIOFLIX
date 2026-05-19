package uniquindio.bases2.QUINDIOFLIX.dto.request;

import jakarta.validation.constraints.*;
import lombok.Builder;

import java.time.LocalDate;

@Builder
public record RegistrarUsuarioRequest(
    @NotBlank @Size(max = 100)
    String nombre,

    @NotBlank @Size(max = 100)
    String apellido,

    @NotBlank @Email @Size(max = 150)
    String email,

    @NotBlank @Pattern(regexp = "\\d{7,15}")
    String telefono,

    @NotNull @Past
    LocalDate fechaNacimiento,

    @NotBlank @Size(max = 80)
    String ciudad,

    @NotNull @Positive
    Long idPlan,

    Long idReferidoPor,

    @Pattern(regexp = "TARJETA_CREDITO|TARJETA_DEBITO|PSE|NEQUI|DAVIPLATA")
    String metodoPago
) {}
