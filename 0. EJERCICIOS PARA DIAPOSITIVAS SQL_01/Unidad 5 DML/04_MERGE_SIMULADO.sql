
-- =============================================
-- 04_MERGE_SIMULADO.sql
-- =============================================
-- Ejemplo de MERGE simulado en MySQL usando INSERT ... ON DUPLICATE KEY UPDATE.
-- Contenido:
--   - Creación de base de datos y tablas necesarias.
--   - Ejemplo de uso correcto de MERGE simulado.
--   - Ejemplo de error y explicación.

-- =============================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS
-- =============================================

CREATE DATABASE IF NOT EXISTS ejemplo_merge;
USE ejemplo_merge;

CREATE TABLE IF NOT EXISTS inventario (
    id INT PRIMARY KEY,
    producto VARCHAR(50),
    cantidad INT
);

-- =============================================
-- EJEMPLO DE USO CORRECTO
-- =============================================

-- Insertar un producto
INSERT INTO inventario (id, producto, cantidad) VALUES (1, 'Tornillos', 100);

-- MERGE simulado: si el id ya existe, actualiza la cantidad
INSERT INTO inventario (id, producto, cantidad)
VALUES (1, 'Tornillos', 150)
ON DUPLICATE KEY UPDATE cantidad = VALUES(cantidad);

-- =============================================
-- EJEMPLOS DE SENTENCIAS ERRÓNEAS Y EXPLICACIÓN
-- =============================================

-- Error 1: No hay clave primaria o índice único
-- INSERT INTO inventario (producto, cantidad) VALUES ('Clavos', 200)
-- ON DUPLICATE KEY UPDATE cantidad = VALUES(cantidad); -- Error: no hay clave única

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
