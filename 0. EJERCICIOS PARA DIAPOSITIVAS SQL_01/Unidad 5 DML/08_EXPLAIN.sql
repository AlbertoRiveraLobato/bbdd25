
-- EXPLAIN: muestra cómo se ejecutaría una consulta (estructura interna)
CREATE DATABASE IF NOT EXISTS ejemplo_ddl;
USE ejemplo_ddl;

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    ciudad VARCHAR(50)
);

INSERT INTO clientes (nombre, ciudad) VALUES ('Juan', 'Madrid'), ('Lucía', 'Sevilla');

-- Aunque aún no hemos visto SELECT, EXPLAIN se usa para analizar consultas
EXPLAIN SELECT * FROM clientes;

-- Error común: usar EXPLAIN sobre una consulta mal formada
-- EXPLAIN SELECTE * FROM clientes; -- Error: 'SELECTE' no es válido
