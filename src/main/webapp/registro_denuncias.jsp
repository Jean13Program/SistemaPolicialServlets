<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Denuncias - Gestión Policial</title>

    <link rel="stylesheet" href="diseño_pagina.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
</head>
<body>

<%
    String mensajeRegistro = (String) request.getAttribute("mensaje");
    String radicadoGenerado = (String) request.getAttribute("radicadoGenerado");
%>

    <div id="menu-overlay" class="menu-overlay" onclick="toggleMenu()"></div>

    <div id="side-menu" class="side-menu">
        <button class="close-btn" onclick="toggleMenu()">&times;</button>

        <div class="user-info" style="padding: 0 25px; margin-bottom: 20px;">
            <span style="font-weight:bold; display:block;">Usuario:</span>
            <span>Nombre de Usuario</span>
        </div>

        <nav>
            <a href="index.html">Inicio</a>
            <a href="registro_denuncias.jsp" class="menu-selected">Registro de Denuncias</a>
            <a href="consulta_denuncias.jsp">Consulta de Denuncias</a>
        </nav>
    </div>

    <header class="dashboard-header">
        <div class="header-left-container">
            <span class="menu-hamburger-icon" onclick="toggleMenu()">☰</span>
            <div class="user-info">
                <span class="user-label">Usuario:</span>
                <span class="user-name">Nombre de Usuario</span>
            </div>
        </div>
        <div class="header-logo-container">
            <img src="imagenes/WhatsApp Image 2025-12-21 at 7.44.05 PM.jpeg" alt="Gestión Policial" class="mini-logo">
        </div>
    </header>

    <nav class="breadcrumb-bar">
        <div class="container">
            <a href="index.html">Inicio</a> /
            <span class="current-page">Registro de denuncias</span>
        </div>
    </nav>

    <main class="dashboard-container form-page-container">
        <h1>Registro de denuncias</h1>

        <%
            if (mensajeRegistro != null) {
        %>
            <div id="toast-success" class="toast show">
                <%= mensajeRegistro %>
                <%
                    if (radicadoGenerado != null) {
                %>
                    <br><strong>Radicado generado:</strong> <%= radicadoGenerado %>
                <%
                    }
                %>
            </div>
        <%
            }
        %>

        <form class="denuncia-form" id="denuncia-form"
              action="${pageContext.request.contextPath}/RegistrarDenunciaServlet"
              method="post"
              enctype="multipart/form-data">

            <section class="form-section">
                <h2>Formulario de denuncia:</h2>

                <div class="form-grid-2-cols">
                    <div class="form-group">
                        <label for="nombre_completo">Nombre completo:</label>
                        <input type="text" id="nombre_completo" name="nombre_completo" required>
                    </div>

                    <div class="form-group">
                        <label for="numero_identificacion">Tipo y número de identificación:</label>
                        <div class="input-group-mixed">
                            <select name="tipo_doc" id="tipo_doc" class="short-select">
                                <option value="Cédula de Ciudadanía">C.C</option>
                                <option value="Cédula de Extranjería">C.E</option>
                                <option value="Tarjeta de Identidad">T.I</option>
                            </select>
                            <input type="text" id="numero_identificacion" name="numero_identificacion" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="correo_denuncia">Correo electrónico:</label>
                        <input type="email" id="correo_denuncia" name="correo_denuncia" required>
                    </div>

                    <div class="form-group">
                        <label for="celular_denuncia">Teléfono celular:</label>
                        <input type="tel" id="celular_denuncia" name="celular_denuncia" required>
                    </div>
                </div>
            </section>

            <section class="form-section">
                <h2>Detalles del incidente:</h2>

                <div class="form-group date-time-group">
                    <label>Fecha y hora del incidente:</label>
                    <div class="date-inputs">
                        <input type="date" id="fecha_incidente" name="fecha_incidente" required>
                        <input type="time" id="hora_incidente" name="hora_incidente" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="direccion_incidente">Lugar del incidente:</label>

                    <div class="location-input-group">
                        <span class="search-icon">🔍</span>
                        <input type="text"
                               id="direccion_incidente"
                               name="direccion_incidente"
                               placeholder="Ingrese la dirección. Ejemplo: Calle 18 # 25-40, Pasto"
                               required>
                    </div>

                    <button type="button"
                            class="btn-action btn-wireframe-blue"
                            id="btn-buscar-direccion"
                            style="margin-bottom: 15px;">
                        Buscar dirección en el mapa
                    </button>

                    <div id="map-container" class="map-placeholder"></div>

                    <small class="map-help">
                        Escriba una dirección y presione “Buscar dirección en el mapa”, o haga clic directamente en el mapa para marcar la ubicación exacta.
                    </small>

                    <input type="hidden" id="latitud" name="latitud">
                    <input type="hidden" id="longitud" name="longitud">
                </div>

                <div class="form-group">
                    <label for="descripcion_detallada">Descripción detallada del incidente:</label>
                    <textarea id="descripcion_detallada" name="descripcion_detallada" rows="6" required></textarea>
                </div>
            </section>

            <section class="form-section">
                <h2>Adjuntar pruebas:</h2>

                <div class="file-select-group">
                    <label for="file-upload-hidden">Subir archivo:</label>
                    <div class="file-input-wrapper">
                        <span id="file-chosen-text">Selecciona uno para subir</span>
                        <label for="file-upload-hidden" class="btn-fake-upload">Subir...</label>
                        <input type="file" id="file-upload-hidden" name="ruta_prueba_adjunta" hidden>
                    </div>
                </div>

                <div class="drop-zone" id="drop-zone-area">
                    <div class="drop-zone-content">
                        <img src="imagenes/nube.png" alt="Arrastra y suelta aquí" class="nube">
                        <p>Arrastra y suelta aquí un archivo</p>
                        <p class="dropped-file-name" id="dropped-file-name"></p>
                    </div>
                </div>
            </section>

            <div class="form-actions-container">
                <div class="buttons-group">
                    <button type="reset" class="btn-action btn-red">Limpiar formulario</button>
                    <button type="button" class="btn-action btn-gray" id="btn-borrador">Guardar borrador</button>
                    <button type="submit" class="btn-action btn-dark-blue">Enviar denuncia</button>
                </div>
                <a href="index.html" class="help-link-text">Volver al inicio</a>
            </div>
        </form>
    </main>

    <div id="toast-draft" class="toast">
        💾 Borrador guardado exitosamente.
    </div>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

    <script>
        let map;
        let marker;

        function inicializarMapa() {
            map = L.map('map-container').setView([1.2136, -77.2811], 13);

            L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '&copy; OpenStreetMap'
            }).addTo(map);

            map.on('click', function(e) {
                colocarMarcador(e.latlng.lat, e.latlng.lng);
            });

            setTimeout(function() {
                map.invalidateSize();
            }, 500);
        }

        function colocarMarcador(latitud, longitud) {
            document.getElementById('latitud').value = latitud;
            document.getElementById('longitud').value = longitud;

            if (marker) {
                map.removeLayer(marker);
            }

            marker = L.marker([latitud, longitud]).addTo(map);
            map.setView([latitud, longitud], 17);
        }

        async function buscarDireccion() {
            const direccion = document.getElementById('direccion_incidente').value.trim();

            if (direccion === "") {
                alert("Ingrese una dirección para buscar.");
                return;
            }

            const consulta = encodeURIComponent(direccion + ", Pasto, Nariño, Colombia");
            const url = "https://nominatim.openstreetmap.org/search?format=json&q=" + consulta + "&limit=1";

            try {
                const respuesta = await fetch(url);
                const datos = await respuesta.json();

                if (datos.length === 0) {
                    alert("No se encontró la dirección. Intente escribirla con más detalle.");
                    return;
                }

                const resultado = datos[0];
                const latitud = parseFloat(resultado.lat);
                const longitud = parseFloat(resultado.lon);

                document.getElementById('direccion_incidente').value = resultado.display_name;
                colocarMarcador(latitud, longitud);

            } catch (error) {
                alert("No fue posible buscar la dirección en este momento.");
                console.log(error);
            }
        }

        window.addEventListener('load', function() {
            inicializarMapa();

            const toastSuccess = document.getElementById('toast-success');
            if (toastSuccess) {
                setTimeout(function() {
                    toastSuccess.classList.remove('show');
                }, 5000);
            }
        });

        const btnBuscarDireccion = document.getElementById('btn-buscar-direccion');
        btnBuscarDireccion.addEventListener('click', buscarDireccion);

        const dropZone = document.getElementById('drop-zone-area');
        const droppedFileNameDisplay = document.getElementById('dropped-file-name');
        const hiddenInput = document.getElementById('file-upload-hidden');
        const fileChosenText = document.getElementById('file-chosen-text');
        const btnLimpiar = document.querySelector('.btn-red');
        const btnBorrador = document.getElementById('btn-borrador');
        const toastDraft = document.getElementById('toast-draft');

        dropZone.addEventListener('dragover', (e) => {
            e.preventDefault();
            dropZone.classList.add('drag-over-active');
        });

        dropZone.addEventListener('dragleave', () => {
            dropZone.classList.remove('drag-over-active');
        });

        dropZone.addEventListener('drop', (e) => {
            e.preventDefault();
            dropZone.classList.remove('drag-over-active');
            const files = e.dataTransfer.files;
            handleFiles(files);
        });

        hiddenInput.addEventListener('change', function() {
            handleFiles(hiddenInput.files);
        });

        function handleFiles(files) {
            if (files.length > 0) {
                hiddenInput.files = files;
                droppedFileNameDisplay.textContent = "Archivo seleccionado: " + files[0].name;
                fileChosenText.textContent = files[0].name;
            }
        }

        btnLimpiar.addEventListener('click', function() {
            droppedFileNameDisplay.textContent = "";
            fileChosenText.textContent = "Selecciona uno para subir";
            hiddenInput.value = "";
            document.getElementById('latitud').value = "";
            document.getElementById('longitud').value = "";

            if (marker) {
                map.removeLayer(marker);
                marker = null;
            }
        });

        btnBorrador.addEventListener('click', function() {
            toastDraft.classList.add('show');

            setTimeout(function() {
                toastDraft.classList.remove('show');
            }, 3000);
        });

        function toggleMenu() {
            const menu = document.getElementById('side-menu');
            const overlay = document.getElementById('menu-overlay');

            menu.classList.toggle('active');
            overlay.classList.toggle('active');

            setTimeout(function() {
                if (map) {
                    map.invalidateSize();
                }
            }, 300);
        }
    </script>

</body>
</html>