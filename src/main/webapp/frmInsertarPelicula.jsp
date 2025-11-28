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
            text-decoration: none;
            display: inline-block;
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
        .duration-group > div { 
            flex: 1; 
        }
        .duration-group label { 
            font-size: 14px; 
            font-weight: normal; 
        }
        .required { 
            color: red; 
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎬 Agregar Nueva Película</h1>
        
        <%
            // DEBUG: Mostrar que el JSP se está ejecutando
            System.out.println("🔄 JSP frmInsertarPelicula.jsp cargado");
            
            // Procesar el formulario cuando se envía
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                System.out.println("📨 Formulario enviado por POST");
                
                String titulo = request.getParameter("titulo");
                String horasStr = request.getParameter("horas");
                String minutosStr = request.getParameter("minutos");
                String genero = request.getParameter("genero");
                String clasificacion = request.getParameter("clasificacion");
                
                // DEBUG: Mostrar parámetros
                System.out.println("📊 Parámetros recibidos:");
                System.out.println("   Título: " + titulo);
                System.out.println("   Horas: " + horasStr);
                System.out.println("   Minutos: " + minutosStr);
                System.out.println("   Género: " + genero);
                System.out.println("   Clasificación: " + clasificacion);
                
                try {
                    // Validar campos obligatorios
                    if (titulo != null && !titulo.trim().isEmpty() &&
                        horasStr != null && minutosStr != null &&
                        genero != null && !genero.trim().isEmpty() &&
                        clasificacion != null && !clasificacion.isEmpty()) {
                        
                        // Convertir horas y minutos a Duration
                        int horas = Integer.parseInt(horasStr);
                        int minutos = Integer.parseInt(minutosStr);
                        
                        // Validar que al menos uno de los dos tenga valor
                        if (horas == 0 && minutos == 0) {
        %>
                            <div class="message error">
                                ❌ La duración debe ser mayor a 0. Ingresa horas o minutos.
                            </div>
        <%
                        } else {
                            Duration duracion = Duration.ofHours(horas).plusMinutes(minutos);
                            
                            System.out.println("⏱️ Duración calculada: " + duracion);
                            
                            // Crear objeto Pelicula
                            Pelicula pelicula = new Pelicula();
                            pelicula.setTitulo(titulo.trim());
                            pelicula.setDuracion(duracion);
                            pelicula.setGenero(genero.trim());
                            pelicula.setClasificacion(clasificacion);
                            
                            System.out.println("🔄 Llamando a PeliculaDAO...");
                            
                            // Insertar en la base de datos
                            PeliculaDAO dao = new PeliculaDAO();
                            dao.insertarPeliculas(pelicula);
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
                        }
                    } else {
                        System.out.println("❌ Campos incompletos");
        %>
                        <div class="message error">
                            ❌ Por favor, completa todos los campos obligatorios.
                        </div>
        <%
                    }
                } catch (NumberFormatException e) {
                    System.out.println("❌ Error en formato numérico: " + e.getMessage());
        %>
                    <div class="message error">
                        ❌ Error en el formato de horas o minutos. Usa solo números.
                    </div>
        <%
                } catch (Exception e) {
                    System.out.println("❌ Error en JSP: " + e.getMessage());
        %>
                    <div class="message error">
                        ❌ Error al agregar la película: <%= e.getMessage() %>
                    </div>
        <%
                    e.printStackTrace();
                }
            }
        %>
        
        <form method="POST" action="" onsubmit="return validarFormulario()">
            <div class="form-group">
                <label for="titulo">Título de la Película <span class="required">*</span></label>
                <input type="text" id="titulo" name="titulo" required 
                       placeholder="Ej: Avengers: Endgame" 
                       value="<%= request.getParameter("titulo") != null ? request.getParameter("titulo") : "" %>">
            </div>
            
            <div class="form-group">
                <label for="duracion">Duración <span class="required">*</span></label>
                <div class="duration-group">
                    <div>
                        <label for="horas">Horas</label>
                        <input type="number" id="horas" name="horas" min="0" max="10" 
                               value="<%= request.getParameter("horas") != null ? request.getParameter("horas") : "2" %>" 
                               required>
                    </div>
                    <div>
                        <label for="minutos">Minutos</label>
                        <input type="number" id="minutos" name="minutos" min="0" max="59" 
                               value="<%= request.getParameter("minutos") != null ? request.getParameter("minutos") : "30" %>" 
                               required>
                    </div>
                </div>
                <small style="color: #666;">Ejemplo: 2 horas y 30 minutos se guardará como "2h 30m"</small>
            </div>
            
            <div class="form-group">
                <label for="genero">Género <span class="required">*</span></label>
                <input type="text" id="genero" name="genero" required 
                       placeholder="Ej: Acción, Comedia, Drama, Terror"
                       value="<%= request.getParameter("genero") != null ? request.getParameter("genero") : "" %>">
            </div>
            
            <div class="form-group">
                <label for="clasificacion">Clasificación <span class="required">*</span></label>
                <select id="clasificacion" name="clasificacion" required>
                    <option value="">Selecciona una clasificación</option>
                    <option value="G" <%= "G".equals(request.getParameter("clasificacion")) ? "selected" : "" %>>G - Todo público</option>
                    <option value="PG" <%= "PG".equals(request.getParameter("clasificacion")) ? "selected" : "" %>>PG - Guía paternal sugerida</option>
                    <option value="PG-13" <%= "PG-13".equals(request.getParameter("clasificacion")) || request.getParameter("clasificacion") == null ? "selected" : "" %>>PG-13 - Mayores de 13 años</option>
                    <option value="R" <%= "R".equals(request.getParameter("clasificacion")) ? "selected" : "" %>>R - Mayores de 17 años</option>
                    <option value="NC-17" <%= "NC-17".equals(request.getParameter("clasificacion")) ? "selected" : "" %>>NC-17 - Solo adultos</option>
                    <option value="A" <%= "A".equals(request.getParameter("clasificacion")) ? "selected" : "" %>>A - Solo adultos</option>
                </select>
            </div>
            
            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn">🎬 Guardar Película</button>
                <a href="frmListadoPeliculas.jsp" class="btn btn-cancel">❌ Cancelar</a>
            </div>
        </form>
    </div>

    <script>
        function validarFormulario() {
            const horas = parseInt(document.getElementById('horas').value) || 0;
            const minutos = parseInt(document.getElementById('minutos').value) || 0;
            
            if (horas === 0 && minutos === 0) {
                alert('❌ La duración debe ser mayor a 0. Ingresa al menos horas o minutos.');
                return false;
            }
            
            if (minutos >= 60) {
                alert('❌ Los minutos no pueden ser 60 o más. Usa las horas para valores mayores.');
                return false;
            }
            
            return true;
        }
        
        // Validación en tiempo real para minutos
        document.getElementById('minutos').addEventListener('change', function() {
            if (this.value >= 60) {
                alert('⚠️ Los minutos no pueden ser 60 o más. Se ajustará automáticamente.');
                this.value = 59;
            }
        });
        
        // Mantener los valores del formulario después del envío (en caso de error)
        window.addEventListener('load', function() {
            // Los valores ya se mantienen gracias al JSP
        });
    </script>
</body>
</html>