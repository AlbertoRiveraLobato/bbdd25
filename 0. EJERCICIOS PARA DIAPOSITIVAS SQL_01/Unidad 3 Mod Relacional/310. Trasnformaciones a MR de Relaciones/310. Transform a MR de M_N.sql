-- =====================================================
-- SCRIPT COMPLETO: MODELO RELACIONAL PARA MATRÍCULAS ACADÉMICAS
-- Relación muchos-a-muchos (M:N) con histórico temporal
-- =====================================================

/* 
=====================================================
ENUNCIADO DEL EJERCICIO:

MODELO ENTIDAD-RELACIÓN (MER) DE PARTIDA:

ENTIDADES:
1. ALUMNOS
   - Atributos:
     * idAlumno (PK): Identificador único
     * nombreAlumno: Nombre completo
   - Participación en MATRÍCULAS:
     * Mínima: 0 (participación PARCIAL - no obligatorio estar matriculado)
     * Máxima: N (un alumno puede matricularse en muchas asignaturas)

2. ASIGNATURAS
   - Atributos:
     * idAsignatura (PK): Código único
     * nombreAsignatura: Nombre completo
   - Participación en MATRÍCULAS:
     * Mínima: 0 (participación PARCIAL - puede existir sin alumnos)
     * Máxima: N (una asignatura puede tener muchos alumnos)

RELACIÓN:
- MATRÍCULAS (M:N) entre ALUMNOS y ASIGNATURAS
  * Atributo de relación:
    - fechaMatricula (DATE): Fecha de matrícula (atributo determinante)
  * Cardinalidades:
    - Alumno ---(0,N)----- MATRÍCULAS -----(0,N)--- Asignatura
  * Características especiales:
    - La fechaMatricula forma parte de la PK compuesta
    - Permite histórico temporal (múltiples matrículas en diferentes fechas)
    - Participación parcial en ambos lados

REQUISITOS DE IMPLEMENTACIÓN:
1. Claves primarias con prefijo "id"
2. Claves foráneas con sufijo "FK"
3. Solo un atributo adicional por entidad
4. Integridad referencial con eliminación en cascada
=====================================================
*/

-- =================================================
-- CONFIGURACIÓN INICIAL DE LA BASE DE DATOS
-- =================================================

-- Eliminar base de datos existente (si existe)
DROP DATABASE IF EXISTS gestion_academica;

-- Crear nueva base de datos con collation en español
CREATE DATABASE gestion_academica;

-- Seleccionar la base de datos recién creada
USE gestion_academica;

-- =================================================
-- CREACIÓN DE TABLAS CON COMENTARIOS INLINE
-- =================================================

-- Tabla ALUMNOS (entidad con participación parcial 0..N)
CREATE TABLE IF NOT EXISTS Alumnos (
    idAlumno INT NOT NULL AUTO_INCREMENT,          -- PK autoincremental
    nombreAlumno VARCHAR(100) NOT NULL,            -- Atributo adicional único
    PRIMARY KEY (idAlumno)
);

-- Tabla ASIGNATURAS (entidad con participación parcial 0..N)
CREATE TABLE IF NOT EXISTS Asignaturas (
    idAsignatura INT NOT NULL AUTO_INCREMENT,      -- PK autoincremental
    nombreAsignatura VARCHAR(100) NOT NULL,        -- Atributo adicional único
    PRIMARY KEY (idAsignatura)
);

-- Tabla MATRÍCULAS (relación M:N con histórico temporal)
CREATE TABLE IF NOT EXISTS Matriculas (
    idAlumnoFK INT NOT NULL,                      -- FK a Alumnos
    idAsignaturaFK INT NOT NULL,                  -- FK a Asignaturas
    fechaMatricula DATE NOT NULL,                 -- Atributo determinante (histórico)
    
    -- Definición de PK compuesta (incluye fecha para histórico)
    PRIMARY KEY (idAlumnoFK, idAsignaturaFK, fechaMatricula),
    
    -- Restricción FK para alumno con eliminación en cascada
    CONSTRAINT fk_matricula_alumno
    FOREIGN KEY (idAlumnoFK) REFERENCES Alumnos(idAlumno)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    
    -- Restricción FK para asignatura con eliminación en cascada
    CONSTRAINT fk_matricula_asignatura
    FOREIGN KEY (idAsignaturaFK) REFERENCES Asignaturas(idAsignatura)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    
    -- Restricción para evitar fechas futuras
    CONSTRAINT chk_fecha_valida
    CHECK (fechaMatricula <= CURDATE())
);

