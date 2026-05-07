package uniquindio.bases2.QUINDIOFLIX.exception;

import jakarta.persistence.EntityNotFoundException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.sql.SQLException;
import java.time.LocalDateTime;

@RestControllerAdvice
public class GlobalExceptionHandler {

    // Entidad no encontrada
    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ApiError> handleNotFound(EntityNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(buildError(ex.getMessage(), 404, "NOT_FOUND"));
    }

    // Violación de constraint Oracle (FK, UNIQUE, CHECK)
    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiError> handleIntegrity(DataIntegrityViolationException ex) {
        String msg = ex.getMostSpecificCause().getMessage();
        return ResponseEntity.status(HttpStatus.CONFLICT)
            .body(buildError("Violación de integridad de datos", 409, msg));
    }

    // Errores de procedimientos almacenados Oracle (-20001, -20002, -20003)
    @ExceptionHandler(BadSqlGrammarException.class)
    public ResponseEntity<ApiError> handleBadSql(BadSqlGrammarException ex) {
        Throwable cause = ex.getCause();
        if (cause instanceof SQLException sqlEx) {
            int oraCode = sqlEx.getErrorCode();
            HttpStatus status = switch (oraCode) {
                case 20001 -> HttpStatus.CONFLICT;       // email duplicado
                case 20002 -> HttpStatus.BAD_REQUEST;    // plan inválido
                case 20003 -> HttpStatus.valueOf(422); // perfiles excedidos
                case 20011 -> HttpStatus.FORBIDDEN;      // cuenta inactiva
                case 20012 -> HttpStatus.PRECONDITION_FAILED;  // avance insuficiente
                default    -> HttpStatus.INTERNAL_SERVER_ERROR;
            };
            return ResponseEntity.status(status)
                .body(buildError(sqlEx.getMessage(), oraCode, "ORA-" + oraCode));
        }
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(buildError(ex.getMessage(), 500, "SQL_ERROR"));
    }

    // Validación de @Valid en requests
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> handleValidation(MethodArgumentNotValidException ex) {
        String detalle = ex.getBindingResult().getFieldErrors().stream()
            .map(fe -> fe.getField() + ": " + fe.getDefaultMessage())
            .reduce((a, b) -> a + " | " + b)
            .orElse("Datos inválidos");
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(buildError("Error de validación", 400, detalle));
    }

    // XOR idContenido / idEpisodio
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiError> handleIllegalArg(IllegalArgumentException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(buildError(ex.getMessage(), 400, "BAD_REQUEST"));
    }

    private ApiError buildError(String error, int codigo, String detalle) {
        return ApiError.builder()
            .error(error)
            .codigo(codigo)
            .detalle(detalle)
            .timestamp(LocalDateTime.now())
            .build();
    }
}
