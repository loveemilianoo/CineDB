<%@page import="dao.ProductoDAO"%>
<%@page import="entity.Producto"%>
<%@page import="java.math.BigDecimal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            padding: 80px 0;
        }
        .form-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 40px;
            margin-top: -50px;
            margin-bottom: 40px;
        }
        .btn-primary-lg {
            padding: 12px 35px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 10px;
        }
        .required-field::after {
            content: " *";
            color: #dc3545;
        }
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }
        .form-control, .form-select {
            border-radius: 8px;
            padding: 12px 15px;
            border: 1px solid #ced4da;
            transition: all 0.3s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
        }
        .input-group-text {
            border-radius: 8px 0 0 8px;
            background-color: #f8f9fa;
        }
        .back-button {
            color: #6c757d;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        .back-button:hover {
            color: #495057;
        }
        .section-title {
            position: relative;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .section-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .alert-custom {
            border-left: 4px solid #667eea;
            border-radius: 8px;
        }
        .icon-circle {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
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
                    <li class="nav-item"><a class="nav-link" href="frmComida.jsp"><i class="fa-solid fa-popcorn me-1"></i>Comida</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link active dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fa-solid fa-sliders me-1"></i>Administrar
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="frmListadoPeliculas.jsp"><i class="fa-solid fa-film me-2"></i>Películas</a></li>
                            <li><a class="dropdown-item active" href="frmListadoProducto.jsp"><i class="fa-solid fa-tags me-2"></i>Productos</a></li>
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
                <h1 class="display-4 fw-bold mb-3">Nuevo Producto</h1>
                <p class="lead mb-0">Agrega un nuevo producto al catálogo del cine</p>
            </div>
        </div>
    </header>

    <main class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="form-container">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <a href="frmListadoProducto.jsp" class="back-button">
                            <i class="fa-solid fa-arrow-left me-2"></i>Volver al listado
                        </a>
                        <span class="badge bg-primary">Paso 1 de 1</span>
                    </div>

                    <form action="GuardarProductoServlet" method="POST" id="productoForm" onsubmit="return validarFormulario()">
                        <div class="row">
                            <div class="col-md-8">
                                <div class="mb-4">
                                    <h3 class="section-title">
                                        <i class="fa-solid fa-box-open text-primary me-2"></i>
                                        Información del Producto
                                    </h3>
                                    
                                    <div class="mb-4">
                                        <label for="nombre" class="form-label required-field">Nombre del Producto</label>
                                        <input type="text" class="form-control" 
                                               id="nombre" name="nombre" 
                                               placeholder="Ej: Combo Familiar, Palomitas Grandes, Refresco Grande, Nachos"
                                               required maxlength="100">
                                        <div class="form-text">Máximo 100 caracteres</div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-4">
                                            <label for="precio" class="form-label required-field">Precio de Venta</label>
                                            <div class="input-group">
                                                <span class="input-group-text">Q</span>
                                                <input type="number" class="form-control" 
                                                       id="precio" name="precio" 
                                                       step="0.01" min="0.01" 
                                                       placeholder="0.00" required>
                                                <span class="input-group-text">.00</span>
                                            </div>
                                            <div class="form-text">Precio en quetzales</div>
                                        </div>
                                        
                                        <div class="col-md-6 mb-4">
                                            <label for="stock" class="form-label required-field">Stock Inicial</label>
                                            <input type="number" class="form-control" 
                                                   id="stock" name="stock" 
                                                   min="0" value="10" required>
                                            <div class="form-text">Cantidad inicial en inventario</div>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <label for="categoria" class="form-label">Categoría</label>
                                        <select class="form-select" id="categoria" name="categoria">
                                            <option value="" selected>Selecciona una categoría</option>
                                            <option value="combo">Combo</option>
                                            <option value="snack">Snack</option>
                                            <option value="bebida">Bebida</option>
                                            <option value="dulce">Dulces</option>
                                            <option value="complemento">Complemento</option>
                                            <option value="otro">Otro</option>
                                        </select>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <label for="descripcion" class="form-label">Descripción</label>
                                        <textarea class="form-control" id="descripcion" name="descripcion" 
                                                  rows="4" placeholder="Describe el producto, ingredientes, tamaño, etc..."
                                                  maxlength="500"></textarea>
                                        <div class="form-text">Máximo 500 caracteres</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <div class="sticky-top" style="top: 20px;">
                                    <div class="alert alert-custom bg-light">
                                        <div class="d-flex align-items-start mb-3">
                                            <div class="icon-circle bg-primary text-white">
                                                <i class="fa-solid fa-lightbulb"></i>
                                            </div>
                                            <div>
                                                <h5 class="alert-heading mb-2">Recomendaciones</h5>
                                                <ul class="mb-0 ps-3 small">
                                                    <li>Usa nombres descriptivos</li>
                                                    <li>Verifica precios de la competencia</li>
                                                    <li>Mantén stock para 2-3 días</li>
                                                    <li>Clasifica por categorías</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="card border-0 shadow-sm mb-4">
                                        <div class="card-body">
                                            <h6 class="card-title mb-3">
                                                <i class="fa-solid fa-calculator text-success me-2"></i>
                                                Resumen
                                            </h6>
                                            <div class="mb-2 d-flex justify-content-between">
                                                <span class="text-muted">Precio unitario:</span>
                                                <span id="precioResumen" class="fw-bold">Q0.00</span>
                                            </div>
                                            <div class="mb-2 d-flex justify-content-between">
                                                <span class="text-muted">Stock inicial:</span>
                                                <span id="stockResumen" class="fw-bold">0 unidades</span>
                                            </div>
                                            <div class="mb-2 d-flex justify-content-between">
                                                <span class="text-muted">Valor total:</span>
                                                <span id="valorTotalResumen" class="fw-bold text-primary">Q0.00</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary btn-primary-lg">
                                            <i class="fa-solid fa-save me-2"></i>Guardar Producto
                                        </button>
                                        <a href="frmListadoProducto.jsp" class="btn btn-outline-secondary">
                                            <i class="fa-solid fa-times me-2"></i>Cancelar
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                
                <div class="alert alert-info">
                    <div class="d-flex">
                        <div class="me-3">
                            <i class="fa-solid fa-info-circle fs-4"></i>
                        </div>
                        <div>
                            <h5 class="alert-heading">Información importante</h5>
                            <p class="mb-0">Los productos agregados estarán disponibles inmediatamente para venta en el sistema. 
                            Asegúrate de que toda la información sea correcta antes de guardar.</p>
                        </div>
                    </div>
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
                    <div class="btn-group" role="group">
                        <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-light btn-sm">
                            <i class="fa-solid fa-ticket me-1"></i>Boletos
                        </a>
                        <a href="frmComida.jsp" class="btn btn-outline-light btn-sm">
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
        // Actualizar resumen en tiempo real
        function actualizarResumen() {
            const precio = parseFloat(document.getElementById('precio').value) || 0;
            const stock = parseInt(document.getElementById('stock').value) || 0;
            const valorTotal = precio * stock;
            
            document.getElementById('precioResumen').textContent = `Q${precio.toFixed(2)}`;
            document.getElementById('stockResumen').textContent = `${stock} unidades`;
            document.getElementById('valorTotalResumen').textContent = `Q${valorTotal.toFixed(2)}`;
        }
        
        // Event listeners para actualizar resumen
        document.getElementById('precio').addEventListener('input', actualizarResumen);
        document.getElementById('stock').addEventListener('input', actualizarResumen);
        
        // Validación del formulario
        function validarFormulario() {
            const nombre = document.getElementById('nombre').value.trim();
            const precio = document.getElementById('precio').value;
            const stock = document.getElementById('stock').value;
            
            // Validar nombre
            if (nombre === '') {
                alert('Por favor ingresa el nombre del producto');
                document.getElementById('nombre').focus();
                return false;
            }
            
            if (nombre.length > 100) {
                alert('El nombre no puede exceder los 100 caracteres');
                document.getElementById('nombre').focus();
                return false;
            }
            
            // Validar precio
            if (precio === '' || parseFloat(precio) <= 0) {
                alert('Por favor ingresa un precio válido mayor a Q0.00');
                document.getElementById('precio').focus();
                return false;
            }
            
            // Validar stock
            if (stock === '' || parseInt(stock) < 0) {
                alert('Por favor ingresa un stock válido (no puede ser negativo)');
                document.getElementById('stock').focus();
                return false;
            }
            
            // Validar descripción
            const descripcion = document.getElementById('descripcion').value;
            if (descripcion.length > 500) {
                alert('La descripción no puede exceder los 500 caracteres');
                document.getElementById('descripcion').focus();
                return false;
            }
            
            // Confirmación final
            return confirm('¿Estás seguro de guardar este nuevo producto?');
        }
        
        // Formatear precio automáticamente
        document.getElementById('precio').addEventListener('blur', function(e) {
            let value = parseFloat(e.target.value);
            if (isNaN(value) || value < 0) {
                e.target.value = '0.00';
            } else {
                e.target.value = value.toFixed(2);
            }
            actualizarResumen();
        });
        
        // Validar stock automáticamente
        document.getElementById('stock').addEventListener('blur', function(e) {
            let value = parseInt(e.target.value);
            if (isNaN(value) || value < 0) {
                e.target.value = '0';
            }
            actualizarResumen();
        });
        
        // Inicializar resumen
        actualizarResumen();
    </script>
</body>
</html>