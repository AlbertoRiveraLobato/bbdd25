-- ---
-- # EJERCICIO DE TRANSFORMACIÓN MER/MERE a MR
-- # CASO: Relación Ternaria M:N:1
-- ---

-- ##########################################################################
-- # ENUNCIADO DEL EJERCICIO (PARA ALUMNOS)                                 #
-- ##########################################################################

-- Se nos pide diseñar una base de datos para registrar la participación de alumnos y profesores
-- en proyectos de fin de ciclo, con un enfoque en la supervisión de estos proyectos.

-- ENTIDADES:
-- 1.  Alumnos: Cada alumno tiene un `idAlumno` único y un `nombreAlumno`.
--     - Atributos: `idAlumno` (PK), `nombreAlumno`.
-- 2.  Profesores: Cada profesor tiene un `idProfesor` único y un `nombreProfesor`.
--     - Atributos: `idProfesor` (PK), `nombreProfesor`.
-- 3.  Proyectos: Cada proyecto tiene un `idProyecto` único y un `tituloProyecto`.
--     - Atributos: `idProyecto` (PK), `tituloProyecto`.

-- RELACIÓN TERNARIA "PARTICIPA_Y_SUPERVISA":
-- Queremos modelar una relación ternaria que vincula a un **Alumno**, un **Profesor** y un **Proyecto**.
-- Esta relación significa que: Un **Alumno** `Participa` en un **Proyecto** y es **Supervisado** en ESE Proyecto
-- por un **Profesor**.

-- PARTICIPACIÓN Y RESTRICCIONES (¡Mucha atención a estos detalles!):

-- Cardinalidades y Participación en la relación ternaria "PARTICIPA_Y_SUPERVISA":

-- 1.  Desde ALUMNO hacia la relación: (0,N)
--     - Mínima (0): Un alumno **puede no participar** en ningún proyecto. (Participación Parcial)
--     - Máxima (N): Un alumno **puede participar en MÚLTIPLES proyectos**. (Cardinalidad M)

-- 2.  Desde PROYECTO hacia la relación: (1,N)
--     - Mínima (1): Un proyecto **DEBE tener al menos un alumno** participando y siendo supervisado. (Participación Total)
--     - Máxima (N): Un proyecto **puede tener MÚLTIPLES alumnos** participando y siendo supervisados. (Cardinalidad N)

-- 3.  Desde PROFESOR hacia la relación: (0,1)
--     - Mínima (0): Un profesor **puede no supervisar** ningún proyecto (o alumno en un proyecto). (Participación Parcial)
--     - Máxima (1): Un profesor **puede supervisar como máximo UN ÚNICO alumno en un proyecto específico**.
--                   Esto significa que para una combinación dada de ALUMNO y PROYECTO,
--                   solo puede haber UN profesor supervisor. (Cardinalidad 1)

-- Atributos de la Relación Ternaria:
-- - `fechaAsignacion`: La fecha en que el alumno fue asignado a ese proyecto con ese supervisor.

-- OBJETIVO:
-- Transformar este modelo E-R (relación ternaria M:N:1) al Modelo Relacional,
-- creando las tablas SQL necesarias y aplicando las restricciones que deriven
-- de las cardinalidades y participaciones.

-- ##########################################################################
-- # COMIENZO DEL CÓDIGO SQL                                                #
-- ##########################################################################

-- 1. Preparación del entorno: Borrar, crear y seleccionar la base de datos.
DROP DATABASE IF EXISTS `bd_proyectos_supervision`;
CREATE DATABASE `bd_proyectos_supervision`;
USE `bd_proyectos_supervision`;

-- 2. Creación de las tablas de las entidades.

-- TABLA ALUMNOS
CREATE TABLE Alumnos (
    idAlumno INT PRIMARY KEY,         -- Clave Primaria para la entidad Alumnos.
    nombreAlumno VARCHAR(100) NOT NULL -- Atributo adicional para el nombre del alumno.
);

