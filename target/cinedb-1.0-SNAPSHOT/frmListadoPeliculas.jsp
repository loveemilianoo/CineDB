<%@page import="java.time.Duration"%>
<%@page import="dao.PeliculaDAO"%>
<%@page import="entity.Pelicula"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gestionar Películas - Cine Prototype</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
      .hero-section {
        color: white;
        padding: 60px 0;
      }
      .section-title {
        position: relative;
        padding-bottom: 15px;
        margin-bottom: 30px;
      }
      .section-title:after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 80px;
        height: 3px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      }
      .table-hover tbody tr:hover {
        background-color: rgba(102, 126, 234, 0.1);
      }
      .action-buttons .btn {
        margin: 2px;
      }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <div class="container">
        <a class="navbar-brand" href="frmMenu.jsp">
          <i class="fa-solid fa-film me-2"></i>Cine
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav" aria-controls="nav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="nav">
          <ul class="navbar-nav ms-auto">
            <li class="nav-item"><a class="nav-link" href="frmMenu.jsp">Inicio</a></li>
            <li class="nav-item"><a class="nav-link" href="frmSeleccionarPelicula.jsp">Boletos</a></li>
            <li class="nav-item"><a class="nav-link" href="#">Comida</a></li>
            <li class="nav-item"><a class="nav-link active" href="frmListadoPeliculas.jsp">Administrar</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <header class="hero-section text-center position-relative" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
      <div class="container position-relative" style="z-index: 1;">
        <h1 class="display-5 fw-bold mb-3">Gestión de Películas</h1>
        <p class="lead mb-0">Administra el catálogo completo de películas del cine</p>
      </div>
    </header>

    <main class="container my-5">
      <!-- Encabezado con acciones -->
      <div class="row align-items-center mb-4">
        <div class="col-md-6">
          <h2 class="section-title mb-0">Catálogo de Películas</h2>
        </div>
        <div class="col-md-6 text-end">
          <div class="btn-group" role="group">
            <a href="frmInsertarPelicula.jsp" class="btn btn-primary">
              <i class="fa-solid fa-plus me-2"></i>Agregar Película
            </a>
            <a href="frmMenu.jsp" class="btn btn-outline-secondary">
              <i class="fa-solid fa-home me-2"></i>Menú Principal
            </a>
          </div>
        </div>
      </div>

      <!-- Tabla de películas -->
      <div class="card shadow-sm border-0">
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
              <thead class="table-light">
                <tr>
                  <th scope="col" class="ps-4">ID</th>
                  <th scope="col">Título</th>
                  <th scope="col">Duración</th>
                  <th scope="col">Género</th>
                  <th scope="col">Clasificación</th>
                  <th scope="col" class="text-center pe-4">Acciones</th>
                </tr>
              </thead>
              <tbody>
                <%
                    PeliculaDAO dao = new PeliculaDAO();
                    List<Pelicula> peliculas = dao.getPeliculas();
                    
                    if(peliculas.isEmpty()) {
                %>
                <tr>
                  <td colspan="6" class="text-center py-5">
                    <div class="text-muted">
                      <i class="fa-solid fa-film fa-3x mb-3"></i>
                      <h5 class="mb-3">No hay películas registradas</h5>
                      <p class="mb-4">Comienza agregando la primera película al catálogo</p>
                      <a href="frmInsertarPelicula.jsp" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-2"></i>Agregar Primera Película
                      </a>
                    </div>
                  </td>
                </tr>
                <%
                    } else {
                        for(Pelicula pelicula : peliculas) {
                %>
                <tr>
                  <td class="ps-4">
                    <span class="fw-bold text-primary">#<%= pelicula.getIdPelicula() %></span>
                  </td>
                  <td>
                    <div>
                      <strong class="text-dark"><%= pelicula.getTitulo() %></strong>
                    </div>
                  </td>
                  <td>
                    <span class="badge bg-light text-dark border">
                      <i class="fa-solid fa-clock me-1"></i>
                      <%
                          Duration duracion = pelicula.getDuracion();
                          long horas = duracion.toHours();
                          long minutos = duracion.toMinutesPart();
                          out.print(horas + "h " + minutos + "m");
                      %>
                    </span>
                  </td>
                  <td>
                    <span class="badge bg-secondary">
                      <i class="fa-solid fa-tag me-1"></i><%= pelicula.getGenero() %>
                    </span>
                  </td>
                  <td>
                    <span class="badge bg-<%= 
                        pelicula.getClasificacion().equals("G") ? "success" : 
                        pelicula.getClasificacion().equals("PG") ? "info" : 
                        pelicula.getClasificacion().equals("PG-13") ? "warning" : 
                        pelicula.getClasificacion().equals("R") ? "danger" : "secondary" 
                    %>">
                      <i class="fa-solid fa-certificate me-1"></i><%= pelicula.getClasificacion() %>
                    </span>
                  </td>
                  <td class="text-center pe-4 action-buttons">
                    <div class="btn-group btn-group-sm" role="group">
                      <button class="btn btn-outline-primary" 
                              onclick="editarPelicula(<%= pelicula.getIdPelicula() %>)">
                        <i class="fa-solid fa-pen-to-square me-1"></i>Editar
                      </button>
                      <button class="btn btn-outline-danger" 
                              onclick="confirmarEliminacion(<%= pelicula.getIdPelicula() %>, '<%= pelicula.getTitulo() %>')">
                        <i class="fa-solid fa-trash me-1"></i>Eliminar
                      </button>
                    </div>
                  </td>
                </tr>
                <%
                        }
                    }
                %>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Resumen y acciones adicionales -->
      <div class="row mt-4">
        <div class="col-md-6">
          <div class="d-flex align-items-center">
            <span class="text-muted me-3">
              <i class="fa-solid fa-film me-1"></i>Total de películas: 
              <strong class="text-dark"><%= peliculas.size() %></strong>
            </span>
          </div>
        </div>
        <div class="col-md-6 text-end">
          <div class="btn-group" role="group">
            <a href="frmInsertarPelicula.jsp" class="btn btn-outline-primary btn-sm">
              <i class="fa-solid fa-plus me-1"></i>Nueva Película
            </a>
            <a href="frmMenu.jsp" class="btn btn-outline-secondary btn-sm">
              <i class="fa-solid fa-arrow-left me-1"></i>Volver al Menú
            </a>
          </div>
        </div>
      </div>
    </main>

    <footer class="bg-dark text-white py-4 mt-5">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-md-6">
            <h5><i class="fa-solid fa-film me-2"></i>Cine Prototype</h5>
            <p class="mb-0">Sistema de gestión cinematográfica</p>
          </div>
          <div class="col-md-6 text-end">
            <div class="btn-group" role="group">
              <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-light btn-sm">
                <i class="fa-solid fa-ticket me-1"></i>Boletos
              </a>
              <a href="#" class="btn btn-outline-light btn-sm">
                <i class="fa-solid fa-popcorn me-1"></i>Comida
              </a>
              <a href="frmListadoPeliculas.jsp" class="btn btn-outline-light btn-sm">
                <i class="fa-solid fa-sliders me-1"></i>Administrar
              </a>
            </div>
          </div>
        </div>
        <hr class="my-3">
        <div class="text-center">
          <p class="mb-0">© 2024 Cine Prototype. Sistema desarrollado con Java JSP y PostgreSQL</p>
        </div>
      </div>
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

      function editarPelicula(id) {
        alert(`Editando película con ID: ${id} (funcionalidad en desarrollo)`);
        // Aquí iría la lógica real de edición
        // window.location.href = 'frmEditarPelicula.jsp?id=' + id;
      }
    </script>
  </body>
</html>