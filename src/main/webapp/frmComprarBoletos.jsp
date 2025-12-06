<%@page import="dao.BoletoDAO"%>
<%@page import="dao.TransaccionDAO"%>
<%@page import="dao.FuncionDAO"%>
<%@page import="dao.SalaDAO"%>
<%@page import="dao.PeliculaDAO"%>
<%@page import="entity.*"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comprar Boletos - Cine</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 0;
        }
        .ticket-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            background: white;
            overflow: hidden;
        }
        .ticket-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .ticket-body {
            padding: 25px;
        }
        .price-tag {
            font-size: 2rem;
            font-weight: bold;
            color: #28a745;
        }
        .btn-comprar {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            border: none;
            color: white;
            padding: 15px 40px;
            border-radius: 25px;
            font-weight: bold;
        }
        .movie-info {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .summary-box {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }
        .alert {
            animation: fadeIn 0.5s;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .ticket-type-card {
            border: 2px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s;
        }
        .ticket-type-card.selected {
            border-color: #28a745;
            background-color: rgba(40, 167, 69, 0.05);
        }
        .ticket-type-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .ticket-type-badge {
            font-size: 0.8rem;
            padding: 5px 10px;
            border-radius: 20px;
        }
        .ticket-price {
            font-size: 1.5rem;
            font-weight: bold;
            color: #28a745;
        }
        .total-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            padding: 25px;
            margin-top: 30px;
        }
        .asiento-badge {
            background: #6c757d;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            margin: 3px;
            display: inline-block;
        }
        .divider {
            height: 1px;
            background: #dee2e6;
            margin: 20px 0;
        }
        
        /* ESTILO PARA EL SELECTOR DE CANTIDAD SIN JAVASCRIPT */
        .quantity-control {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 15px;
        }
        .quantity-label {
            font-weight: bold;
            color: #495057;
            margin-right: 15px;
        }
        .quantity-input-group {
            display: flex;
            align-items: center;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            overflow: hidden;
            background: white;
        }
        .quantity-btn {
            width: 45px;
            height: 45px;
            border: none;
            background: #f8f9fa;
            font-size: 1.5rem;
            font-weight: bold;
            color: #495057;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        .quantity-btn:hover {
            background: #e9ecef;
            color: #007bff;
        }
        .quantity-btn:disabled {
            background: #f8f9fa;
            color: #adb5bd;
            cursor: not-allowed;
        }
        .quantity-display {
            width: 70px;
            height: 45px;
            border: none;
            text-align: center;
            font-size: 1.3rem;
            font-weight: bold;
            color: #212529;
            background: white;
            pointer-events: none; /* Evita que el usuario escriba directamente */
        }
        .quantity-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
            padding: 8px 12px;
            background: #f8f9fa;
            border-radius: 6px;
            font-size: 0.9rem;
        }
        .max-tickets {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <%
    // Obtener parámetros de la función
    String idFuncionStr = request.getParameter("idFuncion");
    String idPeliculaStr = request.getParameter("idPelicula");
    String tituloPelicula = request.getParameter("tituloPelicula");
    String fechaFuncion = request.getParameter("fechaFuncion");
    String horaFuncion = request.getParameter("horaFuncion");
    String idSalaStr = request.getParameter("idSala");
    
    if (idFuncionStr == null || idPeliculaStr == null) {
        response.sendRedirect("frmSeleccionarPelicula.jsp");
        return;
    }
    
    int idFuncion = Integer.parseInt(idFuncionStr);
    int idPelicula = Integer.parseInt(idPeliculaStr);
    int idSala = Integer.parseInt(idSalaStr);
    
    // Obtener información
    PeliculaDAO peliculaDAO = new PeliculaDAO();
    SalaDAO salaDAO = new SalaDAO();
    FuncionDAO funcionDAO = new FuncionDAO();
    BoletoDAO boletoDAO = new BoletoDAO();
    
    Pelicula pelicula = peliculaDAO.getPeliculaPorId(idPelicula);
    Sala sala = salaDAO.getSalaPorId(idSala);
    Funcion funcion = funcionDAO.getFuncionPorId(idFuncion);
    
    // Obtener asientos ocupados
    List<String> asientosOcupados = boletoDAO.getAsientosOcupados(idFuncion);
    
    // Configuración
    int capacidadTotal = sala.getCapacidad();
    int asientosDisponibles = capacidadTotal - asientosOcupados.size();
    
    // Precios por tipo de boleto
    BigDecimal precioGeneral = new BigDecimal("75");
    BigDecimal precioNino = new BigDecimal("55");
    BigDecimal precioEstudiante = new BigDecimal("65");
    
    // Inicializar cantidades desde parámetros o inicializar en 0
    int cantidadGeneral = 0;
    int cantidadNino = 0;
    int cantidadEstudiante = 0;
    
    // Si viene de un POST, obtener las cantidades
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String generalStr = request.getParameter("cantidadGeneral");
        String ninoStr = request.getParameter("cantidadNino");
        String estudianteStr = request.getParameter("cantidadEstudiante");
        
        if (generalStr != null && !generalStr.trim().isEmpty()) {
            cantidadGeneral = Integer.parseInt(generalStr);
        }
        if (ninoStr != null && !ninoStr.trim().isEmpty()) {
            cantidadNino = Integer.parseInt(ninoStr);
        }
        if (estudianteStr != null && !estudianteStr.trim().isEmpty()) {
            cantidadEstudiante = Integer.parseInt(estudianteStr);
        }
    } 
    // Si viene de un GET, verificar si hay parámetros de ajuste
    else if ("GET".equalsIgnoreCase(request.getMethod())) {
        String ajusteGeneral = request.getParameter("ajusteGeneral");
        String ajusteNino = request.getParameter("ajusteNino");
        String ajusteEstudiante = request.getParameter("ajusteEstudiante");
        
        // Obtener valores actuales de la sesión si existen
        Integer sesionGeneral = (Integer) session.getAttribute("cantidadGeneral");
        Integer sesionNino = (Integer) session.getAttribute("cantidadNino");
        Integer sesionEstudiante = (Integer) session.getAttribute("cantidadEstudiante");
        
        if (sesionGeneral != null) cantidadGeneral = sesionGeneral;
        if (sesionNino != null) cantidadNino = sesionNino;
        if (sesionEstudiante != null) cantidadEstudiante = sesionEstudiante;
        
        // Aplicar ajustes desde los botones +/-
        if (ajusteGeneral != null) {
            if ("+".equals(ajusteGeneral)) {
                cantidadGeneral++;
            } else if ("-".equals(ajusteGeneral) && cantidadGeneral > 0) {
                cantidadGeneral--;
            }
        }
        
        if (ajusteNino != null) {
            if ("+".equals(ajusteNino)) {
                cantidadNino++;
            } else if ("-".equals(ajusteNino) && cantidadNino > 0) {
                cantidadNino--;
            }
        }
        
        if (ajusteEstudiante != null) {
            if ("+".equals(ajusteEstudiante)) {
                cantidadEstudiante++;
            } else if ("-".equals(ajusteEstudiante) && cantidadEstudiante > 0) {
                cantidadEstudiante--;
            }
        }
        
        // Guardar en sesión para mantener los valores entre clics
        session.setAttribute("cantidadGeneral", cantidadGeneral);
        session.setAttribute("cantidadNino", cantidadNino);
        session.setAttribute("cantidadEstudiante", cantidadEstudiante);
    }
    
    // Calcular total de boletos seleccionados
    int totalBoletos = cantidadGeneral + cantidadNino + cantidadEstudiante;
    
    // Procesar compra (solo cuando se presiona el botón de compra)
    if ("POST".equalsIgnoreCase(request.getMethod()) && "comprar".equals(request.getParameter("accion"))) {
        // Verificar disponibilidad
        if (totalBoletos > 0 && totalBoletos <= asientosDisponibles) {
            // Generar asientos automáticamente
            List<String> asientosAsignados = generarAsientosAutomaticos(idFuncion, totalBoletos, sala.getNumeroSala(), boletoDAO);
            
            if (!asientosAsignados.isEmpty()) {
                try {
                    // 1. Crear transacción
                    TransaccionDAO transaccionDAO = new TransaccionDAO();
                    
                    // Calcular total
                    BigDecimal totalGeneral = precioGeneral.multiply(new BigDecimal(cantidadGeneral));
                    BigDecimal totalNino = precioNino.multiply(new BigDecimal(cantidadNino));
                    BigDecimal totalEstudiante = precioEstudiante.multiply(new BigDecimal(cantidadEstudiante));
                    BigDecimal total = totalGeneral.add(totalNino).add(totalEstudiante);
                    
                    Transaccion transaccion = new Transaccion();
                    transaccion.setTotal(total);
                    transaccion.setMetodoPago("efectivo");
                    
                    int idTransaccion = transaccionDAO.crearTransaccion(transaccion);
                    
                    if (idTransaccion > 0) {
                        // 2. Crear boletos según tipo
                        boolean todosGuardados = true;
                        int asientoIndex = 0;
                        
                        // Boletos General
                        for (int i = 0; i < cantidadGeneral; i++) {
                            if (asientoIndex < asientosAsignados.size()) {
                                Boleto boleto = new Boleto();
                                boleto.setIdFuncion(idFuncion);
                                boleto.setIdTransaccion(idTransaccion);
                                boleto.setPrecio(precioGeneral);
                                boleto.setTipoBoleto("general");
                                boleto.setEstado("activo");
                                boleto.setAsiento(asientosAsignados.get(asientoIndex));
                                
                                Boleto resultado = boletoDAO.insertarBoleto(boleto);
                                if (resultado == null) {
                                    todosGuardados = false;
                                    break;
                                }
                                asientoIndex++;
                            }
                        }
                        
                        // Boletos Niño
                        for (int i = 0; i < cantidadNino; i++) {
                            if (asientoIndex < asientosAsignados.size()) {
                                Boleto boleto = new Boleto();
                                boleto.setIdFuncion(idFuncion);
                                boleto.setIdTransaccion(idTransaccion);
                                boleto.setPrecio(precioNino);
                                boleto.setTipoBoleto("niño");
                                boleto.setEstado("activo");
                                boleto.setAsiento(asientosAsignados.get(asientoIndex));
                                
                                Boleto resultado = boletoDAO.insertarBoleto(boleto);
                                if (resultado == null) {
                                    todosGuardados = false;
                                    break;
                                }
                                asientoIndex++;
                            }
                        }
                        
                        // Boletos Estudiante
                        for (int i = 0; i < cantidadEstudiante; i++) {
                            if (asientoIndex < asientosAsignados.size()) {
                                Boleto boleto = new Boleto();
                                boleto.setIdFuncion(idFuncion);
                                boleto.setIdTransaccion(idTransaccion);
                                boleto.setPrecio(precioEstudiante);
                                boleto.setTipoBoleto("estudiante");
                                boleto.setEstado("activo");
                                boleto.setAsiento(asientosAsignados.get(asientoIndex));
                                
                                Boleto resultado = boletoDAO.insertarBoleto(boleto);
                                if (resultado == null) {
                                    todosGuardados = false;
                                    break;
                                }
                                asientoIndex++;
                            }
                        }
                        
                        if (todosGuardados) {
                            // Guardar datos para transacción
                            session.setAttribute("compraExitosa", true);
                            session.setAttribute("asientosAsignados", asientosAsignados);
                            session.setAttribute("cantidadGeneral", cantidadGeneral);
                            session.setAttribute("cantidadNino", cantidadNino);
                            session.setAttribute("cantidadEstudiante", cantidadEstudiante);
                            session.setAttribute("totalCompra", total);
                            session.setAttribute("idTransaccion", idTransaccion);
                            session.setAttribute("idFuncion", idFuncion);
                            session.setAttribute("idPelicula", idPelicula);
                            session.setAttribute("tituloPelicula", tituloPelicula);
                            session.setAttribute("fechaFuncion", fechaFuncion);
                            session.setAttribute("horaFuncion", horaFuncion);
                            session.setAttribute("numeroSala", sala.getNumeroSala());
                            session.setAttribute("precioGeneral", precioGeneral);
                            session.setAttribute("precioNino", precioNino);
                            session.setAttribute("precioEstudiante", precioEstudiante);
                            
                            // Limpiar cantidades de la sesión
                            session.removeAttribute("cantidadGeneral");
                            session.removeAttribute("cantidadNino");
                            session.removeAttribute("cantidadEstudiante");
                            
                            // DEPURAR: Ver qué se está guardando en sesión
    System.out.println("DEBUG: Guardado en sesión - tituloPelicula: " + tituloPelicula);
    System.out.println("DEBUG: Guardado en sesión - fechaFuncion: " + fechaFuncion);
    System.out.println("DEBUG: Guardado en sesión - horaFuncion: " + horaFuncion);
    
    // Redirigir a transacción exitosa
    String redirectURL = "frmTransaccionBoleto.jsp?idTransaccion=" + idTransaccion;
    System.out.println("DEBUG: Redirigiendo a: " + redirectURL);
    response.sendRedirect(redirectURL);
    return;
                        } else {
                            out.println("<div class='alert alert-danger alert-dismissible fade show' role='alert'>");
                            out.println("<i class='fa-solid fa-triangle-exclamation me-2'></i>");
                            out.println("<strong>Error:</strong> No se pudieron crear todos los boletos.");
                            out.println("<button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>");
                            out.println("</div>");
                        }
                    } else {
                        out.println("<div class='alert alert-danger alert-dismissible fade show' role='alert'>");
                        out.println("<i class='fa-solid fa-triangle-exclamation me-2'></i>");
                        out.println("<strong>Error:</strong> No se pudo crear la transacción.");
                        out.println("<button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>");
                        out.println("</div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger alert-dismissible fade show' role='alert'>");
                    out.println("<i class='fa-solid fa-triangle-exclamation me-2'></i>");
                    out.println("<strong>Error:</strong> " + e.getMessage());
                    out.println("<button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>");
                    out.println("</div>");
                    e.printStackTrace();
                }
            } else {
                out.println("<div class='alert alert-danger alert-dismissible fade show' role='alert'>");
                out.println("<i class='fa-solid fa-triangle-exclamation me-2'></i>");
                out.println("<strong>Error:</strong> No se pudieron asignar asientos. Intenta con menos boletos.");
                out.println("<button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>");
                out.println("</div>");
            }
        } else if (totalBoletos > asientosDisponibles) {
            out.println("<div class='alert alert-danger alert-dismissible fade show' role='alert'>");
            out.println("<i class='fa-solid fa-triangle-exclamation me-2'></i>");
            out.println("<strong>Error:</strong> No hay suficientes asientos disponibles. Solo hay " + asientosDisponibles + " disponibles.");
            out.println("<button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>");
            out.println("</div>");
        }
    }
    
    // Calcular subtotales y total para mostrar
    BigDecimal subtotalGeneral = precioGeneral.multiply(new BigDecimal(cantidadGeneral));
    BigDecimal subtotalNino = precioNino.multiply(new BigDecimal(cantidadNino));
    BigDecimal subtotalEstudiante = precioEstudiante.multiply(new BigDecimal(cantidadEstudiante));
    BigDecimal totalCompra = subtotalGeneral.add(subtotalNino).add(subtotalEstudiante);
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
            <h1 class="display-4 fw-bold mb-3">🎫 Comprar Boletos</h1>
            <p class="lead mb-0">Selecciona el tipo y cantidad de boletos</p>
        </div>
    </header>

    <main class="container my-5">
        <!-- Información de la función -->
        <div class="movie-info">
            <div class="row">
                <div class="col-md-8">
                    <h4><i class="fa-solid fa-film me-2"></i><%= pelicula.getTitulo() %></h4>
                    <div class="row mt-3">
                        <div class="col-md-4">
                            <p><i class="fa-solid fa-calendar me-2 text-primary"></i><strong>Fecha:</strong> <%= fechaFuncion %></p>
                        </div>
                        <div class="col-md-4">
                            <p><i class="fa-solid fa-clock me-2 text-warning"></i><strong>Hora:</strong> <%= horaFuncion %></p>
                        </div>
                        <div class="col-md-4">
                            <p><i class="fa-solid fa-door-closed me-2 text-success"></i><strong>Sala:</strong> <%= sala.getNumeroSala() %></p>
                        </div>
                    </div>
                    <div class="mt-2">
                        <span class="badge bg-info"><i class="fa-solid fa-users me-1"></i>Capacidad: <%= capacidadTotal %></span>
                        <span class="badge bg-success ms-2"><i class="fa-solid fa-chair me-1"></i>Disponibles: <%= asientosDisponibles %></span>
                    </div>
                </div>
                <div class="col-md-4 text-end">
                    <a href="frmSeleccionarFuncion.jsp?idPelicula=<%= idPelicula %>&tituloPelicula=<%= java.net.URLEncoder.encode(tituloPelicula, "UTF-8") %>" 
                       class="btn btn-outline-secondary">
                        <i class="fa-solid fa-arrow-left me-2"></i>Cambiar Función
                    </a>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="ticket-card">
                    <div class="ticket-header">
                        <h4 class="mb-0"><i class="fa-solid fa-shopping-cart me-2"></i>Selecciona tus Boletos</h4>
                    </div>
                    <div class="ticket-body">
                        <!-- Formulario para ajustar cantidades (botones +/-) -->
                        <form method="get" action="frmComprarBoletos.jsp" class="mb-4">
                            <input type="hidden" name="idFuncion" value="<%= idFuncion %>">
                            <input type="hidden" name="idPelicula" value="<%= idPelicula %>">
                            <input type="hidden" name="tituloPelicula" value="<%= tituloPelicula %>">
                            <input type="hidden" name="fechaFuncion" value="<%= fechaFuncion %>">
                            <input type="hidden" name="horaFuncion" value="<%= horaFuncion %>">
                            <input type="hidden" name="idSala" value="<%= idSala %>">
                            
                            <!-- Tipo de Boleto: General -->
                            <div class="ticket-type-card <%= cantidadGeneral > 0 ? "selected" : "" %>">
                                <div class="ticket-type-header">
                                    <div>
                                        <h5 class="mb-0">Boleto General</h5>
                                        <span class="badge bg-primary ticket-type-badge">Adultos</span>
                                    </div>
                                    <span class="ticket-price">$<%= precioGeneral %></span>
                                </div>
                                <p class="text-muted mb-3">
                                    <i class="fa-solid fa-user me-1"></i>Para mayores de 13 años
                                </p>
                                
                                <!-- SELECTOR DE CANTIDAD SIN JAVASCRIPT -->
                                <div class="quantity-control">
                                    <div class="quantity-label">Cantidad:</div>
                                    <div class="quantity-input-group">
                                        <button type="submit" name="ajusteGeneral" value="-" 
                                                class="quantity-btn" <%= cantidadGeneral == 0 ? "disabled" : "" %>>
                                            <i class="fa-solid fa-minus"></i>
                                        </button>
                                        <input type="text" class="quantity-display" 
                                               value="<%= cantidadGeneral %>" readonly>
                                        <button type="submit" name="ajusteGeneral" value="+"
                                                class="quantity-btn" <%= totalBoletos >= asientosDisponibles ? "disabled" : "" %>>
                                            <i class="fa-solid fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tipo de Boleto: Niño -->
                            <div class="ticket-type-card <%= cantidadNino > 0 ? "selected" : "" %>">
                                <div class="ticket-type-header">
                                    <div>
                                        <h5 class="mb-0">Boleto Niño</h5>
                                        <span class="badge bg-warning ticket-type-badge">3-12 años</span>
                                    </div>
                                    <span class="ticket-price">$<%= precioNino %></span>
                                </div>
                                <p class="text-muted mb-3">
                                    <i class="fa-solid fa-child me-1"></i>Para niños de 3 a 12 años (con identificación)
                                </p>
                                
                                <!-- SELECTOR DE CANTIDAD SIN JAVASCRIPT -->
                                <div class="quantity-control">
                                    <div class="quantity-label">Cantidad:</div>
                                    <div class="quantity-input-group">
                                        <button type="submit" name="ajusteNino" value="-" 
                                                class="quantity-btn" <%= cantidadNino == 0 ? "disabled" : "" %>>
                                            <i class="fa-solid fa-minus"></i>
                                        </button>
                                        <input type="text" class="quantity-display" 
                                               value="<%= cantidadNino %>" readonly>
                                        <button type="submit" name="ajusteNino" value="+"
                                                class="quantity-btn" <%= totalBoletos >= asientosDisponibles ? "disabled" : "" %>>
                                            <i class="fa-solid fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tipo de Boleto: Estudiante -->
                            <div class="ticket-type-card <%= cantidadEstudiante > 0 ? "selected" : "" %>">
                                <div class="ticket-type-header">
                                    <div>
                                        <h5 class="mb-0">Boleto Estudiante</h5>
                                        <span class="badge bg-info ticket-type-badge">Con carnet</span>
                                    </div>
                                    <span class="ticket-price">$<%= precioEstudiante %></span>
                                </div>
                                <p class="text-muted mb-3">
                                    <i class="fa-solid fa-graduation-cap me-1"></i>Para estudiantes con carnet vigente
                                </p>
                                
                                <!-- SELECTOR DE CANTIDAD SIN JAVASCRIPT -->
                                <div class="quantity-control">
                                    <div class="quantity-label">Cantidad:</div>
                                    <div class="quantity-input-group">
                                        <button type="submit" name="ajusteEstudiante" value="-" 
                                                class="quantity-btn" <%= cantidadEstudiante == 0 ? "disabled" : "" %>>
                                            <i class="fa-solid fa-minus"></i>
                                        </button>
                                        <input type="text" class="quantity-display" 
                                               value="<%= cantidadEstudiante %>" readonly>
                                        <button type="submit" name="ajusteEstudiante" value="+"
                                                class="quantity-btn" <%= totalBoletos >= asientosDisponibles ? "disabled" : "" %>>
                                            <i class="fa-solid fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Información de límite -->
                            <div class="quantity-info">
                                <span><strong>Límite máximo:</strong> <span class="max-tickets"><%= asientosDisponibles %> boletos</span></span>
                                <span><strong>Seleccionados:</strong> <%= totalBoletos %> boletos</span>
                            </div>
                        </form>
                        
                        <div class="divider"></div>
                        
                        <!-- Formulario para procesar la compra -->
                        <form method="post" action="frmComprarBoletos.jsp">
                            <input type="hidden" name="idFuncion" value="<%= idFuncion %>">
                            <input type="hidden" name="idPelicula" value="<%= idPelicula %>">
                            <input type="hidden" name="tituloPelicula" value="<%= tituloPelicula %>">
                            <input type="hidden" name="fechaFuncion" value="<%= fechaFuncion %>">
                            <input type="hidden" name="horaFuncion" value="<%= horaFuncion %>">
                            <input type="hidden" name="idSala" value="<%= idSala %>">
                            <input type="hidden" name="cantidadGeneral" value="<%= cantidadGeneral %>">
                            <input type="hidden" name="cantidadNino" value="<%= cantidadNino %>">
                            <input type="hidden" name="cantidadEstudiante" value="<%= cantidadEstudiante %>">
                            <input type="hidden" name="accion" value="comprar">
                            
                            <!-- Resumen y total -->
                            <div class="total-section">
                                <h5 class="mb-4"><i class="fa-solid fa-receipt me-2"></i>Resumen de Compra</h5>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <p class="mb-1">
                                            <span class="badge bg-primary me-2">General</span>
                                            <%= cantidadGeneral %> x $<%= precioGeneral %>
                                        </p>
                                        <p class="mb-1">
                                            <span class="badge bg-warning me-2">Niño</span>
                                            <%= cantidadNino %> x $<%= precioNino %>
                                        </p>
                                        <p class="mb-1">
                                            <span class="badge bg-info me-2">Estudiante</span>
                                            <%= cantidadEstudiante %> x $<%= precioEstudiante %>
                                        </p>
                                    </div>
                                    <div class="col-md-6 text-end">
                                        <p class="mb-1">$<%= String.format("%.2f", subtotalGeneral) %></p>
                                        <p class="mb-1">$<%= String.format("%.2f", subtotalNino) %></p>
                                        <p class="mb-1">$<%= String.format("%.2f", subtotalEstudiante) %></p>
                                    </div>
                                </div>
                                
                                <div class="row border-top pt-3">
                                    <div class="col-md-6">
                                        <h5>Total de boletos: <%= totalBoletos %></h5>
                                    </div>
                                    <div class="col-md-6 text-end">
                                        <h3 class="text-success">$<%= String.format("%.2f", totalCompra) %></h3>
                                    </div>
                                </div>
                                
                                <!-- Información de asientos -->
                                <div class="mt-4">
                                    <p class="mb-2">
                                        <i class="fa-solid fa-info-circle me-2"></i>
                                        <strong>Información importante:</strong>
                                    </p>
                                    <ul class="mb-0 small">
                                        <li>Los asientos serán asignados automáticamente por el sistema</li>
                                        <li>Se asignarán juntos en la medida de lo posible</li>
                                        <li>No se pueden seleccionar asientos específicos</li>
                                        <li>Asientos disponibles: <strong><%= asientosDisponibles %></strong></li>
                                    </ul>
                                </div>
                            </div>
                            
                            <!-- Botón de compra -->
                            <div class="text-center mt-5">
                                <% if (totalBoletos > 0) { %>
                                    <button type="submit" class="btn btn-comprar btn-lg">
                                        <i class="fa-solid fa-credit-card me-2"></i>Procesar Compra
                                    </button>
                                    <p class="text-muted mt-2 small">
                                        Al hacer clic, se procesará tu compra y se asignarán los asientos automáticamente.
                                    </p>
                                <% } else { %>
                                    <div class="alert alert-warning">
                                        <i class="fa-solid fa-exclamation-triangle me-2"></i>
                                        Selecciona al menos un boleto para continuar
                                    </div>
                                <% } %>
                            </div>
                        </form>
                
                        <!-- Información adicional -->
                        <div class="card border-0 shadow-sm mt-4">
                            <div class="card-body">
                                <h5><i class="fa-solid fa-lightbulb me-2 text-warning"></i>Políticas de los boletos</h5>
                                <ul class="mt-3 mb-0">
                                    <li class="mb-2"><strong>Boleto Niño:</strong> Requiere identificación que acredite la edad (3-12 años)</li>
                                    <li class="mb-2"><strong>Boleto Estudiante:</strong> Requiere carnet estudiantil vigente</li>
                                    <li class="mb-2">Los boletos no son reembolsables ni transferibles</li>
                                    <li>Presenta tu código de confirmación en taquilla 15 minutos antes</li>
                                </ul>
                            </div>
                        </div>
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
</body>
</html>

<%!
// Método para generar asientos automáticamente (el mismo que ya tenías)
public List<String> generarAsientosAutomaticos(int idFuncion, int cantidad, int numeroSala, BoletoDAO boletoDAO) {
    List<String> asientosAsignados = new ArrayList<>();
    List<String> asientosOcupados = boletoDAO.getAsientosOcupados(idFuncion);
    
    // Configurar el diseño de la sala
    int filas = 8; // A-H
    int asientosPorFila = 12;
    char[] letrasFila = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
    
    // Estrategia: asignar desde el centro hacia afuera
    int filaInicio = 3; // Empezar desde fila D (centro)
    int asientoInicio = 5; // Empezar desde asiento 6 (centro)
    
    // Primero intentar asignar asientos juntos en el centro
    for (int offsetFila = 0; offsetFila < filas && asientosAsignados.size() < cantidad; offsetFila++) {
        int filaActual = (filaInicio + offsetFila) % filas;
        
        for (int offsetAsiento = 0; offsetAsiento < asientosPorFila && asientosAsignados.size() < cantidad; offsetAsiento++) {
            int asientoActual = (asientoInicio + offsetAsiento) % asientosPorFila;
            
            String asiento = letrasFila[filaActual] + String.format("%02d", asientoActual + 1);
            
            if (!asientosOcupados.contains(asiento) && !asientosAsignados.contains(asiento)) {
                asientosAsignados.add(asiento);
                
                // Si ya asignamos todos, salir
                if (asientosAsignados.size() >= cantidad) {
                    return asientosAsignados;
                }
            }
        }
        
        // Intentar también en dirección contraria
        for (int offsetAsiento = 0; offsetAsiento < asientosPorFila && asientosAsignados.size() < cantidad; offsetAsiento++) {
            int asientoActual = (asientoInicio - offsetAsiento + asientosPorFila) % asientosPorFila;
            
            String asiento = letrasFila[filaActual] + String.format("%02d", asientoActual + 1);
            
            if (!asientosOcupados.contains(asiento) && !asientosAsignados.contains(asiento)) {
                asientosAsignados.add(asiento);
                
                if (asientosAsignados.size() >= cantidad) {
                    return asientosAsignados;
                }
            }
        }
    }
    
    // Si no encontramos suficientes asientos en el centro, buscar en cualquier parte
    if (asientosAsignados.size() < cantidad) {
        for (int fila = 0; fila < filas && asientosAsignados.size() < cantidad; fila++) {
            for (int asientoNum = 1; asientoNum <= asientosPorFila && asientosAsignados.size() < cantidad; asientoNum++) {
                String asiento = letrasFila[fila] + String.format("%02d", asientoNum);
                
                if (!asientosOcupados.contains(asiento) && !asientosAsignados.contains(asiento)) {
                    asientosAsignados.add(asiento);
                }
            }
        }
    }
    
    return asientosAsignados;
}
%>