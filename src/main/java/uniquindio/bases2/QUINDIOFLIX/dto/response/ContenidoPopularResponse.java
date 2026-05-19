package uniquindio.bases2.QUINDIOFLIX.dto.response;

import lombok.Builder;

@Builder
public record ContenidoPopularResponse(
    Long idContenido,
    String titulo,
    Long totalReproducciones,
    Double calificacionPromedio
) {}
