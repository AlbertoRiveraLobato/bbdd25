
-- DELETE vs DROP vs TRUNCATE: Eliminación de datos o estructuras
CREATE DATABASE IF NOT EXISTS ejemplo_ddl;
USE ejemplo_ddl;

CREATE TABLE temporal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dato VARCHAR(50)
);

INSERT INTO temporal (dato) VALUES ('A'), ('B'), ('C');

-- DELETE: elimina datos pero conserva la tabla
DELETE FROM temporal WHERE dato = 'B';

-- TRUNCATE: elimina todos los datos rápidamente, sin registro de transacciones
TRUNCATE TABLE temporal;

-- DROP: elimina completamente la tabla
DROP TABLE temporal;

-- Error común: intentar borrar una tabla que no existe
-- DROP TABLE no_existe; -- Error: tabla no encontrada
