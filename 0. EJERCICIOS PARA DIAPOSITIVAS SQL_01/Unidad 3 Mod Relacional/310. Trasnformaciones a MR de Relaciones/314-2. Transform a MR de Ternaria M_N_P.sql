-- ---
-- # EJERCICIO DE TRANSFORMACIÓN MER/MERE a MR
-- # CASO: Relación Ternaria M:N:P (Muchos a Muchos a Muchos)
-- ---

-- ##########################################################################
-- # ENUNCIADO DEL EJERCICIO (PARA ALUMNOS)                                 #
-- ##########################################################################

-- Se nos pide diseñar una base de datos para registrar qué **Alumnos**
-- son **Supervisados** por qué **Profesores** en el contexto de qué **Proyectos**.

-- ENTIDADES:
-- 1.  Alumnos: Cada alumno tiene un `idAlumno` único y un `nombreAlumno`.
--     - Atributos: `idAlumno` (PK), `nombreAlumno`.
-- 2.  Profesores: Cada profesor tiene un `idProfesor` único y un `nombreProfesor`.
--     - Atributos: `idProfesor` (PK), `nombreProfesor`.
-- 3.  Proyectos: Cada proyecto tiene un `idProyecto` único y un `tituloProyecto`.
--     - Atributos: `idProyecto` (PK), `tituloProyecto`.

-- RELACIÓN TERNARIA "SUPERVISAR":
-- Queremos modelar una relación ternaria que vincula a un **Alumno**, un **Profesor** y un **Proyecto**.
-- Esta relación significa que: un **Profesor** `Supervisa` a un **Alumno** en un **Proyecto** específico.

-- PARTICIPACIÓN Y RESTRICCIONES (¡Mucha atención a estos detalles!):

-- Cardinalidades y Participación en la relación ternaria "SUPERVISAR":

-- 1.  Desde ALUMNO hacia la relación: (0,N)
--     - Mínima (0): Un alumno **puede no estar** siendo supervisado en ningún proyecto. (Participación Parcial)
--     - Máxima (N): Un alumno **puede ser supervisado por MÚLTIPLES profesores en MÚLTIPLES proyectos**. (Cardinalidad N)

-- 2.  Desde PROFESOR hacia la relación: (0,N)
--     - Mínima (0): Un profesor **puede no supervisar** a ningún alumno en ningún proyecto. (Participación Parcial)
--     - Máxima (N): Un profesor **puede supervisar a MÚLTIPLES alumnos en MÚLTIPLES proyectos**. (Cardinalidad N)

-- 3.  Desde PROYECTO hacia la relación: (0,N)
--     - Mínima (0): Un proyecto **puede no tener** alumnos siendo supervisados por profesores. (Participación Parcial)
--     - Máxima (N): Un proyecto **puede involucrar la supervisión de MÚLTIPLES alumnos por MÚLTIPLES profesores**. (Cardinalidad N)

-- Atributos de la Relación Ternaria:
-- - `fechaInicioSupervision`: La fecha en que comenzó esa supervisión específica.

-- OBJETIVO:
-- Transformar este modelo E-R (relación ternaria M:N:P) al Modelo Relacional,
-- creando las tablas SQL necesarias y aplicando las restricciones que deriven
-- de las cardinalidades y participaciones.

-- ##########################################################################
-- # COMIENZO DEL CÓDIGO SQL                                                #
-- ##########################################################################

-- 1. Preparación del entorno: Borrar, crear y seleccionar la base de datos.
DROP DATABASE IF EXISTS `bd_supervision_mnp`;
CREATE DATABASE `bd_supervision_mnp`;
USE `bd_supervision_mnp`;

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

-- 3. Creación de la tabla intermedia para la relación ternaria "SUPERVISAR".
-- Para transformar una relación ternaria M:N:P, siempre se crea una tabla intermedia.
-- La clave primaria de esta tabla intermedia se compone de las claves primarias de CADA UNA
-- de las tres entidades participantes.

