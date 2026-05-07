package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "PAGOS")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Pago {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_pagos")
    @SequenceGenerator(name = "seq_pagos", sequenceName = "SEQ_PAGOS", allocationSize = 1)
    @Column(name = "ID_PAGO")
    private Long idPago;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_USUARIO", nullable = false)
    private Usuario usuario;

    @Column(name = "FECHA_PAGO", nullable = false)
    private LocalDate fechaPago;

    @Column(name = "MONTO", nullable = false, precision = 10, scale = 2)
    private BigDecimal monto;

    @Column(name = "DESCUENTO_APLICADO", nullable = false, precision = 5, scale = 2)
    @Builder.Default
    private BigDecimal descuentoAplicado = BigDecimal.ZERO;

    @Column(name = "METODO_PAGO", nullable = false, length = 20)
    private String metodoPago;

    @Column(name = "ESTADO_PAGO", nullable = false, length = 15)
    private String estadoPago;
}
