-- =============================================
-- 02_SELECT_WHERE.sql
-- =============================================
-- Ejemplos de uso de SELECT con cláusula WHERE en consultas unitabla
-- Incluye: filtros simples, operadores lógicos, IN, BETWEEN, LIKE y NULL.

-- CREACIÓN DE TABLA DE EJEMPLO
CREATE DATABASE IF NOT EXISTS ejemplo_select;
USE ejemplo_select;

CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    departamento VARCHAR(50),
    salario DECIMAL(10,2),
    fecha_alta DATE
);

INSERT INTO empleados (nombre, departamento, salario, fecha_alta) VALUES
('Ana', 'Ventas', 1800, '2022-01-10'),
('Luis', 'Marketing', 2000, '2021-11-05'),
('Marta', 'Ventas', 2200, '2020-09-15'),
('Pedro', 'IT', 2500, '2023-03-01'),
('Lucía', 'IT', 2100, NULL);

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================
-- 1) Muestra los empleados del departamento 'Ventas'.
-- 2) Muestra los empleados cuyo salario sea mayor o igual a 2000.
-- 3) Muestra los empleados que NO sean del departamento 'IT'.
-- 4) Muestra los empleados dados de alta después del 1 de enero de 2022.
-- 5) Muestra los empleados cuyo salario esté entre 2000 y 2500.
-- 6) Muestra los empleados cuyo nombre empiece por 'L'.
-- 7) Muestra los empleados cuyo departamento sea 'Ventas' o 'Marketing'.
-- 8) Muestra los empleados que no tienen fecha de alta registrada.
-- 9) Muestra los empleados cuyo salario NO esté entre 1800 y 2200.
-- 10) Muestra los empleados cuyo nombre contenga la letra 'a'.

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================
-- 1) Muestra los empleados del departamento 'Ventas'.
SELECT * FROM empleados WHERE departamento = 'Ventas';

-- 2) Muestra los empleados cuyo salario sea mayor o igual a 2000.
SELECT * FROM empleados WHERE salario >= 2000;

-- 3) Muestra los empleados que NO sean del departamento 'IT'.
SELECT * FROM empleados WHERE departamento <> 'IT';

-- 4) Muestra los empleados dados de alta después del 1 de enero de 2022.
SELECT * FROM empleados WHERE fecha_alta > '2022-01-01';

-- 5) Muestra los empleados cuyo salario esté entre 2000 y 2500.
SELECT * FROM empleados WHERE salario BETWEEN 2000 AND 2500;
-- otra forma:
-- SELECT * FROM empleados WHERE salario >= 2000 AND salario <= 2500;

-- 6) Muestra los empleados cuyo nombre empiece por 'L'.
-- SELECT * FROM empleados WHERE nombre LIKE L%; -- Error: falta comilla
SELECT * FROM empleados WHERE nombre LIKE 'L%';

-- 7) Muestra los empleados cuyo departamento sea 'Ventas' o 'Marketing'.
SELECT * FROM empleados WHERE departamento IN ('Ventas', 'Marketing');
-- o también:
-- SELECT nombre FROM empleados WHERE (departamento ='Ventas' OR departamento = 'Marketing');


-- 8) Muestra los empleados que no tienen fecha de alta registrada.
-- SELECT * FROM empleados WHERE fecha_alta = NULL; -- Error: debe usarse IS NULL
SELECT * FROM empleados WHERE fecha_alta IS NULL;


-- 9) Muestra los empleados cuyo salario NO esté entre 1800 y 2200.
SELECT * FROM empleados WHERE salario NOT BETWEEN 1800 AND 2200;
-- otra forma: 
-- SELECT * FROM empleados WHERE salario < 1800 OR salario > 2200;

-- 10) Muestra los empleados cuyo nombre contenga la letra 'a'.
SELECT * FROM empleados WHERE nombre LIKE '%a%';

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
