-- #######################################################
-- # EJEMPLOS DE UPDATE Y MERGE (UPSERT)                 #
-- # Incluye:                                           #
-- # - Creación de tablas                               #
-- # - UPDATE básico y con JOIN                         #
-- # - INSERT...ON DUPLICATE KEY UPDATE (UPSERT)        #
-- # - Casos de uso reales                              #
-- #######################################################

CREATE DATABASE IF NOT EXISTS operaciones_datos;
USE operaciones_datos;

-- Tabla principal de productos
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) DEFAULT 0,
    stock INT DEFAULT 0,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de actualizaciones de precios
CREATE TABLE actualizaciones_precios (
    sku VARCHAR(20) NOT NULL,
    nuevo_precio DECIMAL(10,2) NOT NULL,
    fecha_cambio DATE
);

-- Insertar datos iniciales
INSERT INTO productos (sku, nombre, precio, stock) VALUES
('SKU001', 'Laptop HP', 899.99, 15),
('SKU002', 'Teclado Mecánico', 89.99, 30),
('SKU003', 'Monitor 24"', 249.99, 10);

INSERT INTO actualizaciones_precios (sku, nuevo_precio, fecha_cambio) VALUES
('SKU001', 849.99, '2024-01-15'),
('SKU002', 79.99, '2024-01-15'),
('SKU004', 199.99, '2024-01-15'); -- SKU nuevo

-- ##########################################
-- # UPDATE BÁSICO                          #
-- ##########################################

-- Actualizar precio de un producto específico
UPDATE productos 
SET precio = 829.99, fecha_actualizacion = NOW()
WHERE sku = 'SKU001';

-- Actualizar stock después de venta
UPDATE productos 
SET stock = stock - 5
WHERE sku = 'SKU002' AND stock >= 5;

-- ##########################################
-- # UPDATE CON JOIN                        #
-- ##########################################

-- Actualizar precios basado en tabla de actualizaciones
UPDATE productos p
JOIN actualizaciones_precios ap ON p.sku = ap.sku
SET p.precio = ap.nuevo_precio,
    p.fecha_actualizacion = NOW();

-- ##########################################
-- # UPSERT (INSERT OR UPDATE)              #
-- # MySQL usa ON DUPLICATE KEY UPDATE      #
-- ##########################################

-- Insertar o actualizar producto
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

-- ##########################################
-- # CASO REAL: Sincronización de precios   #
-- ##########################################

-- Tabla temporal para precios externos
CREATE TEMPORARY TABLE temp_precios_externos (
    sku VARCHAR(20) PRIMARY KEY,
    precio_externo DECIMAL(10,2) NOT NULL
);

INSERT INTO temp_precios_externos VALUES
('SKU001', 859.99),
('SKU002', 85.99),
('SKU006', 299.99); -- Nuevo SKU

-- Sincronizar precios
INSERT INTO productos (sku, nombre, precio, stock)
SELECT tpe.sku, 'Producto Externo', tpe.precio_externo, 0
FROM temp_precios_externos tpe
ON DUPLICATE KEY UPDATE 
    precio = tpe.precio_externo,
    fecha_actualizacion = NOW();

-- Ver resultados
SELECT * FROM productos ORDER BY sku;

-- ##########################################
-- # TRANSACCIONES CON UPDATE               #
-- ##########################################

START TRANSACTION;

UPDATE productos SET stock = stock - 3 WHERE sku = 'SKU001';
UPDATE productos SET stock = stock + 3 WHERE sku = 'SKU002';

-- Verificar stocks antes de commit
SELECT sku, stock FROM productos WHERE sku IN ('SKU001', 'SKU002');

-- COMMIT;
-- ROLLBACK; -- En caso de error