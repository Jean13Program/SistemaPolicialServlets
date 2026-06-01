package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL = "jdbc:mysql://localhost:3306/gestion_policial?serverTimezone=UTC&useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USUARIO = "root";
    private static final String CLAVE = "adminsena";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver MySQL cargado correctamente.");
        } catch (ClassNotFoundException e) {
            System.out.println("Error: no se encontró el driver de MySQL.");
            e.printStackTrace();
        }
    }

    public static Connection conectar() throws SQLException {
        System.out.println("Intentando conectar a la base de datos gestion_policial...");
        return DriverManager.getConnection(URL, USUARIO, CLAVE);
    }
}