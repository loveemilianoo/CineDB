<%@page import="entity.Producto"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductoDAO"%>
<%@page import="java.math.BigDecimal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // ============================================
    // PROCESAR OPERACIONES AL INICIO DE LA PÁGINA
    // ============================================
    
    // 1. Procesar eliminación de producto
    String idEliminarStr = request.getParameter("eliminar");
    if(idEliminarStr != null && !idEliminarStr.trim().isEmpty()) {
        try {
            int idEliminar = Integer.parseInt(idEliminarStr);
            ProductoDAO daoEliminar = new ProductoDAO();
            daoEliminar.eliminarProducto(idEliminar);
            
            // Redirigir para evitar reenvío del formulario (F5)
            response.sendRedirect("frmListadoProductoSinStock.jsp");
            return;
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }
    
    // 2. Procesar búsqueda
    String buscar = request.getParameter("buscar");
    ProductoDAO dao = new ProductoDAO();
    List<Producto> productos;
    
    if(buscar != null && !buscar.trim().isEmpty()) {
        productos = dao.buscarProductosPorNombre(buscar);
    } else {
        productos = dao.getProductos();
    }
    
    // 3. Solo contar total de productos (sin cálculos de stock)
    int totalProductos = productos.size();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Catálogo de Productos - Cine Prototype</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(125deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 80px 0;
        }
        .stats-card {
            border-radius: 10px;
            transition: all 0.3s ease;
            border: none;
        }
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        .table th {
            background-color: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            color: #495057;
        }
        .table td {
            vertical-align: middle;
        }
        .btn-action {
            border-radius: 6px;
            padding: 5px 12px;
            font-size: 0.9rem;
        }
        .btn-action:hover {
            opacity: 0.8;
        }
        .search-box {
            max-width: 400px;
        }
        .empty-state {
            padding: 40px 0;
            text-align: center;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        .hero-content {
            text-align: center;
        }
        .action-buttons {
            margin-top: 30px;
        }
        .btn-primary-lg {
            padding: 12px 30px;
            font-size: 1.1rem;
            font-weight: 600;
        }
        .icon-circle {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .search-info {
            background-color: #e9ecef;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 15px;
        }
        .product-status {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 8px;
        }
        .status-available {
            background-color: #28a745;
        }
        .status-unavailable {
            background-color: #dc3545;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
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
                    <li class="nav-item"><a class="nav-link" href="#"><i class="fa-solid fa-popcorn me-1"></i>Comida</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link active dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fa-solid fa-sliders me-1"></i>Administrar
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="frmListadoPeliculas.jsp"><i class="fa-solid fa-film me-2"></i>Películas</a></li>
                            <li><a class="dropdown-item active" href="frmListadoProductoSinStock.jsp"><i class="fa-solid fa-tags me-2"></i>Productos</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fa-solid fa-calendar me-2"></i>Funciones</a></li>
                            <li><a class="dropdown-item" href="frmListadoBoletos.jsp"><i class="fa-solid fa-ticket me-2"></i>Boletos</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Header Hero - Título centrado -->
    <header class="hero-section">
        <div class="container">
            <div class="hero-content">
                <h1 class="display-4 fw-bold mb-3">Catálogo de Productos</h1>
                <p class="lead mb-0">Administra los productos disponibles en el cine</p>
                
                <!-- Botón Nuevo Producto -->
                <div class="action-buttons">
                    <a href="frmInsertaProducto.jsp" class="btn btn-light btn-primary-lg">
                        <i class="fa-solid fa-plus me-2"></i>Nuevo Producto
                    </a>
                </div>
            </div>
        </div>
    </header>

    <main class="container my-5">
        <!-- Barra de búsqueda -->
        <div class="row mb-4">
            <div class="col-md-8">
                <!-- Formulario de búsqueda -->
                <form method="GET" action="frmListadoProductoSinStock.jsp" class="search-box">
                    <div class="input-group">
                        <input type="text" class="form-control" 
                               name="buscar" 
                               value="<%= buscar != null ? buscar : "" %>" 
                               placeholder="Buscar producto por nombre...">
                        <button class="btn btn-outline-primary" type="submit">
                            <i class="fa-solid fa-search"></i>
                        </button>
                        <% if(buscar != null && !buscar.trim().isEmpty()) { %>
                        <a href="frmListadoProductoSinStock.jsp" class="btn btn-outline-secondary" title="Limpiar búsqueda">
                            <i class="fa-solid fa-times"></i>
                        </a>
                        <% } %>
                    </div>
                </form>
                
                <% if(buscar != null && !buscar.trim().isEmpty()) { %>
                <div class="search-info mt-2">
                    <i class="fa-solid fa-search me-1"></i>
                    Resultados de búsqueda para: <strong>"<%= buscar %>"</strong>
                    <span class="badge bg-primary ms-2"><%= totalProductos %> productos encontrados</span>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Estadísticas simplificadas -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card stats-card border-start border-primary border-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted mb-0">Total de Productos</h6>
                                <h3 class="mb-0"><%= totalProductos %></h3>
                                <small class="text-muted">Productos en el catálogo</small>
                            </div>
                            <div class="icon-circle bg-primary text-white">
                                <i class="fa-solid fa-boxes"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de productos simplificada -->
        <div class="table-container">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Producto</th>
                            <th>Precio de Venta</th>
                            <th>Disponibilidad</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if(productos.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="5">
                                <div class="empty-state">
                                    <i class="fa-solid fa-box-open text-muted"></i>
                                    <h4 class="text-muted mb-3">
                                        <% if(buscar != null && !buscar.trim().isEmpty()) { %>
                                        No se encontraron productos para "<%= buscar %>"
                                        <% } else { %>
                                        No hay productos en el catálogo
                                        <% } %>
                                    </h4>
                                    <p class="text-muted mb-4">Comienza agregando tu primer producto</p>
                                    <a href="frmInsertaProducto.jsp" class="btn btn-primary">
                                        <i class="fa-solid fa-plus me-2"></i>Agregar Producto
                                    </a>
                                    <% if(buscar != null && !buscar.trim().isEmpty()) { %>
                                    <a href="frmListadoProductoSinStock.jsp" class="btn btn-outline-secondary ms-2">
                                        <i class="fa-solid fa-list me-2"></i>Ver todos los productos
                                    </a>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <%
                            } else {
                                for(Producto producto : productos){
                                    // Determinar disponibilidad simple (sí/no)
                                    boolean disponible = producto.getStock() > 0;
                        %>
                        <tr>
                            <td><span class="badge bg-secondary">#<%= producto.getIdProducto() %></span></td>
                            <td>
                                <strong><%= producto.getNombre() %></strong>
                                <% if(producto.getStock() > 0 && producto.getStock() <= 5) { %>
                                <span class="badge bg-warning ms-2">Pocas unidades</span>
                                <% } %>
                            </td>
                            <td>
                                <span class="fw-bold text-primary">$<%= String.format("%.2f", producto.getPrecioVenta()) %></span>
                                <br>
                                <small class="text-muted">Por unidad</small>
                            </td>
                            <td>
                                <span class="d-flex align-items-center">
                                    <span class="product-status <%= disponible ? "status-available" : "status-unavailable" %>"></span>
                                    <%= disponible ? "Disponible" : "No disponible" %>
                                </span>
                                <% if(disponible && producto.getStock() > 0) { %>
                                <small class="text-muted d-block mt-1">
                                    <% if(producto.getStock() == 1) { %>
                                    Última unidad
                                    <% } else if(producto.getStock() <= 5) { %>
                                    Solo <%= producto.getStock() %> unidades
                                    <% } else { %>
                                    Suficiente stock
                                    <% } %>
                                </small>
                                <% } %>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <a href="frmActualizarProducto.jsp?id=<%= producto.getIdProducto() %>" 
                                       class="btn btn-outline-primary btn-action" 
                                       title="Editar producto">
                                        <i class="fa-solid fa-edit"></i> Editar
                                    </a>
                                    <a href="frmListadoProductoSinStock.jsp?eliminar=<%= producto.getIdProducto() %>" 
                                       class="btn btn-outline-danger btn-action" 
                                       title="Eliminar producto"
                                       onclick="return confirm('¿Estás seguro de eliminar: <%= producto.getNombre() %>?')">
                                        <i class="fa-solid fa-trash"></i> Eliminar
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Información adicional -->
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="alert alert-light border">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="alert-heading mb-1">
                                <i class="fa-solid fa-circle-info me-2"></i>Información del Catálogo
                            </h6>
                            <p class="mb-0">
                                <i class="fa-solid fa-circle status-available me-1"></i>Disponible | 
                                <i class="fa-solid fa-circle status-unavailable ms-3 me-1"></i>No disponible
                            </p>
                        </div>
                        <div>
                            <a href="frmInsertaProducto.jsp" class="btn btn-primary">
                                <i class="fa-solid fa-plus me-2"></i>Agregar Nuevo Producto
                            </a>
                        </div>
                    </div>
                </div>
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
                        <a href="frmMenu.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-home me-1"></i>Inicio
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

    <!-- Bootstrap JS (solo para componentes de Bootstrap) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>