-- =============================================
-- EJERCICIO: DDL y DML - Base de Datos BIBLIOTECA
-- =============================================
-- Ejercicio práctico para utilización de sublenguajes DDL y DML
-- Base de Datos: BIBLIOTECA (basada en normalización desde Excel)
-- IMPORTANTE: Este ejercicio NO utiliza sentencias SELECT

-- =============================================
-- 01. SECCIÓN DDL - CREACIÓN DE BASE DE DATOS Y ESTRUCTURA INICIAL
-- =============================================

-- EJERCICIO 1.1: Crear la base de datos
-- Crea la base de datos 'biblioteca_ejercicios' y selecciónala para uso
DROP DATABASE IF EXISTS biblioteca_ejercicios;
CREATE DATABASE biblioteca_ejercicios;
USE biblioteca_ejercicios;

-- EJERCICIO 1.2: Crear tabla LECTORES (versión inicial incompleta)
-- Crea la tabla Lectores SIN clave primaria y SIN restricciones NOT NULL
CREATE TABLE Lectores (
    LectorID INT,
    NombreLector VARCHAR(100),
    Email VARCHAR(100),
    Telefono VARCHAR(15),
    FechaRegistro DATE,
    Estado ENUM('activo', 'suspendido', 'inactivo')
);

-- EJERCICIO 1.3: Corregir tabla LECTORES - Añadir clave primaria
-- Añade la clave primaria a la tabla Lectores
ALTER TABLE Lectores
    ADD PRIMARY KEY (LectorID);

-- EJERCICIO 1.4: Corregir tabla LECTORES - Añadir restricciones
-- Modifica las columnas para añadir restricciones NOT NULL y DEFAULT donde corresponda
ALTER TABLE Lectores
    MODIFY COLUMN NombreLector VARCHAR(100) NOT NULL,
    MODIFY COLUMN FechaRegistro DATE NOT NULL,
    MODIFY COLUMN Estado ENUM('activo', 'suspendido', 'inactivo') NOT NULL DEFAULT 'activo';

-- EJERCICIO 1.5: Crear tabla AUTORES
-- Crea la tabla Autores con todas sus columnas y restricciones
CREATE TABLE Autores (
    AutorID INT,
    Autor VARCHAR(100) NOT NULL,
    Nacionalidad VARCHAR(50),
    FechaNacimiento DATE,
    FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (AutorID)
);

-- EJERCICIO 1.6: Crear tabla LIBROS
-- Crea la tabla Libros con todas sus columnas, clave primaria y restricciones
CREATE TABLE Libros (
    LibroID INT PRIMARY KEY,
    Libro VARCHAR(150) NOT NULL,
    ISBN VARCHAR(20) UNIQUE,
    AnoPublicacion YEAR,
    Ejemplares INT DEFAULT 1,
    Disponibles INT DEFAULT 1,
    Editorial VARCHAR(100),
    Precio DECIMAL(8,2) DEFAULT 15.99
);

-- EJERCICIO 1.7: Crear tabla intermedia LIBROS_AUTORES (relación N:M)
-- Crea la tabla para la relación muchos a muchos entre Libros y Autores
CREATE TABLE Libros_Autores (
    FK_LibroID INT,
    FK_AutorID INT,
    Orden INT DEFAULT 1,
    PRIMARY KEY (FK_LibroID, FK_AutorID)
);

-- EJERCICIO 1.8: Añadir claves foráneas a LIBROS_AUTORES (primera versión)
-- Añade las claves foráneas SIN acciones en cascada
ALTER TABLE Libros_Autores
    ADD FOREIGN KEY (FK_LibroID) REFERENCES Libros(LibroID),
    ADD FOREIGN KEY (FK_AutorID) REFERENCES Autores(AutorID);

-- EJERCICIO 1.9: Modificar claves foráneas - Eliminar las existentes
-- Elimina las claves foráneas actuales (necesitarás ver los nombres generados automáticamente)
-- NOTA: Ejecuta SHOW CREATE TABLE Libros_Autores; para ver los nombres exactos
ALTER TABLE Libros_Autores DROP FOREIGN KEY libros_autores_ibfk_1;
ALTER TABLE Libros_Autores DROP FOREIGN KEY libros_autores_ibfk_2;

