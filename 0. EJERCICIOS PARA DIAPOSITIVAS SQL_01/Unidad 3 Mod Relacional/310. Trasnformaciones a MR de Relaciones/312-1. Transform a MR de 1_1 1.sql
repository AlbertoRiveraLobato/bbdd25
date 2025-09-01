-- ##########################################################################
-- # ENUNCIADO DEL EJERCICIO (PARA ALUMNOS)    1:1 [(0,1)..(1,1)]           #
-- ##########################################################################

-- ---
-- # EJERCICIO DE TRANSFORMACIÓN MER/MERE a MR
-- # CASO: Relación 1:1 con Participación Parcial en un lado (0,1) - (1,1)
-- ---

-- Se desea modelar una base de datos sencilla para la gestión académica.
-- Consideraremos dos entidades principales: Alumnos y Asignaturas.

-- ENTIDADES:
-- 1. Alumnos: Cada alumno tiene un identificador único (PK) y un nombre.
--    - Atributos: idAlumno (PK), nombreAlumno.
-- 2. Asignaturas: Cada asignatura tiene un identificador único (PK) y un título.
--    - Atributos: idAsignatura (PK), tituloAsignatura.

-- RELACIÓN "ES_DE_PROYECTO_FINAL":
-- La relación a modelar es "ES_DE_PROYECTO_FINAL" entre Alumnos y Asignaturas.
-- Esta relación indica que una ASIGNATURA ES_DE_PROYECTO_FINAL para un ALUMNO.
-- Se trata de una relación de cardinalidad 1:1.

-- PARTICIPACIÓN Y RESTRICCIONES (¡ATENCIÓN A ESTO!):
-- - Participación del ALUMNO en "ES_DE_PROYECTO_FINAL": (0,1)
--   Esto significa que:
--   a) Un alumno PUEDE tener 0 (ninguna) asignatura de proyecto final. (Participación Parcial)
--   b) Un alumno PUEDE tener como máximo 1 asignatura de proyecto final. (Cardinalidad Máxima 1)

-- - Participación de la ASIGNATURA en "ES_DE_PROYECTO_FINAL": (1,1)
--   Esto significa que:
--   a) Una asignatura DEBE estar asociada a AL MENOS 1 alumno como proyecto final. (Participación Total)
--   b) Una asignatura DEBE estar asociada a COMO MÁXIMO 1 alumno como proyecto final. (Cardinalidad Máxima 1)
--   ¡IMPORTANTE!: La participación total de la Asignatura (1,1) en una relación 1:1 implica una restricción muy específica
--   en el Modelo Relacional para evitar nulos y asegurar que cada asignatura tenga un alumno asociado.

-- OBJETIVO:
-- Transformar este modelo E-R al Modelo Relacional, creando las tablas SQL necesarias
-- y aplicando las restricciones que deriven de las cardinalidades y participaciones.

-- ##########################################################################
-- # COMIENZO DEL CÓDIGO SQL                                              #
-- ##########################################################################

-- 1. Sentencias para borrar la base de datos si ya existe, crearla y usarla.
-- BORRADO DE LA BASE DE DATOS SI EXISTE PARA UN COMIENZO LIMPIO
DROP DATABASE IF EXISTS `bd_proyecto_final`;

-- CREACIÓN DE LA NUEVA BASE DE DATOS
CREATE DATABASE `bd_proyecto_final`;

-- SELECCIÓN DE LA BASE DE DATOS PARA TRABAJAR EN ELLA
USE `bd_proyecto_final`;

-- 2. Creación de las tablas resultantes del Modelo Relacional.

-- TABLA ALUMNOS
-- Se crea la tabla para la entidad 'Alumnos'.
-- idAlumno es la clave primaria.
-- nombreAlumno es el único atributo adicional.
CREATE TABLE Alumnos (
    idAlumno INT PRIMARY KEY, -- Clave Primaria de la entidad Alumnos
    nombreAlumno VARCHAR(100) -- Atributo adicional para el alumno
);

-- TABLA ASIGNATURAS
-- Se crea la tabla para la entidad 'Asignaturas'.
-- idAsignatura es la clave primaria.
-- tituloAsignatura es el único atributo adicional.
-- ¡ATENCIÓN!: Esta tabla también contendrá la clave foránea para la relación 1:1.
-- Según la regla de transformación de relaciones 1:1, la FK se coloca en una de las tablas,
-- preferentemente en la entidad con participación parcial si solo una la tiene.
-- Sin embargo, aquí la ASIGNATURA tiene participación TOTAL (1,1) y el ALUMNO (0,1).
-- La participación total de ASIGNATURA (1,1) en la relación 1:1 es crucial.
-- Implica que CADA fila en 'Asignaturas' DEBE estar relacionada con una fila en 'Alumnos'.
-- Por lo tanto, la clave foránea 'idAlumnoFK' NO PUEDE SER NULA en 'Asignaturas'.
-- Además, para asegurar la cardinalidad 1:1 (una asignatura solo es de proyecto final para UN alumno),
-- la clave foránea 'idAlumnoFK' debe ser ÚNICA en la tabla 'Asignaturas'.
CREATE TABLE Asignaturas (
    idAsignatura INT PRIMARY KEY, -- Clave Primaria de la entidad Asignaturas
    tituloAsignatura VARCHAR(100) NOT NULL, -- Atributo adicional para la asignatura
    idAlumnoFK INT NOT NULL UNIQUE, -- Clave Foránea que referencia a Alumnos.
                                  -- NOT NULL: Porque la participación de Asignatura es TOTAL (1,1).
                                  -- UNIQUE: Para garantizar la cardinalidad 1:1 desde Asignatura hacia Alumno
                                  --         (una asignatura solo puede ser proyecto de un único alumno).
    -- Definición de la clave foránea.
    CONSTRAINT fk_alumno_proyecto FOREIGN KEY (idAlumnoFK) REFERENCES Alumnos(idAlumno)
    ON DELETE NO ACTION -- (por defecto, no se borra el alumno si tiene una asignatura asignada como proyecto)
    ON UPDATE CASCADE -- (opcional, si el idAlumno cambia, se actualiza automáticamente aquí)
);

