-- =============================================
-- 06_SELECT_CONDICIONALES.sql
-- =============================================
-- Ejemplos de uso de cláusulas condicionales en SELECT (MySQL): CASE, IF, 
-- COALESCE(valor_a, valor_b): Devuelve el primer valor no nulo de esos dos, 
-- IFNULL(valor, valor_por_defecto): Devuelve valor_por_defecto si valor es NULL.
-- NULLIF(valor_a, valor_b): Devuelve NULL si ambos valores son iguales.


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
-- 7) Muestra el nombre y una columna que indique 'Iguales' si nota es NULL o 5.0, y 'Distintos' si no (NULLIF + IFNULL).
-- 8) Muestra el nombre y una columna que indique 'Excelente' si la nota es mayor o igual a 9, 'Aprobado' si es >=5 y <9, 'Suspenso' si es menor de 5 (CASE anidado).
-- 9) Muestra el nombre y una columna que indique 'Pendiente' si la nota es NULL, o la nota si no lo es (IFNULL).
-- 10) Muestra el nombre y una columna que indique 'Sin nota' si la nota es NULL, 'Nota registrada' si no (IF).

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================
-- 1) Muestra el nombre y una columna "Aprobado" que ponga 'Sí' si la nota es mayor o igual a 5, 'No' en caso contrario (CASE).
SELECT nombre, CASE WHEN nota >= 5 THEN 'Sí' ELSE 'No' END AS Aprobado FROM alumnos;

-- 2) Muestra el nombre y una columna "Situación" que ponga 'Sin nota' si la nota es NULL, o 'Con nota' si no lo es (IF).
SELECT nombre, IF(nota IS NULL, 'Sin nota', 'Con nota') AS Situacion FROM alumnos;

-- 3) Muestra el nombre y la nota, sustituyendo los NULL por 0 (COALESCE).
SELECT nombre, COALESCE(nota, 0) AS nota_sin_null FROM alumnos;

-- 4) Muestra el nombre y la nota, sustituyendo los NULL por 0 (IFNULL).
SELECT nombre, IFNULL(nota, 0) AS nota_sin_null FROM alumnos;

-- 5) Muestra el nombre y una columna que indique 'Recuperación' si la observación es 'Recuperación', 'Normal' en otro caso (CASE).
SELECT nombre, CASE WHEN observaciones = 'Recuperación' THEN 'Recuperación' ELSE 'Normal' END AS tipo FROM alumnos;

-- 6) Muestra el nombre y una columna que indique 'Sin observaciones' si observaciones es NULL, o el valor de observaciones si no lo es (COALESCE).
SELECT nombre, COALESCE(observaciones, 'Sin observaciones') AS obs FROM alumnos;

-- 7) Muestra el nombre y una columna que indique 'Iguales' si nota es NULL o 5.0, y 'Distintos' si no (NULLIF + IFNULL).
    SELECT nombre, IFNULL(NULLIF(nota, 5.0), 'Iguales') AS comparacion FROM alumnos;

-- 8) Muestra el nombre y una columna que indique 'Excelente' si la nota es mayor o igual a 9, 'Aprobado' si es >=5 y <9, 'Suspenso' si es menor de 5 (CASE anidado).
SELECT nombre, CASE 
    WHEN nota >= 9 THEN 'Excelente'
    WHEN nota >= 5 THEN 'Aprobado'
    WHEN nota < 5 THEN 'Suspenso'
    ELSE 'Sin nota'
END AS calificacion FROM alumnos;

-- 9) Muestra el nombre y una columna que indique 'Pendiente' si la nota es NULL, o la nota si no lo es (IFNULL).
SELECT nombre, IFNULL(nota, 'Pendiente') AS estado FROM alumnos;

-- 10) Muestra el nombre y una columna que indique 'Sin nota' si la nota es NULL, 'Nota registrada' si no (IF).
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





-- ==========================================
-- DEMOSTRACIÓN PRÁCTICA DE COALESCE
-- ==========================================
-- Propósito: Mostrar la diferencia entre usar SUM() solo y SUM() con COALESCE
-- en una situación realista, como en un trigger que actualiza el total de una venta.

