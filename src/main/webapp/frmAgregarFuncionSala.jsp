<%@page import="java.time.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.FuncionDAO, dao.PeliculaDAO, dao.SalaDAO, entity.Funcion, entity.Pelicula, entity.Sala, java.util.List, java.time.LocalDate, java.time.LocalTime, java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agregar Función Sala - Cine Prototype</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
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
        .alert {
            animation: fadeIn 0.5s;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .debug-panel {
            background: #f8f9fa;
            border-left: 4px solid #dc3545;
            padding: 15px;
            margin: 15px 0;
            font-size: 12px;
        }
    </style>
</head>

<body class="bg-light">
    <%
    // PROCESAR EL FORMULARIO
    boolean success = false;
    String errorMessage = "";
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Obtener parámetros del formulario
            String fechaStr = request.getParameter("fecha");
            String horasStr = request.getParameter("horas");
            String minutosStr = request.getParameter("minutos");
            String idPeliculaStr = request.getParameter("idPelicula");
            String idSalaStr = request.getParameter("idSala");
           
            // Validar que todos los campos estén presentes
            if (fechaStr != null && !fechaStr.trim().isEmpty() &&
                horasStr != null && !horasStr.trim().isEmpty() &&
                minutosStr != null && !minutosStr.trim().isEmpty() &&
                idPeliculaStr != null && !idPeliculaStr.trim().isEmpty() &&
                idSalaStr != null && !idSalaStr.trim().isEmpty()) {
                
                // Convertir a tipos correctos
                LocalDate fecha = LocalDate.parse(fechaStr);
                
                int horas = Integer.parseInt(horasStr);
                int minutos = Integer.parseInt(minutosStr);
                
                // Validar rangos
                if (horas < 0 || horas > 23) {
                    throw new IllegalArgumentException("Las horas deben estar entre 0 y 23");
                }
                if (minutos < 0 || minutos > 59) {
                    throw new IllegalArgumentException("Los minutos deben estar entre 0 y 59");
                }
                
                // Crear LocalTime
                LocalTime horaInicio = LocalTime.of(horas, minutos);
                
                // CREAR Y GUARDAR LA FUNCIÓN
                Funcion funcion = new Funcion();
                funcion.setFecha(fecha);
                funcion.setHoraInicio(horaInicio);
                funcion.setIdPelicula(Integer.parseInt(idPeliculaStr));
                funcion.setIdSala(Integer.parseInt(idSalaStr));

                FuncionDAO funcionDAO = new FuncionDAO();
                funcionDAO.insertarFuncion(funcion);
                
                success = true;
                
                out.println("<div class='alert alert-success alert-dismissible fade show' role='alert'>");
                out.println("<i class='fa-solid fa-check-circle me-2'></i>");
                out.println("<strong>¡Función creada exitosamente!</strong><br>");
                out.println("Fecha: " + fecha + " | Hora: " + horaInicio.toString());
                out.println("<button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>");
                out.println("</div>");
                
            } else {
                errorMessage = "Todos los campos son obligatorios";
            }
            
        } catch (DateTimeException e) {
            errorMessage = "Formato de fecha u hora inválido: " + e.getMessage();
            e.printStackTrace();
        } catch (NumberFormatException e) {
            errorMessage = "Horas y minutos deben ser números válidos: " + e.getMessage();
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            errorMessage = e.getMessage();
            e.printStackTrace();
        } catch (Exception e) {
            errorMessage = "Error al procesar la función: " + e.getMessage();
            e.printStackTrace();
        }
        
        if (!errorMessage.isEmpty()) {
            out.println("<div class='alert alert-danger alert-dismissible fade show' role='alert'>");
            out.println("<i class='fa-solid fa-triangle-exclamation me-2'></i>");
            out.println("<strong>Error:</strong> " + errorMessage);
            out.println("<button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>");
            out.println("</div>");
        }
    }
    %>

    <!-- Navbar -->
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
            <li class="nav-item"><a class="nav-link" href="frmMenu.jsp"><i class="fa-solid fa-home me-1"></i>Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="frmSeleccionarPelicula.jsp"><i class="fa-solid fa-ticket me-1"></i>Boletos</a></li>
                    <li class="nav-item"><a class="nav-link" href="frmSeleccionarComida.jsp"><i class="fa-solid fa-utensils me-1"></i>Comida</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link active dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fa-solid fa-sliders me-1"></i>Administrar
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="frmListadoPeliculas.jsp"><i class="fa-solid fa-film me-2"></i>Películas</a></li>
                            <li><a class="dropdown-item active" href="frmListadoProducto.jsp"><i class="fa-solid fa-pizza-slice me-2"></i>Productos</a></li>
                            <li><a class="dropdown-item" href="frmSeleccionarFuncion.jsp"><i class="fa-solid fa-calendar me-2"></i>Funciones</a></li>
                            <li><a class="dropdown-item" href="frmListadoSalas.jsp"><i class="fa-solid fa-couch me-2"></i>Salas</a></li>
                        </ul>
                    </li>
          </ul>
        </div>
      </div>
    </nav>

    <main class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-5">
                        <h2 class="text-center section-title">Agregar Función Sala</h2>

                        <form method="post" action="frmAgregarFuncionSala.jsp">
                            <!-- Fecha -->
                            <div class="mb-4">
                                <label for="fecha" class="form-label fw-bold">Fecha</label>
                                <input type="date" id="fecha" name="fecha" class="form-control" 
                                       value="<%= LocalDate.now() %>" 
                                       min="<%= LocalDate.now() %>"
                                       max="<%= LocalDate.now().plusMonths(3) %>" 
                                       required>
                                <div class="form-text">
                                    <i class="fa-solid fa-calendar me-1"></i>
                                    Seleccione una fecha entre hoy y <%= LocalDate.now().plusMonths(3).format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>
                                </div>
                            </div>

                            <!-- Selección de Hora -->
                            <div class="mb-4">
                                <label class="form-label fw-bold">Hora de Inicio</label>
                                <div class="row g-2">
                                    <div class="col-md-6">
                                        <label for="horas" class="form-label small text-muted">Horas (0-23)</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fa-solid fa-clock"></i></span>
                                            <input type="number" class="form-control" id="horas" name="horas"
                                                min="0" max="23" value="20" required>
                                            <span class="input-group-text">horas</span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="minutos" class="form-label small text-muted">Minutos (0-59)</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fa-solid fa-stopwatch"></i></span>
                                            <input type="number" class="form-control" id="minutos" name="minutos"
                                                min="0" max="59" value="30" required>
                                            <span class="input-group-text">min</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-text mt-2">
                                    <i class="fa-solid fa-circle-info me-1"></i>
                                    Ejemplo: 20 horas y 30 minutos se guardará como "20:30"
                                </div>
                            </div>

                            <!-- Selección de Sala -->
                            <div class="mb-4">
                                <label for="sala" class="form-label fw-bold">Sala</label>
                                <select id="sala" name="idSala" class="form-select" required>
                                    <option value="">-- Seleccionar Sala --</option>
                                    <% 
                                    SalaDAO salaDao = new SalaDAO(); 
                                    List<Sala> salas = salaDao.getSalas();
                                    System.out.println("DEBUG: Salas encontradas: " + salas.size());
                                    for (Sala sala : salas) {
                                    %>
                                    <option value="<%= sala.getIdSala() %>">
                                        Sala <%= sala.getNumeroSala() %> (Capacidad: <%= sala.getCapacidad() %>)
                                    </option>
                                    <% } %>
                                </select>
                            </div>

                            <!-- Selección de Película -->
                            <div class="mb-4">
                                <label for="pelicula" class="form-label fw-bold">Película</label>
                                <select id="pelicula" name="idPelicula" class="form-select" required>
                                    <option value="">-- Seleccionar Película --</option>
                                    <% 
                                    PeliculaDAO peliculaDAO = new PeliculaDAO(); 
                                    List<Pelicula> peliculas = peliculaDAO.getPeliculas();
                                    System.out.println("DEBUG: Películas encontradas: " + peliculas.size());
                                    for (Pelicula pelicula : peliculas) {
                                        Duration duracion = pelicula.getDuracion();
                                        long horas = duracion.toHours();
                                        long minutos = duracion.toMinutesPart();
                                        String duracionStr = horas + "h " + minutos + "m";
                                    %>
                                    <option value="<%= pelicula.getIdPelicula() %>">
                                        <%= pelicula.getTitulo() %> - <%= pelicula.getGenero() %> 
                                        (<%= duracionStr %>, <%= pelicula.getClasificacion() %>)
                                    </option>
                                    <% } %>
                                </select>
                            </div>

                            <!-- Botones -->
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="frmListadoPeliculas.jsp" class="btn btn-outline-secondary me-md-2">
                                    <i class="fa-solid fa-arrow-left me-2"></i>Volver
                                </a>
                                <button type="submit" class="btn btn-success btn-lg">
                                    <i class="fa-solid fa-plus me-2"></i>Agregar Función
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Información de la función creada -->
                <% if (success) { 
                    String fechaParam = request.getParameter("fecha");
                    String horasParam = request.getParameter("horas");
                    String minutosParam = request.getParameter("minutos");
                    String idSalaParam = request.getParameter("idSala");
                    String idPeliculaParam = request.getParameter("idPelicula");
                %>
                <div class="card shadow-sm border-success mt-4">
                    <div class="card-header bg-success text-white">
                        <i class="fa-solid fa-clipboard-check me-2"></i>Resumen de la Función
                    </div>
                    <div class="card-body">
                        <h5 class="card-title">Detalles de la función programada:</h5>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item">
                                <strong>Fecha:</strong> <%= fechaParam != null ? fechaParam : "N/A" %>
                            </li>
                            <li class="list-group-item">
                                <strong>Hora:</strong> 
                                <%= horasParam != null ? horasParam : "N/A" %>:<%= minutosParam != null ? minutosParam : "N/A" %>
                            </li>
                            <li class="list-group-item">
                                <strong>Sala:</strong> 
                                <% 
                                if (idSalaParam != null && !idSalaParam.isEmpty()) {
                                    try {
                                        int salaId = Integer.parseInt(idSalaParam);
                                        Sala sala = salaDao.getSalaPorId(salaId);
                                        if (sala != null) {
                                            out.print("Sala " + sala.getNumeroSala());
                                        } else {
                                            out.print("Sala no encontrada (ID: " + salaId + ")");
                                        }
                                    } catch (NumberFormatException e) {
                                        out.print("ID de sala inválido");
                                    }
                                } else {
                                    out.print("No especificada");
                                }
                                %>
                            </li>
                            <li class="list-group-item">
                                <strong>Película:</strong> 
                                <% 
                                if (idPeliculaParam != null && !idPeliculaParam.isEmpty()) {
                                    try {
                                        int peliculaId = Integer.parseInt(idPeliculaParam);
                                        Pelicula pelicula = peliculaDAO.getPeliculaPorId(peliculaId);
                                        if (pelicula != null) {
                                            out.print(pelicula.getTitulo());
                                        } else {
                                            out.print("Película no encontrada (ID: " + peliculaId + ")");
                                        }
                                    } catch (NumberFormatException e) {
                                        out.print("ID de película inválido");
                                    }
                                } else {
                                    out.print("No especificada");
                                }
                                %>
                            </li>
                        </ul>
                        <div class="text-center mt-3">
                            <a href="frmAgregarFuncionSala.jsp" class="btn btn-primary">
                                <i class="fa-solid fa-plus me-2"></i>Agregar Otra Función
                            </a>
                            <a href="frmSeleccionarPelicula.jsp" class="btn btn-success ms-2">
                                <i class="fa-solid fa-ticket me-2"></i>Ver Cartelera
                            </a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </main>

    <!-- Footer -->
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