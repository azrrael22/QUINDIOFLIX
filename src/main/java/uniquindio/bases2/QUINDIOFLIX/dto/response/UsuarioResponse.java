package uniquindio.bases2.QUINDIOFLIX.dto.response;

import lombok.Builder;

import java.time.LocalDate;

@Builder
public record UsuarioResponse(
    Long idUsuario,
    String nombre,
    String apellido,
    String email,
    String ciudad,
    String plan,
    String estadoCuenta,
    LocalDate fechaRegistro,
    LocalDate fechaUltimoPago
) {}
