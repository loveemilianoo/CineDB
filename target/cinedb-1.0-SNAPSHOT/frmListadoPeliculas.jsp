<%@page import="java.time.Duration"%>
<%@page import="dao.PeliculaDAO"%>
<%@page import="entity.Pelicula"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Lista de Películas</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .btn {
            padding: 8px 12px;
            text-decoration: none;
            border-radius: 4px;
            margin: 2px;
        }
        .btn-add {
            background-color: #4CAF50;
            color: white;
        }
        .btn-edit {
            background-color: #2196F3;
            color: white;
        }
        .btn-delete {
            background-color: #f44336;
            color: white;
        }
    </style>
</head>
<body>
    <h1>🎬 Lista de Películas</h1>
    
    <a href="frmInsertarPelicula.jsp" class="btn btn-add">➕ Agregar Nueva Película</a>
    
    <table>
        <tr>
            <th>ID</th>
            <th>Título</th>
            <th>Duración</th>
            <th>Género</th>
            <th>Clasificación</th>
            <th>Acciones</th>
        </tr>
        
        <%
            PeliculaDAO dao = new PeliculaDAO();
            List<Pelicula> peliculas = dao.getPeliculas();
            
            if(peliculas.isEmpty()) {
        %>
            <tr>
                <td colspan="6" style="text-align: center;">No hay películas registradas</td>
            </tr>
        <%
            } else {
                for(Pelicula pelicula : peliculas) {
        %>
            <tr>
                <td><%= pelicula.getIdPelicula() %></td>
                <td><strong><%= pelicula.getTitulo() %></strong></td>
                <td>
                    <%
                        Duration duracion = pelicula.getDuracion();
                        long horas = duracion.toHours();
                        long minutos = duracion.toMinutesPart();
                        out.print(horas + "h " + minutos + "m");
                    %>
                </td>
                <td><%= pelicula.getGenero() %></td>
                <td><%= pelicula.getClasificacion() %></td>
                <td>
                    <a href="#" class="btn btn-edit">✏️ Editar</a>
                    <a href="#" class="btn btn-delete" 
                       onclick="return confirm('¿Eliminar <%= pelicula.getTitulo() %>?')">🗑️ Eliminar</a>
                </td>
            </tr>
        <%
                }
            }
        %>
    </table>
</body>
</html>