-- =============================================
-- 7.03_RIGHT_JOIN.sql
-- =============================================
-- Ejemplos de uso de RIGHT JOIN (RIGHT OUTER JOIN) en consultas multitabla
-- Incluye: RIGHT JOIN básico, comparación con LEFT JOIN, y casos prácticos.

-- CREACIÓN COMPLETA DE TABLAS Y DATOS
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

-- Datos de departamentos (incluyendo departamentos sin empleados)
INSERT INTO departamentos (nombre_dept, ubicacion) VALUES
('Ventas', 'Madrid'),
('Marketing', 'Barcelona'),
('IT', 'Valencia'),
('Recursos Humanos', 'Sevilla'),
('Finanzas', 'Bilbao'),
('Investigación', 'Granada'), -- Departamento sin empleados
('Legal', 'Toledo'), -- Departamento sin empleados
('Calidad', 'Santander'),
('Logística', 'Zaragoza'),
('Desarrollo', 'Murcia'); -- Departamento adicional sin empleados

-- Datos de empleados básicos (incluyendo empleados sin departamento)
INSERT INTO empleados (nombre, salario, id_departamento) VALUES
('Ana García', 1800, 1),
('Luis Pérez', 2000, 2),
('Marta Ruiz', 2200, 1),
('Pedro López', 2500, 3),
('Lucía Gómez', 2100, 3),
('Carmen Silva', 1900, NULL), -- Empleado sin departamento
('Roberto Díaz', 2300, NULL),  -- Empleado sin departamento
('Sandra Martín', 1950, NULL), -- Empleado sin departamento
('Elena Vázquez', 2400, 4),
('Diego Moreno', 1850, 5);

-- Datos de proyectos (incluyendo proyectos en departamentos sin empleados)
INSERT INTO proyectos (nombre_proyecto, presupuesto, id_departamento) VALUES
('Campaña Primavera', 50000, 1),
('Web Corporativa', 75000, 3),
('App Móvil', 120000, 3),
('Evento Anual', 30000, 2),
('Auditoría Anual', 25000, 5),
('Consulta Legal', 15000, 7), -- Proyecto en departamento sin empleados
('Sistema Calidad', 45000, 8),
('Optimización Logística', 60000, 9),
('Proyecto Investigación', 80000, 6), -- Proyecto en departamento sin empleados
('Proyecto Desarrollo', 95000, 10); -- Proyecto en departamento sin empleados

-- Datos de empleados con jerarquía
INSERT INTO empleados_jerarquia (nombre, puesto, salario, id_jefe, id_departamento, fecha_contratacion) VALUES
('Carlos Director', 'Director General', 5000, NULL, 1, '2020-01-01'),
('Ana Gerente', 'Gerente Ventas', 3500, 1, 1, '2020-03-15'),
('Luis Supervisor', 'Supervisor', 2800, 2, 1, '2021-01-10'),
('Marta Vendedor', 'Vendedor', 2200, 3, 1, '2021-06-01'),
('Pedro Vendedor', 'Vendedor', 2100, 3, 1, '2021-08-15'),
('Elena Gerente', 'Gerente IT', 3800, 1, 3, '2020-05-20'),
('Diego Programador', 'Programador Senior', 3200, 6, 3, '2021-02-01'),
('Sofia Programador', 'Programador Junior', 2400, 7, 3, '2022-01-15'),
('Carmen Gerente', 'Gerente Marketing', 3600, 1, 2, '2020-06-10'),
('Roberto Especialista', 'Especialista Marketing', 2800, 9, 2, '2021-03-20');



-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================

-- *** EJERCICIOS BÁSICOS CON RIGHT JOIN (1-10) ***
-- 1) Muestra todos los departamentos con sus empleados (incluye departamentos sin empleados) usando RIGHT JOIN.
-- 2) Muestra todos los departamentos con sus proyectos (incluye departamentos sin proyectos) usando RIGHT JOIN.
-- 3) Equivalencia: muestra la diferencia entre LEFT JOIN y RIGHT JOIN con el mismo resultado.
-- 4) Muestra todos los proyectos con información del departamento usando RIGHT JOIN.
-- 5) Encuentra departamentos sin empleados usando RIGHT JOIN.
-- 6) Encuentra departamentos sin proyectos usando RIGHT JOIN.
-- 7) Muestra el presupuesto total por departamento usando RIGHT JOIN.
-- 8) Muestra todos los empleados y proyectos de su departamento usando RIGHT JOIN desde proyectos.
-- 9) Comparación: misma consulta con LEFT JOIN y RIGHT JOIN intercambiando tablas.
-- 10) Muestra todos los departamentos con conteo de empleados usando RIGHT JOIN.

