-- =============================================
-- 7.07_SELF_JOIN.sql
-- =============================================
-- Ejemplos de uso de SELF JOIN en consultas multitabla
-- Incluye: auto-referencias, jerarquías organizacionales, y análisis de relaciones internas.

-- CREACIÓN COMPLETA DE TABLAS Y DATOS
DROP DATABASE IF EXISTS ejemplo_auto_joins;
CREATE DATABASE ejemplo_auto_joins;
USE ejemplo_auto_joins;

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

-- Tabla de empleados con jerarquía (principal para SELF JOIN)
CREATE TABLE empleados_jerarquia (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    puesto VARCHAR(50),
    salario DECIMAL(10,2),
    id_jefe INT,
    id_departamento INT,
    fecha_contratacion DATE,
    FOREIGN KEY (id_jefe) REFERENCES empleados_jerarquia(id_empleado),
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

-- Tabla de productos para ejemplos complejos

-- =============================================
-- INSERCIÓN DE DATOS COMPLETA
-- =============================================

-- Datos de departamentos
INSERT INTO departamentos (nombre_dept, ubicacion) VALUES
('Ventas', 'Madrid'),
('Marketing', 'Barcelona'),
('IT', 'Valencia'),
('Recursos Humanos', 'Sevilla'),
('Finanzas', 'Bilbao'),
('Investigación', 'Granada'),
('Legal', 'Toledo'),
('Calidad', 'Santander'),
('Logística', 'Zaragoza'),
('Desarrollo', 'Murcia');

-- Datos de empleados básicos
INSERT INTO empleados (nombre, salario, id_departamento) VALUES
('Ana García', 1800, 1),
('Luis Pérez', 2000, 2),
('Marta Ruiz', 2200, 1),
('Pedro López', 2500, 3),
('Lucía Gómez', 2100, 3),
('Carmen Silva', 1900, 4),
('Roberto Díaz', 2300, 5),
('Sandra Martín', 1950, 4),
('Elena Vázquez', 2400, 3),
('Diego Moreno', 1850, 5);

-- Datos de proyectos
INSERT INTO proyectos (nombre_proyecto, presupuesto, id_departamento) VALUES
('Campaña Primavera', 50000, 1),
('Web Corporativa', 75000, 3),
('App Móvil', 120000, 3),
('Evento Anual', 30000, 2),
('Auditoría Anual', 25000, 5),
('Consulta Legal', 15000, 7),
('Sistema Calidad', 45000, 8),
('Optimización Logística', 60000, 9),
('Proyecto Investigación', 80000, 6),
('Proyecto Desarrollo', 95000, 10);

-- Datos específicos para SELF JOIN - Empleados con jerarquía completa
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
('Roberto Especialista', 'Especialista Marketing', 2800, 9, 2, '2021-03-20'),
('María Supervisor', 'Supervisor RRHH', 3200, 1, 4, '2020-07-01'),
('José Analista', 'Analista RRHH', 2600, 11, 4, '2021-04-15'),
('Laura Gerente', 'Gerente Finanzas', 3700, 1, 5, '2020-04-01'),
('Antonio Contable', 'Contable Senior', 2900, 13, 5, '2021-01-20'),
('Patricia Asistente', 'Asistente Contable', 2300, 14, 5, '2021-09-10');

-- Datos de productos

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================

-- *** EJERCICIOS BÁSICOS CON SELF JOIN (1-10) ***
-- 1) SELF JOIN: Muestra cada empleado, con su puesto y con el nombre de su jefe.
-- 2) SELF JOIN: Muestra todos los subordinados de cada jefe.
-- 3) SELF JOIN: Encuentra empleados que ganan más que su jefe.
-- 4) SELF JOIN jerárquico: Muestra la cadena de jefes de cada empleado (hasta 3 niveles).
-- 5) SELF JOIN: Comparar empleados del mismo departamento.
-- 6) SELF JOIN: Empleados contratados en el mismo año.
-- 7) SELF JOIN: Empleados con diferencia salarial mínima en el mismo puesto.
-- 8) SELF JOIN: Mostrar empleados sin subordinados (hojas del árbol organizacional).
-- 9) SELF JOIN: Contar subordinados directos por jefe.
-- 10) SELF JOIN: Empleados que trabajan para jefes de otro departamento.

-- *** EJERCICIOS AVANZADOS CON SELF JOIN (11-20) ***
-- 11) SELF JOIN recursivo: Jerarquía organizacional completa con niveles.
-- 12) SELF JOIN con DISTINCT: Análisis único de relaciones jerárquicas.
-- 13) SELF JOIN con agregaciones: Estadísticas por niveles organizacionales.
-- 14) SELF JOIN con campos calculados: Rendimiento y comisiones por jerarquía.
-- 15) SELF JOIN con CASE: Clasificación jerárquica y análisis de equipos.
-- 16) SELF JOIN con COALESCE: Manejo de datos faltantes en estructuras jerárquicas.
-- 17) SELF JOIN con subconsultas: Análisis comparativo por niveles organizacionales.
-- 18) SELF JOIN optimizado: Análisis de rendimiento en estructuras jerárquicas complejas.
-- 19) SELF JOIN integral: Dashboard organizacional con métricas jerárquicas completas.
-- 20) SELF JOIN avanzado: Análisis de red organizacional y influencia.

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================

-- *** SOLUCIONES EJERCICIOS BÁSICOS (1-10) ***

