-- =============================================
-- PRÁCTICAS DE SQL-DCL: REVOKE
-- =============================================
-- Descripción: Este archivo sirve como guía para practicar el comando REVOKE en SQL-DCL.
-- Incluye creación de base, tablas, inserción de datos y ejercicios.

-- CONSTRUCCIÓN DE LA BASE DE DATOS Y TABLAS
CREATE DATABASE IF NOT EXISTS empresa;
USE empresa;

CREATE TABLE departamentos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    salario DECIMAL(10,2),
    departamento_id INT,
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id)
);

CREATE USER 'usuario_prueba'@'localhost' IDENTIFIED BY 'password123';

-- INSERCIÓN DE DATOS
INSERT INTO departamentos (nombre) VALUES ('Ventas'), ('IT'), ('RRHH');
INSERT INTO empleados (nombre, salario, departamento_id) VALUES
('Ana', 2000, 1),
('Luis', 2500, 2),
('Marta', 2200, 3);


-- EJERCICIOS BÁSICOS (7)
-- 1. Revoca privilegios SELECT sobre empleados al usuario usuario_prueba.
-- 2. Revoca privilegios INSERT y UPDATE sobre departamentos al usuario usuario_prueba.
-- 3. Revoca todos los privilegios sobre la base de datos empresa al usuario usuario_prueba.
-- 4. Revoca el privilegio GRANT OPTION sobre la base de datos empresa al usuario usuario_prueba.
-- 5. Revoca el privilegio EXECUTE sobre procedimientos almacenados en la base empresa al usuario usuario_prueba.
-- 6. Revoca privilegios SELECT sobre empleados al usuario usuario_prueba desde una IP específica.
-- 7. Revoca privilegios ALTER, INDEX y DROP sobre empleados al usuario usuario_prueba.


-- SOLUCIONES
-- 1. Revoca privilegios SELECT sobre empleados al usuario usuario_prueba.
REVOKE SELECT ON empleados FROM 'usuario_prueba'@'localhost';

-- 2. Revoca varios privilegios sobre departamentos al usuario usuario_prueba: INSERT y UPDATE.
REVOKE INSERT, UPDATE ON departamentos FROM 'usuario_prueba'@'localhost';

-- 3. Revoca todos los privilegios sobre empresa al usuario usuario_prueba.
REVOKE ALL PRIVILEGES ON empresa.* FROM 'usuario_prueba'@'localhost';

-- 4. Revoca privilegios GRANT OPTION al usuario usuario_prueba.
REVOKE GRANT OPTION ON empresa.* FROM 'usuario_prueba'@'localhost';

-- 5. Revoca privilegios EXECUTE sobre procedimientos almacenados.
REVOKE EXECUTE ON PROCEDURE empresa.* FROM 'usuario_prueba'@'localhost';

-- 6. Revoca privilegios SELECT sobre empleados desde una IP específica.
REVOKE SELECT ON empleados FROM 'usuario_prueba'@'192.168.1.100';

-- 7. Revoca privilegios ALTER sobre empleados al usuario usuario_prueba.
REVOKE ALTER, INDEX, DROP  ON empleados FROM 'usuario_prueba'@'localhost';