-- *** EJERCICIOS AVANZADOS CON RIGHT JOIN (11-20) ***
-- 11) Calcula estadísticas salariales por departamento usando RIGHT JOIN y funciones de agregación.
-- 12) Muestra proyectos únicos (DISTINCT) con información del departamento usando RIGHT JOIN.
-- 13) Calcula el total de empleados y presupuesto por departamento con RIGHT JOIN.
-- 14) Muestra departamentos con presupuestos calculados y clasificación usando RIGHT JOIN.
-- 15) Clasifica departamentos según actividad: con/sin empleados, con/sin proyectos usando CASE.
-- 16) Usa COALESCE y IFNULL para manejar información faltante en RIGHT JOIN.
-- 17) Encuentra departamentos con presupuesto superior al promedio usando RIGHT JOIN y subconsultas.
-- 18) Compara eficiencia: empleados por proyecto usando RIGHT JOIN y campos calculados.
-- 19) Análisis completo: departamentos con ratios y métricas usando RIGHT JOIN.
-- 20) Identifica departamentos con necesidades de recursos usando RIGHT JOIN y múltiples condiciones.

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================

-- *** SOLUCIONES EJERCICIOS BÁSICOS (1-10) ***

-- 1) Muestra todos los departamentos con sus empleados (incluye departamentos sin empleados) usando RIGHT JOIN.
SELECT d.nombre_dept, e.nombre 
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- 2) Muestra todos los departamentos con sus proyectos (incluye departamentos sin proyectos) usando RIGHT JOIN.
SELECT d.nombre_dept, p.nombre_proyecto 
FROM proyectos p 
RIGHT JOIN departamentos d ON p.id_departamento = d.id_departamento;

-- 3) Equivalencia: muestra la diferencia entre LEFT JOIN y RIGHT JOIN con el mismo resultado.
-- LEFT JOIN: departamentos LEFT JOIN empleados
SELECT 'LEFT JOIN - Departamentos LEFT JOIN Empleados:' AS tipo_consulta;
SELECT d.nombre_dept, e.nombre 
FROM departamentos d 
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento;

-- RIGHT JOIN: empleados RIGHT JOIN departamentos (mismo resultado que arriba)
SELECT 'RIGHT JOIN - Empleados RIGHT JOIN Departamentos:' AS tipo_consulta;
SELECT d.nombre_dept, e.nombre 
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- 4) Muestra todos los proyectos con información del departamento usando RIGHT JOIN.
SELECT p.nombre_proyecto, p.presupuesto, d.nombre_dept 
FROM departamentos d 
RIGHT JOIN proyectos p ON d.id_departamento = p.id_departamento;

-- 5) Encuentra departamentos sin empleados usando RIGHT JOIN.
SELECT d.nombre_dept, d.ubicacion 
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE e.id_departamento IS NULL;

-- 6) Encuentra departamentos sin proyectos usando RIGHT JOIN.
SELECT d.nombre_dept, d.ubicacion 
FROM proyectos p 
RIGHT JOIN departamentos d ON p.id_departamento = d.id_departamento
WHERE p.id_departamento IS NULL;

-- 7) Muestra el presupuesto total por departamento usando RIGHT JOIN.
SELECT d.nombre_dept, COALESCE(SUM(p.presupuesto), 0) AS total_presupuesto 
FROM proyectos p 
RIGHT JOIN departamentos d ON p.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nombre_dept;

-- 8) Muestra todos los empleados y proyectos de su departamento usando RIGHT JOIN desde proyectos.
SELECT p.nombre_proyecto, d.nombre_dept, e.nombre AS empleado
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
RIGHT JOIN proyectos p ON d.id_departamento = p.id_departamento;