-- 1) SELF JOIN: Muestra cada empleado, con su puesto y con el nombre de su jefe.
SELECT 
    emp.nombre AS empleado,
    emp.puesto,
    COALESCE(jefe.nombre, 'Sin Jefe') AS jefe
FROM empleados_jerarquia emp
LEFT JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
ORDER BY emp.nombre;

-- 2) SELF JOIN: Muestra todos los subordinados de cada jefe.
SELECT 
    jefe.nombre AS jefe,
    jefe.puesto AS puesto_jefe,
    emp.nombre AS subordinado,
    emp.puesto AS puesto_subordinado
FROM empleados_jerarquia jefe
INNER JOIN empleados_jerarquia emp ON jefe.id_empleado = emp.id_jefe
ORDER BY jefe.nombre, emp.nombre;

-- 3) SELF JOIN: Encuentra empleados que ganan más que su jefe.
SELECT 
    emp.nombre AS empleado,
    emp.salario AS salario_empleado,
    jefe.nombre AS jefe,
    jefe.salario AS salario_jefe,
    (emp.salario - jefe.salario) AS diferencia
FROM empleados_jerarquia emp
INNER JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
WHERE emp.salario > jefe.salario
ORDER BY diferencia DESC;

-- 4) SELF JOIN jerárquico: Muestra la cadena de jefes de cada empleado (hasta 3 niveles).
SELECT 
    emp.nombre AS empleado,
    emp.puesto,
    COALESCE(jefe1.nombre, 'Sin Jefe') AS jefe_directo,
    COALESCE(jefe2.nombre, 'N/A') AS jefe_del_jefe,
    COALESCE(jefe3.nombre, 'N/A') AS director_general
FROM empleados_jerarquia emp
LEFT JOIN empleados_jerarquia jefe1 ON emp.id_jefe = jefe1.id_empleado
LEFT JOIN empleados_jerarquia jefe2 ON jefe1.id_jefe = jefe2.id_empleado  
LEFT JOIN empleados_jerarquia jefe3 ON jefe2.id_jefe = jefe3.id_empleado
ORDER BY emp.nombre;

-- 5) SELF JOIN: Comparar empleados del mismo departamento.
SELECT 
    emp1.nombre AS empleado1,
    emp1.salario AS salario1,
    emp2.nombre AS empleado2,
    emp2.salario AS salario2,
    d.nombre_dept AS departamento,
    ABS(emp1.salario - emp2.salario) AS diferencia_salarial
FROM empleados_jerarquia emp1
INNER JOIN empleados_jerarquia emp2 ON emp1.id_departamento = emp2.id_departamento 
    AND emp1.id_empleado < emp2.id_empleado
INNER JOIN departamentos d ON emp1.id_departamento = d.id_departamento
ORDER BY d.nombre_dept, diferencia_salarial DESC;

-- 6) SELF JOIN: Empleados contratados en el mismo año.
SELECT 
    emp1.nombre AS empleado1,
    emp1.fecha_contratacion AS fecha1,
    emp2.nombre AS empleado2,
    emp2.fecha_contratacion AS fecha2,
    YEAR(emp1.fecha_contratacion) AS año_contratacion,
    DATEDIFF(emp1.fecha_contratacion, emp2.fecha_contratacion) AS diferencia_dias
FROM empleados_jerarquia emp1
INNER JOIN empleados_jerarquia emp2 ON YEAR(emp1.fecha_contratacion) = YEAR(emp2.fecha_contratacion)
    AND emp1.id_empleado < emp2.id_empleado
ORDER BY año_contratacion, diferencia_dias;

-- 7) SELF JOIN: Empleados con diferencia salarial mínima en el mismo puesto.
SELECT 
    emp1.nombre AS empleado1,
    emp1.salario AS salario1,
    emp2.nombre AS empleado2,
    emp2.salario AS salario2,
    emp1.puesto,
    ABS(emp1.salario - emp2.salario) AS diferencia_salarial
FROM empleados_jerarquia emp1
INNER JOIN empleados_jerarquia emp2 ON emp1.puesto = emp2.puesto
    AND emp1.id_empleado < emp2.id_empleado
ORDER BY emp1.puesto, diferencia_salarial ASC;

-- 8) SELF JOIN: Mostrar empleados sin subordinados (hojas del árbol organizacional).
SELECT 
    emp.nombre AS empleado_sin_subordinados,
    emp.puesto,
    emp.salario,
    d.nombre_dept AS departamento
FROM empleados_jerarquia emp
LEFT JOIN empleados_jerarquia subordinado ON emp.id_empleado = subordinado.id_jefe
INNER JOIN departamentos d ON emp.id_departamento = d.id_departamento
WHERE subordinado.id_jefe IS NULL
ORDER BY emp.nombre;

-- 9) SELF JOIN: Contar subordinados directos por jefe.
SELECT 
    jefe.nombre AS jefe,
    jefe.puesto,
    COUNT(subordinado.id_empleado) AS num_subordinados_directos,
    GROUP_CONCAT(subordinado.nombre SEPARATOR ', ') AS lista_subordinados
FROM empleados_jerarquia jefe
LEFT JOIN empleados_jerarquia subordinado ON jefe.id_empleado = subordinado.id_jefe
GROUP BY jefe.id_empleado, jefe.nombre, jefe.puesto
ORDER BY num_subordinados_directos DESC, jefe.nombre;

