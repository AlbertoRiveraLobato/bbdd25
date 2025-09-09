-- ==========================================
-- COMANDOS DML Y DDL: DELETE, TRUNCATE y DROP
-- ==========================================

-- 1. CREACIÓN DE BASE DE DATOS Y TABLAS DE EJEMPLO

-- Crear base de datos de ejemplo
CREATE DATABASE IF NOT EXISTS empresa;
USE empresa;

-- Crear tabla de empleados
CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    departamento VARCHAR(30)
);

-- Insertar datos de ejemplo en empleados
INSERT INTO empleados (nombre, departamento) VALUES
('Ana', 'Ventas'),
('Luis', 'Marketing'),
('Marta', 'Ventas'),
('Pedro', 'Finanzas'),
('Lucía', 'Marketing');

-- Crear tabla de productos
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50)
);

INSERT INTO productos (nombre) VALUES
('Ratón'),
('Teclado'),
('Monitor');

-- Crear tabla de logs
CREATE TABLE IF NOT EXISTS logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensaje VARCHAR(100)
);

INSERT INTO logs (mensaje) VALUES
('Inicio de sesión'),
('Error de conexión'),
('Actualización de datos');

-- Crear tabla de pruebas
CREATE TABLE IF NOT EXISTS pruebas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dato VARCHAR(50)
);

INSERT INTO pruebas (dato) VALUES
('Prueba1'),
('Prueba2');

-- ==========================================
-- 2. EJEMPLOS DE USO DE DELETE, TRUNCATE Y DROP
-- ==========================================

/*
    - DELETE: Elimina filas de una tabla. Permite usar condiciones (WHERE).
    - TRUNCATE: Elimina todas las filas de una tabla, no permite condiciones.
    - DROP: Elimina la tabla completa (estructura y datos).
*/

-- EJEMPLO 1: DELETE (DML)
-- Elimina filas específicas según una condición
DELETE FROM empleados WHERE departamento = 'Ventas';

-- Elimina todas las filas de la tabla (sin borrar la estructura)
DELETE FROM empleados;

-- EJEMPLO 2: TRUNCATE (DDL)
-- Elimina todas las filas de la tabla de forma rápida y no registra cada fila eliminada
TRUNCATE TABLE empleados;

-- EJEMPLO 3: DROP (DDL)
-- Elimina la tabla completa, incluyendo su estructura y datos
DROP TABLE empleados;

-- ==========================================
-- 3. DIFERENCIAS PRINCIPALES ENTRE DELETE, TRUNCATE Y DROP
-- ==========================================
/*
    1. DELETE:
        - Es DML.
        - Permite condición WHERE.
        - Se pueden recuperar los datos con ROLLBACK si está en una transacción.
        - No libera el espacio de la tabla.
    2. TRUNCATE:
        - Es DDL.
        - No permite condición WHERE.
        - No se pueden recuperar los datos con ROLLBACK.
        - Libera el espacio de la tabla.
    3. DROP:
        - Es DDL.
        - Elimina la tabla y sus datos.
        - No se pueden recuperar los datos ni la estructura.
*/

-- ==========================================
-- 4. EJEMPLOS ADICIONALES
-- ==========================================

-- Eliminar todos los registros de una tabla de productos
DELETE FROM productos;

-- Vaciar rápidamente una tabla de logs
TRUNCATE TABLE logs;

-- Eliminar completamente una tabla de pruebas