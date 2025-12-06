<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.List"%>
<%@page import="dao.BoletoDAO"%>
<%@page import="entity.Boleto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comprobante de Boletos - Cine</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #0066cc 0%, #003366 100%);
            color: white;
            padding: 40px 0;
        }
        .ticket-card {
            border: 3px solid #0066cc;
            border-radius: 15px;
            background: white;
            max-width: 800px;
            margin: 0 auto;
        }
        .ticket-header {
            background: #0066cc;
            color: white;
            padding: 20px;
            text-align: center;
            border-radius: 12px 12px 0 0;
        }
        .ticket-body {
            padding: 30px;
        }
        .ticket-code {
            font-family: 'Courier New', monospace;
            font-size: 2rem;
            font-weight: bold;
            letter-spacing: 3px;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border: 2px dashed #0066cc;
            text-align: center;
            margin: 20px 0;
        }
        .seat-badge {
            background: #28a745;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
            margin: 5px;
            display: inline-block;
            font-size: 1.1rem;
        }
        .boleto-info {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
            border-left: 4px solid #0066cc;
        }
        .qr-container {
            text-align: center;
            padding: 20px;
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            margin: 20px 0;
        }
        .print-ticket {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
            padding: 15px 40px;
            border-radius: 25px;
            font-weight: bold;
            font-size: 1.2rem;
        }
        .ticket-footer {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 0 0 12px 12px;
            border-top: 2px solid #dee2e6;
        }
        .ticket-details {
            border-bottom: 2px solid #0066cc;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }
        .ticket-type {
            font-size: 0.9rem;
            padding: 3px 10px;
            border-radius: 12px;
            margin-right: 5px;
        }
        .instructions {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 15px;
            margin: 15px 0;
        }
    </style>
</head>
<body>
    <%
    // Obtener ID de transacción desde parámetro o sesión
    String idTransaccionStr = request.getParameter("idTransaccion");
    if (idTransaccionStr == null || idTransaccionStr.trim().isEmpty()) {
        // Intentar obtener de la sesión
        Integer idTransaccionSession = (Integer) session.getAttribute("idTransaccion");
        if (idTransaccionSession != null) {
            idTransaccionStr = idTransaccionSession.toString();
        } else {
            // No hay transacción, redirigir
            response.sendRedirect("frmSeleccionarPelicula.jsp");
            return;
        }
    }
    
    int idTransaccion = Integer.parseInt(idTransaccionStr);
    
    // Obtener boletos de esta transacción
    BoletoDAO boletoDAO = new BoletoDAO();
    List<Boleto> boletos = boletoDAO.getBoletosPorTransaccion(idTransaccion);
    
    if (boletos == null || boletos.isEmpty()) {
        response.sendRedirect("frmSeleccionarPelicula.jsp");
        return;
    }
    
    // Obtener información del primer boleto (todos son de la misma función)
    Boleto primerBoleto = boletos.get(0);
    
    // Obtener información de la función (necesitarás crear este método en BoletoDAO)
    // O puedes obtenerla de la sesión si la guardaste
    String tituloPelicula = (String) session.getAttribute("tituloPelicula");
    String fechaFuncion = (String) session.getAttribute("fechaFuncion");
    String horaFuncion = (String) session.getAttribute("horaFuncion");
    Integer numeroSala = (Integer) session.getAttribute("numeroSala");
    
    // Si no hay en sesión, usa valores por defecto
    if (tituloPelicula == null) tituloPelicula = "Película";
    if (fechaFuncion == null) fechaFuncion = "Fecha no disponible";
    if (horaFuncion == null) horaFuncion = "Hora no disponible";
    if (numeroSala == null) numeroSala = 0;
    
    // Generar código único para este ticket
    String ticketCode = "CINE-" + idTransaccion + "-" + System.currentTimeMillis();
    
    // Calcular total
    BigDecimal total = BigDecimal.ZERO;
    for (Boleto boleto : boletos) {
        total = total.add(boleto.getPrecio());
    }
    
    // Contar por tipo
    int countGeneral = 0;
    int countNino = 0;
    int countEstudiante = 0;
    for (Boleto boleto : boletos) {
        if ("general".equals(boleto.getTipoBoleto())) {
            countGeneral++;
        } else if ("niño".equals(boleto.getTipoBoleto())) {
            countNino++;
        } else if ("estudiante".equals(boleto.getTipoBoleto())) {
            countEstudiante++;
        }
    }
    %>
    
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="frmMenu.jsp">
                <i class="fa-solid fa-film me-2"></i>Cine
            </a>
            <div class="navbar-text text-white">
                <i class="fa-solid fa-ticket me-1"></i>Comprobante de Boletos
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <header class="hero-section">
        <div class="container text-center">
            <h1 class="display-5 fw-bold mb-3">🎟️ Comprobante de Compra</h1>
            <p class="lead mb-0">Presenta este ticket para acceder a la función</p>
        </div>
    </header>

    <main class="container my-5">
        <div class="ticket-card shadow-lg">
            <!-- Encabezado del Ticket -->
            <div class="ticket-header">
                <h2 class="mb-0"><i class="fa-solid fa-clapperboard me-2"></i>CINE TICKET</h2>
                <p class="mb-0">Transacción #<%= idTransaccion %></p>
            </div>
            
            <!-- Cuerpo del Ticket -->
            <div class="ticket-body">
                <!-- Código de verificación -->
                <div class="ticket-code">
                    <%= ticketCode %>
                </div>
                
                <!-- Detalles de la función -->
                <div class="ticket-details">
                    <h4><i class="fa-solid fa-film me-2"></i><%= tituloPelicula %></h4>
                    <div class="row mt-3">
                        <div class="col-md-4">
                            <p><i class="fa-solid fa-calendar me-2 text-primary"></i><strong>Fecha:</strong> <%= fechaFuncion %></p>
                        </div>
                        <div class="col-md-4">
                            <p><i class="fa-solid fa-clock me-2 text-warning"></i><strong>Hora:</strong> <%= horaFuncion %></p>
                        </div>
                        <div class="col-md-4">
                            <p><i class="fa-solid fa-door-closed me-2 text-success"></i><strong>Sala:</strong> <%= numeroSala %></p>
                        </div>
                    </div>
                </div>
                
                <!-- Detalles de los boletos -->
                <div class="mb-4">
                    <h5><i class="fa-solid fa-ticket me-2"></i>Detalle de Boletos</h5>
                    
                    <!-- Resumen por tipo -->
                    <div class="row mb-3">
                        <% if (countGeneral > 0) { %>
                        <div class="col-md-4">
                            <div class="boleto-info">
                                <span class="badge bg-primary ticket-type">General</span>
                                <strong><%= countGeneral %> boleto(s)</strong>
                                <p class="mb-0">$8.50 c/u</p>
                            </div>
                        </div>
                        <% } %>
                        
                        <% if (countNino > 0) { %>
                        <div class="col-md-4">
                            <div class="boleto-info">
                                <span class="badge bg-warning ticket-type">Niño</span>
                                <strong><%= countNino %> boleto(s)</strong>
                                <p class="mb-0">$5.50 c/u</p>
                            </div>
                        </div>
                        <% } %>
                        
                        <% if (countEstudiante > 0) { %>
                        <div class="col-md-4">
                            <div class="boleto-info">
                                <span class="badge bg-info ticket-type">Estudiante</span>
                                <strong><%= countEstudiante %> boleto(s)</strong>
                                <p class="mb-0">$6.50 c/u</p>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    
                    <!-- Asientos asignados -->
                    <h6><i class="fa-solid fa-chair me-2"></i>Asientos Asignados:</h6>
                    <div class="d-flex flex-wrap mb-3">
                        <% 
                        for (Boleto boleto : boletos) {
                            if (boleto.getAsiento() != null && !boleto.getAsiento().isEmpty()) {
                        %>
                        <span class="seat-badge">
                            <%= boleto.getAsiento() %>
                            <small class="ms-1">
                                <% 
                                String tipo = boleto.getTipoBoleto();
                                if ("general".equals(tipo)) {
                                    out.print("(G)");
                                } else if ("niño".equals(tipo)) {
                                    out.print("(N)");
                                } else if ("estudiante".equals(tipo)) {
                                    out.print("(E)");
                                }
                                %>
                            </small>
                        </span>
                        <% 
                            }
                        } 
                        %>
                    </div>
                </div>
                    
                <!-- Total -->
                <div class="text-center mt-4">
                    <h4 class="mb-3">Total Pagado</h4>
                    <h1 class="text-success display-4">$<%= String.format("%.2f", total) %></h1>
                    <p class="text-muted">
                        <i class="fa-solid fa-receipt me-1"></i>
                        <%= boletos.size() %> boleto(s) en total
                    </p>
                </div>
            </div>
        
        <!-- Botones de acción -->
        <div class="text-center mt-5">
            <a href="frmMenu.jsp" class="btn btn-outline-primary">
                <i class="fa-solid fa-home me-2"></i>Volver al Inicio
            </a>
            <a href="frmSeleccionarPelicula.jsp" class="btn btn-success ms-3">
                <i class="fa-solid fa-ticket me-2"></i>Comprar Más Boletos
            </a>
        </div>
        
        <!-- Nota importante -->
        <div class="alert alert-warning mt-4">
            <div class="d-flex">
                <div class="me-3">
                    <i class="fa-solid fa-exclamation-triangle fa-2x"></i>
                </div>
                <div>
                    <h6 class="alert-heading">Importante para el acceso:</h6>
                    <p class="mb-0">
                        Este comprobante contiene el código <strong><%= ticketCode %></strong> que será verificado en la entrada.
                        Cada boleto tiene asignado un asiento específico que no puede ser cambiado.
                        Para boletos de niño o estudiante, se debe presentar identificación válida.
                    </p>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0">
                <i class="fa-solid fa-film me-2"></i>Sistema de Cine
            </p>
        </div>
    </footer>
    
</body>
</html>