-- =================================================
-- DATOS DE EJEMPLO (OPCIONAL)
-- =================================================

-- Insertar datos de prueba en Alumnos
INSERT INTO Alumnos (nombreAlumno) VALUES
    ('María García López'),
    ('Carlos Martínez Ruiz'),
    ('Ana Rodríguez Sánchez');

-- Insertar datos de prueba en Asignaturas
INSERT INTO Asignaturas (nombreAsignatura) VALUES
    ('Bases de Datos'),
    ('Programación Avanzada'),
    ('Sistemas Operativos');

-- Insertar matrículas con diferentes fechas (histórico)
INSERT INTO Matriculas (idAlumnoFK, idAsignaturaFK, fechaMatricula) VALUES
    (1, 1, '2023-09-10'),  -- María en BD (2023)
    (1, 1, '2024-01-15'),  -- María en BD (2024 - repite)
    (1, 2, '2023-09-10'),  -- María en Programación
    (2, 1, '2023-09-11'),  -- Carlos en BD
    (3, 3, '2023-09-12');  -- Ana en Sistemas Operativos

-- =================================================
-- CONSULTAS DEMOSTRATIVAS
-- =================================================

-- Consulta 1: Mostrar histórico completo de matrículas
SELECT 
    A.nombreAlumno AS 'Alumno',
    S.nombreAsignatura AS 'Asignatura',
    M.fechaMatricula AS 'Fecha Matrícula',
    -- Mostrar año académico basado en la fecha
    CASE 
        WHEN MONTH(M.fechaMatricula) >= 9 THEN CONCAT(YEAR(M.fechaMatricula), '-', YEAR(M.fechaMatricula)+1)
        ELSE CONCAT(YEAR(M.fechaMatricula)-1, '-', YEAR(M.fechaMatricula))
    END AS 'Año Académico'
FROM 
    Matriculas M
    JOIN Alumnos A ON M.idAlumnoFK = A.idAlumno
    JOIN Asignaturas S ON M.idAsignaturaFK = S.idAsignatura
ORDER BY 
    M.fechaMatricula DESC;

-- Consulta 2: Ver alumnos matriculados en una asignatura específica
SELECT 
    A.nombreAlumno,
    M.fechaMatricula
FROM 
    Matriculas M
    JOIN Alumnos A ON M.idAlumnoFK = A.idAlumno
WHERE 
    M.idAsignaturaFK = 1  -- Bases de Datos
ORDER BY 
    M.fechaMatricula DESC;

/* 
=====================================================
OBSERVACIONES PEDAGÓGICAS:

1. SOBRE LA PK COMPUESTA:
   - La inclusión de fechaMatricula en la PK permite:
     * Registrar múltiples matrículas del mismo alumno en la misma asignatura en diferentes fechas
     * Mantener un histórico temporal completo
     * Evitar duplicados en el mismo día

2. SOBRE PARTICIPACIÓN PARCIAL:
   - Ambas entidades tienen participación parcial (0..N):
     * Se pueden crear alumnos sin matrículas
     * Se pueden crear asignaturas sin alumnos
   - Se refleja en la no obligatoriedad de registros en MATRÍCULAS

3. SOBRE RESTRICCIONES:
   - ON DELETE CASCADE: Mantiene integridad referencial
   - CHECK fecha: Evita matrículas con fechas futuras
   - Nomenclatura consistente (PK sin sufijo, FK con sufijo)

4. PARA AMPLIACIÓN:
   - Se podría añadir atributos a la relación (ej: estado, convocatoria)
   - Se podría implementar triggers para validaciones complejas
=====================================================
*/