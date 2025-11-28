<%@page import="dao.PeliculaDAO"%>
<%@page import="entity.Pelicula"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Seleccionar Película</title>
</head>
<body>
    <h1>🎬 Selecciona una Película</h1>
    
    <%
        PeliculaDAO peliculaDAO = new PeliculaDAO();
        List<Pelicula> peliculas = peliculaDAO.getPeliculas();
    %>
    
    <div class="peliculas-container">
        <% for (Pelicula pelicula : peliculas) { %>
            <div class="pelicula-card">
                <h3><%= pelicula.getTitulo() %></h3>
                <p><strong>Género:</strong> <%= pelicula.getGenero() %></p>
                <p><strong>Duración:</strong> 
                    <%
                        java.time.Duration duracion = pelicula.getDuracion();
                        long horas = duracion.toHours();
                        long minutos = duracion.toMinutesPart();
                        out.print(horas + "h " + minutos + "m");
                    %>
                </p>
                <p><strong>Clasificación:</strong> <%= pelicula.getClasificacion() %></p>
                
                <!-- ✅ CORRECTO: Pasa a frmSeleccionarFuncion.jsp -->
                <form action="frmSeleccionarFuncion.jsp" method="GET">
                    <input type="hidden" name="idPelicula" value="<%= pelicula.getIdPelicula() %>">
                    <input type="hidden" name="tituloPelicula" value="<%= pelicula.getTitulo() %>">
                    <button type="submit">Seleccionar y Ver Funciones</button>
                </form>
            </div>
        <% } %>
    </div>

    <!-- Enlace a mantenimiento (si es necesario) -->
    <div style="margin-top: 20px;">
        <a href="frmListadoPeliculas.jsp">📋 Administrar Películas</a>
    </div>
</body>
</html>