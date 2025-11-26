-- =============================================
-- PRÁCTICAS DE SQL-DCL: GRANT
-- =============================================
-- Descripción: Este archivo sirve como guía para practicar el comando GRANT en SQL-DCL.
-- Incluye creación de base, tablas, inserción de datos y ejercicios.

-- CONSTRUCCIÓN DE LA BASE DE DATOS Y TABLAS
-- Será una base de datos relacionada con una empresa que tiene empleados y departamentos.
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

DROP USER IF EXISTS 'usuario_prueba'@'localhost';
DROP USER IF EXISTS 'usuario_prueba_2'@'localhost';
DROP USER IF EXISTS 'usuario_prueba'@'192.168.1.100';  -- O cualquier otra IP "%"

CREATE USER 'usuario_prueba'@'localhost' IDENTIFIED BY 'password123';
CREATE USER 'usuario_prueba_2'@'localhost' IDENTIFIED BY 'password123';

INSERT INTO departamentos (nombre) VALUES ('Ventas'), ('IT'), ('RRHH');
INSERT INTO empleados (nombre, salario, departamento_id) VALUES
('Ana', 2000, 1),
('Luis', 2500, 2),
('Marta', 2200, 3);

-- =============================================
-- COMPROBACIÓN INICIAL DE PRIVILEGIOS DEL USUARIO
-- =============================================

/*-- Comandos de comprobación y reseteo:
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'usuario_prueba'@'localhost';
GRANT ALL PRIVILEGES ON ejemplos_grant.* TO 'usuario_prueba'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'usuario_prueba'@'localhost';
*/
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'usuario_prueba'@'localhost';

-- Ejemplo de conexión desde DBeaver:
    -- Abre DBeaver y crea una nueva conexión a la base de datos MySQL.
    -- Introduce 'usuario_prueba' como usuario y 'password123' como contraseña.
    -- No selecciones ninguna base de datos: déjalo en blanco.

-- Es posible, por una debilidad de MySQL, que haya que reconectar desde DBeaver para que los permisos se actualicen correctamente.

-- Prueba de acceso antes de asignar permisos (como usuario_prueba):
-- (Deberían fallar TODAS, ya que no tiene privilegios)
    -- Desde usuario_prueba (DBeaver):
		USE ejemplos_grant;
		SELECT * FROM empleados;
		INSERT INTO empleados (nombre, salario, departamento_id) VALUES ('Prueba', 1000, 1);

-- El sistema debe devolver un error de permisos insuficientes.


-- EJERCICIOS BÁSICOS
-- 1. Concede privilegios SELECT sobre empleados solo desde una IP específica.
-- 2. Concede privilegios SELECT sobre la tabla empleados al usuario usuario_prueba desde localhost.
-- 3. Concede privilegios INSERT sobre la tabla empleados al usuario usuario_prueba.
-- 4. Concede privilegios UPDATE sobre empleados al usuario usuario_prueba.
-- 5. Concede privilegios DELETE sobre empleados al usuario usuario_prueba.
-- 6. Concede varios privilegios a la vez: DROP y ALTER sobre la base ejemplos_grant al usuario usuario_prueba.
-- 7. Concede TODOS los privilegios sobre departamentos al usuario usuario_prueba.
-- 8. Concede privilegios CREATE sobre la base ejemplos_grant al usuario usuario_prueba.


-- SOLUCIONES
-- 1. Concede privilegios SELECT sobre empleados solo desde una IP específica.
GRANT SELECT ON empleados TO 'usuario_prueba'@'192.168.1.100'; -- dará error, porque el user no está definido en ese host
	-- por tanto, habrá que crearlo
    CREATE USER 'usuario_prueba'@'192.168.1.100' IDENTIFIED BY 'password123';
    GRANT SELECT ON empleados TO 'usuario_prueba'@'192.168.1.100';

    -- (Desde DBeaver) Intenta usar ahora la base y mostrar la tabla empleados:
    USE ejemplos_grant; -- NO debería funcionar, ya que el host desde el que accede no es ese, sino localhost.
    SELECT * FROM empleados; -- NO debería funcionar, ya que el host desde el que accede no es ese, sino localhost.

-- 2. Concede privilegios SELECT sobre la tabla empleados al usuario usuario_prueba desde localhost.
GRANT SELECT ON empleados TO 'usuario_prueba'@'localhost';
    
    -- (Desde DBeaver) Intenta usar ahora la base y mostrar la tabla empleados:
    USE ejemplos_grant; -- ahora debería funcionar.
    SELECT * FROM empleados; -- ahora debería funcionar.
    -- Pero si intentas insertar, aún fallará:
    INSERT INTO empleados (nombre, salario, departamento_id) VALUES ('Prueba', 1000, 1); -- Debería fallar.
    -- Y si intentas generar privilegios, también fallará:
    GRANT INSERT ON empleados TO 'otro_usuario'@'localhost'; -- Debería fallar.

-- 3. Concede privilegios INSERT sobre la tabla empleados al usuario usuario_prueba.
GRANT INSERT ON empleados TO 'usuario_prueba'@'localhost';
    
    -- (Desde DBeaver) Actualiza salario y departamento_id del usuario 'Julián' (id = 4):
    UPDATE empleados SET salario = 2200, departamento_id = 2 WHERE id = 4; -- debería fallar
    -- (Desde DBeaver) Inserta un nuevo empleado 'Julián':
    INSERT INTO empleados (nombre) VALUES ('Julián');

