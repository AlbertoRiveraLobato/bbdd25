/*
 * Base de datos: triggers302
 * Descripción: Sistema de gestión para una academia que controla estudiantes,
 * cursos y sus inscripciones con restricciones de integridad

 ---------------------------

 Explicación de elementos clave:
Estructura de tablas:

    - estudiantes y cursos tienen restricciones CHECK para validar edad mínima y duración del curso

    - inscripciones es una tabla puente con clave primaria compuesta

- Trigger check_max_cursos:

    Se activa ANTES de cada inserción en inscripciones

    Cuenta las inscripciones existentes del estudiante

    Si alcanza el límite de 3, cancela la operación con error

    Manejo de errores:

        - Usa SIGNAL SQLSTATE para mensajes claros al usuario

        - Previene inconsistencias antes de que ocurran (BEFORE INSERT)

Integridad referencial:

    - Las claves foráneas usan ON DELETE CASCADE para mantener consistencia

    La clave primaria compuesta evita inscripciones duplicadas
 */

-- Elimina la base de datos si existe para empezar limpio
DROP DATABASE IF EXISTS triggers302;

-- Crea la base de datos y la selecciona para uso
CREATE DATABASE triggers302;
USE triggers302;

/*
 * Tabla: estudiantes
 * Campos:
 *   - dni: Identificador único (clave primaria)
 *   - nombre: Nombre completo del estudiante
 *   - edad: Debe ser >=18 (restricción CHECK)
 *   - nota_media: Promedio académico con 2 decimales
 */
CREATE TABLE estudiantes (
    dni CHAR(9) PRIMARY KEY,  -- Documento Nacional de Identidad (9 caracteres)
    nombre VARCHAR(50) NOT NULL,  -- Nombre obligatorio
    edad INT CHECK (edad >= 18),  -- Solo mayores de 18 años
    nota_media DECIMAL(3,2)  -- Rango de 0.00 a 9.99
);

/*
 * Tabla: cursos
 * Campos:
 *   - id_curso: Identificador único (clave primaria)
 *   - nombre: Nombre descriptivo del curso
 *   - duración: Horas lectivas (mínimo 10 por CHECK)
 */
CREATE TABLE cursos (
    id_curso INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,  -- Nombre obligatorio
    duracion INT CHECK (duracion >= 10)  -- Mínimo 10 horas
);

/*
 * Tabla: inscripciones
 * Propósito: Relación muchos-a-muchos entre estudiantes y cursos
 * Clave primaria compuesta: (dniFK, id_cursoFK)
 * Claves foráneas que referencian las tablas principales
 */
CREATE TABLE inscripciones (
    dniFK CHAR(9),
    id_cursoFK INT,
    PRIMARY KEY (dniFK, id_cursoFK),  -- Evita duplicados de misma inscripción
    FOREIGN KEY (dniFK) REFERENCES estudiantes(dni) ON DELETE CASCADE,
    FOREIGN KEY (id_cursoFK) REFERENCES cursos(id_curso) ON DELETE CASCADE
);

-- ========== INSERCIONES DE PRUEBA ==========

-- Datos válidos de estudiantes
INSERT INTO estudiantes VALUES ('12345678A', 'Laura Pérez', 20, 8.5);
INSERT INTO estudiantes VALUES ('87654321B', 'Carlos Ruiz', 22, 7.2);

-- Datos válidos de cursos
INSERT INTO cursos VALUES (1, 'Bases de Datos', 40);
INSERT INTO cursos VALUES (2, 'Redes', 30);
INSERT INTO cursos VALUES (3, 'Sistemas Operativos', 20);

-- Inscripciones válidas (3 cursos para un estudiante)
INSERT INTO inscripciones VALUES ('12345678A', 1);
INSERT INTO inscripciones VALUES ('12345678A', 2);
INSERT INTO inscripciones VALUES ('12345678A', 3); -- Límite permitido (3)

-- ========== PRUEBAS DE RESTRICCIONES ==========

-- Violación: Edad menor al mínimo permitido (CHECK)
INSERT INTO estudiantes VALUES ('55555555C', 'Ana Torres', 16, 9.1);

-- Violación: Duración de curso insuficiente (CHECK)
INSERT INTO cursos VALUES (4, 'HTML básico', 5);

-- Ejemplo que violaría la regla de máximo 3 cursos (si no existiera el trigger)
INSERT INTO cursos VALUES (5, 'Python', 50);  -- Curso válido
-- Esta inserción fallará cuando el trigger esté activo:
INSERT INTO inscripciones VALUES ('12345678A', 5);  -- 4º curso para Laura

-- ========== TRIGGER DE CONTROL ==========

/*
 * Trigger: check_max_cursos
 * Objetivo: Impedir que un estudiante se inscriba en más de 3 cursos
 * Tipo: BEFORE INSERT (previene la inserción no válida)
 * Tabla: inscripciones
 */
DELIMITER //  -- Cambio temporal de delimitador

CREATE TRIGGER check_max_cursos
BEFORE INSERT ON inscripciones
FOR EACH ROW  -- Evalúa cada fila insertada
BEGIN
  DECLARE total INT;  -- Variable para contar cursos actuales
  
  -- Consulta que cuenta las inscripciones existentes del estudiante
  SELECT COUNT(*) INTO total
  FROM inscripciones
  WHERE dniFK = NEW.dniFK;  -- NEW representa la nueva inscripción
  
  -- Si ya tiene 3 o más cursos, genera error
  IF total >= 3 THEN
    SIGNAL SQLSTATE '45000'  -- Código estándar para errores personalizados
    SET MESSAGE_TEXT = 'Error: un estudiante no puede estar inscrito en más de 3 cursos';
  END IF;
END;
//

DELIMITER ;  -- Restauración del delimitador estándar