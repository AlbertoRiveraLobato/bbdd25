
CREATE DATABASE IF NOT EXISTS comandos;
USE comandos;

CREATE TABLE IF NOT EXISTS empresa (
	idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50),
	ciudad VARCHAR(50),
	país VARCHAR(50)
);

INSERT INTO empresa (nombre, ciudad, país) VALUES
('ALCAMPO', 'Madrid', 'España'),
('CARREFOUR', 'Sevilla', 'España'),
('LIDL', 'Berlín', 'Alemania');

DELETE FROM empresa WHERE idEmpresa = 6;
DELETE FROM empresa WHERE nombre = 'ALCAMPO';

CREATE DATABASE IF NOT EXISTS ejemplo_ddl;
USE ejemplo_ddl;

CREATE TABLE temporal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dato VARCHAR(50)
);

INSERT INTO temporal (dato) VALUES ('A'), ('B'), ('C');

DELETE FROM temporal WHERE dato = 'B';
TRUNCATE TABLE temporal;
DROP TABLE temporal;

CREATE DATABASE IF NOT EXISTS comparacion_operaciones;
USE comparacion_operaciones;

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    activo BOOLEAN DEFAULT true
);

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    producto VARCHAR(50),
    cantidad INT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes (nombre, email) VALUES
('Ana García', 'ana@example.com'),
('Carlos Ruiz', 'carlos@example.com'),
('Elena Torres', 'elena@example.com');

INSERT INTO pedidos (cliente_id, producto, cantidad) VALUES
(1, 'Laptop', 1),
(1, 'Mouse', 2),
(2, 'Teclado', 1),
(3, 'Monitor', 1);

DELETE FROM pedidos WHERE cliente_id = 1;
DELETE p 
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id 
WHERE c.nombre = 'Carlos Ruiz';
START TRANSACTION;
DELETE FROM pedidos WHERE cliente_id = 3;
SELECT * FROM pedidos;
ROLLBACK; -- Para deshacer en pruebas

TRUNCATE TABLE pedidos;
CREATE TABLE logs_auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensaje TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO logs_auditoria (mensaje) VALUES
('Log de prueba 1'),
('Log de prueba 2'),
('Log de prueba 3');
TRUNCATE TABLE logs_auditoria;

DROP TABLE IF EXISTS logs_auditoria;

/*
DELETE vs TRUNCATE vs DROP:
1. DELETE:
   - Elimina registros uno por uno
   - Se puede usar con WHERE
   - Registra en log de transacciones
   - Mantiene la estructura de la tabla
   - Se puede hacer ROLLBACK
   - Más lento para grandes volúmenes
2. TRUNCATE:
   - Elimina todos los registros de una vez
   - No se puede usar con WHERE
   - Reinicia los contadores AUTO_INCREMENT
   - Más rápido que DELETE
   - DDL operation (no registra logs individuales)
   - No se puede hacer ROLLBACK en algunas BD
3. DROP:
   - Elimina toda la tabla o base de datos
   - Elimina estructura y datos
   - Operación DDL irreversible
*/


START TRANSACTION;
CREATE TABLE pedidos_archivo AS
SELECT * FROM pedidos WHERE fecha < '2023-01-01';
DELETE FROM pedidos WHERE fecha < '2023-01-01';
TRUNCATE TABLE temp_logs;
COMMIT;
DROP TABLE IF EXISTS temp_table_old;
-- =============================================
-- 05_DELETE_TRUNCATE_DROP.sql
-- =============================================
-- Ejemplos de uso de DELETE, TRUNCATE y DROP en MySQL.
-- Incluye: creación de base de datos y tablas, ejemplos de borrado, y errores comunes.

-- CREACIÓN DE BASE DE DATOS Y TABLAS
CREATE DATABASE IF NOT EXISTS ejemplo_delete;
USE ejemplo_delete;

CREATE TABLE empresa (
    idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    ciudad VARCHAR(50),
    pais VARCHAR(50)
);

CREATE TABLE temporal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dato VARCHAR(50)
);

-- =============================================
-- EJEMPLOS DE USO
-- =============================================

-- DELETE: elimina registros específicos
INSERT INTO empresa (nombre, ciudad, pais) VALUES ('ALCAMPO', 'Madrid', 'España');
DELETE FROM empresa WHERE nombre = 'ALCAMPO';

-- TRUNCATE: elimina todos los registros de una tabla
INSERT INTO temporal (dato) VALUES ('A'), ('B'), ('C');
TRUNCATE TABLE temporal;

-- DROP: elimina la tabla por completo
DROP TABLE IF EXISTS temporal;

-- =============================================
-- ERRORES COMUNES
-- =============================================

-- Error 1: Olvidar WHERE en DELETE
-- DELETE FROM empresa; -- Elimina todos los registros

-- Error 2: TRUNCATE con restricciones FOREIGN KEY
-- Si temporal tuviera claves foráneas, TRUNCATE fallaría

-- Error 3: DROP de tabla inexistente
-- DROP TABLE tabla_que_no_existe; -- Error: tabla no encontrada
