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
CREATE TABLE IF NOT EXISTS inventarios (
    id INT PRIMARY KEY,
    producto VARCHAR(50),
    cantidad INT
);

-- Insertar datos de ejemplo
INSERT INTO empleados (nombre, salario) VALUES 
('Ana', 2000), 
('Luis', 2500),
('Carlos', 2700),
('María', 2200);

INSERT INTO productos (sku, nombre, precio, stock) VALUES
('SKU001', 'Laptop', 899.99, 10),
('SKU002', 'Teclado', 99.99, 25),
('SKU003', 'Ratón', 29.99, 50);

INSERT INTO inventarios (id, producto, cantidad) VALUES 
(1, 'Tornillos', 100),
(2, 'Tuercas', 200),
(3, 'Arandelas', 150);

-- =============================================
-- EJEMPLOS DE USO CORRECTO
-- =============================================

-- UPDATE básico - actualizar salario de un empleado específico.
-- Cambia el salario de 'Ana' a 3000.
UPDATE empleados SET salario = 3000 WHERE nombre = 'Ana';

-- Cambia el salario de cualquier empleado cuyo nombre contenga alguna 'a' a 3000.
UPDATE empleados SET salario = 3000 WHERE nombre LIKE '%a%';

-- Cambia el salario de cualquier empleado cuyo nombre termine en 'ana' a 3000.
UPDATE empleados SET salario = 3000 WHERE nombre LIKE '%ana';

-- Cambia el salario de cualquier empleado cuyo nombre empiece por 'a' y tenga dos caracteres más a 3000.
UPDATE empleados SET salario = 3000 WHERE nombre LIKE 'a__';


-- UPDATE múltiple con diferentes condiciones.
-- Aumenta un 10% el salario de todos los empleados que ganan menos de 2500.
UPDATE empleados SET salario = salario * 1.10 WHERE salario < 2500;

-- MERGE/UPSERT: INSERT ... ON DUPLICATE KEY UPDATE en productos.
-- Inserta un producto con id=1, o si ya existe, actualiza su precio y stock.
-- id, sku, nombre, precio, stock: 1, 'SKU001', 'Laptop', 899.99, 10
INSERT INTO productos (id, sku, nombre, precio, stock) VALUES (1, 'SKU001', 'Laptop', 899.99, 10)
ON DUPLICATE KEY UPDATE precio = VALUES(precio*100), stock = VALUES(stock);

-- Inserta un producto (sin id, sin PK, pero con otro campo que actúa como índice, como clave
-- con SKU001, o si ya existe, actualiza su precio y stock.
-- sku, nombre, precio, stock: 'SKU001', 'Laptop', 899.99, 10
INSERT INTO productos (sku, nombre, precio, stock) VALUES ('SKU001', 'Laptop', 899.99, 10)
ON DUPLICATE KEY UPDATE precio = VALUES(precio*100), stock = VALUES(stock);

-- Inserta y acutaliza, ahora tomando también el id de producto (para demostrar que funciona con cualquier clave única).
INSERT INTO productos (id, sku, nombre, precio, stock) VALUES (1, 'SKU002', 'Teclado', 99.99, 25)
ON DUPLICATE KEY UPDATE precio = VALUES(precio), stock = VALUES(stock);

-- Otra forma de hacer UPSERT sin indicar la clave primaria ni ningún otro campo único, 
-- para demostrar que funciona, siempre y cuando no estemos introduciendo filas duplicadas.
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(20) UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) DEFAULT 0,
    stock INT DEFAULT 0,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO productos (nombre, precio, stock) VALUES
	('Laptop', 900, 20)
    ON DUPLICATE KEY UPDATE precio = VALUES(precio), stock=VALUES(stock);

INSERT INTO productos (id, nombre, precio, stock) VALUES (5, 'Laptop', 900, 20);


-- MERGE simulado en inventario - actualizar o insertar según existe.
-- Actualiza la cantidad de tornillos (id=1) a 150, o inserta si no existe.
-- Hazlo sin indicar el id (clave primaria), para demostrar que sólo funciona 
-- cuando le pasamos cualquier clave única.
-- producto, cantidad: 'Tornillos', 150
INSERT INTO inventarios (producto, cantidad) 
    VALUES ('Tornillos', 150)
    ON DUPLICATE KEY UPDATE cantidad = VALUES(cantidad); -- Va a dar ERROR.

-- Insertar nuevo producto en inventario o sumar cantidad si ya existe.
-- Si el producto con id=4 existe, suma 75 a la cantidad actual; si no, lo inserta.
-- id, producto, cantidad: 4, 'Clavos', 75
INSERT INTO inventarios (id, producto, cantidad) 
    VALUES (4, 'Clavos', 75)
    ON DUPLICATE KEY UPDATE cantidad = cantidad + VALUES(cantidad);

-- UPSERT avanzado en productos con actualización de timestamp.
-- Actualiza el producto SKU002 con nuevo nombre, precio, stock y fecha actual.
-- sku, nombre, precio, stock: 'SKU002', 'Teclado Mecánico Premium', 99.99, 25
INSERT INTO productos (sku, nombre, precio, stock) 
VALUES ('SKU002', 'Teclado Mecánico Premium', 99.99, 25)
ON DUPLICATE KEY UPDATE 
    nombre = VALUES(nombre),
    precio = VALUES(precio),
    stock = VALUES(stock),
    fecha_actualizacion = NOW();

-- Insertar múltiples productos con UPSERT.
-- Actualiza SKU001 y crea SKU005 si no existe, actualizando todos los campos.
-- Datos: ('SKU001', 'Laptop HP Actualizada', 879.99, 20), ('SKU005', 'Nuevo Producto', 49.99, 100)
INSERT INTO productos (sku, nombre, precio, stock) VALUES
('SKU001', 'Laptop HP Actualizada', 879.99, 20),
('SKU005', 'Nuevo Producto', 49.99, 100)
ON DUPLICATE KEY UPDATE 
    nombre = VALUES(nombre),
    precio = VALUES(precio),
    stock = VALUES(stock),
    fecha_actualizacion = NOW();

-- Actualización masiva de precios con porcentaje.
-- Incrementa en 5% el precio de todos los productos que tienen stock mayor a 20.
UPDATE productos SET precio = precio * 1.05 WHERE stock > 20;

-- REPLACE: alternativa a INSERT...ON DUPLICATE KEY UPDATE.
-- Reemplaza completamente el registro con id=2, cambiando producto y cantidad.
-- id, producto, cantidad: 2, 'Tuercas Nuevas', 300
REPLACE INTO inventarios (id, producto, cantidad) VALUES (2, 'Tuercas Nuevas', 300);

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

-- Error 4: UPDATE sin WHERE puede afectar todos los registros
-- UPDATE empleados SET salario = 5000; -- ¡Cuidado! Actualiza TODOS los empleados

-- Error 5: Referencia a columna inexistente
-- UPDATE empleados SET sueldo = 3000 WHERE nombre = 'Ana'; -- Error: columna 'sueldo' no existe

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
