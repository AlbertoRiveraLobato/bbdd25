-- =============================================================
-- EJERCICIO MIXTO: CONTROL DE ACCESO Y PRIVILEGIOS EN MySQL
-- =============================================================
-- Contexto: Base de datos de una empresa con gestión de empleados y departamentos.
-- El objetivo es practicar la creación de usuarios, asignación y revocación de privilegios, y consultas sobre los permisos.
-- Incluye operaciones DCL (GRANT, REVOKE, CREATE USER, DROP USER) y consultas sobre la tabla de usuarios.

-- =============================
-- ENUNCIADOS PARA RESOLVER
-- =============================
/*
1) Crea la base de datos y las tablas empleados y departamentos, con las claves y restricciones adecuadas.
2) Inserta algunos registros de ejemplo en ambas tablas.
3) Asegúrate de eliminar los usuarios creados para limpiar el entorno.
4) Crea varios usuarios con diferentes hosts y contraseñas.
5) Asigna privilegios SELECT e INSERT sobre la tabla empleados a los usuarios creados, diferenciando por host.
6) Revoca el privilegio SELECT sobre empleados a uno de los usuarios.
7) Consulta la tabla mysql.user para ver los usuarios creados y sus hosts.
8) Elimina los usuarios creados para limpiar el entorno.
*/

-- 1) Crea la base de datos y las tablas empleados y departamentos, con las claves y restricciones adecuadas.

DROP DATABASE IF EXISTS ejemplos_grant; 
CREATE DATABASE IF NOT EXISTS ejemplos_grant;
USE ejemplos_grant;

CREATE TABLE departamentos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    salario DECIMAL(10,2),
    departamento_id INT,
    
    CONSTRAINT FK_empleados FOREIGN KEY (departamento_id) REFERENCES departamentos(id) ON DELETE SET NULL
);

-- 2) Inserta algunos registros de ejemplo en ambas tablas.

INSERT INTO departamentos (nombre) VALUES ('Ventas'), ('IT'), ('RRHH');
INSERT INTO empleados (nombre, salario, departamento_id) VALUES
('Ana', 2000, 1),
('Luis', 2500, 2),
('Marta', 2200, 3);

-- 3) Asegúrate de eliminar los usuarios creados para limpiar el entorno.
    
DROP USER IF EXISTS 'usuario_prueba'@'localhost';
DROP USER IF EXISTS 'usuario_prueba'@'192.168.1.100';  
DROP USER IF EXISTS 'usuario_prueba'@'127.0.0.1';
DROP USER IF EXISTS 'usuario_prueba'@'%';
DROP USER IF EXISTS 'usuario_prueba_2'@'localhost';

-- 4) Crea varios usuarios con diferentes hosts y contraseñas.

-- CREATE USER 'usuario_prueba'@'localhost' IDENTIFIED BY 'password123'; -- localhost, para con '%', no opera igual que 127.0.0.1.
CREATE USER 'usuario_prueba'@'192.168.1.100' IDENTIFIED BY 'password123'; -- aunque lo vamos a crear, no vamos a poder establecer conexión desde DBeaver si no estamos en esa IP.
CREATE USER 'usuario_prueba'@'127.0.0.1' IDENTIFIED BY 'password123';
CREATE USER 'usuario_prueba'@'%' IDENTIFIED BY 'password123';
CREATE USER 'usuario_prueba_2'@'localhost' IDENTIFIED BY 'password123';

    -- 4.1) desde DBeaver, crea conexiones con estos usuarios, verás que todas son posibles.
            -- Conexión MySQL con 'usuario_prueba', 'password' y al host correspondiente (dónde está residiendo la base de datos: localhost, 127.0.0.1 -> usa mejor esta última IP)

    -- 4.2) desde DBeaver, comprueba los privilegios que tienen por el momento.
            -- SHOW GRANTS FOR 'usuario_prueba'@'127.0.0.1';
            -- SHOW GRANTS FOR 'usuario_prueba'@'%';

-- 5) Asigna privilegios SELECT e INSERT sobre la tabla empleados al usuario_prueba@127.0.0.1

    -- opción 1: 
    GRANT SELECT ON empleados TO 'usuario_prueba'@'127.0.0.1';
    GRANT INSERT ON empleados TO 'usuario_prueba'@'127.0.0.1';

    -- opción 2: (alternativa ya que '%', incluye a 127.0.0.1)
    GRANT SELECT ON empleados TO 'usuario_prueba'@'%';
    GRANT INSERT ON empleados TO 'usuario_prueba'@'%';

    -- 5.1) desde DBeaver, conéctate como 'usuario_prueba'@'127.0.0.1' y comprueba que puedes hacer SELECT e INSERT en empleados.
        -- Deberías poder hacer:
        -- SELECT * FROM empleados;
        -- INSERT INTO empleados (nombre, salario, departamento_id) VALUES ('Prueba', 1500, 1);

-- 6) Revoca el privilegio SELECT sobre empleados al usuario_prueba@127.0.0.1

    -- aunque para las conexiones, podemos usar '%', ya que incluye a cualquier host, para
    -- las creaciones/eliminaciones de usuarios, y asignaciones/revocaciones de privilegios, hay que ser específico con user+host.

    -- De hecho, puedes hacer la prueba, y si revocas el privilegio SELECT desde '%', no se revoca el privilegio para 'usuario_prueba'@'127.0.0.1'.
        REVOKE SELECT ON empleados FROM 'usuario_prueba'@'%';
        -- si ahora consultas los privilegios de 'usuario_prueba'@'127.0.0.1', verás que sigue teniendo SELECT.
        -- O si intentas hacer un SELECT desde una conexión con 'usuario_prueba'@'127.0.0.1', funcionará porque ese privilegio no fue revocado desde '%'.

    -- La forma correcta de revocar el privilegio SELECT para 'usuario_prueba'@'127.0.0.1' es:
    REVOKE SELECT ON empleados FROM 'usuario_prueba'@'127.0.0.1';  

    -- 6.1) desde DBeaver, conéctate como 'usuario_prueba'@'127.0.0.1' y comprueba que ya no puedes hacer SELECT en empleados.
        -- Deberías obtener un error al intentar:
        -- SELECT * FROM empleados;

-- 7) Ahora vamos a eliminar los usuarios creados para limpiar el entorno.

DROP USER IF EXISTS 'usuario_prueba'@'localhost';
DROP USER IF EXISTS 'usuario_prueba'@'192.168.1.100';  
DROP USER IF EXISTS 'usuario_prueba'@'127.0.0.1';
DROP USER IF EXISTS 'usuario_prueba'@'%';
DROP USER IF EXISTS 'usuario_prueba_2'@'localhost';

    -- 7.1) desde DBeaver, intenta conectarte con alguno de los usuarios eliminados para verificar que ya no existen.
        -- Deberías obtener un error de autenticación al intentar conectarte.   



-- =============================
-- COMANDOS ÚTILES PARA PRUEBAS ADICIONALES
-- =============================


-- Comandos útiles para comprobar los usuarios y sus hosts:
-- A) Consulta la tabla mysql.user para ver los usuarios creados y sus hosts.
SELECT user, host 
FROM mysql.user 
WHERE user = 'usuario_prueba';