-- EJERCICIO 1.10: Recrear claves foráneas con CASCADE
-- Vuelve a crear las claves foráneas con nombres propios y acciones en cascada
ALTER TABLE Libros_Autores
    ADD CONSTRAINT fk_libros_autores_libro FOREIGN KEY (FK_LibroID) REFERENCES Libros(LibroID) ON DELETE CASCADE,
    ADD CONSTRAINT fk_libros_autores_autor FOREIGN KEY (FK_AutorID) REFERENCES Autores(AutorID) ON DELETE CASCADE;

-- EJERCICIO 1.11: Crear tabla DETALLES_PRESTAMOS (primera versión incorrecta)
-- Crea la tabla con un error intencional: columnas NOT NULL con FK SET NULL
CREATE TABLE Detalles_Prestamos (
    PrestamoID INT PRIMARY KEY,
    FK_LectorID INT NOT NULL,
    FK_LibroID INT NOT NULL,
    FechaPrestamo DATE NOT NULL,
    FechaDevolucion DATE,
    Estado ENUM('activo', 'devuelto', 'vencido') DEFAULT 'activo',
    Multa DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (FK_LectorID) REFERENCES Lectores(LectorID) ON DELETE SET NULL,
    FOREIGN KEY (FK_LibroID) REFERENCES Libros(LibroID) ON DELETE SET NULL
);

-- EJERCICIO 1.12: Corregir tabla DETALLES_PRESTAMOS
-- Elimina la tabla anterior y recréala correctamente
DROP TABLE Detalles_Prestamos;

CREATE TABLE Detalles_Prestamos (
    PrestamoID INT PRIMARY KEY,
    FK_LectorID INT,
    FK_LibroID INT,
    FechaPrestamo DATE NOT NULL,
    FechaDevolucion DATE,
    Estado ENUM('activo', 'devuelto', 'vencido') DEFAULT 'activo',
    Multa DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (FK_LectorID) REFERENCES Lectores(LectorID) ON DELETE SET NULL,
    FOREIGN KEY (FK_LibroID) REFERENCES Libros(LibroID) ON DELETE SET NULL
);

-- EJERCICIO 1.13: Ejercicio adicional - Renombrar columnas FK (método alternativo)
-- NOTA: Si ya tienes tablas creadas sin el prefijo FK_, puedes renombrar las columnas así:
-- ALTER TABLE Libros_Autores CHANGE LibroID FK_LibroID INT;
-- ALTER TABLE Libros_Autores CHANGE AutorID FK_AutorID INT;
-- ALTER TABLE Detalles_Prestamos CHANGE LectorID FK_LectorID INT;
-- ALTER TABLE Detalles_Prestamos CHANGE LibroID FK_LibroID INT;
-- (Luego habrá que recrear las claves foráneas con los nuevos nombres)



-- =============================================
-- 02. SECCIÓN DDL - MODIFICACIONES DE ESTRUCTURA
-- =============================================

-- EJERCICIO 2.1: Añadir columnas a tabla existente
-- Añade una columna 'Descripcion' a la tabla Libros
ALTER TABLE Libros ADD COLUMN Descripcion TEXT;

-- EJERCICIO 2.2: Modificar tipo de dato de columna
-- Cambia el tipo de la columna Telefono en Lectores a VARCHAR(20)
ALTER TABLE Lectores MODIFY COLUMN Telefono VARCHAR(20);

-- EJERCICIO 2.3: Añadir columna con restricción CHECK (si tu versión de MySQL lo soporta)
-- Añade una columna 'Puntuacion' a Libros con valores entre 1 y 10
ALTER TABLE Libros ADD COLUMN Puntuacion INT DEFAULT 5 CHECK (Puntuacion >= 1 AND Puntuacion <= 10);

-- EJERCICIO 2.4: Crear tabla de auditoría
-- Crea una tabla para registrar operaciones sobre las tablas principales
CREATE TABLE Auditoria_Operaciones (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Tabla VARCHAR(50) NOT NULL,
    Operacion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    Usuario VARCHAR(100) DEFAULT USER(),
    Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Descripcion TEXT
);

-- EJERCICIO 2.5: Añadir índices para mejorar rendimiento
-- Crea índices en las columnas más utilizadas
CREATE INDEX idx_lectores_email ON Lectores(Email);
CREATE INDEX idx_libros_isbn ON Libros(ISBN);
CREATE INDEX idx_prestamos_fecha ON Detalles_Prestamos(FechaPrestamo);

-- =============================================
-- 03. SECCIÓN DDL - CREACIÓN DE TRIGGERS
-- =============================================

