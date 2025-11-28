<%@page import="java.time.Duration"%>
<%@page import="dao.PeliculaDAO"%>
<%@page import="entity.Pelicula"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Catálogo de Películas - Cine Prototype</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <div class="container">
        <a class="navbar-brand" href="frmListadoPeliculas.jsp">Cine Prototype</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav" aria-controls="nav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="nav">
          <ul class="navbar-nav ms-auto">
            <li class="nav-item"><a class="nav-link active" href="frmListadoPeliculas.jsp">Catálogo</a></li>
            <li class="nav-item"><a class="nav-link" href="frmInsertarPelicula.jsp">Agregar</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <header class="text-white text-center py-5" style="background-color: black;">
      <div class="container">
        <h1 class="display-4 fw-bold">Bienvenido a Cine Prototype</h1>
        <p class="lead mb-0">Disfruta de la mejor colección de películas</p>
      </div>
    </header>

    <main class="container my-5">
      <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Catálogo de Películas</h1>
        <a href="frmInsertarPelicula.jsp" class="btn btn-primary"><i class="fa-solid fa-plus me-2"></i>Agregar Nueva Película</a>
      </div>

      <div class="table-responsive">
        <table class="table table-striped table-hover align-middle">
          <thead class="table-light">
            <tr>
              <th scope="col">ID</th>
              <th scope="col">Título</th>
              <th scope="col">Duración</th>
              <th scope="col">Género</th>
              <th scope="col">Clasificación</th>
              <th scope="col">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <%
                PeliculaDAO dao = new PeliculaDAO();
                List<Pelicula> peliculas = dao.getPeliculas();
                
                if(peliculas.isEmpty()) {
            %>
                <tr>
                    <td colspan="6" class="text-center py-4">
                        <div class="text-muted">
                            <i class="fa-solid fa-film fa-2x mb-3"></i>
                            <p>No hay películas registradas</p>
                            <a href="frmInsertarPelicula.jsp" class="btn btn-sm btn-primary">Agregar primera película</a>
                        </div>
                    </td>
                </tr>
            <%
                } else {
                    for(Pelicula pelicula : peliculas) {
            %>
                <tr>
                    <td><%= pelicula.getIdPelicula() %></td>
                    <td>
                        <strong><%= pelicula.getTitulo() %></strong>
                    </td>
                    <td>
                        <%
                            Duration duracion = pelicula.getDuracion();
                            long horas = duracion.toHours();
                            long minutos = duracion.toMinutesPart();
                            out.print(horas + "h " + minutos + "m");
                        %>
                    </td>
                    <td>
                        <span class="badge bg-secondary"><%= pelicula.getGenero() %></span>
                    </td>
                    <td>
                        <span class="badge bg-info"><%= pelicula.getClasificacion() %></span>
                    </td>
                    <td>
                        <a href="#" class="btn btn-sm btn-outline-secondary me-2">
                            <i class="fa-solid fa-pen-to-square"></i> Editar
                        </a>
                        <button class="btn btn-sm btn-outline-danger" 
                                onclick="confirmarEliminacion(<%= pelicula.getIdPelicula() %>, '<%= pelicula.getTitulo() %>')">
                            <i class="fa-solid fa-trash"></i> Eliminar
                        </button>
                    </td>
                </tr>
            <%
                    }
                }
            %>
          </tbody>
        </table>
      </div>

      <div class="mt-4">
        <small class="text-muted">
          Total de películas: <strong><%= peliculas.size() %></strong>
        </small>
      </div>
    </main>

    <footer class="bg-light py-3 mt-auto">
      <div class="container text-center small text-muted">© 2025 Cine Prototype</div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmarEliminacion(id, titulo) {
            if (confirm(`¿Estás seguro de que quieres eliminar la película "${titulo}"?`)) {
                alert(`Película "${titulo}" eliminada (esto es solo una demostración)`);
                // Aquí iría la lógica real de eliminación
                // window.location.href = 'EliminarPeliculaServlet?id=' + id;
            }
        }
    </script>
  </body>
</html>