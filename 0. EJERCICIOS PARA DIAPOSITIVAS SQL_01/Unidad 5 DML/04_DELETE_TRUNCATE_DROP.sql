
-- =============================================
-- 04_DELETE_TRUNCATE_DROP.sql
-- =============================================
-- Ejemplo de uso de DELETE, TRUNCATE y DROP en MySQL/MariaDB.
-- Contenido:
--   - Creación de base de datos y tablas necesarias.
--   - Ejemplos de sentencias correctas de borrado y eliminación.
--   - Ejemplos de sentencias erróneas y explicación de los errores más comunes.

-- =============================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS
-- =============================================

CREATE DATABASE IF NOT EXISTS ejemplo_delete;
USE ejemplo_delete;

CREATE TABLE IF NOT EXISTS empresa (
    idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    ciudad VARCHAR(50),
    pais VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temporal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dato VARCHAR(50)
);

-- =============================================
-- EJEMPLOS DE USO CORRECTO
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
-- EJEMPLOS DE SENTENCIAS ERRÓNEAS Y EXPLICACIÓN
-- =============================================

-- Error 1: Olvidar WHERE en DELETE
-- DELETE FROM empresa; -- Elimina todos los registros

-- Error 2: TRUNCATE con restricciones FOREIGN KEY
-- Si temporal tuviera claves foráneas, TRUNCATE fallaría

-- Error 3: DROP de tabla inexistente
-- DROP TABLE tabla_que_no_existe; -- Error: tabla no encontrada

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
