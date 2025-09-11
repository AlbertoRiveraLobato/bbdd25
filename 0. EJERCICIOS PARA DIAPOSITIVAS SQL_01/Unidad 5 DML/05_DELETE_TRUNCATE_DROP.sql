-- #######################################################
-- # DIFERENCIAS ENTRE DELETE, TRUNCATE Y DROP           #
-- # Incluye:                                            #
-- # - Ejemplos de cada comando                          #
-- # - Comparación de características                    #
-- # - Casos de uso recomendados                         #
-- #######################################################

-- Ejemplo 1: DELETE sobre tabla empresa
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

-- Borrar por clave primaria
DELETE FROM empresa WHERE idEmpresa = 6;
-- Borrar por otro campo (pueden ser varias filas)
DELETE FROM empresa WHERE nombre = 'ALCAMPO';

-- Ejemplo 2: DELETE, TRUNCATE y DROP sobre tabla temporal
CREATE DATABASE IF NOT EXISTS ejemplo_ddl;
USE ejemplo_ddl;

CREATE TABLE temporal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dato VARCHAR(50)
);

INSERT INTO temporal (dato) VALUES ('A'), ('B'), ('C');

-- DELETE: elimina datos pero conserva la tabla
DELETE FROM temporal WHERE dato = 'B';
-- TRUNCATE: elimina todos los datos rápidamente
TRUNCATE TABLE temporal;
-- DROP: elimina completamente la tabla
DROP TABLE temporal;

-- Ejemplo 3: Comparación avanzada y casos de uso
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

-- DELETE específico con WHERE
DELETE FROM pedidos WHERE cliente_id = 1;
-- DELETE de todos los registros (¡CUIDADO!)
-- DELETE FROM pedidos;
-- DELETE con JOIN
DELETE p 
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id 
WHERE c.nombre = 'Carlos Ruiz';
-- DELETE con transacción (recomendado)
START TRANSACTION;
DELETE FROM pedidos WHERE cliente_id = 3;
SELECT * FROM pedidos;
-- COMMIT;
ROLLBACK; -- Para deshacer en pruebas

-- TRUNCATE TABLE (elimina todos los registros)
TRUNCATE TABLE pedidos;
-- TRUNCATE no funciona con FOREIGN KEY constraints
-- Primero debemos eliminar o deshabilitar las constraints
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

-- DROP TABLE (elimina tabla completa)
DROP TABLE IF EXISTS logs_auditoria;
-- DROP DATABASE (elimina base de datos completa)
-- CREATE DATABASE prueba_drop;
-- DROP DATABASE prueba_drop;

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

-- Casos de uso recomendados
-- USAR DELETE cuando:
--   - Necesitas eliminar registros específicos
--   - Requieres transaccionalidad
--   - Quieres mantener la estructura
-- USAR TRUNCATE cuando:
--   - Necesitas eliminar TODOS los registros rápidamente
--   - No necesitas cláusula WHERE
--   - Quieres reiniciar contadores AUTO_INCREMENT
-- USAR DROP cuando:
--   - Quieres eliminar completamente la tabla
--   - Vas a recrear la estructura
--   - No necesitas los datos ni la estructura

-- Escenario: Limpieza mensual de datos
START TRANSACTION;
CREATE TABLE pedidos_archivo AS
SELECT * FROM pedidos WHERE fecha < '2023-01-01';
DELETE FROM pedidos WHERE fecha < '2023-01-01';
TRUNCATE TABLE temp_logs;
COMMIT;
DROP TABLE IF EXISTS temp_table_old;
