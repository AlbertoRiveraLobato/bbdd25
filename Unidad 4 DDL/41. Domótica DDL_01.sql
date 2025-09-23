-- -----------------------------------------------------
-- Archivo: "41. Domótica DDL_01.sql"
-- Base de datos: DomoticaHogar
-- -----------------------------------------------------
DROP DATABASE IF EXISTS DomoticaHogar;
CREATE DATABASE DomoticaHogar;
USE DomoticaHogar;

-- -----------------------------------------------------
-- Tabla: Habitaciones
-- -----------------------------------------------------
CREATE TABLE Habitaciones (
    id_habitacion_PK INT AUTO_INCREMENT PRIMARY KEY, -- Clave primaria
    nombre VARCHAR(100) NOT NULL
) COMMENT = 'Habitaciones del hogar donde se ubican dispositivos';

-- -----------------------------------------------------
-- Tabla: Dispositivos
-- -----------------------------------------------------
CREATE TABLE Dispositivos (
    id_dispositivo_PK INT AUTO_INCREMENT PRIMARY KEY, -- Clave primaria
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(100),
    estado BOOLEAN DEFAULT TRUE,
    id_habitacion_FK INT NOT NULL, -- Clave foránea
    FOREIGN KEY (id_habitacion_FK) REFERENCES Habitaciones(id_habitacion_PK) ON DELETE CASCADE
) COMMENT = 'Dispositivos conectados en el hogar';

-- -----------------------------------------------------
-- Tabla: Usuarios
-- -----------------------------------------------------
CREATE TABLE Usuarios (
    id_usuario_PK INT AUTO_INCREMENT PRIMARY KEY, -- Clave primaria
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL
) COMMENT = 'Usuarios registrados en el sistema';

-- -----------------------------------------------------
-- Tabla: AccionesProgramadas
-- -----------------------------------------------------
CREATE TABLE AccionesProgramadas (
    id_accion_PK INT AUTO_INCREMENT PRIMARY KEY, -- Clave primaria
    id_dispositivo_FK INT NOT NULL,              -- Clave foránea
    accion VARCHAR(100) NOT NULL,
    hora_programada TIME NOT NULL,
    fecha_programada DATE NOT NULL,
    FOREIGN KEY (id_dispositivo_FK) REFERENCES Dispositivos(id_dispositivo_PK) ON DELETE CASCADE
) COMMENT = 'Acciones programadas para dispositivos';

-- -----------------------------------------------------
-- Tabla: RegistroActividades
-- -----------------------------------------------------
CREATE TABLE RegistroActividades (
    id_log_PK INT AUTO_INCREMENT PRIMARY KEY, -- Clave primaria
    id_dispositivo_FK INT NOT NULL,           -- Clave foránea
    accion VARCHAR(100) NOT NULL,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_dispositivo_FK) REFERENCES Dispositivos(id_dispositivo_PK) ON DELETE CASCADE
) COMMENT = 'Registro de actividad de los dispositivos';

-- -----------------------------------------------------
-- ALTER TABLE: Añadir columna a Usuarios
-- -----------------------------------------------------
ALTER TABLE Usuarios
ADD telefono VARCHAR(20) COMMENT 'Número de teléfono del usuario';

-- -----------------------------------------------------
-- CREATE VIEW: Vista de dispositivos activos
-- -----------------------------------------------------
CREATE VIEW VistaDispositivosActivos AS
SELECT nombre, tipo, ubicacion
FROM Dispositivos
WHERE estado = TRUE;

-- -----------------------------------------------------
-- CREATE INDEX: Índice en correo
-- -----------------------------------------------------
CREATE INDEX idx_correo ON Usuarios(correo);

-- -----------------------------------------------------
-- TRUNCATE TABLE: Vaciar tabla de registros
-- -----------------------------------------------------
TRUNCATE TABLE RegistroActividades;

-- -----------------------------------------------------
-- SHOW y DESCRIBE (para inspección)
-- -----------------------------------------------------
SHOW TABLES;
SHOW CREATE TABLE Dispositivos; -- muestra el código SQL completo que se utilizó para crear esa tabla
DESCRIBE Habitaciones;
SHOW INDEX FROM Usuarios;
SHOW CREATE VIEW VistaDispositivosActivos; -- muestra el código SQL completo que se utilizó para crear esa vista

-- -----------------------------------------------------
-- Fin del script
-- -----------------------------------------------------
