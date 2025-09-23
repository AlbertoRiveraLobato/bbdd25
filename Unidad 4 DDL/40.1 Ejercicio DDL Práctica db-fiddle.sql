

-- El alumno debe escribir y ejecutar cada sentencia en db-fiddle.com (MySQL), observando los resultados y posibles errores.


-- 1) Crea una tabla llamada alumnos con las columnas: ID_Alumno INT, nombre VARCHAR(50), edad INT.
-- Query de comprobación:
SHOW TABLES;
DESCRIBE alumnos;

-- Solución:
CREATE TABLE alumnos (
    ID_Alumno INT,
    nombre VARCHAR(50),
    edad INT
);

-- 2) Crea una tabla profesores con las columnas: ID_Profesor INT, nombre VARCHAR(50), departamento VARCHAR(50).
-- Query de comprobación:
SHOW TABLES;
DESCRIBE profesores;

-- Solución:
CREATE TABLE profesores (
    ID_Profesor INT,
    nombre VARCHAR(50),
    departamento VARCHAR(50)
);

-- 3) Crea una tabla materias con ID_Materia INT, nombre VARCHAR(50), creditos INT.
-- Query de comprobación:
SHOW TABLES;
DESCRIBE materias;

-- Solución:
CREATE TABLE materias (
    ID_Materia INT,
    nombre VARCHAR(50),
    creditos INT
);

-- 4) Añade una columna email VARCHAR(100) a la tabla alumnos.
-- Query de comprobación:
DESCRIBE alumnos;

-- Solución:
ALTER TABLE alumnos ADD COLUMN email VARCHAR(100);

-- 5) Añade una columna telefono VARCHAR(20) a la tabla profesores.
-- Query de comprobación:
DESCRIBE profesores;

-- Solución:
ALTER TABLE profesores ADD COLUMN telefono VARCHAR(20);

-- 6) Modifica la columna edad de alumnos para que sea SMALLINT.
-- Query de comprobación:
DESCRIBE alumnos;

-- Solución:
ALTER TABLE alumnos MODIFY COLUMN edad SMALLINT;

-- 7) Modifica la columna creditos de materias para que sea DECIMAL(3,1).
-- Query de comprobación:
DESCRIBE materias;

-- Solución:
ALTER TABLE materias MODIFY COLUMN creditos DECIMAL(3,1);

-- 8) Cambia el nombre de la columna departamento de profesores a area.
-- Query de comprobación:
DESCRIBE profesores;

-- Solución:
ALTER TABLE profesores RENAME COLUMN departamento TO area;
-- O también: ALTER TABLE profesores CHANGE COLUMN departamento area VARCHAR(50);

-- 9) Añade una columna fecha_nacimiento DATE a la tabla alumnos, con valor por defecto '2000-01-01'.
-- Query de comprobación:
DESCRIBE alumnos;

-- Solución:
ALTER TABLE alumnos ADD COLUMN fecha_nacimiento DATE DEFAULT '2000-01-01';

-- 10) Añade una restricción UNIQUE al email de alumnos.
-- Query de comprobación:
DESCRIBE alumnos;

-- Solución:
ALTER TABLE alumnos ADD CONSTRAINT unique_email UNIQUE (email);

-- 11) Añade una restricción CHECK para que la edad de los alumnos sea mayor o igual a 18.
-- Query de comprobación:
DESCRIBE alumnos;

-- Solución:
ALTER TABLE alumnos ADD CONSTRAINT chk_edad CHECK (edad >= 18);

-- 12.1) Añade una clave primaria (PRIMARY KEY) a la columna ID_Alumno de alumnos.
-- Query de comprobación:
DESCRIBE alumnos;

-- Solución:
ALTER TABLE alumnos ADD PRIMARY KEY (ID_Alumno);

-- 12.2) Elimina la clave primaria de la columna ID_Alumno de alumnos.
-- Query de comprobación:
DESCRIBE alumnos;

-- Solución:
ALTER TABLE alumnos DROP PRIMARY KEY;

-- 13) Añade una clave primaria a la columna ID_Profesor de profesores.
-- Query de comprobación:
DESCRIBE profesores;

-- Solución:
ALTER TABLE profesores ADD PRIMARY KEY (ID_Profesor);

-- 14) Añade una clave primaria a la columna ID_Materia de materias.
-- Query de comprobación:
DESCRIBE materias;

-- Solución:
ALTER TABLE materias ADD PRIMARY KEY (ID_Materia);

-- 15) Elimina la columna telefono de profesores.
-- Query de comprobación:
DESCRIBE profesores;

-- Solución:
ALTER TABLE profesores DROP COLUMN telefono;

-- 16) Elimina la restricción CHECK de la edad en alumnos.
-- Query de comprobación:
DESCRIBE alumnos;

-- Solución:
ALTER TABLE alumnos DROP CONSTRAINT CHECK chk_edad;

-- 17) Elimina la restricción UNIQUE del email en alumnos.
-- Query de comprobación:
DESCRIBE alumnos;

-- Solución:
ALTER TABLE alumnos DROP CONSTRAINT email_unico;
-- O también (en MySQL):ALTER TABLE alumnos DROP INDEX unique_email;
-- En MySQL, una restricción UNIQUE realmente crea un índice único en la tabla.


-- 18.1) Inserta un registro en la tabla materias: (1, 'Mates', 15).
-- Query de comprobación:
SELECT * FROM materias;

-- Solución:
INSERT INTO materias (ID_Materia, nombre, creditos) VALUES
	(1, 'Mates', 15);


-- 18.2) Vacía todos los registros de la tabla materias, pero manteniendo su estructura.
-- Query de comprobación:
SELECT * FROM materias;

-- Solución:
TRUNCATE TABLE materias;

-- 19) Elimina la tabla materias.
-- Query de comprobación:
SHOW TABLES;

-- Solución:
DROP TABLE materias;

-- 20) Elimina la tabla profesores.
-- Query de comprobación:
SHOW TABLES;

-- Solución:
DROP TABLE profesores;

-- 21) Elimina la tabla alumnos.
-- Query de comprobación:
SHOW TABLES;

-- Solución:
DROP TABLE alumnos;


-- =============================================
-- FIN DE GUION INTEGRADO
-- =============================================
