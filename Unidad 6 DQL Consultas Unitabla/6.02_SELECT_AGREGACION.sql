-- =============================================
-- 03_SELECT_AGREGACION.sql
-- =============================================
-- Ejemplos de uso de funciones de agregación en SELECT sobre una sola tabla
-- Incluye: COUNT, SUM, AVG, MIN, MAX, GROUP BY y HAVING.

-- CREACIÓN DE TABLA DE EJEMPLO
CREATE DATABASE IF NOT EXISTS ejemplo_select;
USE ejemplo_select;

CREATE TABLE IF NOT EXISTS ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto VARCHAR(100),
    cantidad INT,
    total DECIMAL(10,2),
    fecha DATE
);

INSERT INTO ventas (producto, cantidad, total, fecha) VALUES
('Ratón', 2, 25.00, '2025-09-01'),
('Teclado', 1, 25.00, '2025-09-01'),
('Monitor', 1, 150.00, '2025-09-02'),
('Ratón', 1, 12.50, '2025-09-03'),
('Impresora', 1, 80.00, '2025-09-03'),
('Módem', 3, 90.00, '2025-09-04');


-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================
-- 1) Muestra el número total de ventas realizadas.
-- 2) Muestra la suma total de ingresos.
-- 3) Muestra la cantidad media vendida por producto.
-- 4) Muestra el producto más vendido (por cantidad).
-- 5) Muestra el total de ventas por producto.
-- 6) Muestra el total de ventas por día.
-- 7) Muestra los productos que han generado más de 50 euros en total.
-- 8) Muestra el día con mayor número de ventas.
-- 9) Producto con menor cantidad vendida
-- 10) Total de ventas del producto 'Ratón'
-- 11) Muestra el total de ventas de productos cuyo nombre contiene la letra 'o'.
-- 12) Muestra la suma de ventas de productos cuyo nombre empieza por 'M'.

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================
-- 1) Muestra el número total de ventas realizadas.
SELECT COUNT(*) AS total_ventas FROM ventas;

-- 2) Muestra la suma total de ingresos.
SELECT SUM(total) AS ingresos_totales FROM ventas;

-- 3) Muestra la cantidad media vendida por producto.
SELECT producto, AVG(cantidad) AS media_cantidad FROM ventas GROUP BY producto;

-- 4) Muestra el producto más vendido (por cantidad).
SELECT producto, SUM(cantidad) AS total_vendida FROM ventas GROUP BY producto ORDER BY total_vendida DESC LIMIT 1;

-- 5) Muestra el total de ventas por producto.
SELECT producto, SUM(total) AS total_ventas FROM ventas GROUP BY producto;

-- 6) Muestra el total de ventas por día.
SELECT fecha, SUM(total) AS total_dia FROM ventas GROUP BY fecha;

-- 7) Muestra los productos que han generado más de 50 euros en total.
SELECT producto, SUM(total) AS total_ventas FROM ventas GROUP BY producto HAVING total_ventas > 50;

-- 8) Muestra el día con mayor número de ventas.
SELECT fecha, COUNT(*) AS num_ventas FROM ventas GROUP BY fecha ORDER BY num_ventas DESC LIMIT 1;

-- 9) Producto con menor cantidad vendida
SELECT producto, SUM(cantidad) AS total_vendida FROM ventas GROUP BY producto ORDER BY total_vendida ASC LIMIT 1;

-- 10) Total de ventas del producto 'Ratón'
SELECT SUM(total) AS total_raton FROM ventas WHERE producto = 'Ratón';

-- 11) Muestra el total de ventas de productos cuyo nombre contiene la letra 'o'.
SELECT SUM(total) AS total_con_o FROM ventas WHERE producto LIKE '%o%';
-- o por separado cada producto:
SELECT SUM(total), producto FROM ventas WHERE producto LIKE '%o%' GROUP BY producto;

-- 12) Muestra la suma de ventas de productos cuyo nombre empieza por 'M'.
SELECT SUM(total) AS total_m FROM ventas WHERE producto LIKE 'M%';
-- o por separado cada producto:
SELECT SUM(total), producto FROM ventas WHERE producto LIKE 'M%' GROUP BY producto;

-- =============================================
-- ERRORES COMUNES
-- =============================================
-- Error: uso incorrecto de GROUP BY
-- SELECT producto, SUM(total) FROM ventas; -- Error: falta GROUP BY

-- Error: uso incorrecto de HAVING
-- SELECT * FROM ventas HAVING total > 50; -- Error: HAVING sólo tras GROUP BY

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
