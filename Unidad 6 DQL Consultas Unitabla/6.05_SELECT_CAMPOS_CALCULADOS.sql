-- =============================================
-- 05_SELECT_CAMPOS_CALCULADOS.sql
-- =============================================
-- Ejemplos de campos calculados y uso de funciones como SUBSTRING en la cláusula SELECT (consultas unitabla)
-- Incluye: operaciones aritméticas, concatenación, uso de funciones de texto y alias.

-- CREACIÓN DE TABLA DE EJEMPLO
CREATE DATABASE IF NOT EXISTS ejemplo_select;
USE ejemplo_select;

CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    salario DECIMAL(10,2),
    departamento VARCHAR(50)
);

INSERT INTO empleados (nombre, salario, departamento) VALUES
('Ana García', 1800, 'Ventas'),
('Luis Pérez', 2000, 'Marketing'),
('Marta Ruiz', 2200, 'Ventas'),
('Pedro López', 2500, 'IT'),
('Lucía Gómez', 2100, 'IT');

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================
-- 1) Muestra el salario anual de cada empleado (salario * 12).
-- 2) Muestra el nombre completo en mayúsculas y el salario con un 10% de incremento.
-- 3) Muestra el nombre y los dos primeros caracteres del departamento.
-- 4) Muestra el nombre y los tres últimos caracteres del nombre.
-- 5) Muestra el nombre y la longitud del nombre.
-- 6) Muestra el nombre y el salario neto tras aplicar una retención del 15%.
-- 7) Muestra el nombre y el departamento en una sola columna separados por un guion.
-- 8) Muestra el nombre y la inicial del apellido (usando SUBSTRING).
-- 9) Muestra el nombre y el salario convertido a texto con el símbolo € al final.
-- 10) Muestra el nombre y el departamento en minúsculas.

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================
-- 1) Muestra el salario anual de cada empleado (salario * 12).
SELECT nombre, salario * 12 AS salario_anual FROM empleados;

-- 2) Muestra el nombre completo en mayúsculas y el salario con un 10% de incremento.
SELECT UPPER(nombre) AS nombre_mayus, salario * 1.10 AS salario_incrementado FROM empleados;

-- 3) Muestra el nombre y los dos primeros caracteres del departamento.
SELECT nombre, LEFT(departamento, 2) AS depto_abrev FROM empleados;

-- 4) Muestra el nombre y los tres últimos caracteres del nombre.
SELECT nombre, RIGHT(nombre, 3) AS ultimos_tres FROM empleados;

-- 5) Muestra el nombre y la longitud del nombre.
SELECT nombre, LENGTH(nombre) AS longitud FROM empleados;

-- 6) Muestra el nombre y el salario neto tras aplicar una retención del 15%.
SELECT nombre, salario * 0.85 AS salario_neto FROM empleados;

-- 7) Muestra el nombre y el departamento en una sola columna separados por un guion.
SELECT CONCAT(nombre, ' - ', departamento) AS info FROM empleados;

-- 8) Muestra el nombre y la inicial del apellido (usando SUBSTRING).
SELECT nombre, SUBSTRING(nombre, LOCATE(' ', nombre) + 1, 1) AS inicial_apellido FROM empleados;

-- 9) Muestra el nombre y el salario convertido a texto con el símbolo € al final.
SELECT nombre, CONCAT(CAST(salario AS CHAR), ' €') AS salario_euro FROM empleados;

-- 10) Muestra el nombre y el departamento en minúsculas.
SELECT nombre, LOWER(departamento) AS depto_minus FROM empleados;

-- =============================================
-- ERRORES COMUNES
-- =============================================
-- Error: uso incorrecto de SUBSTRING
-- SELECT SUBSTRING(nombre, 1, 1) FROM empleados; -- Correcto
-- SELECT SUBSTRING(nombre FROM 1 FOR 1) FROM empleados; -- Sintaxis alternativa (MySQL)

-- Error: división por cero
-- SELECT salario / 0 FROM empleados; -- Error

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
