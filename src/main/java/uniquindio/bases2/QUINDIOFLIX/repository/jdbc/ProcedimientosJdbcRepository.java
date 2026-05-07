package uniquindio.bases2.QUINDIOFLIX.repository.jdbc;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.CallableStatement;
import java.sql.Date;
import java.time.LocalDate;

@Repository
@RequiredArgsConstructor
public class ProcedimientosJdbcRepository {

    private final JdbcTemplate jdbc;

    public void registrarUsuario(String nombre, String apellido, String email,
                                  String telefono, LocalDate fechaNac, String ciudad,
                                  Long idPlan, Long idReferidoPor, String metodoPago) {
        jdbc.execute((java.sql.Connection con) -> {
            String call = "{ CALL sp_registrar_usuario(?,?,?,?,?,?,?,?,?) }";
            try (CallableStatement cs = con.prepareCall(call)) {
                cs.setString(1, nombre);
                cs.setString(2, apellido);
                cs.setString(3, email);
                cs.setString(4, telefono);
                cs.setDate(5, Date.valueOf(fechaNac));
                cs.setString(6, ciudad);
                cs.setLong(7, idPlan);
                if (idReferidoPor != null) cs.setLong(8, idReferidoPor);
                else cs.setNull(8, java.sql.Types.NUMERIC);
                cs.setString(9, metodoPago != null ? metodoPago : "PSE");
                cs.execute();
            }
            return null;
        });
    }

    public void cambiarPlan(Long idUsuario, Long idNuevoPlan) {
        jdbc.execute((java.sql.Connection con) -> {
            try (CallableStatement cs = con.prepareCall("{ CALL sp_cambiar_plan(?,?) }")) {
                cs.setLong(1, idUsuario);
                cs.setLong(2, idNuevoPlan);
                cs.execute();
            }
            return null;
        });
    }
}
