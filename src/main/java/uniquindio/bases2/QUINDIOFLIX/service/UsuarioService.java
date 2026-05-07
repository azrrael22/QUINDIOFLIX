package uniquindio.bases2.QUINDIOFLIX.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import uniquindio.bases2.QUINDIOFLIX.dto.request.CambiarPlanRequest;
import uniquindio.bases2.QUINDIOFLIX.dto.request.RegistrarUsuarioRequest;
import uniquindio.bases2.QUINDIOFLIX.dto.response.UsuarioResponse;
import uniquindio.bases2.QUINDIOFLIX.entity.Usuario;
import uniquindio.bases2.QUINDIOFLIX.repository.jdbc.ProcedimientosJdbcRepository;
import uniquindio.bases2.QUINDIOFLIX.repository.jpa.UsuarioRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository usuarioRepo;
    private final ProcedimientosJdbcRepository procedimientosRepo;

    // El registro pasa por SP_REGISTRAR_USUARIO en Oracle para aplicar todas las
    // validaciones y reglas de negocio (triggers, excepciones personalizadas).
    @Transactional
    public void registrar(RegistrarUsuarioRequest req) {
        procedimientosRepo.registrarUsuario(
            req.nombre(), req.apellido(), req.email(),
            req.telefono(), req.fechaNacimiento(), req.ciudad(),
            req.idPlan(), req.idReferidoPor(),
            req.metodoPago()
        );
    }

    @Transactional
    public void cambiarPlan(CambiarPlanRequest req) {
        procedimientosRepo.cambiarPlan(req.idUsuario(), req.idNuevoPlan());
    }

    public List<UsuarioResponse> listarTodos() {
        return usuarioRepo.findAll().stream().map(this::toResponse).toList();
    }

    public UsuarioResponse buscarPorEmail(String email) {
        return usuarioRepo.findByEmail(email)
            .map(this::toResponse)
            .orElseThrow(() -> new jakarta.persistence.EntityNotFoundException(
                "Usuario no encontrado con email: " + email));
    }

    public List<UsuarioResponse> listarMorosos() {
        return usuarioRepo.findMorosos().stream().map(this::toResponse).toList();
    }

    private UsuarioResponse toResponse(Usuario u) {
        return UsuarioResponse.builder()
            .idUsuario(u.getIdUsuario())
            .nombre(u.getNombre())
            .apellido(u.getApellido())
            .email(u.getEmail())
            .ciudad(u.getCiudad())
            .plan(u.getPlan().getNombre())
            .estadoCuenta(u.getEstadoCuenta())
            .fechaRegistro(u.getFechaRegistro())
            .fechaUltimoPago(u.getFechaUltimoPago())
            .build();
    }
}