-- EJERCICIO 3.1: Trigger para validar formato de email
-- Crea un trigger que valide el formato del email antes de insertar en Lectores
DELIMITER $$
CREATE TRIGGER tr_validar_email_lectores
BEFORE INSERT ON Lectores
FOR EACH ROW
BEGIN
    IF NEW.Email IS NOT NULL AND NEW.Email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El email debe tener un formato válido (ejemplo@dominio.com)';
    END IF;
END$$
DELIMITER ;

-- EJERCICIO 3.2: Trigger para actualizar disponibilidad al prestar
-- Crea un trigger que reduzca automáticamente los libros disponibles cuando se hace un préstamo
DELIMITER $$
CREATE TRIGGER tr_reducir_disponibilidad
AFTER INSERT ON Detalles_Prestamos
FOR EACH ROW
BEGIN
    UPDATE Libros 
    SET Disponibles = Disponibles - 1 
    WHERE LibroID = NEW.FK_LibroID;
END$$
DELIMITER ;

-- EJERCICIO 3.3: Trigger para restaurar disponibilidad al devolver
-- Crea un trigger que aumente los libros disponibles cuando se marca como devuelto
DELIMITER $$
CREATE TRIGGER tr_aumentar_disponibilidad
AFTER UPDATE ON Detalles_Prestamos
FOR EACH ROW
BEGIN
    IF OLD.Estado != 'devuelto' AND NEW.Estado = 'devuelto' THEN
        UPDATE Libros 
        SET Disponibles = Disponibles + 1 
        WHERE LibroID = NEW.FK_LibroID;
    END IF;
END$$
DELIMITER ;

-- EJERCICIO 3.4: Trigger para validar disponibilidad antes de préstamo
-- Crea un trigger que impida prestar libros si no hay ejemplares disponibles
DELIMITER $$
CREATE TRIGGER tr_validar_disponibilidad_prestamo
BEFORE INSERT ON Detalles_Prestamos
FOR EACH ROW
BEGIN
    DECLARE ejemplares_disponibles INT DEFAULT 0;
    
    -- Obtener disponibles del libro
    SET ejemplares_disponibles = (
        SELECT Disponibles FROM Libros WHERE LibroID = NEW.FK_LibroID
    );
    
    IF ejemplares_disponibles <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay ejemplares disponibles para este libro';
    END IF;
END$$
DELIMITER ;

-- EJERCICIO 3.5: Trigger de auditoría para lectores
-- Crea un trigger que registre las modificaciones en la tabla Lectores
DELIMITER $$
CREATE TRIGGER tr_auditoria_lectores_update
AFTER UPDATE ON Lectores
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria_Operaciones (Tabla, Operacion, Descripcion)
    VALUES ('Lectores', 'UPDATE', 
            CONCAT('Actualizado lector ID: ', NEW.LectorID, 
                   ' - Nombre: ', NEW.NombreLector,
                   ' - Estado anterior: ', OLD.Estado, 
                   ' - Estado nuevo: ', NEW.Estado));
END$$
DELIMITER ;

-- EJERCICIO 3.6: Trigger de auditoría para inserción de libros
-- Crea un trigger que registre cuando se añaden nuevos libros
DELIMITER $$
CREATE TRIGGER tr_auditoria_libros_insert
AFTER INSERT ON Libros
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria_Operaciones (Tabla, Operacion, Descripcion)
    VALUES ('Libros', 'INSERT', 
            CONCAT('Nuevo libro añadido - ID: ', NEW.LibroID, 
                   ' - Título: ', NEW.Libro,
                   ' - Ejemplares: ', NEW.Ejemplares));
END$$
DELIMITER ;

-- =============================================
-- 04. SECCIÓN DML - INSERCIÓN DE DATOS
-- =============================================

-- EJERCICIO 4.1: Insertar lectores individualmente
-- Inserta 3 lectores uno por uno
INSERT INTO Lectores (LectorID, NombreLector, Email, Telefono, FechaRegistro, Estado) 
VALUES (1, 'María González Pérez', 'maria.gonzalez@email.com', '611223344', '2024-01-15', 'activo');

INSERT INTO Lectores (LectorID, NombreLector, Email, Telefono, FechaRegistro, Estado) 
VALUES (2, 'Carlos Martín López', 'carlos.martin@email.com', '622334455', '2024-02-20', 'activo');