-- TABLA PROFESORES
CREATE TABLE Profesores (
    idProfesor INT PRIMARY KEY,       -- Clave Primaria para la entidad Profesores.
    nombreProfesor VARCHAR(100) NOT NULL -- Atributo adicional para el nombre del profesor.
);

-- TABLA PROYECTOS
CREATE TABLE Proyectos (
    idProyecto INT PRIMARY KEY,       -- Clave Primaria para la entidad Proyectos.
    tituloProyecto VARCHAR(255) NOT NULL -- Atributo adicional para el título del proyecto.
);

-- 3. Creación de la tabla intermedia para la relación ternaria "PARTICIPA_Y_SUPERVISA".
-- Para transformar una relación ternaria, siempre se crea una tabla intermedia.
-- La clave primaria de esta tabla intermedia se compone de las PKs de las entidades
-- participantes, con la particularidad de la cardinalidad '1' de 'Profesor'.

-- TABLA INTERMEDIA (O DE ENLACE) PARA LA RELACIÓN TERNARIA M:N:1
CREATE TABLE Participacion_Supervision (
    idAlumnoFK INT,    -- Clave Foránea que referencia a Alumnos (lado M).
    idProyectoFK INT,  -- Clave Foránea que referencia a Proyectos (lado N).
    idProfesorFK INT NOT NULL, -- Clave Foránea que referencia a Profesores (lado 1).
                               -- NOT NULL: La participación (0,1) del profesor en la relación
                               --           significa que no todos los profesores supervisan,
                               --           PERO para una combinación (Alumno, Proyecto), DEBE HABER un profesor supervisor.
                               --           Entonces, si un registro existe en esta tabla, idProfesorFK no puede ser NULL.
    fechaAsignacion DATE NOT NULL, -- Atributo propio de la relación ternaria.

    -- Definición de la Clave Primaria de la tabla ternaria.
    -- La PK se define por los lados 'M' y 'N' de la relación (Alumno y Proyecto),
    -- ya que un Alumno participa en un Proyecto, y en esa combinación, hay un único Profesor.
    PRIMARY KEY (idAlumnoFK, idProyectoFK),

    -- Restricción UNIQUE para el lado '1' de la relación ternaria (Profesor):
    -- Para una relación A-B-C con cardinalidad M:N:1 (donde C es el lado 1),
    -- la PK de la tabla de enlace es {A_FK, B_FK}.
    -- Y el lado '1' (C_FK) debe ser UNIQUE junto con el lado 'N' (B_FK), o el otro lado 'M' (A_FK),
    -- dependiendo de cómo se interprete el "1".
    -- En nuestro caso (Alumno, Proyecto, Profesor) -> (M, N, 1):
    -- Un (Alumno, Proyecto) tiene 1 Profesor. -> PRIMARY KEY (idAlumnoFK, idProyectoFK)
    -- Pero también, un (Profesor, Proyecto) puede tener N Alumnos.
    -- Un (Profesor, Alumno) puede participar en N Proyectos.
    -- La cardinalidad M:N:1 significa que para cada (Alumno, Proyecto) hay un único Profesor.
    -- Esto se refleja directamente en la PK de la tabla de enlace. No necesitamos un UNIQUE adicional
    -- sobre `idProfesorFK` porque su unicidad es respecto a la combinación `(idAlumnoFK, idProyectoFK)`.

    -- Definición de claves foráneas.
    CONSTRAINT fk_ps_alumno FOREIGN KEY (idAlumnoFK) REFERENCES Alumnos(idAlumno)
    ON DELETE CASCADE   -- Si un alumno es borrado, se borran sus participaciones.
    ON UPDATE CASCADE,  -- Si el ID del alumno cambia, se actualiza la FK.

    CONSTRAINT fk_ps_proyecto FOREIGN KEY (idProyectoFK) REFERENCES Proyectos(idProyecto)
    ON DELETE CASCADE   -- Si un proyecto es borrado, se borran todas las participaciones en él.
    ON UPDATE CASCADE,  -- Si el ID del proyecto cambia, se actualiza la FK.

    CONSTRAINT fk_ps_profesor FOREIGN KEY (idProfesorFK) REFERENCES Profesores(idProfesor)
    ON DELETE RESTRICT  -- Si un profesor es borrado, NO se permite si aún supervisa un proyecto.
                        -- Esto es sensato para proteger los datos de supervisión.
    ON UPDATE CASCADE   -- Si el ID del profesor cambia, se actualiza la FK.
);

