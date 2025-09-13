CREATE DATABASE IF NOT EXISTS ejemplo_ddl;
USE ejemplo_ddl;

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'productos.csv' INTO TABLE productos
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '
';


-- =============================================
-- 01_LOAD_DATA.sql
-- =============================================
-- Ejemplos de uso de LOAD DATA INFILE y variantes para carga masiva de datos en MySQL.
-- Incluye: creación de base de datos y tablas, ejemplos de carga, y errores comunes.

-- CREACIÓN DE BASE DE DATOS Y TABLAS
CREATE DATABASE IF NOT EXISTS ejemplo_load_data;
USE ejemplo_load_data;

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2)
);

CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    departamento VARCHAR(50),
    salario DECIMAL(10,2),
    fecha_contratacion DATE
);

-- =============================================
-- EJEMPLOS DE USO
-- =============================================

-- Ejemplo 1: Cargar productos desde CSV
-- Archivo: productos.csv
-- id,nombre,precio
-- 1,"Ratón",12.50
-- 2,"Teclado",25.00
LOAD DATA LOCAL INFILE 'productos.csv' INTO TABLE productos
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, nombre, precio);

-- Ejemplo 2: Cargar empleados desde CSV
-- Archivo: empleados.csv
-- nombre,apellido,email,departamento,salario,fecha_contratacion
-- "Juan","Pérez","juan@empresa.com","IT",45000.00,"2023-01-15"
LOAD DATA INFILE 'empleados.csv' INTO TABLE empleados
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nombre, apellido, email, departamento, salario, fecha_contratacion);

-- =============================================
-- ERRORES COMUNES
-- =============================================

-- Error 1: Archivo no existe
-- LOAD DATA LOCAL INFILE 'no_existe.csv' INTO TABLE productos; -- Error: archivo no encontrado

-- Error 2: No usar IGNORE 1 ROWS y cargar cabecera como datos
-- LOAD DATA INFILE 'empleados.csv' INTO TABLE empleados
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'; -- Error: la cabecera se inserta como fila

-- Error 3: Tipos incompatibles o columnas desordenadas
-- LOAD DATA INFILE 'empleados.csv' INTO TABLE empleados
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
-- (apellido, nombre, email, departamento, salario, fecha_contratacion); -- Error: columnas desordenadas
