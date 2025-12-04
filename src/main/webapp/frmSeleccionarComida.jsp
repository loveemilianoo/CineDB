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
        <div class="row">
            <!-- Columna de productos -->
            <div class="col-lg-8">
                <div class="mb-4">
                    <h2 class="section-title">Catálogo de Productos</h2>
                    
                    <div class="category-filter mb-4">
                        <button class="btn btn-outline-success active" data-category="all">Todos</button>
                        <button class="btn btn-outline-success" data-category="combo">Combos</button>
                        <button class="btn btn-outline-success" data-category="snack">Snacks</button>
                        <button class="btn btn-outline-success" data-category="bebida">Bebidas</button>
                        <button class="btn btn-outline-success" data-category="dulce">Dulces</button>
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
                                
                                // Asignar categoría basada en nombre (esto es temporal)
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
                                    <button class="btn btn-success btn-sm agregar-carrito" 
                                            data-id="<%= producto.getIdProducto() %>"
                                            data-nombre="<%= producto.getNombre() %>"
                                            data-precio="<%= producto.getPrecioVenta() %>"
                                            data-stock="<%= producto.getStock() %>">
                                        <i class="fa-solid fa-cart-plus me-1"></i>Agregar
                                    </button>
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
                    
                    <div id="carritoVacio" class="empty-cart">
                        <i class="fa-solid fa-cart-shopping fa-3x mb-3"></i>
                        <h5>Tu carrito está vacío</h5>
                        <p class="mb-0">Agrega productos desde el catálogo</p>
                    </div>
                    
                    <div id="carritoContenido" style="display: none;">
                        <div id="carritoItems" class="mb-4">
                            <!-- Los items del carrito se agregarán aquí -->
                        </div>
                        
                        <div class="mb-3">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">Subtotal:</span>
                                <span id="subtotal" class="fw-bold">Q0.00</span>
                            </div>
                            <div class="d-flex justify-content-between mb-3">
                                <span class="text-muted">Total:</span>
                                <h4 id="total" class="text-success mb-0">Q0.00</h4>
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <button id="btnProcesarPedido" class="btn btn-success btn-success-lg">
                                <i class="fa-solid fa-credit-card me-2"></i>Procesar Pedido
                            </button>
                            <button id="btnVaciarCarrito" class="btn btn-outline-danger">
                                <i class="fa-solid fa-trash me-2"></i>Vaciar Carrito
                            </button>
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
        // Carrito de compras
        let carrito = [];
        
        // Filtro por categoría
        document.querySelectorAll('.category-filter .btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.category-filter .btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                
                const categoria = this.getAttribute('data-category');
                document.querySelectorAll('.producto-item').forEach(item => {
                    if(categoria === 'all' || item.getAttribute('data-category') === categoria) {
                        item.style.display = 'block';
                    } else {
                        item.style.display = 'none';
                    }
                });
            });
        });
        
        // Agregar al carrito
        document.querySelectorAll('.agregar-carrito').forEach(btn => {
            btn.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const nombre = this.getAttribute('data-nombre');
                const precio = parseFloat(this.getAttribute('data-precio'));
                const stock = parseInt(this.getAttribute('data-stock'));
                
                // Verificar si ya está en el carrito
                const index = carrito.findIndex(item => item.id === id);
                
                if(index === -1) {
                    // Agregar nuevo item
                    if(stock > 0) {
                        carrito.push({
                            id: id,
                            nombre: nombre,
                            precio: precio,
                            cantidad: 1,
                            stock: stock
                        });
                    } else {
                        alert('No hay stock disponible de este producto');
                        return;
                    }
                } else {
                    // Incrementar cantidad si hay stock
                    if(carrito[index].cantidad < carrito[index].stock) {
                        carrito[index].cantidad++;
                    } else {
                        alert('No hay más stock disponible de este producto');
                        return;
                    }
                }
                
                actualizarCarrito();
                mostrarNotificacion(`${nombre} agregado al carrito`);
            });
        });
        
        // Actualizar carrito
        function actualizarCarrito() {
            const carritoItems = document.getElementById('carritoItems');
            const carritoVacio = document.getElementById('carritoVacio');
            const carritoContenido = document.getElementById('carritoContenido');
            
            if(carrito.length === 0) {
                carritoVacio.style.display = 'block';
                carritoContenido.style.display = 'none';
                return;
            }
            
            carritoVacio.style.display = 'none';
            carritoContenido.style.display = 'block';
            
            carritoItems.innerHTML = '';
            let subtotal = 0;
            
            carrito.forEach((item, index) => {
                const totalItem = item.precio * item.cantidad;
                subtotal += totalItem;
                
                carritoItems.innerHTML += `
                    <div class="cart-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">${item.nombre}</h6>
                                <p class="text-muted small mb-0">Q${item.precio.toFixed(2)} c/u</p>
                            </div>
                            <button class="btn btn-sm btn-outline-danger eliminar-item" data-index="${index}">
                                <i class="fa-solid fa-times"></i>
                            </button>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <div class="quantity-control">
                                <div class="input-group input-group-sm">
                                    <button class="btn btn-outline-secondary decrementar" data-index="${index}">-</button>
                                    <input type="text" class="form-control text-center" value="${item.cantidad}" readonly>
                                    <button class="btn btn-outline-secondary incrementar" data-index="${index}" ${item.cantidad >= item.stock ? 'disabled' : ''}>+</button>
                                </div>
                            </div>
                            <span class="fw-bold">Q${totalItem.toFixed(2)}</span>
                        </div>
                    </div>
                `;
            });
            
            document.getElementById('subtotal').textContent = `Q${subtotal.toFixed(2)}`;
            document.getElementById('total').textContent = `Q${subtotal.toFixed(2)}`;
            
            // Agregar eventos a los botones del carrito
            document.querySelectorAll('.eliminar-item').forEach(btn => {
                btn.addEventListener('click', function() {
                    const index = parseInt(this.getAttribute('data-index'));
                    carrito.splice(index, 1);
                    actualizarCarrito();
                });
            });
            
            document.querySelectorAll('.decrementar').forEach(btn => {
                btn.addEventListener('click', function() {
                    const index = parseInt(this.getAttribute('data-index'));
                    if(carrito[index].cantidad > 1) {
                        carrito[index].cantidad--;
                        actualizarCarrito();
                    }
                });
            });
            
            document.querySelectorAll('.incrementar').forEach(btn => {
                btn.addEventListener('click', function() {
                    const index = parseInt(this.getAttribute('data-index'));
                    if(carrito[index].cantidad < carrito[index].stock) {
                        carrito[index].cantidad++;
                        actualizarCarrito();
                    }
                });
            });
        }
        
        // Vaciar carrito
        document.getElementById('btnVaciarCarrito').addEventListener('click', function() {
            if(carrito.length > 0 && confirm('¿Estás seguro de vaciar el carrito?')) {
                carrito = [];
                actualizarCarrito();
                mostrarNotificacion('Carrito vaciado');
            }
        });
        
        // Procesar pedido
        document.getElementById('btnProcesarPedido').addEventListener('click', function() {
            if(carrito.length === 0) {
                alert('El carrito está vacío');
                return;
            }
            
            if(confirm('¿Confirmar pedido?')) {
                // Aquí iría la lógica para guardar el pedido en la BD
                alert('Pedido procesado exitosamente');
                carrito = [];
                actualizarCarrito();
                mostrarNotificacion('Pedido realizado con éxito');
            }
        });
        
        // Notificación
        function mostrarNotificacion(mensaje) {
            const notificacion = document.createElement('div');
            notificacion.className = 'position-fixed bottom-0 end-0 m-3 p-3 bg-success text-white rounded shadow-lg';
            notificacion.style.zIndex = '1050';
            notificacion.innerHTML = `
                <div class="d-flex align-items-center">
                    <i class="fa-solid fa-check-circle me-2"></i>
                    <span>${mensaje}</span>
                </div>
            `;
            
            document.body.appendChild(notificacion);
            
            setTimeout(() => {
                notificacion.remove();
            }, 3000);
        }
        
        // Inicializar
        actualizarCarrito();
    </script>
</body>
</html>