-- 9) Comparación: misma consulta con LEFT JOIN y RIGHT JOIN intercambiando tablas.
SELECT 'Con LEFT JOIN:' AS metodo;
SELECT d.nombre_dept, COUNT(e.id_empleado) AS num_empleados
FROM departamentos d 
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
GROUP BY d.id_departamento, d.nombre_dept;

SELECT 'Con RIGHT JOIN (mismo resultado):' AS metodo;
SELECT d.nombre_dept, COUNT(e.id_empleado) AS num_empleados
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nombre_dept;

-- 10) Muestra todos los departamentos con conteo de empleados usando RIGHT JOIN.
SELECT d.nombre_dept, d.ubicacion, COUNT(e.id_empleado) AS num_empleados 
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion
ORDER BY num_empleados DESC;

-- *** SOLUCIONES EJERCICIOS AVANZADOS (11-20) ***

-- 11) Calcula estadísticas salariales por departamento usando RIGHT JOIN y funciones de agregación.
SELECT 
    d.nombre_dept,
    d.ubicacion,
    COUNT(e.id_empleado) AS num_empleados,
    COALESCE(AVG(e.salario), 0) AS salario_promedio,
    COALESCE(MAX(e.salario), 0) AS salario_maximo,
    COALESCE(MIN(e.salario), 0) AS salario_minimo,
    COALESCE(SUM(e.salario), 0) AS masa_salarial_total
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion
ORDER BY salario_promedio DESC;

-- 12) Muestra proyectos únicos (DISTINCT) con información del departamento usando RIGHT JOIN.
SELECT DISTINCT
    p.nombre_proyecto,
    p.presupuesto,
    COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
    COALESCE(d.ubicacion, 'Sin Ubicación') AS ubicacion,
    CASE 
        WHEN p.presupuesto > 50000 THEN 'Alto'
        WHEN p.presupuesto > 25000 THEN 'Medio'
        ELSE 'Bajo'
    END AS categoria_presupuesto
FROM departamentos d 
RIGHT JOIN proyectos p ON d.id_departamento = p.id_departamento
ORDER BY p.presupuesto DESC;

-- 13) Calcula el total de empleados y presupuesto por departamento con RIGHT JOIN.
SELECT 
    d.nombre_dept,
    COUNT(DISTINCT e.id_empleado) AS total_empleados,
    COUNT(DISTINCT p.id_proyecto) AS total_proyectos,
    COALESCE(SUM(e.salario), 0) AS costo_empleados,
    COALESCE(SUM(p.presupuesto), 0) AS presupuesto_proyectos,
    COALESCE(SUM(e.salario), 0) + COALESCE(SUM(p.presupuesto), 0) AS costo_total_departamento
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept
ORDER BY costo_total_departamento DESC;

-- 14) Muestra departamentos con presupuestos calculados y clasificación usando RIGHT JOIN.
SELECT 
    d.nombre_dept,
    d.ubicacion,
    COALESCE(SUM(p.presupuesto), 0) AS presupuesto_total,
    COUNT(p.id_proyecto) AS num_proyectos,
    CASE 
        WHEN COUNT(p.id_proyecto) = 0 THEN 'Sin Proyectos'
        WHEN SUM(p.presupuesto) > 100000 THEN 'Alto Presupuesto'
        WHEN SUM(p.presupuesto) > 50000 THEN 'Presupuesto Medio'
        ELSE 'Presupuesto Bajo'
    END AS categoria_presupuesto,
    CASE 
        WHEN COUNT(p.id_proyecto) > 0 THEN SUM(p.presupuesto) / COUNT(p.id_proyecto)
        ELSE 0
    END AS presupuesto_promedio_proyecto
FROM proyectos p 
RIGHT JOIN departamentos d ON p.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion
ORDER BY presupuesto_total DESC;

