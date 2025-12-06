<%-- 
    Document   : frmListadoSalas
    Created on : Dec 5, 2025, 7:45:52 PM
    Author     : famil
--%>

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

<html>
<head>
    <title>Listado de Salas</title>
</head>
<body>
    <h1>Salas</h1>

    <a href="frmInsertarSala.jsp">Agregar Sala</a>
    <br><br>

    <table border="1" cellpadding="5">
        <tr>
            <th>ID</th>
            <th>Número</th>
            <th>Capacidad</th>
            <th>Acciones</th>
        </tr>

        <%
            for (Sala s : lista) {
        %>
        <tr>
            <td><%= s.getIdSala() %></td>
            <td><%= s.getNumeroSala() %></td>
            <td><%= s.getCapacidad() %></td>
            <td>
                <a href="frmEditarSala.jsp?id=<%=s.getIdSala()%>">Editar</a> |
                <a href="frmListadoSalas.jsp?action=delete&id=<%=s.getIdSala()%>"
                   onclick="return confirm('¿Eliminar sala?');">Eliminar</a>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>