INSERT INTO Lectores (LectorID, NombreLector, Email, Telefono, FechaRegistro, Estado) 
VALUES (3, 'Ana Rodríguez Silva', 'ana.rodriguez@email.com', '633445566', '2024-03-10', 'suspendido');

-- EJERCICIO 4.2: Insertar múltiples lectores en una sola sentencia
-- Inserta 4 lectores más usando una sola sentencia INSERT
INSERT INTO Lectores (LectorID, NombreLector, Email, Telefono, FechaRegistro, Estado) VALUES
(4, 'Luis Fernández García', 'luis.fernandez@email.com', '644556677', '2024-04-05', 'activo'),
(5, 'Carmen Jiménez Torres', 'carmen.jimenez@email.com', '655667788', '2024-05-12', 'inactivo'),
(6, 'David Sánchez Ruiz', 'david.sanchez@email.com', '666778899', '2024-06-18', 'activo'),
(7, 'Laura Moreno Vega', 'laura.moreno@email.com', '677889900', '2024-07-25', 'activo');

-- EJERCICIO 4.3: Insertar autores
-- Inserta varios autores en la base de datos
INSERT INTO Autores (AutorID, Autor, Nacionalidad, FechaNacimiento) VALUES
(1, 'Miguel de Cervantes', 'Española', '1547-09-29'),
(2, 'Gabriel García Márquez', 'Colombiana', '1927-03-06'),
(3, 'Isabel Allende', 'Chilena', '1942-08-02'),
(4, 'Federico García Lorca', 'Española', '1898-06-05'),
(5, 'Jorge Luis Borges', 'Argentina', '1899-08-24'),
(6, 'Octavio Paz', 'Mexicana', '1914-03-31'),
(7, 'Mario Vargas Llosa', 'Peruana', '1936-03-28'),
(8, 'Pablo Neruda', 'Chilena', '1904-07-12');

-- EJERCICIO 4.4: Insertar libros
-- Inserta varios libros en la base de datos
INSERT INTO Libros (LibroID, Libro, ISBN, AnoPublicacion, Ejemplares, Disponibles, Editorial, Precio) VALUES
(1, 'Don Quijote de la Mancha', '978-84-376-0494-7', 1605, 5, 5, 'Editorial Cervantes', 25.50),
(2, 'Cien años de soledad', '978-84-376-0495-4', 1967, 4, 4, 'Sudamericana', 22.90),
(3, 'La casa de los espíritus', '978-84-376-0496-1', 1982, 3, 3, 'Plaza & Janés', 22.90),
(4, 'Bodas de sangre', '978-84-376-0497-8', 1933, 2, 2, 'Losada', 18.75),
(5, 'Ficciones', '978-84-376-0498-5', 1944, 3, 3, 'Emecé', 18.75),
(6, 'El laberinto de la soledad', '978-84-376-0499-2', 1950, 2, 2, 'Fondo de Cultura Económica', 18.75),
(7, 'La ciudad y los perros', '978-84-376-0500-5', 1963, 2, 2, 'Seix Barral', 22.90),
(8, 'Veinte poemas de amor y una canción desesperada', '978-84-376-0501-2', 1924, 4, 4, 'Nascimento', 25.50);

-- EJERCICIO 4.5: Insertar relaciones libros-autores
-- Relaciona los libros con sus autores en la tabla intermedia
INSERT INTO Libros_Autores (FK_LibroID, FK_AutorID, Orden) VALUES
(1, 1, 1),  -- Cervantes - Don Quijote
(2, 2, 1),  -- García Márquez - Cien años de soledad
(3, 3, 1),  -- Isabel Allende - La casa de los espíritus
(4, 4, 1),  -- García Lorca - Bodas de sangre
(5, 5, 1),  -- Borges - Ficciones
(6, 6, 1),  -- Octavio Paz - El laberinto de la soledad
(7, 7, 1),  -- Vargas Llosa - La ciudad y los perros
(8, 8, 1);  -- Pablo Neruda - Veinte poemas de amor

-- EJERCICIO 4.6: Intentar insertar email inválido (debe fallar por trigger)
-- Intenta insertar un lector con email inválido - el trigger debe impedirlo
-- INSERT INTO Lectores (LectorID, NombreLector, Email, FechaRegistro) 
-- VALUES (10, 'Prueba Error', 'email-invalido', '2024-08-01');

