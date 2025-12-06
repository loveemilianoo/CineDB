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
    // ============================================
    // 1. INICIALIZAR CARRITO EN SESIÓN
    // ============================================
    Map<Integer, Integer> carrito = (Map<Integer, Integer>) session.getAttribute("carritoSimple");
    if(carrito == null) {
        carrito = new HashMap<>();
        session.setAttribute("carritoSimple", carrito);
    }
    
    // ============================================
    // 2. PROCESAR ACCIONES
    // ============================================
    String mensaje = "";
    String tipoMensaje = "";
    
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
                    // Calcular total
                    BigDecimal total = BigDecimal.ZERO;
                    ProductoDAO productoDAO = new ProductoDAO();
                    
                    // Crear registro de venta (simplificado - sin control de stock)
                    // Aquí iría la lógica para guardar en la base de datos
                    
                    for(Map.Entry<Integer, Integer> entry : carrito.entrySet()) {
                        Producto producto = productoDAO.getProductoPorId(entry.getKey());
                        if(producto != null) {
                            BigDecimal subtotal = producto.getPrecioVenta()
                                .multiply(new BigDecimal(entry.getValue()));
                            total = total.add(subtotal);
                        }
                    }
                    
                    // Limpiar carrito después de la compra
                    carrito.clear();
                    
                    mensaje = "¡Pedido realizado exitosamente! Total: $" + String.format("%.2f", total);
                    tipoMensaje = "success";
                }
            } catch(Exception e) {
                mensaje = "Error al procesar la compra: " + e.getMessage();
                tipoMensaje = "danger";
            }
        }
    }
    
    // ============================================
    // 3. OBTENER TODOS LOS PRODUCTOS
    // ============================================
    ProductoDAO dao = new ProductoDAO();
    List<Producto> productos = dao.getProductos();
    
    // ============================================
    // 4. CALCULAR TOTAL DEL CARRITO
    // ============================================
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
    <title>Seleccionar Comida - Cine Prototyoe</title>
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
    </style>
</head>
<body>
     <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
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
<<<<<<< HEAD
                    <li class="nav-item"><a class="nav-link" href="frmSeleccionarComida.jsp"><i class="fa-solid fa-popcorn me-1"></i>Comida</a></li>
=======
                    <li class="nav-item"><a class="nav-link" href="frmSeleccionarComida"><i class="fa-solid fa-popcorn me-1"></i>Comida</a></li>
