<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductoDAO"%>
<%@page import="entity.Producto"%>
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
        .ticket-type-badge {
            font-size: 0.8rem;
            padding: 3px 8px;
            border-radius: 12px;
            margin-right: 5px;
        }
        .ticket-summary {
            background: #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <%
    // Obtener datos de la compra desde sesión
    Boolean compraExitosa = (Boolean) session.getAttribute("compraExitosa");
    List<String> asientosAsignados = (List<String>) session.getAttribute("asientosAsignados");
    
    // Cantidades por tipo de boleto
    Integer cantidadGeneral = (Integer) session.getAttribute("cantidadGeneral");
    Integer cantidadNino = (Integer) session.getAttribute("cantidadNino");
    Integer cantidadEstudiante = (Integer) session.getAttribute("cantidadEstudiante");
    
    BigDecimal totalCompra = (BigDecimal) session.getAttribute("totalCompra");
    String tituloPelicula = (String) session.getAttribute("tituloPelicula");
    String fechaFuncion = (String) session.getAttribute("fechaFuncion");
    String horaFuncion = (String) session.getAttribute("horaFuncion");
    Integer numeroSala = (Integer) session.getAttribute("numeroSala");
    
    // Precios por tipo
    BigDecimal precioGeneral = (BigDecimal) session.getAttribute("precioGeneral");
    BigDecimal precioNino = (BigDecimal) session.getAttribute("precioNino");
    BigDecimal precioEstudiante = (BigDecimal) session.getAttribute("precioEstudiante");
    
    // Asegurar que las cantidades no sean null
    if (cantidadGeneral == null) cantidadGeneral = 0;
    if (cantidadNino == null) cantidadNino = 0;
    if (cantidadEstudiante == null) cantidadEstudiante = 0;
    
    // Calcular total de boletos
    int totalBoletos = cantidadGeneral + cantidadNino + cantidadEstudiante;
    
    // Verificar si hay datos de compra
    if (compraExitosa == null || !compraExitosa) {
        response.sendRedirect("frmSeleccionarPelicula.jsp");
        return;
    }
    
    // Generar código de confirmación único
    String codigoConfirmacion = "CINE-" + System.currentTimeMillis();
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
                                <%= totalBoletos %> Boleto(s) Comprado(s)
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
                                    <!-- Detalle por tipo de boleto -->
                                    <div class="ticket-summary">
                                        <% if (cantidadGeneral > 0) { %>
                                        <p class="mb-1">
                                            <span class="badge bg-primary ticket-type-badge">General</span>
                                            <%= cantidadGeneral %> x $<%= precioGeneral %> = $<%= precioGeneral.multiply(new BigDecimal(cantidadGeneral)) %>
                                        </p>
                                        <% } %>
                                        
                                        <% if (cantidadNino > 0) { %>
                                        <p class="mb-1">
                                            <span class="badge bg-warning ticket-type-badge">Niño</span>
                                            <%= cantidadNino %> x $<%= precioNino %> = $<%= precioNino.multiply(new BigDecimal(cantidadNino)) %>
                                        </p>
                                        <% } %>
                                        
                                        <% if (cantidadEstudiante > 0) { %>
                                        <p class="mb-1">
                                            <span class="badge bg-info ticket-type-badge">Estudiante</span>
                                            <%= cantidadEstudiante %> x $<%= precioEstudiante %> = $<%= precioEstudiante.multiply(new BigDecimal(cantidadEstudiante)) %>
                                        </p>
                                        <% } %>
                                    </div>
                                    
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

                        <!-- Productos Disponibles (Comida) - OPCIONAL -->
                        <div class="mt-5">
                            <h5 class="mb-4"><i class="fa-solid fa-burger me-2"></i>Complementa tu experiencia</h5>
                            <p class="text-muted mb-3">¡No te quedes con hambre! Estos son los productos disponibles en dulcería:</p>

                            <div class="row">
                                <% 
                                // Obtener productos directamente (sin Servlet)
                                ProductoDAO productoDAO = new ProductoDAO();
                                List<Producto> productos = productoDAO.getProductos();
                                
                                if (productos != null && !productos.isEmpty()) {
                                    // Mostrar solo productos con stock
                                    int productosConStock = 0;
                                    for (Producto prod : productos) {
                                        if (prod.getStock() > 0) {
                                            productosConStock++;
                                %>
                                <div class="col-md-6 mb-3">
                                    <div class="d-flex align-items-center p-3 border rounded bg-white">
                                        <div class="me-3 text-warning">
                                            <i class="fa-solid fa-utensils fa-2x"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <h6 class="mb-0"><%= prod.getNombre() %></h6>
                                            <small class="text-muted">Stock: <%= prod.getStock() %></small>
                                        </div>
                                        <div class="text-end">
                                            <span class="fw-bold text-success">$<%= prod.getPrecioVenta() %></span>
                                        </div>
                                    </div>
                                </div>
                                <%
                                        }
                                    }
                                    
                                    if (productosConStock == 0) {
                                %>
                                <div class="col-12">
                                    <div class="alert alert-light text-center">
                                        <i class="fa-solid fa-store-slash me-2"></i>No hay productos disponibles en este momento.
                                    </div>
                                </div>
                                <%
                                    }
                                } else {
                                %>
                                <div class="col-12">
                                    <div class="alert alert-light text-center">
                                        <i class="fa-solid fa-store-slash me-2"></i>No hay productos disponibles en este momento.
                                    </div>
                                </div>
                                <% } %>
                            </div>
                            
                            <!-- Botón para ir a comprar comida -->
                            <div class="text-center mt-3">
                                <a href="frmSeleccionarComida.jsp" class="btn btn-warning">
                                    <i class="fa-solid fa-cart-shopping me-2"></i>Comprar Comida y Bebidas
                                </a>
                            </div>
                        </div>
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
                        <li>Para boletos de niño/estudiante, presenta identificación</li>
                    </ul>
                </div>

                <!-- Botones de acción -->
                <div class="d-flex justify-content-between mt-4">
                    <a href="frmMenu.jsp" class="btn btn-outline-secondary">
                        <i class="fa-solid fa-home me-2"></i>Volver al Inicio
                    </a>
                    <div>
                        <button onclick="window.print()" class="btn btn-print me-2">
                            <i class="fa-solid fa-print me-2"></i>Imprimir Comprobante
                        </button>
                        <a href="frmSeleccionarPelicula.jsp" class="btn btn-success">
                            <i class="fa-solid fa-ticket me-2"></i>Comprar Más Boletos
                        </a>
                    </div>
                </div>
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

    <!-- Script simple para impresión -->
    <script>
        // Auto-scroll al inicio después de imprimir
        window.onafterprint = function() {
            window.scrollTo(0, 0);
        };
    </script>
</body>
</html>

<%
// Limpiar sesión después de mostrar (solo si estamos seguros de que se mostró)
try {
    session.removeAttribute("compraExitosa");
    session.removeAttribute("asientosAsignados");
    session.removeAttribute("cantidadGeneral");
    session.removeAttribute("cantidadNino");
    session.removeAttribute("cantidadEstudiante");
    session.removeAttribute("totalCompra");
    session.removeAttribute("idFuncion");
    session.removeAttribute("idPelicula");
    session.removeAttribute("tituloPelicula");
    session.removeAttribute("fechaFuncion");
    session.removeAttribute("horaFuncion");
    session.removeAttribute("numeroSala");
    session.removeAttribute("precioGeneral");
    session.removeAttribute("precioNino");
    session.removeAttribute("precioEstudiante");
} catch (Exception e) {
    // Ignorar errores al limpiar sesión
}
%>