-- EJERCICIO 4.7: Insertar préstamos válidos
-- Inserta algunos préstamos que funcionen correctamente
INSERT INTO Detalles_Prestamos (PrestamoID, FK_LectorID, FK_LibroID, FechaPrestamo, Estado) VALUES
(1, 1, 1, '2024-10-01', 'activo'),
(2, 2, 2, '2024-10-05', 'activo'),
(3, 3, 3, '2024-10-10', 'activo');

-- =============================================
-- 05. SECCIÓN DML - MODIFICACIÓN Y ACTUALIZACIÓN DE DATOS
-- =============================================

-- EJERCICIO 5.1: Actualizar datos de un lector específico
-- Actualiza el teléfono y email del lector con ID 1
UPDATE Lectores 
SET Telefono = '611223355', Email = 'maria.gonzalez.nuevo@email.com' 
WHERE LectorID = 1;

-- EJERCICIO 5.2: Actualizar múltiples registros con condición
-- Cambia el estado a 'suspendido' para todos los lectores registrados antes de marzo de 2024
UPDATE Lectores 
SET Estado = 'suspendido' 
WHERE FechaRegistro < '2024-03-01';

-- EJERCICIO 5.3: Aumentar stock de libros
-- Añade 2 ejemplares (tanto total como disponibles) a los libros con ID 1, 2 y 3
UPDATE Libros 
SET Ejemplares = Ejemplares + 2, Disponibles = Disponibles + 2 
WHERE LibroID IN (1, 2, 3);

-- EJERCICIO 5.4: Actualizar precios masivamente
-- Desactiva el modo seguro para permitir actualizaciones masivas
SET SQL_SAFE_UPDATES = 0;

-- Actualiza precios según el año de publicación
UPDATE Libros SET Precio = 28.00 WHERE AnoPublicacion < 1950;
UPDATE Libros SET Precio = 20.00 WHERE AnoPublicacion BETWEEN 1950 AND 1980;
UPDATE Libros SET Precio = 25.00 WHERE AnoPublicacion > 1980;

-- Reactiva el modo seguro
SET SQL_SAFE_UPDATES = 1;

-- EJERCICIO 5.5: Simular devolución de libros
-- Marca como devueltos algunos préstamos (esto activará el trigger de disponibilidad)
UPDATE Detalles_Prestamos 
SET Estado = 'devuelto', FechaDevolucion = '2024-10-15' 
WHERE PrestamoID = 1;

UPDATE Detalles_Prestamos 
SET Estado = 'devuelto', FechaDevolucion = '2024-10-20' 
WHERE PrestamoID = 2;

-- EJERCICIO 5.6: Crear préstamos vencidos con multas
-- Actualiza algunos préstamos para marcarlos como vencidos y añadir multas
UPDATE Detalles_Prestamos 
SET Estado = 'vencido', Multa = 5.00 
WHERE PrestamoID = 3;

-- EJERCICIO 5.7: Insertar nuevos préstamos
-- Añade más préstamos para probar el funcionamiento de los triggers
INSERT INTO Detalles_Prestamos (PrestamoID, FK_LectorID, FK_LibroID, FechaPrestamo, Estado) VALUES
(4, 4, 4, '2024-10-12', 'activo'),
(5, 5, 5, '2024-10-15', 'activo'),
(6, 6, 6, '2024-10-18', 'activo');

-- EJERCICIO 5.8: Intentar préstamo sin disponibilidad (debe fallar)
-- Primero agota la disponibilidad de un libro y luego intenta prestarlo
UPDATE Libros SET Disponibles = 0 WHERE LibroID = 7;
-- La siguiente inserción debe fallar por el trigger de validación
-- INSERT INTO Detalles_Prestamos (PrestamoID, FK_LectorID, FK_LibroID, FechaPrestamo, Estado) 
-- VALUES (10, 1, 7, '2024-10-21', 'activo');

-- EJERCICIO 5.9: Restaurar disponibilidad del libro anterior
UPDATE Libros SET Disponibles = 2 WHERE LibroID = 7;

-- EJERCICIO 5.10: Actualizar información de autores
-- Añade información adicional a algunos autores
UPDATE Autores 
SET Nacionalidad = 'Española (Alcalá de Henares)' 
WHERE AutorID = 1;

UPDATE Autores 
SET Nacionalidad = 'Colombiana (Aracataca)' 
WHERE AutorID = 2;

-- =============================================
-- 06. SECCIÓN DML - CREACIÓN DE VISTAS E ÍNDICES
-- =============================================

