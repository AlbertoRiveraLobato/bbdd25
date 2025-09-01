-- **********************************************************************
-- 👨‍🏫 EJERCICIO DE TRANSFORMACIÓN MERE → MODELO RELACIONAL
-- FP - Bases de Datos | Tema: Relaciones 1:N con participación total/parcial
-- **********************************************************************

-- 🔄 Eliminar la base de datos si ya existe
DROP DATABASE IF EXISTS BDEducativa;

-- 🆕 Crear una nueva base de datos
CREATE DATABASE BDEducativa;

-- 📌 Usar esta base de datos por defecto
USE BDEducativa;

-- **********************************************************************
-- 📘 ENUNCIADO (en comentarios SQL):
-- 
-- En un centro educativo, cada alumno está asignado obligatoriamente a una asignatura.
-- Una asignatura puede tener muchos alumnos, o incluso ninguno.
--
-- ⚙️ RELACIÓN: "EstáAsignado"
-- Tipo de relación: 1:N entre Asignaturas y Alumnos
--
-- ➤ Cardinalidad:
--     - Asignaturas: (0,N) → Puede no tener alumnos, puede tener muchos.
--     - Alumnos:     (1,1) → Cada alumno debe estar en una sola asignatura.
--
-- ➤ Participación:
--     - Alumnos → Participación TOTAL en la relación
--     - Asignaturas → Participación PARCIAL en la relación
--
-- 🎯 Objetivo: Transformar esta relación en un modelo relacional completo.
-- **********************************************************************


-- 🎓 ENTIDAD: Asignaturas
CREATE TABLE Asignaturas (
    idAsignatura INT PRIMARY KEY,              -- Clave primaria de Asignaturas
    nombreAsignatura VARCHAR(100) NOT NULL     -- Atributo de ejemplo
);

-- 👥 ENTIDAD: Alumnos
-- El atributo 'idAsignaturaFK' representa la relación 1:N
-- como FK que apunta a Asignaturas.
-- Se declara NOT NULL porque la participación de Alumnos es TOTAL.
CREATE TABLE Alumnos (
    idAlumno INT PRIMARY KEY,                      -- Clave primaria de Alumnos
    nombreAlumno VARCHAR(100) NOT NULL,            -- Atributo de ejemplo
    idAsignaturaFK INT NOT NULL,                   -- Dado que la participación de Alumnos es TOTAL
    FOREIGN KEY (idAsignaturaFK) REFERENCES Asignaturas(idAsignatura) -- Clave foránea que representa la relación
        ON DELETE RESTRICT                         -- Evita borrar asignaturas con alumnos
        ON UPDATE CASCADE                          -- Actualiza la FK si cambia el ID de Asignaturas
);

-- **********************************************************************
-- 🔍 EXPLICACIÓN DE LA TRANSFORMACIÓN MERE → MR:
--
-- 📌 Como la relación es 1:N (Asignaturas:Alumnos), la FK va en el lado N: Alumnos.
-- 📌 Dado que la participación de Alumnos es TOTAL:
--      ➤ El campo 'idAsignaturaFK' es NOT NULL.
-- 📌 Como la participación de Asignaturas es PARCIAL:
--      ➤ No se requiere ninguna restricción adicional.
--
-- ✅ Este diseño refleja correctamente la relación "EstáAsignado"
-- desde el modelo MER/MERE al modelo relacional.
-- **********************************************************************

-- **********************************************************************
-- 🗂️ INSERCIÓN DE DATOS DE PRUEBA
-- **********************************************************************

-- Insertar asignaturas
INSERT INTO Asignaturas (idAsignatura, nombreAsignatura) VALUES
(1, 'Bases de Datos'),
(2, 'Programación'),
(3, 'Entornos de Desarrollo');

-- Insertar alumnos
-- Recuerda que cada alumno debe estar asignado a UNA asignatura obligatoriamente.
INSERT INTO Alumnos (idAlumno, nombreAlumno, idAsignaturaFK) VALUES
(101, 'Laura Gómez', 1),
(102, 'Mario Díaz', 2),
(103, 'Elena Ruiz', 1),
(104, 'Carlos Pérez', 3);

-- **********************************************************************
-- 🔍 CONSULTAS PARA COMPROBAR LOS DATOS
-- **********************************************************************

-- Ver todas las asignaturas
SELECT * FROM Asignaturas;

-- Ver todos los alumnos con su asignatura (JOIN)
SELECT 
    a.idAlumno,
    a.nombreAlumno,
    s.nombreAsignatura
FROM Alumnos a
JOIN Asignaturas s ON a.idAsignaturaFK = s.idAsignatura;

-- Ver cuántos alumnos hay por asignatura
SELECT 
    s.nombreAsignatura,
    COUNT(a.idAlumno) AS totalAlumnos
FROM Asignaturas s
LEFT JOIN Alumnos a ON s.idAsignatura = a.idAsignaturaFK
GROUP BY s.nombreAsignatura;

-- Ver asignaturas sin alumnos (si las hubiera)
SELECT 
    s.idAsignatura,
    s.nombreAsignatura
FROM Asignaturas s
LEFT JOIN Alumnos a ON s.idAsignatura = a.idAsignaturaFK
WHERE a.idAlumno IS NULL;

-- Ver alumnos que están en la asignatura "Bases de Datos"
SELECT 
    a.idAlumno,
    a.nombreAlumno
FROM Alumnos a
JOIN Asignaturas s ON a.idAsignaturaFK = s.idAsignatura
WHERE s.nombreAsignatura = 'Bases de Datos';
