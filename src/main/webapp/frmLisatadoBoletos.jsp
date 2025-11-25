<%@page import="entity.Boleto"%>
<%@page import="java.util.List"%>
<%@page import="dao.BoletoDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Listado de Boletos</title>
        <style>
            table {
                border-collapse: collapse;
                width: 100%;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
            tr:hover {
                background-color: #f5f5f5;
            }
        </style>
    </head>
    <body>
        <h1>Boletos del Cine</h1>
        <a href="frmGuardaBoleto.jsp">Nuevo Boleto</a>
        <% System.out.println("Cargando lista de boletos..."); %>
        <a href="frmActualizarBoleto.jsp" style="margin-left: 10px;">Actualizar Boleto</a>
        
        <table>
            <tr>
                <th>ID Boleto</th>
                <th>ID Función</th>
                <th>ID Asiento</th>
                <th>ID Transacción</th>
                <th>Precio</th>
                <th>Tipo de Boleto</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
            
            <%
                BoletoDAO dao = new BoletoDAO();
                List<Boleto> boletos = dao.getBoletos();
                
                if(boletos.isEmpty()) {
            %>
            <tr>
                <td colspan="8" style="text-align: center;">No hay boletos registrados</td>
            </tr>
            <%
                } else {
                    for(Boleto boleto : boletos){
            %>
            <tr>
                <td><%= boleto.getIdBoleto() %></td>
                <td><%= boleto.getIdFuncion() %></td>
                <td><%= boleto.getIdAsiento() %></td>
                <td><%= boleto.getIdTransaccion() %></td>
                <td>$<%= String.format("%.2f", boleto.getPrecio()) %></td>
                <td><%= boleto.getTipoBoleto() %></td>
                <td><%= boleto.getEstado() %></td>
                <td>
                    <a href="frmActualizarBoleto.jsp?id=<%= boleto.getIdBoleto() %>">Editar</a>
                    <a href="EliminarBoletoServlet?id=<%= boleto.getIdBoleto() %>" 
                       onclick="return confirm('¿Estás seguro de eliminar este boleto?')" 
                       style="margin-left: 5px; color: red;">Eliminar</a>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>
        
        <div style="margin-top: 20px;">
            <p>Total de boletos: <strong><%= boletos.size() %></strong></p>
        </div>
    </body>
</html>