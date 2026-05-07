package uniquindio.bases2.QUINDIOFLIX.dto.response;

import lombok.Builder;

import java.time.LocalDate;
import java.util.Set;

@Builder
public record ContenidoResponse(
    Long idContenido,
    String titulo,
    Integer anioLanzamiento,
    Integer duracion,
    String clasificacionEdad,
    String categoria,
    boolean esOriginal,
    LocalDate fechaAgregado,
    Long popularidad,
    Set<String> generos
) {}
