package uniquindio.bases2.QUINDIOFLIX.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import uniquindio.bases2.QUINDIOFLIX.dto.request.CambiarPlanRequest;
import uniquindio.bases2.QUINDIOFLIX.dto.request.RegistrarUsuarioRequest;
import uniquindio.bases2.QUINDIOFLIX.dto.response.UsuarioResponse;
import uniquindio.bases2.QUINDIOFLIX.service.UsuarioService;

import java.util.List;

@RestController
@RequestMapping("/api/usuarios")
@RequiredArgsConstructor
public class UsuarioController {

    private final UsuarioService service;

    @GetMapping
    public List<UsuarioResponse> listar() {
        return service.listarTodos();
    }

    @GetMapping("/morosos")
    public List<UsuarioResponse> morosos() {
        return service.listarMorosos();
    }

    @GetMapping("/buscar")
    public UsuarioResponse buscarPorEmail(@RequestParam String email) {
        return service.buscarPorEmail(email);
    }

    @PostMapping
    public ResponseEntity<Void> registrar(@Valid @RequestBody RegistrarUsuarioRequest req) {
        service.registrar(req);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PostMapping("/cambiar-plan")
    public ResponseEntity<Void> cambiarPlan(@Valid @RequestBody CambiarPlanRequest req) {
        service.cambiarPlan(req);
        return ResponseEntity.ok().build();
    }
}
