-- Ejercicio 44: Club deportivo y gestión de equipos

CREATE DATABASE IF NOT EXISTS ClubDeportivo;
USE ClubDeportivo;

CREATE TABLE equipos (
    idEquipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    ciudad VARCHAR(50)
);

INSERT INTO equipos (nombre, ciudad) VALUES
('Tigres', 'Madrid'),
('Leones', 'Barcelona'),
('Águilas', 'Valencia');

ALTER TABLE equipos ADD fundacion YEAR DEFAULT 2000;
ALTER TABLE equipos MODIFY ciudad VARCHAR(80);
ALTER TABLE equipos CHANGE fundacion año_fundacion YEAR DEFAULT 2000;

CREATE INDEX idx_nombre_ciudad ON equipos(nombre, ciudad);

DESCRIBE equipos;
SELECT * FROM equipos;

TRUNCATE TABLE equipos;

INSERT INTO equipos (nombre, ciudad, año_fundacion) VALUES
('Panteras', 'Sevilla', 2010),
('Osos', 'Bilbao', 2015);

SELECT * FROM equipos;

DROP INDEX idx_nombre_ciudad ON equipos;
DROP TABLE equipos;