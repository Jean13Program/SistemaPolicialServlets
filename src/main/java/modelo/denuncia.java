package modelo;

public class denuncia {

    private int idDenuncia;
    private int idCiudadano;
    private String numeroDocumento;
    private String nombresApellidos;
    private String numeroRadicado;
    private String telefonoCelular;
    private String fechaHoraIncidente;
    private String lugarIncidente;
    private Double latitud;
    private Double longitud;
    private String descripcionDetallada;
    private String rutaPruebaAdjunta;
    private String estadoActual;
    private String descripcionEstado;
    private String fechaUltimaActualizacion;

    public denuncia() {
    }

    public int getIdDenuncia() {
        return idDenuncia;
    }

    public void setIdDenuncia(int idDenuncia) {
        this.idDenuncia = idDenuncia;
    }

    public int getIdCiudadano() {
        return idCiudadano;
    }

    public void setIdCiudadano(int idCiudadano) {
        this.idCiudadano = idCiudadano;
    }

    public String getNumeroDocumento() {
        return numeroDocumento;
    }

    public void setNumeroDocumento(String numeroDocumento) {
        this.numeroDocumento = numeroDocumento;
    }

    public String getNombresApellidos() {
        return nombresApellidos;
    }

    public void setNombresApellidos(String nombresApellidos) {
        this.nombresApellidos = nombresApellidos;
    }

    public String getNumeroRadicado() {
        return numeroRadicado;
    }

    public void setNumeroRadicado(String numeroRadicado) {
        this.numeroRadicado = numeroRadicado;
    }

    public String getTelefonoCelular() {
        return telefonoCelular;
    }

    public void setTelefonoCelular(String telefonoCelular) {
        this.telefonoCelular = telefonoCelular;
    }

    public String getFechaHoraIncidente() {
        return fechaHoraIncidente;
    }

    public void setFechaHoraIncidente(String fechaHoraIncidente) {
        this.fechaHoraIncidente = fechaHoraIncidente;
    }

    public String getLugarIncidente() {
        return lugarIncidente;
    }

    public void setLugarIncidente(String lugarIncidente) {
        this.lugarIncidente = lugarIncidente;
    }

    public Double getLatitud() {
        return latitud;
    }

    public void setLatitud(Double latitud) {
        this.latitud = latitud;
    }

    public Double getLongitud() {
        return longitud;
    }

    public void setLongitud(Double longitud) {
        this.longitud = longitud;
    }

    public String getDescripcionDetallada() {
        return descripcionDetallada;
    }

    public void setDescripcionDetallada(String descripcionDetallada) {
        this.descripcionDetallada = descripcionDetallada;
    }

    public String getRutaPruebaAdjunta() {
        return rutaPruebaAdjunta;
    }

    public void setRutaPruebaAdjunta(String rutaPruebaAdjunta) {
        this.rutaPruebaAdjunta = rutaPruebaAdjunta;
    }

    public String getEstadoActual() {
        return estadoActual;
    }

    public void setEstadoActual(String estadoActual) {
        this.estadoActual = estadoActual;
    }

    public String getDescripcionEstado() {
        return descripcionEstado;
    }

    public void setDescripcionEstado(String descripcionEstado) {
        this.descripcionEstado = descripcionEstado;
    }

    public String getFechaUltimaActualizacion() {
        return fechaUltimaActualizacion;
    }

    public void setFechaUltimaActualizacion(String fechaUltimaActualizacion) {
        this.fechaUltimaActualizacion = fechaUltimaActualizacion;
    }
}