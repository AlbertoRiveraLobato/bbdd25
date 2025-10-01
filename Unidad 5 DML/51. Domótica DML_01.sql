
-- =============================================
-- 51. Domótica DML_01.sql
-- =============================================
-- Ejemplos de DML para una base de datos de domótica.
-- Incluye: creación de base de datos y tablas, ejemplos de inserción, actualización, borrado, carga masiva y errores comunes.

-- CREACIÓN DE BASE DE DATOS Y TABLAS
CREATE DATABASE IF NOT EXISTS DomoticaHogar;
USE DomoticaHogar;

CREATE TABLE Habitaciones (
	id_habitacion_PK INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50)
);

CREATE TABLE Dispositivos (
	id_dispositivo_PK INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50),
	tipo VARCHAR(50),
	ubicacion VARCHAR(50),
	estado BOOLEAN,
	id_habitacion_FK INT,
	FOREIGN KEY (id_habitacion_FK) REFERENCES Habitaciones(id_habitacion_PK)
);

CREATE TABLE Usuarios (
	id_usuario_PK INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50),
	correo VARCHAR(100),
	contraseña VARCHAR(256),
	telefono VARCHAR(20)
);

CREATE TABLE AccionesProgramadas (
	id_accion_PK INT AUTO_INCREMENT PRIMARY KEY,
	id_dispositivo_FK INT,
	accion VARCHAR(100),
	hora_programada TIME,
	fecha_programada DATE,
	FOREIGN KEY (id_dispositivo_FK) REFERENCES Dispositivos(id_dispositivo_PK)
);

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================
-- 1) Inserta los siguientes datos en la tabla Habitaciones:
--    'Salón', 'Cocina', 'Dormitorio Principal', 'Dormitorio Invitados', 'Baño', 'Estudio', 'Terraza'
-- 2) Inserta los siguientes dispositivos en la tabla Dispositivos:
--    ('TV Samsung', 'Televisor', 'Pared principal', TRUE, 1),
--    ('Aire Acondicionado', 'Climatización', 'Techo', FALSE, 1),
--    ('Luces LED', 'Iluminación', 'Techo', TRUE, 1)
-- 3) Inserta el usuario 'Ana García', correo 'ana@email.com', contraseña 'password123', teléfono '+34 612345678' en la tabla Usuarios.
-- 4) Carga masivamente los siguientes dispositivos desde un archivo CSV:
--    'Robot Aspirador','Limpieza','Suelo',1,1
--    'Altavoz Inteligente','Audio','Estantería',1,1
-- 5) Actualiza el estado del dispositivo con id 2 a FALSE.
-- 6) Elimina el usuario con id 1.
-- 7) Inserta una acción programada para encender las luces a las 19:00 de hoy.
-- 8) Muestra ejemplos de errores comunes: violación de clave foránea, clave única y tipos incompatibles.

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================
-- 1) Inserción de habitaciones
INSERT INTO Habitaciones (nombre) VALUES
('Salón'), ('Cocina'), ('Dormitorio Principal'), ('Dormitorio Invitados'), ('Baño'), ('Estudio'), ('Terraza');

-- 2) Inserción de dispositivos
INSERT INTO Dispositivos (nombre, tipo, ubicacion, estado, id_habitacion_FK) VALUES
('TV Samsung', 'Televisor', 'Pared principal', TRUE, 1),
('Aire Acondicionado', 'Climatización', 'Techo', FALSE, 1),
('Luces LED', 'Iluminación', 'Techo', TRUE, 1);

-- 3) Inserción de usuario
INSERT INTO Usuarios (nombre, correo, contraseña, telefono) VALUES
('Ana García', 'ana@email.com', SHA2('password123', 256), '+34 612345678');

-- 4) Carga masiva de dispositivos
-- Archivo: dispositivos_nuevos.csv
-- nombre,tipo,ubicacion,estado,id_habitacion_FK
-- 'Robot Aspirador','Limpieza','Suelo',1,1
-- 'Altavoz Inteligente','Audio','Estantería',1,1
--
-- LOAD DATA INFILE 'dispositivos_nuevos.csv'
-- INTO TABLE Dispositivos
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '\''
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (nombre, tipo, ubicacion, estado, id_habitacion_FK);

-- 5) Actualización de estado
UPDATE Dispositivos SET estado = FALSE WHERE id_dispositivo_PK = 2;

-- 6) Eliminación de usuario
DELETE FROM Usuarios WHERE id_usuario_PK = 1;

-- 7) Inserción de acción programada
INSERT INTO AccionesProgramadas (id_dispositivo_FK, accion, hora_programada, fecha_programada)
VALUES (3, 'Encender luces', '19:00:00', CURDATE());

-- 8) Ejemplos de errores comunes
-- Error 1: Violación de clave foránea
-- INSERT INTO Dispositivos (nombre, tipo, ubicacion, estado, id_habitacion_FK) VALUES ('X', 'Y', 'Z', 1, 99); -- Error: no existe la habitación 99

-- Error 2: Violación de clave única
-- INSERT INTO Usuarios (id_usuario_PK, nombre, correo, contraseña, telefono) VALUES (1, 'Ana', 'ana@email.com', 'x', 'y'); -- Error: clave duplicada

-- Error 3: Tipos incompatibles
-- INSERT INTO Habitaciones (nombre) VALUES (123); -- Error: tipo incorrecto

