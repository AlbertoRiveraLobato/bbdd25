-- =============================================
-- PRÁCTICAS DE SQL-DCL: DROP USER
-- =============================================
-- Descripción: Este archivo sirve como guía para practicar el comando DROP USER en SQL-DCL.
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
CREATE USER 'usuario_prueba2'@'192.168.1.100' IDENTIFIED BY 'password123';
CREATE USER 'usuario1'@'localhost' IDENTIFIED BY 'password123';
CREATE USER 'usuario2'@'localhost' IDENTIFIED BY 'password123';

-- INSERCIÓN DE DATOS
INSERT INTO departamentos (nombre) VALUES ('Ventas'), ('IT'), ('RRHH');
INSERT INTO empleados (nombre, salario, departamento_id) VALUES
('Ana', 2000, 1),
('Luis', 2500, 2),
('Marta', 2200, 3);


-- EJERCICIOS BÁSICOS (4)
-- 1. Elimina el usuario usuario_prueba.
-- 2. Elimina varios usuarios en una sola sentencia.
-- 3. Elimina un usuario solo si existe.
-- 4. Elimina usuarios con comodín en host.


-- SOLUCIONES
-- 1. Elimina el usuario usuario_prueba.
DROP USER 'usuario_prueba'@'localhost';

-- 2. Elimina varios usuarios en una sola sentencia.
DROP USER 'usuario1'@'localhost', 'usuario2'@'localhost';

-- 3. Elimina un usuario solo si existe.
DROP USER IF EXISTS 'usuario_prueba'@'localhost';
DROP USER IF EXISTS 'usuario2'@'localhost';

-- 4. Elimina usuarios con comodín en host.
DROP USER 'usuario_prueba2'@'%';

-- Batería de comandos para pruebas adicionales.
DROP USER IF EXISTS 'usuario_prueba'@'localhost'; 
DROP USER IF EXISTS 'usuario_prueba'@'192.168.1.100';  -- el usuario queda definido completamente por user+host
DROP USER IF EXISTS 'usuario_prueba'@'127.0.0.1'; 
DROP USER IF EXISTS 'usuario_prueba'@'%';
DROP USER IF EXISTS 'usuario_prueba_2'@'localhost';


CREATE USER 'usuario_prueba'@'localhost' IDENTIFIED BY 'password123';  -- localhost NO es lo mismo que 127.0.0.1 (por eso con localhost NO funciona '%')
CREATE USER 'usuario_prueba'@'192.168.1.100' IDENTIFIED BY 'password123'; -- el usuario queda definido completamente por user+host
CREATE USER 'usuario_prueba'@'127.0.0.1' IDENTIFIED BY 'password123';
CREATE USER 'usuario_prueba'@'%' IDENTIFIED BY 'password123';
CREATE USER 'usuario_prueba_2'@'localhost' IDENTIFIED BY 'password123';


GRANT SELECT ON empleados TO 'usuario_prueba'@'localhost';
GRANT INSERT ON empleados TO 'usuario_prueba'@'localhost';

GRANT SELECT ON empleados TO 'usuario_prueba'@'192.168.1.100';

REVOKE SELECT ON empleados FROM 'usuario_prueba'@'localhost';


SELECT user, host 
FROM mysql.user 
WHERE user = 'usuario_prueba';


-- Si yo creo un usuario con host '%', ¿afecta a los otros usuarios con el mismo nombre pero host diferente?
-- Respuesta: No, cada combinación de usuario y host es única e independiente en MySQL.
-- Por lo tanto, eliminar un usuario con host '%' no afectará a los usuarios con el
-- mismo nombre pero con hosts específicos como 'localhost' o '192.168.1.100'.
-- Sin embargo, al crear un usuario con host '%', este podrá conectarse desde cualquier host,
-- lo que puede tener implicaciones de seguridad si no se gestiona adecuadamente.
-- Es decir, '%' es un comodín para las conexiones de ese usuario, pero no un comodín para identificar al usuario en sí mismo,
-- y por tanto, NO un comodín para asignar/revocar permisos a otros usuarios con el mismo nombre pero host diferente (ni para borrarlos).