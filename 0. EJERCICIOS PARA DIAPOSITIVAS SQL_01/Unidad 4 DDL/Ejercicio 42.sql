-- Ejercicio 42: Gestión de una tienda de informática

-- Crear base de datos y usarla
CREATE DATABASE IF NOT EXISTS TiendaInformatica;
USE TiendaInformatica;

-- Crear tabla productos
CREATE TABLE productos (
    idProducto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(8,2)
);

-- Insertar datos
INSERT INTO productos (nombre, precio) VALUES
('Ratón', 15.99),
('Teclado', 25.50),
('Monitor', 120.00);

-- Crear índice sobre nombre
CREATE INDEX idx_nombre_producto ON productos(nombre);

-- Añadir columna stock con valor por defecto
ALTER TABLE productos ADD stock INT DEFAULT 10;

-- Modificar tipo de columna precio
ALTER TABLE productos MODIFY precio DECIMAL(10,2);

-- Cambiar nombre de columna stock a unidades
ALTER TABLE productos CHANGE stock unidades INT DEFAULT 10;

-- Mostrar estructura y contenido
DESCRIBE productos;
SELECT * FROM productos;

-- Vaciar la tabla
TRUNCATE TABLE productos;

-- Insertar nuevos datos tras el truncate
INSERT INTO productos (nombre, precio, unidades) VALUES
('Altavoz', 35.00, 5);

-- Mostrar contenido actualizado
SELECT * FROM productos;

-- Eliminar índice
DROP INDEX idx_nombre_producto ON productos;

-- Eliminar la tabla
DROP TABLE productos;

-- Mostrar tablas existentes
SHOW TABLES;