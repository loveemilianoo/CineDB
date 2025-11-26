<%@page import="dao.PeliculaDAO"%>
<%@page import="entity.Pelicula"%>
<%@page import="java.time.Duration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Agregar Nueva Película</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"], input[type="number"], select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
        }
        .btn-cancel {
            background-color: #f44336;
        }
        .btn:hover {
            opacity: 0.9;
        }
        .message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
            text-align: center;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .duration-group {
            display: flex;
            gap: 10px;
        }
        .duration-group input {
            flex: 1;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎬 Agregar Nueva Película</h1>
        
        <%
            // Procesar el formulario cuando se envía
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String titulo = request.getParameter("titulo");
                String horasStr = request.getParameter("horas");
                String minutosStr = request.getParameter("minutos");
                String genero = request.getParameter("genero");
                String clasificacion = request.getParameter("clasificacion");
                
                try {
                    // Validar campos obligatorios
                    if (titulo != null && !titulo.trim().isEmpty() &&
                        horasStr != null && minutosStr != null &&
                        genero != null && clasificacion != null) {
                        
                        // Convertir horas y minutos a Duration
                        int horas = Integer.parseInt(horasStr);
                        int minutos = Integer.parseInt(minutosStr);
                        Duration duracion = Duration.ofHours(horas).plusMinutes(minutos);
                        
                        // Crear objeto Pelicula
                        Pelicula pelicula = new Pelicula();
                        pelicula.setTitulo(titulo.trim());
                        pelicula.setDuracion(duracion);
                        pelicula.setGenero(genero.trim());
                        pelicula.setClasificacion(clasificacion);
                        
                        // Insertar en la base de datos
                        PeliculaDAO dao = new PeliculaDAO();
                        dao.insetrtarPelicula(pelicula);
        %>
                        <div class="message success">
                            ✅ ¡Película "<%= titulo %>" agregada exitosamente!
                        </div>
                        <script>
                            setTimeout(function() {
                                window.location.href = 'frmListadoPeliculas.jsp';
                            }, 2000);
                        </script>
        <%
                    } else {
        %>
                        <div class="message error">
                            ❌ Por favor, completa todos los campos obligatorios.
                        </div>
        <%
                    }
                } catch (Exception e) {
        %>
                    <div class="message error">
                        ❌ Error al agregar la película: <%= e.getMessage() %>
                    </div>
        <%
                    e.printStackTrace();
                }
            }
        %>
        
        <form method="POST" action="">
            <div class="form-group">
                <label for="titulo">Título de la Película *</label>
                <input type="text" id="titulo" name="titulo" required 
                       placeholder="Ej: Avengers: Endgame">
            </div>
            
            <div class="form-group">
                <label for="duracion">Duración *</label>
                <div class="duration-group">
                    <div>
                        <label for="horas">Horas</label>
                        <input type="number" id="horas" name="horas" min="0" max="10" 
                               value="2" required>
                    </div>
                    <div>
                        <label for="minutos">Minutos</label>
                        <input type="number" id="minutos" name="minutos" min="0" max="59" 
                               value="30" required>
                    </div>
                </div>
            </div>
            
            <div class="form-group">
                <label for="genero">Género *</label>
                <input type="text" id="genero" name="genero" required 
                       placeholder="Ej: Acción, Comedia, Drama">
            </div>
            
            <div class="form-group">
                <label for="clasificacion">Clasificación *</label>
                <select id="clasificacion" name="clasificacion" required>
                    <option value="">Selecciona una clasificación</option>
                    <option value="G">G - Todo público</option>
                    <option value="PG">PG - Guía paternal sugerida</option>
                    <option value="PG-13">PG-13 - Mayores de 13 años</option>
                    <option value="R">R - Mayores de 17 años</option>
                    <option value="NC-17">NC-17 - Solo adultos</option>
                    <option value="A">A - Solo adultos</option>
                </select>
            </div>
            
            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn">🎬 Guardar Película</button>
                <a href="frmListadoPeliculas.jsp" class="btn btn-cancel">❌ Cancelar</a>
            </div>
        </form>
    </div>
    
    <script>
        // Validación adicional del lado del cliente
        document.querySelector('form').addEventListener('submit', function(e) {
            const titulo = document.getElementById('titulo').value.trim();
            const genero = document.getElementById('genero').value.trim();
            const clasificacion = document.getElementById('clasificacion').value;
            
            if (!titulo) {
                alert('Por favor ingresa el título de la película');
                e.preventDefault();
                return;
            }
            
            if (!genero) {
                alert('Por favor ingresa el género de la película');
                e.preventDefault();
                return;
            }
            
            if (!clasificacion) {
                alert('Por favor selecciona una clasificación');
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html>