-- 10) SELF JOIN: Empleados que trabajan para jefes de otro departamento.
SELECT 
    emp.nombre AS empleado,
    emp_dept.nombre_dept AS dept_empleado,
    jefe.nombre AS jefe,
    jefe_dept.nombre_dept AS dept_jefe,
    'Estructura interdepartamental' AS observacion
FROM empleados_jerarquia emp
INNER JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
INNER JOIN departamentos emp_dept ON emp.id_departamento = emp_dept.id_departamento
INNER JOIN departamentos jefe_dept ON jefe.id_departamento = jefe_dept.id_departamento
WHERE emp.id_departamento != jefe.id_departamento
ORDER BY emp.nombre;

-- *** SOLUCIONES EJERCICIOS AVANZADOS (11-20) ***

-- 11) SELF JOIN recursivo: Jerarquía organizacional completa con niveles.
WITH RECURSIVE jerarquia AS (
    -- Caso base: empleados sin jefe (nivel 0)
    SELECT 
        id_empleado,
        nombre,
        puesto,
        id_jefe,
        0 AS nivel,
        CAST(nombre AS CHAR(1000)) AS cadena_jerarquica,
        CAST('/' AS CHAR(1000)) AS path_ids
    FROM empleados_jerarquia 
    WHERE id_jefe IS NULL
    
    UNION ALL
    
    -- Caso recursivo: empleados con jefe
    SELECT 
        emp.id_empleado,
        emp.nombre,
        emp.puesto,
        emp.id_jefe,
        j.nivel + 1,
        CAST(CONCAT(j.cadena_jerarquica, ' > ', emp.nombre) AS CHAR(1000)),
        CAST(CONCAT(j.path_ids, emp.id_empleado, '/') AS CHAR(1000))
    FROM empleados_jerarquia emp
    INNER JOIN jerarquia j ON emp.id_jefe = j.id_empleado
    WHERE j.nivel < 10  -- Prevenir recursión infinita
)
SELECT 
    nombre AS empleado,
    puesto,
    nivel,
    cadena_jerarquica,
    (SELECT COUNT(*) FROM empleados_jerarquia e WHERE e.id_jefe = jerarquia.id_empleado) AS subordinados_directos,
    CASE 
        WHEN nivel = 0 THEN 'Director'
        WHEN nivel = 1 THEN 'Gerente'
        WHEN nivel = 2 THEN 'Supervisor'
        ELSE 'Empleado'
    END AS categoria_jerarquica
FROM jerarquia
ORDER BY nivel, nombre;

-- 12) SELF JOIN con DISTINCT: Análisis único de relaciones jerárquicas.
SELECT DISTINCT
    emp.nombre AS empleado,
    emp.puesto,
    jefe.nombre AS jefe,
    d.nombre_dept AS departamento,
    CASE 
        WHEN jefe.id_empleado IS NOT NULL THEN 'Con Supervisor'
        ELSE 'Independiente'
    END AS estado_supervision,
    CASE 
        WHEN emp.id_departamento = jefe.id_departamento THEN 'Mismo Departamento'
        WHEN jefe.id_empleado IS NOT NULL THEN 'Departamento Cruzado'
        ELSE 'Sin Jefe'
    END AS tipo_relacion
FROM empleados_jerarquia emp
LEFT JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
INNER JOIN departamentos d ON emp.id_departamento = d.id_departamento
ORDER BY emp.nombre;

-- 13) SELF JOIN con agregaciones: Estadísticas por niveles organizacionales.
SELECT 
    CASE 
        WHEN emp.id_jefe IS NULL THEN 'Nivel 0 - Director'
        WHEN jefe.id_jefe IS NULL THEN 'Nivel 1 - Gerente' 
        WHEN abuelo.id_jefe IS NULL THEN 'Nivel 2 - Supervisor'
        ELSE 'Nivel 3+ - Empleado'
    END AS nivel_organizacional,
    COUNT(*) AS num_empleados,
    ROUND(AVG(emp.salario), 2) AS salario_promedio,
    MIN(emp.salario) AS salario_minimo,
    MAX(emp.salario) AS salario_maximo,
    SUM(emp.salario) AS masa_salarial_total,
    ROUND(STDDEV(emp.salario), 2) AS desviacion_salarial
FROM empleados_jerarquia emp
LEFT JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
LEFT JOIN empleados_jerarquia abuelo ON jefe.id_jefe = abuelo.id_empleado
GROUP BY nivel_organizacional
ORDER BY 
    CASE nivel_organizacional
        WHEN 'Nivel 0 - Director' THEN 0
        WHEN 'Nivel 1 - Gerente' THEN 1
        WHEN 'Nivel 2 - Supervisor' THEN 2
        ELSE 3
    END;

