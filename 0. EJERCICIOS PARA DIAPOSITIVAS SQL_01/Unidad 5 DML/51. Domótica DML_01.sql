INSERT INTO Habitaciones (nombre) VALUES
('Salón'),
('Cocina'),
('Dormitorio Principal'),
('Dormitorio Invitados'),
('Baño'),
('Estudio'),
('Terraza');
INSERT INTO Dispositivos (nombre, tipo, ubicacion, estado, id_habitacion_FK) VALUES
('TV Samsung', 'Televisor', 'Pared principal', TRUE, 1),
('Aire Acondicionado', 'Climatización', 'Techo', FALSE, 1),
('Luces LED', 'Iluminación', 'Techo', TRUE, 1),
('Frigorífico', 'Electrodoméstico', 'Esquina derecha', TRUE, 2),
('Horno Inteligente', 'Electrodoméstico', 'Encimera', TRUE, 2),
('Sensor Movimiento', 'Seguridad', 'Entrada', TRUE, 3),
('Cámara Vigilancia', 'Seguridad', 'Exterior', TRUE, 7),
('Termostato', 'Climatización', 'Pared', TRUE, 3);
INSERT INTO Usuarios (nombre, correo, contraseña, telefono) VALUES
('Ana García', 'ana@email.com', SHA2('password123', 256), '+34 612345678'),
('Carlos López', 'carlos@email.com', SHA2('securepass', 256), '+34 687654321'),
('Maria Rodriguez', 'maria@email.com', SHA2('mipass123', 256), NULL);
INSERT INTO AccionesProgramadas (id_dispositivo_FK, accion, hora_programada, fecha_programada) VALUES
(3, 'Encender luces', '19:00:00', CURDATE()),
(2, 'Apagar aire acondicionado', '23:30:00', CURDATE()),
(3, 'Atenuar luces al 50%', '22:00:00', CURDATE() + INTERVAL 1 DAY);
UPDATE Dispositivos 
SET estado = FALSE 
WHERE id_dispositivo_PK = 2;
UPDATE Dispositivos 
SET ubicacion = 'Techo central'
WHERE tipo = 'Iluminación' AND id_habitacion_FK = 1;
UPDATE Usuarios 
SET telefono = '+34 600123456'
WHERE id_usuario_PK = 3;
INSERT INTO Usuarios (id_usuario_PK, nombre, correo, contraseña, telefono)
VALUES (1, 'Ana García Modificado', 'ana@email.com', SHA2('nuevopassword', 256), '+34 612345678')
ON DUPLICATE KEY UPDATE 
nombre = VALUES(nombre), 
contraseña = VALUES(contraseña);
REPLACE INTO Dispositivos (id_dispositivo_PK, nombre, tipo, ubicacion, estado, id_habitacion_FK)
VALUES (5, 'Horno Super Inteligente', 'Electrodoméstico', 'Encimera', TRUE, 2);
DELETE FROM AccionesProgramadas 
WHERE fecha_programada < '2024-01-01';
DELETE FROM Usuarios 
WHERE id_usuario_PK = 3;
TRUNCATE TABLE RegistroActividades;
DELETE FROM AccionesProgramadas 
WHERE id_accion_PK BETWEEN 10 AND 20;
CREATE TABLE Habitaciones_backup LIKE Habitaciones;
INSERT INTO Habitaciones_backup SELECT * FROM Habitaciones;
DROP TABLE Habitaciones;

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
-- INSERCIONES DE DATOS
-- =============================================
INSERT INTO Habitaciones (nombre) VALUES
('Salón'), ('Cocina'), ('Dormitorio Principal'), ('Dormitorio Invitados'), ('Baño'), ('Estudio'), ('Terraza');

INSERT INTO Dispositivos (nombre, tipo, ubicacion, estado, id_habitacion_FK) VALUES
('TV Samsung', 'Televisor', 'Pared principal', TRUE, 1),
('Aire Acondicionado', 'Climatización', 'Techo', FALSE, 1),
('Luces LED', 'Iluminación', 'Techo', TRUE, 1);

INSERT INTO Usuarios (nombre, correo, contraseña, telefono) VALUES
('Ana García', 'ana@email.com', SHA2('password123', 256), '+34 612345678');

-- =============================================
-- CARGA MASIVA DE DATOS
-- =============================================
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

-- =============================================
-- ACTUALIZACIONES (UPDATE)
-- =============================================
UPDATE Dispositivos SET estado = FALSE WHERE id_dispositivo_PK = 2;

-- =============================================
-- ELIMINACIONES (DELETE)
-- =============================================
DELETE FROM Usuarios WHERE id_usuario_PK = 1;

-- =============================================
-- ERRORES COMUNES
-- =============================================
-- Error 1: Violación de clave foránea
-- INSERT INTO Dispositivos (nombre, tipo, ubicacion, estado, id_habitacion_FK) VALUES ('X', 'Y', 'Z', 1, 99); -- Error: no existe la habitación 99

-- Error 2: Violación de clave única
-- INSERT INTO Usuarios (id_usuario_PK, nombre, correo, contraseña, telefono) VALUES (1, 'Ana', 'ana@email.com', 'x', 'y'); -- Error: clave duplicada

-- Error 3: Tipos incompatibles
-- INSERT INTO Habitaciones (nombre) VALUES (123); -- Error: tipo incorrecto

