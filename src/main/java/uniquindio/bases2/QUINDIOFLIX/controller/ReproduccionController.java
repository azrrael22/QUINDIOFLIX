package uniquindio.bases2.QUINDIOFLIX.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import uniquindio.bases2.QUINDIOFLIX.dto.request.ReproduccionRequest;
import uniquindio.bases2.QUINDIOFLIX.dto.response.ReproduccionResponse;
import uniquindio.bases2.QUINDIOFLIX.service.ReproduccionService;

import java.util.List;

@RestController
@RequestMapping("/api/reproducciones")
@RequiredArgsConstructor
public class ReproduccionController {

    private final ReproduccionService service;

    @PostMapping
    public ResponseEntity<ReproduccionResponse> registrar(
            @Valid @RequestBody ReproduccionRequest req) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.registrar(req));
    }

    @GetMapping("/perfil/{idPerfil}")
    public List<ReproduccionResponse> historial(@PathVariable Long idPerfil) {
        return service.historialPerfil(idPerfil);
    }
}
