-- ##########################################################################
-- # ENUNCIADO DEL EJERCICIO (PARA ALUMNOS)    1:1 [(0,1)..(0,1)]           #
-- ##########################################################################

-- ---
-- # EJERCICIO DE TRANSFORMACIÓN MER/MERE a MR
-- # CASO: Relación 1:1 con Participación Parcial en ambos lados (0,1) - (0,1)
-- ---

-- ##########################################################################
-- # ENUNCIADO DEL EJERCICIO (PARA ALUMNOS)                                 #
-- ##########################################################################

-- Se nos pide diseñar una base de datos sencilla para la gestión académica,
-- centrándonos en la relación entre Alumnos y Asignaturas en un contexto particular.

-- ENTIDADES:
-- 1.  Alumnos: Cada alumno se identifica por un `idAlumno` único y tiene un `nombreAlumno`.
--     - Atributos: `idAlumno` (PK), `nombreAlumno`.
-- 2.  Asignaturas: Cada asignatura se identifica por un `idAsignatura` único y tiene un `tituloAsignatura`.
--     - Atributos: `idAsignatura` (PK), `tituloAsignatura`.

-- RELACIÓN "ES_ASIGNATURA_PREFERENTE":
-- Queremos modelar una relación 1:1 llamada "ES_ASIGNATURA_PREFERENTE".
-- Esta relación vincula a un ALUMNO con una ASIGNATURA que es su "asignatura preferente".

-- PARTICIPACIÓN Y RESTRICCIONES (¡Mucha atención a estos detalles!):

-- 1.  Participación del ALUMNO en "ES_ASIGNATURA_PREFERENTE": (0,1)
--     - Mínima (0): Un alumno **puede NO tener** una asignatura preferente. (Participación Parcial)
--     - Máxima (1): Un alumno **puede tener como máximo una** asignatura preferente.

-- 2.  Participación de la ASIGNATURA en "ES_ASIGNATURA_PREFERENTE": (0,1)
--     - Mínima (0): Una asignatura **puede NO ser** la preferente de ningún alumno. (Participación Parcial)
--     - Máxima (1): Una asignatura **puede ser la preferente de como máximo un** alumno.

-- OBJETIVO:
-- Transformar este modelo E-R al Modelo Relacional, creando las tablas SQL necesarias
-- y aplicando las restricciones que deriven de las cardinalidades y participaciones.

-- ##########################################################################
-- # COMIENZO DEL CÓDIGO SQL                                                #
-- ##########################################################################

-- 1. Preparación del entorno: Borrar, crear y seleccionar la base de datos.
-- Borra la base de datos si ya existe para empezar desde cero.
DROP DATABASE IF EXISTS `bd_asignatura_preferente`;

-- Crea la nueva base de datos.
CREATE DATABASE `bd_asignatura_preferente`;

-- Selecciona la base de datos para ejecutar las operaciones siguientes en ella.
USE `bd_asignatura_preferente`;

-- 2. Creación de las tablas resultantes del Modelo Relacional.

-- TABLA ALUMNOS
-- Representa la entidad 'Alumnos'.
CREATE TABLE Alumnos (
    idAlumno INT PRIMARY KEY,         -- Clave Primaria para identificar a cada alumno de forma única.
    nombreAlumno VARCHAR(100) NOT NULL -- Atributo adicional: el nombre del alumno (no puede ser nulo).
);

-- TABLA ASIGNATURAS
-- Representa la entidad 'Asignaturas'.
-- Para una relación 1:1 con participación parcial en ambos lados (0,1)-(0,1),
-- la clave foránea se puede colocar en CUALQUIERA de las dos tablas.
-- Aquí la colocaremos en la tabla 'Asignaturas', para que el título de la asignatura sea independiente de la relación.
CREATE TABLE Asignaturas (
    idAsignatura INT PRIMARY KEY,         -- Clave Primaria para identificar cada asignatura.
    tituloAsignatura VARCHAR(100) NOT NULL, -- Atributo adicional: el título de la asignatura (no puede ser nulo).
    idAlumnoFK INT UNIQUE,                -- Clave Foránea que referencia a Alumnos.
                                        -- UNIQUE: Para garantizar la cardinalidad 1:1 desde Alumno hacia Asignatura
                                        --         (una asignatura solo puede ser preferente para un único alumno,
                                        --          y un alumno solo puede tener una asignatura preferente).
                                        -- NULLABLE: Porque la participación del ALUMNO es PARCIAL (0,1).
                                        --         Un alumno puede NO tener una asignatura preferente,
                                        --         lo que significa que esta FK podría ser NULL para ciertas asignaturas
                                        --         si la asignatura no es preferente para nadie.
    -- Define la restricción de clave foránea.
    CONSTRAINT fk_alumno_preferente FOREIGN KEY (idAlumnoFK) REFERENCES Alumnos(idAlumno)
    -- ON DELETE SET NULL: Si un alumno es borrado, su id en 'Asignaturas' se establece a NULL.
    -- Esto mantiene la integridad referencial y permite que la asignatura exista sin un "propietario preferente".
    ON DELETE SET NULL
    -- ON UPDATE CASCADE: Si el idAlumno cambia en la tabla Alumnos, se actualiza automáticamente aquí.
    ON UPDATE CASCADE
);

