CREATE DATABASE IF NOT EXISTS comandos;
USE comandos;

CREATE TABLE IF NOT EXISTS empresa (
	idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50),
	ciudad VARCHAR(50),
	país VARCHAR(50)
);


INSERT INTO empresa (idEmpresa, nombre, ciudad) VALUES (1, 'PRYCA', 'San Fernando');

INSERT INTO empresa (nombre, ciudad, país) VALUES ('CARREFOUR', 'San Fernando', 'España');


INSERT INTO empresa (nombre, ciudad, país) VALUES 
	('ECI', 'Mejorada', 'España'),
	('CARRODS', 'Oxford', 'Ingalterra'),
	('ALCAMPO', '', ''),
	('LIDL', 'Berlín', 'Alemania');


CREATE TABLE IF NOT EXISTS empresa_respaldo LIKE empresa;

INSERT INTO empresa_respaldo SELECT * FROM empresa;



-- =============================================
-- 02_INSERT_INTO.sql
-- =============================================
-- Ejemplo de uso de INSERT INTO para insertar datos en MySQL/MariaDB.
-- Contenido:
--   - Creación de base de datos y tablas necesarias.
--   - Ejemplos de sentencias correctas de inserción de datos.
--   - Ejemplos de sentencias erróneas y explicación de los errores más comunes.

-- =============================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS
-- =============================================

CREATE DATABASE IF NOT EXISTS ejemplo_insert;
USE ejemplo_insert;

CREATE TABLE IF NOT EXISTS empresa (
	idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50),
	ciudad VARCHAR(50),
	pais VARCHAR(50)
);

-- =============================================
-- EJEMPLOS DE USO CORRECTO
-- =============================================

-- Insertar una empresa con todos los campos
INSERT INTO empresa (idEmpresa, nombre, ciudad, pais) VALUES (1, 'PRYCA', 'San Fernando', 'España');

-- Insertar sin especificar la clave primaria (AUTO_INCREMENT)
INSERT INTO empresa (nombre, ciudad, pais) VALUES ('CARREFOUR', 'San Fernando', 'España');

-- Insertar varias filas de golpe
INSERT INTO empresa (nombre, ciudad, pais) VALUES 
	('ECI', 'Mejorada', 'España'),
	('CARRODS', 'Oxford', 'Inglaterra'),
	('ALCAMPO', '', ''),
	('LIDL', 'Berlín', 'Alemania');

-- Clonar todos los datos de una tabla a otra
CREATE TABLE IF NOT EXISTS empresa_respaldo LIKE empresa;
INSERT INTO empresa_respaldo SELECT * FROM empresa;

-- Clonar solo algunas columnas o filas
-- INSERT INTO empresa_respaldo (nombre, ciudad, pais)
-- SELECT nombre, ciudad, pais FROM empresa WHERE ciudad = 'San Fernando';

-- =============================================
-- EJEMPLOS DE SENTENCIAS ERRÓNEAS Y EXPLICACIÓN
-- =============================================

-- Error 1: Número de columnas y valores no coincide
-- INSERT INTO empresa (nombre, ciudad) VALUES ('PRYCA', 'San Fernando', 'España'); -- Error

-- Error 2: Violación de clave única
-- INSERT INTO empresa (idEmpresa, nombre, ciudad, pais) VALUES (1, 'DUPLICADO', 'Madrid', 'España'); -- Error: clave duplicada

-- Error 3: Tipos incompatibles
-- INSERT INTO empresa (nombre, ciudad, pais) VALUES (123, 'Madrid', 'España'); -- Error: tipo incorrecto

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================

-- CREACIÓN DE BASE DE DATOS Y TABLAS
CREATE DATABASE IF NOT EXISTS ejemplo_insert;
USE ejemplo_insert;

CREATE TABLE empresa (
	idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50),
	ciudad VARCHAR(50),
	pais VARCHAR(50)
);

-- =============================================
-- EJEMPLOS DE USO
-- =============================================

-- Insertar una empresa con todos los campos
INSERT INTO empresa (idEmpresa, nombre, ciudad, pais) VALUES (1, 'PRYCA', 'San Fernando', 'España');

-- Insertar sin especificar la clave primaria (AUTO_INCREMENT)
INSERT INTO empresa (nombre, ciudad, pais) VALUES ('CARREFOUR', 'San Fernando', 'España');

-- Insertar varias filas de golpe
INSERT INTO empresa (nombre, ciudad, pais) VALUES 
	('ECI', 'Mejorada', 'España'),
	('CARRODS', 'Oxford', 'Inglaterra'),
	('ALCAMPO', '', ''),
	('LIDL', 'Berlín', 'Alemania');

-- Clonar todos los datos de una tabla a otra
CREATE TABLE empresa_respaldo LIKE empresa;
INSERT INTO empresa_respaldo SELECT * FROM empresa;

-- Clonar solo algunas columnas o filas
-- INSERT INTO empresa_respaldo (nombre, ciudad, pais)
-- SELECT nombre, ciudad, pais FROM empresa WHERE ciudad = 'San Fernando';

-- =============================================
-- ERRORES COMUNES
-- =============================================

-- Error 1: Número de columnas y valores no coincide
-- INSERT INTO empresa (nombre, ciudad) VALUES ('PRYCA', 'San Fernando', 'España'); -- Error

-- Error 2: Violación de clave única
-- INSERT INTO empresa (idEmpresa, nombre, ciudad, pais) VALUES (1, 'DUPLICADO', 'Madrid', 'España'); -- Error: clave duplicada

-- Error 3: Tipos incompatibles
-- INSERT INTO empresa (nombre, ciudad, pais) VALUES (123, 'Madrid', 'España'); -- Error: tipo incorrecto