-- 14) SELF JOIN con campos calculados: Rendimiento y comisiones por jerarquía.
SELECT 
    emp.nombre AS empleado,
    emp.puesto,
    emp.salario AS salario_base,
    jefe.nombre AS supervisor,
    -- Cálculo de ventas
    COALESCE(SUM(v.cantidad * v.precio_unitario), 0) AS ventas_totales,
    -- Comisión base (2% de ventas)
    COALESCE(SUM(v.cantidad * v.precio_unitario), 0) * 0.02 AS comision_base,
    -- Bonificación jerárquica
    CASE 
        WHEN emp.puesto LIKE '%Gerente%' THEN emp.salario * 0.15
        WHEN emp.puesto LIKE '%Supervisor%' THEN emp.salario * 0.10
        ELSE emp.salario * 0.05
    END AS bonificacion_puesto,
    -- Bonificación por rendimiento
    CASE 
        WHEN COALESCE(SUM(v.cantidad * v.precio_unitario), 0) > 200 THEN 500
        WHEN COALESCE(SUM(v.cantidad * v.precio_unitario), 0) > 100 THEN 300
        WHEN COALESCE(SUM(v.cantidad * v.precio_unitario), 0) > 50 THEN 100
        ELSE 0
    END AS bonificacion_rendimiento,
    -- Salario total calculado
    emp.salario + 
    (COALESCE(SUM(v.cantidad * v.precio_unitario), 0) * 0.02) +
    (CASE 
        WHEN emp.puesto LIKE '%Gerente%' THEN emp.salario * 0.15
        WHEN emp.puesto LIKE '%Supervisor%' THEN emp.salario * 0.10
        ELSE emp.salario * 0.05
    END) +
    (CASE 
        WHEN COALESCE(SUM(v.cantidad * v.precio_unitario), 0) > 200 THEN 500
        WHEN COALESCE(SUM(v.cantidad * v.precio_unitario), 0) > 100 THEN 300
        WHEN COALESCE(SUM(v.cantidad * v.precio_unitario), 0) > 50 THEN 100
        ELSE 0
    END) AS salario_total_calculado
FROM empleados_jerarquia emp
LEFT JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
LEFT JOIN ventas v ON emp.id_empleado = v.id_empleado
GROUP BY emp.id_empleado, emp.nombre, emp.puesto, emp.salario, jefe.nombre
ORDER BY salario_total_calculado DESC;

-- 15) SELF JOIN con CASE: Clasificación jerárquica y análisis de equipos.
SELECT 
    jefe.nombre AS lider_equipo,
    jefe.puesto AS posicion_lider,
    COUNT(emp.id_empleado) AS tamaño_equipo,
    AVG(emp.salario) AS salario_promedio_equipo,
    SUM(COALESCE(ventas_emp.total_ventas, 0)) AS ventas_totales_equipo,
    -- Clasificación del equipo
    CASE 
        WHEN COUNT(emp.id_empleado) >= 3 AND SUM(COALESCE(ventas_emp.total_ventas, 0)) > 300 
        THEN 'EQUIPO ESTELAR: Alto rendimiento y tamaño'
        WHEN COUNT(emp.id_empleado) >= 3 
        THEN 'EQUIPO GRANDE: Necesita mejorar rendimiento'
        WHEN SUM(COALESCE(ventas_emp.total_ventas, 0)) > 200 
        THEN 'EQUIPO EFICIENTE: Alto rendimiento, pequeño'
        WHEN COUNT(emp.id_empleado) > 0 
        THEN 'EQUIPO ESTÁNDAR: Rendimiento normal'
        ELSE 'SIN EQUIPO'
    END AS clasificacion_equipo,
    -- Estilo de liderazgo recomendado
    CASE 
        WHEN AVG(emp.salario) > 3000 THEN 'Liderazgo Consultivo'
        WHEN COUNT(emp.id_empleado) > 2 THEN 'Liderazgo Directivo'
        ELSE 'Liderazgo Coaching'
    END AS estilo_liderazgo_recomendado,
    -- Necesidades del equipo
    CASE 
        WHEN COUNT(emp.id_empleado) = 0 THEN 'Necesita formar equipo'
        WHEN SUM(COALESCE(ventas_emp.total_ventas, 0)) = 0 THEN 'Necesita mejorar ventas'
        WHEN AVG(emp.salario) < 2500 THEN 'Considerar ajustes salariales'
        ELSE 'Equipo equilibrado'
    END AS recomendaciones,
    -- Puntuación de liderazgo (0-100)
    LEAST(100, 
        (COUNT(emp.id_empleado) * 20) + 
        (SUM(COALESCE(ventas_emp.total_ventas, 0)) / 10) + 
        (CASE WHEN AVG(emp.salario) > 3000 THEN 20 ELSE 10 END)
    ) AS puntuacion_liderazgo
FROM empleados_jerarquia jefe
LEFT JOIN empleados_jerarquia emp ON jefe.id_empleado = emp.id_jefe
LEFT JOIN (
    SELECT 
        id_empleado, 
        SUM(cantidad * precio_unitario) AS total_ventas
    FROM ventas 
    GROUP BY id_empleado
) ventas_emp ON emp.id_empleado = ventas_emp.id_empleado
WHERE jefe.puesto LIKE '%Gerente%' OR jefe.puesto LIKE '%Supervisor%' OR jefe.id_jefe IS NULL
GROUP BY jefe.id_empleado, jefe.nombre, jefe.puesto
ORDER BY puntuacion_liderazgo DESC;

