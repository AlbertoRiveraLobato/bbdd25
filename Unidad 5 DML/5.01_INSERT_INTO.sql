
-- =============================================
-- 01_INSERT_INTO.sql
-- =============================================
-- Ejemplo de uso de INSERT INTO para insertar datos en MySQL/MariaDB.
-- Contenido:
--   - Creación de base de datos y tablas necesarias.
--   - Ejemplos de sentencias correctas de inserción de datos.
--   - Ejemplos de sentencias erróneas y explicación de los errores más comunes.

-- =============================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS
-- =============================================

-- Crea una tabla de empresas, con los campos idEmpresa (clave primaria auto incremental),
-- nombre (no nulo), ciudad y país.
CREATE TABLE IF NOT EXISTS empresa (
    idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50),
    pais VARCHAR(50)
);

-- Tabla para ejemplos con ENUM, DEFAULT y NULL
-- Crea una tabla de empleados con id_empleado (clave primaria auto incremental),
-- nombre_empleado (no nulo), género (ENUM con valores 'Masculino', 'Femenino', 'No especificado', por defecto 'No especificado'),
-- y edad (entero, puede ser NULL).
CREATE TABLE IF NOT EXISTS empleados (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre_empleado VARCHAR(100) NOT NULL,
    genero ENUM('Masculino', 'Femenino', 'No especificado') NOT NULL DEFAULT 'No especificado',
    edad INT NULL
);

-- =============================================
-- EJEMPLOS DE USO CORRECTO
-- =============================================

-- Insertar una empresa con los siguientes valores, en la primera fila:
-- nombre: 'PRYCA', ciudad: 'San Fernando', pais: 'España'
INSERT INTO empresa (idEmpresa, nombre, ciudad, pais) VALUES (1, 'PRYCA', 'San Fernando', 'España');

-- Insertar sin especificar la clave primaria (AUTO_INCREMENT).
-- Añade ahora otra empresa con nombre 'CARREFOUR1', ciudad 'San Fernando' y país 'España',
-- sin especificar la fila o clave primaria idEmpresa.
-- El valor de idEmpresa se asignará automáticamente.
INSERT INTO empresa (nombre, ciudad, pais) VALUES ('CARREFOUR1', 'San Fernando', 'España');


-- Insertar con clave primaria específica.
-- Añade dos empresas más, pero esta vez especificando la clave primaria idEmpresa:
INSERT INTO empresas (idEmpresa, nombre, ciudad, pais) VALUES
	(100, 'CARREFOUR2', 'San Fernando', 'España'),
    (5, 'CARREFOUR3', 'San Fernando', 'España');


-- Insertar "múltiple": insertar varias filas de golpe. ¿Qué sucederá ahora con los idEmpresa? 
-- ¿Por cuál empezará el siguiente idEmpresa?
-- Añade las siguientes empresas de golpe, sin especificar la clave o idEmpresa:
-- nombre: 'ECI', ciudad: 'Mejorada', pais: 'España',
-- nombre: 'CARRODS', ciudad: 'Oxford', pais: 'Inglaterra',
-- nombre: 'ALCAMPO', ciudad: '', pais: '',
-- nombre: 'LIDL', ciudad: 'Berlín', pais: 'Alemania'.
INSERT INTO empresa (nombre, ciudad, pais) VALUES 
    ('ECI', 'Mejorada', 'España'),
    ('CARRODS', 'Oxford', 'Inglaterra'),
    ('ALCAMPO', '', ''),
    ('LIDL', 'Berlín', 'Alemania');


-- Insertar datos cuando hay columnas con valores por defecto o que permiten NULL,
-- usando la tabla empleados creada arriba.
-- Inserta el siguiente empleado, del que conocemos todos los datos:
-- nombre_empleado: 'Lara Ruiz', genero: 'Femenino', edad: 28.
INSERT INTO empleados (nombre_empleado, genero, edad) VALUES
('Lara Ruiz', 'Femenino', 28);

-- Inserta los siguientes empleados, de los que solo conocemos el nombre:
-- nombre_empleado: 'Jorge López',
-- nombre_empleado: 'Abel Ramos'.
INSERT INTO empleados (nombre_empleado) VALUES
('Jorge López'),
('Abel Ramos');

-- Inserta los siguientes empleados, de los que solo conocemos el nombre (y de uno de ellos, el género):
-- nombre_empleado: 'Ana García', genero: 'Femenino'.
-- nombre_empleado: 'Luis Martínez', género: lo desconocemos.
INSERT INTO empleados (nombre_empleado, genero) VALUES
('Ana García', 'Femenino'),
('Luis Martínez', DEFAULT);


-- Clonar todos los datos de una tabla a otra.
-- Crea una tabla de respaldo IDÉNTICA a empresa y copia TODOS LOS DATOS.
-- Si la tabla ya existe, no la recrea (IF NOT EXISTS).
CREATE TABLE IF NOT EXISTS empresa_respaldo LIKE empresa;
INSERT INTO empresa_respaldo SELECT * FROM empresa;

-- Clonar solo algunas columnas o filas
-- INSERT INTO empresa_respaldo (nombre, ciudad, pais)
-- SELECT nombre, ciudad, pais FROM empresa WHERE ciudad = 'San Fernando';

-- =============================================
-- EJEMPLOS DE SENTENCIAS ERRÓNEAS Y EXPLICACIÓN
-- =============================================

-- Error 1: Número de columnas y valores no coincide
-- INSERT INTO empresa (nombre, ciudad) VALUES ('PRYCA', 'San Fernando', 'España'); -- Error

-- Error 2: Violación de clave única
-- INSERT INTO empresa (idEmpresa, nombre, ciudad, pais) VALUES (1, 'DUPLICADO', 'Madrid', 'España'); -- Error: clave duplicada

-- Error 3: Tipos incompatibles
-- INSERT INTO empresa (nombre, ciudad, pais) VALUES (123, 'Madrid', 'España'); -- Error: tipo incorrecto

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================