-- Ejercicio: Consultas resumen Vendedores y Ventas.

-- Creación de la base de datos de vendedores y ventas
CREATE DATABASE ventas_db;
USE ventas_db;

-- Tabla de vendedores
CREATE TABLE vendedores (
    id_vendedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(15),
    fecha_contratacion DATE,
    salario_base DECIMAL(10,2),
    comision DECIMAL(5,2) DEFAULT 0.10
);

-- Tabla de ventas
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_vendedor INT,
    fecha_venta DATE,
    producto VARCHAR(100),
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    region VARCHAR(50)
);

-- Inserción de datos de ejemplo
INSERT INTO vendedores (nombre, apellido, email, telefono, fecha_contratacion, salario_base, comision) VALUES
('María', 'García', 'maria.garcia@empresa.com', '611223344', '2022-01-15', 25000.00, 0.15),
('Juan', 'López', 'juan.lopez@empresa.com', '622334455', '2021-03-10', 28000.00, 0.12),
('Ana', 'Martínez', 'ana.martinez@empresa.com', '633445566', '2023-02-20', 23000.00, 0.18),
('Carlos', 'Rodríguez', 'carlos.rodriguez@empresa.com', '644556677', '2020-11-05', 30000.00, 0.10),
('Laura', 'Sánchez', 'laura.sanchez@empresa.com', '655667788', '2022-08-12', 26000.00, 0.14);

INSERT INTO ventas (id_vendedor, fecha_venta, producto, cantidad, precio_unitario, region) VALUES
(1, '2024-01-15', 'Portátil Gaming', 2, 1200.00, 'Norte'),
(1, '2024-01-20', 'Monitor 24"', 3, 250.00, 'Norte'),
(2, '2024-01-10', 'Teclado Mecánico', 5, 80.00, 'Sur'),
(2, '2024-01-25', 'Ratón Inalámbrico', 10, 45.00, 'Sur'),
(3, '2024-01-05', 'Tablet', 4, 350.00, 'Este'),
(3, '2024-01-18', 'Smartphone', 6, 600.00, 'Este'),
(4, '2024-01-12', 'Impresora', 2, 450.00, 'Oeste'),
(4, '2024-01-22', 'Altavoces', 8, 120.00, 'Oeste'),
(5, '2024-01-08', 'Cámara Web', 15, 60.00, 'Centro'),
(5, '2024-01-28', 'Disco Duro Externo', 7, 180.00, 'Centro'),
(1, '2024-02-01', 'Tablet', 3, 350.00, 'Norte'),
(2, '2024-02-05', 'Monitor 24"', 4, 250.00, 'Sur');

/* BATERÍA 1: CONSULTAS SIN JOINS

1. Mostrar todos los datos de los vendedores
2. Mostrar nombre, apellido y salario base de los vendedores
3. Mostrar vendedores con salario superior a 25,000€
4. Mostrar vendedores con salario mayor a 24,000€ y comisión mayor al 12%
5. Mostrar vendedores con salario entre 23,000€ y 27,000€
6. Mostrar vendedores llamados María, Juan o Ana
7. Mostrar vendedores cuyo nombre empiece con 'M'
8. Mostrar vendedores cuyo segundo carácter sea 'a'
9. Mostrar vendedores que no tienen email registrado
10. Calcular salario anual y comisión estimada de cada vendedor
11. Contar número de ventas por región
12. Contar ventas por región y producto
13. Mostrar regiones con más de 2 ventas
14. Mostrar regiones con ventas totales superiores a 1,500€
15. Mostrar vendedores que tienen ventas superiores a 1,000€
16. Mostrar regiones con más de 1 venta (usando subconsulta en FROM)
17. Mostrar vendedores con el número total de ventas que tienen
18. Mostrar ventas cuyo valor es superior al promedio de su región
19. Reporte de productos vendidos en enero 2024 en Norte o Sur con valor total superior a 500€
20. Mostrar vendedores con salario no inferior a 25,000€ o comisión no inferior al 12%, contratados después de 2022

*/