-- 16) SELF JOIN con COALESCE: Manejo de datos faltantes en estructuras jerárquicas.
SELECT 
    COALESCE(emp.nombre, 'Empleado Desconocido') AS empleado,
    COALESCE(emp.puesto, 'Puesto No Definido') AS puesto,
    COALESCE(emp.salario, 0) AS salario,
    COALESCE(jefe.nombre, 'Sin Supervisor') AS supervisor,
    COALESCE(jefe.puesto, 'N/A') AS puesto_supervisor,
    -- Información avanzada con COALESCE
    IFNULL(emp.fecha_contratacion, 'Fecha No Registrada') AS fecha_contratacion,
    NULLIF(emp.salario, 0) AS salario_sin_ceros,  -- Convierte 0 a NULL
    COALESCE(NULLIF(emp.salario, 0), 1500) AS salario_con_minimo,  -- Mínimo si es 0 o NULL
    -- Estados calculados
    CASE 
        WHEN emp.id_empleado IS NULL THEN 'Registro Fantasma'
        WHEN jefe.id_empleado IS NULL AND emp.id_jefe IS NOT NULL THEN 'Supervisor Faltante'
        WHEN jefe.id_empleado IS NULL AND emp.id_jefe IS NULL THEN 'Director/Independiente'
        ELSE 'Estructura Normal'
    END AS estado_jerarquico,
    -- Información de la cadena jerárquica
    COALESCE(
        CONCAT(
            COALESCE(jefe.nombre, 'Sin Jefe'), 
            ' → ', 
            emp.nombre
        ), 
        emp.nombre
    ) AS cadena_supervision
FROM empleados_jerarquia emp
LEFT JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
ORDER BY emp.nombre;

-- 17) SELF JOIN con subconsultas: Análisis comparativo por niveles organizacionales.
SELECT 
    emp.nombre AS empleado,
    emp.puesto,
    emp.salario,
    jefe.nombre AS supervisor,
    -- Comparaciones con subconsultas correlacionadas
    (SELECT AVG(e2.salario) 
     FROM empleados_jerarquia e2 
     WHERE e2.puesto = emp.puesto) AS salario_promedio_puesto,
    (SELECT COUNT(*) 
     FROM empleados_jerarquia e3 
     WHERE e3.id_jefe = emp.id_jefe 
     AND e3.id_empleado != emp.id_empleado) AS compañeros_equipo,
    (SELECT COUNT(*) 
     FROM empleados_jerarquia e4 
     WHERE e4.id_jefe = emp.id_empleado) AS subordinados_directos,
    (SELECT SUM(v.cantidad * v.precio_unitario) 
     FROM ventas v 
     WHERE v.id_empleado = emp.id_empleado) AS ventas_personales,
    -- Análisis de posición en la jerarquía
    (SELECT COUNT(*) 
     FROM empleados_jerarquia e5 
     WHERE e5.id_jefe = emp.id_jefe 
     AND e5.salario > emp.salario) AS empleados_mejor_pagados_mismo_jefe,
    -- Análisis de influencia organizacional
    (SELECT COUNT(*) 
     FROM empleados_jerarquia e6 
     WHERE e6.id_jefe IN (
         SELECT e7.id_empleado 
         FROM empleados_jerarquia e7 
         WHERE e7.id_jefe = emp.id_empleado
     )) AS subordinados_segundo_nivel,
    -- Análisis de posición relativa
    CASE 
        WHEN emp.salario > (SELECT AVG(e8.salario) FROM empleados_jerarquia e8 WHERE e8.puesto = emp.puesto)
        THEN 'Salario por encima del promedio del puesto'
        ELSE 'Salario por debajo del promedio del puesto'
    END AS posicion_salarial,
    CASE 
        WHEN (SELECT COUNT(*) FROM empleados_jerarquia e9 WHERE e9.id_jefe = emp.id_empleado) = 0
        THEN 'Empleado Individual'
        WHEN (SELECT COUNT(*) FROM empleados_jerarquia e10 WHERE e10.id_jefe = emp.id_empleado) <= 2
        THEN 'Supervisor Pequeño'
        ELSE 'Líder de Equipo Grande'
    END AS tipo_liderazgo
FROM empleados_jerarquia emp
LEFT JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
ORDER BY emp.salario DESC;

-- 18) SELF JOIN optimizado: Análisis de rendimiento en estructuras jerárquicas complejas.
-- Consulta optimizada usando subconsultas eficientes
SELECT 
    emp.nombre AS empleado,
    emp.puesto,
    emp.salario,
    jerarquia.nivel_jerarquico,
    jerarquia.subordinados_directos,
    equipos.tamaño_equipo_total,
    rendimiento.total_ventas,
    -- Métricas de eficiencia jerárquica
    ROUND(
        CASE 
            WHEN emp.salario > 0 THEN rendimiento.total_ventas / emp.salario 
            ELSE 0 
        END, 2
    ) AS ratio_ventas_salario,
    ROUND(
        CASE 
            WHEN equipos.tamaño_equipo_total > 1 
            THEN rendimiento.total_ventas / equipos.tamaño_equipo_total 
            ELSE rendimiento.total_ventas 
        END, 2
    ) AS ventas_per_capita_equipo,
    -- Clasificación jerárquica de rendimiento
    CASE 
        WHEN rendimiento.total_ventas > 200 AND jerarquia.subordinados_directos > 0 THEN 'LÍDER DE ALTO RENDIMIENTO'
        WHEN rendimiento.total_ventas > 150 THEN 'VENDEDOR ESTRELLA'  
        WHEN rendimiento.total_ventas > 75 THEN 'RENDIMIENTO SÓLIDO'
        WHEN rendimiento.total_ventas > 0 THEN 'EN DESARROLLO'
        ELSE 'SIN VENTAS REGISTRADAS'
    END AS clasificacion_rendimiento,
    -- Análisis de posición organizacional
    CASE 
        WHEN jerarquia.nivel_jerarquico = 0 THEN 'EJECUTIVO PRINCIPAL'
        WHEN jerarquia.nivel_jerarquico = 1 AND jerarquia.subordinados_directos > 3 THEN 'GERENTE SENIOR'
        WHEN jerarquia.nivel_jerarquico = 1 THEN 'GERENTE'
        WHEN jerarquia.nivel_jerarquico = 2 THEN 'SUPERVISOR'
        ELSE 'COLABORADOR INDIVIDUAL'
    END AS categoria_organizacional
