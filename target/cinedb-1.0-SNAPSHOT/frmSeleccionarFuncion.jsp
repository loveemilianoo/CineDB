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
        <a href="frmSeleccionarPelicula.jsp">← Volver a Películas</a>
    <% } else { %>
        <div class="funciones-container">
            <% for (Funcion funcion : funciones) { %>
                <div class="funcion-card" style="border: 1px solid #ccc; padding: 15px; margin: 10px;">
                    <h3>Sala <%= funcion.getSala().getNumeroSala() %></h3>
                    <p><strong>Fecha:</strong> <%= funcion.getFecha() %></p>
                    <p><strong>Hora:</strong> 
                        <%
                            java.time.Duration horaInicio = funcion.getHoraInicio();
                            long horas = horaInicio.toHours();
                            long minutos = horaInicio.toMinutesPart();
                            out.print(String.format("%02d:%02d", horas, minutos));
                        %>
                    </p>
                    
                    <!-- ✅ CORRECTO: Pasa a frmSeleccionarAsiento.jsp (debes crearlo) -->
                    <form action="frmSeleccionarAsiento.jsp" method="GET">
                        <input type="hidden" name="idFuncion" value="<%= funcion.getIdFuncion() %>">
                        <input type="hidden" name="idPelicula" value="<%= idPelicula %>">
                        <input type="hidden" name="tituloPelicula" value="<%= tituloPelicula %>">
                        <input type="hidden" name="fechaFuncion" value="<%= funcion.getFecha() %>">
                        <input type="hidden" name="horaFuncion" value="<%= String.format("%02d:%02d", horas, minutos) %>">
                        <input type="hidden" name="numeroSala" value="<%= funcion.getSala().getNumeroSala() %>">
                        <button type="submit">Seleccionar Asientos</button>
                    </form>
                </div>
            <% } %>
        </div>
    <% } 
        } else { %>
        <p>Error: No se especificó la película.</p>
    <% } %>
    
    <br>
    <a href="frmSeleccionarPelicula.jsp">← Volver a Películas</a>
</body>
</html>