
-- LOAD DATA: Carga masiva de datos desde un archivo externo
CREATE DATABASE IF NOT EXISTS ejemplo_ddl;
USE ejemplo_ddl;

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2)
);

-- Supongamos que tenemos un archivo llamado 'productos.csv' con datos válidos
LOAD DATA LOCAL INFILE 'productos.csv' INTO TABLE productos
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '
';

-- Error común: si el archivo no existe o no se permite LOAD DATA LOCAL
-- LOAD DATA LOCAL INFILE 'no_existe.csv' INTO TABLE productos; -- Error: archivo no encontrado
