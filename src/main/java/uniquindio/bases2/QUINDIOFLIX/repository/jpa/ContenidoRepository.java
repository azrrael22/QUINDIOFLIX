package uniquindio.bases2.QUINDIOFLIX.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import uniquindio.bases2.QUINDIOFLIX.entity.Contenido;

import java.util.List;

public interface ContenidoRepository extends JpaRepository<Contenido, Long> {

    List<Contenido> findByCategoria_IdCategoria(Long idCategoria);

    List<Contenido> findByEsOriginal(String esOriginal);

    List<Contenido> findByAnioLanzamiento(Integer anio);

    List<Contenido> findByTituloContainingIgnoreCase(String titulo);

    @Query("""
        SELECT c FROM Contenido c
        JOIN c.generos g
        WHERE g.idGenero = :idGenero
        ORDER BY c.popularidad DESC
        """)
    List<Contenido> findByGeneroOrderByPopularidad(@Param("idGenero") Long idGenero);
}
