-- =============================================
-- 52. TiendaOnline DML_01.sql
-- =============================================
-- Ejemplo de aplicación sencilla: Gestión de una tienda online
-- Incluye ejemplos de DDL y DML básicos (CREATE, INSERT, UPDATE, DELETE)
-- para que los alumnos vean cómo se implementan estos comandos en un caso casi real.

-- Crear base de datos y tablas
CREATE DATABASE IF NOT EXISTS tienda_online;
USE tienda_online;

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    stock INT
);

CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    fecha DATE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);


CREATE TABLE IF NOT EXISTS detalle_pedido (
    pedido_id INT,
    producto_id INT,
    cantidad INT,
    PRIMARY KEY (pedido_id, producto_id),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================
-- 1) Inserta los siguientes productos en la tabla productos:
--    ('Ratón', 12.50, 100), ('Teclado', 25.00, 50), ('Monitor', 150.00, 20)
-- 2) Inserta los siguientes clientes en la tabla clientes:
--    ('Juan Pérez', 'juan@correo.com'), ('Ana López', 'ana@correo.com')
-- 3) Crea un pedido para el cliente con id 1 en la fecha '2025-09-14'.
-- 4) Añade al pedido anterior 2 ratones y 1 teclado.
-- 5) Actualiza el stock de los productos vendidos.
-- 6) Elimina el producto con id 3 (Monitor).

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================
-- 1) Inserción de productos
INSERT INTO productos (nombre, precio, stock) VALUES
('Ratón', 12.50, 100),
('Teclado', 25.00, 50),
('Monitor', 150.00, 20);

-- 2) Inserción de clientes
INSERT INTO clientes (nombre, email) VALUES
('Juan Pérez', 'juan@correo.com'),
('Ana López', 'ana@correo.com');

-- 3) Crear un pedido
INSERT INTO pedidos (cliente_id, fecha) VALUES (1, '2025-09-14');

-- 4) Añadir productos al pedido
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad) VALUES (1, 1, 2), (1, 2, 1);

-- 5) Actualizar stock tras la venta
UPDATE productos SET stock = stock - 2 WHERE id = 1; -- Ratón
UPDATE productos SET stock = stock - 1 WHERE id = 2; -- Teclado

-- 6) Eliminar un producto
DELETE FROM productos WHERE id = 3; -- Monitor

-- Comentarios:
-- Este ejemplo muestra cómo se usan los comandos DDL y DML en una aplicación sencilla.
-- Los alumnos pueden ver la relación entre tablas y cómo afectan los comandos a los datos.
-- No se usan comandos avanzados, sólo lo visto en clase.
-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
