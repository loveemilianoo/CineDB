<%@page import="java.time.Duration"%>
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
                        Duration duracion = pelicula.getDuracion();
                        long horas = duracion.toHours();
                        long minutos = duracion.toMinutesPart();
                        out.print(horas + "h " + minutos + "m");
                    %>
                </p>
                <p><strong>Clasificación:</strong> <%= pelicula.getClasificacion() %></p>
                
                <!-- Form para seleccionar esta película -->
                <form action="seleccionarFuncion.jsp" method="GET">
                    <input type="hidden" name="idPelicula" value="<%= pelicula.getIdPelicula() %>">
                    <input type="hidden" name="tituloPelicula" value="<%= pelicula.getTitulo() %>">
                    <button type="submit">Seleccionar y Ver Funciones</button>
                </form>
            </div>
        <% } %>
    </div>
</body>
</html>