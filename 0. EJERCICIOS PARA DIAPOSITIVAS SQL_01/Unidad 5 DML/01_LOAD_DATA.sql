';

-- =============================================
-- 01_LOAD_DATA.sql
-- =============================================
-- Ejemplo de uso de LOAD DATA INFILE para carga masiva de datos en MySQL/MariaDB.
-- Contenido:
--   - Creación de base de datos y tablas necesarias.
--   - Ejemplos de sentencias correctas de carga de datos.
--   - Ejemplos de sentencias erróneas y explicación de los errores más comunes.
--   - Notas sobre el formato de los archivos de entrada.
-- Requiere archivos CSV: productos.csv, empleados.csv

-- =============================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS
-- =============================================

CREATE DATABASE IF NOT EXISTS ejemplo_load_data;
USE ejemplo_load_data;

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    departamento VARCHAR(50),
    salario DECIMAL(10,2),
    fecha_contratacion DATE
);

-- =============================================
-- EJEMPLOS DE USO CORRECTO
-- =============================================

-- Ejemplo: Cargar productos desde CSV (omite cabecera)
-- Archivo productos.csv:
-- id,nombre,precio
-- 1,"Ratón",12.50
-- 2,"Teclado",25.00
LOAD DATA LOCAL INFILE 'productos.csv' INTO TABLE productos
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, nombre, precio);

-- Ejemplo: Cargar empleados desde CSV (omite cabecera)
-- Archivo empleados.csv:
-- nombre,apellido,email,departamento,salario,fecha_contratacion
-- "Juan","Pérez","juan@empresa.com","IT",45000.00,"2023-01-15"
LOAD DATA INFILE 'empleados.csv' INTO TABLE empleados
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nombre, apellido, email, departamento, salario, fecha_contratacion);

-- =============================================
-- EJEMPLOS DE SENTENCIAS ERRÓNEAS Y EXPLICACIÓN
-- =============================================

-- Error 1: Archivo no existe
-- LOAD DATA LOCAL INFILE 'no_existe.csv' INTO TABLE productos;
-- -- Error: El archivo especificado no se encuentra.

-- Error 2: No usar IGNORE 1 ROWS (la cabecera se inserta como datos)
-- LOAD DATA INFILE 'empleados.csv' INTO TABLE empleados
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';
-- -- Error: La primera fila (cabecera) se inserta como un registro erróneo.

-- Error 3: Columnas desordenadas o incompatibles
-- LOAD DATA INFILE 'empleados.csv' INTO TABLE empleados
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
-- (apellido, nombre, email, departamento, salario, fecha_contratacion);
-- -- Error: El orden de las columnas no coincide con el del archivo, los datos se insertan incorrectamente.

-- Error 4: Tipos incompatibles (por ejemplo, texto en campo numérico)
-- Si en productos.csv hay una fila: 3,"Monitor","veinte"
-- -- Error: 'veinte' no puede convertirse a DECIMAL(10,2), la fila falla.

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
