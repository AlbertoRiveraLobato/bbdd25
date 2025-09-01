-- ---
-- # EJERCICIO DE TRANSFORMACIÓN MER/MERE a MR
-- # CASO: Relación Reflexiva 1:1 con Participación Total
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

-- - Participación del lado "representado" (el alumno que es representado): (1,1)
--   - Mínima (1): Un alumno **DEBE tener** UN representante asignado. (Participación Total)
--   - Máxima (1): Un alumno **puede tener como máximo un** único representante.

-- - Participación del lado "representante" (el alumno que actúa como representante): (0,1)
--   - Mínima (0): Un alumno **puede no ser representante de ningún otro alumno**. (Participación Parcial)
--   - Máxima (1): Un alumno **puede ser representante de como máximo un** único alumno.

-- OBJETIVO:
-- Transformar este modelo E-R (reflexivo 1:1 con participación total por un lado) al Modelo Relacional,
-- creando las tablas SQL necesarias y aplicando las restricciones que deriven
-- de las cardinalidades y participaciones.

-- ##########################################################################
-- # COMIENZO DEL CÓDIGO SQL                                                #
-- ##########################################################################

-- 1. Preparación del entorno: Borrar, crear y seleccionar la base de datos.
DROP DATABASE IF EXISTS `bd_alumnos_representantes_total`;
CREATE DATABASE `bd_alumnos_representantes_total`;
USE `bd_alumnos_representantes_total`;

-- 2. Creación de la tabla Alumnos con la FK reflexiva y NOT NULL.

-- TABLA ALUMNOS
-- Representa la entidad 'Alumnos' y contendrá la clave foránea reflexiva.
CREATE TABLE Alumnos (
    idAlumno INT PRIMARY KEY,         -- Clave Primaria para identificar a cada alumno de forma única.
    nombreAlumno VARCHAR(100) NOT NULL, -- Atributo adicional: el nombre del alumno (no puede ser nulo).
    idRepresentanteFK INT UNIQUE NOT NULL, -- Clave Foránea reflexiva que apunta a otro idAlumno.
                                         -- UNIQUE: Es CRUCIAL. Garantiza la cardinalidad 1:1 del lado del representante (0,1),
                                         --         asegurando que un representante solo representa a un único alumno.
                                         -- NOT NULL: ¡ATENCIÓN! Esto implementa la PARTICIPACIÓN TOTAL (1,1)
                                         --         del lado "representado": cada alumno DEBE tener un representante.
                                         --         Si un alumno tiene participación total, su FK NO PUEDE ser NULL.

    -- Definición de la clave foránea reflexiva.
    CONSTRAINT fk_representante_alumno FOREIGN KEY (idRepresentanteFK) REFERENCES Alumnos(idAlumno)
    -- ON DELETE RESTRICT: Si el representante (el alumno al que apunta idRepresentanteFK) es borrado,
    -- NO se permitirá el borrado si hay alumnos que lo tienen como representante. Esto es común con NOT NULL.
    ON DELETE RESTRICT
    -- ON UPDATE CASCADE: Si el id del representante cambia, se actualiza automáticamente.
    ON UPDATE CASCADE
);

-- COMENTARIOS ADICIONALES SOBRE LA TRANSFORMACIÓN DE RELACIONES REFLEXIVAS 1:1 CON PARTICIPACIÓN TOTAL (1,1) POR UN LADO:
-- 1.  No se crea una tabla nueva: Como en las relaciones 1:1, se añade una FK en una de las tablas.
--     Aquí, la FK `idRepresentanteFK` se añade a la tabla `Alumnos` misma.

-- 2.  Elección del lado para la FK y la nulabilidad:
--     - La entidad 'Alumno' en su rol de "representado" tiene participación TOTAL (1,1). Esto significa que
--       CADA FILA en la tabla `Alumnos` (como representado) DEBE tener un valor válido en la columna `idRepresentanteFK`.
--       Por lo tanto, `idRepresentanteFK` debe ser **NOT NULL**.
--     - La entidad 'Alumno' en su rol de "representante" tiene participación PARCIAL (0,1).
--       La restricción `UNIQUE` en `idRepresentanteFK` asegura que un `idAlumno` solo puede aparecer
--       una vez como representante. No tener un `NOT NULL` en este caso sería ideal para el lado (0),
--       pero la necesidad del lado (1,1) (representado) domina aquí.
--       Esto puede generar una pequeña "incomodidad" si modelamos que algunos alumnos NO son representados,
--       pues todos deben tener un valor en `idRepresentanteFK`.
--       (Para manejar esto en modelos más complejos, a veces se usa un registro "dummy" para "sin representante" o
--       se considera una relación binaria a una entidad "Representante" separada que puede o no ser Alumno.)

