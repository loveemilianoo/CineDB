<%@page import="entity.Producto"%>
<%@page import="dao.ProductoDAO"%>
<%@page import="java.math.BigDecimal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // ============================================
    // 1. OBTENER ID DEL PRODUCTO A EDITAR
    // ============================================
    String idParam = request.getParameter("id");
    Producto producto = null;
    ProductoDAO dao = new ProductoDAO();
    
    if(idParam != null && !idParam.trim().isEmpty()) {
        try {
            int idProducto = Integer.parseInt(idParam);
            producto = dao.getProductoPorId(idProducto);
        } catch (NumberFormatException e) {
            // ID inválido
        }
    }
    
    // ============================================
    // 2. PROCESAR ACTUALIZACIÓN
    // ============================================
    String mensaje = "";
    String tipoMensaje = "";
    
    if("POST".equals(request.getMethod())) {
        try {
            String nombre = request.getParameter("nombre");
            String precioStr = request.getParameter("precio");
            String stockStr = request.getParameter("stock");
            String idStr = request.getParameter("idProducto");
            
            // Validar campos obligatorios
            if(nombre != null && !nombre.trim().isEmpty() &&
               precioStr != null && !precioStr.trim().isEmpty() &&
               stockStr != null && !stockStr.trim().isEmpty() &&
               idStr != null && !idStr.trim().isEmpty()) {
                
                int idProducto = Integer.parseInt(idStr);
                BigDecimal precio = new BigDecimal(precioStr);
                int stock = Integer.parseInt(stockStr);
                
                // Crear objeto Producto con los datos actualizados
                Producto productoActualizado = new Producto(idProducto, nombre, precio, stock);
                
                // Actualizar en la base de datos
                dao.actualizarProducto(productoActualizado);
                
                mensaje = "Producto actualizado exitosamente";
                tipoMensaje = "success";
                
                // Recargar datos del producto
                producto = dao.getProductoPorId(idProducto);
            } else {
                mensaje = "Todos los campos son requeridos";
                tipoMensaje = "danger";
            }
        } catch (NumberFormatException e) {
            mensaje = "Error en el formato de los números";
            tipoMensaje = "danger";
        } catch (Exception e) {
            mensaje = "Error al actualizar el producto: " + e.getMessage();
            tipoMensaje = "danger";
            e.printStackTrace();
        }
    }
    
    // ============================================
    // 3. REDIRIGIR SI NO HAY PRODUCTO
    // ============================================
    if(producto == null && !"POST".equals(request.getMethod())) {
        response.sendRedirect("frmListadoProducto.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Actualizar Producto - Cine Prototype</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(125deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 0;
        }
        .form-card {
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            border: none;
            margin-top: -50px;
        }
        .form-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: -40px auto 20px;
            font-size: 2rem;
        }
        .required-field::after {
            content: " *";
            color: #dc3545;
        }
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
        }
        .simple-form {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
        }
        .product-id {
            background-color: #e9ecef;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .stock-indicator {
            display: inline-block;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            margin-right: 8px;
        }
        .stock-high { background-color: #28a745; }
        .stock-low { background-color: #fd7e14; }
        .stock-zero { background-color: #dc3545; }
        .stock-info-box {
            background-color: #e9f7ef;
            border-radius: 5px;
            padding: 15px;
            margin-top: 10px;
            border-left: 4px solid #28a745;
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
                    <li class="nav-item"><a class="nav-link" href="frmSeleccionarComida.jsp"><i class="fa-solid fa-utensils me-1"></i>Comida</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link active dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fa-solid fa-sliders me-1"></i>Administrar
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="frmListadoPeliculas.jsp"><i class="fa-solid fa-film me-2"></i>Películas</a></li>
                            <li><a class="dropdown-item" href="frmListadoProducto.jsp"><i class="fa-solid fa-pizza-slice me-2"></i>Productos</a></li>
                            <li><a class="dropdown-item" href="frmSeleccionarFuncion.jsp"><i class="fa-solid fa-calendar me-2"></i>Funciones</a></li>
                            <li><a class="dropdown-item" href="frmListadoBoletos.jsp"><i class="fa-solid fa-ticket me-2"></i>Boletos</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Header -->
    <header class="hero-section">
        <div class="container">
            <div class="hero-content d-flex flex-column align-items-center justify-content-center text-center">
                <h1 class="display-4 fw-bold mb-3">Editar Producto</h1>
                <p class="lead mb-0">Modifica la información del producto</p>
            </div>
        </div>
    </header>

    <main class="container my-5">
        <% if(!mensaje.isEmpty()) { %>
        <div class="row justify-content-center mb-4">
            <div class="col-md-8">
                <div class="alert alert-<%= tipoMensaje %> alert-dismissible fade show">
                    <%= mensaje %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </div>
        <% } %>
        
        <div class="row justify-content-center">
            <div class="col-md-8">
                <!-- Formulario de edición -->
                <div class="card form-card">
                    <div class="form-icon bg-warning text-white">
                        <i class="fa-solid fa-edit"></i>
                    </div>
                    <div class="card-body p-4">
                        <h2 class="card-title text-center mb-4">Información del Producto</h2>
                        
                        <!-- Información del ID -->
                        <% if(producto != null) { 
                            // Determinar color del indicador de stock
                            String stockClass = "stock-zero";
                            String stockTexto = "Sin stock";

                            if(producto.getStock() > 5) {
                                stockClass = "stock-high";
                                stockTexto = "Disponible";
                            } else if(producto.getStock() > 0) {
                                stockClass = "stock-low";
                                stockTexto = "Stock bajo";
                            }
                        %>
                        <div class="product-id">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="fa-solid fa-hashtag me-2"></i>
                                    <strong>ID del Producto:</strong>
                                    <span class="badge bg-secondary ms-2">#<%= producto.getIdProducto() %></span>
                                </div>
                                <div>
                                    <span class="stock-indicator <%= stockClass %>"></span>
                                    <span class="fw-bold"><%= stockTexto %></span>
                                </div>
                            </div>
                        </div>
                        <% } %>
                        
                        <div class="simple-form">
                            <form method="POST" action="frmActualizarProducto.jsp">
                                <!-- Campo oculto para el ID -->
                                <input type="hidden" name="idProducto" value="<%= producto != null ? producto.getIdProducto() : "" %>">
                                
                                <!-- Nombre del Producto -->
                                <div class="mb-4">
                                    <label for="nombre" class="form-label required-field fw-bold">
                                        <i class="fa-solid fa-tag me-2"></i>Nombre del Producto
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="nombre" 
                                           name="nombre" 
                                           required
                                           value="<%= producto != null ? producto.getNombre() : "" %>"
                                           placeholder="Ej: Palomitas, Refresco, Hot Dog">
                                </div>
                                
                                <!-- Precio -->
                                <div class="mb-4">
                                    <label for="precio" class="form-label required-field fw-bold">
                                        <i class="fa-solid fa-dollar-sign me-2"></i>Precio
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" 
                                               class="form-control" 
                                               id="precio" 
                                               name="precio" 
                                               required
                                               min="0" 
                                               step="0.01"
                                               value="<%= producto != null ? String.format("%.2f", producto.getPrecioVenta()) : "0.00" %>"
                                               placeholder="0.00">
                                    </div>
                                </div>
                                
                                <!-- STOCK (Cantidad) -->
                                <div class="mb-4">
                                    <label for="stock" class="form-label required-field fw-bold">
                                        <i class="fa-solid fa-boxes-stacked me-2"></i>Cantidad en Stock
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fa-solid fa-cube"></i>
                                        </span>
                                        <input type="number" 
                                               class="form-control" 
                                               id="stock" 
                                               name="stock" 
                                               required
                                               min="0"
                                               value="<%= producto != null ? producto.getStock() : "0" %>"
                                               placeholder="0">
                                        <span class="input-group-text">unidades</span>
                                    </div>
                                    <div class="form-text">
                                        Ingresa la cantidad disponible en inventario.
                                    </div>
                                    
                                    <!-- Información sobre niveles de stock -->
                                    <div class="stock-info-box">
                                        <h6 class="fw-bold">
                                            <i class="fa-solid fa-chart-line me-2"></i>Niveles de Stock:
                                        </h6>
                                        <ul class="list-unstyled mb-0">
                                            <li>
                                                <span class="stock-indicator stock-high"></span>
                                                <strong>Disponible:</strong> Más de 5 unidades
                                            </li>
                                            <li>
                                                <span class="stock-indicator stock-low"></span>
                                                <strong>Stock Bajo:</strong> Entre 1 y 5 unidades
                                            </li>
                                            <li>
                                                <span class="stock-indicator stock-zero"></span>
                                                <strong>Sin Stock:</strong> 0 unidades
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                
                                <!-- Información adicional -->
                                <% if(producto != null) { 
                                    BigDecimal valorTotal = producto.getPrecioVenta().multiply(new BigDecimal(producto.getStock()));
                                %>
                                <div class="alert alert-info">
                                    <div class="d-flex">
                                        <div class="me-3">
                                            <i class="fa-solid fa-calculator fa-2x"></i>
                                        </div>
                                        <div>
                                            <h6 class="alert-heading">Resumen del inventario</h6>
                                            <p class="mb-0 small">
                                                <strong>Stock actual:</strong> <%= producto.getStock() %> unidades<br>
                                                <strong>Precio unitario:</strong> $<%= String.format("%.2f", producto.getPrecioVenta()) %><br>
                                                <strong>Valor total del stock:</strong> $<%= String.format("%.2f", valorTotal) %>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <% } %>
                                
                                <!-- Botones de acción -->
                                <div class="d-flex justify-content-between mt-4 pt-3 border-top">
                                    <div>
                                        <a href="frmListadoProducto.jsp" class="btn btn-outline-secondary">
                                            <i class="fa-solid fa-arrow-left me-2"></i>Volver al Listado
                                        </a>
                                    </div>
                                    <div>
                                        <a href="frmListadoProducto.jsp?eliminar=<%= producto != null ? producto.getIdProducto() : "" %>" 
                                           class="btn btn-outline-danger me-2"
                                           onclick="return confirm('¿Estás seguro de eliminar este producto?')">
                                            <i class="fa-solid fa-trash me-2"></i>Eliminar
                                        </a>
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fa-solid fa-floppy-disk me-2"></i>Actualizar Producto
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                
                <!-- Enlace a crear nuevo producto -->
                <div class="text-center mt-4">
                    <a href="frmInsertaProducto.jsp" class="text-decoration-none">
                        <i class="fa-solid fa-plus-circle me-1"></i>
                        Crear nuevo producto
                    </a>
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
                        <a href="frmListadoProducto.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-utensils me-1"></i>Productos
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

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>