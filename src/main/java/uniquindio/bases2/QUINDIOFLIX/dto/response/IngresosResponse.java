package uniquindio.bases2.QUINDIOFLIX.dto.response;

import lombok.Builder;

import java.math.BigDecimal;

@Builder
public record IngresosResponse(
    String ciudad,
    String plan,
    Integer mes,
    Integer anio,
    BigDecimal totalIngresos
) {}
