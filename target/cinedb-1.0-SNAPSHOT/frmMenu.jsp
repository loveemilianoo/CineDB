<%@page import="dao.PeliculaDAO"%>
<%@page import="entity.Pelicula"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inicio - Cine Prototype</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
      .hero-section {
        color: white;
        padding: 80px 0;
      }
      .action-card {
        transition: transform 0.3s, box-shadow 0.3s;
        border: none;
        border-radius: 15px;
        overflow: hidden;
      }
      .action-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 10px 25px rgba(0,0,0,0.2);
      }
      .action-icon {
        font-size: 4rem;
        margin-bottom: 1.5rem;
      }
      .btn-action {
        padding: 15px 30px;
        font-size: 1.1rem;
        border-radius: 10px;
        transition: all 0.3s;
      }
      .movie-card {
        height: 100%;
        transition: transform 0.3s;
      }
      .movie-card:hover {
        transform: scale(1.05);
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
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <div class="container">
        <a class="navbar-brand" href="frmMenu.jsp">
          <i class="fa-solid fa-film me-2"></i>Cine Prototype
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav" aria-controls="nav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="nav">
          <ul class="navbar-nav ms-auto">
            <li class="nav-item"><a class="nav-link active" href="frmMenu.jsp">Inicio</a></li>
            <li class="nav-item"><a class="nav-link" href="frmSeleccionarPelicula.jsp">Boletos</a></li>
            <li class="nav-item"><a class="nav-link" href="#">Comida</a></li>
            <li class="nav-item"><a class="nav-link" href="frmListadoPeliculas.jsp">Administrar</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <header class="hero-section text-center position-relative" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
      <div class="container position-relative" style="z-index: 1;">
        <h1 class="display-4 fw-bold mb-4">Cine Prototype</h1>
        <p class="lead mb-5">Tu experiencia cinematográfica perfecta comienza aquí</p>
      </div>
    </header>

    <main class="container my-5">
      <!-- Sección de Acciones Principales -->
      <section class="row g-4 mb-5">
        <div class="col-12">
          <h2 class="text-center section-title">¿Qué deseas hacer?</h2>
        </div>
        
        <!-- Comprar Boletos -->
        <div class="col-md-4">
          <div class="card action-card h-100 text-center border-primary">
            <div class="card-body p-4">
              <div class="action-icon text-primary">
                <i class="fa-solid fa-ticket"></i>
              </div>
              <h3 class="card-title mb-3">Comprar Boletos</h3>
              <p class="card-text text-muted mb-4">
                Selecciona tu película, función y asiento preferido. Vive la experiencia completa del cine.
              </p>
              <a href="frmSeleccionarPelicula.jsp" class="btn btn-primary btn-action w-100">
                <i class="fa-solid fa-clapperboard me-2"></i>Comprar Boletos
              </a>
            </div>
          </div>
        </div>
        
        <!-- Comprar Comida -->
        <div class="col-md-4">
          <div class="card action-card h-100 text-center border-success">
            <div class="card-body p-4">
              <div class="action-icon text-success">
                <i class="fa-solid fa-popcorn"></i>
              </div>
              <h3 class="card-title mb-3">Comprar Comida</h3>
              <p class="card-text text-muted mb-4">
                Disfruta de nuestros deliciosos combos, snacks y bebidas. El complemento perfecto para tu película.
              </p>
              <a href="#" class="btn btn-success btn-action w-100">
                <i class="fa-solid fa-utensils me-2"></i>Ordenar Comida
              </a>
            </div>
          </div>
        </div>
        
        <!-- Administrar Sistema -->
        <div class="col-md-4">
          <div class="card action-card h-100 text-center border-warning">
            <div class="card-body p-4">
              <div class="action-icon text-warning">
                <i class="fa-solid fa-sliders"></i>
              </div>
              <h3 class="card-title mb-3">Administrar Sistema</h3>
              <p class="card-text text-muted mb-4">
                Gestiona películas, productos, funciones y más. Panel de control completo del cine.
              </p>
              <div class="dropdown">
                <button class="btn btn-warning btn-action w-100 dropdown-toggle" type="button" data-bs-toggle="dropdown">
                  <i class="fa-solid fa-gear me-2"></i>Administrar
                </button>
                <ul class="dropdown-menu w-100">
                  <li><a class="dropdown-item" href="frmListadoPeliculas.jsp"><i class="fa-solid fa-film me-2"></i>Gestionar Películas</a></li>
                  <li><a class="dropdown-item" href="#"><i class="fa-solid fa-tags me-2"></i>Gestionar Productos</a></li>
                  <li><a class="dropdown-item" href="#"><i class="fa-solid fa-calendar me-2"></i>Gestionar Funciones</a></li>
                  <li><a class="dropdown-item" href="frmListadoBoletos.jsp"><i class="fa-solid fa-ticket me-2"></i>Ver Boletos</a></li>
                  <li><hr class="dropdown-divider"></li>
                  <li><a class="dropdown-item" href="#"><i class="fa-solid fa-chart-bar me-2"></i>Reportes</a></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Cartelera Rápida -->
      <section class="row g-4">
        <div class="col-12">
          <h2 class="text-center section-title">Cartelera Destacada</h2>
        </div>
        <%
            PeliculaDAO peliculaDAO = new PeliculaDAO();
            List<Pelicula> peliculas = peliculaDAO.getPeliculas();
            
            int count = 0;
            for (Pelicula pelicula : peliculas) {
                if (count >= 3) break;
        %>
        <div class="col-md-4">
          <div class="card movie-card shadow-sm">
            <div style="height: 200px; background: linear-gradient(45deg, #<?= String.format("%06x", (int)(Math.random() * 0xFFFFFF)) %>, #<?= String.format("%06x", (int)(Math.random() * 0xFFFFFF)) %>); display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem;">
              <i class="fa-solid fa-film"></i>
            </div>
            <div class="card-body text-center">
              <h5 class="card-title"><%= pelicula.getTitulo() %></h5>
              <p class="card-text text-muted small">
                <%= pelicula.getGenero() %> • 
                <%
                    java.time.Duration duracion = pelicula.getDuracion();
                    long horas = duracion.toHours();
                    long minutos = duracion.toMinutesPart();
                    out.print(horas + "h " + minutos + "m");
                %>
              </p>
              <div class="d-grid gap-2">
                <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-primary btn-sm">
                  <i class="fa-solid fa-ticket me-1"></i>Comprar Boleto
                </a>
              </div>
            </div>
          </div>
        </div>
        <%
                count++;
            }
            
            if (peliculas.isEmpty()) {
        %>
        <div class="col-12 text-center">
          <div class="alert alert-info">
            <i class="fa-solid fa-info-circle me-2"></i>
            No hay películas en cartelera en este momento.
            <a href="frmListadoPeliculas.jsp" class="alert-link">Agregar películas</a>
          </div>
        </div>
        <%
            }
        %>
      </section>

      <!-- Estadísticas Rápidas -->
      <section class="row g-4 mt-5">
        <div class="col-12">
          <div class="bg-light p-4 rounded-3">
            <div class="row text-center">
              <div class="col-md-3">
                <h4 class="text-primary mb-1">
                  <i class="fa-solid fa-film me-2"></i><%= peliculas.size() %>
                </h4>
                <p class="mb-0 text-muted">Películas en Cartelera</p>
              </div>
              <div class="col-md-3">
                <h4 class="text-success mb-1">
                  <i class="fa-solid fa-ticket me-2"></i>+
                </h4>
                <p class="mb-0 text-muted">Boletos Vendidos</p>
              </div>
              <div class="col-md-3">
                <h4 class="text-warning mb-1">
                  <i class="fa-solid fa-star me-2"></i>4.8
                </h4>
                <p class="mb-0 text-muted">Calificación</p>
              </div>
              <div class="col-md-3">
                <h4 class="text-info mb-1">
                  <i class="fa-solid fa-users me-2"></i>100%
                </h4>
                <p class="mb-0 text-muted">Clientes Satisfechos</p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <footer class="bg-dark text-white py-4 mt-5">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-md-6">
            <h5><i class="fa-solid fa-film me-2"></i>Cine Prototype</h5>
            <p class="mb-0">Más que cine, una experiencia.</p>
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