FROM empleados_jerarquia emp
LEFT JOIN (
    -- Subconsulta para rendimiento de ventas
    SELECT 
        id_empleado,
        COUNT(*) AS num_ventas,
        COALESCE(SUM(cantidad * precio_unitario), 0) AS total_ventas
    FROM ventas 
    GROUP BY id_empleado
) rendimiento ON emp.id_empleado = rendimiento.id_empleado
LEFT JOIN (
    -- Subconsulta para información jerárquica
    SELECT 
        e1.id_empleado,
        CASE 
            WHEN e1.id_jefe IS NULL THEN 0
            WHEN e2.id_jefe IS NULL THEN 1  
            WHEN e3.id_jefe IS NULL THEN 2
            ELSE 3
        END AS nivel_jerarquico,
        (SELECT COUNT(*) FROM empleados_jerarquia sub WHERE sub.id_jefe = e1.id_empleado) AS subordinados_directos
    FROM empleados_jerarquia e1
    LEFT JOIN empleados_jerarquia e2 ON e1.id_jefe = e2.id_empleado
    LEFT JOIN empleados_jerarquia e3 ON e2.id_jefe = e3.id_empleado
) jerarquia ON emp.id_empleado = jerarquia.id_empleado
LEFT JOIN (
    -- Subconsulta para tamaño de equipos extendidos
    SELECT 
        lider.id_empleado,
        COUNT(DISTINCT miembro.id_empleado) AS tamaño_equipo_total
    FROM empleados_jerarquia lider
    LEFT JOIN empleados_jerarquia miembro ON lider.id_empleado = miembro.id_jefe
    GROUP BY lider.id_empleado
) equipos ON emp.id_empleado = equipos.id_empleado
ORDER BY clasificacion_rendimiento, rendimiento.total_ventas DESC;

-- 19) SELF JOIN integral: Dashboard organizacional con métricas jerárquicas completas.
WITH resumen_jerarquico AS (
    SELECT 
        CASE 
            WHEN emp.id_jefe IS NULL THEN 'DIRECCIÓN'
            WHEN jefe.id_jefe IS NULL THEN 'GERENCIA' 
            WHEN abuelo.id_jefe IS NULL THEN 'SUPERVISIÓN'
            ELSE 'OPERACIÓN'
        END AS nivel_organizacional,
        emp.id_empleado,
        emp.nombre,
        emp.puesto,
        emp.salario,
        (SELECT COUNT(*) FROM empleados_jerarquia sub WHERE sub.id_jefe = emp.id_empleado) AS subordinados,
        COALESCE(ventas_info.total_ventas, 0) AS ventas_individuales
    FROM empleados_jerarquia emp
    LEFT JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
    LEFT JOIN empleados_jerarquia abuelo ON jefe.id_jefe = abuelo.id_empleado
    LEFT JOIN (
        SELECT id_empleado, SUM(cantidad * precio_unitario) AS total_ventas
        FROM ventas GROUP BY id_empleado
    ) ventas_info ON emp.id_empleado = ventas_info.id_empleado
)
SELECT 
    nivel_organizacional,
    COUNT(*) AS total_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    SUM(salario) AS masa_salarial,
    SUM(subordinados) AS total_subordinados_gestionados,
    SUM(ventas_individuales) AS ventas_totales_nivel,
    -- KPIs Organizacionales por nivel
    ROUND(SUM(ventas_individuales) / NULLIF(SUM(salario), 0), 2) AS roi_nivel,
    ROUND(SUM(ventas_individuales) / COUNT(*), 2) AS ventas_per_capita,
    ROUND(SUM(subordinados) / COUNT(*), 1) AS subordinados_promedio,
    -- Análisis de eficiencia organizacional
    CASE 
        WHEN nivel_organizacional = 'DIRECCIÓN' AND SUM(subordinados) < 3 
        THEN 'Estructura directiva pequeña'
        WHEN nivel_organizacional = 'GERENCIA' AND SUM(subordinados) / COUNT(*) < 2 
        THEN 'Gerentes con pocos reportes'
        WHEN nivel_organizacional = 'SUPERVISIÓN' AND SUM(ventas_individuales) = 0 
        THEN 'Supervisión sin impacto comercial'
        WHEN nivel_organizacional = 'OPERACIÓN' AND SUM(ventas_individuales) / COUNT(*) > 100 
        THEN 'Operación altamente productiva'
        ELSE 'Nivel organizacional estándar'
    END AS analisis_eficiencia,
    -- Recomendaciones organizacionales
    CASE 
        WHEN nivel_organizacional = 'DIRECCIÓN' THEN 'Mantener focus estratégico'
        WHEN nivel_organizacional = 'GERENCIA' AND SUM(ventas_individuales) < 500 
        THEN 'Mejorar efectividad de gestión comercial'
        WHEN nivel_organizacional = 'SUPERVISIÓN' AND SUM(subordinados) = 0 
        THEN 'Revisar necesidad del rol supervisor'
        WHEN nivel_organizacional = 'OPERACIÓN' 
        THEN 'Optimizar herramientas y procesos'
        ELSE 'Revisión periódica estándar'
    END AS recomendacion_organizacional