-- 15) Clasifica departamentos según actividad: con/sin empleados, con/sin proyectos usando CASE.
SELECT 
    d.nombre_dept,
    d.ubicacion,
    COUNT(DISTINCT e.id_empleado) AS num_empleados,
    COUNT(DISTINCT p.id_proyecto) AS num_proyectos,
    CASE 
        WHEN COUNT(DISTINCT e.id_empleado) > 0 AND COUNT(DISTINCT p.id_proyecto) > 0 
        THEN 'ACTIVO: Con empleados y proyectos'
        WHEN COUNT(DISTINCT e.id_empleado) > 0 AND COUNT(DISTINCT p.id_proyecto) = 0 
        THEN 'PARCIAL: Solo empleados'
        WHEN COUNT(DISTINCT e.id_empleado) = 0 AND COUNT(DISTINCT p.id_proyecto) > 0 
        THEN 'PARCIAL: Solo proyectos'
        ELSE 'INACTIVO: Sin empleados ni proyectos'
    END AS estado_actividad,
    IF(COUNT(DISTINCT e.id_empleado) > 0 OR COUNT(DISTINCT p.id_proyecto) > 0, 'Operativo', 'Sin Actividad') AS operatividad
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion
ORDER BY num_empleados DESC, num_proyectos DESC;

-- 16) Usa COALESCE y IFNULL para manejar información faltante en RIGHT JOIN.
SELECT 
    d.nombre_dept,
    COALESCE(d.ubicacion, 'Ubicación No Definida') AS ubicacion,
    COALESCE(e.nombre, 'Sin Empleados') AS empleado,
    COALESCE(e.salario, 0) AS salario,
    IFNULL(p.nombre_proyecto, 'Sin Proyectos') AS proyecto,
    IFNULL(p.presupuesto, 0) AS presupuesto,
    NULLIF(COUNT(e.id_empleado), 0) AS empleados_count,  -- Convierte 0 a NULL
    NULLIF(COUNT(p.id_proyecto), 0) AS proyectos_count   -- Convierte 0 a NULL
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion, e.id_empleado, e.nombre, e.salario, p.id_proyecto, p.nombre_proyecto, p.presupuesto
ORDER BY d.nombre_dept;

-- 17) Encuentra departamentos con presupuesto superior al promedio usando RIGHT JOIN y subconsultas.
SELECT 
    d.nombre_dept,
    d.ubicacion,
    COALESCE(SUM(p.presupuesto), 0) AS presupuesto_total,
    (SELECT AVG(presupuesto_dept) FROM (
        SELECT SUM(p2.presupuesto) AS presupuesto_dept 
        FROM proyectos p2 
        GROUP BY p2.id_departamento
    ) AS promedios) AS promedio_general,
    CASE 
        WHEN SUM(p.presupuesto) > (
            SELECT AVG(presupuesto_dept) FROM (
                SELECT SUM(p3.presupuesto) AS presupuesto_dept 
                FROM proyectos p3 
                GROUP BY p3.id_departamento
            ) AS promedios2
        ) THEN 'Presupuesto Superior'
        WHEN SUM(p.presupuesto) IS NULL THEN 'Sin Proyectos'
        ELSE 'Presupuesto Inferior'
    END AS comparacion_presupuesto
FROM proyectos p 
RIGHT JOIN departamentos d ON p.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion
ORDER BY presupuesto_total DESC;

-- 18) Compara eficiencia: empleados por proyecto usando RIGHT JOIN y campos calculados.
SELECT 
    d.nombre_dept,
    COUNT(DISTINCT e.id_empleado) AS total_empleados,
    COUNT(DISTINCT p.id_proyecto) AS total_proyectos,
    COALESCE(SUM(p.presupuesto), 0) AS presupuesto_total,
    CASE 
        WHEN COUNT(DISTINCT p.id_proyecto) = 0 THEN 0
        ELSE ROUND(COUNT(DISTINCT e.id_empleado) / COUNT(DISTINCT p.id_proyecto), 2)
    END AS empleados_por_proyecto,
    CASE 
        WHEN COUNT(DISTINCT e.id_empleado) = 0 THEN 0
        ELSE ROUND(COALESCE(SUM(p.presupuesto), 0) / COUNT(DISTINCT e.id_empleado), 2)
    END AS presupuesto_por_empleado,
    CASE 
        WHEN COUNT(DISTINCT e.id_empleado) = 0 AND COUNT(DISTINCT p.id_proyecto) = 0 THEN 'Sin Recursos'
        WHEN COUNT(DISTINCT e.id_empleado) / NULLIF(COUNT(DISTINCT p.id_proyecto), 0) > 2 THEN 'Sobredimensionado'
        WHEN COUNT(DISTINCT e.id_empleado) / NULLIF(COUNT(DISTINCT p.id_proyecto), 0) < 1 THEN 'Subdimensionado'
        ELSE 'Equilibrado'
    END AS evaluacion_eficiencia
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept
ORDER BY empleados_por_proyecto DESC;