-- COMENTARIOS ADICIONALES SOBRE LA TRANSFORMACIÓN DE 1:1 CON PARTICIPACIÓN (0,1)-(0,1):
-- 1.  Colocación de la FK: En este caso de 1:1 (0,1)-(0,1), la clave foránea (`idAlumnoFK`)
--     se puede colocar en cualquiera de las dos tablas (`Alumnos` o `Asignaturas`).
--     Hemos elegido `Asignaturas` por una decisión de diseño, pero igualmente podría ir en `Alumnos`.

-- 2.  Restricción UNIQUE para la FK: Es CRUCIAL que la FK (`idAlumnoFK`) en la tabla `Asignaturas`
--     tenga la restricción `UNIQUE`. Esto asegura la cardinalidad 1:1 en ambos sentidos:
--     - Un alumno solo puede aparecer una vez como `idAlumnoFK` en `Asignaturas` (su asignatura preferente es única).
--     - Una asignatura solo puede tener un `idAlumnoFK` (es preferente para un único alumno).

-- 3.  Permitir NULL en la FK: La FK (`idAlumnoFK`) es `NULLABLE` (no tiene `NOT NULL`).
--     Esto implementa la PARTICIPACIÓN PARCIAL (0,1) en ambos lados:
--     - Para Alumnos: Un `idAlumno` puede no aparecer nunca en `idAlumnoFK` en `Asignaturas` (alumno sin preferente).
--     - Para Asignaturas: Un `idAlumnoFK` puede ser `NULL` para una `Asignatura` (asignatura que no es preferente de nadie).

-- 3. Inserción de datos de prueba.

-- Insertamos algunos alumnos.
INSERT INTO Alumnos (idAlumno, nombreAlumno) VALUES
(1, 'Ana García'),
(2, 'Luis Pérez'),
(3, 'Marta Díaz'),
(4, 'Pedro Ruiz');

-- Insertamos algunas asignaturas.
-- Algunas serán preferentes, otras no.
INSERT INTO Asignaturas (idAsignatura, tituloAsignatura, idAlumnoFK) VALUES
(101, 'Base de Datos Avanzadas', 1),   -- Asignatura 101 es preferente de Ana
(102, 'Desarrollo Web Fullstack', 2),   -- Asignatura 102 es preferente de Luis
(103, 'Ciberseguridad Práctica', NULL), -- Asignatura 103 no es preferente de nadie (NULL es permitido)
(104, 'Inteligencia Artificial', NULL), -- Asignatura 104 no es preferente de nadie
(105, 'Robótica Colaborativa', 3);   -- Asignatura 105 es preferente de Marta

-- PRUEBAS DE RESTRICCIONES (DESCOMENTAR PARA VER LOS ERRORES):

-- Intento de que un alumno tenga DOS asignaturas preferentes (viola UNIQUE en idAlumnoFK):
-- INSERT INTO Asignaturas (idAsignatura, tituloAsignatura, idAlumnoFK) VALUES (106, 'Matemáticas Discretas', 1);
-- Error: Duplicate entry '1' for key 'asignaturas.idAlumnoFK'

-- Intento de que una asignatura sea preferente de un alumno que no existe (viola FOREIGN KEY):
-- INSERT INTO Asignaturas (idAsignatura, tituloAsignatura, idAlumnoFK) VALUES (107, 'Física Cuántica', 999);
-- Error: Cannot add or update a child row: a foreign key constraint fails

-- 4. Consultas para verificar los datos y la relación.

-- Ver todos los alumnos.
SELECT * FROM Alumnos;

-- Ver todas las asignaturas, incluyendo cuál es preferente y para quién (si aplica).
SELECT * FROM Asignaturas;

-- Ver los alumnos y sus asignaturas preferentes (JOIN con LEFT JOIN para incluir alumnos sin asignatura preferente).
SELECT
    A.idAlumno,
    A.nombreAlumno,
    ASIG.tituloAsignatura
FROM
    Alumnos A
LEFT JOIN
    Asignaturas ASIG ON A.idAlumno = ASIG.idAlumnoFK;

-- Ver solo las asignaturas que son preferentes para alguien y qué alumno la tiene.
SELECT
    A.nombreAlumno,
    ASIG.tituloAsignatura
FROM
    Alumnos A
JOIN
    Asignaturas ASIG ON A.idAlumno = ASIG.idAlumnoFK
WHERE
    ASIG.idAlumnoFK IS NOT NULL;

-- ##########################################################################
-- # FIN DEL CÓDIGO SQL                                                     #
-- ##########################################################################