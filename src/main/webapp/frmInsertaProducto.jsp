<%-- 
    Document   : frmInsertaProducto.jsp
    Created on : 1 dic 2025, 9:34:28 a.m.
    Author     : Kevin
--%>

<%@page import="java.math.BigDecimal"%>
<%@page import="dao.ProductoDAO"%>
<%@page import="entity.Producto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String accion = request.getParameter("accion");

    if ("guardar".equals(accion)) {
        String nombre = request.getParameter("nombre");
        String precio = request.getParameter("precio");
        String stock = request.getParameter("stock");

        ProductoDAO dao = new ProductoDAO();

        try {
Producto p = new Producto(0, nombre, new BigDecimal(precio), Integer.parseInt(stock));
            p.setNombre(nombre);
            p.setPrecioVenta(new java.math.BigDecimal(precio));
            p.setStock(Integer.parseInt(stock));

            dao.insertarProducto(p);

            out.println("<p style='color:green;'>Producto guardado correctamente</p>");
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error al guardar producto</p>");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insertar Producto</title>
</head>
<body>

    <h1>Registrar Producto</h1>

    <form action="frmInsertaProducto.jsp" method="post">
        <input type="hidden" name="accion" value="guardar">

        <table>
            <tr>
                <td>Nombre:</td>
                <td><input t
