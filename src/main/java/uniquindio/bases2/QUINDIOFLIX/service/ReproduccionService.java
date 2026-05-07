package uniquindio.bases2.QUINDIOFLIX.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import uniquindio.bases2.QUINDIOFLIX.dto.request.ReproduccionRequest;
import uniquindio.bases2.QUINDIOFLIX.dto.response.ReproduccionResponse;
import uniquindio.bases2.QUINDIOFLIX.entity.*;
import uniquindio.bases2.QUINDIOFLIX.repository.jpa.*;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReproduccionService {

    private final ReproduccionRepository reproduccionRepo;
    private final PerfilRepository perfilRepo;
    private final ContenidoRepository contenidoRepo;

    @Transactional
    public ReproduccionResponse registrar(ReproduccionRequest req) {
        if ((req.idContenido() == null) == (req.idEpisodio() == null)) {
            throw new IllegalArgumentException(
                "Debe indicar exactamente uno de idContenido o idEpisodio, no ambos.");
        }

        Perfil perfil = perfilRepo.findById(req.idPerfil())
            .orElseThrow(() -> new jakarta.persistence.EntityNotFoundException(
                "Perfil no encontrado: " + req.idPerfil()));

        Reproduccion rep = Reproduccion.builder()
            .perfil(perfil)
            .fechaHoraInicio(LocalDateTime.now())
            .dispositivo(req.dispositivo())
            .build();

        if (req.idContenido() != null) {
            rep.setContenido(contenidoRepo.getReferenceById(req.idContenido()));
        }

        // El trigger TRG_REPR_CUENTA_ACTIVA en Oracle valida el estado de la cuenta
        rep = reproduccionRepo.save(rep);
        return toResponse(rep);
    }

    public List<ReproduccionResponse> historialPerfil(Long idPerfil) {
        return reproduccionRepo
            .findByPerfil_IdPerfilOrderByFechaHoraInicioDesc(idPerfil)
            .stream().map(this::toResponse).toList();
    }

    private ReproduccionResponse toResponse(Reproduccion r) {
        String titulo = r.getContenido() != null
            ? r.getContenido().getTitulo()
            : (r.getEpisodio() != null ? r.getEpisodio().getTitulo() : null);

        return ReproduccionResponse.builder()
            .idReproduccion(r.getIdReproduccion())
            .idPerfil(r.getPerfil().getIdPerfil())
            .idContenido(r.getContenido() != null ? r.getContenido().getIdContenido() : null)
            .idEpisodio(r.getEpisodio() != null ? r.getEpisodio().getIdEpisodio() : null)
            .titulo(titulo)
            .fechaHoraInicio(r.getFechaHoraInicio())
            .fechaHoraFin(r.getFechaHoraFin())
            .dispositivo(r.getDispositivo())
            .porcentajeAvance(r.getPorcentajeAvance())
            .build();
    }
}
