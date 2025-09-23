-- Eliminar una base de datos
DROP DATABASE IF EXISTS MiBaseDeDatos;

-- Eliminar una tabla
DROP TABLE IF EXISTS comandos.empresa;

-- Eliminar una vista
DROP VIEW IF EXISTS comandos.vista_empresas;

-- Eliminar un índice
DROP INDEX idx_nombre ON comandos.empresa_nueva;

-- Eliminar una columna
ALTER TABLE comandos.empresa_nueva DROP COLUMN provincia;


-- =============================================================
-- ERRORES COMUNES Y MALAS PRÁCTICAS EN DROP (MySQL)
-- =============================================================
-- A continuación se muestran ejemplos de comandos incorrectos o confusos que suelen causar errores o comportamientos inesperados en MySQL.

-- Error: Intentar eliminar una base de datos o tabla que no existe sin IF EXISTS.
-- DROP DATABASE MiBaseDeDatos;
-- Comentario: Si la base de datos o tabla no existe, MySQL dará error. Usa IF EXISTS para evitarlo.

-- Error: Olvidar que DROP TABLE elimina todos los datos de forma irreversible.
-- DROP TABLE empleados;
-- Comentario: DROP TABLE borra la tabla y sus datos permanentemente. No se puede recuperar.

-- Error: Intentar eliminar una columna en versiones antiguas de MySQL (antes de 5.7).
-- ALTER TABLE comandos.empresa DROP COLUMN pais;
-- Comentario: En versiones antiguas, DROP COLUMN no está soportado. Hay que crear una tabla nueva sin esa columna y migrar los datos.

-- Error: Usar DROP INDEX como si fuera DROP CONSTRAINT para claves primarias.
-- DROP INDEX pk_id ON empleados;
-- Comentario: Para eliminar una PRIMARY KEY se debe usar DROP PRIMARY KEY, no DROP INDEX.

-- Error: Olvidar el punto y coma al final de la instrucción.
-- DROP TABLE empleados
-- Comentario: MySQL espera un punto y coma (;) al final de cada instrucción.