-- COMENTARIOS ADICIONALES SOBRE LA TRANSFORMACIÓN DE 1:1 CON PARTICIPACIÓN (0,1)-(1,1):
-- 1. Colocación de la FK: La clave foránea (idAlumnoFK) se coloca en la tabla 'Asignaturas'.
--    Esto se hace porque la entidad 'Asignaturas' tiene participación TOTAL (1,1)
--    y 'Alumnos' tiene participación PARCIAL (0,1). Al poner la FK en la entidad con
--    participación total (Asignaturas), nos aseguramos de que cada asignatura
--    tenga un alumno asociado para su proyecto final.

-- 2. Restricción NOT NULL: La FK 'idAlumnoFK' en 'Asignaturas' se declara como NOT NULL.
--    Esto impone la restricción de PARTICIPACIÓN TOTAL (1,1) de 'Asignaturas':
--    Cada asignatura DEBE tener un alumno asignado como proyecto final.

-- 3. Restricción UNIQUE: La FK 'idAlumnoFK' en 'Asignaturas' se declara como UNIQUE.
--    Esto impone la restricción de CARDINALIDAD MÁXIMA 1 del lado de 'Alumnos' (1,1):
--    Un alumno solo puede ser proyecto final para UNA ÚNICA asignatura.
--    Si esta restricción no existiera, un alumno podría aparecer en 'idAlumnoFK' en varias filas de 'Asignaturas',
--    rompiendo la cardinalidad 1:1 desde la perspectiva del alumno.

-- 3. Inserción de datos de prueba.

-- Inserción de alumnos (algunos con proyecto, otros no).
INSERT INTO Alumnos (idAlumno, nombreAlumno) VALUES
(1, 'Ana García'),
(2, 'Luis Pérez'),
(3, 'Marta Díaz'),
(4, 'Pedro Ruiz'),
(5, 'Sofía Castro');

-- Inserción de asignaturas.
-- NOTA: Todas las asignaturas deben tener un 'idAlumnoFK' porque su participación es total (1,1).
-- Y ese 'idAlumnoFK' debe ser único en la tabla Asignaturas (para la relación 1:1).
INSERT INTO Asignaturas (idAsignatura, tituloAsignatura, idAlumnoFK) VALUES
(101, 'Base de Datos Avanzadas', 1), -- Asignatura 101 es proyecto final de Ana
(102, 'Desarrollo Web Fullstack', 2), -- Asignatura 102 es proyecto final de Luis
(103, 'Ciberseguridad Práctica', 3); -- Asignatura 103 es proyecto final de Marta

-- PRUEBA DE RESTRICCIONES (DESCOMENTAR PARA VER LOS ERRORES):
-- Esto fallaría: INTENTO DE INSERTAR UNA ASIGNATURA SIN ALUMNO ASOCIADO (viola NOT NULL en idAlumnoFK)
-- INSERT INTO Asignaturas (idAsignatura, tituloAsignatura, idAlumnoFK) VALUES (104, 'Inteligencia Artificial', NULL);

-- Esto fallaría: INTENTO DE ASIGNAR LA MISMA ASIGNATURA A OTRO ALUMNO (viola UNIQUE en idAlumnoFK, si fuese un ID de Asignatura)
-- ¡Ojo! En este caso es el idAlumnoFK el que debe ser único para la Asignatura,
-- lo que significa que un ALUMNO solo puede tener UNA asignatura como proyecto final.
-- Esto fallaría: INTENTO DE ASIGNAR OTRA ASIGNATURA A UN ALUMNO QUE YA TIENE PROYECTO (viola UNIQUE en idAlumnoFK)
-- INSERT INTO Asignaturas (idAsignatura, tituloAsignatura, idAlumnoFK) VALUES (104, 'Robótica Colaborativa', 1);

-- 4. Consultas para verificar los datos.

-- Ver todos los alumnos
SELECT * FROM Alumnos;

-- Ver todas las asignaturas (y qué alumno la tiene como proyecto final)
SELECT * FROM Asignaturas;

-- Ver qué alumno tiene qué asignatura como proyecto final (unión de tablas)
SELECT
    A.nombreAlumno,
    ASIG.tituloAsignatura
FROM
    Alumnos A
JOIN
    Asignaturas ASIG ON A.idAlumno = ASIG.idAlumnoFK;

-- ##########################################################################
-- # FIN DEL CÓDIGO SQL                                                   #
-- ##########################################################################