-- 19) Análisis completo: departamentos con ratios y métricas usando RIGHT JOIN.
SELECT 
    d.nombre_dept AS departamento,
    d.ubicacion,
    COUNT(DISTINCT e.id_empleado) AS empleados,
    COUNT(DISTINCT p.id_proyecto) AS proyectos,
    COALESCE(AVG(e.salario), 0) AS salario_promedio,
    COALESCE(SUM(p.presupuesto), 0) AS presupuesto_total,
    -- Ratios calculados
    ROUND(
        CASE 
            WHEN COUNT(DISTINCT p.id_proyecto) = 0 THEN 0
            ELSE COUNT(DISTINCT e.id_empleado) / COUNT(DISTINCT p.id_proyecto)
        END, 2
    ) AS ratio_empleados_proyectos,
    ROUND(
        CASE 
            WHEN COUNT(DISTINCT e.id_empleado) = 0 THEN 0
            ELSE COALESCE(SUM(p.presupuesto), 0) / COUNT(DISTINCT e.id_empleado)
        END, 2
    ) AS presupuesto_per_capita,
    -- Índice de productividad (presupuesto / empleados / proyectos)
    ROUND(
        CASE 
            WHEN COUNT(DISTINCT e.id_empleado) = 0 OR COUNT(DISTINCT p.id_proyecto) = 0 THEN 0
            ELSE COALESCE(SUM(p.presupuesto), 0) / (COUNT(DISTINCT e.id_empleado) * COUNT(DISTINCT p.id_proyecto))
        END, 2
    ) AS indice_productividad,
    -- Clasificación final
    CASE 
        WHEN COUNT(DISTINCT e.id_empleado) = 0 AND COUNT(DISTINCT p.id_proyecto) = 0 THEN 'CRÍTICO'
        WHEN COUNT(DISTINCT e.id_empleado) > 0 AND COUNT(DISTINCT p.id_proyecto) > 0 AND 
             COALESCE(SUM(p.presupuesto), 0) / (COUNT(DISTINCT e.id_empleado) * COUNT(DISTINCT p.id_proyecto)) > 1000 THEN 'EXCELENTE'
        WHEN COUNT(DISTINCT e.id_empleado) > 0 AND COUNT(DISTINCT p.id_proyecto) > 0 THEN 'BUENO'
        ELSE 'REGULAR'
    END AS calificacion_general
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion
ORDER BY indice_productividad DESC, presupuesto_total DESC;

