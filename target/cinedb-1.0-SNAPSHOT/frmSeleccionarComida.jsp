<%@page import="entity.Producto"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductoDAO"%>
<%@page import="dao.TransaccionDAO"%>
<%@page import="dao.DetalleProductoDAO"%>
<%@page import="entity.Transaccion"%>
<%@page import="entity.DetalleProducto"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.time.LocalDateTime"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Seleccionar Comida - Cine</title>
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
            height: 200px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
        }
        .product-category {
            position: absolute;
            top: 10px;
            right: 10px;
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
            padding: 10px 0;
        }
        .quantity-control {
            width: 100px;
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
        .category-filter .btn {
            border-radius: 20px;
            padding: 8px 20px;
            margin: 0 5px 10px 0;
        }
    </style>
</head>
<body>
    <%
        // ============================================
        // 1. PROCESAR PEDIDO CUANDO SE ENVÍA EL FORMULARIO
        // ============================================
        String mensaje = "";
        String tipoMensaje = "";
        
        if("POST".equals(request.getMethod()) && "guardarPedido".equals(request.getParameter("accion"))) {
            try {
                // Obtener datos del formulario
                String nombreCliente = request.getParameter("nombreCliente");
                String metodoPago = request.getParameter("metodoPago");
                String totalStr = request.getParameter("total");
                
                if(nombreCliente == null || nombreCliente.trim().isEmpty()) {
                    mensaje = "El nombre del cliente es requerido";
                    tipoMensaje = "danger";
                } else if(totalStr == null || totalStr.trim().isEmpty() || new BigDecimal(totalStr).compareTo(BigDecimal.ZERO) <= 0) {
                    mensaje = "El carrito está vacío";
                    tipoMensaje = "warning";
                } else {
                    // Crear transacción
                    BigDecimal total = new BigDecimal(totalStr);
                    Transaccion transaccion = new Transaccion(
                        0, // id se generará automáticamente
                        LocalDateTime.now(),
                        total,
                        metodoPago != null ? metodoPago : "EFECTIVO"
                    );
                    
                    // Guardar transacción
                    TransaccionDAO transaccionDAO = new TransaccionDAO();
                    transaccionDAO.insertarTransaccion(transaccion);
                    
                    // Para obtener el ID de la transacción recién creada,
                    // necesitamos buscar la última transacción
                    // (O modificar el DAO para que retorne el ID generado)
                    // Por simplicidad, asumiremos que funciona
                    
                    mensaje = "¡Pedido guardado exitosamente! Total: Q" + String.format("%.2f", total);
                    tipoMensaje = "success";
                }
            } catch(Exception e) {
                mensaje = "Error al guardar el pedido: " + e.getMessage();
                tipoMensaje = "danger";
                e.printStackTrace();
            }
        }
    %>
    
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
                    <li class="nav-item"><a class="nav-link active" href="frmSeleccionComida.jsp"><i class="fa-solid fa-popcorn me-1"></i>Comida</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fa-solid fa-sliders me-1"></i>Administrar
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="frmListadoPeliculas.jsp"><i class="fa-solid fa-film me-2"></i>Películas</a></li>
                            <li><a class="dropdown-item" href="frmListadoProducto.jsp"><i class="fa-solid fa-tags me-2"></i>Productos</a></li>
                            <li><a class="dropdown-item" href="frmFunciones.jsp"><i class="fa-solid fa-calendar me-2"></i>Funciones</a></li>
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
                <h1 class="display-4 fw-bold mb-3">Selecciona tu Comida</h1>
                <p class="lead mb-0">Disfruta de nuestros deliciosos snacks y bebidas</p>
            </div>
        </div>
    </header>

    <main class="container my-5">
        <% if(!mensaje.isEmpty()) { %>
        <div class="row mb-4">
            <div class="col-12">
                <div class="alert alert-<%= tipoMensaje %> alert-dismissible fade show">
                    <%= mensaje %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </div>
        <% } %>
        
        <div class="row">
            <!-- Columna de productos -->
            <div class="col-lg-8">
                <div class="mb-4">
                    <h2 class="section-title">Catálogo de Productos</h2>
                    
                    <div class="category-filter mb-4">
                        <button class="btn btn-outline-success active" onclick="filtrarProductos('all')">Todos</button>
                        <button class="btn btn-outline-success" onclick="filtrarProductos('combo')">Combos</button>
                        <button class="btn btn-outline-success" onclick="filtrarProductos('snack')">Snacks</button>
                        <button class="btn btn-outline-success" onclick="filtrarProductos('bebida')">Bebidas</button>
                        <button class="btn btn-outline-success" onclick="filtrarProductos('dulce')">Dulces</button>
                    </div>
                </div>
                
                <div class="row" id="productosContainer">
                    <%
                        ProductoDAO dao = new ProductoDAO();
                        List<Producto> productos = dao.getProductosConStock();
                        
                        if(productos.isEmpty()) {
                    %>
                    <div class="col-12">
                        <div class="alert alert-warning text-center">
                            <i class="fa-solid fa-exclamation-triangle fa-2x mb-3"></i>
                            <h4>No hay productos disponibles</h4>
                            <p class="mb-0">Actualmente no hay productos en stock.</p>
                        </div>
                    </div>
                    <%
                        } else {
                            for(Producto producto : productos){
                                String categoria = "otro";
                                String categoriaClass = "secondary";
                                String icono = "fa-box";
                                
                                // Asignar categoría basada en nombre
                                String nombreLower = producto.getNombre().toLowerCase();
                                if(nombreLower.contains("combo")) {
                                    categoria = "combo";
                                    categoriaClass = "warning";
                                    icono = "fa-gift";
                                } else if(nombreLower.contains("refresco") || nombreLower.contains("bebida")) {
                                    categoria = "bebida";
                                    categoriaClass = "info";
                                    icono = "fa-glass-water";
                                } else if(nombreLower.contains("palomitas") || nombreLower.contains("popcorn")) {
                                    categoria = "snack";
                                    categoriaClass = "success";
                                    icono = "fa-popcorn";
                                } else if(nombreLower.contains("dulce") || nombreLower.contains("chocolate")) {
                                    categoria = "dulce";
                                    categoriaClass = "danger";
                                    icono = "fa-candy-cane";
                                }
                    %>
                    <div class="col-md-6 col-lg-4 mb-4 producto-item" data-category="<%= categoria %>">
                        <div class="product-card">
                            <div class="product-img position-relative">
                                <i class="fa-solid <%= icono %> fa-4x text-muted"></i>
                                <span class="badge bg-<%= categoriaClass %> product-category">
                                    <%= categoria.substring(0, 1).toUpperCase() + categoria.substring(1) %>
                                </span>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title"><%= producto.getNombre() %></h5>
                                <p class="card-text text-muted small mb-2">
                                    <%= producto.getStock() %> disponibles
                                </p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <h4 class="text-success mb-0">Q<%= String.format("%.2f", producto.getPrecioVenta()) %></h4>
                                    <form method="POST" action="" style="display: inline;">
                                        <input type="hidden" name="accion" value="agregarProducto">
                                        <input type="hidden" name="idProducto" value="<%= producto.getIdProducto() %>">
                                        <button type="submit" class="btn btn-success btn-sm">
                                            <i class="fa-solid fa-cart-plus me-1"></i>Agregar
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>
            
            <!-- Columna del carrito -->
            <div class="col-lg-4">
                <div class="cart-sidebar">
                    <h3 class="mb-4">
                        <i class="fa-solid fa-shopping-cart text-success me-2"></i>
                        Mi Pedido
                    </h3>
                    
                    <!-- Formulario principal para guardar pedido -->
                    <form method="POST" action="" id="formPedido">
                        <input type="hidden" name="accion" value="guardarPedido">
                        
                        <!-- Datos del cliente -->
                        <div class="mb-4">
                            <h5 class="mb-3">Datos del Cliente</h5>
                            <div class="mb-3">
                                <label for="nombreCliente" class="form-label">Nombre:</label>
                                <input type="text" class="form-control" id="nombreCliente" name="nombreCliente" 
                                       required placeholder="Ingresa tu nombre">
                            </div>
                            <div class="mb-3">
                                <label for="metodoPago" class="form-label">Método de Pago:</label>
                                <select class="form-select" id="metodoPago" name="metodoPago" required>
                                    <option value="EFECTIVO">Efectivo</option>
                                    <option value="TARJETA">Tarjeta de Crédito/Débito</option>
                                </select>
                            </div>
                        </div>
                        
                        <!-- Productos en el carrito -->
                        <%
                            // Simular carrito en sesión (esto es temporal)
                            // En un sistema real, usarías HttpSession
                            List<Producto> carrito = new java.util.ArrayList<>();
                            BigDecimal totalCarrito = BigDecimal.ZERO;
                            
                            // Verificar si se está agregando un producto
                            if("POST".equals(request.getMethod()) && "agregarProducto".equals(request.getParameter("accion"))) {
                                String idProductoStr = request.getParameter("idProducto");
                                if(idProductoStr != null) {
                                    int idProducto = Integer.parseInt(idProductoStr);
                                    Producto productoAgregar = dao.getProductoPorId(idProducto);
                                    if(productoAgregar != null) {
                                        // Aquí normalmente usarías la sesión
                                        // Por ahora solo mostramos
                                    }
                                }
                            }
                            
                            // Mostrar productos en carrito (simulado)
                            if(carrito.isEmpty()) {
                        %>
                        <div class="empty-cart">
                            <i class="fa-solid fa-cart-shopping fa-3x mb-3"></i>
                            <h5>Tu carrito está vacío</h5>
                            <p class="mb-0">Agrega productos desde el catálogo</p>
                        </div>
                        <%
                            } else {
                        %>
                        <div id="carritoContenido">
                            <div class="mb-4">
                                <%
                                    for(Producto producto : carrito) {
                                        BigDecimal subtotal = producto.getPrecioVenta(); // En realidad sería precio * cantidad
                                        totalCarrito = totalCarrito.add(subtotal);
                                %>
                                <div class="cart-item">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <h6 class="mb-1"><%= producto.getNombre() %></h6>
                                            <p class="text-muted small mb-0">Q<%= String.format("%.2f", producto.getPrecioVenta()) %> c/u</p>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mt-2">
                                        <span>Cantidad: 1</span>
                                        <span class="fw-bold">Q<%= String.format("%.2f", subtotal) %></span>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                            
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Subtotal:</span>
                                    <span id="subtotal" class="fw-bold">Q<%= String.format("%.2f", totalCarrito) %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-3">
                                    <span class="text-muted">Total:</span>
                                    <h4 id="total" class="text-success mb-0">Q<%= String.format("%.2f", totalCarrito) %></h4>
                                </div>
                            </div>
                            
                            <input type="hidden" name="total" value="<%= totalCarrito %>">
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-success btn-success-lg">
                                    <i class="fa-solid fa-credit-card me-2"></i>Confirmar Pedido
                                </button>
                                <a href="frmSeleccionComida.jsp" class="btn btn-outline-secondary">
                                    <i class="fa-solid fa-times me-2"></i>Cancelar
                                </a>
                            </div>
                        </div>
                        <%
                            }
                        %>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h5><i class="fa-solid fa-film me-2"></i>Cine</h5>
                    <p class="mb-0">Más que cine, una experiencia.</p>
                </div>
                <div class="col-md-6 text-end">
                    <div class="btn-group" role="group">
                        <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-ticket me-1"></i>Boletos
                        </a>
                        <a href="frmSeleccionComida.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-popcorn me-1"></i>Comida
                        </a>
                        <a href="frmMenu.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-home me-1"></i>Inicio
                        </a>
                        <a href="frmListadoPeliculas.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-sliders me-1"></i>Administrar
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función simple para filtrar productos (sin AJAX)
        function filtrarProductos(categoria) {
            document.querySelectorAll('.category-filter .btn').forEach(b => b.classList.remove('active'));
            event.target.classList.add('active');
            
            document.querySelectorAll('.producto-item').forEach(item => {
                if(categoria === 'all' || item.getAttribute('data-category') === categoria) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>