-- 1. SELECT básico
SELECT * FROM vendedores;

-- 2. SELECT con columnas específicas
SELECT nombre, apellido, salario_base FROM vendedores;

-- 3. WHERE con operadores de comparación
SELECT * FROM vendedores WHERE salario_base > 25000;

-- 4. WHERE con operadores lógicos (AND, OR)
SELECT * FROM vendedores 
WHERE salario_base > 24000 AND comision > 0.12;

-- 5. WHERE con BETWEEN (rango)
SELECT * FROM vendedores 
WHERE salario_base BETWEEN 23000 AND 27000;

-- 6. WHERE con IN (conjunto)
SELECT * FROM vendedores 
WHERE nombre IN ('María', 'Juan', 'Ana');

-- 7. WHERE con LIKE (patrones) - % cualquier cadena
SELECT * FROM vendedores 
WHERE nombre LIKE 'M%';

-- 8. WHERE con LIKE (patrones) - _ un solo carácter
SELECT * FROM vendedores 
WHERE nombre LIKE '_a%';

-- 9. WHERE con IS NULL
SELECT * FROM vendedores 
WHERE email IS NULL;

-- 10. OPERADORES ARITMÉTICOS - Campos calculados
SELECT nombre, apellido, 
       salario_base * 12 AS salario_anual,
       salario_base * comision * 1000 AS comision_estimada
FROM vendedores;

-- 11. GROUP BY con COUNT
SELECT region, COUNT(*) as total_ventas
FROM ventas 
GROUP BY region;

-- 12. GROUP BY con múltiples columnas
SELECT region, producto, COUNT(*) as cantidad_ventas
FROM ventas 
GROUP BY region, producto;

-- 13. HAVING con condición sobre agregación
SELECT region, COUNT(*) as total_ventas
FROM ventas 
GROUP BY region
HAVING COUNT(*) > 2;

-- 14. HAVING con operadores aritméticos
SELECT region, SUM(cantidad * precio_unitario) as total_ventas
FROM ventas 
GROUP BY region
HAVING SUM(cantidad * precio_unitario) > 1500;

-- 15. Sub-consulta en WHERE
SELECT * FROM vendedores 
WHERE id_vendedor IN (
    SELECT id_vendedor 
    FROM ventas 
    WHERE cantidad * precio_unitario > 1000
);

-- 16. Sub-consulta en FROM
SELECT v.region, v.total_ventas
FROM (
    SELECT region, COUNT(*) as total_ventas
    FROM ventas 
    GROUP BY region
) AS v
WHERE v.total_ventas > 1;

-- 17. Sub-consulta en SELECT
SELECT nombre, apellido,
       (SELECT COUNT(*) FROM ventas WHERE ventas.id_vendedor = vendedores.id_vendedor) as total_ventas
FROM vendedores;

-- 18. Sub-consulta correlacionada
SELECT * FROM ventas v1
WHERE cantidad * precio_unitario > (
    SELECT AVG(cantidad * precio_unitario)
    FROM ventas v2
    WHERE v2.region = v1.region
);

-- 19. Consulta compleja con múltiples operadores
SELECT producto,
       SUM(cantidad) as total_unidades,
       SUM(cantidad * precio_unitario) as valor_total,
       AVG(precio_unitario) as precio_promedio
FROM ventas
WHERE fecha_venta BETWEEN '2024-01-01' AND '2024-01-31'
AND region IN ('Norte', 'Sur')
GROUP BY producto
HAVING SUM(cantidad * precio_unitario) > 500
ORDER BY valor_total DESC;

-- 20. Consulta con NOT y operadores lógicos
SELECT * FROM vendedores 
WHERE NOT (salario_base < 25000 OR comision < 0.12)
AND fecha_contratacion > '2022-01-01';