<%@page import="entity.Producto"%>
<%@page import="dao.ProductoDAO"%>
<%@page import="java.math.BigDecimal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Procesar el formulario cuando se envía
    if("POST".equals(request.getMethod())) {
        try {
            String nombre = request.getParameter("nombre");
            String precioStr = request.getParameter("precio");
            String disponible = request.getParameter("disponible");
            
            // Validar campos obligatorios
            if(nombre != null && !nombre.trim().isEmpty() &&
               precioStr != null && !precioStr.trim().isEmpty()) {
                
                BigDecimal precio = new BigDecimal(precioStr);
                int stock = "si".equals(disponible) ? 1 : 0;
                
                // CORRECCIÓN: Usar constructor con parámetros
                // ID temporal = 0, la BD generará el real
                Producto producto = new Producto(0, nombre, precio, stock);
                
                // Insertar en la base de datos
                ProductoDAO dao = new ProductoDAO();
                dao.insertarProducto(producto);
                
                // Redirigir al listado sin stock
                response.sendRedirect("frmListadoProductoSinStock.jsp");
                return;
            }
        } catch (NumberFormatException e) {
            // Manejar error de formato numérico
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Nuevo Producto - Cine Prototype</title>
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
        .availability-badge {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 8px;
        }
        .available-badge {
            background-color: #28a745;
        }
        .unavailable-badge {
            background-color: #dc3545;
        }
        .simple-form {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
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
                            <li><a class="dropdown-item" href="frmListadoProductoSinStock.jsp"><i class="fa-solid fa-tags me-2"></i>Productos</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fa-solid fa-calendar me-2"></i>Funciones</a></li>
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
            <div class="hero-content">
                <h1 class="display-4 fw-bold mb-3">Nuevo Producto</h1>
                <p class="lead mb-0">Agrega un producto al catálogo</p>
            </div>
        </div>
    </header>

    <main class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <!-- Formulario simplificado -->
                <div class="card form-card">
                    <div class="form-icon bg-success text-white">
                        <i class="fa-solid fa-cart-plus"></i>
                    </div>
                    <div class="card-body p-4">
                        <h2 class="card-title text-center mb-4">Información Básica del Producto</h2>
                        
                        <div class="simple-form">
                            <form method="POST" action="frmGuardaProductoSinStock.jsp">
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
                                               placeholder="0.00">
                                    </div>
                                </div>
                                
                                <!-- Disponibilidad (Sí/No) -->
                                <div class="mb-4">
                                    <label class="form-label fw-bold d-block mb-3">
                                        <i class="fa-solid fa-circle-check me-2"></i>Disponibilidad
                                    </label>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" 
                                               type="radio" 
                                               name="disponible" 
                                               id="disponibleSi" 
                                               value="si" 
                                               checked>
                                        <label class="form-check-label" for="disponibleSi">
                                            <span class="availability-badge available-badge"></span>
                                            Disponible
                                        </label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" 
                                               type="radio" 
                                               name="disponible" 
                                               id="disponibleNo" 
                                               value="no">
                                        <label class="form-check-label" for="disponibleNo">
                                            <span class="availability-badge unavailable-badge"></span>
                                            No disponible
                                        </label>
                                    </div>
                                    <div class="form-text mt-2">
                                        Indica si el producto está disponible para la venta.
                                    </div>
                                </div>
                                
                                <!-- Botones de acción -->
                                <div class="d-flex justify-content-between mt-4 pt-3 border-top">
                                    <a href="frmListadoProductoSinStock.jsp" class="btn btn-outline-secondary">
                                        <i class="fa-solid fa-arrow-left me-2"></i>Cancelar
                                    </a>
                                    <div>
                                        <a href="frmGuardaProducto.jsp" class="btn btn-outline-primary me-2">
                                            <i class="fa-solid fa-boxes-stacked me-2"></i>Versión con Stock
                                        </a>
                                        <button type="submit" class="btn btn-success">
                                            <i class="fa-solid fa-floppy-disk me-2"></i>Guardar Producto
                                        </button>
                                    </div>
                                </div>
                            </form>
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
                        <a href="frmListadoProductoSinStock.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-popcorn me-1"></i>Productos
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