package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "USUARIOS")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_usuarios")
    @SequenceGenerator(name = "seq_usuarios", sequenceName = "SEQ_USUARIOS", allocationSize = 1)
    @Column(name = "ID_USUARIO")
    private Long idUsuario;

    @Column(name = "NOMBRE", nullable = false, length = 100)
    private String nombre;

    @Column(name = "APELLIDO", nullable = false, length = 100)
    private String apellido;

    @Column(name = "EMAIL", nullable = false, unique = true, length = 150)
    private String email;

    @Column(name = "TELEFONO", nullable = false, length = 15)
    private String telefono;

    @Column(name = "FECHA_NACIMIENTO", nullable = false)
    private LocalDate fechaNacimiento;

    @Column(name = "CIUDAD", nullable = false, length = 80)
    private String ciudad;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_PLAN", nullable = false)
    private Plan plan;

    @Column(name = "FECHA_REGISTRO", nullable = false)
    private LocalDate fechaRegistro;

    @Column(name = "ESTADO_CUENTA", nullable = false, length = 10)
    @Builder.Default
    private String estadoCuenta = "ACTIVO";

    @Column(name = "FECHA_ULTIMO_PAGO")
    private LocalDate fechaUltimoPago;

    // Autorelación: usuario que refirió a este suscriptor
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_REFERIDO_POR")
    private Usuario referidoPor;
}
