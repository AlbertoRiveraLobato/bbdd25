
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

-- Insertar datos de ejemplo
INSERT INTO empresa (nombre, ciudad, país) VALUES
('ALCAMPO', 'Madrid', 'España'),
('CARREFOUR', 'Sevilla', 'España'),
('LIDL', 'Berlín', 'Alemania');

-- ===========================================
-- COMANDOS DE BORRADO
-- ===========================================

-- Borrar por clave primaria
DELETE FROM empresa
	WHERE idEmpresa = 6;

-- Método erróneo porque no fija una fila... podrían ser varias.
DELETE FROM empresa
	WHERE nombre = 'ALCAMPO';
