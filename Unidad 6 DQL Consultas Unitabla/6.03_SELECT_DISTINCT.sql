-- =============================================
-- 04_SELECT_DISTINCT.sql
-- =============================================
-- Ejemplos de uso de SELECT DISTINCT en consultas unitabla
-- Incluye: selección de valores únicos, combinación con WHERE y funciones de agregación.

-- CREACIÓN DE TABLA DE EJEMPLO
CREATE DATABASE IF NOT EXISTS ejemplo_select;
USE ejemplo_select;

CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    ciudad VARCHAR(50)
);

INSERT INTO clientes (nombre, ciudad) VALUES
('Ana', 'Madrid'),
('Luis', 'Sevilla'),
('Marta', 'Madrid'),
('Pedro', 'Valencia'),
('Lucía', 'Sevilla');

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================
-- 1) Muestra todas las ciudades (puede haber repetidas).
-- 2) Muestra sólo las ciudades distintas donde hay clientes.
-- 3) Muestra los nombres de clientes únicos.
-- 4) Muestra las ciudades distintas donde hay más de un cliente.
-- 5) Muestra el número de ciudades distintas.
-- 6) Muestra los clientes de la ciudad de 'Madrid'.
-- 7) Muestra las ciudades distintas que empiezan por 'M'.
-- 8) Muestra los clientes cuyo nombre es único (no repetido).
-- 9) Muestra las ciudades distintas ordenadas alfabéticamente.
-- 10) Muestra las ciudades distintas donde no hay clientes llamados 'Ana'.

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================
-- 1) Muestra todas las ciudades (puede haber repetidas).
SELECT ciudad FROM clientes;

-- 2) Muestra sólo las ciudades distintas donde hay clientes.
SELECT DISTINCT ciudad FROM clientes;

-- 3) Muestra los nombres de clientes únicos.
SELECT DISTINCT nombre FROM clientes;

-- 4) Muestra las ciudades distintas donde hay más de un cliente.
SELECT ciudad FROM clientes GROUP BY ciudad HAVING COUNT(*) > 1;

-- 5) Muestra el número de ciudades distintas.
SELECT COUNT(DISTINCT ciudad) AS num_ciudades FROM clientes;

-- 6) Muestra los clientes de la ciudad de 'Madrid'.
SELECT nombre FROM clientes WHERE ciudad = 'Madrid';

-- 7) Muestra las ciudades distintas que empiezan por 'M'.
SELECT DISTINCT ciudad FROM clientes WHERE ciudad LIKE 'M%';

-- 8) Muestra los clientes cuyo nombre es único (no repetido).
SELECT ciudad FROM clientes GROUP BY ciudad HAVING COUNT(*) = 1;

-- 9) Muestra las ciudades distintas ordenadas alfabéticamente.
SELECT DISTINCT ciudad FROM clientes ORDER BY ciudad ASC;

-- 10) Muestra las ciudades distintas donde no hay clientes llamados 'Ana'.
SELECT DISTINCT ciudad FROM clientes WHERE ciudad NOT IN (
    SELECT ciudad FROM clientes WHERE nombre = 'Ana'
);

-- =============================================
-- ERRORES COMUNES
-- =============================================
-- Error: uso incorrecto de DISTINCT
-- SELECT DISTINCT ciudad, nombre FROM clientes; -- Devuelve combinaciones únicas de ambos campos

-- Error: uso incorrecto de COUNT
-- SELECT COUNT(ciudad) FROM clientes; -- Cuenta todas las filas, no sólo distintas

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
