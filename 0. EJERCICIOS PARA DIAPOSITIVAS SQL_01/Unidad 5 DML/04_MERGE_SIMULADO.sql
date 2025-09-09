
-- MERGE (simulado en MySQL con INSERT ... ON DUPLICATE KEY UPDATE)
CREATE DATABASE IF NOT EXISTS ejemplo_ddl;
USE ejemplo_ddl;

CREATE TABLE inventario (
    id INT PRIMARY KEY,
    producto VARCHAR(50),
    cantidad INT
);

INSERT INTO inventario (id, producto, cantidad) VALUES (1, 'Tornillos', 100);

-- Simulación de MERGE: si el id ya existe, actualiza la cantidad
INSERT INTO inventario (id, producto, cantidad)
VALUES (1, 'Tornillos', 150)
ON DUPLICATE KEY UPDATE cantidad = VALUES(cantidad);

-- Error común: si no hay clave primaria o índice único, no funciona
-- INSERT INTO inventario (producto, cantidad) VALUES ('Clavos', 200)
-- ON DUPLICATE KEY UPDATE cantidad = VALUES(cantidad); -- Error: no hay clave única
