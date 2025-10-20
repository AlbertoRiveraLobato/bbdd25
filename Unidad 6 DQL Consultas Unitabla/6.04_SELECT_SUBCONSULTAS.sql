-- =============================================
-- 05_SELECT_SUBCONSULTAS.sql
-- =============================================
-- Ejemplos de uso de subconsultas en SELECT sobre una sola tabla
-- Incluye: subconsultas en WHERE, en SELECT y en FROM (sin JOIN).

-- CREACIÓN DE TABLA DE EJEMPLO
CREATE DATABASE IF NOT EXISTS ejemplo_select;
USE ejemplo_select;

CREATE TABLE IF NOT EXISTS articulos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    categoria VARCHAR(50)
);

INSERT INTO articulos (nombre, precio, categoria) VALUES
('Ratón', 12.50, 'Informática'),
('Teclado', 25.00, 'Informática'),
('Monitor', 150.00, 'Informática'),
('Libro', 20.00, 'Libros'),
('Agenda', 8.00, 'Papelería');

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================
-- 1) Muestra los artículos cuyo precio es mayor que la media de todos los artículos.
-- 2) Muestra el artículo más barato usando una subconsulta.
-- 3) Muestra los artículos de la categoría 'Informática' cuyo precio es mayor que el precio medio de esa categoría.
-- 4) Muestra el número de artículos por categoría usando una subconsulta en FROM.
-- 5) Muestra los artículos cuyo precio es igual al precio máximo de su categoría.
-- 6) Muestra los artículos cuyo precio es menor que el precio medio de todos los artículos.
-- 7) Muestra el nombre y la diferencia entre el precio de cada artículo y el precio medio de su categoría.
-- 8) Muestra los artículos cuyo precio es igual al precio mínimo de su categoría.
-- 9) Muestra los artículos cuyo precio es mayor que el precio de 'Agenda'.
-- 10) Muestra los artículos cuyo precio es igual al precio máximo de todos los artículos.

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================
-- 1) Muestra los artículos cuyo precio es mayor que la media de todos los artículos.
SELECT * FROM articulos WHERE precio > (SELECT AVG(precio) FROM articulos);

-- 2) Muestra el artículo más barato usando una subconsulta.
SELECT * FROM articulos WHERE precio = (SELECT MIN(precio) FROM articulos);

-- 3) Muestra los artículos de la categoría 'Informática' cuyo precio es mayor que el precio medio de esa categoría.
SELECT * FROM articulos a WHERE categoria = 'Informática' AND precio > (
    SELECT AVG(precio) FROM articulos WHERE categoria = 'Informática'
);

-- 4) Muestra el número de artículos por categoría usando una subconsulta en FROM.
SELECT categoria, total FROM (
    SELECT categoria, COUNT(*) AS total FROM articulos GROUP BY categoria
) AS sub;

-- 5) Muestra los artículos cuyo precio es igual al precio máximo de su categoría.
SELECT * FROM articulos a WHERE precio = (
    SELECT MAX(precio) FROM articulos WHERE categoria = a.categoria
);

-- 6) Muestra los artículos cuyo precio es menor que el precio medio de todos los artículos.
SELECT * FROM articulos WHERE precio < (SELECT AVG(precio) FROM articulos);

-- 7) Muestra el nombre y la diferencia entre el precio de cada artículo y el precio medio de su categoría.
SELECT nombre, precio - (
    SELECT AVG(precio) FROM articulos WHERE categoria = a.categoria
) AS diferencia FROM articulos a;

-- 8) Muestra los artículos cuyo precio es igual al precio mínimo de su categoría.
SELECT * FROM articulos a WHERE precio = (
    SELECT MIN(precio) FROM articulos WHERE categoria = a.categoria
);

-- 9) Muestra los artículos cuyo precio es mayor que el precio de 'Agenda'.
SELECT * FROM articulos WHERE precio > (
    SELECT precio FROM articulos WHERE nombre = 'Agenda'
);

-- 10) Muestra los artículos cuyo precio es igual al precio máximo de todos los artículos.
SELECT * FROM articulos WHERE precio = (SELECT MAX(precio) FROM articulos);

-- =============================================
-- ERRORES COMUNES
-- =============================================
-- Error: subconsulta devuelve más de un valor
-- SELECT * FROM articulos WHERE precio = (SELECT precio FROM articulos); -- Error si hay más de un resultado

-- Error: subconsulta sin paréntesis
-- SELECT * FROM articulos WHERE precio = SELECT MAX(precio) FROM articulos; -- Error de sintaxis

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
