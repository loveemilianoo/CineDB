<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="dao.SalaDAO"%>
<%@page import="entity.Sala"%>

<%
    String action = request.getParameter("action");
    if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        new SalaDAO().eliminarSala(id);
        response.sendRedirect("frmListadoSalas.jsp");
        return;
    }

    SalaDAO dao = new SalaDAO();
    List<Sala> lista = dao.getSalas();
%>

<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Gestionar Salas - Cine Prototype</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .hero-section {
      color: white;
      padding: 60px 0;
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
      width: 80px;
      height: 3px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    .table-hover tbody tr:hover {
      background-color: rgba(102, 126, 234, 0.1);
    }

    .action-buttons .btn {
      margin: 2px;
    }
    
    .capacity-badge {
      font-size: 0.85em;
    }
  </style>
</head>

<body>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
      <a class="navbar-brand" href="frmMenu.jsp">
        <i class="fa-solid fa-film me-2"></i>Cine
      </a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav"
        aria-controls="nav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="nav">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item"><a class="nav-link" href="frmMenu.jsp">Inicio</a></li>
          <li class="nav-item"><a class="nav-link" href="frmSeleccionarPelicula.jsp">Boletos</a></li>
          <li class="nav-item"><a class="nav-link" href="#">Comida</a></li>
          <li class="nav-item"><a class="nav-link active" href="frmListadoSalas.jsp">Administrar</a></li>
        </ul>
      </div>
    </div>
  </nav>

  <header class="hero-section text-center position-relative"
    style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
    <div class="container position-relative" style="z-index: 1;">
      <h1 class="display-5 fw-bold mb-3">Gestión de Salas</h1>
      <p class="lead mb-0">Administra las salas de cine disponibles</p>
    </div>
  </header>

  <main class="container my-5">

    <!-- Encabezado -->
    <div class="row align-items-center mb-4">
      <div class="col-md-6">
        <h2 class="section-title mb-0">Listado de Salas</h2>
      </div>
      <div class="col-md-6 text-end">
        <div class="btn-group" role="group">
          <a href="frmInsertarSala.jsp" class="btn btn-primary">
            <i class="fa-solid fa-plus me-2"></i>Agregar Sala
          </a>
          <a href="frmMenu.jsp" class="btn btn-outline-secondary">
            <i class="fa-solid fa-home me-2"></i>Menú Principal
          </a>
        </div>
      </div>
    </div>

    <!-- Tabla de salas -->
    <div class="card shadow-sm border-0">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
              <tr>
                <th scope="col" class="ps-4">ID</th>
                <th scope="col">Número de Sala</th>
                <th scope="col">Capacidad</th>
                <th scope="col" class="text-center pe-4">Acciones</th>
              </tr>
            </thead>
            <tbody>
              <% 
              if(lista.isEmpty()) { 
              %>
                <tr>
                  <td colspan="4" class="text-center py-5">
                    <div class="text-muted">
                      <i class="fa-solid fa-door-closed fa-3x mb-3"></i>
                      <h5 class="mb-3">No hay salas registradas</h5>
                      <p class="mb-4">Comienza agregando la primera sala al sistema</p>
                      <a href="frmInsertarSala.jsp" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-2"></i>Agregar Primera Sala
                      </a>
                    </div>
                  </td>
                </tr>
              <% 
              } else { 
                for(Sala s : lista) { 
              %>
                <tr>
                  <td class="ps-4">
                    <span class="fw-bold text-primary">#<%= s.getIdSala() %></span>
                  </td>
                  <td>
                    <div>
                      <strong class="text-dark">
                        <i class="fa-solid fa-door-open me-2"></i>Sala <%= s.getNumeroSala() %>
                      </strong>
                    </div>
                  </td>
                  <td>
                    <span class="badge bg-light text-dark border capacity-badge">
                      <i class="fa-solid fa-users me-1"></i>
                      <%= s.getCapacidad() %> personas
                    </span>
                  </td>
                  <td class="text-center pe-4 action-buttons">
                    <div class="btn-group btn-group-sm" role="group">
                      <a href="frmEditarSala.jsp?id=<%= s.getIdSala() %>" class="btn btn-outline-primary">
                        <i class="fa-solid fa-pen-to-square me-1"></i>Editar
                      </a>
                      <a href="frmListadoSalas.jsp?action=delete&id=<%= s.getIdSala() %>" 
                        class="btn btn-outline-danger"
                        onclick="return confirm('¿Estás seguro de que deseas eliminar la Sala <%= s.getNumeroSala() %>?')">
                        <i class="fa-solid fa-trash me-1"></i>Eliminar
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
    </div>

    <!-- Pie de tabla -->
    <div class="row mt-4">
      <div class="col-md-6">
        <div class="d-flex align-items-center">
          <span class="text-muted me-3">
            <i class="fa-solid fa-info-circle me-1"></i>
            Total de salas: <%= lista.size() %>
          </span>
        </div>
      </div>
      <div class="col-md-6 text-end">
        <div class="btn-group" role="group">
          <a href="frmInsertarSala.jsp" class="btn btn-outline-primary btn-sm">
            <i class="fa-solid fa-plus me-1"></i>Nueva Sala
          </a>
          <a href="frmMenu.jsp" class="btn btn-outline-secondary btn-sm">
            <i class="fa-solid fa-arrow-left me-1"></i>Volver al Menú
          </a>
        </div>
      </div>
    </div>
  </main>

  <footer class="bg-dark text-white py-4 mt-5">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-md-6">
          <h5><i class="fa-solid fa-film me-2"></i>Sistema de Cine</h5>
          <p class="mb-0">Sistema de gestión de salas</p>
        </div>
        <div class="col-md-6 text-end">
          <div class="btn-group" role="group">
            <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-light btn-sm">
              <i class="fa-solid fa-ticket me-1"></i>Boletos
            </a>
            <a href="#" class="btn btn-outline-light btn-sm">
              <i class="fa-solid fa-popcorn me-1"></i>Comida
            </a>
            <a href="frmListadoSalas.jsp" class="btn btn-outline-light btn-sm">
              <i class="fa-solid fa-sliders me-1"></i>Administrar
            </a>
          </div>
        </div>
      </div>
      <hr class="my-3">
      <div class="text-center text-muted">
        <small>© 2025 Sistema de Gestión de Cine. Todos los derechos reservados.</small>
      </div>
    </div>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>