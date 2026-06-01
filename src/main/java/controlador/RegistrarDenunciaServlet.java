package controlador;

import dao.denunciaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import modelo.denuncia;

import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/RegistrarDenunciaServlet")
@MultipartConfig
public class RegistrarDenunciaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String nombreCompleto = obtenerTexto(request, "nombre_completo");
        String numeroDocumento = obtenerTexto(request, "numero_identificacion");
        String celular = obtenerTexto(request, "celular_denuncia");
        String fecha = obtenerTexto(request, "fecha_incidente");
        String hora = obtenerTexto(request, "hora_incidente");
        String lugar = obtenerTexto(request, "direccion_incidente");
        String descripcion = obtenerTexto(request, "descripcion_detallada");
        String latitudTexto = obtenerTexto(request, "latitud");
        String longitudTexto = obtenerTexto(request, "longitud");

        System.out.println("Documento recibido desde el formulario: [" + numeroDocumento + "]");

        String fechaHoraCompleta = fecha + " " + hora + ":00";
        String numeroRadicado = generarNumeroRadicado();

        Double latitud = convertirDouble(latitudTexto);
        Double longitud = convertirDouble(longitudTexto);

        if (latitud == null || longitud == null) {
            latitud = 1.2136;
            longitud = -77.2811;
        }

        String rutaPrueba = null;
        Part archivoPart = request.getPart("ruta_prueba_adjunta");

        if (archivoPart != null && archivoPart.getSize() > 0) {
            rutaPrueba = Paths.get(archivoPart.getSubmittedFileName()).getFileName().toString();
        }

        denuncia denuncia = new denuncia();
        denuncia.setNumeroRadicado(numeroRadicado);
        denuncia.setNumeroDocumento(numeroDocumento);
        denuncia.setNombresApellidos(nombreCompleto);
        denuncia.setTelefonoCelular(celular);
        denuncia.setFechaHoraIncidente(fechaHoraCompleta);
        denuncia.setLugarIncidente(lugar);
        denuncia.setLatitud(latitud);
        denuncia.setLongitud(longitud);
        denuncia.setDescripcionDetallada(descripcion);
        denuncia.setRutaPruebaAdjunta(rutaPrueba);
        denuncia.setEstadoActual("En proceso");
        denuncia.setDescripcionEstado(null);

        denunciaDAO dao = new denunciaDAO();
        boolean guardada = dao.insertar(denuncia);

        if (guardada) {
            request.setAttribute("mensaje", "Denuncia registrada correctamente para " + nombreCompleto + ".");
            request.setAttribute("radicadoGenerado", numeroRadicado);
        } else {
            request.setAttribute("mensaje", "No fue posible registrar la denuncia. Verifique que el ciudadano exista en la base de datos.");
        }

        request.getRequestDispatcher("/registro_denuncias.jsp").forward(request, response);
    }

    private String obtenerTexto(HttpServletRequest request, String parametro) {
        String valor = request.getParameter(parametro);

        if (valor == null) {
            return "";
        }

        return valor.trim();
    }

    private Double convertirDouble(String valor) {
        try {
            if (valor != null && !valor.trim().isEmpty()) {
                return Double.parseDouble(valor.trim());
            }
        } catch (NumberFormatException e) {
            return null;
        }

        return null;
    }

    private String generarNumeroRadicado() {
        DateTimeFormatter formato = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        String fechaActual = LocalDateTime.now().format(formato);
        int aleatorio = (int) (Math.random() * 9000) + 1000;

        return "RAD-" + fechaActual + "-" + aleatorio;
    }
}