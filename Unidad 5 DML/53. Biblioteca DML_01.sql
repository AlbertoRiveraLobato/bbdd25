-- =============================================
-- 53. Biblioteca DML_01.sql
-- =============================================
-- Ejemplo de aplicación sencilla: Gestión de una biblioteca
-- Incluye ejemplos de DDL y DML básicos (CREATE, INSERT, UPDATE, DELETE)
-- para que los alumnos vean cómo se implementan estos comandos en un caso casi real.

-- Crear base de datos y tablas
CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;

CREATE TABLE IF NOT EXISTS libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150),
    autor VARCHAR(100),
    ejemplares INT
);

CREATE TABLE IF NOT EXISTS socios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100) UNIQUE
);


CREATE TABLE IF NOT EXISTS prestamos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    socio_id INT,
    libro_id INT,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    FOREIGN KEY (socio_id) REFERENCES socios(id),
    FOREIGN KEY (libro_id) REFERENCES libros(id)
);

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================
-- 1) Inserta los siguientes libros en la tabla libros:
--    ('Cien años de soledad', 'Gabriel García Márquez', 5),
--    ('El Quijote', 'Miguel de Cervantes', 3),
--    ('1984', 'George Orwell', 4)
-- 2) Inserta los siguientes socios en la tabla socios:
--    ('Luis Gómez', 'luis@correo.com'), ('Marta Ruiz', 'marta@correo.com')
-- 3) Registra un préstamo del libro con id 2 a Luis Gómez (id 1) el día '2025-09-14'.
-- 4) Actualiza el número de ejemplares del libro prestado.
-- 5) Registra la devolución del libro el día '2025-09-21' y actualiza los ejemplares.
-- 6) Elimina el socio con id 2 (Marta Ruiz).

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================
-- 1) Inserción de libros
INSERT INTO libros (titulo, autor, ejemplares) VALUES
('Cien años de soledad', 'Gabriel García Márquez', 5),
('El Quijote', 'Miguel de Cervantes', 3),
('1984', 'George Orwell', 4);

-- 2) Inserción de socios
INSERT INTO socios (nombre, email) VALUES
('Luis Gómez', 'luis@correo.com'),
('Marta Ruiz', 'marta@correo.com');

-- 3) Registrar un préstamo
INSERT INTO prestamos (socio_id, libro_id, fecha_prestamo, fecha_devolucion) VALUES (1, 2, '2025-09-14', NULL);

-- 4) Actualizar ejemplares tras el préstamo
UPDATE libros SET ejemplares = ejemplares - 1 WHERE id = 2; -- El Quijote

-- 5) Registrar devolución y actualizar ejemplares
UPDATE prestamos SET fecha_devolucion = '2025-09-21' WHERE id = 1;
UPDATE libros SET ejemplares = ejemplares + 1 WHERE id = 2; -- El Quijote

-- 6) Eliminar un socio
DELETE FROM socios WHERE id = 2; -- Marta Ruiz

-- Comentarios:
-- Este ejemplo muestra cómo se usan los comandos DDL y DML en una aplicación sencilla.
-- Los alumnos pueden ver la relación entre tablas y cómo afectan los comandos a los datos.
-- No se usan comandos avanzados, sólo lo visto en clase.
-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
