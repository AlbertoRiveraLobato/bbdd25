-- =============================================
-- 03_UPDATE_y_MERGE.sql
-- =============================================
-- Ejemplo de uso de UPDATE, MERGE y UPSERT en MySQL/MariaDB.
-- Contenido:
--   - Creación de base de datos y tablas necesarias.
--   - Ejemplos de sentencias correctas de actualización, MERGE y UPSERT.
--   - Ejemplos de sentencias erróneas y explicación de los errores más comunes.

-- =============================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS
-- =============================================

CREATE DATABASE IF NOT EXISTS ejemplo_update_merge;
USE ejemplo_update_merge;

-- Tabla de empleados
CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    salario DECIMAL(10,2)
);

-- Tabla de productos
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) DEFAULT 0,
    stock INT DEFAULT 0,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de inventario (para ejemplos de MERGE simulado)
CREATE TABLE IF NOT EXISTS inventario (
    id INT PRIMARY KEY,
    producto VARCHAR(50),
    cantidad INT
);

-- Tabla de actualizaciones de salario
CREATE TABLE IF NOT EXISTS actualizaciones_salario (
    nombre VARCHAR(50),
    nuevo_salario DECIMAL(10,2)
);

-- Tabla de actualizaciones de precios
CREATE TABLE IF NOT EXISTS actualizaciones_precios (
    sku VARCHAR(20) NOT NULL,
    nuevo_precio DECIMAL(10,2) NOT NULL,
    fecha_cambio DATE
);

-- =============================================
-- EJEMPLOS DE USO CORRECTO
-- =============================================

-- UPDATE básico
INSERT INTO empleados (nombre, salario) VALUES ('Ana', 2000), ('Luis', 2500);
UPDATE empleados SET salario = 3000 WHERE nombre = 'Ana';

-- UPDATE de todos los registros (¡Cuidado!)
UPDATE empleados SET salario = 1000;

-- UPDATE con JOIN
INSERT INTO actualizaciones_salario VALUES ('Luis', 2700);
UPDATE empleados e
JOIN actualizaciones_salario a ON e.nombre = a.nombre
SET e.salario = a.nuevo_salario;

-- MERGE/UPSERT: INSERT ... ON DUPLICATE KEY UPDATE en productos
INSERT INTO productos (sku, nombre, precio, stock) VALUES ('SKU001', 'Laptop', 899.99, 10)
ON DUPLICATE KEY UPDATE precio = VALUES(precio), stock = VALUES(stock);

-- MERGE simulado en inventario
INSERT INTO inventario (id, producto, cantidad) VALUES (1, 'Tornillos', 100);
INSERT INTO inventario (id, producto, cantidad)
VALUES (1, 'Tornillos', 150)
ON DUPLICATE KEY UPDATE cantidad = VALUES(cantidad);

-- UPSERT avanzado en productos
INSERT INTO productos (sku, nombre, precio, stock) 
VALUES ('SKU002', 'Teclado Mecánico Premium', 99.99, 25)
ON DUPLICATE KEY UPDATE 
    nombre = VALUES(nombre),
    precio = VALUES(precio),
    stock = VALUES(stock),
    fecha_actualizacion = NOW();

-- Insertar múltiples con UPSERT
INSERT INTO productos (sku, nombre, precio, stock) VALUES
('SKU001', 'Laptop HP Actualizada', 879.99, 20),
('SKU005', 'Nuevo Producto', 49.99, 100)
ON DUPLICATE KEY UPDATE 
    nombre = VALUES(nombre),
    precio = VALUES(precio),
    stock = VALUES(stock),
    fecha_actualizacion = NOW();

-- Sincronización de precios con tabla temporal
CREATE TEMPORARY TABLE temp_precios_externos (
    sku VARCHAR(20) PRIMARY KEY,
    precio_externo DECIMAL(10,2) NOT NULL
);
INSERT INTO temp_precios_externos VALUES
('SKU001', 859.99),
('SKU002', 85.99),
('SKU006', 299.99);
INSERT INTO productos (sku, nombre, precio, stock)
SELECT tpe.sku, 'Producto Externo', tpe.precio_externo, 0
FROM temp_precios_externos tpe
ON DUPLICATE KEY UPDATE 
    precio = tpe.precio_externo,
    fecha_actualizacion = NOW();

-- =============================================
-- EJEMPLOS DE SENTENCIAS ERRÓNEAS Y EXPLICACIÓN
-- =============================================

-- Error 1: Olvidar WHERE y actualizar toda la tabla
-- UPDATE empleados SET salario = 1000; -- ¡Cuidado!

-- Error 2: No tener clave única para ON DUPLICATE KEY UPDATE
-- CREATE TABLE sin_clave (nombre VARCHAR(50));
-- INSERT INTO sin_clave (nombre) VALUES ('Ana') ON DUPLICATE KEY UPDATE nombre = 'Ana'; -- Error

-- Error 3: Tipos incompatibles
-- UPDATE empleados SET salario = 'texto'; -- Error: tipo incorrecto

-- Error 4: No hay clave primaria o índice único en MERGE simulado
-- INSERT INTO inventario (producto, cantidad) VALUES ('Clavos', 200)
-- ON DUPLICATE KEY UPDATE cantidad = VALUES(cantidad); -- Error: no hay clave única

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
