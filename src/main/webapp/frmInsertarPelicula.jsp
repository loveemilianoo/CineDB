<%@page import="dao.PeliculaDAO"%>
<%@page import="entity.Pelicula"%>
<%@page import="java.time.Duration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Agregar Película - Cine Prototype</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .duration-inputs .input-group {
            max-width: 200px;
        }
    </style>
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
            <li class="nav-item"><a class="nav-link" href="frmListadoPeliculas.jsp">Catálogo</a></li>
            <li class="nav-item"><a class="nav-link active" href="frmInsertarPelicula.jsp">Agregar</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <header class="text-white text-center py-4" style="background-color: black;">
      <div class="container">
        <h1 class="h3 fw-bold mb-0">Agregar Nueva Película</h1>
      </div>
    </header>

    <main class="container my-5">
      <div class="row justify-content-center">
        <div class="col-md-8">
          <div class="card shadow">
            <div class="card-header bg-primary text-white">
              <h5 class="card-title mb-0"><i class="fa-solid fa-plus me-2"></i>Información de la Película</h5>
            </div>
            <div class="card-body">
              
              <%
                  // Procesar el formulario cuando se envía
                  if ("POST".equalsIgnoreCase(request.getMethod())) {
                      System.out.println("📨 Formulario enviado por POST");
                      
                      String titulo = request.getParameter("titulo");
                      String horasStr = request.getParameter("horas");
                      String minutosStr = request.getParameter("minutos");
                      String genero = request.getParameter("genero");
                      String clasificacion = request.getParameter("clasificacion");
                      
                      try {
                          // Validar campos obligatorios
                          if (titulo != null && !titulo.trim().isEmpty() &&
                              horasStr != null && minutosStr != null &&
                              genero != null && !genero.trim().isEmpty() &&
                              clasificacion != null && !clasificacion.isEmpty()) {
                              
                              int horas = Integer.parseInt(horasStr);
                              int minutos = Integer.parseInt(minutosStr);
                              
                              if (horas == 0 && minutos == 0) {
              %>
                              <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                  <i class="fa-solid fa-triangle-exclamation me-2"></i>
                                  <strong>Advertencia:</strong> La duración debe ser mayor a 0. Ingresa horas o minutos.
                                  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                              </div>
              <%
                              } else {
                                  Duration duracion = Duration.ofHours(horas).plusMinutes(minutos);
                                  
                                  // Crear objeto Pelicula
                                  Pelicula pelicula = new Pelicula();
                                  pelicula.setTitulo(titulo.trim());
                                  pelicula.setDuracion(duracion);
                                  pelicula.setGenero(genero.trim());
                                  pelicula.setClasificacion(clasificacion);
                                  
                                  // Insertar en la base de datos
                                  PeliculaDAO dao = new PeliculaDAO();
                                  dao.insertarPeliculas(pelicula);
              %>
                              <div class="alert alert-success alert-dismissible fade show" role="alert">
                                  <i class="fa-solid fa-check-circle me-2"></i>
                                  <strong>¡Éxito!</strong> Película "<%= titulo %>" agregada correctamente.
                                  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                              </div>
                              <script>
                                  setTimeout(function() {
                                      window.location.href = 'frmListadoPeliculas.jsp';
                                  }, 2000);
                              </script>
              <%
                              }
                          } else {
              %>
                              <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                  <i class="fa-solid fa-circle-exclamation me-2"></i>
                                  <strong>Error:</strong> Por favor, completa todos los campos obligatorios.
                                  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                              </div>
              <%
                          }
                      } catch (NumberFormatException e) {
              %>
                          <div class="alert alert-danger alert-dismissible fade show" role="alert">
                              <i class="fa-solid fa-circle-exclamation me-2"></i>
                              <strong>Error:</strong> Formato inválido en horas o minutos. Usa solo números.
                              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                          </div>
              <%
                      } catch (Exception e) {
              %>
                          <div class="alert alert-danger alert-dismissible fade show" role="alert">
                              <i class="fa-solid fa-circle-exclamation me-2"></i>
                              <strong>Error:</strong> <%= e.getMessage() %>
                              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                          </div>
              <%
                          e.printStackTrace();
                      }
                  }
              %>
              
              <form method="POST" action="" onsubmit="return validarFormulario()">
                <div class="row">
                  <div class="col-md-12 mb-3">
                    <label for="titulo" class="form-label">Título de la Película <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="titulo" name="titulo" required 
                           placeholder="Ej: Avengers: Endgame" 
                           value="<%= request.getParameter("titulo") != null ? request.getParameter("titulo") : "" %>">
                  </div>
                  
                  <div class="col-md-12 mb-3">
                    <label class="form-label">Duración <span class="text-danger">*</span></label>
                    <div class="duration-inputs d-flex gap-3">
                      <div>
                        <label for="horas" class="form-label small">Horas</label>
                        <input type="number" class="form-control" id="horas" name="horas" min="0" max="10" 
                               value="<%= request.getParameter("horas") != null ? request.getParameter("horas") : "2" %>" required>
                      </div>
                      <div>
                        <label for="minutos" class="form-label small">Minutos</label>
                        <input type="number" class="form-control" id="minutos" name="minutos" min="0" max="59" 
                               value="<%= request.getParameter("minutos") != null ? request.getParameter("minutos") : "30" %>" required>
                      </div>
                    </div>
                    <div class="form-text">Ejemplo: 2 horas y 30 minutos se guardará como "2h 30m"</div>
                  </div>
                  
                  <div class="col-md-6 mb-3">
                    <label for="genero" class="form-label">Género <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="genero" name="genero" required 
                           placeholder="Ej: Acción, Comedia, Drama"
                           value="<%= request.getParameter("genero") != null ? request.getParameter("genero") : "" %>">
                  </div>
                  
                  <div class="col-md-6 mb-3">
                    <label for="clasificacion" class="form-label">Clasificación <span class="text-danger">*</span></label>
                    <select class="form-select" id="clasificacion" name="clasificacion" required>
                      <option value="">Selecciona una clasificación</option>
                      <option value="G" <%= "G".equals(request.getParameter("clasificacion")) ? "selected" : "" %>>G - Todo público</option>
                      <option value="PG" <%= "PG".equals(request.getParameter("clasificacion")) ? "selected" : "" %>>PG - Guía paternal sugerida</option>
                      <option value="PG-13" <%= "PG-13".equals(request.getParameter("clasificacion")) || request.getParameter("clasificacion") == null ? "selected" : "" %>>PG-13 - Mayores de 13 años</option>
                      <option value="R" <%= "R".equals(request.getParameter("clasificacion")) ? "selected" : "" %>>R - Mayores de 17 años</option>
                      <option value="NC-17" <%= "NC-17".equals(request.getParameter("clasificacion")) ? "selected" : "" %>>NC-17 - Solo adultos</option>
                      <option value="A" <%= "A".equals(request.getParameter("clasificacion")) ? "selected" : "" %>>A - Solo adultos</option>
                    </select>
                  </div>
                </div>
                
                <div class="d-flex justify-content-between mt-4">
                  <a href="frmListadoPeliculas.jsp" class="btn btn-outline-secondary">
                    <i class="fa-solid fa-arrow-left me-2"></i>Volver al Catálogo
                  </a>
                  <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-save me-2"></i>Guardar Película
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </main>

    <footer class="bg-light py-3 mt-5">
      <div class="container text-center small text-muted">© 2025 Cine Prototype</div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function validarFormulario() {
            const horas = parseInt(document.getElementById('horas').value) || 0;
            const minutos = parseInt(document.getElementById('minutos').value) || 0;
            
            if (horas === 0 && minutos === 0) {
                alert('❌ La duración debe ser mayor a 0. Ingresa al menos horas o minutos.');
                return false;
            }
            
            if (minutos >= 60) {
                alert('❌ Los minutos no pueden ser 60 o más. Usa las horas para valores mayores.');
                return false;
            }
            
            return true;
        }
        
        // Validación en tiempo real para minutos
        document.getElementById('minutos').addEventListener('change', function() {
            if (this.value >= 60) {
                alert('⚠️ Los minutos no pueden ser 60 o más. Se ajustará automáticamente.');
                this.value = 59;
            }
        });
    </script>
  </body>
</html>