-- ---
-- # EJERCICIO DE TRANSFORMACIÓN MER/MERE a MR
-- # CASO: Relación Reflexiva 1:N  (con participación parcial)
-- ---

-- **********************************************************************
-- 💬 ENUNCIADO (en comentarios SQL)
-- **********************************************************************
-- Modelamos una relación reflexiva (1,N) entre Alumnos y,
-- (0,1) del lado del representado, (1,N) del lado del vocal.
-- En cada grupo, algunos alumnos actúan como *vocales* del resto.
-- 
-- 🧩 Requisitos de la relación reflexiva:
-- - Un alumno puede tener como mucho un vocal → (0,1) → participación parcial.
-- - Un vocal representa obligatoriamente a algún alumno → (1,N) → participación total.
-- - Un alumno no puede representarse a sí mismo.
-- 
-- En resumen, la relación reflexiva tiene cardinalidades laterales:
-- (0,1) del lado del representado, (1,N) del lado del vocal.
-- 
-- 👇 Aclaraciones de modelado:
-- - Solo un atributo por entidad, además de la PK.
-- - Las claves foráneas se nombran como "id...FK"
-- - La base de datos se llamará BD_AlumnosVocales
-- **********************************************************************


-- **********************************************************************
-- 🔄 BORRADO Y CREACIÓN DE BASE DE DATOS
-- **********************************************************************
DROP DATABASE IF EXISTS BD_AlumnosVocales;
CREATE DATABASE BD_AlumnosVocales;
USE BD_AlumnosVocales;


-- **********************************************************************
-- 🧱 TABLA: Alumnos
-- **********************************************************************
CREATE TABLE Alumnos (
    idAlumno INT PRIMARY KEY,                -- PK: identificador único del alumno
    nombreAlumno VARCHAR(50),                -- Atributo adicional: nombre del alumno
    idVocalFK INT,                           -- FK reflexiva: indica quién es su vocal (otro alumno)
    -- No aplicamos "NOT NULL" a la FK porque NO todos los alumnos tienen vocal (participación parcial)
    
    -- Restricción de integridad referencial reflexiva
    CONSTRAINT fk_vocal FOREIGN KEY (idVocalFK) REFERENCES Alumnos(idAlumno)
        ON DELETE RESTRICT                   -- No permitimos eliminar vocales si representan a alguien
        ON UPDATE CASCADE,                   -- Si cambia el id del vocal, se propaga al representado
    
    -- Restricción: un alumno no puede representarse a sí mismo
    CONSTRAINT chk_no_autorepresentacion CHECK (idAlumno <> idVocalFK)
);

-- NOTA:
-- No aplicamos "NOT NULL" a la FK porque NO todos los alumnos tienen vocal (participación parcial)
-- Pero sí deben cumplirse las restricciones cuando exista el vínculo.


-- **********************************************************************
-- 🔢 INSERCIÓN DE DATOS DE PRUEBA
-- **********************************************************************
INSERT INTO Alumnos (idAlumno, nombreAlumno, idVocalFK) VALUES
    (1, 'Laura', 3),     -- Laura está representada por Marcos
    (2, 'Lucía', 3),     -- Lucía también por Marcos
    (3, 'Marcos', NULL), -- Marcos es vocal, no tiene vocal propio
    (4, 'Iván', 5),      -- Iván está representado por Elena
    (5, 'Elena', NULL);  -- Elena es vocal


-- **********************************************************************
-- 🔍 CONSULTAS DE PRUEBA
-- **********************************************************************

-- Consulta general de la tabla:
SELECT * FROM Alumnos;

-- Alumnos que tienen vocal (representados):
SELECT nombreAlumno AS Representado, idVocalFK FROM Alumnos WHERE idVocalFK IS NOT NULL;

-- Alumnos que NO tienen vocal (actúan como vocales):
SELECT nombreAlumno AS Vocal FROM Alumnos WHERE idVocalFK IS NULL;

-- Contar cuántos alumnos representa cada vocal:
SELECT A2.nombreAlumno AS Vocal, COUNT(*) AS Representados
FROM Alumnos A1
JOIN Alumnos A2 ON A1.idVocalFK = A2.idAlumno
GROUP BY A2.nombreAlumno;
