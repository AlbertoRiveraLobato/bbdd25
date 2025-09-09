-- -----------------------------------------------------
-- Archivo: "51. Domótica DML_01.sql"
-- Base de datos: DomoticaHogar
-- -----------------------------------------------------

USE DomoticaHogar;

-- =====================================================
-- INSERCIONES DE DATOS
-- =====================================================

-- Insertar datos en Habitaciones
INSERT INTO Habitaciones (nombre) VALUES
('Salón'),
('Cocina'),
('Dormitorio Principal'),
('Dormitorio Invitados'),
('Baño'),
('Estudio'),
('Terraza');

-- Insertar datos en Dispositivos
INSERT INTO Dispositivos (nombre, tipo, ubicacion, estado, id_habitacion_FK) VALUES
('TV Samsung', 'Televisor', 'Pared principal', TRUE, 1),
('Aire Acondicionado', 'Climatización', 'Techo', FALSE, 1),
('Luces LED', 'Iluminación', 'Techo', TRUE, 1),
('Frigorífico', 'Electrodoméstico', 'Esquina derecha', TRUE, 2),
('Horno Inteligente', 'Electrodoméstico', 'Encimera', TRUE, 2),
('Sensor Movimiento', 'Seguridad', 'Entrada', TRUE, 3),
('Cámara Vigilancia', 'Seguridad', 'Exterior', TRUE, 7),
('Termostato', 'Climatización', 'Pared', TRUE, 3);

-- Insertar datos en Usuarios
INSERT INTO Usuarios (nombre, correo, contraseña, telefono) VALUES
('Ana García', 'ana@email.com', SHA2('password123', 256), '+34 612345678'),
('Carlos López', 'carlos@email.com', SHA2('securepass', 256), '+34 687654321'),
('Maria Rodriguez', 'maria@email.com', SHA2('mipass123', 256), NULL);

-- Insertar acciones programadas
INSERT INTO AccionesProgramadas (id_dispositivo_FK, accion, hora_programada, fecha_programada) VALUES
(3, 'Encender luces', '19:00:00', CURDATE()),
(2, 'Apagar aire acondicionado', '23:30:00', CURDATE()),
(3, 'Atenuar luces al 50%', '22:00:00', CURDATE() + INTERVAL 1 DAY);

-- =====================================================
-- LOAD DATA INFILE (Importar desde CSV)
-- =====================================================

/*
-- Crear archivo CSV primero (ejemplo: dispositivos_nuevos.csv)
-- id_dispositivo_PK,nombre,tipo,ubicacion,estado,id_habitacion_FK
-- ,'Robot Aspirador','Limpieza','Suelo',1,1
-- ,'Altavoz Inteligente','Audio','Estantería',1,1

LOAD DATA INFILE '/tmp/dispositivos_nuevos.csv'
INTO TABLE Dispositivos
FIELDS TERMINATED BY ','
ENCLOSED BY "'"
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nombre, tipo, ubicacion, estado, id_habitacion_FK);
*/

-- =====================================================
-- ACTUALIZACIONES (UPDATE)
-- =====================================================

-- Actualizar estado de un dispositivo
UPDATE Dispositivos 
SET estado = FALSE 
WHERE id_dispositivo_PK = 2;

-- Actualizar ubicación de múltiples dispositivos
UPDATE Dispositivos 
SET ubicacion = 'Techo central'
WHERE tipo = 'Iluminación' AND id_habitacion_FK = 1;

-- Actualizar teléfono de usuario
UPDATE Usuarios 
SET telefono = '+34 600123456'
WHERE id_usuario_PK = 3;

-- =====================================================
-- MERGE/REPLACE (UPSERT)
-- =====================================================

-- INSERT ... ON DUPLICATE KEY UPDATE
INSERT INTO Usuarios (id_usuario_PK, nombre, correo, contraseña, telefono)
VALUES (1, 'Ana García Modificado', 'ana@email.com', SHA2('nuevopassword', 256), '+34 612345678')
ON DUPLICATE KEY UPDATE 
nombre = VALUES(nombre), 
contraseña = VALUES(contraseña);

-- REPLACE (borra y inserta si existe clave duplicada)
REPLACE INTO Dispositivos (id_dispositivo_PK, nombre, tipo, ubicacion, estado, id_habitacion_FK)
VALUES (5, 'Horno Super Inteligente', 'Electrodoméstico', 'Encimera', TRUE, 2);

-- =====================================================
-- ELIMINACIONES (DELETE)
-- =====================================================

-- Eliminar acciones programadas antiguas
DELETE FROM AccionesProgramadas 
WHERE fecha_programada < '2024-01-01';

-- Eliminar usuario específico
DELETE FROM Usuarios 
WHERE id_usuario_PK = 3;

-- =====================================================
-- TRUNCATE vs DELETE vs DROP
-- =====================================================

-- TRUNCATE: Elimina todos los registros y reinicia auto_increment
TRUNCATE TABLE RegistroActividades;

-- DELETE: Elimina registros pero mantiene estructura
DELETE FROM AccionesProgramadas 
WHERE id_accion_PK BETWEEN 10 AND 20;

-- CREATE TABLE LIKE + DROP: Copiar estructura y eliminar original
CREATE TABLE Habitaciones_backup LIKE Habitaciones;
INSERT INTO Habitaciones_backup SELECT * FROM Habitaciones;
DROP TABLE Habitaciones;

