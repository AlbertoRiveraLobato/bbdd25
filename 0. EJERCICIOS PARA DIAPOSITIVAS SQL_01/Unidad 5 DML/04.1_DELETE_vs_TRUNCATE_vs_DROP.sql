-- #######################################################
-- # DIFERENCIAS ENTRE DELETE, TRUNCATE Y DROP           #
-- # Incluye:                                           #
-- # - Ejemplos de cada comando                         #
-- # - Comparación de características                   #
-- # - Casos de uso recomendados                        #
-- #######################################################

CREATE DATABASE IF NOT EXISTS comparacion_operaciones;
USE comparacion_operaciones;

-- Tabla para pruebas
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

-- Insertar datos de prueba
INSERT INTO clientes (nombre, email) VALUES
('Ana García', 'ana@example.com'),
('Carlos Ruiz', 'carlos@example.com'),
('Elena Torres', 'elena@example.com');

INSERT INTO pedidos (cliente_id, producto, cantidad) VALUES
(1, 'Laptop', 1),
(1, 'Mouse', 2),
(2, 'Teclado', 1),
(3, 'Monitor', 1);

-- ##########################################
-- # 1. DELETE                              #
-- ##########################################

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
-- Verificar resultados antes de commit
SELECT * FROM pedidos;
-- COMMIT;
ROLLBACK; -- Para deshacer en pruebas

-- ##########################################
-- # 2. TRUNCATE                            #
-- ##########################################

-- TRUNCATE TABLE (elimina todos los registros)
TRUNCATE TABLE pedidos;

-- TRUNCATE no funciona con FOREIGN KEY constraints
-- Primero debemos eliminar o deshabilitar las constraints

-- TRUNCATE con tabla sin referencias
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

-- ##########################################
-- # 3. DROP                                #
-- ##########################################

-- DROP TABLE (elimina tabla completa)
DROP TABLE IF EXISTS logs_auditoria;

-- DROP DATABASE (elimina base de datos completa)
-- CREATE DATABASE prueba_drop;
-- DROP DATABASE prueba_drop;

-- ##########################################
-- # COMPARACIÓN                            #
-- ##########################################

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

-- ##########################################
-- # CASOS DE USO RECOMENDADOS              #
-- ##########################################

-- ✅ USAR DELETE cuando:
--   - Necesitas eliminar registros específicos
--   - Requieres transaccionalidad
--   - Quieres mantener la estructura

-- ✅ USAR TRUNCATE cuando:
--   - Necesitas eliminar TODOS los registros rápidamente
--   - No necesitas cláusula WHERE
--   - Quieres reiniciar contadores AUTO_INCREMENT

-- ✅ USAR DROP cuando:
--   - Quieres eliminar completamente la tabla
--   - Vas a recrear la estructura
--   - No necesitas los datos ni la estructura

-- ##########################################
-- # EJEMPLO PRÁCTICO                      #
-- ##########################################

-- Escenario: Limpieza mensual de datos
START TRANSACTION;

-- Archivar datos antiguos primero
CREATE TABLE pedidos_archivo AS
SELECT * FROM pedidos WHERE fecha < '2023-01-01';

-- Eliminar datos archivados
DELETE FROM pedidos WHERE fecha < '2023-01-01';

-- TRUNCATE para tablas temporales
TRUNCATE TABLE temp_logs;

COMMIT;

-- En desarrollo: DROP para limpieza
DROP TABLE IF EXISTS temp_table_old;