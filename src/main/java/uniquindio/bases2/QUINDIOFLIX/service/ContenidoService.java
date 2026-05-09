package uniquindio.bases2.QUINDIOFLIX.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import uniquindio.bases2.QUINDIOFLIX.dto.response.ContenidoPopularResponse;
import uniquindio.bases2.QUINDIOFLIX.dto.response.ContenidoResponse;
import uniquindio.bases2.QUINDIOFLIX.entity.Contenido;
import uniquindio.bases2.QUINDIOFLIX.entity.Genero;
import uniquindio.bases2.QUINDIOFLIX.repository.jdbc.ContenidoPopularJdbcRepository;
import uniquindio.bases2.QUINDIOFLIX.repository.jpa.ContenidoRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ContenidoService {

    private final ContenidoRepository contenidoRepo;
    private final ContenidoPopularJdbcRepository popularRepo;

    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public List<ContenidoResponse> listarTodos() {
        return contenidoRepo.findAll().stream().map(this::toResponse).toList();
    }

    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public ContenidoResponse buscarPorId(Long id) {
        return contenidoRepo.findById(id)
            .map(this::toResponse)
            .orElseThrow(() -> new jakarta.persistence.EntityNotFoundException(
                "Contenido no encontrado: " + id));
    }

    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public List<ContenidoResponse> listarPorCategoria(Long idCategoria) {
        return contenidoRepo.findByCategoria_IdCategoria(idCategoria)
            .stream().map(this::toResponse).toList();
    }

    // Usa la vista materializada mv_contenido_popular
    public List<ContenidoPopularResponse> listarPopular(int limite) {
        return popularRepo.findTopContenido(limite);
    }

    private ContenidoResponse toResponse(Contenido c) {
        return ContenidoResponse.builder()
            .idContenido(c.getIdContenido())
            .titulo(c.getTitulo())
            .anioLanzamiento(c.getAnioLanzamiento())
            .duracion(c.getDuracion())
            .clasificacionEdad(c.getClasificacionEdad())
            .categoria(c.getCategoria().getNombre())
            .esOriginal("S".equals(c.getEsOriginal()))
            .fechaAgregado(c.getFechaAgregado())
            .popularidad(c.getPopularidad())
            .generos(c.getGeneros().stream().map(Genero::getNombre).collect(Collectors.toSet()))
            .build();
    }
}
