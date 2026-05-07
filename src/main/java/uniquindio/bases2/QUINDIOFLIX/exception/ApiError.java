package uniquindio.bases2.QUINDIOFLIX.exception;

import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record ApiError(
    String error,
    int codigo,
    String detalle,
    LocalDateTime timestamp
) {}
