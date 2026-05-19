package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

@Entity
@Table(name = "PLANES")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Plan {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_planes")
    @SequenceGenerator(name = "seq_planes", sequenceName = "SEQ_PLANES", allocationSize = 1)
    @Column(name = "ID_PLAN")
    private Long idPlan;

    @Column(name = "NOMBRE", nullable = false, unique = true, length = 20)
    private String nombre;

    @Column(name = "PRECIO_MENSUAL", nullable = false, precision = 10, scale = 2)
    private BigDecimal precioMensual;

    @Column(name = "CALIDAD", nullable = false, length = 5)
    private String calidad;

    @Column(name = "MAX_PANTALLAS", nullable = false)
    private Integer maxPantallas;

    @Column(name = "MAX_PERFILES", nullable = false)
    private Integer maxPerfiles;
}
