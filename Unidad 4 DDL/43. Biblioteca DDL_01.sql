-- Ejercicio 43: Biblioteca y gestión de libros

CREATE DATABASE IF NOT EXISTS Biblioteca;
USE Biblioteca;

CREATE TABLE libros (
    idLibro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100),
    autor VARCHAR(50)
);

INSERT INTO libros (titulo, autor) VALUES
('Cien años de soledad', 'Gabriel García Márquez'),
('Don Quijote de la Mancha', 'Miguel de Cervantes'),
('La sombra del viento', 'Carlos Ruiz Zafón');

ALTER TABLE libros ADD año_publicacion INT;

UPDATE libros SET año_publicacion = 1967 WHERE titulo = 'Cien años de soledad';
UPDATE libros SET año_publicacion = 1605 WHERE titulo = 'Don Quijote de la Mancha';
UPDATE libros SET año_publicacion = 2001 WHERE titulo = 'La sombra del viento';

CREATE UNIQUE INDEX idx_unico_titulo ON libros(titulo);

CREATE VIEW libros_modernos AS
SELECT titulo, autor, año_publicacion FROM libros WHERE año_publicacion > 1900;

DESCRIBE libros;
SELECT * FROM libros;
SELECT * FROM libros_modernos;

TRUNCATE TABLE libros;

SELECT * FROM libros;

DROP VIEW libros_modernos;
DROP TABLE libros;

SHOW TABLES;