-- COMENTARIOS ADICIONALES SOBRE LA TRANSFORMACIÓN DE RELACIONES TERNARIAS M:N:1:
-- 1.  Tabla de Enlace Obligatoria: Para cualquier relación ternaria, siempre se crea
--     una tabla intermedia. En este caso, `Participacion_Supervision`.

-- 2.  Clave Primaria de la Tabla Ternaria:
--     - Se forma con las claves foráneas de los lados 'M' y 'N' (`idAlumnoFK`, `idProyectoFK`).
--     - La cardinalidad '1' del `Profesor` significa que para cada combinación de `(Alumno, Proyecto)`,
--       solo hay un `Profesor` asociado. Por eso, `idProfesorFK` NO es parte de la PK de esta tabla,
--       sino un atributo más que es determinado por la combinación (`idAlumnoFK`, `idProyectoFK`).

-- 3.  Restricción NOT NULL en `idProfesorFK`: Implementa la cardinalidad (X,1) del Profesor,
--     asegurando que si un alumno participa en un proyecto, DEBE tener un profesor asignado para esa supervisión.
--     Aunque el profesor tenga participación (0,1) en la relación general, dentro de una *instancia*
--     de la relación (un registro en la tabla `Participacion_Supervision`), el profesor siempre existirá.

-- 4.  Participación Total del Proyecto (1,N): La clave foránea `idProyectoFK` no es `NOT NULL` aquí,
--     sino que su `NOT NULL` viene implícito al ser parte de la PK de la tabla de enlace.
--     La "participación total" del Proyecto (que cada Proyecto DEBE tener al menos un Alumno supervisado)
--     se garantizará si la lógica de inserción de proyectos asegura que siempre se añada
--     al menos una entrada en `Participacion_Supervision` por cada `idProyecto` creado.
--     SQL no puede imponer esto directamente sin triggers o validación a nivel de aplicación.
--     Sin embargo, al ser `idProyectoFK` parte de la PK de `Participacion_Supervision`,
--     implica que cada registro de `Participacion_Supervision` SIEMPRE estará vinculado a un `idProyecto` existente.

-- 5.  Participación Parcial de Alumno (0,N) y Profesor (0,1):
--     - Un alumno no tiene por qué aparecer en `Participacion_Supervision` (`idAlumnoFK` es FK pero no PK).
--     - Un profesor no tiene por qué aparecer en `Participacion_Supervision` (`idProfesorFK` es FK pero no parte de la PK).

-- 3. Inserción de datos de prueba.

-- Insertar algunos alumnos
INSERT INTO Alumnos (idAlumno, nombreAlumno) VALUES
(1, 'Ana García'),
(2, 'Luis Pérez'),
(3, 'Marta Díaz');

-- Insertar algunos profesores
INSERT INTO Profesores (idProfesor, nombreProfesor) VALUES
(101, 'Dr. Robles'),
(102, 'Dra. López'),
(103, 'Ing. Sánchez');

-- Insertar algunos proyectos
INSERT INTO Proyectos (idProyecto, tituloProyecto) VALUES
(2001, 'Aplicación de Gestión de Biblioteca'),
(2002, 'Sistema de Reconocimiento Facial'),
(2003, 'Plataforma E-learning Interactiva');