-- CREACIÓN DE BASE DE DATOS Y TABLA DE EJEMPLO
CREATE DATABASE IF NOT EXISTS demo_coalesce;
USE demo_coalesce;
DROP TABLE IF EXISTS detalle_ventas;

-- Tabla sencilla para probar COALESCE con SUM()
CREATE TABLE detalle_ventas (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_venta INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    subtotal DECIMAL(10,2)
);

-- ==========================================
-- DATOS DE PRUEBA PARA DEMOSTRAR COALESCE
-- ==========================================

-- CASO 1: Insertar datos para id_venta = 1 (SUM normal)
INSERT INTO detalle_ventas (id_venta, cantidad, precio_unitario, subtotal) VALUES 
(1, 2, 100.50, 201.00),
(1, 1, 50.25, 50.25),
(1, 3, 25.00, 75.00);

-- CASO 2: Insertar datos para id_venta = 2 (más datos)
INSERT INTO detalle_ventas (id_venta, cantidad, precio_unitario, subtotal) VALUES 
(2, 1, 200.00, 200.00),
(2, 2, 150.75, 301.50);

-- ==========================================
-- PRUEBAS PARA DEMOSTRAR LA DIFERENCIA
-- ==========================================

-- Consulta 1: Con datos existentes (id_venta = 1) - SUM devuelve valor
SELECT 'CASO 1: id_venta = 1 (CON datos)' AS caso;
SELECT SUM(subtotal) AS sin_coalesce FROM detalle_ventas WHERE id_venta = 1;
SELECT COALESCE(SUM(subtotal), 0) AS con_coalesce FROM detalle_ventas WHERE id_venta = 1;

-- Consulta 2: Sin datos (id_venta = 99) - SUM devuelve NULL
SELECT 'CASO 2: id_venta = 99 (SIN datos)' AS caso;
SELECT SUM(subtotal) AS sin_coalesce FROM detalle_ventas WHERE id_venta = 99;
SELECT COALESCE(SUM(subtotal), 0) AS con_coalesce FROM detalle_ventas WHERE id_venta = 99;

-- Consulta 3: Con datos (id_venta = 2) - Otro ejemplo con datos
SELECT 'CASO 3: id_venta = 2 (CON datos)' AS caso;
SELECT SUM(subtotal) AS sin_coalesce FROM detalle_ventas WHERE id_venta = 2;
SELECT COALESCE(SUM(subtotal), 0) AS con_coalesce FROM detalle_ventas WHERE id_venta = 2;

-- ==========================================
-- VERIFICACIÓN DE LOS DATOS INSERTADOS
-- ==========================================
SELECT 'DATOS EN LA TABLA:' AS info;
SELECT * FROM detalle_ventas ORDER BY id_venta, id_detalle;

-- ==========================================
-- EXPLICACIÓN PRÁCTICA
-- ==========================================

/*
RESULTADOS ESPERADOS:

CASO 1 (id_venta = 1 - CON datos):
- sin_coalesce: 326.25
- con_coalesce: 326.25
→ Ambos devuelven el mismo resultado porque SUM encuentra datos

CASO 2 (id_venta = 99 - SIN datos):
- sin_coalesce: NULL
- con_coalesce: 0
→ COALESCE convierte el NULL en 0, evitando problemas

CASO 3 (id_venta = 2 - CON datos):
- sin_coalesce: 501.50
- con_coalesce: 501.50
→ Ambos devuelven el mismo resultado porque SUM encuentra datos

¿POR QUÉ ES IMPORTANTE COALESCE?

En tu trigger tr_procesar_venta, cuando se actualiza el total de una venta:

UPDATE ventas 
SET total = (
    SELECT COALESCE(SUM(subtotal), 0) 
    FROM detalle_ventas 
    WHERE id_venta = NEW.id_venta
)

Si por alguna razón no hay registros en detalle_ventas para esa venta:
- Sin COALESCE: total se establecería como NULL
- Con COALESCE: total se establece como 0

Esto mantiene la integridad de datos y evita cálculos erróneos posteriores.
*/