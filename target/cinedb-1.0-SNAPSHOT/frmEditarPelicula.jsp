<%@page import="dao.PeliculaDAO" %>
<%@page import="entity.Pelicula" %>
<%@page import="java.time.Duration" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%
// Procesar el formulario si se envió
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String idParam = request.getParameter("id_pelicula");
    String titulo = request.getParameter("titulo");
    String duracionStr = request.getParameter("duracion");
    String genero = request.getParameter("genero");
    String clasificacion = request.getParameter("clasificacion");
    
    if (idParam != null && titulo != null && duracionStr != null && genero != null && clasificacion != null) {
        try {
            int idPelicula = Integer.parseInt(idParam);
            
            // Parsear duración
            String[] partes = duracionStr.split(":");
            long horas = Long.parseLong(partes[0]);
            long minutos = Long.parseLong(partes[1]);
            long segundos = partes.length > 2 ? Long.parseLong(partes[2]) : 0;
            Duration duracion = Duration.ofHours(horas).plusMinutes(minutos).plusSeconds(segundos);
            
            // Crear objeto Pelicula
            Pelicula pelicula = new Pelicula();
            pelicula.setIdPelicula(idPelicula);
            pelicula.setTitulo(titulo);
            pelicula.setDuracion(duracion);
            pelicula.setGenero(genero);
            pelicula.setClasificacion(clasificacion);
            
            // Actualizar en la base de datos
            PeliculaDAO dao = new PeliculaDAO();
            dao.updatePelicula(pelicula);
            
            // Redirigir con mensaje de éxito
            response.sendRedirect("frmListadoPeliculas.jsp?updated=true");
            return;
            
        } catch (Exception e) {
            e.printStackTrace();
            // Mostrar error en la misma página
            request.setAttribute("error", "Error al actualizar: " + e.getMessage());
        }
    }
}

// Cargar datos de la película para editar (si es GET)
Pelicula pelicula = null;
String idParam = request.getParameter("id");
if (idParam != null && !idParam.isEmpty()) {
    try {
        int idPelicula = Integer.parseInt(idParam);
        PeliculaDAO dao = new PeliculaDAO();
        pelicula = dao.getPeliculaPorId(idPelicula);
    } catch (NumberFormatException e) {
        e.printStackTrace();
    }
}

if (pelicula == null) {
    response.sendRedirect("frmListadoPeliculas.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Película</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .error-message {
            color: #dc3545;
            font-size: 0.875em;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">
                            <i class="fa-solid fa-pen-to-square me-2"></i>Editar Película
                        </h4>
                    </div>
                    <div class="card-body">
                        <!-- Mensaje de error si existe -->
                        <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fa-solid fa-exclamation-triangle me-2"></i>
                            <%= request.getAttribute("error") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } %>
                        
                        <form method="post">
                            <input type="hidden" name="id_pelicula" value="<%= pelicula.getIdPelicula() %>">
                            
                            <div class="mb-3">
                                <label for="titulo" class="form-label">Título <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="titulo" name="titulo" 
                                       value="<%= pelicula.getTitulo() %>" required
                                       maxlength="100">
                                <div class="form-text">Máximo 100 caracteres</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="duracion" class="form-label">Duración (HH:MM:SS) <span class="text-danger">*</span></label>
                                <%
                                Duration duracion = pelicula.getDuracion();
                                String duracionStr = String.format("%02d:%02d:%02d", 
                                    duracion.toHours(), 
                                    duracion.toMinutesPart(), 
                                    duracion.toSecondsPart());
                                %>
                                <input type="text" class="form-control" id="duracion" name="duracion" 
                                       value="<%= duracionStr %>" 
                                       placeholder="Ej: 02:30:00" 
                                       pattern="^([0-1]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$" 
                                       required
                                       title="Formato: HH:MM:SS (00:00:00 a 23:59:59)">
                                <div class="form-text">Formato 24 horas: HH:MM:SS</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="genero" class="form-label">Género <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="genero" name="genero" 
                                       value="<%= pelicula.getGenero() %>" required
                                       maxlength="50">
                                <div class="form-text">Ej: Acción, Drama, Comedia, etc.</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="clasificacion" class="form-label">Clasificación <span class="text-danger">*</span></label>
                                <select class="form-select" id="clasificacion" name="clasificacion" required>
                                    <option value="">Seleccione una clasificación</option>
                                    <option value="G" <%= "G".equals(pelicula.getClasificacion()) ? "selected" : "" %>>G - Todo público</option>
                                    <option value="PG" <%= "PG".equals(pelicula.getClasificacion()) ? "selected" : "" %>>PG - Guía paterna sugerida</option>
                                    <option value="PG-13" <%= "PG-13".equals(pelicula.getClasificacion()) ? "selected" : "" %>>PG-13 - Mayores de 13 años</option>
                                    <option value="R" <%= "R".equals(pelicula.getClasificacion()) ? "selected" : "" %>>R - Restringido</option>
                                    <option value="B" <%= "B".equals(pelicula.getClasificacion()) ? "selected" : "" %>>B</option>
                                    <option value="RG-12" <%= "RG-12".equals(pelicula.getClasificacion()) ? "selected" : "" %>>RG-12</option>
                                    <option value="RG-13" <%= "RG-13".equals(pelicula.getClasificacion()) ? "selected" : "" %>>RG-13</option>
                                    <option value="RG-17" <%= "RG-17".equals(pelicula.getClasificacion()) ? "selected" : "" %>>RG-17</option>
                                </select>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="frmListadoPeliculas.jsp" class="btn btn-secondary me-md-2">
                                    <i class="fa-solid fa-times me-1"></i>Cancelar
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa-solid fa-save me-1"></i>Guardar Cambios
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Información de la película -->
                <div class="card mt-3 shadow-sm">
                    <div class="card-body">
                        <h6 class="card-title">
                            <i class="fa-solid fa-info-circle me-2 text-info"></i>Información
                        </h6>
                        <div class="row small">
                            <div class="col-6">
                                <strong>ID:</strong> #<%= pelicula.getIdPelicula() %>
                            </div>
                            <div class="col-6 text-end">
                                <a href="frmListadoPeliculas.jsp" class="text-decoration-none">
                                    <i class="fa-solid fa-arrow-left me-1"></i>Volver al listado
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validación del formato de duración
        document.querySelector('form').addEventListener('submit', function(e) {
            const duracionInput = document.getElementById('duracion');
            const pattern = /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/;
            
            if (!pattern.test(duracionInput.value)) {
                e.preventDefault();
                alert('Formato de duración inválido. Use HH:MM:SS (ej: 02:30:00)');
                duracionInput.focus();
            }
        });
    </script>
</body>
</html>