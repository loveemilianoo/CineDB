<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page
        import="dao.FuncionDAO, dao.PeliculaDAO, dao.SalaDAO, entity.Funcion, entity.Pelicula, entity.Sala, java.util.List, java.time.LocalDate, java.time.format.DateTimeFormatter"
        %>
        <!DOCTYPE html>
        <html lang="es">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Agregar Función Sala - Cine Prototype</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .section-title {
                    position: relative;
                    padding-bottom: 15px;
                    margin-bottom: 30px;
                }

                .section-title:after {
                    content: '';
                    position: absolute;
                    bottom: 0;
                    left: 50%;
                    transform: translateX(-50%);
                    width: 80px;
                    height: 3px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                }

                .hora-btn {
                    width: 100px;
                    transition: all 0.3s;
                }

                .hora-btn.selected {
                    background-color: #0d6efd;
                    color: white;
                    border-color: #0d6efd;
                }

                .price-display {
                    font-size: 2rem;
                    font-weight: bold;
                    color: #198754;
                }
            </style>
        </head>

        <body class="bg-light">
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <div class="container">
                    <a class="navbar-brand" href="frmMenu.jsp">
                        <i class="fa-solid fa-film me-2"></i>Cine
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav"
                        aria-controls="nav" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="nav">
                        <ul class="navbar-nav ms-auto">
                            <li class="nav-item"><a class="nav-link" href="frmMenu.jsp">Inicio</a></li>
                            <li class="nav-item"><a class="nav-link" href="frmSeleccionarPelicula.jsp">Boletos</a></li>
                            <li class="nav-item"><a class="nav-link" href="#">Comida</a></li>
                            <li class="nav-item"><a class="nav-link active"
                                    href="frmListadoPeliculas.jsp">Administrar</a></li>
                        </ul>
                    </div>
                </div>
            </nav>

            <main class="container my-5">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card shadow-sm border-0">
                            <div class="card-body p-5">
                                <h2 class="text-center section-title">Agregar Función Sala</h2>

                                <form action="AgregarFuncionServlet" method="post" id="funcionForm">
                                    <!-- Periodo -->
                                    <div class="mb-4">
                                        <label for="periodo" class="form-label fw-bold">Periodo</label>
                                        <div class="input-group">
                                            <input type="text" id="periodo" name="periodo" class="form-control"
                                                placeholder="Seleccione periodo..." required>
                                            <button type="button" id="btnAgregar31Dias"
                                                class="btn btn-outline-secondary">
                                                <i class="fa-solid fa-calendar-plus me-2"></i>31 Días
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Selección de Sala -->
                                    <div class="mb-4">
                                        <label for="sala" class="form-label fw-bold">Sala</label>
                                        <select id="sala" name="idSala" class="form-select" required>
                                            <option value="">-- Seleccionar Sala --</option>
                                            <% SalaDAO salaDAO=new SalaDAO(); List<Sala> salas = salaDAO.getSalas();
                                                for (Sala sala : salas) {
                                                %>
                                                <option value="<%= sala.getIdSala() %>">Sala <%= sala.getNumeroSala() %>
                                                        (Capacidad: <%= sala.getCapacidad() %>)</option>
                                                <% } %>
                                        </select>
                                    </div>

                                    <!-- Selección de Hora -->
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Hora de Inicio <span
                                                class="text-danger">*</span></label>
                                        <div class="row g-2">
                                            <div class="col-md-6">
                                                <label for="horas" class="form-label small text-muted">Horas
                                                    (0-23)</label>
                                                <input type="number" class="form-control" id="horas" name="horas"
                                                    min="0" max="23" value="<%= request.getParameter(" horas") !=null ?
                                                    request.getParameter("horas") : "20" %>" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="minutos" class="form-label small text-muted">Minutos
                                                    (0-59)</label>
                                                <input type="number" class="form-control" id="minutos" name="minutos"
                                                    min="0" max="59" value="<%= request.getParameter(" minutos") !=null
                                                    ? request.getParameter("minutos") : "30" %>" required>
                                            </div>
                                        </div>
                                        <div class="form-text mt-2"><i class="fa-solid fa-circle-info me-1"></i>Ejemplo:
                                            20 horas y 30 minutos se guardará como "20:30"</div>
                                        <input type="hidden" id="horaInicio" name="horaInicio">
                                    </div>

                                    <!-- Selección de Película -->
                                    <div class="mb-4">
                                        <label for="pelicula" class="form-label fw-bold">Película</label>
                                        <select id="pelicula" name="idPelicula" class="form-select" required>
                                            <option value="">-- Seleccionar Película --</option>
                                            <% PeliculaDAO peliculaDAO=new PeliculaDAO(); List<Pelicula> peliculas =
                                                peliculaDAO.getPeliculas();
                                                for (Pelicula pelicula : peliculas) {
                                                %>
                                                <option value="<%= pelicula.getIdPelicula() %>">
                                                    <%= pelicula.getTitulo() %> (<%= pelicula.getDuracion() %>)
                                                </option>
                                                <% } %>
                                        </select>
                                    </div>

                                    <!-- Precio -->
                                    <div class="text-center mb-4 p-3 bg-light rounded">
                                        <label class="text-muted mb-2">Precio Estimado</label>
                                        <div class="price-display" id="precioDisplay">$0.00</div>
                                    </div>

                                    <!-- Botones -->
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-success btn-lg">
                                            <i class="fa-solid fa-plus me-2"></i>Agregar Función
                                        </button>
                                        <a href="frmMenu.jsp" class="btn btn-outline-secondary">
                                            <i class="fa-solid fa-arrow-left me-2"></i>Volver al Menú
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <!-- Footer -->
            <footer class="bg-dark text-white py-4 mt-5">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h5><i class="fa-solid fa-film me-2"></i>Cine Prototype</h5>
                            <p class="mb-0">Más que cine, una experiencia.</p>
                        </div>
                        <div class="col-md-6 text-end">
                            <div class="btn-group" role="group">
                                <a href="frmSeleccionarPelicula.jsp" class="btn btn-outline-light btn-sm">
                                    <i class="fa-solid fa-ticket me-1"></i>Boletos
                                </a>
                                <a href="#" class="btn btn-outline-light btn-sm">
                                    <i class="fa-solid fa-popcorn me-1"></i>Comida
                                </a>
                                <a href="frmListadoPeliculas.jsp" class="btn btn-outline-light btn-sm">
                                    <i class="fa-solid fa-sliders me-1"></i>Administrar
                                </a>
                            </div>
                        </div>
                    </div>
                    <hr class="my-3">
                    <div class="text-center">
                        <p class="mb-0">© 2024 Cine Prototype. Sistema desarrollado con Java JSP y PostgreSQL</p>
                    </div>
                </div>
            </footer>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Variables globales
                const PRECIO_BASE = 202.30;
                let horaSeleccionada = '';
                let idPeliculaSeleccionada = '';

                // Inicialización cuando el DOM está listo
                document.addEventListener('DOMContentLoaded', function () {
                    inicializarEventos();
                    actualizarPrecio();
                });

                // Inicializar eventos
                function inicializarEventos() {
                    // Evento para el botón de 31 días
                    document.getElementById('btnAgregar31Dias').addEventListener('click', function () {
                        const fechaActual = new Date();
                        const fechaFin = new Date();
                        fechaFin.setDate(fechaActual.getDate() + 31);

                        const formato = { year: 'numeric', month: '2-digit', day: '2-digit' };
                        const periodo = fechaActual.toLocaleDateString('es-ES', formato) + ' - ' +
                            fechaFin.toLocaleDateString('es-ES', formato);

                        document.getElementById('periodo').value = periodo;
                    });

                    // Evento para cambio de sala
                    document.getElementById('sala').addEventListener('change', actualizarPrecio);

                    // Evento para cambio de película
                    document.getElementById('pelicula').addEventListener('change', function () {
                        idPeliculaSeleccionada = this.value;
                        actualizarPrecio();
                    });

                    // Sync hidden input for horaInicio (although we are using separate inputs now, the servlet might expect the combined string or we handle it there)
                    // The previous code had buttons updating a hidden input. 
                    // The NEW code has number inputs. We should probably construct the string on submit or let the servlet handle separate fields.
                    // Looking at the previous code, it had: <input type="hidden" id="horaInicio" name="horaInicio" required>
                    // And the servlet likely reads "horaInicio".
                    // So let's update the hidden input when the number inputs change.

                    const horasInput = document.getElementById('horas');
                    const minutosInput = document.getElementById('minutos');

                    function updateHiddenHora() {
                        const h = horasInput.value.padStart(2, '0');
                        const m = minutosInput.value.padStart(2, '0');
                        document.getElementById('horaInicio').value = h + ':' + m;
                    }

                    horasInput.addEventListener('change', updateHiddenHora);
                    minutosInput.addEventListener('change', updateHiddenHora);

                    // Initial update
                    updateHiddenHora();
                }

                // Actualizar precio display
                function actualizarPrecio() {
                    const sala = document.getElementById('sala').value;
                    const precioFinal = PRECIO_BASE;

                    document.getElementById('precioDisplay').textContent = `$${precioFinal.toFixed(2)}`;
                }

                // Validación del formulario antes de enviar
                document.getElementById('funcionForm').addEventListener('submit', function (e) {
                    if (!validarFormulario()) {
                        e.preventDefault();
                        alert('Por favor, complete todos los campos requeridos.');
                    }
                });

                function validarFormulario() {
                    const periodo = document.getElementById('periodo').value;
                    const sala = document.getElementById('sala').value;
                    // horaInicio is updated by the inputs
                    const hora = document.getElementById('horaInicio').value;
                    const pelicula = document.getElementById('pelicula').value;

                    return periodo && sala && hora && pelicula;
                }
            </script>
        </body>

        </html>