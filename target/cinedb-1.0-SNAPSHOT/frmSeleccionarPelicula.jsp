<%@page import="entity.Sala"%>
<%@page import="dao.SalaDAO"%>
<%@page import="dao.FuncionDAO"%>
<%@page import="dao.PeliculaDAO"%>
<%@page import="entity.Funcion"%>
<%@page import="entity.Pelicula"%>
<%@page import="java.util.List"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Seleccionar Función - Cine Prototype</title>
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
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .function-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            transition: all 0.3s;
        }
        .function-card:hover {
            border-color: #667eea;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.1);
        }
        .btn-select-time {
            width: 120px;
            margin: 5px;
        }
        .date-header {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <%
    // Obtener parámetros
    String idPeliculaStr = request.getParameter("idPelicula");
    String tituloPelicula = request.getParameter("tituloPelicula");
    
    if (idPeliculaStr == null || tituloPelicula == null) {
        response.sendRedirect("frmSeleccionarPelicula.jsp");
        return;
    }
    
    int idPelicula = Integer.parseInt(idPeliculaStr);
    
    // Obtener información de la película
    PeliculaDAO peliculaDAO = new PeliculaDAO();
    Pelicula pelicula = peliculaDAO.getPeliculaPorId(idPelicula);
    
    // Obtener funciones para esta película
    FuncionDAO funcionDAO = new FuncionDAO();
    List<Funcion> funciones = funcionDAO.getFuncionesPorPelicula(idPelicula);
    %>
    
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
                    <li class="nav-item"><a class="nav-link active" href="frmSeleccionarPelicula.jsp">Boletos</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Comida</a></li>
                    <li class="nav-item"><a class="nav-link" href="frmListadoPeliculas.jsp">Administrar</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <header class="hero-section text-center position-relative" 
            style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
        <div class="container position-relative" style="z-index: 1;">
            <h1 class="display-5 fw-bold mb-3">Seleccionar Función</h1>
            <p class="lead mb-0">Película: <%= tituloPelicula %></p>
        </div>
    </header>

    <main class="container my-5">
        <!-- Información de la película -->
        <div class="card mb-4 shadow-sm">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h4 class="card-title mb-3"><%= pelicula != null ? pelicula.getTitulo() : tituloPelicula %></h4>
                        <div class="row">
                            <div class="col-md-4">
                                <p class="mb-2">
                                    <i class="fa-solid fa-clock me-2 text-warning"></i>
                                    <strong>Duración:</strong> 
                                    <% 
                                    if (pelicula != null) {
                                        java.time.Duration duracion = pelicula.getDuracion();
                                        long horas = duracion.toHours();
                                        long minutos = duracion.toMinutesPart();
                                        out.print(horas + "h " + minutos + "m");
                                    }
                                    %>
                                </p>
                            </div>
                            <div class="col-md-4">
                                <p class="mb-2">
                                    <i class="fa-solid fa-tags me-2 text-primary"></i>
                                    <strong>Género:</strong> <%= pelicula != null ? pelicula.getGenero() : "" %>
                                </p>
                            </div>
                            <div class="col-md-4">
                                <p class="mb-2">
                                    <i class="fa-solid fa-certificate me-2 text-success"></i>
                                    <strong>Clasificación:</strong> 
                                    <span class="badge bg-<%= 
                                        pelicula != null ? 
                                            (pelicula.getClasificacion().equals("G") ? "success" : 
                                             pelicula.getClasificacion().equals("PG") ? "info" : 
                                             pelicula.getClasificacion().equals("PG-13") ? "warning" : 
                                             pelicula.getClasificacion().equals("R") ? "danger" : "secondary") 
                                        : "secondary"
                                    %>">
                                        <%= pelicula != null ? pelicula.getClasificacion() : "" %>
                                    </span>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-secondary">
                            <i class="fa-solid fa-arrow-left me-2"></i>Cambiar Película
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Funciones disponibles -->
        <div class="row">
            <div class="col-12">
                <h3 class="section-title text-center">Funciones Disponibles</h3>
                
                <% 
                if (funciones.isEmpty()) {
                %>
                <div class="alert alert-info text-center">
                    <i class="fa-solid fa-calendar-times fa-2x mb-3"></i>
                    <h4>No hay funciones disponibles</h4>
                    <p class="mb-3">No hay funciones programadas para esta película.</p>
                    <a href="frmAgregarFuncionSala.jsp?idPelicula=<%= idPelicula %>&titulo=<%= java.net.URLEncoder.encode(tituloPelicula, "UTF-8") %>" 
                       class="btn btn-primary">
                        <i class="fa-solid fa-plus me-2"></i>Agregar Función
                    </a>
                </div>
                <% 
                } else {
                    // Agrupar funciones por fecha
                    java.util.Map<LocalDate, java.util.List<Funcion>> funcionesPorFecha = new java.util.LinkedHashMap<>();
                    
                    for (Funcion funcion : funciones) {
                        LocalDate fecha = funcion.getFecha();
                        funcionesPorFecha.computeIfAbsent(fecha, k -> new java.util.ArrayList<>()).add(funcion);
                    }
                    
                    // Mostrar funciones agrupadas por fecha
                    for (java.util.Map.Entry<LocalDate, java.util.List<Funcion>> entry : funcionesPorFecha.entrySet()) {
                        LocalDate fecha = entry.getKey();
                        List<Funcion> funcionesDia = entry.getValue();
                        
                        // Formatear fecha en español
                        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, d 'de' MMMM", new java.util.Locale("es"));
                        String fechaFormateada = fecha.format(dateFormatter);
                %>
                <div class="card mb-4">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">
                            <i class="fa-solid fa-calendar-day me-2"></i>
                            <%= fechaFormateada %>
                            <span class="badge bg-primary ms-2"><%= funcionesDia.size() %> funciones</span>
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <% 
                            for (Funcion funcion : funcionesDia) {
                                // Obtener hora de inicio (es LocalTime, no Duration)
                                LocalTime horaInicio = funcion.getHoraInicio();
                                int horas = horaInicio.getHour();
                                int minutos = horaInicio.getMinute();
                                String horaFormateada = String.format("%02d:%02d", horas, minutos);
                                
                                // Obtener información de la sala
                                SalaDAO salaDAO = new SalaDAO();
                                Sala sala = salaDAO.getSalaPorId(funcion.getIdSala());
                            %>
                            <div class="col-md-6 col-lg-4 mb-3">
                                <div class="card function-card h-100">
                                    <div class="card-body">
                                        <h6 class="card-title">
                                            <i class="fa-solid fa-clock me-2 text-primary"></i>
                                            <%= horaFormateada %>
                                        </h6>
                                        <p class="card-text">
                                            <i class="fa-solid fa-door-closed me-2 text-secondary"></i>
                                            Sala: <%= sala != null ? "Sala " + sala.getNumeroSala() : "N/A" %>
                                        </p>
                                        <p class="card-text">
                                            <i class="fa-solid fa-users me-2 text-success"></i>
                                            Capacidad: <%= sala != null ? sala.getCapacidad() : "N/A" %>
                                        </p>
                                        <div class="d-grid">
                                            <form action="frmSeleccionarAsientos.jsp" method="GET">
                                                <input type="hidden" name="idFuncion" value="<%= funcion.getIdFuncion() %>">
                                                <input type="hidden" name="idPelicula" value="<%= idPelicula %>">
                                                <input type="hidden" name="tituloPelicula" value="<%= tituloPelicula %>">
                                                <input type="hidden" name="horaFuncion" value="<%= horaFormateada %>">
                                                <input type="hidden" name="fechaFuncion" value="<%= fecha %>">
                                                <input type="hidden" name="idSala" value="<%= funcion.getIdSala() %>">
                                                <button type="submit" class="btn btn-primary btn-select-time w-100">
                                                    <i class="fa-solid fa-check me-1"></i> Seleccionar
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% 
                            }
                            %>
                        </div>
                    </div>
                </div>
                <% 
                    }
                }
                %>
            </div>
        </div>

        <!-- Acciones -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="bg-light p-4 rounded-3">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h5 class="mb-2">¿No encuentras un horario adecuado?</h5>
                            <p class="mb-0 text-muted">Puedes agregar nuevas funciones en el menú de Administración.</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-primary">
                                <i class="fa-solid fa-arrow-left me-2"></i>Volver a Películas
                            </a>
                            <a href="frmAgregarFuncionSala.jsp?idPelicula=<%= idPelicula %>&titulo=<%= java.net.URLEncoder.encode(tituloPelicula, "UTF-8") %>" 
                               class="btn btn-success ms-2">
                                <i class="fa-solid fa-plus me-2"></i>Agregar Función
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
            
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>