-- 4. Concede privilegios UPDATE sobre empleados al usuario usuario_prueba.
GRANT UPDATE ON empleados TO 'usuario_prueba'@'localhost';
    
    -- (Desde DBeaver) Actualiza salario y departamento_id del usuario 'Julián':
    SELECT * FROM empleados WHERE nombre = 'Julián'; -- para localizar el id
    UPDATE empleados SET salario = 2200, departamento_id = 2 WHERE id = XX; -- id de ese empleado

-- 5. Concede privilegios DELETE sobre empleados al usuario usuario_prueba.
GRANT DELETE ON empleados TO 'usuario_prueba'@'localhost';
    
    -- (Desde DBeaver) Intenta vaciar la tabla empleados con TRUNCATE:
    TRUNCATE TABLE empleados; -- debería fallar. (Además, este comando no se puede ejecutar contra una tabla que posee la PK a la que está apuntando una FK; se debe vaciar con delete)
    DELETE FROM empleados WHERE (id IS NULL) OR (id IS NOT NULL); -- debería funcionar.

-- 6. Concede varios privilegios a la vez: DROP y ALTER sobre la base ejemplos_grant al usuario usuario_prueba.
GRANT DROP, ALTER ON ejemplos_grant.* TO 'usuario_prueba'@'localhost';

-- 7. Concede TODOS los privilegios sobre departamentos al usuario usuario_prueba.
GRANT ALL PRIVILEGES ON departamentos TO 'usuario_prueba'@'localhost';

-- 8. Concede privilegios CREATE sobre la base ejemplos_grant al usuario usuario_prueba.
GRANT CREATE ON ejemplos_grant.* TO 'usuario_prueba'@'localhost';

    -- (Desde DBeaver) Intenta crear una nueva tabla:
    CREATE TABLE aux (
        id INT PRIMARY KEY,
        col2 INT
    ); -- Ahora funcionará


-- =====================================================
-- EJEMPLOS: INFLUENCIA DEL ORDEN DE PRIVILEGIOS
-- =====================================================

-- 1. Privilegios de tabla vs. base de datos

	-- Si primero das un privilegio específico sobre una tabla:
	GRANT SELECT ON empleados TO 'usuario_prueba'@'localhost';
	-- Y después das todos los privilegios sobre la base:
	GRANT ALL PRIVILEGES ON ejemplos_grant.* TO 'usuario_prueba'@'localhost';
	-- El usuario termina con todos los privilegios sobre todas las tablas, no solo sobre empleados.

	-- Pero si primero das ALL y luego revocas solo en una tabla:
	GRANT ALL PRIVILEGES ON ejemplos_grant.* TO 'usuario_prueba'@'localhost';
	REVOKE INSERT ON empleados FROM 'usuario_prueba'@'localhost';
	-- El usuario NO puede hacer INSERT en empleados, pero sí en el resto de tablas.

-- 2. GRANT OPTION y privilegios delegados

	-- Si primero das el privilegio sin GRANT OPTION:  (capacidad para otorgar permisos a otros usuarios)
	GRANT SELECT ON empleados TO 'usuario_prueba'@'localhost';
	-- Y luego añades GRANT OPTION:
	GRANT SELECT ON empleados TO 'usuario_prueba'@'localhost' WITH GRANT OPTION;
	-- Ahora el usuario puede delegar ese permiso a otros.
    -- Ver los usuarios del sistema local:
    SELECT user, host FROM mysql.user;

    -- 2.1 (Desde DBeaver) Intenta dar permisos de SELEC sobre empleados al usuario_prueba_2
    grant select on empleados to 'usuario_prueba_2'@'localhost';  -- debería funcionar.

	-- Pero si primero das GRANT OPTION y luego lo revocas:
	GRANT SELECT ON empleados TO 'usuario_prueba'@'localhost' WITH GRANT OPTION;
	REVOKE GRANT OPTION ON empleados FROM 'usuario_prueba'@'localhost';
	-- El usuario pierde la capacidad de delegar, aunque conserve el SELECT.
    

-- COMENTARIOS TEÓRICOS
-- El comando GRANT se utiliza en SQL-DCL para gestionar permisos y usuarios.
-- Errores comunes: olvidar especificar el host, no usar FLUSH PRIVILEGES tras cambios, etc.



-- NOTAS.

/*
-- CONEXIÓN DESDE DBEAVER Y ERROR DE RECUPERACIÓN DE CLAVE PÚBLICA.
Error (“Public Key Retrieval is not allowed”) ocurre porque DBeaver (y otros clientes JDBC) intentan autenticarse usando el plugin caching_sha2_password (por defecto en MySQL 8+) y la opción de recuperación de clave pública no está permitida.

Para solucionarlo, tienes dos opciones:

Opción 1: Añadir allowPublicKeyRetrieval=true en la conexión de DBeaver
En DBeaver, edita la conexión.
Ve a la pestaña Driver Properties.
Busca la propiedad allowPublicKeyRetrieval y ponla en true.
Si no existe, añádela manualmente.
Asegúrate de que useSSL está en false (si es solo para pruebas locales).
Guarda y vuelve a conectar.

*/