-- TABLA INTERMEDIA (O DE ENLACE) PARA LA RELACIÓN TERNARIA M:N:P
CREATE TABLE Supervision (
    idAlumnoFK INT,    -- Clave Foránea que referencia a Alumnos. Parte de la PK compuesta.
    idProfesorFK INT,  -- Clave Foránea que referencia a Profesores. Parte de la PK compuesta.
    idProyectoFK INT,  -- Clave Foránea que referencia a Proyectos. Parte de la PK compuesta.
    fechaInicioSupervision DATE NOT NULL, -- Atributo propio de la relación ternaria.

    -- Definición de la Clave Primaria de la tabla ternaria.
    -- Según la regla M:N:P, la PK se forma con las claves foráneas de todas las entidades.
    PRIMARY KEY (idAlumnoFK, idProfesorFK, idProyectoFK),

    -- Definición de claves foráneas.
    CONSTRAINT fk_supervision_alumno FOREIGN KEY (idAlumnoFK) REFERENCES Alumnos(idAlumno)
    ON DELETE CASCADE   -- Si un alumno es borrado, se borran todas las supervisiones donde participa.
    ON UPDATE CASCADE,  -- Si el ID del alumno cambia, se actualiza la FK.

    CONSTRAINT fk_supervision_profesor FOREIGN KEY (idProfesorFK) REFERENCES Profesores(idProfesor)
    ON DELETE RESTRICT  -- Si un profesor es borrado, NO se permite si aún está supervisando.
                        -- (Se podría usar SET NULL si las FKs fueran NULLable, pero aquí son parte de PK).
    ON UPDATE CASCADE,  -- Si el ID del profesor cambia, se actualiza la FK.

    CONSTRAINT fk_supervision_proyecto FOREIGN KEY (idProyectoFK) REFERENCES Proyectos(idProyecto)
    ON DELETE CASCADE   -- Si un proyecto es borrado, se borran todas las supervisiones asociadas a él.
    ON UPDATE CASCADE   -- Si el ID del proyecto cambia, se actualiza la FK.
);

-- COMENTARIOS ADICIONALES SOBRE LA TRANSFORMACIÓN DE RELACIONES TERNARIAS M:N:P:
-- 1.  Tabla de Enlace Obligatoria: Siempre se crea una tabla intermedia para una relación ternaria.

-- 2.  Clave Primaria de la Tabla Ternaria:
--     - En una relación M:N:P, la PK de la tabla de enlace es la **combinación de las claves foráneas
--       de TODAS las entidades participantes** (`idAlumnoFK`, `idProfesorFK`, `idProyectoFK`).
--     - Esto garantiza la unicidad de cada tupla (Alumno, Profesor, Proyecto) en la relación.

-- 3.  Nulabilidad de las FKs:
--     - Dado que todas las FKs (`idAlumnoFK`, `idProfesorFK`, `idProyectoFK`) son parte de la Clave Primaria
--       compuesta de la tabla `Supervision`, implícitamente **NO PUEDEN SER NULL**.
--     - Esto también refleja la participación: si una tupla (supervisión) existe,
--       DEBE involucrar a un Alumno, un Profesor y un Proyecto.
--     - La **participación parcial (0)** de las entidades en la relación general (ej. un Alumno `(0,N)` no supervisa)
--       se maneja porque no todos los `idAlumno`, `idProfesor` o `idProyecto` necesitan aparecer
--       en esta tabla `Supervision`. Solo aparecen los que están activamente en una relación.

-- 4.  Acciones ON DELETE:
--     - `ON DELETE CASCADE` para `idAlumnoFK` y `idProyectoFK` es una opción común: si el alumno o proyecto
--       son eliminados, se eliminan todas las entradas de supervisión relacionadas.
--     - `ON DELETE RESTRICT` para `idProfesorFK` es sensato: un profesor no puede ser eliminado si
--       todavía está supervisando (lo cual es lógico si se quiere mantener un registro de sus supervisores).
--       Si se quisiera permitir el borrado de un profesor incluso si supervisa, habría que repensar la regla
--       de negocio o el modelo de la cardinalidad de participación del profesor.

-- 3. Inserción de datos de prueba.

