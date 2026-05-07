package uniquindio.bases2.QUINDIOFLIX.dto.response;

import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Builder
public record ReproduccionResponse(
    Long idReproduccion,
    Long idPerfil,
    Long idContenido,
    Long idEpisodio,
    String titulo,
    LocalDateTime fechaHoraInicio,
    LocalDateTime fechaHoraFin,
    String dispositivo,
    BigDecimal porcentajeAvance
) {}
