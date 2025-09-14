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