-- EJERCICIO 6.1: Crear vista de libros disponibles
-- Crea una vista que muestre información básica de libros con ejemplares disponibles
CREATE VIEW Vista_Libros_Disponibles AS
SELECT LibroID, Libro, Editorial, Ejemplares, Disponibles, Precio
FROM Libros 
WHERE Disponibles > 0;

-- EJERCICIO 6.1.1: Consultar la vista de libros disponibles
SELECT * FROM Vista_Libros_Disponibles;

-- EJERCICIO 6.2: Crear vista de préstamos activos
-- Crea una vista que muestre los préstamos que están actualmente activos
CREATE VIEW Vista_Prestamos_Activos AS
SELECT PrestamoID, FK_LectorID, FK_LibroID, FechaPrestamo, Estado
FROM Detalles_Prestamos 
WHERE Estado = 'activo';

-- EJERCICIO 6.2.1: Consultar la vista de préstamos activos
SELECT * FROM Vista_Prestamos_Activos;

-- EJERCICIO 6.3: Añadir más índices
-- Crea índices adicionales para mejorar el rendimiento
CREATE INDEX idx_prestamos_estado ON Detalles_Prestamos(Estado);
CREATE INDEX idx_autores_nacionalidad ON Autores(Nacionalidad);
CREATE INDEX idx_libros_precio ON Libros(Precio);

-- EJERCICIO 6.3.2: Eliminar un índice
-- Elimina el índice creado en la columna Precio de Libros
DROP INDEX idx_libros_precio ON Libros;

-- EJERCICIO 6.4: Crear vista compuesta
-- Crea una vista que combine información de múltiples tablas
CREATE VIEW Vista_Resumen_Biblioteca AS
SELECT 
    l.LibroID,
    l.Libro,
    l.Editorial,
    l.Precio,
    l.Ejemplares,
    l.Disponibles,
    CASE 
        WHEN l.Disponibles = 0 THEN 'No disponible'
        WHEN l.Disponibles <= 2 THEN 'Pocas unidades'
        ELSE 'Disponible'
    END AS Estado_Disponibilidad
FROM Libros l;

-- EJERCICIO 6.4.1: Consultar la vista resumen de biblioteca
SELECT * FROM Vista_Resumen_Biblioteca;

-- =============================================
-- 07. SECCIÓN DML - OPERACIONES DE BORRADO
-- =============================================

-- EJERCICIO 7.1: Borrar un préstamo específico
-- Elimina un préstamo que ya fue devuelto
DELETE FROM Detalles_Prestamos WHERE PrestamoID = 1 AND Estado = 'devuelto';

-- EJERCICIO 7.2: Borrar múltiples préstamos con condición
-- Elimina todos los préstamos devueltos sin multa
DELETE FROM Detalles_Prestamos 
WHERE Estado = 'devuelto' AND Multa = 0.00;

-- EJERCICIO 7.3: Intentar borrar autor con libros (probará las FK CASCADE)
-- Esto eliminará automáticamente las relaciones en Libros_Autores
DELETE FROM Autores WHERE AutorID = 8;  -- Pablo Neruda

-- EJERCICIO 7.4: Añadir nuevos datos para más pruebas
-- Inserta nuevos autores y libros para poder hacer más operaciones de borrado
INSERT INTO Autores (AutorID, Autor, Nacionalidad, FechaNacimiento) VALUES
(9, 'Julio Cortázar', 'Argentina', '1914-08-26'),
(10, 'García Lorca (copia)', 'Española', '1898-06-05');

INSERT INTO Libros (LibroID, Libro, ISBN, AnoPublicacion, Ejemplares, Disponibles, Editorial, Precio) VALUES
(9, 'Rayuela', '978-84-376-0503-6', 1963, 2, 2, 'Sudamericana', 22.90),
(10, 'Libro de prueba', '978-84-376-0504-3', 2024, 1, 1, 'Editorial Test', 15.99);

INSERT INTO Libros_Autores (FK_LibroID, FK_AutorID, Orden) VALUES
(9, 9, 1),   -- Cortázar - Rayuela
(10, 10, 1); -- García Lorca copia - Libro de prueba

-- EJERCICIO 7.5: Borrar lector (probará SET NULL en préstamos)
-- Esto pondrá NULL en LectorID de los préstamos asociados
DELETE FROM Lectores WHERE LectorID = 5;

