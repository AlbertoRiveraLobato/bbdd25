
-- ===========================================
-- CREACIÓN DE BASE DE DATOS Y TABLA DE EJEMPLO
-- ===========================================
CREATE DATABASE IF NOT EXISTS comandos;
USE comandos;

CREATE TABLE IF NOT EXISTS empresa (
	idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50),
	ciudad VARCHAR(50),
	país VARCHAR(50)
);

-- ===========================================
-- INSERCIONES DE DATOS
-- ===========================================

-- Insertar una empresa con todos los campos
INSERT INTO empresa (idEmpresa, nombre, ciudad) VALUES (1, 'PRYCA', 'San Fernando');

-- Si quiero meter datos, sin tener que indicar la PRIMARY_KEY, debo definir esa columna como AUTO_INCREMENT
INSERT INTO empresa (nombre, ciudad, país) VALUES ('CARREFOUR', 'San Fernando', 'España');

-- Varias filas de golpe

INSERT INTO empresa (nombre, ciudad, país) VALUES 
	('ECI', 'Mejorada', 'España'),
	('CARRODS', 'Oxford', 'Ingalterra'),
	('ALCAMPO', '', ''),
	('LIDL', 'Berlín', 'Alemania');

-- ===========================================
-- EJEMPLO: CLONAR UNA TABLA CON INSERT INTO ... SELECT
-- ===========================================

-- Crear una tabla de respaldo con la misma estructura
CREATE TABLE IF NOT EXISTS empresa_respaldo LIKE empresa;

-- Clonar todos los datos de empresa a empresa_respaldo
INSERT INTO empresa_respaldo SELECT * FROM empresa;

-- También puedes clonar solo algunas columnas o filas:
-- INSERT INTO empresa_respaldo (nombre, ciudad, país)
-- SELECT nombre, ciudad, país FROM empresa WHERE ciudad = 'San Fernando';