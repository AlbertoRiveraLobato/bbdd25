-- ---
-- # EJERCICIO DE TRANSFORMACIÓN MER/MERE a MR
-- # CASO: Relación Reflexiva 1:1 (con participaciones parciales en ambos roles)
-- ---

-- ##########################################################################
-- # ENUNCIADO DEL EJERCICIO (PARA ALUMNOS)                                 #
-- ##########################################################################

-- Vamos a diseñar una base de datos para la gestión de alumnos,
-- centrándonos en una relación especial de tutoría o representación entre ellos.

-- ENTIDAD PRINCIPAL:
-- 1.  Alumnos: Cada alumno se identifica por un `idAlumno` único y tiene un `nombreAlumno`.
--     - Atributos: `idAlumno` (PK), `nombreAlumno`.

-- RELACIÓN REFLEXIVA "TIENE_REPRESENTANTE":
-- Queremos modelar una relación reflexiva 1:1 llamada "TIENE_REPRESENTANTE".
-- Esta relación indica que un ALUMNO puede tener a OTRO ALUMNO como su representante único,
-- y, a su vez, un ALUMNO solo puede representar a UN ÚNICO otro alumno.
-- Pensemos en un escenario donde cada alumno tiene un "mentor" o "tutor de grupo" individual,
-- y cada mentor solo puede llevar a un único alumno.

-- PARTICIPACIÓN Y RESTRICCIONES (¡Mucha atención a estos detalles!):

-- - Participación del lado "representado" (el alumno que es representado): (0,1)
--   - Mínima (0): Un alumno **puede no tener** un representante asignado. (Participación Parcial)
--   - Máxima (1): Un alumno **puede tener como máximo un** único representante.

-- - Participación del lado "representante" (el alumno que actúa como representante): (0,1)
--   - Mínima (0): Un alumno **puede no ser representante de ningún otro alumno**. (Participación Parcial)
--   - Máxima (1): Un alumno **puede ser representante de como máximo un** único alumno.

-- OBJETIVO:
-- Transformar este modelo E-R (reflexivo 1:1) al Modelo Relacional,
-- creando las tablas SQL necesarias y aplicando las restricciones que deriven
-- de las cardinalidades y participaciones.

-- ##########################################################################
-- # COMIENZO DEL CÓDIGO SQL                                                #
-- ##########################################################################

-- 1. Preparación del entorno: Borrar, crear y seleccionar la base de datos.
-- Borra la base de datos si ya existe para empezar desde cero.
DROP DATABASE IF EXISTS `bd_alumnos_representantes`;

-- Crea la nueva base de datos.
CREATE DATABASE `bd_alumnos_representantes`;

-- Selecciona la base de datos para ejecutar las operaciones siguientes en ella.
USE `bd_alumnos_representantes`;

-- 2. Creación de las tablas resultantes del Modelo Relacional.

-- TABLA ALUMNOS
-- Representa la entidad 'Alumnos' y, en este caso de relación reflexiva 1:1,
-- también contendrá la clave foránea para modelar la relación.
CREATE TABLE Alumnos (
    idAlumno INT PRIMARY KEY,         -- Clave Primaria para identificar a cada alumno de forma única.
    nombreAlumno VARCHAR(100) NOT NULL, -- Atributo adicional: el nombre del alumno (no puede ser nulo).
    idRepresentanteFK INT UNIQUE,     -- Clave Foránea reflexiva que apunta a otro idAlumno.
                                    -- UNIQUE: Es CRUCIAL. Garantiza que un representante (idAlumno)
                                    --         solo puede aparecer UNA VEZ en esta columna. Esto asegura
                                    --         la cardinalidad 1:1 del lado del representante (0,1):
                                    --         un representante solo representa a un único alumno.
                                    -- NULLABLE: Permite que un alumno NO tenga un representante (`idRepresentanteFK` es NULL)
                                    --         o que un alumno NO sea representante de nadie (su `idAlumno` no aparece
                                    --         en esta columna `idRepresentanteFK` de ninguna otra fila).
                                    --         Esto implementa la PARTICIPACIÓN PARCIAL (0) en ambos lados.

    -- Definición de la clave foránea reflexiva.
    -- Apunta a la misma tabla 'Alumnos', en la columna 'idAlumno'.
    CONSTRAINT fk_representante_alumno FOREIGN KEY (idRepresentanteFK) REFERENCES Alumnos(idAlumno)
    -- ON DELETE SET NULL: Si el representante (el alumno al que apunta idRepresentanteFK) es borrado,
    -- el idRepresentanteFK del alumno representado se pone a NULL. Esto mantiene la integridad.
    ON DELETE SET NULL
    -- ON UPDATE CASCADE: Si el id del representante cambia, se actualiza automáticamente.
    ON UPDATE CASCADE
);

-- COMENTARIOS ADICIONALES SOBRE LA TRANSFORMACIÓN DE RELACIONES REFLEXIVAS 1:1 (0,1)-(0,1):
-- 1.  No se crea una tabla nueva: Para relaciones 1:1 (reflexivas o binarias), la transformación
--     ideal es añadir una clave foránea en una de las entidades. En el caso reflexivo,
--     esta FK apunta a la MISMA tabla.

