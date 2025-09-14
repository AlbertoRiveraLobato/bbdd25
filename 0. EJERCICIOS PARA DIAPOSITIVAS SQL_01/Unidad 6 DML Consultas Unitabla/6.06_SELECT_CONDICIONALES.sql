-- =============================================
-- 06_SELECT_CONDICIONALES.sql
-- =============================================
-- Ejemplos de uso de cláusulas condicionales en SELECT (MySQL): CASE, IF, COALESCE, IFNULL, NULLIF
-- Incluye: ejemplos prácticos y errores comunes.

-- CREACIÓN DE TABLA DE EJEMPLO
CREATE DATABASE IF NOT EXISTS ejemplo_select;
USE ejemplo_select;

CREATE TABLE IF NOT EXISTS alumnos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    nota DECIMAL(4,2),
    observaciones VARCHAR(100)
);

INSERT INTO alumnos (nombre, nota, observaciones) VALUES
('Ana', 8.5, NULL),
('Luis', 5.0, 'Recuperación'),
('Marta', NULL, NULL),
('Pedro', 9.2, 'Excelente'),
('Lucía', 4.5, NULL);

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================
-- 1) Muestra el nombre y una columna "Aprobado" que ponga 'Sí' si la nota es mayor o igual a 5, 'No' en caso contrario (CASE).
-- 2) Muestra el nombre y una columna "Situación" que ponga 'Sin nota' si la nota es NULL, o 'Con nota' si no lo es (IF).
-- 3) Muestra el nombre y la nota, sustituyendo los NULL por 0 (COALESCE).
-- 4) Muestra el nombre y la nota, sustituyendo los NULL por 0 (IFNULL).
-- 5) Muestra el nombre y una columna que indique 'Recuperación' si la observación es 'Recuperación', 'Normal' en otro caso (CASE).
-- 6) Muestra el nombre y una columna que indique 'Sin observaciones' si observaciones es NULL, o el valor de observaciones si no lo es (COALESCE).
-- 7) Muestra el nombre y una columna que indique 'Iguales' si nota y 5.0 son iguales, 'Distintos' si no (NULLIF + IFNULL).
-- 8) Muestra el nombre y una columna que indique 'Excelente' si la nota es mayor o igual a 9, 'Aprobado' si es >=5 y <9, 'Suspenso' si es menor de 5 (CASE anidado).
-- 9) Muestra el nombre y una columna que indique 'Pendiente' si la nota es NULL, o la nota si no lo es (IFNULL).
-- 10) Muestra el nombre y una columna que indique 'Sin nota' si la nota es NULL, 'Nota registrada' si no (IF).

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================
-- 1) CASE para aprobado
SELECT nombre, CASE WHEN nota >= 5 THEN 'Sí' ELSE 'No' END AS Aprobado FROM alumnos;

-- 2) IF para situación
SELECT nombre, IF(nota IS NULL, 'Sin nota', 'Con nota') AS Situacion FROM alumnos;

-- 3) COALESCE para nota
SELECT nombre, COALESCE(nota, 0) AS nota_sin_null FROM alumnos;

-- 4) IFNULL para nota
SELECT nombre, IFNULL(nota, 0) AS nota_sin_null FROM alumnos;

-- 5) CASE para observaciones
SELECT nombre, CASE WHEN observaciones = 'Recuperación' THEN 'Recuperación' ELSE 'Normal' END AS tipo FROM alumnos;

-- 6) COALESCE para observaciones
SELECT nombre, COALESCE(observaciones, 'Sin observaciones') AS obs FROM alumnos;

-- 7) NULLIF + IFNULL para igualdad
SELECT nombre, IFNULL(NULLIF(nota, 5.0), 'Iguales') AS comparacion FROM alumnos;

-- 8) CASE anidado para calificación
SELECT nombre, CASE 
    WHEN nota >= 9 THEN 'Excelente'
    WHEN nota >= 5 THEN 'Aprobado'
    WHEN nota < 5 THEN 'Suspenso'
    ELSE 'Sin nota'
END AS calificacion FROM alumnos;

-- 9) IFNULL para pendiente
SELECT nombre, IFNULL(CAST(nota AS CHAR), 'Pendiente') AS estado FROM alumnos;

-- 10) IF para sin nota
SELECT nombre, IF(nota IS NULL, 'Sin nota', 'Nota registrada') AS estado FROM alumnos;

-- =============================================
-- ERRORES COMUNES
-- =============================================
-- Error: uso incorrecto de CASE
-- SELECT nombre, CASE nota >= 5 THEN 'Sí' ELSE 'No' END FROM alumnos; -- Falta WHEN

-- Error: uso incorrecto de IFNULL
-- SELECT nombre, IFNULL() FROM alumnos; -- Faltan argumentos

-- Error: uso incorrecto de NULLIF
-- SELECT nombre, NULLIF(nota) FROM alumnos; -- Faltan argumentos

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
