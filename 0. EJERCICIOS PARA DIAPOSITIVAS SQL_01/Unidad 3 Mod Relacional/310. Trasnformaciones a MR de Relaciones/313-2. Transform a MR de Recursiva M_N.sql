-- ---
-- # EJERCICIO DE TRANSFORMACIÓN MER/MERE a MR
-- # CASO: Relación Reflexiva M:N
-- ---

-- ##########################################################################
-- # ENUNCIADO DEL EJERCICIO (PARA ALUMNOS)                                 #
-- ##########################################################################

-- Se nos pide diseñar una base de datos sencilla para la gestión de alumnos,
-- con un enfoque especial en cómo se organizan dentro de comités o grupos.

-- ENTIDAD PRINCIPAL:
-- 1.  Alumnos: Cada alumno se identifica por un `idAlumno` único y tiene un `nombreAlumno`.
--     - Atributos: `idAlumno` (PK), `nombreAlumno`.

-- RELACIÓN REFLEXIVA "ES_VOCAL_DE":
-- Queremos modelar una relación reflexiva M:N llamada "ES_VOCAL_DE".
-- Esta relación indica que un ALUMNO puede ser vocal de OTRO ALUMNO, y viceversa.
-- Esto representa, por ejemplo, que los alumnos se organizan en grupos de trabajo
-- donde un alumno actúa como vocal (representante) de otros compañeros, y puede ser
-- vocal para varios. Al mismo tiempo, un alumno puede tener varios vocales que lo representen.
-- La relación tiene un atributo propio: `fechaNombramiento`.

-- PARTICIPACIÓN Y RESTRICCIONES (¡Mucha atención a estos detalles!):

-- - Participación del lado "vocal" (el alumno que ejerce de vocal): (0,N)
--   - Mínima (0): Un alumno **puede no ser vocal de ningún otro alumno**. (Participación Parcial)
--   - Máxima (N): Un alumno **puede ser vocal de MÚLTIPLES otros alumnos**. (Cardinalidad Máxima M)

-- - Participación del lado "representado" (el alumno que es representado por un vocal): (0,N)
--   - Mínima (0): Un alumno **puede no tener ningún vocal que lo represente**. (Participación Parcial)
--   - Máxima (N): Un alumno **puede ser representado por MÚLTIPLES vocales**. (Cardinalidad Máxima N)

-- OBJETIVO:
-- Transformar este modelo E-R (reflexivo M:N) al Modelo Relacional,
-- creando las tablas SQL necesarias y aplicando las restricciones que deriven
-- de las cardinalidades y participaciones.

-- ##########################################################################
-- # COMIENZO DEL CÓDIGO SQL                                                #
-- ##########################################################################

-- 1. Preparación del entorno: Borrar, crear y seleccionar la base de datos.
-- Borra la base de datos si ya existe para empezar desde cero.
DROP DATABASE IF EXISTS `bd_alumnos_vocales`;

-- Crea la nueva base de datos.
CREATE DATABASE `bd_alumnos_vocales`;

-- Selecciona la base de datos para ejecutar las operaciones siguientes en ella.
USE `bd_alumnos_vocales`;

-- 2. Creación de las tablas resultantes del Modelo Relacional.

-- TABLA ALUMNOS
-- Representa la entidad 'Alumnos'.
CREATE TABLE Alumnos (
    idAlumno INT PRIMARY KEY,         -- Clave Primaria para identificar a cada alumno de forma única.
    nombreAlumno VARCHAR(100) NOT NULL -- Atributo adicional: el nombre del alumno (no puede ser nulo).
);

