-- #######################################################
-- # EJEMPLO COMPLETO DE LOAD DATA INFILE                #
-- # Incluye:                                           #
-- # - Creación de tabla                                #
-- # - Archivo CSV de ejemplo                           #
-- # - Comando LOAD DATA                                #
-- # - Manejo de errores                                #
-- #######################################################

-- Creación de la tabla
CREATE DATABASE IF NOT EXISTS carga_datos;
USE carga_datos;

CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    departamento VARCHAR(50),
    salario DECIMAL(10,2),
    fecha_contratacion DATE
);

-- ##########################################
-- # ARCHIVO CSV: empleados.csv             #
-- # Contenido (guardar en C:/temp/):       #
-- # nombre,apellido,email,departamento,salario,fecha_contratacion
-- # "Juan","Pérez","juan@empresa.com","IT",45000.00,"2023-01-15"
-- # "María","García","maria@empresa.com","RH",38000.00,"2023-02-20"
-- # "Carlos","López","carlos@empresa.com","Ventas",42000.00,"2023-03-10"
-- ##########################################

-- Carga de datos desde archivo CSV
LOAD DATA INFILE 'C:/temp/empleados.csv'
INTO TABLE empleados
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nombre, apellido, email, departamento, salario, fecha_contratacion);

-- Verificar datos cargados
SELECT * FROM empleados;

-- ##########################################
-- # ALTERNATIVA CON LOCAL (desde cliente)  #
-- ##########################################

-- Necesita habilitar LOCAL en MySQL
-- SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/temp/empleados.csv'
INTO TABLE empleados
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nombre, apellido, email, departamento, salario, fecha_contratacion);

-- ##########################################
-- # MANEJO DE ERRORES                      #
-- ##########################################

-- Opción para continuar despite errores
LOAD DATA INFILE 'C:/temp/empleados.csv'
IGNORE INTO TABLE empleados
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nombre, apellido, email, departamento, salario, fecha_contratacion);

-- Opción para reemplazar registros existentes
LOAD DATA INFILE 'C:/temp/empleados.csv'
REPLACE INTO TABLE empleados
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(nombre, apellido, email, departamento, salario, fecha_contratacion);