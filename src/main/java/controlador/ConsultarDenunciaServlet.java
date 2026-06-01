package controlador;

import dao.denunciaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.denuncia;

import java.io.IOException;

@WebServlet("/ConsultarDenunciaServlet")
public class ConsultarDenunciaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String numeroRadicado = request.getParameter("num_radicado");
        String numeroDocumento = request.getParameter("numero_identificacion");

        if (numeroRadicado == null || numeroRadicado.isBlank()
                || numeroDocumento == null || numeroDocumento.isBlank()) {
            request.setAttribute("mensaje", "Debe ingresar el número de radicado y el documento.");
            request.getRequestDispatcher("/consulta_denuncias.jsp").forward(request, response);
            return;
        }

        denunciaDAO dao = new denunciaDAO();
        denuncia denuncia = dao.consultarPorRadicadoYDocumento(numeroRadicado.trim(), numeroDocumento.trim());

        if (denuncia == null) {
            request.setAttribute("mensaje", "No se encontró ninguna denuncia con esos datos.");
        } else {
            request.setAttribute("denuncia", denuncia);
        }

        request.getRequestDispatcher("/consulta_denuncias.jsp").forward(request, response);
    }
}