-- TABLA INTERMEDIA (O DE ENLACE) PARA LA RELACIÓN REFLEXIVA M:N
-- Para una relación M:N (ya sea binaria o reflexiva), siempre se crea una tabla intermedia.
-- Esta tabla contendrá dos claves foráneas que referencian a la misma tabla 'Alumnos',
-- pero con roles diferentes: uno para el vocal y otro para el alumno representado.
CREATE TABLE Alumno_Es_Vocal_De (
    idAlumnoVocalFK INT,    -- Clave Foránea que referencia al 'idAlumno' que ejerce de vocal.
    idAlumnoRepresentadoFK INT, -- Clave Foránea que referencia al 'idAlumno' que es representado.
    fechaNombramiento DATE NOT NULL, -- Atributo propio de la relación "ES_VOCAL_DE".
    PRIMARY KEY (idAlumnoVocalFK, idAlumnoRepresentadoFK), -- La combinación de ambas FKs forma la clave primaria compuesta
                                                            -- de esta tabla de enlace. Esto garantiza la unicidad de cada relación
                                                            -- Vocal-Representado.

    -- Definición de la primera clave foránea (lado "vocal").
    -- ON DELETE CASCADE: Si un alumno (vocal) es borrado, se borran todas las entradas donde era vocal.
    -- ON UPDATE CASCADE: Si el idAlumno (vocal) cambia, se actualiza automáticamente.
    CONSTRAINT fk_alumno_vocal FOREIGN KEY (idAlumnoVocalFK) REFERENCES Alumnos(idAlumno)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    -- Definición de la segunda clave foránea (lado "representado").
    -- ON DELETE CASCADE: Si un alumno (representado) es borrado, se borran todas las entradas donde era representado.
    -- ON UPDATE CASCADE: Si el idAlumno (representado) cambia, se actualiza automáticamente.
    CONSTRAINT fk_alumno_representado FOREIGN KEY (idAlumnoRepresentadoFK) REFERENCES Alumnos(idAlumno)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- COMENTARIOS ADICIONALES SOBRE LA TRANSFORMACIÓN DE RELACIONES REFLEXIVAS M:N (0,N)-(0,N):
-- 1.  Tabla de Enlace Obligatoria: Para cualquier relación M:N (incluidas las reflexivas),
--     siempre se crea una tabla intermedia (o de enlace) para resolver la cardinalidad.
--     En este caso, 'Alumno_Es_Vocal_De'.

-- 2.  Dos Claves Foráneas a la Misma Tabla: La tabla de enlace contiene dos FKs,
--     cada una apuntando a la tabla 'Alumnos'. Esto es lo que la hace "reflexiva".
--     Es crucial darles nombres distintos (`idAlumnoVocalFK`, `idAlumnoRepresentadoFK`)
--     para diferenciar el rol de cada alumno en la relación.

-- 3.  Clave Primaria Compuesta: La PK de la tabla de enlace es la combinación de ambas FKs.
--     Esto garantiza que una combinación específica de "vocal" y "representado"
--     solo puede existir una vez.

-- 4.  Participación Parcial (0,N) en ambos lados:
--     - No hay `NOT NULL` en las claves foráneas de la tabla `Alumnos` (porque no son FKs).
--     - La tabla de enlace `Alumno_Es_Vocal_De` solo contendrá registros para aquellos
--       alumnos que efectivamente actúen como vocales o sean representados.
--     - Un alumno puede existir en la tabla `Alumnos` sin aparecer en la tabla `Alumno_Es_Vocal_De`
--       ni como `idAlumnoVocalFK` ni como `idAlumnoRepresentadoFK`.
--       Esto implementa la participación mínima de 0 (Parcial) para ambos lados de la relación.

-- 5.  ON DELETE CASCADE: Elegido para este ejemplo. Significa que si un alumno es eliminado,
--     todos los registros en `Alumno_Es_Vocal_De` donde aparezca (ya sea como vocal o representado)
--     también serán eliminados automáticamente. Esto mantiene la integridad y evita registros "huérfanos".
--     Otras opciones serían RESTRICT (por defecto), SET NULL (si las FKs pudieran ser nulas aquí) o NO ACTION.

-- 3. Inserción de datos de prueba.

-- Insertamos algunos alumnos.
INSERT INTO Alumnos (idAlumno, nombreAlumno) VALUES
(1, 'Ana García'),
(2, 'Luis Pérez'),
(3, 'Marta Díaz'),
(4, 'Pedro Ruiz'),
(5, 'Sofía Castro'),
(6, 'Javier López');

-- Insertamos relaciones de "Es Vocal De".
-- Un alumno puede ser vocal de varios, y un alumno puede ser representado por varios.
INSERT INTO Alumno_Es_Vocal_De (idAlumnoVocalFK, idAlumnoRepresentadoFK, fechaNombramiento) VALUES
-- Ana (1) es vocal de Luis (2)
(1, 2, '2025-01-15'),
-- Ana (1) también es vocal de Marta (3)
(1, 3, '2025-01-15'),
-- Luis (2) es vocal de Pedro (4)
(2, 4, '2025-02-01'),
-- Marta (3) es vocal de Luis (2) (un alumno puede ser vocal y representado al mismo tiempo)
(3, 2, '2025-03-10'),
-- Pedro (4) es vocal de Sofía (5)
(4, 5, '2025-04-20'),
-- Sofía (5) es vocal de Javier (6)
(5, 6, '2025-05-01');

-- PRUEBAS DE RESTRICCIONES (DESCOMENTAR PARA VER LOS ERRORES):

-- Esto fallaría: INTENTO DE CREAR UNA RELACIÓN CON UN ALUMNO QUE NO EXISTE (viola FOREIGN KEY)
-- INSERT INTO Alumno_Es_Vocal_De (idAlumnoVocalFK, idAlumnoRepresentadoFK, fechaNombramiento) VALUES (1, 999, '2025-06-01');

-- Esto fallaría: INTENTO DE DUPLICAR LA MISMA RELACIÓN VOCAL-REPRESENTADO (viola PRIMARY KEY)
-- INSERT INTO Alumno_Es_Vocal_De (idAlumnoVocalFK, idAlumnoRepresentadoFK, fechaNombramiento) VALUES (1, 2, '2025-01-15');

-- 4. Consultas para verificar los datos y la relación reflexiva.

-- Ver todos los alumnos.
SELECT * FROM Alumnos;

-- Ver todas las relaciones de vocalía.
SELECT * FROM Alumno_Es_Vocal_De;

-- Mostrar quién es vocal de quién, incluyendo los nombres de los alumnos.
SELECT
    Vocal.nombreAlumno AS Nombre_Vocal,
    Representado.nombreAlumno AS Nombre_Representado,
    AEVD.fechaNombramiento
FROM
    Alumno_Es_Vocal_De AEVD
JOIN
    Alumnos Vocal ON AEVD.idAlumnoVocalFK = Vocal.idAlumno
JOIN
    Alumnos Representado ON AEVD.idAlumnoRepresentadoFK = Representado.idAlumno;

-- Mostrar qué alumnos son vocales de otros (y de cuántos).
SELECT
    Vocal.nombreAlumno,
    COUNT(AEVD.idAlumnoRepresentadoFK) AS Cantidad_Representados
FROM
    Alumno_Es_Vocal_De AEVD
JOIN
    Alumnos Vocal ON AEVD.idAlumnoVocalFK = Vocal.idAlumno
GROUP BY
    Vocal.nombreAlumno;

-- Mostrar qué alumnos son representados por otros (y por cuántos vocales).
SELECT
    Representado.nombreAlumno,
    COUNT(AEVD.idAlumnoVocalFK) AS Cantidad_Vocales
FROM
    Alumno_Es_Vocal_De AEVD
JOIN
    Alumnos Representado ON AEVD.idAlumnoRepresentadoFK = Representado.idAlumno
GROUP BY
    Representado.nombreAlumno;

-- ##########################################################################
-- # FIN DEL CÓDIGO SQL                                                     #
-- ##########################################################################