-- 20) Identifica departamentos con necesidades de recursos usando RIGHT JOIN y múltiples condiciones.
SELECT 
    d.nombre_dept,
    d.ubicacion,
    COUNT(DISTINCT e.id_empleado) AS empleados_actuales,
    COUNT(DISTINCT p.id_proyecto) AS proyectos_actuales,
    COALESCE(SUM(p.presupuesto), 0) AS presupuesto_disponible,
    -- Análisis de necesidades
    CASE 
        WHEN COUNT(DISTINCT p.id_proyecto) > COUNT(DISTINCT e.id_empleado) * 2 
        THEN CONCAT('Necesita ', (COUNT(DISTINCT p.id_proyecto) - COUNT(DISTINCT e.id_empleado)), ' empleados más')
        WHEN COUNT(DISTINCT e.id_empleado) > COUNT(DISTINCT p.id_proyecto) * 3 
        THEN 'Exceso de empleados, necesita más proyectos'
        WHEN COUNT(DISTINCT e.id_empleado) = 0 AND COUNT(DISTINCT p.id_proyecto) > 0 
        THEN 'URGENTE: Proyectos sin empleados asignados'
        WHEN COUNT(DISTINCT e.id_empleado) > 0 AND COUNT(DISTINCT p.id_proyecto) = 0 
        THEN 'Empleados sin proyectos activos'
        ELSE 'Recursos equilibrados'
    END AS analisis_recursos,
    -- Prioridad de atención
    CASE 
        WHEN COUNT(DISTINCT e.id_empleado) = 0 AND COUNT(DISTINCT p.id_proyecto) > 0 THEN 1
        WHEN COUNT(DISTINCT p.id_proyecto) > COUNT(DISTINCT e.id_empleado) * 2 THEN 2
        WHEN COUNT(DISTINCT e.id_empleado) = 0 AND COUNT(DISTINCT p.id_proyecto) = 0 THEN 3
        WHEN COUNT(DISTINCT e.id_empleado) > 0 AND COUNT(DISTINCT p.id_proyecto) = 0 THEN 4
        ELSE 5
    END AS prioridad_atencion,
    -- Recomendación específica
    CASE 
        WHEN COUNT(DISTINCT e.id_empleado) = 0 AND COUNT(DISTINCT p.id_proyecto) > 0 
        THEN 'Asignar empleados inmediatamente'
        WHEN COUNT(DISTINCT p.id_proyecto) > COUNT(DISTINCT e.id_empleado) * 2 
        THEN 'Contratar personal adicional'
        WHEN COUNT(DISTINCT e.id_empleado) = 0 AND COUNT(DISTINCT p.id_proyecto) = 0 
        THEN 'Evaluar cierre o reestructuración'
        WHEN COUNT(DISTINCT e.id_empleado) > 0 AND COUNT(DISTINCT p.id_proyecto) = 0 
        THEN 'Asignar nuevos proyectos'
        ELSE 'Mantener estructura actual'
    END AS recomendacion
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion
ORDER BY prioridad_atencion, presupuesto_disponible DESC;

-- 7) Muestra el presupuesto total por departamento (incluye departamentos sin proyectos) con RIGHT JOIN.
SELECT d.nombre_dept, COALESCE(SUM(p.presupuesto), 0) AS total_presupuesto 
FROM proyectos p 
RIGHT JOIN departamentos d ON p.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nombre_dept;

-- 8) Muestra todos los empleados y proyectos de su departamento usando RIGHT JOIN desde proyectos.
-- Aquí RIGHT JOIN nos da todos los proyectos, algunos pueden no tener empleados en su departamento
SELECT e.nombre AS empleado, p.nombre_proyecto, d.nombre_dept 
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
RIGHT JOIN proyectos p ON d.id_departamento = p.id_departamento;

-- 9) Comparación: misma consulta con LEFT JOIN y RIGHT JOIN intercambiando tablas.
-- Consulta A: Departamentos LEFT JOIN Empleados
SELECT 'A: Departamentos LEFT JOIN Empleados' AS consulta;
SELECT d.nombre_dept, COUNT(e.id_empleado) AS num_empleados 
FROM departamentos d 
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
GROUP BY d.id_departamento, d.nombre_dept;

-- Consulta B: Empleados RIGHT JOIN Departamentos (resultado equivalente)
SELECT 'B: Empleados RIGHT JOIN Departamentos' AS consulta;
SELECT d.nombre_dept, COUNT(e.id_empleado) AS num_empleados 
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nombre_dept;

-- 10) Muestra todos los departamentos con conteo de empleados y proyectos usando RIGHT JOIN.
SELECT 
    d.nombre_dept,
    COUNT(DISTINCT e.id_empleado) AS num_empleados,
    COUNT(DISTINCT p.id_proyecto) AS num_proyectos
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept;

-- =============================================
-- COMPARACIONES DETALLADAS: LEFT vs RIGHT JOIN
-- =============================================

-- Ejemplo 1: Empleados y Departamentos
SELECT '=== COMPARACIÓN: Empleados y Departamentos ===' AS seccion;

-- LEFT JOIN: Todos los empleados (algunos sin departamento)
SELECT 'LEFT JOIN - Todos los empleados:' AS tipo;
SELECT e.nombre, COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento 
FROM empleados e 
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY e.nombre;

-- RIGHT JOIN: Todos los departamentos (algunos sin empleados)
SELECT 'RIGHT JOIN - Todos los departamentos:' AS tipo;
SELECT COALESCE(e.nombre, 'Sin Empleados') AS empleado, d.nombre_dept 
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY d.nombre_dept;

-- Ejemplo 2: Proyectos y Departamentos
SELECT '=== COMPARACIÓN: Proyectos y Departamentos ===' AS seccion;