-- EJERCICIO 7.6: Borrar libro (probará SET NULL en préstamos)
-- Esto pondrá NULL en LibroID de los préstamos asociados
DELETE FROM Libros WHERE LibroID = 10;

-- EJERCICIO 7.7: Limpiar datos de prueba adicionales
-- Elimina algunos registros que ya no necesitamos
DELETE FROM Libros_Autores WHERE FK_AutorID = 10;
DELETE FROM Autores WHERE AutorID = 10;

-- =============================================
-- 08. SECCIÓN DML - OPERACIONES AVANZADAS
-- =============================================

-- EJERCICIO 8.1: Actualización con cálculos
-- Calcula y actualiza el total de multas por lector en una nueva columna
ALTER TABLE Lectores ADD COLUMN Total_Multas DECIMAL(10,2) DEFAULT 0.00;

-- Actualiza las multas manualmente (sin SELECT, calculando una por una)
UPDATE Lectores SET Total_Multas = 0.00 WHERE LectorID = 1;
UPDATE Lectores SET Total_Multas = 0.00 WHERE LectorID = 2;
UPDATE Lectores SET Total_Multas = 5.00 WHERE LectorID = 3;  -- Tenía un préstamo vencido
UPDATE Lectores SET Total_Multas = 0.00 WHERE LectorID = 4;
UPDATE Lectores SET Total_Multas = 0.00 WHERE LectorID = 6;
UPDATE Lectores SET Total_Multas = 0.00 WHERE LectorID = 7;

-- EJERCICIO 8.2: Actualización masiva con CASE
-- Actualiza el estado de los lectores según sus multas
UPDATE Lectores 
SET Estado = CASE 
    WHEN Total_Multas > 10 THEN 'suspendido'
    WHEN Total_Multas > 0 THEN 'activo'
    ELSE 'activo'
END;

-- EJERCICIO 8.3: Insertar datos con valores calculados
-- Inserta nuevos préstamos con fechas calculadas
INSERT INTO Detalles_Prestamos (PrestamoID, FK_LectorID, FK_LibroID, FechaPrestamo, Estado) VALUES
(11, 1, 7, CURDATE(), 'activo'),
(12, 2, 8, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'activo');

-- EJERCICIO 8.4: Actualizar usando funciones de fecha
-- Marca como vencidos los préstamos de hace más de 15 días
UPDATE Detalles_Prestamos 
SET Estado = 'vencido', Multa = 7.50 
WHERE FechaPrestamo < DATE_SUB(CURDATE(), INTERVAL 15 DAY) 
AND Estado = 'activo';

-- =============================================
-- 09. SECCIÓN DDL - MODIFICACIONES FINALES
-- =============================================

-- EJERCICIO 9.1: Añadir columnas de auditoría
-- Añade columnas de timestamp a las tablas principales
ALTER TABLE Lectores ADD COLUMN Fecha_Ultima_Modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE Libros ADD COLUMN Fecha_Ultima_Modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- EJERCICIO 9.2: Crear trigger adicional de auditoría para borrados
-- Registra cuando se eliminan lectores
DELIMITER $$
CREATE TRIGGER tr_auditoria_lectores_delete
AFTER DELETE ON Lectores
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria_Operaciones (Tabla, Operacion, Descripcion)
    VALUES ('Lectores', 'DELETE', 
            CONCAT('Eliminado lector ID: ', OLD.LectorID, 
                   ' - Nombre: ', OLD.NombreLector,
                   ' - Estado: ', OLD.Estado));
END$$
DELIMITER ;

-- EJERCICIO 9.3: Modificar una vista existente
-- Elimina y recrea la vista con información adicional
DROP VIEW Vista_Libros_Disponibles;

CREATE VIEW Vista_Libros_Disponibles AS
SELECT LibroID, Libro, Editorial, Ejemplares, Disponibles, Precio,
       CASE 
           WHEN Disponibles = 0 THEN 'Agotado'
           WHEN Disponibles <= 2 THEN 'Últimos ejemplares'
           ELSE 'Disponible'
       END AS Estado
FROM Libros;

-- EJERCICIO 9.3.1: Consultar la vista modificada
SELECT * FROM Vista_Libros_Disponibles;


-- EJERCICIO 9.4: Crear índice compuesto
-- Crea un índice que combine múltiples columnas
CREATE INDEX idx_prestamos_completo ON Detalles_Prestamos(FK_LectorID, FK_LibroID, FechaPrestamo);

