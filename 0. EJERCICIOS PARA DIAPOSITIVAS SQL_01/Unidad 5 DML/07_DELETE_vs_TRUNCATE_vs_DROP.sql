-- =============================================
-- 07_DELETE_vs_TRUNCATE_vs_DROP.sql
-- =============================================
-- Ejemplo comparativo de DELETE, TRUNCATE y DROP en MySQL/MariaDB.
-- Contenido:
--   - Creación de base de datos y tablas necesarias.
--   - Ejemplos de sentencias correctas de borrado y eliminación.
--   - Ejemplos de sentencias erróneas y explicación de los errores más comunes.
--   - Comparación y casos de uso recomendados.

-- =============================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS
-- =============================================

CREATE DATABASE IF NOT EXISTS comparacion_operaciones;
USE comparacion_operaciones;

CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    activo BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    producto VARCHAR(50),
    cantidad INT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- =============================================
-- EJEMPLOS DE USO CORRECTO
-- =============================================

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
ROLLBACK; -- Para deshacer en pruebas

-- TRUNCATE TABLE (elimina todos los registros)
TRUNCATE TABLE pedidos;

-- TRUNCATE con tabla sin referencias
CREATE TABLE IF NOT EXISTS logs_auditoria (
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

-- =============================================
-- EJEMPLOS DE SENTENCIAS ERRÓNEAS Y EXPLICACIÓN
-- =============================================

-- Error 1: Olvidar WHERE en DELETE
-- DELETE FROM pedidos; -- Elimina todos los registros

-- Error 2: TRUNCATE con restricciones FOREIGN KEY
-- Si la tabla tiene claves foráneas, TRUNCATE fallará

-- Error 3: DROP de tabla inexistente
-- DROP TABLE tabla_que_no_existe; -- Error: tabla no encontrada

-- =============================================
-- COMPARACIÓN Y CASOS DE USO RECOMENDADOS
-- =============================================

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

-- Casos de uso recomendados:
-- ✅ USAR DELETE cuando necesitas eliminar registros específicos y mantener la estructura.
-- ✅ USAR TRUNCATE cuando necesitas eliminar todos los registros rápidamente y reiniciar contadores.
-- ✅ USAR DROP cuando quieres eliminar completamente la tabla o base de datos.

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================