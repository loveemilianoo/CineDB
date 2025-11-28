<%@page import="java.time.Duration"%>
<%@page import="dao.FuncionDAO"%>
<%@page import="entity.Funcion"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Seleccionar Función</title>
</head>
<body>
    <h1>🎭 Selecciona una Función</h1>
    
    <%
        String idPeliculaStr = request.getParameter("idPelicula");
        String tituloPelicula = request.getParameter("tituloPelicula");
        
        if (idPeliculaStr != null) {
            int idPelicula = Integer.parseInt(idPeliculaStr);
            
            FuncionDAO funcionDAO = new FuncionDAO();
            List<Funcion> funciones = funcionDAO.getFuncionesPelicula(idPelicula);
    %>
    
    <h2>Película: <%= tituloPelicula %></h2>
    
    <% if (funciones.isEmpty()) { %>
        <p>No hay funciones disponibles para esta película.</p>
    <% } else { %>
        <div class="funciones-container">
            <% for (Funcion funcion : funciones) { %>
                <div class="funcion-card">
                    <h3>Sala <%= funcion.getSala().getNumeroSala() %></h3>
                    <p><strong>Fecha:</strong> <%= funcion.getFecha() %></p>
                    <p><strong>Hora:</strong> 
                        <%
                            Duration horaInicio = funcion.getHoraInicio();
                            long horas = horaInicio.toHours();
                            long minutos = horaInicio.toMinutesPart();
                            out.print(String.format("%02d:%02d", horas, minutos));
                        %>
                    </p>
                    
                    <form action="seleccionarAsiento.jsp" method="GET">
                        <input type="hidden" name="idFuncion" value="<%= funcion.getIdFuncion() %>">
                        <input type="hidden" name="idPelicula" value="<%= idPelicula %>">
                        <input type="hidden" name="tituloPelicula" value="<%= tituloPelicula %>">
                        <input type="hidden" name="fechaFuncion" value="<%= funcion.getFecha() %>">
                        <input type="hidden" name="horaFuncion" value="<%= String.format("%02d:%02d", 
                            funcion.getHoraInicio().toHours(), 
                            funcion.getHoraInicio().toMinutesPart()) %>">
                        <input type="hidden" name="sala" value="<%= funcion.getSala().getNumeroSala() %>">
                        <button type="submit">Seleccionar Asientos</button>
                    </form>
                </div>
            <% } %>
        </div>
    <% } 
        } else { %>
        <p>Error: No se especificó la película.</p>
    <% } %>
    
    <a href="seleccionarPelicula.jsp">← Volver a Películas</a>
</body>
</html>