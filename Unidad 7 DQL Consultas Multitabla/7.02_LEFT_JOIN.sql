
-- =============================================
-- 7.02_LEFT_JOIN.sql
-- =============================================
-- Ejercicios y ejemplos progresivos de LEFT JOIN (LEFT OUTER JOIN) en SQL
-- Estructura: introducción, creación de tablas/datos, enunciados, soluciones, comparativas, casos prácticos, errores comunes y conceptos clave.

DROP DATABASE IF EXISTS ejemplo_joins;
CREATE DATABASE ejemplo_joins;
USE ejemplo_joins;

-- =============================================
-- CREACIÓN DE TABLAS
-- =============================================

-- Tabla de departamentos
CREATE TABLE departamentos (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_dept VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(50)
);

-- Tabla de empleados básica
CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    salario DECIMAL(10,2),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

-- Tabla de proyectos
CREATE TABLE proyectos (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_proyecto VARCHAR(100) NOT NULL,
    presupuesto DECIMAL(12,2),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);



-- =============================================
-- INSERCIÓN DE DATOS
-- =============================================
('Ventas', 'Madrid'),
('IT', 'Valencia'),
('Recursos Humanos', 'Sevilla'),
('Finanzas', 'Bilbao'),
('Investigación', 'Granada'),
('Legal', 'Toledo'),
('Calidad', 'Santander'),
('Sin Asignar', 'No definida'); -- Departamento especial sin empleados

-- Datos de empleados básicos (incluyendo empleados sin departamento)
INSERT INTO empleados (nombre, salario, id_departamento) VALUES
('Ana García', 1800, 1),
('Luis Pérez', 2000, 2),
('Marta Ruiz', 2200, 1),
('Pedro López', 2500, 3),
('Carmen Silva', 1900, NULL), -- Empleado sin departamento
('Roberto Díaz', 2300, NULL),  -- Empleado sin departamento
('Sandra Martín', 1950, NULL), -- Empleado sin departamento
('Elena Vázquez', 2400, 4),
('Diego Moreno', 1850, 5);

-- Datos de proyectos (incluyendo proyectos sin departamento)
INSERT INTO proyectos (nombre_proyecto, presupuesto, id_departamento) VALUES
('Campaña Primavera', 50000, 1),
('Web Corporativa', 75000, 3),
('Consulta Legal', 15000, 7),
('Optimización Logística', 60000, 9),
('Proyecto Huérfano', 35000, NULL); -- Proyecto sin departamento

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================

-- *** EJERCICIOS BÁSICOS CON LEFT JOIN (1-10) ***
-- 1) Muestra todos los empleados con el nombre de su departamento (incluye empleados sin departamento).
-- 2) Muestra todos los departamentos con sus empleados (incluye departamentos sin empleados).
-- 3) Muestra los empleados que NO tienen departamento asignado.
-- 4) Muestra los departamentos que NO tienen empleados asignados.
-- 5) Muestra todos los empleados con su salario y departamento, ordenados por salario.
-- 6) Muestra el número de empleados por departamento (incluye departamentos con 0 empleados).
-- 7) Muestra todos los departamentos con el presupuesto total de sus proyectos (incluye departamentos sin proyectos).
-- 8) Muestra los departamentos que no tienen proyectos asignados.
-- 9) Muestra todos los empleados con información completa: departamento y ubicación (incluye empleados sin departamento).
-- 10) Muestra todos los proyectos con el nombre del departamento (incluye proyectos sin departamento asignado).

-- *** EJERCICIOS AVANZADOS CON LEFT JOIN (11-20) ***
-- 11) Calcula el salario promedio, máximo y mínimo por departamento (incluye departamentos sin empleados).
-- 12) Muestra empleados únicos (DISTINCT) que trabajan en departamentos con proyectos (incluye todos los empleados).
-- 13) Calcula el número total de proyectos y empleados por departamento usando agregadores.
-- 14) Muestra empleados con salario calculado y bonificación, incluyendo empleados sin departamento.
-- 15) Clasifica departamentos según número de empleados: 'Grande' (>2), 'Mediano' (1-2), 'Sin empleados' (0).
-- 16) Muestra información de empleados usando COALESCE para valores NULL en departamento y salario.
-- 17) Muestra departamentos cuyos empleados tienen salario superior al promedio general (incluye departamentos sin empleados).
-- 18) Calcula la diferencia entre empleados con departamento vs sin departamento usando subconsultas.
-- 19) Muestra un reporte completo con campos calculados: ratio de empleados por proyecto en cada departamento.
-- 20) Identifica departamentos "problemáticos": sin empleados O sin proyectos usando múltiples condiciones.

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================