-- Insertar relaciones de participación y supervisión (ternaria M:N:1)
-- Recuerda: Un (Alumno, Proyecto) es supervisado por UN ÚNICO Profesor.
INSERT INTO Participacion_Supervision (idAlumnoFK, idProyectoFK, idProfesorFK, fechaAsignacion) VALUES
(1, 2001, 101, '2024-09-01'), -- Ana participa en Proyecto 2001, supervisada por Dr. Robles
(1, 2002, 102, '2024-09-10'), -- Ana participa en Proyecto 2002, supervisada por Dra. López (un alumno en varios proyectos)
(2, 2001, 101, '2024-09-05'), -- Luis participa en Proyecto 2001, supervisado por Dr. Robles (varios alumnos en un proyecto)
(3, 2003, 103, '2024-10-01'); -- Marta participa en Proyecto 2003, supervisada por Ing. Sánchez

-- PRUEBAS DE RESTRICCIONES (DESCOMENTAR PARA VER LOS ERRORES):

-- Esto fallaría: INTENTO DE QUE LA MISMA COMBINACIÓN (ALUMNO, PROYECTO) TENGA DOS PROFESORES (viola PRIMARY KEY)
-- INSERT INTO Participacion_Supervision (idAlumnoFK, idProyectoFK, idProfesorFK, fechaAsignacion) VALUES (1, 2001, 102, '2024-09-02');
-- Error: Duplicate entry '1-2001' for key 'participacion_supervision.PRIMARY'

-- Esto fallaría: INTENTO DE INSERTAR UNA SUPERVISIÓN SIN PROFESOR (viola NOT NULL en idProfesorFK)
-- INSERT INTO Participacion_Supervision (idAlumnoFK, idProyectoFK, idProfesorFK, fechaAsignacion) VALUES (2, 2002, NULL, '2024-09-15');

-- Esto fallaría: INTENTO DE USAR UN ID DE ALUMNO/PROYECTO/PROFESOR INEXISTENTE (viola FOREIGN KEY)
-- INSERT INTO Participacion_Supervision (idAlumnoFK, idProyectoFK, idProfesorFK, fechaAsignacion) VALUES (99, 2001, 101, '2024-09-20');

-- 4. Consultas para verificar los datos.

-- Ver todas las participaciones y supervisiones
SELECT * FROM Participacion_Supervision;

-- Mostrar el detalle de cada participación y supervisión:
-- Quién (Alumno) participa en qué (Proyecto) y quién lo supervisa (Profesor).
SELECT
    A.nombreAlumno,
    P.tituloProyecto,
    PR.nombreProfesor,
    PS.fechaAsignacion
FROM
    Participacion_Supervision PS
JOIN
    Alumnos A ON PS.idAlumnoFK = A.idAlumno
JOIN
    Proyectos P ON PS.idProyectoFK = P.idProyecto
JOIN
    Profesores PR ON PS.idProfesorFK = PR.idProfesor;

-- Mostrar qué profesores están supervisando y cuántos alumnos/proyectos supervisan.
SELECT
    PR.nombreProfesor,
    COUNT(PS.idAlumnoFK) AS Total_Supervisiones
FROM
    Participacion_Supervision PS
JOIN
    Profesores PR ON PS.idProfesorFK = PR.idProfesor
GROUP BY
    PR.nombreProfesor;

-- Mostrar qué proyectos tienen más alumnos participando y siendo supervisados.
SELECT
    P.tituloProyecto,
    COUNT(PS.idAlumnoFK) AS Total_Alumnos_Supervisados
FROM
    Participacion_Supervision PS
JOIN
    Proyectos P ON PS.idProyectoFK = P.idProyecto
GROUP BY
    P.tituloProyecto;

-- ##########################################################################
-- # FIN DEL CÓDIGO SQL                                                     #
-- ##########################################################################