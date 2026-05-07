package uniquindio.bases2.QUINDIOFLIX.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import uniquindio.bases2.QUINDIOFLIX.dto.request.PagoRequest;
import uniquindio.bases2.QUINDIOFLIX.dto.response.PagoResponse;
import uniquindio.bases2.QUINDIOFLIX.service.PagoService;

import java.util.List;

@RestController
@RequestMapping("/api/pagos")
@RequiredArgsConstructor
public class PagoController {

    private final PagoService service;

    @PostMapping
    public ResponseEntity<PagoResponse> registrar(@Valid @RequestBody PagoRequest req) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.registrar(req));
    }

    @GetMapping("/usuario/{idUsuario}")
    public List<PagoResponse> historial(@PathVariable Long idUsuario) {
        return service.historialUsuario(idUsuario);
    }
}
