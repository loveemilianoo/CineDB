<%@page import="dao.PeliculaDAO"%>
<%@page import="entity.Pelicula"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Seleccionar Película - Cine Prototype</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
      .hero-section {
        color: white;
        padding: 60px 0;
      }
      .movie-card {
        transition: transform 0.3s, box-shadow 0.3s;
        border: none;
        border-radius: 15px;
        overflow: hidden;
        height: 100%;
      }
      .movie-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
      }
      .movie-poster {
        height: 250px;
        background: linear-gradient(45deg, #667eea, #764ba2);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 4rem;
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
        left: 50%;
        transform: translateX(-50%);
        width: 80px;
        height: 3px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      }
      .btn-select {
        padding: 10px 20px;
        border-radius: 8px;
        transition: all 0.3s;
      }
      .movie-info {
        border-left: 3px solid #667eea;
        padding-left: 15px;
        margin: 10px 0;
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
            <li class="nav-item"><a class="nav-link active" href="frmSeleccionarPelicula.jsp">Boletos</a></li>
            <li class="nav-item"><a class="nav-link" href="#">Comida</a></li>
            <li class="nav-item"><a class="nav-link" href="frmListadoPeliculas.jsp">Administrar</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <header class="hero-section text-center position-relative" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
      <div class="container position-relative" style="z-index: 1;">
        <h1 class="display-5 fw-bold mb-3">Selecciona una Película</h1>
      </div>
    </header>

    <main class="container my-5">
      <div class="row">
        <div class="col-12">
          <h2 class="text-center section-title">Cartelera Disponible</h2>
        </div>
      </div>

      <%
          PeliculaDAO peliculaDAO = new PeliculaDAO();
          List<Pelicula> peliculas = peliculaDAO.getPeliculas();
          
          if (peliculas.isEmpty()) {
      %>
      <div class="row">
        <div class="col-12">
          <div class="alert alert-info text-center">
            <i class="fa-solid fa-film fa-2x mb-3"></i>
            <h4>No hay películas en cartelera</h4>
            <p class="mb-3">Actualmente no tenemos películas disponibles.</p>
            <a href="frmListadoPeliculas.jsp" class="btn btn-primary">
              <i class="fa-solid fa-plus me-2"></i>Agregar Películas
            </a>
          </div>
        </div>
      </div>
      <%
          } else {
      %>
      <div class="row g-4">
        <%
            for (Pelicula pelicula : peliculas) {
                // Generar color único para cada película
                String color1 = String.format("#%06x", (pelicula.getTitulo().hashCode() & 0xFFFFFF));
                String color2 = String.format("#%06x", ((pelicula.getTitulo().hashCode() + 123456) & 0xFFFFFF));
        %>
        <div class="col-md-6 col-lg-4">
          <div class="card movie-card shadow-sm">
            <!-- Poster de la película -->
            <div class="movie-poster" style="background: linear-gradient(135deg, <%= color1 %>, <%= color2 %>);">
              <i class="fa-solid fa-clapperboard"></i>
            </div>
            
            <div class="card-body">
              <h5 class="card-title fw-bold text-dark"><%= pelicula.getTitulo() %></h5>
              
              <div class="movie-info">
                <p class="card-text mb-2">
                  <i class="fa-solid fa-tags me-2 text-primary"></i>
                  <strong>Género:</strong> <%= pelicula.getGenero() %>
                </p>
                
                <p class="card-text mb-2">
                  <i class="fa-solid fa-clock me-2 text-warning"></i>
                  <strong>Duración:</strong> 
                  <%
                      java.time.Duration duracion = pelicula.getDuracion();
                      long horas = duracion.toHours();
                      long minutos = duracion.toMinutesPart();
                      out.print(horas + "h " + minutos + "m");
                  %>
                </p>
                
                <p class="card-text mb-3">
                  <i class="fa-solid fa-certificate me-2 text-success"></i>
                  <strong>Clasificación:</strong> 
                  <span class="badge bg-<%= 
                      pelicula.getClasificacion().equals("G") ? "success" : 
                      pelicula.getClasificacion().equals("PG") ? "info" : 
                      pelicula.getClasificacion().equals("PG-13") ? "warning" : 
                      pelicula.getClasificacion().equals("R") ? "danger" : "secondary" 
                  %>">
                    <%= pelicula.getClasificacion() %>
                  </span>
                </p>
              </div>
              
              <!-- Formulario para seleccionar función -->
              <form action="frmSeleccionarFuncion.jsp" method="GET">
                <input type="hidden" name="idPelicula" value="<%= pelicula.getIdPelicula() %>">
                <input type="hidden" name="tituloPelicula" value="<%= pelicula.getTitulo() %>">
                <button type="submit" class="btn btn-primary btn-select w-100">
                  <i class="fa-solid fa-ticket me-2"></i>
                  
                  
                </button>
              </form>
            </div>
          </div>
        </div>
        <%
            }
        %>
      </div>
      <%
          }
      %>

      <!-- Acciones adicionales -->
      <div class="row mt-5">
        <div class="col-12">
          <div class="bg-light p-4 rounded-3">
            <div class="row align-items-center">
              <div class="col-md-8">
                <h4 class="mb-2">¿No hay peliculas?</h4>
                <p class="mb-0 text-muted">Se pueden añadir en menú de Administración.</p>
              </div>
              <div class="col-md-4 text-end">
                <a href="frmListadoPeliculas.jsp" class="btn btn-outline-primary">
                  <i class="fa-solid fa-sliders me-2"></i>Gestionar Películas
                </a>
                <a href="frmMenu.jsp" class="btn btn-outline-secondary ms-2">
                  <i class="fa-solid fa-home me-2"></i>Volver al Inicio
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <footer class="bg-dark text-white py-4 mt-5">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-md-6">
            <h5><i class="fa-solid fa-film me-2"></i>Cine Prototype</h5>
            <p class="mb-0">Tu cine de confianza</p>
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
  </body>
</html>