>>>>>>> 556f933636f05e139116c50123927b4adcaa5c29
                    <li class="nav-item dropdown">
                        <a class="nav-link active dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fa-solid fa-sliders me-1"></i>Administrar
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="frmListadoPeliculas.jsp"><i class="fa-solid fa-film me-2"></i>Películas</a></li>
                            <li><a class="dropdown-item active" href="frmListadoProducto.jsp"><i class="fa-solid fa-tags me-2"></i>Productos</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fa-solid fa-calendar me-2"></i>Funciones</a></li>
                            <li><a class="dropdown-item" href="frmListadoBoletos.jsp"><i class="fa-solid fa-ticket me-2"></i>Boletos</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <header class="hero-section">
        <div class="container">
            <div class="text-center">
                <h1 class="display-4 fw-bold mb-3">Seleccionar Comida</h1>
                <p class="lead mb-0">Selecciona tus productos favoritos</p>
            </div>
        </div>
    </header>

    <main class="container my-5">
        <% if(!mensaje.isEmpty()) { %>
        <div class="row mb-4">
            <div class="col-12">
                <div class="alert alert-<%= tipoMensaje %>">
                    <i class="fa-solid fa-info-circle me-2"></i><%= mensaje %>
                </div>
            </div>
        </div>
        <% } %>
        
        <div class="row">
            <!-- Columna de productos -->
            <div class="col-lg-8">
                <div class="mb-4">
                    <h2 class="section-title">Menú Disponible</h2>
                    
                    <!-- Información simplificada -->
                    <div class="simple-form">
                        <div class="d-flex align-items-center mb-2">
                            <span class="availability-dot available"></span>
                            <small class="me-3">Disponible</small>
                            <span class="availability-dot unavailable"></span>
                            <small>No disponible</small>
                        </div>
                        <p class="mb-0 text-muted">
                            <i class="fa-solid fa-info-circle me-1"></i>
                            Selecciona la cantidad de cada producto. No hay control de inventario.
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
                                
                                <!-- Estado simple -->
                                <p class="small mb-3">
                                    <span class="badge <%= disponible ? "bg-success" : "bg-danger" %>">
                                        <%= disponible ? "Disponible" : "No disponible" %>
                                    </span>
                                </p>
                                
                                <!-- Formulario para agregar -->
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
            
            <!-- Columna del carrito y formulario de pago -->
            <div class="col-lg-4">
                <div class="cart-sidebar">
                    <!-- Título del carrito -->
                    <h3 class="mb-4">
                        <i class="fa-solid fa-shopping-cart text-success me-2"></i>
                        Mi Pedido
                    </h3>
                    
                    <!-- Formulario de datos del cliente (SIEMPRE VISIBLE) -->
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
                         </form>
                    </div>
                    
                    <!-- Contenido del carrito -->
                    <% if(carrito.isEmpty()) { %>
                    <div class="empty-cart">
                        <i class="fa-solid fa-cart-shopping fa-3x mb-3 text-muted"></i>
                        <h5 class="text-muted">Tu carrito está vacío</h5>
                        <p class="text-muted mb-0">Agrega productos desde el catálogo</p>
                    </div>
                    <% } else { %>
                    <!-- Items del carrito -->
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
                                    <p class="text-muted small mb-0">Q<%= String.format("%.2f", producto.getPrecioVenta()) %> c/u</p>
                                </div>
                                <form method="POST" action="frmSeleccionarComida.jsp" class="d-inline">
                                    <input type="hidden" name="accion" value="eliminar">
                                    <input type="hidden" name="idProducto" value="<%= producto.getIdProducto() %>">
                                    <button type="submit" class="btn btn-outline-danger btn-sm">
                                        <i class="fa-solid fa-times"></i>
                                    </button>
                                </form>
                            </div>
                            
                            <!-- Control de cantidad -->
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
                                <span class="fw-bold">Q<%= String.format("%.2f", subtotal) %></span>
                            </div>
                        </div>
                        <% } } %>
                    </div>
                    
                    <!-- Resumen del pedido -->
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
                            <span class="fw-bold">Q<%= String.format("%.2f", totalCarrito) %></span>
                        </div>
                        
                        <div class="d-flex justify-content-between mb-4 border-top pt-2">
                            <span class="h5">Total a pagar:</span>
                            <h3 class="text-success mb-0">Q<%= String.format("%.2f", totalCarrito) %></h3>
                        </div>
                        
                        <!-- Nota informativa -->
                        <div class="alert alert-info small">
                            <i class="fa-solid fa-lightbulb me-1"></i>
                            Completa tus datos arriba y haz clic en "Confirmar Pedido"
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h5><i class="fa-solid fa-film me-2"></i>Cine Prototype</h5>
                    <p class="mb-0">Más que cine, una experiencia.</p>
                </div>
                <div class="col-md-6 text-end">
                    <div class="btn-group">
                        <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-ticket me-1"></i>Boletos
                        </a>
                        <a href="frmSeleccionarComida.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-popcorn me-1"></i>Comida
                        </a>
                        <a href="frmMenu.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-home me-1"></i>Inicio
                        </a>
                    </div>
                </div>
            </div>
            <hr class="my-3">
            <div class="text-center">
                <p class="mb-0">© 2024 Cine. Sistema desarrollado con Java JSP y PostgreSQL</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS (solo para componentes) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>