-- 3.  Restricción UNIQUE para la FK: ¡Fundamental! La FK `idRepresentanteFK` debe ser `UNIQUE`.
--     Esto es lo que asegura la cardinalidad 1:1 desde el punto de vista del representante:
--     un representante solo puede aparecer una vez en esta columna, por lo que solo representa a UN alumno.

-- 4.  Restricción de `ON DELETE`: `RESTRICT` es una opción adecuada junto con `NOT NULL`.
--     Significa que no puedes borrar un alumno si otro alumno lo tiene como su `idRepresentanteFK`.
--     Esto garantiza que nunca habrá un `idRepresentanteFK` "colgando" que apunte a un alumno no existente.

-- 3. Inserción de datos de prueba.

-- NOTA IMPORTANTE PARA LA INSERCIÓN:
-- Debido a que 'idRepresentanteFK' es NOT NULL, no podemos insertar alumnos sin representante al principio.
-- Esto significa que debemos insertar primero a los alumnos que serán representantes,
-- y luego a los alumnos representados por ellos.
-- ¡Y recuerda que no puede haber ciclos ni auto-referencias al principio sin un diseño especial!
-- Si un alumno representa a otro, el representado no puede aparecer en la columna idRepresentanteFK del representante.
-- La forma más sencilla para el 1:1 (1,1) de un lado es pensar en una cadena o árbol.

INSERT INTO Alumnos (idAlumno, nombreAlumno, idRepresentanteFK) VALUES
(1, 'Ana García', 1); -- Ana se representa a sí misma (o es el "raíz" inicial, no hay otra forma al ser NOT NULL).
                     -- Esto sería un caso especial a discutir en clase si es válido o no.
                     -- Si no es válido, se necesitaría un registro "dummy" o un diseño alternativo.

-- Para este ejemplo, haremos que el representante sea un alumno con un ID menor, simulando una jerarquía.
-- Esto evita ciclos al principio y satisface el NOT NULL.

-- Insertamos el primer alumno que será "representante base" (o se representa a sí mismo si se permite).
-- Para cumplir estrictamente el NOT NULL (1,1) con una única tabla, necesitamos un punto de partida.
-- La única forma de iniciar la cadena es que un alumno se represente a sí mismo o que tengamos una estructura
-- donde los representantes ya existan antes de que alguien los referencie.
-- Aquí, para simplificar y mostrar el NOT NULL:

-- 1. Insertamos un alumno que será representante.
-- Para que cumpla NOT NULL y UNIQUE, al menos un alumno debe ser el 'representante' de sí mismo temporalmente
-- o de un 'dummy'. O bien, si es una jerarquía estricta, un 'root' que no tiene representante (lo que violaría el NOT NULL).
-- La opción más realista para (1,1) en una tabla reflexiva es que *cada alumno debe tener un representante*.

-- ¡Corregido el enfoque para la participación (1,1) - (0,1)!
-- Si el alumno representado (la fila actual) tiene participación total (1,1), SIEMPRE DEBE TENER UN REPRESENTANTE.
-- El representante (el que aparece en idRepresentanteFK) tiene participación parcial (0,1),
-- es decir, no todos los alumnos son representantes.

-- Escenario para (1,1)-(0,1) en reflexiva 1:1:
-- `idAlumno` (PK) | `nombreAlumno` | `idRepresentanteFK` (UNIQUE, NOT NULL)
-- - Cada alumno (fila) debe tener un `idRepresentanteFK`
-- - Cada `idRepresentanteFK` solo puede aparecer una vez (es decir, un representante solo representa a 1)

