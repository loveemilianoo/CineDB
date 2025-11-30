<%@page import="dao.FuncionDAO"%>
<%@page import="entity.Funcion"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seleccionar Función - Cine</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 0;
        }
        .funcion-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            background: white;
            overflow: hidden;
        }
        .funcion-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .funcion-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .funcion-body {
            padding: 25px;
        }
        .sala-badge {
            background: #28a745;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
        }
        .time-display {
            font-size: 1.5rem;
            font-weight: bold;
            color: #333;
        }
        .date-display {
            color: #666;
            font-size: 0.9rem;
        }
        .btn-seleccionar {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        .btn-seleccionar:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        .empty-state i {
            font-size: 4rem;
            color: #6c757d;
            margin-bottom: 20px;
        }
        .movie-title {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .movie-subtitle {
            color: #6c757d;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="frmMenu.jsp">
                <i class="fa-solid fa-film me-2"></i>Cine
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="frmMenu.jsp">
                            <i class="fa-solid fa-home me-1"></i>Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="frmSeleccionarPelicula.jsp">
                            <i class="fa-solid fa-ticket me-1"></i>Boletos
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <header class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold mb-3">🎭 Selecciona tu Función</h1>
            <p class="lead mb-0">Elige la fecha y hora que mejor se adapte a tu agenda</p>
        </div>
    </header>

    <main class="container my-5">
        <%
            String idPeliculaStr = request.getParameter("idPelicula");
            String tituloPelicula = request.getParameter("tituloPelicula");
            
            if (idPeliculaStr != null) {
                int idPelicula = Integer.parseInt(idPeliculaStr);
                FuncionDAO funcionDAO = new FuncionDAO();
                List<Funcion> funciones = funcionDAO.getFuncionesPelicula(idPelicula);
        %>

        <!-- Movie Info -->
        <div class="row mb-5">
            <div class="col-12 text-center">
                <h2 class="movie-title"><%= tituloPelicula %></h2>
                <p class="movie-subtitle">
                    <i class="fa-solid fa-calendar me-1"></i>
                    <%= funciones.size() %> función(es) disponible(s)
                </p>
            </div>
        </div>

        <!-- Functions Grid -->
        <% if (funciones.isEmpty()) { %>
            <div class="empty-state">
                <i class="fa-solid fa-calendar-times"></i>
                <h3 class="text-muted mb-3">No hay funciones disponibles</h3>
                <p class="text-muted mb-4">Lo sentimos, no hay funciones programadas para esta película en este momento.</p>
                <a href="frmSeleccionarPelicula.jsp" class="btn btn-primary btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>Volver a Películas
                </a>
            </div>
        <% } else { %>
            <div class="row g-4">
                <% 
                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, d 'de' MMMM", new java.util.Locale("es"));
                for (Funcion funcion : funciones) { 
                    java.time.Duration horaInicio = funcion.getHoraInicio();
                    long horas = horaInicio.toHours();
                    long minutos = horaInicio.toMinutesPart();
                    String horaFormateada = String.format("%02d:%02d", horas, minutos);
                %>
                    <div class="col-md-6 col-lg-4">
                        <div class="funcion-card h-100">
                            <div class="funcion-header">
                                <span class="sala-badge">
                                    <i class="fa-solid fa-door-open me-1"></i>Sala <%= funcion.getSala().getNumeroSala() %>
                                </span>
                            </div>
                            <div class="funcion-body text-center">
                                <div class="time-display mb-2">
                                    <i class="fa-solid fa-clock me-2"></i><%= horaFormateada %>
                                </div>
                                <div class="date-display mb-3">
                                    <i class="fa-solid fa-calendar me-1"></i>
                                    <%= funcion.getFecha().format(dateFormatter) %>
                                </div>
                                <div class="mb-3">
                                    <small class="text-muted">
                                        <i class="fa-solid fa-users me-1"></i>
                                        Capacidad: <%= funcion.getSala().getCapacidad() %> asientos
                                    </small>
                                </div>
                                
                                <form action="frmSeleccionarAsiento.jsp" method="GET">
                                    <input type="hidden" name="idFuncion" value="<%= funcion.getIdFuncion() %>">
                                    <input type="hidden" name="idPelicula" value="<%= idPelicula %>">
                                    <input type="hidden" name="tituloPelicula" value="<%= tituloPelicula %>">
                                    <input type="hidden" name="fechaFuncion" value="<%= funcion.getFecha() %>">
                                    <input type="hidden" name="horaFuncion" value="<%= horaFormateada %>">
                                    <input type="hidden" name="numeroSala" value="<%= funcion.getSala().getNumeroSala() %>">
                                    <button type="submit" class="btn btn-seleccionar w-100">
                                        <i class="fa-solid fa-armchair me-2"></i>Seleccionar Asientos
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } 
        } else { %>
            <!-- Error State -->
            <div class="empty-state">
                <i class="fa-solid fa-exclamation-triangle"></i>
                <h3 class="text-danger mb-3">Error</h3>
                <p class="text-muted mb-4">No se especificó la película. Por favor, selecciona una película primero.</p>
                <a href="frmSeleccionarPelicula.jsp" class="btn btn-primary btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>Volver a Películas
                </a>
            </div>
        <% } %>

        <!-- Back Button -->
        <div class="row mt-5">
            <div class="col-12 text-center">
                <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-secondary">
                    <i class="fa-solid fa-arrow-left me-2"></i>Volver a Películas
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0">
                <i class="fa-solid fa-film me-2"></i>Sistema de Cine &copy; 2024
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>