-- *** SOLUCIONES EJERCICIOS BÁSICOS (1-10) ***
FROM empleados e 
WHERE d.id_departamento IS NULL;

FROM empleados e 

-- 6) Muestra el número de empleados por departamento (incluye departamentos con 0 empleados).
SELECT d.nombre_dept, COUNT(e.id_empleado) AS num_empleados 
FROM departamentos d 
GROUP BY d.id_departamento, d.nombre_dept;

-- 7) Muestra todos los departamentos con el presupuesto total de sus proyectos (incluye departamentos sin proyectos).
SELECT d.nombre_dept, COALESCE(SUM(p.presupuesto), 0) AS total_presupuesto 
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept;

-- 8) Muestra los departamentos que no tienen proyectos asignados.
SELECT d.nombre_dept, d.ubicacion 
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
WHERE p.id_departamento IS NULL;

-- 9) Muestra todos los empleados con información completa: departamento y ubicación (incluye empleados sin departamento).
SELECT e.nombre, 
       COALESCE(d.ubicacion, 'Sin Ubicación') AS ubicacion 
FROM empleados e 
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento;

SELECT p.nombre_proyecto, p.presupuesto, COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento
FROM proyectos p 
LEFT JOIN departamentos d ON p.id_departamento = d.id_departamento;

-- *** SOLUCIONES EJERCICIOS AVANZADOS (11-20) ***
-- 11) Calcula el salario promedio, máximo y mínimo por departamento (incluye departamentos sin empleados).
SELECT 
    d.nombre_dept,
    COUNT(e.id_empleado) AS num_empleados,
    COALESCE(AVG(e.salario), 0) AS salario_promedio,
    COALESCE(MIN(e.salario), 0) AS salario_minimo
FROM departamentos d 
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
GROUP BY d.id_departamento, d.nombre_dept
ORDER BY num_empleados DESC;
-- 12) Muestra empleados únicos (DISTINCT) que trabajan en departamentos con proyectos (incluye todos los empleados).
SELECT DISTINCT 
    e.nombre, 
    e.salario, 
    CASE 
        WHEN p.id_proyecto IS NOT NULL THEN 'Tiene Proyectos'
        ELSE 'Sin Proyectos'
    END AS estado_proyectos
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
ORDER BY e.nombre;

-- 13) Calcula el número total de proyectos y empleados por departamento usando agregadores.
SELECT 
    COUNT(DISTINCT e.id_empleado) AS total_empleados,
    COUNT(DISTINCT p.id_proyecto) AS total_proyectos,
    COALESCE(SUM(p.presupuesto), 0) AS presupuesto_total,
    CASE 
        WHEN COUNT(DISTINCT e.id_empleado) = 0 THEN 'Inactivo'
        ELSE 'Activo'
    END AS estado_departamento
FROM departamentos d 
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept

-- 14) Muestra empleados con salario calculado y bonificación, incluyendo empleados sin departamento.
SELECT 
    e.nombre,
    COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
    COALESCE(d.ubicacion, 'Sin Ubicación') AS ubicacion,
    COALESCE(e.salario, 0) AS salario_base,
    CASE 
        WHEN d.ubicacion = 'Madrid' THEN COALESCE(e.salario, 0) * 1.15
        ELSE COALESCE(e.salario, 0) * 1.05  -- Empleados sin departamento
    END AS salario_con_bonificacion,
    CASE 
        WHEN d.ubicacion = 'Madrid' THEN COALESCE(e.salario, 0) * 0.15
        WHEN d.ubicacion IS NOT NULL THEN COALESCE(e.salario, 0) * 0.10
        ELSE COALESCE(e.salario, 0) * 0.05
    END AS bonificacion
