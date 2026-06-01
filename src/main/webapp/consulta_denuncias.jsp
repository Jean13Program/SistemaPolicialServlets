<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.denuncia" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consulta de Denuncias - Gestión Policial</title>
    <link rel="stylesheet" href="diseño_pagina.css">
</head>
<body>

<%
    denuncia denuncia = (denuncia) request.getAttribute("denuncia");
    String mensajeConsulta = (String) request.getAttribute("mensaje");

    String estadoActual = "";
    String fechaActualizacion = "";
    String horaActualizacion = "";
    String descripcionEstado = "";

    if (denuncia != null) {
        if (denuncia.getEstadoActual() != null) {
            estadoActual = denuncia.getEstadoActual();
        }

        if (denuncia.getFechaUltimaActualizacion() != null) {
            String[] partes = denuncia.getFechaUltimaActualizacion().split(" ");
            if (partes.length >= 2) {
                fechaActualizacion = partes[0];
                horaActualizacion = partes[1].substring(0, 5);
            }
        }

        if (denuncia.getDescripcionEstado() != null) {
            descripcionEstado = denuncia.getDescripcionEstado();
        }
    }
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
            <a href="registro_denuncias.jsp">Registro de Denuncias</a>
            <a href="consulta_denuncias.jsp" class="menu-selected">Consulta de Denuncias</a>
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
            <span class="current-page">Consulta de denuncias</span>
        </div>
    </nav>

    <main class="dashboard-container form-page-container">
        <h1>Consulta del estado de denuncias</h1>

        <%
            if (mensajeConsulta != null) {
        %>
            <div class="toast show">
                <%= mensajeConsulta %>
            </div>
        <%
            }
        %>

        <form class="denuncia-form" id="consulta-form"
              action="${pageContext.request.contextPath}/ConsultarDenunciaServlet"
              method="get">

            <section class="form-section">
                <h2>Formulario de búsqueda:</h2>
                <div class="form-grid-2-cols">
                    <div class="form-group">
                        <label for="num_radicado">Número de radicado:</label>
                        <input type="text" id="num_radicado" name="num_radicado" required>
                    </div>
                    <div class="form-group">
                        <label for="numero_identificacion">Número de identificación del denunciante:</label>
                        <div class="input-group-mixed">
                            <select name="tipo_doc" id="tipo_doc" class="short-select">
                                <option value="Cédula de Ciudadanía">C.C</option>
                                <option value="Cédula de Extranjería">C.E</option>
                                <option value="Tarjeta de Identidad">T.I</option>
                            </select>
                            <input type="text" id="numero_identificacion" name="numero_identificacion" required>
                        </div>
                    </div>
                </div>
                <div style="margin-top: 20px;">
                    <button type="submit" class="btn-action btn-wireframe-gray">Buscar</button>
                </div>
            </section>

            <section class="form-section">
                <h2>Denuncias encontradas:</h2>
                <div class="table-responsive">
                    <table class="results-table">
                        <thead>
                            <tr>
                                <th>Número de Radicado</th>
                                <th>Fecha y hora</th>
                                <th>Lugar incidente</th>
                                <th>Descripción del incidente</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (denuncia != null) {
                        %>
                            <tr>
                                <td><%= denuncia.getNumeroRadicado() %></td>
                                <td><%= denuncia.getFechaHoraIncidente() %></td>
                                <td><%= denuncia.getLugarIncidente() %></td>
                                <td><%= denuncia.getDescripcionDetallada() %></td>
                            </tr>
                        <%
                            } else {
                        %>
                            <tr>
                                <td colspan="4">Sin resultados aún. Realice una búsqueda.</td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="form-section" style="border-bottom: none;">
                <div class="form-group" style="margin-bottom: 30px;">
                    <label for="estado_actual_select" style="font-weight: bold;">Estado actual:</label>
                    <select id="estado_actual_select" style="max-width: 400px;" disabled>
                        <option selected>
                            <%= estadoActual.isEmpty() ? "Seleccione una para ver su estado actual... (En proceso...)" : estadoActual %>
                        </option>
                    </select>
                </div>

                <div class="form-group date-time-group">
                    <label>Fecha de la última actualización:</label>
                    <div class="date-inputs">
                        <input type="date" id="fecha_actualizacion" value="<%= fechaActualizacion %>" readonly>
                        <input type="time" id="hora_actualizacion" value="<%= horaActualizacion %>" readonly>
                    </div>
                </div>

                <div class="form-group">
                    <label for="descripcion_estado">Descripción del estado actual:</label>
                    <textarea id="descripcion_estado" rows="4" readonly><%= descripcionEstado %></textarea>
                </div>
            </section>

            <div class="form-actions-container" style="justify-content: center; gap: 20px;">
                <button type="button" class="btn-action btn-wireframe-gray"
                        onclick="window.print()"
                        style="display: flex; align-items: center; gap: 10px;">
                    <img src="imagenes/impresora.png" alt="" class="btn-icon-placeholder">
                    Imprimir
                </button>

                <button type="button" id="btn-descargar" class="btn-action btn-wireframe-blue"
                        style="display: flex; align-items: center; gap: 10px;">
                    <img src="imagenes/descargar.png" alt="" class="btn-icon-placeholder">
                    Descargar
                </button>

                <a href="index.html" class="help-link-text" style="align-self: center; margin-left: 20px;">Inicio</a>
            </div>
        </form>
    </main>

    <div id="toast-download" class="toast">
        ⬇️ Descargando archivo...
    </div>

    <script>
        function toggleMenu() {
            const menu = document.getElementById('side-menu');
            const overlay = document.getElementById('menu-overlay');
            menu.classList.toggle('active');
            overlay.classList.toggle('active');
        }

        const btnDescargar = document.getElementById('btn-descargar');
        const toastDownload = document.getElementById('toast-download');

        btnDescargar.addEventListener('click', function() {
            toastDownload.classList.add('show');

            setTimeout(function() {
                toastDownload.classList.remove('show');
            }, 3000);
        });
    </script>

</body>
</html>