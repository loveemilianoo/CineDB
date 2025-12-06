<%-- 
    Document   : frmInsertarSala
    Created on : 5 dic 2025, 11:31:48 p.m.
    Author     : Kevin
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="dao.SalaDAO"%>
<%@page import="entity.Sala"%>

<%
    if (request.getMethod().equals("POST")) {
        int numero = Integer.parseInt(request.getParameter("numero"));
        int capacidad = Integer.parseInt(request.getParameter("capacidad"));

        Sala nueva = new Sala(0, numero, capacidad);
        new SalaDAO().insertarSala(nueva);

        response.sendRedirect("frmListadoSalas.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Agregar Nueva Sala - Cine Prototype</title>
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

    .form-container {
      max-width: 600px;
      margin: 0 auto;
    }

    .form-label {
      font-weight: 600;
      color: #495057;
    }

    .input-group-icon {
      position: absolute;
      left: 15px;
      top: 50%;
      transform: translateY(-50%);
      color: #6c757d;
      z-index: 3;
    }

    .form-control-with-icon {
      padding-left: 45px;
    }
  </style>
</head>

<body>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
      <a class="navbar-brand" href="frmMenu.jsp">
        <i class="fa-solid fa-film me-2"></i>Cine
      </a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav"
        aria-controls="nav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="nav">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item"><a class="nav-link" href="frmMenu.jsp">Inicio</a></li>
          <li class="nav-item"><a class="nav-link" href="frmSeleccionarPelicula.jsp">Boletos</a></li>
          <li class="nav-item"><a class="nav-link" href="#">Comida</a></li>
          <li class="nav-item"><a class="nav-link active" href="frmListadoSalas.jsp">Administrar</a></li>
        </ul>
      </div>
    </div>
  </nav>

  <header class="hero-section text-center position-relative"
    style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
    <div class="container position-relative" style="z-index: 1;">
      <h1 class="display-5 fw-bold mb-3">Agregar Nueva Sala</h1>
      <p class="lead mb-0">Registra una nueva sala en el sistema de cine</p>
    </div>
  </header>

  <main class="container my-5">
    <div class="row justify-content-center">
      <div class="col-lg-8">
        <div class="card shadow-sm border-0">
          <div class="card-header bg-white border-0 py-4">
            <h2 class="section-title mb-0">
              <i class="fa-solid fa-door-open me-2"></i>Información de la Sala
            </h2>
            <p class="text-muted mb-0 mt-2">Complete todos los campos para registrar una nueva sala</p>
          </div>
          <div class="card-body p-4">
            <form method="post" id="salaForm">
              <div class="row">
                <!-- Número de Sala -->
                <div class="col-md-6 mb-4">
                  <label for="numero" class="form-label">
                    <i class="fa-solid fa-hashtag me-1"></i>Número de Sala
                  </label>
                  <div class="input-group">
                    <span class="input-group-text">
                      <i class="fa-solid fa-door-closed"></i>
                    </span>
                    <input type="number" 
                           class="form-control" 
                           id="numero" 
                           name="numero" 
                           required 
                           min="1"
                           max="50"
                           placeholder="Ej: 1, 2, 3...">
                  </div>
                  <div class="form-text">Número único que identifica la sala</div>
                </div>

                <!-- Capacidad -->
                <div class="col-md-6 mb-4">
                  <label for="capacidad" class="form-label">
                    <i class="fa-solid fa-users me-1"></i>Capacidad
                  </label>
                  <div class="input-group">
                    <span class="input-group-text">
                      <i class="fa-solid fa-chair"></i>
                    </span>
                    <input type="number" 
                           class="form-control" 
                           id="capacidad" 
                           name="capacidad" 
                           required 
                           min="10"
                           max="500"
                           placeholder="Ej: 50, 100, 150...">
                    <span class="input-group-text">personas</span>
                  </div>
                  <div class="form-text">Número máximo de espectadores</div>
                </div>
              </div>

              <!-- Información adicional -->
              <div class="alert alert-info mb-4">
                <div class="d-flex">
                  <div class="me-3">
                    <i class="fa-solid fa-circle-info fa-lg"></i>
                  </div>
                  <div>
                    <h6 class="alert-heading mb-2">Consideraciones importantes</h6>
                    <ul class="mb-0 ps-3">
                      <li>El número de sala debe ser único en el sistema</li>
                      <li>La capacidad mínima recomendada es de 10 personas</li>
                      <li>Verifique que la sala no exista previamente</li>
                    </ul>
                  </div>
                </div>
              </div>

              <!-- Botones de acción -->
              <div class="d-flex justify-content-between pt-3">
                <a href="frmListadoSalas.jsp" class="btn btn-outline-secondary">
                  <i class="fa-solid fa-arrow-left me-2"></i>Volver al Listado
                </a>
                <div class="btn-group">
                  <button type="reset" class="btn btn-outline-danger">
                    <i class="fa-solid fa-eraser me-2"></i>Limpiar
                  </button>
                  <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-floppy-disk me-2"></i>Guardar Sala
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>

        <!-- Vista previa -->
        <div class="card shadow-sm border-0 mt-4">
          <div class="card-header bg-white border-0 py-3">
            <h5 class="mb-0">
              <i class="fa-solid fa-eye me-2"></i>Vista previa
            </h5>
          </div>
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-md-8">
                <div class="d-flex align-items-center">
                  <div class="bg-light rounded-circle p-3 me-3">
                    <i class="fa-solid fa-door-open fa-2x text-primary"></i>
                  </div>
                  <div>
                    <h5 class="mb-1" id="previewNombre">Sala [Número]</h5>
                    <p class="text-muted mb-0" id="previewCapacidad">Capacidad: [capacidad] personas</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4 text-end">
                <span class="badge bg-info fs-6">
                  <i class="fa-solid fa-users me-1"></i>
                  <span id="previewCapacidadBadge">0</span> personas
                </span>
              </div>
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
          <h5><i class="fa-solid fa-film me-2"></i>Sistema de Cine</h5>
          <p class="mb-0">Sistema de gestión de salas</p>
        </div>
        <div class="col-md-6 text-end">
          <div class="btn-group" role="group">
            <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-light btn-sm">
              <i class="fa-solid fa-ticket me-1"></i>Boletos
            </a>
            <a href="#" class="btn btn-outline-light btn-sm">
              <i class="fa-solid fa-popcorn me-1"></i>Comida
            </a>
            <a href="frmListadoSalas.jsp" class="btn btn-outline-light btn-sm">
              <i class="fa-solid fa-sliders me-1"></i>Administrar
            </a>
          </div>
        </div>
      </div>
      <hr class="my-3">
      <div class="text-center text-muted">
        <small>© 2025 Sistema de Gestión de Cine. Todos los derechos reservados.</small>
      </div>
    </div>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const numeroInput = document.getElementById('numero');
      const capacidadInput = document.getElementById('capacidad');
      const previewNombre = document.getElementById('previewNombre');
      const previewCapacidad = document.getElementById('previewCapacidad');
      const previewCapacidadBadge = document.getElementById('previewCapacidadBadge');
      
      function updatePreview() {
        const numero = numeroInput.value || '[Número]';
        const capacidad = capacidadInput.value || '[capacidad]';
        
        previewNombre.textContent = `Sala ${numero}`;
        previewCapacidad.textContent = `Capacidad: ${capacidad} personas`;
        previewCapacidadBadge.textContent = capacidad;
      }
      
      numeroInput.addEventListener('input', updatePreview);
      capacidadInput.addEventListener('input', updatePreview);
      
      updatePreview();
      
      document.getElementById('salaForm').addEventListener('submit', function(e) {
        const numero = parseInt(numeroInput.value);
        const capacidad = parseInt(capacidadInput.value);
        
        if (numero < 1 || numero > 50) {
          e.preventDefault();
          alert('El número de sala debe estar entre 1 y 50');
          numeroInput.focus();
          return false;
        }
        
        if (capacidad < 10 || capacidad > 500) {
          e.preventDefault();
          alert('La capacidad debe estar entre 10 y 500 personas');
          capacidadInput.focus();
          return false;
        }
        
        return true;
      });
    });
  </script>
</body>

</html>