FROM resumen_jerarquico
GROUP BY nivel_organizacional
ORDER BY 
    CASE nivel_organizacional
        WHEN 'DIRECCIÓN' THEN 1
        WHEN 'GERENCIA' THEN 2
        WHEN 'SUPERVISIÓN' THEN 3
        ELSE 4
    END;

-- 20) SELF JOIN avanzado: Análisis de red organizacional y influencia.
WITH red_organizacional AS (
    -- Calcular métricas de red para cada empleado
    SELECT 
        emp.id_empleado,
        emp.nombre,
        emp.puesto,
        emp.salario,
        -- Conexiones directas
        COALESCE(subordinados.num_subordinados, 0) AS subordinados_directos,
        CASE WHEN emp.id_jefe IS NOT NULL THEN 1 ELSE 0 END AS tiene_jefe,
        -- Conexiones indirectas
        COALESCE(red_extendida.subordinados_nivel2, 0) AS subordinados_segundo_nivel,
        COALESCE(compañeros.num_compañeros, 0) AS compañeros_mismo_nivel,
        -- Métricas de influencia
        (COALESCE(subordinados.masa_salarial_subordinados, 0) + emp.salario) AS influencia_salarial,
        COALESCE(ventas_equipo.ventas_equipo_total, 0) AS ventas_equipo_supervisado
    FROM empleados_jerarquia emp
    LEFT JOIN (
        SELECT 
            id_jefe,
            COUNT(*) AS num_subordinados,
            SUM(salario) AS masa_salarial_subordinados
        FROM empleados_jerarquia 
        WHERE id_jefe IS NOT NULL
        GROUP BY id_jefe
    ) subordinados ON emp.id_empleado = subordinados.id_jefe
    LEFT JOIN (
        SELECT 
            supervisor.id_empleado,
            COUNT(DISTINCT nivel2.id_empleado) AS subordinados_nivel2
        FROM empleados_jerarquia supervisor
        INNER JOIN empleados_jerarquia nivel1 ON supervisor.id_empleado = nivel1.id_jefe
        INNER JOIN empleados_jerarquia nivel2 ON nivel1.id_empleado = nivel2.id_jefe
        GROUP BY supervisor.id_empleado
    ) red_extendida ON emp.id_empleado = red_extendida.id_empleado
    LEFT JOIN (
        SELECT 
            emp1.id_empleado,
            COUNT(emp2.id_empleado) AS num_compañeros
        FROM empleados_jerarquia emp1
        INNER JOIN empleados_jerarquia emp2 ON emp1.id_jefe = emp2.id_jefe 
            AND emp1.id_empleado != emp2.id_empleado
        GROUP BY emp1.id_empleado
    ) compañeros ON emp.id_empleado = compañeros.id_empleado
    LEFT JOIN (
        SELECT 
            jefe.id_empleado,
            SUM(v.cantidad * v.precio_unitario) AS ventas_equipo_total
        FROM empleados_jerarquia jefe
        INNER JOIN empleados_jerarquia subordinado ON jefe.id_empleado = subordinado.id_jefe
        INNER JOIN ventas v ON subordinado.id_empleado = v.id_empleado
        GROUP BY jefe.id_empleado
    ) ventas_equipo ON emp.id_empleado = ventas_equipo.id_empleado
)
SELECT 
    nombre AS empleado,
    puesto,
    salario,
    subordinados_directos,
    subordinados_segundo_nivel,
    compañeros_mismo_nivel,
    -- Puntuación de influencia organizacional (0-100)
    LEAST(100, 
        (subordinados_directos * 20) + 
        (subordinados_segundo_nivel * 10) + 
        (compañeros_mismo_nivel * 5) +
        (CASE WHEN tiene_jefe = 0 THEN 25 ELSE 5 END) +
        (LEAST(20, influencia_salarial / 1000))
    ) AS puntuacion_influencia,
    -- Clasificación en la red organizacional
    CASE 
        WHEN subordinados_directos = 0 AND subordinados_segundo_nivel = 0 THEN 'NODO TERMINAL'
        WHEN subordinados_directos <= 2 AND subordinados_segundo_nivel = 0 THEN 'SUPERVISOR BÁSICO'
        WHEN subordinados_segundo_nivel > 0 AND subordinados_directos > 2 THEN 'HUB ORGANIZACIONAL'
        WHEN subordinados_segundo_nivel > 5 THEN 'SUPER CONECTOR'
        WHEN tiene_jefe = 0 THEN 'NODO CENTRAL'
        ELSE 'CONECTOR MEDIO'
    END AS tipo_nodo_red,
    -- Análisis de centralidad
    subordinados_directos + subordinados_segundo_nivel + compañeros_mismo_nivel AS conectividad_total,
    ROUND(influencia_salarial / 1000, 2) AS influencia_economica_k,
    ROUND(ventas_equipo_supervisado, 2) AS impacto_comercial,
    -- Recomendaciones de desarrollo
    CASE 
        WHEN subordinados_directos > 5 AND subordinados_segundo_nivel = 0 
        THEN 'Desarrollar línea media de gestión'
        WHEN puntuacion_influencia < 20 AND puesto LIKE '%Gerente%' 
        THEN 'Fortalecer liderazgo y red'
        WHEN ventas_equipo_supervisado = 0 AND subordinados_directos > 0 
        THEN 'Enfocar equipo en resultados comerciales'
        WHEN conectividad_total > 10 
        THEN 'Considerar para roles estratégicos'
        ELSE 'Desarrollo estándar'
    END AS recomendacion_desarrollo