-- Esto implica una estructura de "cadena" o "árbol" donde cada nodo (alumno) tiene un padre (representante) único,
-- excepto la raíz. PERO la raíz también DEBE tener un representante debido al NOT NULL.
-- La forma más sencilla de hacer esto y mostrar el NOT NULL en una única tabla es con un "auto-representante" o un ciclo.
-- O bien, forzando un diseño donde el "representante" es de otro tipo (ej. un "Coordinador" externo),
-- o se permite una referencia a sí mismo para el primero.

-- Para nuestro ejemplo, asumiremos una cadena, y el primer alumno se representará a sí mismo,
-- o bien, existe una 'raíz' que es representada por 'nadie' (pero esto viola NOT NULL).
-- La manera de hacerlo con NOT NULL es que *todos* tienen un representante, incluso el "último" o "primero" de la cadena.
-- Esto conduce a un ciclo inevitable en una tabla de un solo nodo.

-- Opción 1: Un alumno que es representante de sí mismo (para ser la "raíz" y cumplir NOT NULL)
INSERT INTO Alumnos (idAlumno, nombreAlumno, idRepresentanteFK) VALUES
(1, 'Ana García', 1); -- Ana es su propia representante (punto de inicio para cumplir NOT NULL y UNIQUE)

-- Ahora, otros alumnos deben tener un representante (y ese representante solo puede representar a uno).
INSERT INTO Alumnos (idAlumno, nombreAlumno, idRepresentanteFK) VALUES
(2, 'Luis Pérez', 1),     -- Luis tiene a Ana (1) como representante
(3, 'Marta Díaz', 2),     -- Marta tiene a Luis (2) como representante
(4, 'Pedro Ruiz', 3);     -- Pedro tiene a Marta (3) como representante

-- En este esquema, Ana (id=1) es representante de Luis (id=2)
-- Luis (id=2) es representante de Marta (id=3)
-- Marta (id=3) es representante de Pedro (id=4)
-- Y Ana es "representante" de sí misma para cumplir la condición NOT NULL en el primer registro.
-- Esto simula una cadena donde cada alumno tiene un representante único, y ese representante solo representa a uno.

-- PRUEBAS DE RESTRICCIONES (DESCOMENTAR PARA VER LOS ERRORES):

-- Esto fallaría: INTENTO DE INSERTAR UN ALUMNO SIN REPRESENTANTE (viola NOT NULL en idRepresentanteFK)
-- INSERT INTO Alumnos (idAlumno, nombreAlumno, idRepresentanteFK) VALUES (5, 'Sofía Castro', NULL);

-- Esto fallaría: INTENTO DE QUE UN REPRESENTANTE TENGA DOS REPRESENTADOS (viola UNIQUE en idRepresentanteFK)
-- INSERT INTO Alumnos (idAlumno, nombreAlumno, idRepresentanteFK) VALUES (5, 'Sofía Castro', 1);
-- Error: Duplicate entry '1' for key 'alumnos.idRepresentanteFK'
-- (Esto porque id=1 (Ana) ya es representante de id=2 (Luis). No puede serlo también de Sofía).

-- Esto fallaría: INTENTO DE ASIGNAR UN REPRESENTANTE QUE NO EXISTE (viola FOREIGN KEY)
-- INSERT INTO Alumnos (idAlumno, nombreAlumno, idRepresentanteFK) VALUES (5, 'Sofía Castro', 999);

-- 4. Consultas para verificar los datos y la relación reflexiva.

-- Ver todos los alumnos y su representante.
SELECT * FROM Alumnos;

-- Mostrar la cadena de representación: Alumno Representado y su Representante.
SELECT
    A.nombreAlumno AS Alumno_Representado,
    R.nombreAlumno AS Alumno_Representante
FROM
    Alumnos A
JOIN
    Alumnos R ON A.idRepresentanteFK = R.idAlumno;

-- Mostrar qué alumnos actúan como representantes (aquellos cuyo id aparece en idRepresentanteFK de otra fila).
SELECT
    DISTINCT R.nombreAlumno AS Alumno_Que_Es_Representante
FROM
    Alumnos A
JOIN
    Alumnos R ON A.idRepresentanteFK = R.idAlumno
WHERE A.idAlumno != R.idAlumno; -- Excluir el caso de auto-representación si no es parte del modelo lógico

-- ##########################################################################
-- # FIN DEL CÓDIGO SQL                                                     #
-- ##########################################################################