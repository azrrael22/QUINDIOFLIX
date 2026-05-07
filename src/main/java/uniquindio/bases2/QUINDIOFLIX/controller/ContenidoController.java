package uniquindio.bases2.QUINDIOFLIX.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import uniquindio.bases2.QUINDIOFLIX.dto.response.ContenidoPopularResponse;
import uniquindio.bases2.QUINDIOFLIX.dto.response.ContenidoResponse;
import uniquindio.bases2.QUINDIOFLIX.service.ContenidoService;

import java.util.List;

@RestController
@RequestMapping("/api/contenido")
@RequiredArgsConstructor
public class ContenidoController {

    private final ContenidoService service;

    @GetMapping
    public List<ContenidoResponse> listar() {
        return service.listarTodos();
    }

    @GetMapping("/{id}")
    public ContenidoResponse buscar(@PathVariable Long id) {
        return service.buscarPorId(id);
    }

    @GetMapping("/categoria/{idCategoria}")
    public List<ContenidoResponse> porCategoria(@PathVariable Long idCategoria) {
        return service.listarPorCategoria(idCategoria);
    }

    @GetMapping("/popular")
    public List<ContenidoPopularResponse> popular(
            @RequestParam(defaultValue = "10") int limite) {
        return service.listarPopular(limite);
    }
}