-- Insertar algunos alumnos
INSERT INTO Alumnos (idAlumno, nombreAlumno) VALUES
(1, 'Ana García'),
(2, 'Luis Pérez'),
(3, 'Marta Díaz'),
(4, 'Pedro Ruiz');

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

-- Insertar relaciones de supervisión (ternaria M:N:P)
-- Un Alumno puede ser supervisado por N Profesores en N Proyectos.
-- Un Profesor puede supervisar a N Alumnos en N Proyectos.
-- Un Proyecto puede tener N Alumnos supervisados por N Profesores.
INSERT INTO Supervision (idAlumnoFK, idProfesorFK, idProyectoFK, fechaInicioSupervision) VALUES
(1, 101, 2001, '2024-09-01'), -- Ana supervisada por Dr. Robles en Proyecto 2001
(1, 102, 2002, '2024-09-10'), -- Ana supervisada por Dra. López en Proyecto 2002 (mismo alumno, diferentes profesor/proyecto)
(2, 101, 2001, '2024-09-05'), -- Luis supervisado por Dr. Robles en Proyecto 2001 (mismo profesor/proyecto, diferente alumno)
(2, 103, 2003, '2024-10-01'), -- Luis supervisado por Ing. Sánchez en Proyecto 2003
(3, 101, 2002, '2024-10-15'); -- Marta supervisada por Dr. Robles en Proyecto 2002

-- PRUEBAS DE RESTRICCIONES (DESCOMENTAR PARA VER LOS ERRORES):

-- Esto fallaría: INTENTO DE DUPLICAR LA MISMA SUPERVISIÓN (viola PRIMARY KEY)
-- INSERT INTO Supervision (idAlumnoFK, idProfesorFK, idProyectoFK, fechaInicioSupervision) VALUES (1, 101, 2001, '2024-09-01');
-- Error: Duplicate entry '1-101-2001' for key 'supervision.PRIMARY'

-- Esto fallaría: INTENTO DE INSERTAR UNA SUPERVISIÓN CON ALUMNO/PROFESOR/PROYECTO INEXISTENTE (viola FOREIGN KEY)
-- INSERT INTO Supervision (idAlumnoFK, idProfesorFK, idProyectoFK, fechaInicioSupervision) VALUES (99, 101, 2001, '2024-11-01');

-- Esto fallaría: INTENTO DE INSERTAR UNA SUPERVISIÓN CON CUALQUIER FK NULA (viola NOT NULL implícito de PK)
-- INSERT INTO Supervision (idAlumnoFK, idProfesorFK, idProyectoFK, fechaInicioSupervision) VALUES (4, NULL, 2001, '2024-11-01');

-- 4. Consultas para verificar los datos.

-- Ver todas las supervisiones registradas
SELECT * FROM Supervision;

-- Mostrar el detalle de cada supervisión: Quién supervisa a quién y en qué proyecto.
SELECT
    A.nombreAlumno,
    PR.nombreProfesor,
    P.tituloProyecto,
    S.fechaInicioSupervision
FROM
    Supervision S
JOIN
    Alumnos A ON S.idAlumnoFK = A.idAlumno
JOIN
    Profesores PR ON S.idProfesorFK = PR.idProfesor
JOIN
    Proyectos P ON S.idProyectoFK = P.idProyecto;

-- Mostrar cuántos alumnos supervisa cada profesor.
SELECT
    PR.nombreProfesor,
    COUNT(DISTINCT S.idAlumnoFK) AS Alumnos_Supervisados
FROM
    Supervision S
JOIN
    Profesores PR ON S.idProfesorFK = PR.idProfesor
GROUP BY
    PR.nombreProfesor;

-- Mostrar en qué proyectos está involucrado cada alumno como supervisado.
SELECT
    A.nombreAlumno,
    P.tituloProyecto
FROM

    Supervision S
JOIN
    Alumnos A ON S.idAlumnoFK = A.idAlumno
JOIN
    Proyectos P ON S.idProyectoFK = P.idProyecto
GROUP BY
    A.nombreAlumno, P.tituloProyecto;

-- ##########################################################################
-- # FIN DEL CÓDIGO SQL                                                     #
-- ##########################################################################