-- LEFT JOIN: Todos los proyectos (todos tienen departamento en este caso)
SELECT 'LEFT JOIN - Todos los proyectos:' AS tipo;
SELECT p.nombre_proyecto, d.nombre_dept 
FROM proyectos p 
LEFT JOIN departamentos d ON p.id_departamento = d.id_departamento
ORDER BY p.nombre_proyecto;

-- RIGHT JOIN: Todos los departamentos (algunos sin proyectos)
SELECT 'RIGHT JOIN - Todos los departamentos:' AS tipo;
SELECT COALESCE(p.nombre_proyecto, 'Sin Proyectos') AS proyecto, d.nombre_dept 
FROM proyectos p 
RIGHT JOIN departamentos d ON p.id_departamento = d.id_departamento
ORDER BY d.nombre_dept;

-- =============================================
-- CASOS PRÁCTICOS: CUÁNDO USAR RIGHT JOIN
-- =============================================

-- Caso 1: Reporte de departamentos completo (todos los departamentos deben aparecer)
SELECT 'CASO 1: Reporte completo de departamentos' AS caso;
SELECT 
    d.nombre_dept,
    d.ubicacion,
    COUNT(DISTINCT e.id_empleado) AS total_empleados,
    COALESCE(AVG(e.salario), 0) AS salario_promedio,
    COUNT(DISTINCT p.id_proyecto) AS total_proyectos,
    COALESCE(SUM(p.presupuesto), 0) AS presupuesto_total
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion
ORDER BY d.nombre_dept;

-- Caso 2: Auditoría - departamentos que necesitan atención (sin empleados o sin proyectos)
SELECT 'CASO 2: Departamentos que necesitan atención' AS caso;
SELECT 
    d.nombre_dept,
    CASE 
        WHEN COUNT(DISTINCT e.id_empleado) = 0 AND COUNT(DISTINCT p.id_proyecto) = 0 
        THEN 'Sin empleados ni proyectos'
        WHEN COUNT(DISTINCT e.id_empleado) = 0 
        THEN 'Sin empleados'
        WHEN COUNT(DISTINCT p.id_proyecto) = 0 
        THEN 'Sin proyectos'
        ELSE 'Activo'
    END AS estado
FROM empleados e 
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept
HAVING estado != 'Activo';

-- =============================================
-- ERRORES COMUNES CON RIGHT JOIN
-- =============================================

-- Error: Confundir qué tabla es la "derecha"
-- En: FROM tabla_A RIGHT JOIN tabla_B
-- tabla_B es la tabla derecha (la que aporta TODOS sus registros)
-- tabla_A es la tabla izquierda (la que puede tener NULLs)

-- Error: No entender la equivalencia
-- ESTAS DOS CONSULTAS SON EQUIVALENTES:
-- SELECT * FROM A LEFT JOIN B ON A.id = B.id;
-- SELECT * FROM B RIGHT JOIN A ON B.id = A.id;

-- =============================================
-- CONCEPTOS CLAVE DEL RIGHT JOIN
-- =============================================
/*
RIGHT JOIN (RIGHT OUTER JOIN):
- Devuelve TODAS las filas de la tabla derecha (después de RIGHT JOIN)
- Incluye filas de la tabla izquierda que coinciden
- Para filas sin coincidencias en la tabla izquierda, rellena con NULL
- Es el "espejo" del LEFT JOIN

SINTAXIS:
SELECT columnas
FROM tabla_izquierda
RIGHT JOIN tabla_derecha ON tabla_izquierda.columna = tabla_derecha.columna;

EQUIVALENCIA IMPORTANTE:
A LEFT JOIN B ≡ B RIGHT JOIN A

CUÁNDO USAR RIGHT JOIN:
- Cuando la lógica de la consulta se lee más naturalmente con RIGHT JOIN
- En algunos casos específicos donde el orden de las tablas ya está establecido
- Para mostrar TODOS los registros de una tabla específica cuando está en posición derecha

RECOMENDACIÓN:
- LEFT JOIN es más común y legible en la mayoría de casos
- RIGHT JOIN se usa menos frecuentemente
- Muchos desarrolladores prefieren reorganizar las tablas para usar LEFT JOIN
*/

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================