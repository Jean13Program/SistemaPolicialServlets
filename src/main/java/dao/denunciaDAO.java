package dao;

import conexion.Conexion;
import modelo.denuncia;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;

public class denunciaDAO {

    private Integer obtenerIdCiudadanoPorDocumento(String numeroDocumento) {
        String sql = "SELECT id_usuario FROM usuarios WHERE TRIM(numero_documento) = ?";

        if (numeroDocumento == null || numeroDocumento.trim().isEmpty()) {
            System.out.println("El número de documento llegó vacío al DAO.");
            return null;
        }

        String documentoLimpio = numeroDocumento.trim();

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, documentoLimpio);

            System.out.println("Buscando ciudadano con documento: [" + documentoLimpio + "]");

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int idUsuario = rs.getInt("id_usuario");
                    System.out.println("Ciudadano encontrado. ID: " + idUsuario);
                    return idUsuario;
                } else {
                    System.out.println("No se encontró ciudadano con documento: [" + documentoLimpio + "]");
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al buscar el ciudadano: " + e.getMessage());
        }

        return null;
    }

    private void setStringOrNull(PreparedStatement ps, int index, String valor) throws SQLException {
        if (valor == null || valor.trim().isEmpty()) {
            ps.setNull(index, Types.VARCHAR);
        } else {
            ps.setString(index, valor.trim());
        }
    }

    private void setDoubleOrNull(PreparedStatement ps, int index, Double valor) throws SQLException {
        if (valor == null) {
            ps.setNull(index, Types.DECIMAL);
        } else {
            ps.setDouble(index, valor);
        }
    }

    public boolean insertar(denuncia denuncia) {
        Integer idCiudadano = obtenerIdCiudadanoPorDocumento(denuncia.getNumeroDocumento());

        if (idCiudadano == null) {
            System.out.println("No existe un ciudadano con ese número de documento.");
            return false;
        }

        String sql = "INSERT INTO denuncias "
                + "(numero_radicado, id_ciudadano, telefono_celular, fecha_hora_incidente, "
                + "lugar_incidente, latitud, longitud, descripcion_detallada, ruta_prueba_adjunta, "
                + "estado_actual, descripcion_estado) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, denuncia.getNumeroRadicado());
            ps.setInt(2, idCiudadano);
            ps.setString(3, denuncia.getTelefonoCelular());
            ps.setTimestamp(4, Timestamp.valueOf(denuncia.getFechaHoraIncidente()));
            ps.setString(5, denuncia.getLugarIncidente());
            setDoubleOrNull(ps, 6, denuncia.getLatitud());
            setDoubleOrNull(ps, 7, denuncia.getLongitud());
            setStringOrNull(ps, 8, denuncia.getDescripcionDetallada());
            setStringOrNull(ps, 9, denuncia.getRutaPruebaAdjunta());

            String estado = denuncia.getEstadoActual();
            if (estado == null || estado.trim().isEmpty()) {
                estado = "En proceso";
            }
            ps.setString(10, estado);

            setStringOrNull(ps, 11, denuncia.getDescripcionEstado());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al insertar denuncia: " + e.getMessage());
            return false;
        }
    }

    public denuncia consultarPorRadicadoYDocumento(String numeroRadicado, String numeroDocumento) {
        String sql = "SELECT d.id_denuncia, d.numero_radicado, d.id_ciudadano, "
                + "u.numero_documento, u.nombres_apellidos, d.telefono_celular, "
                + "d.fecha_hora_incidente, d.lugar_incidente, d.latitud, d.longitud, "
                + "d.descripcion_detallada, d.ruta_prueba_adjunta, d.estado_actual, "
                + "d.descripcion_estado, d.fecha_ultima_actualizacion "
                + "FROM denuncias d "
                + "INNER JOIN usuarios u ON d.id_ciudadano = u.id_usuario "
                + "WHERE TRIM(d.numero_radicado) = ? AND TRIM(u.numero_documento) = ?";

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, numeroRadicado.trim());
            ps.setString(2, numeroDocumento.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    denuncia d = new denuncia();

                    d.setIdDenuncia(rs.getInt("id_denuncia"));
                    d.setNumeroRadicado(rs.getString("numero_radicado"));
                    d.setIdCiudadano(rs.getInt("id_ciudadano"));
                    d.setNumeroDocumento(rs.getString("numero_documento"));
                    d.setNombresApellidos(rs.getString("nombres_apellidos"));
                    d.setTelefonoCelular(rs.getString("telefono_celular"));
                    d.setFechaHoraIncidente(String.valueOf(rs.getTimestamp("fecha_hora_incidente")));
                    d.setLugarIncidente(rs.getString("lugar_incidente"));

                    Object lat = rs.getObject("latitud");
                    Object lon = rs.getObject("longitud");

                    if (lat != null) {
                        d.setLatitud(rs.getDouble("latitud"));
                    }

                    if (lon != null) {
                        d.setLongitud(rs.getDouble("longitud"));
                    }

                    d.setDescripcionDetallada(rs.getString("descripcion_detallada"));
                    d.setRutaPruebaAdjunta(rs.getString("ruta_prueba_adjunta"));
                    d.setEstadoActual(rs.getString("estado_actual"));
                    d.setDescripcionEstado(rs.getString("descripcion_estado"));

                    Timestamp fechaUpdate = rs.getTimestamp("fecha_ultima_actualizacion");
                    if (fechaUpdate != null) {
                        d.setFechaUltimaActualizacion(fechaUpdate.toString());
                    }

                    return d;
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al consultar denuncia: " + e.getMessage());
        }

        return null;
    }
}