FROM empleados e 
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY salario_con_bonificacion DESC;
-- 15) Clasifica departamentos según número de empleados: 'Grande' (>2), 'Mediano' (1-2), 'Sin empleados' (0).
SELECT 
    d.nombre_dept,
    d.ubicacion,
    CASE 
        WHEN COUNT(e.id_empleado) > 2 THEN 'Grande'
        WHEN COUNT(e.id_empleado) BETWEEN 1 AND 2 THEN 'Mediano'
        ELSE 'Sin empleados'
    END AS tamaño_departamento,
    IF(COUNT(e.id_empleado) > 0, 'Activo', 'Inactivo') AS estado
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion
ORDER BY num_empleados DESC;

-- 16) Muestra información de empleados usando COALESCE para valores NULL en departamento y salario.
    e.nombre,
    COALESCE(e.salario, 1500) AS salario_con_minimo,
    COALESCE(d.nombre_dept, 'Departamento No Asignado') AS departamento,
    COALESCE(d.ubicacion, 'Ubicación Pendiente') AS ubicacion,
    IFNULL(e.salario, 'Salario Pendiente') AS salario_texto,
    NULLIF(e.salario, 0) AS salario_sin_ceros  -- Convierte 0 a NULL
FROM empleados e 
ORDER BY e.salario DESC;

-- 17) Muestra departamentos cuyos empleados tienen salario superior al promedio general (incluye departamentos sin empleados).
SELECT 
    d.nombre_dept,
    COUNT(e.id_empleado) AS num_empleados,
    COALESCE(AVG(e.salario), 0) AS promedio_departamento,
    (SELECT AVG(salario) FROM empleados WHERE salario IS NOT NULL) AS promedio_general,
    CASE 
        WHEN AVG(e.salario) > (SELECT AVG(salario) FROM empleados WHERE salario IS NOT NULL) 
        THEN 'Por encima del promedio' 
        WHEN AVG(e.salario) IS NULL 
FROM departamentos d 
GROUP BY d.id_departamento, d.nombre_dept
ORDER BY promedio_departamento DESC;

-- 18) Calcula la diferencia entre empleados con departamento vs sin departamento usando subconsultas.
    'Con Departamento' AS categoria,
    COUNT(*) AS cantidad,
    AVG(e.salario) AS salario_promedio,
    (SELECT COUNT(*) FROM empleados) AS total_empleados
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE d.id_departamento IS NOT NULL

UNION ALL
    COUNT(*) AS cantidad,
    (SELECT COUNT(*) FROM empleados) AS total_empleados
FROM empleados e 
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE d.id_departamento IS NULL;

SELECT 
    d.nombre_dept,
    d.ubicacion,
    COUNT(DISTINCT e.id_empleado) AS total_empleados,
    COUNT(DISTINCT p.id_proyecto) AS total_proyectos,
    CASE 
        WHEN COUNT(DISTINCT p.id_proyecto) = 0 THEN 0
        ELSE ROUND(COUNT(DISTINCT e.id_empleado) / COUNT(DISTINCT p.id_proyecto), 2)
    END AS ratio_empleados_proyectos,
    END AS presupuesto_por_empleado
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion
-- 20) Identifica departamentos "problemáticos": sin empleados O sin proyectos usando múltiples condiciones.
    COUNT(DISTINCT e.id_empleado) AS num_empleados,
    COUNT(DISTINCT p.id_proyecto) AS num_proyectos,
        THEN 'PROBLEMA: Sin empleados'
        WHEN COUNT(DISTINCT p.id_proyecto) = 0 
        THEN 'ADVERTENCIA: Sin proyectos'
        ELSE 'NORMAL: Con empleados y proyectos'
    END AS estado_departamento,
    CASE 
        WHEN COUNT(DISTINCT e.id_empleado) = 0 OR COUNT(DISTINCT p.id_proyecto) = 0 
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
    CASE 
        WHEN COUNT(DISTINCT e.id_empleado) = 0 AND COUNT(DISTINCT p.id_proyecto) = 0 THEN 1
    END;
GROUP BY d.id_departamento, d.nombre_dept;

-- 8) Muestra los departamentos que no tienen proyectos asignados.
SELECT d.nombre_dept, d.ubicacion 
FROM departamentos d 
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
WHERE p.id_departamento IS NULL;

-- 9) Muestra todos los empleados con información completa: departamento y ubicación (incluye empleados sin departamento).
SELECT e.nombre, 
       COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
       COALESCE(d.ubicacion, 'Sin Ubicación') AS ubicacion 