-- =============================================
-- 10. SECCIÓN FINAL - LIMPIEZA Y VERIFICACIÓN
-- =============================================

-- EJERCICIO 10.1: Probar operaciones finales
-- Inserta algunos datos finales para verificar que todo funciona
INSERT INTO Lectores (LectorID, NombreLector, Email, FechaRegistro) VALUES
(20, 'Usuario Final', 'final@test.com', CURDATE());

INSERT INTO Detalles_Prestamos (PrestamoID, FK_LectorID, FK_LibroID, FechaPrestamo, Estado) VALUES
(20, 20, 1, CURDATE(), 'activo');

-- EJERCICIO 10.2: Actualizar datos finales
UPDATE Detalles_Prestamos 
SET Estado = 'devuelto', FechaDevolucion = CURDATE() 
WHERE PrestamoID = 20;

-- EJERCICIO 10.3: Eliminar datos de prueba final (opcional)
-- DELETE FROM Detalles_Prestamos WHERE PrestamoID = 20;
-- DELETE FROM Lectores WHERE LectorID = 20;

-- =============================================
-- COMANDOS DE LIMPIEZA TOTAL (SOLO PARA PRUEBAS)
-- =============================================
-- IMPORTANTE: Descomenta solo si quieres limpiar completamente la base de datos

-- EJERCICIO 10.4: Eliminar triggers (opcional)
-- DROP TRIGGER IF EXISTS tr_validar_email_lectores;
-- DROP TRIGGER IF EXISTS tr_reducir_disponibilidad;
-- DROP TRIGGER IF EXISTS tr_aumentar_disponibilidad;
-- DROP TRIGGER IF EXISTS tr_validar_disponibilidad_prestamo;
-- DROP TRIGGER IF EXISTS tr_auditoria_lectores_update;
-- DROP TRIGGER IF EXISTS tr_auditoria_libros_insert;
-- DROP TRIGGER IF EXISTS tr_auditoria_lectores_delete;

-- EJERCICIO 10.5: Eliminar vistas (opcional)
-- DROP VIEW IF EXISTS Vista_Libros_Disponibles;
-- DROP VIEW IF EXISTS Vista_Prestamos_Activos;
-- DROP VIEW IF EXISTS Vista_Resumen_Biblioteca;

-- EJERCICIO 10.6: Eliminar tablas en orden correcto (opcional)
-- DROP TABLE IF EXISTS Auditoria_Operaciones;
-- DROP TABLE IF EXISTS Detalles_Prestamos;
-- DROP TABLE IF EXISTS Libros_Autores;
-- DROP TABLE IF EXISTS Lectores;
-- DROP TABLE IF EXISTS Libros;
-- DROP TABLE IF EXISTS Autores;

-- EJERCICIO 10.7: Eliminar base de datos completa (opcional)
-- DROP DATABASE IF EXISTS biblioteca_ejercicios;

/*
===============================================
RESUMEN DE EJERCICIOS COMPLETADOS:
===============================================

SECCIÓN DDL:
✓ Creación de base de datos y estructura inicial
✓ Corrección de errores intencionados en tablas
✓ Añadir y modificar claves primarias y foráneas
✓ Modificación de tipos de datos y restricciones
✓ Creación de índices simples y compuestos
✓ Creación de triggers de validación y auditoría
✓ Modificación de estructura de tablas existentes

SECCIÓN DML:
✓ Inserción de datos individuales y masivos
✓ Actualización de registros específicos y masivos
✓ Modificación con cálculos y funciones
✓ Creación y modificación de vistas
✓ Borrado de registros con pruebas de integridad referencial
✓ Operaciones de auditoría automáticas
✓ Manejo de errores y validaciones por triggers

CONCEPTOS CUBIERTOS:
- CREATE/ALTER/DROP DATABASE/TABLE/VIEW/TRIGGER/INDEX
- PRIMARY KEY, FOREIGN KEY, CHECK constraints
- ENUM, TIMESTAMP, AUTO_INCREMENT
- ON DELETE CASCADE/SET NULL
- INSERT, UPDATE, DELETE con múltiples variantes
- Triggers BEFORE/AFTER INSERT/UPDATE/DELETE
- Integridad referencial y validaciones
- Auditoría automática de operaciones
- Gestión de errores con SIGNAL
- Funciones de fecha y operadores CASE

NOTA: Este ejercicio está diseñado para practicar DDL y DML 
sin necesidad de usar sentencias SELECT para consultas.
*/