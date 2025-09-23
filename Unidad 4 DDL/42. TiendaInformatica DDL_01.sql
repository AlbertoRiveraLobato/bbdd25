-- Ejercicio 42: Gestión de una tienda de informática

-- Crear base de datos y usarla
CREATE DATABASE IF NOT EXISTS TiendaInformatica;
USE TiendaInformatica;

CREATE TABLE productos (
    idProducto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(8,2)
);

INSERT INTO productos (nombre, precio) VALUES
('Ratón', 15.99),
('Teclado', 25.50),
('Monitor', 120.00);

CREATE INDEX idx_nombre_producto ON productos(nombre);

ALTER TABLE productos ADD stock INT DEFAULT 10;
ALTER TABLE productos MODIFY precio DECIMAL(10,2);
ALTER TABLE productos CHANGE stock unidades INT DEFAULT 10;

DESCRIBE productos;
SELECT * FROM productos;

TRUNCATE TABLE productos;

INSERT INTO productos (nombre, precio, unidades) VALUES
('Altavoz', 35.00, 5);

SELECT * FROM productos;

DROP INDEX idx_nombre_producto ON productos;
DROP TABLE productos;

SHOW TABLES;