FROM empleados e 
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- 10) Muestra el salario promedio por departamento (incluye departamentos sin empleados como NULL).
SELECT d.nombre_dept, AVG(e.salario) AS salario_promedio 
FROM departamentos d 
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
GROUP BY d.id_departamento, d.nombre_dept;

-- =============================================
-- EJEMPLOS COMPARATIVOS: INNER JOIN vs LEFT JOIN
-- =============================================

-- INNER JOIN: Solo empleados CON departamento
SELECT 'INNER JOIN - Solo empleados con departamento:' AS comparacion;
SELECT e.nombre, d.nombre_dept 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- LEFT JOIN: TODOS los empleados (con y sin departamento)
SELECT 'LEFT JOIN - Todos los empleados:' AS comparacion;
SELECT e.nombre, COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento 
FROM empleados e 
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- Mostrar la diferencia en conteo
SELECT 'Conteo de registros:' AS comparacion;
SELECT 
    (SELECT COUNT(*) FROM empleados e INNER JOIN departamentos d ON e.id_departamento = d.id_departamento) AS inner_join_count,
    (SELECT COUNT(*) FROM empleados e LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento) AS left_join_count;

-- =============================================
-- CASOS PRÁCTICOS COMUNES
-- =============================================

-- Caso 1: Encontrar registros "huérfanos" (empleados sin departamento)
SELECT 'Empleados sin departamento asignado:' AS caso;
SELECT e.nombre, e.salario 
FROM empleados e 
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE d.id_departamento IS NULL;

-- Caso 2: Encontrar departamentos inactivos (sin empleados)
SELECT 'Departamentos sin empleados:' AS caso;
SELECT d.nombre_dept, d.ubicacion 
FROM departamentos d 
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
WHERE e.id_departamento IS NULL;

-- Caso 3: Reporte completo con manejo de valores NULL
SELECT 'Reporte completo de empleados:' AS caso;
SELECT 
    e.nombre,
    e.salario,
    COALESCE(d.nombre_dept, 'Sin Asignar') AS departamento,
    COALESCE(d.ubicacion, 'N/A') AS ubicacion
FROM empleados e 
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY e.salario DESC;

-- =============================================
-- ERRORES COMUNES
-- =============================================

-- Error: Usar WHERE en lugar de ON puede convertir LEFT JOIN en INNER JOIN
-- INCORRECTO (se comporta como INNER JOIN):
-- SELECT e.nombre, d.nombre_dept FROM empleados e LEFT JOIN departamentos d WHERE e.id_departamento = d.id_departamento;

-- CORRECTO:
-- SELECT e.nombre, d.nombre_dept FROM empleados e LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- Error: No entender cuándo usar IS NULL para detectar registros sin coincidencias
-- Para encontrar empleados sin departamento, hay que usar IS NULL en la columna de la tabla derecha:
-- WHERE d.id_departamento IS NULL (correcto)
-- WHERE e.id_departamento IS NULL (incorrecto - buscaría empleados con id_departamento NULL)

-- =============================================
-- CONCEPTOS CLAVE DEL LEFT JOIN
-- =============================================
/*
LEFT JOIN (LEFT OUTER JOIN):
- Devuelve TODAS las filas de la tabla izquierda
- Incluye filas de la tabla derecha que coinciden
- Para filas sin coincidencias en la tabla derecha, rellena con NULL
- Útil para encontrar registros "huérfanos" o generar reportes completos

SINTAXIS:
SELECT columnas
FROM tabla_izquierda
LEFT JOIN tabla_derecha ON tabla_izquierda.columna = tabla_derecha.columna;

CUÁNDO USAR LEFT JOIN:
- Cuando necesitas TODOS los registros de la tabla principal
- Para encontrar registros sin relaciones (usando WHERE columna_derecha IS NULL)
- Para generar reportes completos con valores por defecto para datos faltantes
- Para conteos que incluyan ceros (departamentos sin empleados, etc.)

DIFERENCIA CON INNER JOIN:
- INNER JOIN: Solo coincidencias (restrictivo)
- LEFT JOIN: Tabla izquierda completa + coincidencias (inclusivo)
*/

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================