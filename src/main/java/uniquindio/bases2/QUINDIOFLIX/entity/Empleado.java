package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "EMPLEADOS")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Empleado {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_empleados")
    @SequenceGenerator(name = "seq_empleados", sequenceName = "SEQ_EMPLEADOS", allocationSize = 1)
    @Column(name = "ID_EMPLEADO")
    private Long idEmpleado;

    @Column(name = "NOMBRE", nullable = false, length = 100)
    private String nombre;

    @Column(name = "EMAIL", nullable = false, unique = true, length = 100)
    private String email;

    @Column(name = "CARGO", nullable = false, length = 50)
    private String cargo;

    @Column(name = "FECHA_CONTRATACION", nullable = false)
    private LocalDate fechaContratacion;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID_DEPARTAMENTO", nullable = false)
    private Departamento departamento;

    // Autorelación: supervisor del mismo departamento
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_SUPERVISOR")
    private Empleado supervisor;
}
