create database gestion_policial;
use gestion_policial;

CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT,
    nombre_rol VARCHAR(30) NOT NULL UNIQUE,
    PRIMARY KEY (id_rol)
);

INSERT INTO roles (nombre_rol) VALUES ('Ciudadano'), ('Policia'), ('Administrador');

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT,
    id_rol INT NOT NULL,
    nombres_apellidos VARCHAR(120) NOT NULL,
    tipo_documento ENUM('Cédula de Ciudadanía', 'Tarjeta de Identidad', 'Cédula de Extranjería') NOT NULL,
    numero_documento VARCHAR(15) NOT NULL UNIQUE,
    correo VARCHAR(120) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario),
    CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol) REFERENCES roles(id_rol) ON DELETE RESTRICT
);

CREATE TABLE denuncias (
    id_denuncia INT AUTO_INCREMENT,
    numero_radicado VARCHAR(100) NOT NULL UNIQUE,
    id_ciudadano INT NOT NULL,
    telefono_celular VARCHAR(15) NOT NULL,
    fecha_hora_incidente DATETIME NOT NULL,
    lugar_incidente VARCHAR(200) NOT NULL,
    latitud DECIMAL(10, 8),
    longitud DECIMAL(11, 8),
    descripcion_detallada TEXT NOT NULL,
    ruta_prueba_adjunta VARCHAR(255),
    estado_actual ENUM('En proceso', 'En investigación', 'Cerrado') DEFAULT 'En proceso',
    descripcion_estado TEXT,
    fecha_ultima_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    fecha_radicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_denuncia),
    CONSTRAINT fk_denuncia_ciudadano FOREIGN KEY (id_ciudadano) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE multas (
    id_multa INT AUTO_INCREMENT,
    id_infractor INT NOT NULL,
    referencia VARCHAR(60) NOT NULL UNIQUE,
    fecha DATE NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    descripcion_multa TEXT NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_multa),
    CONSTRAINT fk_multa_infractor FOREIGN KEY (id_infractor) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE casos (
    id_caso INT AUTO_INCREMENT,
    numero_caso VARCHAR(30) NOT NULL UNIQUE,
    id_denuncia INT NOT NULL,
    id_agente_asignado INT NOT NULL,
    estado_actual ENUM('En proceso', 'En investigación', 'Cerrado') DEFAULT 'En proceso',
    descripcion_estado TEXT,
    fecha_ultima_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    fecha_apertura DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_caso),
    CONSTRAINT fk_caso_denuncia FOREIGN KEY (id_denuncia) REFERENCES denuncias(id_denuncia) ON DELETE CASCADE,
    CONSTRAINT fk_caso_agente FOREIGN KEY (id_agente_asignado) REFERENCES usuarios(id_usuario) ON DELETE RESTRICT
);

CREATE TABLE audiencias (
    id_audiencia INT AUTO_INCREMENT,
    tipo_audiencia VARCHAR(80) NOT NULL,
    duracion_estimada VARCHAR(30) NOT NULL,
    lugar VARCHAR(210) NOT NULL,
    listado_participantes TEXT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    id_oficial_responsable INT NOT NULL, 
    funcionario_judicial VARCHAR(120) NOT NULL,
    proposito TEXT NOT NULL,
    estado ENUM('Borrador', 'Programada', 'Realizada', 'Cancelada') DEFAULT 'Borrador',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_audiencia),
    CONSTRAINT fk_audiencia_oficial FOREIGN KEY (id_oficial_responsable) REFERENCES usuarios(id_usuario) ON DELETE RESTRICT
);

INSERT INTO usuarios (id_rol, nombres_apellidos, tipo_documento, numero_documento, correo, contrasena) VALUES
(1, 'Jeancarlo Castillo', 'Cédula de Ciudadanía', '1085203471', 'jeankastillo13@gmail.com', 'contraseña123'),
(2, 'Marlon Narvaez', 'Cédula de Ciudadanía', '1080659411', 'marlon@policia.gov.co', 'contraseña124'),
(1, 'Lina Arango', 'Cédula de Ciudadanía', '1034901125', 'lina@gmail.com', 'contraseña125');

SELECT * FROM usuarios;

SELECT * FROM denuncias;

SHOW TABLES;

SELECT COUNT(*) FROM usuarios;


