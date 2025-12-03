<%@page import="entity.Producto"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductoDAO"%>
<%@page import="java.math.BigDecimal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gestión de Productos - Cine Prototype</title>
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
        .badge-stock {
            font-size: 0.85em;
            padding: 5px 10px;
        }
        .btn-action {
            border-radius: 6px;
            padding: 5px 12px;
            font-size: 0.9rem;
            transition: all 0.2s;
        }
        .btn-action:hover {
            transform: translateY(-2px);
        }
        .search-box {
            max-width: 400px;
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
            width: 60px;
            height: 3px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
                            <li><a class="dropdown-item active" href="frmListadoProducto.jsp"><i class="fa-solid fa-tags me-2"></i>Productos</a></li>
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
                <h1 class="display-4 fw-bold mb-3">Gestión de Productos</h1>
                <p class="lead mb-0">Administra todos los productos disponibles en el cine</p>
                
                <!-- Botón Nuevo Producto abajo del título -->
                <div class="action-buttons">
                    <a href="frmGuardaProducto.jsp" class="btn btn-light btn-primary-lg">
                        <i class="fa-solid fa-plus me-2"></i>Nuevo Producto
                    </a>
                </div>
            </div>
        </div>
    </header>

    <main class="container my-5">
        <!-- Barra de búsqueda y filtros -->
        <div class="row mb-4">
            <div class="col-md-8">
                <div class="input-group search-box">
                    <input type="text" class="form-control" placeholder="Buscar producto por nombre..." id="searchInput">
                    <button class="btn btn-outline-primary" type="button" id="searchBtn">
                        <i class="fa-solid fa-search"></i>
                    </button>
                </div>
            </div>
            <div class="col-md-4 text-end">
                <div class="btn-group">
                    <a href="frmListadoProducto.jsp" class="btn btn-outline-primary">Todos</a>
                    <a href="frmListadoProductoConStock.jsp" class="btn btn-outline-success">Con Stock</a>
                </div>
            </div>
        </div>

        <!-- Sección de estadísticas -->
        <%
            ProductoDAO dao = new ProductoDAO();
            List<Producto> productos = dao.getProductos();
            int totalProductos = 0;
            int productosSinStock = 0;
            int productosStockBajo = 0;
            BigDecimal valorTotalInventario = BigDecimal.ZERO;
            
            for(Producto producto : productos) {
                totalProductos++;
                valorTotalInventario = valorTotalInventario.add(
                    producto.getPrecioVenta().multiply(new BigDecimal(producto.getStock()))
                );
                
                if(producto.getStock() == 0) {
                    productosSinStock++;
                } else if(producto.getStock() <= 5) {
                    productosStockBajo++;
                }
            }
        %>
        
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card border-start border-primary border-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted mb-0">Total Productos</h6>
                                <h3 class="mb-0"><%= totalProductos %></h3>
                            </div>
                            <div class="icon-circle bg-primary text-white">
                                <i class="fa-solid fa-boxes"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-start border-success border-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted mb-0">Disponibles</h6>
                                <h3 class="mb-0"><%= totalProductos - productosSinStock - productosStockBajo %></h3>
                            </div>
                            <div class="icon-circle bg-success text-white">
                                <i class="fa-solid fa-check-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-start border-warning border-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted mb-0">Stock Bajo</h6>
                                <h3 class="mb-0"><%= productosStockBajo %></h3>
                            </div>
                            <div class="icon-circle bg-warning text-white">
                                <i class="fa-solid fa-exclamation-triangle"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-start border-danger border-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted mb-0">Sin Stock</h6>
                                <h3 class="mb-0"><%= productosSinStock %></h3>
                            </div>
                            <div class="icon-circle bg-danger text-white">
                                <i class="fa-solid fa-times-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de productos -->
        <div class="table-container">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Producto</th>
                            <th>Precio</th>
                            <th>Stock</th>
                            <th>Estado</th>
                            <th>Valor Total</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if(productos.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="7">
                                <div class="empty-state">
                                    <i class="fa-solid fa-box-open text-muted"></i>
                                    <h4 class="text-muted mb-3">No hay productos registrados</h4>
                                    <p class="text-muted mb-4">Comienza agregando tu primer producto</p>
                                    <a href="frmGuardaProducto.jsp" class="btn btn-primary">
                                        <i class="fa-solid fa-plus me-2"></i>Agregar Producto
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <%
                            } else {
                                for(Producto producto : productos){
                                    String badgeClass = "bg-success";
                                    String estadoTexto = "Disponible";
                                    
                                    if(producto.getStock() == 0) {
                                        badgeClass = "bg-danger";
                                        estadoTexto = "Sin Stock";
                                    } else if(producto.getStock() <= 5) {
                                        badgeClass = "bg-warning";
                                        estadoTexto = "Stock Bajo";
                                    }
                                    
                                    BigDecimal valorTotal = producto.getPrecioVenta()
                                        .multiply(new BigDecimal(producto.getStock()));
                        %>
                        <tr>
                            <td><span class="badge bg-secondary">#<%= producto.getIdProducto() %></span></td>
                            <td>
                                <strong><%= producto.getNombre() %></strong>
                            </td>
                            <td>
                                <span class="fw-bold text-primary">$<%= String.format("%.2f", producto.getPrecioVenta()) %></span>
                            </td>
                            <td>
                                <span class="fw-bold <%= producto.getStock() == 0 ? "text-danger" : "text-dark" %>">
                                    <%= producto.getStock() %> unidades
                                </span>
                            </td>
                            <td>
                                <span class="badge <%= badgeClass %> badge-stock">
                                    <%= estadoTexto %>
                                </span>
                            </td>
                            <td>
                                <span class="fw-bold">$<%= String.format("%.2f", valorTotal) %></span>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <a href="frmActualizarProducto.jsp?id=<%= producto.getIdProducto() %>" 
                                       class="btn btn-outline-primary btn-action" 
                                       title="Editar producto">
                                        <i class="fa-solid fa-edit"></i>
                                    </a>
                                    <button type="button" 
                                            class="btn btn-outline-danger btn-action" 
                                            onclick="confirmarEliminacion(<%= producto.getIdProducto() %>, '<%= producto.getNombre() %>')"
                                            title="Eliminar producto">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
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

        <!-- Resumen del valor del inventario -->
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="alert alert-info d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="alert-heading mb-1">
                            <i class="fa-solid fa-chart-line me-2"></i>Valor Total del Inventario
                        </h5>
                        <p class="mb-0">Valor estimado de todo el stock disponible</p>
                    </div>
                    <div>
                        <h3 class="mb-0 text-dark">$<%= String.format("%.2f", valorTotalInventario) %></h3>
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

    <!-- Modal de confirmación -->
    <div class="modal fade" id="confirmModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p id="modalMessage">¿Estás seguro de eliminar este producto?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Eliminar</a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Estilos adicionales
        document.head.innerHTML += '<style>' +
            '.icon-circle { width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; }' +
            '</style>';
        
        // Función para confirmar eliminación
        function confirmarEliminacion(id, nombre) {
            const modal = new bootstrap.Modal(document.getElementById('confirmModal'));
            document.getElementById('modalMessage').textContent = 
                `¿Estás seguro de eliminar el producto: "${nombre}"? Esta acción no se puede deshacer.`;
            document.getElementById('confirmDeleteBtn').href = 
                `EliminarProductoServlet?id=${id}`;
            modal.show();
        }
        
        // Búsqueda en tiempo real
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            });
        });
        
        // Botón de búsqueda
        document.getElementById('searchBtn').addEventListener('click', function() {
            const searchInput = document.getElementById('searchInput');
            if(searchInput.value.trim()) {
                // Aquí puedes implementar búsqueda en servidor si lo prefieres
                window.location.href = `frmBuscarProducto.jsp?nombre=${encodeURIComponent(searchInput.value)}`;
            }
        });
    </script>
</body>
</html>