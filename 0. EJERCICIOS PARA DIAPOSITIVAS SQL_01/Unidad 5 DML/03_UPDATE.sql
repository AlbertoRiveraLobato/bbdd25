CREATE DATABASE IF NOT EXISTS ejemplo_ddl;
USE ejemplo_ddl;
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    salario DECIMAL(10,2)
);

INSERT INTO empleados (nombre, salario) VALUES ('Ana', 2000), ('Luis', 2500);

UPDATE empleados SET salario = 3000 WHERE nombre = 'Ana';

UPDATE empleados SET 
    salario = 1000; -- ¡Cuidado! Todos los salarios se actualizan

UPDATE comandos.empresa SET
	ciudad = "Zaragoza";

-- =============================================
-- 03_UPDATE_y_MERGE.sql
-- =============================================
-- Ejemplos de uso de UPDATE y MERGE/UPSERT en MySQL.
-- Incluye: creación de base de datos y tablas, ejemplos de actualización, upsert y errores comunes.

-- CREACIÓN DE BASE DE DATOS Y TABLAS
CREATE DATABASE IF NOT EXISTS ejemplo_update;
USE ejemplo_update;

CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    salario DECIMAL(10,2)
);

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) DEFAULT 0,
    stock INT DEFAULT 0
);

-- =============================================
-- EJEMPLOS DE USO
-- =============================================

-- UPDATE básico
INSERT INTO empleados (nombre, salario) VALUES ('Ana', 2000), ('Luis', 2500);
UPDATE empleados SET salario = 3000 WHERE nombre = 'Ana';

-- UPDATE de todos los registros (¡Cuidado!)
UPDATE empleados SET salario = 1000;

-- UPDATE con JOIN
CREATE TABLE actualizaciones_salario (
    nombre VARCHAR(50),
    nuevo_salario DECIMAL(10,2)
);
INSERT INTO actualizaciones_salario VALUES ('Luis', 2700);
UPDATE empleados e
JOIN actualizaciones_salario a ON e.nombre = a.nombre
SET e.salario = a.nuevo_salario;

-- MERGE/UPSERT: INSERT ... ON DUPLICATE KEY UPDATE
INSERT INTO productos (sku, nombre, precio, stock) VALUES ('SKU001', 'Laptop', 899.99, 10)
ON DUPLICATE KEY UPDATE precio = VALUES(precio), stock = VALUES(stock);

-- =============================================
-- ERRORES COMUNES
-- =============================================

-- Error 1: Olvidar WHERE y actualizar toda la tabla
-- UPDATE empleados SET salario = 1000; -- ¡Cuidado!

-- Error 2: No tener clave única para ON DUPLICATE KEY UPDATE
-- CREATE TABLE sin_clave (nombre VARCHAR(50));
-- INSERT INTO sin_clave (nombre) VALUES ('Ana') ON DUPLICATE KEY UPDATE nombre = 'Ana'; -- Error

-- Error 3: Tipos incompatibles
-- UPDATE empleados SET salario = 'texto'; -- Error: tipo incorrecto