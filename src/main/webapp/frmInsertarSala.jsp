<%-- 
    Document   : frmInsertarSala
    Created on : 5 dic 2025, 11:31:48 p.m.
    Author     : Kevin
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="dao.SalaDAO"%>
<%@page import="entity.Sala"%>

<%
    if (request.getMethod().equals("POST")) {
        int numero = Integer.parseInt(request.getParameter("numero"));
        int capacidad = Integer.parseInt(request.getParameter("capacidad"));

        Sala nueva = new Sala(0, numero, capacidad);
        new SalaDAO().insertarSala(nueva);

        response.sendRedirect("frmListadoSalas.jsp");
        return;
    }
%>

<html>
<head>
    <title>Agregar Sala</title>
</head>
<body>
    <h1>Agregar una Sala</h1>

    <form method="post">
        Número de sala: <br>
        <input type="number" name="numero" required><br><br>

        Capacidad: <br>
        <input type="number" name="capacidad" required><br><br>

        <button type="submit">Guardar</button>
    </form>

    <br>
    <a href="frmListadoSalas.jsp">Volver</a>
</body>
</html>