-- 2.  Elección de la entidad para la FK: Con participación (0,1)-(0,1) en ambos lados (parcial-parcial),
--     la clave foránea se puede añadir a cualquiera de los dos lados de la relación.
--     Aquí, se ha elegido añadir `idRepresentanteFK` a la entidad `Alumnos` para indicar quién es su representante.

-- 3.  Restricción UNIQUE para la FK: ¡Fundamental! La FK `idRepresentanteFK` debe ser `UNIQUE`.
--     - Si un alumno es representante, su `idAlumno` aparecerá en esta columna `idRepresentanteFK`.
--     - Al ser `UNIQUE`, ese `idAlumno` solo puede aparecer una vez, asegurando que un representante
--       solo tiene UN representado.

-- 4.  Permitir NULL en la FK: La FK `idRepresentanteFK` NO debe ser `NOT NULL`.
--     Esto implementa la PARTICIPACIÓN PARCIAL (0) en ambos lados:
--     - Un alumno puede tener `idRepresentanteFK` como `NULL` (no tiene representante).
--     - Un alumno cuyo `idAlumno` NO aparece en la columna `idRepresentanteFK` de ninguna otra fila
--       significa que no es representante de nadie.

-- 5.  Evitar ciclos (precaución): En relaciones reflexivas, es posible crear ciclos (ej., A representa a B, B representa a A).
--     El diseño de la base de datos permite esto, pero la lógica de la aplicación debe manejar si estos ciclos son válidos.
--     También es posible que un alumno se represente a sí mismo (idRepresentanteFK = idAlumno), lo cual también debe ser
--     manejado por la lógica de negocio si no es permitido.

-- 3. Inserción de datos de prueba.

-- Insertamos algunos alumnos.
INSERT INTO Alumnos (idAlumno, nombreAlumno, idRepresentanteFK) VALUES
(1, 'Ana García', NULL),    -- Ana no tiene representante (es NULL)
(2, 'Luis Pérez', 1),     -- Luis tiene a Ana (1) como representante
(3, 'Marta Díaz', NULL),    -- Marta no tiene representante
(4, 'Pedro Ruiz', 3),     -- Pedro tiene a Marta (3) como representante
(5, 'Sofía Castro', NULL),  -- Sofía no tiene representante
(6, 'Javier López', 5);   -- Javier tiene a Sofía (5) como representante

-- PRUEBAS DE RESTRICCIONES (DESCOMENTAR PARA VER LOS ERRORES):

-- Esto fallaría: INTENTO DE QUE UN ALUMNO TENGA DOS REPRESENTANTES (viola PRIMARY KEY de idAlumno)
-- INSERT INTO Alumnos (idAlumno, nombreAlumno, idRepresentanteFK) VALUES (2, 'Luis Pérez (duplicado)', 4);

-- Esto fallaría: INTENTO DE ASIGNAR A UN ALUMNO UN REPRESENTANTE QUE NO EXISTE (viola FOREIGN KEY)
-- INSERT INTO Alumnos (idAlumno, nombreAlumno, idRepresentanteFK) VALUES (7, 'Carlos Blanco', 999);

-- Esto fallaría: INTENTO DE QUE UN REPRESENTANTE TENGA DOS REPRESENTADOS (viola UNIQUE en idRepresentanteFK)
-- INSERT INTO Alumnos (idAlumno, nombreAlumno, idRepresentanteFK) VALUES (7, 'Carlos Blanco', 1);
-- Error: Duplicate entry '1' for key 'alumnos.idRepresentanteFK'
-- (Esto significa que el id 1 (Ana) ya está en idRepresentanteFK como representante de Luis (2),
-- y no puede ser también representante de Carlos (7)).

-- 4. Consultas para verificar los datos y la relación reflexiva.

-- Ver todos los alumnos y su representante (si lo tienen).
SELECT * FROM Alumnos;

-- Mostrar la relación "Quién es representante de quién", incluyendo nombres.
-- Usamos LEFT JOIN para ver también a los alumnos que no tienen representante.
SELECT
    A.nombreAlumno AS Alumno_Representado,
    R.nombreAlumno AS Alumno_Representante
FROM
    Alumnos A
LEFT JOIN
    Alumnos R ON A.idRepresentanteFK = R.idAlumno;

-- Mostrar solo los alumnos que tienen un representante.
SELECT
    A.nombreAlumno AS Alumno_Representado,
    R.nombreAlumno AS Alumno_Representante
FROM
    Alumnos A
JOIN
    Alumnos R ON A.idRepresentanteFK = R.idAlumno
WHERE
    A.idRepresentanteFK IS NOT NULL;

-- Mostrar qué alumnos actúan como representantes (aquellos cuyo id aparece en idRepresentanteFK de otra fila).
SELECT
    DISTINCT R.nombreAlumno AS Alumno_Que_Es_Representante
FROM
    Alumnos A
JOIN
    Alumnos R ON A.idRepresentanteFK = R.idAlumno;

-- ##########################################################################
-- # FIN DEL CÓDIGO SQL                                                     #
-- ##########################################################################