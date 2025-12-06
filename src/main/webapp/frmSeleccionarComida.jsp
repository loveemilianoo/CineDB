<%@page import="entity.Producto"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductoDAO"%>
<%@page import="dao.TransaccionDAO"%>
<%@page import="dao.DetalleProductoDAO"%>
<%@page import="entity.Transaccion"%>
<%@page import="entity.DetalleProducto"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    
    Map<Integer, Integer> carrito = (Map<Integer, Integer>) session.getAttribute("carritoSimple");
    if(carrito == null) {
        carrito = new HashMap<>();
        session.setAttribute("carritoSimple", carrito);
    }
    
   
    String mensaje = "";
    String tipoMensaje = "";
    boolean mostrarTicket = false;
    Map<String, Object> ticketData = null;
    
    String accion = request.getParameter("accion");
    if(accion != null) {
        if("agregar".equals(accion)) {
            try {
                int idProducto = Integer.parseInt(request.getParameter("idProducto"));
                int cantidad = Integer.parseInt(request.getParameter("cantidad"));
                
                if(cantidad > 0) {
                    ProductoDAO productoDAO = new ProductoDAO();
                    Producto producto = productoDAO.getProductoPorId(idProducto);
                    
                    if(producto != null) {
                        int cantidadActual = carrito.getOrDefault(idProducto, 0);
                        carrito.put(idProducto, cantidadActual + cantidad);
                        mensaje = producto.getNombre() + " agregado (x" + cantidad + ")";
                        tipoMensaje = "success";
                    }
                }
            } catch(Exception e) {
                mensaje = "Error al agregar producto";
                tipoMensaje = "danger";
            }
            
        } else if("eliminar".equals(accion)) {
            try {
                int idProducto = Integer.parseInt(request.getParameter("idProducto"));
                carrito.remove(idProducto);
                mensaje = "Producto eliminado";
                tipoMensaje = "info";
            } catch(Exception e) {
                mensaje = "Error al eliminar";
                tipoMensaje = "danger";
            }
            
        } else if("actualizar".equals(accion)) {
            try {
                int idProducto = Integer.parseInt(request.getParameter("idProducto"));
                int nuevaCantidad = Integer.parseInt(request.getParameter("cantidad"));
                
                if(nuevaCantidad > 0) {
                    carrito.put(idProducto, nuevaCantidad);
                    mensaje = "Cantidad actualizada";
                    tipoMensaje = "success";
                } else {
                    carrito.remove(idProducto);
                    mensaje = "Producto eliminado";
                    tipoMensaje = "info";
                }
            } catch(Exception e) {
                mensaje = "Error al actualizar";
                tipoMensaje = "danger";
            }
            
        } else if("limpiar".equals(accion)) {
            carrito.clear();
            mensaje = "Carrito vaciado";
            tipoMensaje = "info";
            
        } else if("comprar".equals(accion)) {
            try {
                String nombreCliente = request.getParameter("nombreCliente");
                String metodoPago = request.getParameter("metodoPago");
                
                if(nombreCliente == null || nombreCliente.trim().isEmpty()) {
                    mensaje = "Nombre del cliente requerido";
                    tipoMensaje = "danger";
                } else if(carrito.isEmpty()) {
                    mensaje = "El carrito está vacío";
                    tipoMensaje = "warning";
                } else {
                    BigDecimal total = BigDecimal.ZERO;
                    ProductoDAO productoDAO = new ProductoDAO();
                    
                    List<Map<String, Object>> detallesPedido = new ArrayList<>();
                    
                    for(Map.Entry<Integer, Integer> entry : carrito.entrySet()) {
                        Producto producto = productoDAO.getProductoPorId(entry.getKey());
                        if(producto != null) {
                            BigDecimal subtotal = producto.getPrecioVenta()
                                .multiply(new BigDecimal(entry.getValue()));
                            total = total.add(subtotal);
                            
                            Map<String, Object> detalle = new HashMap<>();
                            detalle.put("producto", producto);
                            detalle.put("cantidad", entry.getValue());
                            detalle.put("subtotal", subtotal);
                            detallesPedido.add(detalle);
                        }
                    }
                    
                    
                    
                    String ticketId = "TKT" + System.currentTimeMillis() + (int)(Math.random() * 1000);
                    
                    ticketData = new HashMap<>();
                    ticketData.put("ticketId", ticketId);
                    ticketData.put("nombreCliente", nombreCliente.trim());
                    ticketData.put("metodoPago", metodoPago);
                    ticketData.put("total", total);
                    ticketData.put("fecha", LocalDateTime.now());
                    ticketData.put("detalles", detallesPedido);
                    
                    session.setAttribute("ticketActual", ticketData);
                    
                    mensaje = "¡Compra realizada con éxito! Ticket: " + ticketId;
                    tipoMensaje = "success";
                    mostrarTicket = true;
                    
                    carrito.clear();
                }
            } catch(Exception e) {
                mensaje = "Error al procesar la compra: " + e.getMessage();
                tipoMensaje = "danger";
                e.printStackTrace();
            }
        }
    }
    
    ProductoDAO dao = new ProductoDAO();
    List<Producto> productos = dao.getProductos();
    
    
    BigDecimal totalCarrito = BigDecimal.ZERO;
    int totalItems = 0;
    
    if(!carrito.isEmpty()) {
        for(Map.Entry<Integer, Integer> entry : carrito.entrySet()) {
            Producto producto = dao.getProductoPorId(entry.getKey());
            if(producto != null) {
                BigDecimal subtotal = producto.getPrecioVenta()
                    .multiply(new BigDecimal(entry.getValue()));
                totalCarrito = totalCarrito.add(subtotal);
                totalItems += entry.getValue();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Seleccionar Comida - Cine Prototype</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(125deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 80px 0;
        }
        .product-card {
            border-radius: 15px;
            transition: all 0.3s ease;
            border: 1px solid #dee2e6;
            overflow: hidden;
            height: 100%;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .product-img {
            height: 180px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
        }
        .cart-sidebar {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 25px;
            position: sticky;
            top: 20px;
        }
        .cart-item {
            border-bottom: 1px solid #dee2e6;
            padding: 15px 0;
        }
        .btn-success-lg {
            padding: 15px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 10px;
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
            width: 60px;
            height: 3px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        .empty-cart {
            padding: 40px 0;
            text-align: center;
            color: #6c757d;
        }
        .simple-form {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .availability-dot {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 5px;
        }
        .available {
            background-color: #28a745;
        }
        .unavailable {
            background-color: #dc3545;
        }
        .cart-summary {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }
        .customer-info {
            background-color: #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .ticket-container {
            border: 2px solid #28a745;
            border-radius: 10px;
            background: white;
            max-width: 800px;
            margin: 0 auto;
        }
        .ticket-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 20px;
            border-radius: 10px 10px 0 0;
        }
        .ticket-body {
            padding: 30px;
        }
        .ticket-footer {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 0 0 10px 10px;
            border-top: 1px solid #dee2e6;
        }
        .ticket-id {
            font-family: 'Courier New', monospace;
            font-weight: bold;
            letter-spacing: 1px;
        }
        @media print {
            .no-print {
                display: none !important;
            }
            .ticket-container {
                border: none;
                box-shadow: none;
            }
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
                    <li class="nav-item"><a class="nav-link" href="frmMenu.jsp"><i class="fa-solid fa-home me-1"></i>Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="frmSeleccionarPelicula.jsp"><i class="fa-solid fa-ticket me-1"></i>Boletos</a></li>
                    <li class="nav-item"><a class="nav-link active" href="frmSeleccionarComida.jsp"><i class="fa-solid fa-utensils me-1"></i>Comida</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link active dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fa-solid fa-sliders me-1"></i>Administrar
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="frmListadoPeliculas.jsp"><i class="fa-solid fa-film me-2"></i>Películas</a></li>
                            <li><a class="dropdown-item active" href="frmListadoProducto.jsp"><i class="fa-solid fa-pizza-slice me-2"></i>Productos</a></li>
                            <li><a class="dropdown-item" href="frmSeleccionarFuncion.jsp"><i class="fa-solid fa-calendar me-2"></i>Funciones</a></li>
                            <li><a class="dropdown-item" href="frmListadoBoletos.jsp"><i class="fa-solid fa-couchs me-2"></i>Salas</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <header class="hero-section no-print">
        <div class="container">
            <div class="text-center">
                <h1 class="display-4 fw-bold mb-3">Seleccionar Comida</h1>
                <p class="lead mb-0">Selecciona tus productos favoritos</p>
            </div>
        </div>
    </header>

    <main class="container my-5">
        <% if(!mensaje.isEmpty() && !mostrarTicket) { %>
        <div class="row mb-4 no-print">
            <div class="col-12">
                <div class="alert alert-<%= tipoMensaje %>">
                    <i class="fa-solid fa-info-circle me-2"></i><%= mensaje %>
                </div>
            </div>
        </div>
        <% } %>
        
        <% if(mostrarTicket && ticketData != null) { 
            String ticketId = (String) ticketData.get("ticketId");
            String nombreCliente = (String) ticketData.get("nombreCliente");
            String metodoPago = (String) ticketData.get("metodoPago");
            BigDecimal total = (BigDecimal) ticketData.get("total");
            LocalDateTime fecha = (LocalDateTime) ticketData.get("fecha");
            List<Map<String, Object>> detalles = (List<Map<String, Object>>) ticketData.get("detalles");
        %>
        <div class="row mb-5">
            <div class="col-12">
                <div class="ticket-container shadow-lg">
                    <div class="ticket-header">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h2 class="mb-2">
                                    <i class="fa-solid fa-ticket-alt me-2"></i>Ticket de Compra
                                </h2>
                                <h5 class="mb-0">Cine Prototype - Venta de Comida</h5>
                            </div>
                            <div class="col-md-4 text-end">
                                <h4 class="ticket-id mb-2"><%= ticketId %></h4>
                                <p class="mb-0">
                                    <i class="fa-solid fa-calendar me-1"></i>
                                    <%= fecha.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>
                                </p>
                                <p class="mb-0">
                                    <i class="fa-solid fa-clock me-1"></i>
                                    <%= fecha.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss")) %>
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="ticket-body">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h5><i class="fa-solid fa-user me-2"></i>Información del Cliente</h5>
                                <div class="card">
                                    <div class="card-body">
                                        <p class="mb-2"><strong>Nombre:</strong> <%= nombreCliente %></p>
                                        <p class="mb-0"><strong>Método de pago:</strong> <%= metodoPago %></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h5><i class="fa-solid fa-store me-2"></i>Información del Cine</h5>
                                <div class="card">
                                    <div class="card-body">
                                        <p class="mb-2"><strong>Establecimiento:</strong> Cine Prototype</p>
                                        <p class="mb-2"><strong>Sistema:</strong> Venta de Comida</p>
                                        <p class="mb-0"><strong>Atendido por:</strong> Sistema Automático</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <h5 class="mb-3"><i class="fa-solid fa-list me-2"></i>Detalles de la Compra</h5>
                        <div class="table-responsive mb-4">
                            <table class="table table-bordered">
                                <thead class="table-success">
                                    <tr>
                                        <th>#</th>
                                        <th>Producto</th>
                                        <th class="text-center">Cantidad</th>
                                        <th class="text-center">Precio Unitario</th>
                                        <th class="text-center">Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        int contador = 1;
                                        for(Map<String, Object> detalle : detalles) {
                                            Producto producto = (Producto) detalle.get("producto");
                                            int cantidad = (int) detalle.get("cantidad");
                                            BigDecimal subtotal = (BigDecimal) detalle.get("subtotal");
                                    %>
                                    <tr>
                                        <td><%= contador++ %></td>
                                        <td><%= producto.getNombre() %></td>
                                        <td class="text-center"><%= cantidad %></td>
                                        <td class="text-center">$<%= String.format("%.2f", producto.getPrecioVenta()) %></td>
                                        <td class="text-center">$<%= String.format("%.2f", subtotal) %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                                <tfoot class="table-success">
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>TOTAL A PAGAR:</strong></td>
                                        <td class="text-center">
                                            <h4 class="mb-0 text-dark">$<%= String.format("%.2f", total) %></h4>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                        
                        <div class="alert alert-success">
                            <div class="d-flex align-items-center">
                                <i class="fa-solid fa-check-circle fa-2x me-3"></i>
                                <div>
                                    <h5 class="alert-heading mb-2">¡Compra realizada con éxito!</h5>
                                    <p class="mb-0">Tu pedido ha sido procesado correctamente. Conserva este ticket como comprobante.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="card border-info">
                            <div class="card-header bg-info text-white">
                                <i class="fa-solid fa-info-circle me-2"></i>Información importante
                            </div>
                            <div class="card-body">
                                <ul class="mb-0">
                                    <li>Este ticket es tu comprobante de compra</li>
                                    <li>Presenta el <strong>ID <%= ticketId %></strong> para cualquier consulta</li>
                                    <li>El ticket es válido solo para el día de la compra</li>
                                    <li>Para reclamos, presenta este documento en atención al cliente</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <div class="ticket-footer">
                        <div class="row">
                            <div class="col-md-8">
                                <p class="mb-0 text-muted">
                                    <i class="fa-solid fa-shield-alt me-1"></i>
                                    Sistema seguro - Cine Prototype
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <p class="mb-0">
                                    <strong>Ticket ID:</strong> <span class="ticket-id"><%= ticketId %></span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="d-flex justify-content-center gap-3 mt-4 no-print">
                    </button>
                    <a href="frmSeleccionarComida.jsp" class="btn btn-success btn-lg">
                        <i class="fa-solid fa-cart-plus me-2"></i>Nueva Compra
                    </a>
                    <a href="frmMenu.jsp" class="btn btn-outline-secondary btn-lg">
                        <i class="fa-solid fa-home me-2"></i>Volver al Menú
                    </a>
                </div>
            </div>
        </div>
        <% } %>
        
        <% if(!mostrarTicket) { %>
        <div class="row no-print">
            <div class="col-lg-8">
                <div class="mb-4">
                    <h2 class="section-title">Menú Disponible</h2>
                    
                    <div class="simple-form">
                        <div class="d-flex align-items-center mb-2">
                            <span class="availability-dot available"></span>
                            <small class="me-3">Disponible</small>
                            <span class="availability-dot unavailable"></span>
                            <small>No disponible</small>
                        </div>
                        <p class="mb-0 text-muted">
                            <i class="fa-solid fa-info-circle me-1"></i>
                            Selecciona la cantidad de cada producto.
                        </p>
                    </div>
                </div>
                
                <div class="row">
                    <%
                        for(Producto producto : productos){
                            boolean disponible = producto.getStock() > 0;
                            String icono = "fa-box";
                            String nombreLower = producto.getNombre().toLowerCase();
                            
                            if(nombreLower.contains("combo")) {
                                icono = "fa-gift";
                            } else if(nombreLower.contains("refresco") || nombreLower.contains("bebida")) {
                                icono = "fa-glass-water";
                            } else if(nombreLower.contains("palomitas") || nombreLower.contains("popcorn")) {
                                icono = "fa-popcorn";
                            }
                    %>
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="product-card">
                            <div class="product-img position-relative">
                                <i class="fa-solid <%= icono %> fa-4x <%= disponible ? "text-success" : "text-muted" %>"></i>
                                <span class="badge <%= disponible ? "bg-success" : "bg-secondary" %>" 
                                      style="position: absolute; top: 10px; right: 10px;">
                                    $<%= String.format("%.2f", producto.getPrecioVenta()) %>
                                </span>
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="card-title mb-0"><%= producto.getNombre() %></h5>
                                    <span class="availability-dot <%= disponible ? "available" : "unavailable" %>"></span>
                                </div>
                                
                                <p class="small mb-3">
                                    <span class="badge <%= disponible ? "bg-success" : "bg-danger" %>">
                                        <%= disponible ? "Disponible" : "No disponible" %>
                                    </span>
                                </p>
                                
                                <form method="POST" action="frmSeleccionarComida.jsp">
                                    <input type="hidden" name="accion" value="agregar">
                                    <input type="hidden" name="idProducto" value="<%= producto.getIdProducto() %>">
                                    
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div>
                                            <label class="form-label small mb-1">Cantidad:</label>
                                            <select name="cantidad" class="form-select form-select-sm" style="width: 80px;">
                                                <% for(int i = 1; i <= 10; i++) { %>
                                                <option value="<%= i %>"><%= i %></option>
                                                <% } %>
                                            </select>
                                        </div>
                                        
                                        <button type="submit" 
                                                class="btn <%= disponible ? "btn-success" : "btn-secondary" %>"
                                                <%= !disponible ? "disabled" : "" %>>
                                            <i class="fa-solid fa-cart-plus me-1"></i>
                                            Agregar
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="cart-sidebar">
                    <h3 class="mb-4">
                        <i class="fa-solid fa-shopping-cart text-success me-2"></i>
                        Mi Pedido
                    </h3>
                    
                    <div class="customer-info">
                        <h5 class="mb-3">
                            <i class="fa-solid fa-user me-2"></i>Datos del Cliente
                        </h5>
                        <form method="POST" action="frmSeleccionarComida.jsp" id="formPedido">
                            <input type="hidden" name="accion" value="comprar">
                            
                            <div class="mb-3">
                                <label for="nombreCliente" class="form-label">
                                    <i class="fa-solid fa-user-tag me-1"></i>Nombre:
                                </label>
                                <input type="text" 
                                       class="form-control" 
                                       id="nombreCliente" 
                                       name="nombreCliente" 
                                       required 
                                       placeholder="Ingresa tu nombre completo"
                                       value="<%= request.getParameter("nombreCliente") != null ? request.getParameter("nombreCliente") : "" %>">
                            </div>
                            
                            <div class="mb-3">
                                <label for="metodoPago" class="form-label">
                                    <i class="fa-solid fa-credit-card me-1"></i>Método de Pago:
                                </label>
                                <select class="form-select" id="metodoPago" name="metodoPago" required>
                                    <option value="EFECTIVO" <%= "EFECTIVO".equals(request.getParameter("metodoPago")) ? "selected" : "" %>>Efectivo</option>
                                    <option value="TARJETA" <%= "TARJETA".equals(request.getParameter("metodoPago")) ? "selected" : "" %>>Tarjeta</option>
                                    <option value="TRANSFERENCIA" <%= "TRANSFERENCIA".equals(request.getParameter("metodoPago")) ? "selected" : "" %>>Transferencia</option>
                                </select>
                            </div>
                            
                            <% if(!carrito.isEmpty()) { %>
                            <div class="d-flex justify-content-between mb-3">
                                <button type="button" 
                                        onclick="if(confirm('¿Estás seguro de vaciar el carrito?')) { document.getElementById('formLimpiar').submit(); }" 
                                        class="btn btn-outline-danger btn-sm">
                                    <i class="fa-solid fa-trash me-1"></i>Vaciar Carrito
                                </button>

                                <button type="submit" form="formPedido" class="btn btn-success">
                                    <i class="fa-solid fa-check-circle me-1"></i>Confirmar Pedido
                                </button>
                            </div>
                            <% } %>
                        </form>
                        <form method="POST" action="frmSeleccionarComida.jsp" id="formLimpiar" style="display: none;">
                            <input type="hidden" name="accion" value="limpiar">
                    </div>
                    
                    <% if(carrito.isEmpty()) { %>
                    <div class="empty-cart">
                        <i class="fa-solid fa-cart-shopping fa-3x mb-3 text-muted"></i>
                        <h5 class="text-muted">Tu carrito está vacío</h5>
                        <p class="text-muted mb-0">Agrega productos desde el catálogo</p>
                    </div>
                    <% } else { %>
                    <div class="mb-4" style="max-height: 300px; overflow-y: auto;">
                        <%
                            for(Map.Entry<Integer, Integer> entry : carrito.entrySet()) {
                                Producto producto = dao.getProductoPorId(entry.getKey());
                                if(producto != null) {
                                    BigDecimal subtotal = producto.getPrecioVenta()
                                        .multiply(new BigDecimal(entry.getValue()));
                        %>
                        <div class="cart-item">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h6 class="mb-1"><%= producto.getNombre() %></h6>
                                    <p class="text-muted small mb-0">$<%= String.format("%.2f", producto.getPrecioVenta()) %> c/u</p>
                                </div>
                                <form method="POST" action="frmSeleccionarComida.jsp" class="d-inline">
                                    <input type="hidden" name="accion" value="eliminar">
                                    <input type="hidden" name="idProducto" value="<%= producto.getIdProducto() %>">
                                    <button type="submit" class="btn btn-outline-danger btn-sm">
                                        <i class="fa-solid fa-times"></i>
                                    </button>
                                </form>
                            </div>
                            
                            <div class="d-flex justify-content-between align-items-center mt-2">
                                <form method="POST" action="frmSeleccionarComida.jsp" class="d-flex align-items-center">
                                    <input type="hidden" name="accion" value="actualizar">
                                    <input type="hidden" name="idProducto" value="<%= producto.getIdProducto() %>">
                                    <span class="me-2">Cantidad:</span>
                                    <select name="cantidad" class="form-select form-select-sm" style="width: 70px;" 
                                            onchange="this.form.submit()">
                                        <% for(int i = 1; i <= 10; i++) { 
                                            String selected = i == entry.getValue() ? "selected" : "";
                                        %>
                                        <option value="<%= i %>" <%= selected %>><%= i %></option>
                                        <% } %>
                                    </select>
                                </form>
                                <span class="fw-bold">$<%= String.format("%.2f", subtotal) %></span>
                            </div>
                        </div>
                        <% } } %>
                    </div>
                    
                    <div class="cart-summary">
                        <h5 class="mb-3">
                            <i class="fa-solid fa-receipt me-2"></i>Resumen del Pedido
                        </h5>
                        
                        <div class="d-flex justify-content-between mb-2">
                            <span>Items en el carrito:</span>
                            <span class="fw-bold"><%= totalItems %></span>
                        </div>
                        
                        <div class="d-flex justify-content-between mb-3">
                            <span>Subtotal:</span>
                            <span class="fw-bold">$<%= String.format("%.2f", totalCarrito) %></span>
                        </div>
                        
                        <div class="d-flex justify-content-between mb-4 border-top pt-2">
                            <span class="h5">Total a pagar:</span>
                            <h3 class="text-success mb-0">$<%= String.format("%.2f", totalCarrito) %></h3>
                        </div>
                        
                        <div class="alert alert-info small">
                            <i class="fa-solid fa-lightbulb me-1"></i>
                            Completa tus datos arriba y haz clic en "Confirmar Pedido"
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </main>

    <footer class="bg-dark text-white py-4 mt-5 no-print">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h5><i class="fa-solid fa-film me-2"></i>Sistema Cine</h5>
                </div>
                <div class="col-md-6 text-end">
                    <div class="btn-group">
                        <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-ticket me-1"></i>Boletos
                        </a>
                        <a href="frmSeleccionarComida.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-utensils me-1"></i>Comida
                        </a>
                        <a href="frmMenu.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-home me-1"></i>Inicio
                        </a>
                    </div>
                </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min