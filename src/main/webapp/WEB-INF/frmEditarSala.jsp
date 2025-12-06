<%-- 
    Document   : frmEditarSala
    Created on : 5 dic 2025, 11:38:45 p.m.
    Author     : Kevin
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="dao.SalaDAO"%>
<%@page import="entity.Sala"%>

<%
    SalaDAO dao = new SalaDAO();

    int id = Integer.parseInt(request.getParameter("id"));
      Sala sala = dao.getSalaPorId(id);

    if (request.getMethod().equals("POST")) {
        int numero = Integer.parseInt(request.getParameter("numero"));
        int capacidad = Integer.parseInt(request.getParameter("capacidad"));

        sala.setNumeroSala(numero);
        sala.setCapacidad(capacidad);

        dao.actualizarSala(sala);

        response.sendRedirect("frmListadoSala.jsp");
        return;
    }
%>

<html>
<head>
    <title>Editar Sala</title>
</head>
<body>
    <h1>Editar Sala</h1>

    <form method="post">
        Número de sala: <br>
        <input type="number" name="numero" value="<%=sala.getNumeroSala()%>" required><br><br>

        Capacidad: <br>
        <input type="number" name="capacidad" value="<%=sala.getCapacidad()%>" required><br><br>

        <button type="submit">Actualizar</button>
    </form>

    <br>
    <a href="frmListadoSala.jsp">Volver</a>
</body>
</html>