FROM red_organizacional
ORDER BY puntuacion_influencia DESC, conectividad_total DESC;

-- =============================================
-- EJEMPLOS PRÁCTICOS ADICIONALES DE SELF JOIN
-- =============================================

-- Ejemplo adicional 1: Comparar empleados con sus compañeros de mismo nivel
SELECT '=== COMPARACIÓN ENTRE COMPAÑEROS DE MISMO NIVEL ===' AS ejemplo;
SELECT 
    emp1.nombre AS empleado1,
    emp1.salario AS salario1,
    emp2.nombre AS empleado2,
    emp2.salario AS salario2,
    jefe.nombre AS jefe_comun,
    ABS(emp1.salario - emp2.salario) AS diferencia_salarial,
    CASE 
        WHEN emp1.salario > emp2.salario THEN CONCAT(emp1.nombre, ' gana más')
        WHEN emp1.salario < emp2.salario THEN CONCAT(emp2.nombre, ' gana más')
        ELSE 'Mismo salario'
    END AS comparacion
FROM empleados_jerarquia emp1
INNER JOIN empleados_jerarquia emp2 ON emp1.id_jefe = emp2.id_jefe 
    AND emp1.id_empleado < emp2.id_empleado  -- Evita duplicados
INNER JOIN empleados_jerarquia jefe ON emp1.id_jefe = jefe.id_empleado
ORDER BY jefe.nombre, diferencia_salarial DESC;

-- Ejemplo adicional 2: Árbol genealógico organizacional
SELECT '=== ÁRBOL ORGANIZACIONAL COMPLETO ===' AS ejemplo;
SELECT 
    LEVEL_0.nombre AS Director,
    LEVEL_1.nombre AS Gerente,
    LEVEL_2.nombre AS Supervisor,
    LEVEL_3.nombre AS Empleado,
    CONCAT_WS(' → ', 
        LEVEL_0.nombre, 
        LEVEL_1.nombre, 
        LEVEL_2.nombre, 
        LEVEL_3.nombre
    ) AS cadena_completa
FROM empleados_jerarquia LEVEL_0
LEFT JOIN empleados_jerarquia LEVEL_1 ON LEVEL_0.id_empleado = LEVEL_1.id_jefe
LEFT JOIN empleados_jerarquia LEVEL_2 ON LEVEL_1.id_empleado = LEVEL_2.id_jefe
LEFT JOIN empleados_jerarquia LEVEL_3 ON LEVEL_2.id_empleado = LEVEL_3.id_jefe
WHERE LEVEL_0.id_jefe IS NULL  -- Empezamos desde la raíz
ORDER BY LEVEL_0.nombre, LEVEL_1.nombre, LEVEL_2.nombre, LEVEL_3.nombre;

-- Ejemplo adicional 3: Análisis de span de control
SELECT '=== ANÁLISIS DE SPAN DE CONTROL ===' AS ejemplo;
SELECT 
    jefe.nombre AS jefe,
    jefe.puesto,
    COUNT(subordinado.id_empleado) AS subordinados_directos,
    ROUND(AVG(subordinado.salario), 2) AS salario_promedio_equipo,
    CASE 
        WHEN COUNT(subordinado.id_empleado) = 0 THEN 'Sin equipo'
        WHEN COUNT(subordinado.id_empleado) <= 3 THEN 'Span óptimo'
        WHEN COUNT(subordinado.id_empleado) <= 6 THEN 'Span alto'
        ELSE 'Span crítico - considerar restructuración'
    END AS evaluacion_span
FROM empleados_jerarquia jefe
LEFT JOIN empleados_jerarquia subordinado ON jefe.id_empleado = subordinado.id_jefe
GROUP BY jefe.id_empleado, jefe.nombre, jefe.puesto
ORDER BY subordinados_directos DESC;

-- =============================================
-- CONCEPTOS CLAVE DEL SELF JOIN
-- =============================================
/*
SELF JOIN:
- Une una tabla consigo misma usando alias diferentes
- Útil para relaciones jerárquicas y auto-referencias
- Permite comparar registros dentro de la misma tabla

SINTAXIS BÁSICA:
SELECT alias1.columna, alias2.columna
FROM tabla alias1
INNER/LEFT/RIGHT JOIN tabla alias2 ON alias1.columna = alias2.columna_referencia;

CASOS DE USO COMUNES:
- Estructuras jerárquicas (empleado-jefe)
- Comparaciones entre registros similares
- Análisis de relaciones internas
- Árboles organizacionales
- Redes sociales o de influencia

TIPOS DE SELF JOIN:
- INNER SELF JOIN: Solo relaciones existentes
- LEFT SELF JOIN: Incluye registros sin relación
- Recursivo: Para jerarquías de múltiples niveles

CONSIDERACIONES:
- Siempre usar alias para distinguir las instancias
- Cuidado con la recursión infinita en CTEs
- Optimizar con índices apropiados
- Considerar el rendimiento con grandes volúmenes
*/

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================