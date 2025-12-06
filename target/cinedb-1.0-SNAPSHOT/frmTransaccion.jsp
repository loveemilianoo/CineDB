<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transacción Exitosa - Cine</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 60px 0;
        }
        .success-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            background: white;
            overflow: hidden;
        }
        .success-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 25px;
            text-align: center;
        }
        .success-body {
            padding: 30px;
        }
        .success-icon {
            font-size: 5rem;
            color: #28a745;
        }
        .ticket-badge {
            background: #007bff;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 1.1rem;
        }
        .seat-badge {
            background: #6c757d;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            margin: 3px;
            display: inline-block;
            font-size: 0.9rem;
        }
        .confirmation-code {
            font-family: 'Courier New', monospace;
            font-size: 1.5rem;
            font-weight: bold;
            letter-spacing: 2px;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border: 2px dashed #28a745;
        }
        .btn-print {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: bold;
        }
        .transaction-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <%
    // Obtener datos de la compra desde sesión
    Boolean compraExitosa = (Boolean) session.getAttribute("compraExitosa");
    List<String> asientosAsignados = (List<String>) session.getAttribute("asientosAsignados");
    Integer cantidadComprada = (Integer) session.getAttribute("cantidadComprada");
    BigDecimal totalCompra = (BigDecimal) session.getAttribute("totalCompra");
    String tituloPelicula = (String) session.getAttribute("tituloPelicula");
    String fechaFuncion = (String) session.getAttribute("fechaFuncion");
    String horaFuncion = (String) session.getAttribute("horaFuncion");
    Integer numeroSala = (Integer) session.getAttribute("numeroSala");
    BigDecimal precioPorBoleto = (BigDecimal) session.getAttribute("precioPorBoleto");
    
    // Verificar si hay datos de compra
    if (compraExitosa == null || !compraExitosa) {
        response.sendRedirect("frmSeleccionarPelicula.jsp");
        return;
    }
    
    // Generar código de confirmación único
    String codigoConfirmacion = "CINE-" + System.currentTimeMillis();
    
    // Limpiar sesión después de mostrar
    session.removeAttribute("compraExitosa");
    session.removeAttribute("asientosAsignados");
    session.removeAttribute("cantidadComprada");
    session.removeAttribute("totalCompra");
    session.removeAttribute("idFuncion");
    session.removeAttribute("idPelicula");
    session.removeAttribute("tituloPelicula");
    session.removeAttribute("fechaFuncion");
    session.removeAttribute("horaFuncion");
    session.removeAttribute("numeroSala");
    session.removeAttribute("precioPorBoleto");
    %>
    
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="frmMenu.jsp">
                <i class="fa-solid fa-film me-2"></i>Cine
            </a>
        </div>
    </nav>

    <!-- Hero Section -->
    <header class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold mb-3">✅ Transacción Exitosa</h1>
            <p class="lead mb-0">Tu compra se ha procesado correctamente</p>
        </div>
    </header>

    <main class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="success-card">
                    <div class="success-header">
                        <div class="success-icon mb-3">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <h3 class="mb-0">¡Compra Realizada con Éxito!</h3>
                    </div>
                    <div class="success-body">
                        <!-- Resumen de la compra -->
                        <div class="text-center mb-4">
                            <span class="ticket-badge">
                                <i class="fa-solid fa-ticket me-1"></i>
                                <%= cantidadComprada %> Boleto(s) Comprado(s)
                            </span>
                        </div>
                        
                        <!-- Código de confirmación -->
                        <div class="text-center mb-5">
                            <h5 class="mb-3">Código de Confirmación</h5>
                            <div class="confirmation-code">
                                <%= codigoConfirmacion %>
                            </div>
                            <p class="text-muted mt-2">
                                <i class="fa-solid fa-info-circle me-1"></i>
                                Presenta este código en taquilla para reclamar tus boletos
                            </p>
                        </div>
                        
                        <!-- Detalles de la transacción -->
                        <div class="transaction-details">
                            <h5 class="mb-4"><i class="fa-solid fa-clipboard-list me-2"></i>Detalles de la Compra</h5>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong><i class="fa-solid fa-film me-2"></i>Película:</strong><br>
                                    <%= tituloPelicula %></p>
                                    
                                    <p><strong><i class="fa-solid fa-calendar me-2"></i>Fecha y Hora:</strong><br>
                                    <%= fechaFuncion %> - <%= horaFuncion %></p>
                                    
                                    <p><strong><i class="fa-solid fa-door-closed me-2"></i>Sala:</strong><br>
                                    Sala <%= numeroSala %></p>
                                </div>
                                
                                <div class="col-md-6">
                                    <p><strong><i class="fa-solid fa-ticket me-2"></i>Boletos:</strong><br>
                                    <%= cantidadComprada %> x $<%= precioPorBoleto %></p>
                                    
                                    <p><strong><i class="fa-solid fa-money-bill-wave me-2"></i>Total Pagado:</strong><br>
                                    <h4 class="text-success">$<%= totalCompra %></h4></p>
                                    
                                    <p><strong><i class="fa-solid fa-clock me-2"></i>Fecha de Compra:</strong><br>
                                    <%= new java.util.Date() %></p>
                                </div>
                            </div>
                            
                            <!-- Asientos asignados -->
                            <div class="mt-4">
                                <p class="mb-2"><strong><i class="fa-solid fa-chair me-2"></i>Asientos Asignados:</strong></p>
                                <div class="d-flex flex-wrap">
                                    <% 
                                    if (asientosAsignados != null) {
                                        for (String asiento : asientosAsignados) { 
                                    %>
                                    <span class="seat-badge"><%= asiento %></span>
                                    <% 
                                        }
                                    } 
                                    %>
                                </div>
                                <p class="text-muted mt-2 small">
                                    <i class="fa-solid fa-lightbulb me-1"></i>
                                    Los asientos fueron asignados automáticamente para optimizar tu experiencia.
                                </p>
                            </div>
                        </div>
                        
                        <!-- Instrucciones -->
                        <div class="alert alert-info mt-4">
                            <h6><i class="fa-solid fa-clipboard-check me-2"></i>Instrucciones Importantes:</h6>
                            <ul class="mb-0">
                                <li>Llega al cine 15 minutos antes de la función</li>
                                <li>Presenta tu código de confirmación en taquilla</li>
                                <li>Guarda este comprobante, no es reembolsable</li>
                                <li>Los asientos asignados no pueden cambiarse</li>
                            </ul>
                        </div>
                            
                            <a href="frmSeleccionarPelicula.jsp" class="btn btn-success">
                                <i class="fa-solid fa-ticket me-2"></