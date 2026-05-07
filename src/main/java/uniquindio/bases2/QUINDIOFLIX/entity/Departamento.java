package uniquindio.bases2.QUINDIOFLIX.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "DEPARTAMENTOS")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Departamento {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_departamentos")
    @SequenceGenerator(name = "seq_departamentos", sequenceName = "SEQ_DEPARTAMENTOS", allocationSize = 1)
    @Column(name = "ID_DEPARTAMENTO")
    private Long idDepartamento;

    @Column(name = "NOMBRE", nullable = false, unique = true, length = 50)
    private String nombre;

    // FK circular con EMPLEADOS — se carga lazy para evitar recursión
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_JEFE")
    private Empleado jefe;
}
