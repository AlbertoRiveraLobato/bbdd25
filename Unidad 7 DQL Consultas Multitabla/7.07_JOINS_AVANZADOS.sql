-- =============================================
-- 7.06_JOINS_AVANZADOS.sql
-- =============================================
-- Ejemplos de JOINs avanzados: múltiples JOINs, JOINs con subconsultas
-- Incluye: joins complejos, optimización y casos prácticos empresariales.

-- NOTA: Para SELF JOIN, consulta el archivo 7.07_SELF_JOIN.sql

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

-- Tabla de empleados con jerarquía (para SELF JOIN)
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
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    precio_base DECIMAL(10,2)
);

-- Tabla de colores para CROSS JOIN
CREATE TABLE colores (
    id_color INT AUTO_INCREMENT PRIMARY KEY,
    color VARCHAR(50) NOT NULL
);

-- Tabla de tallas para CROSS JOIN
CREATE TABLE tallas (
    id_talla INT AUTO_INCREMENT PRIMARY KEY,
    talla VARCHAR(10) NOT NULL
);

-- Tabla de tipos de descuento
CREATE TABLE tipos_descuento (
    id_descuento INT AUTO_INCREMENT PRIMARY KEY,
    tipo_descuento VARCHAR(50) NOT NULL,
    porcentaje DECIMAL(5,2)
);

-- Tabla de ventas para ejemplos complejos
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    fecha_venta DATE,
    id_empleado INT,
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    FOREIGN KEY (id_empleado) REFERENCES empleados_jerarquia(id_empleado),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

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
INSERT INTO productos (nombre_producto, precio_base) VALUES
('Camiseta', 25.00),
('Pantalón', 45.00),
('Chaqueta', 85.00),
('Zapatos', 65.00),
('Accesorios', 15.00);

-- Datos de colores
INSERT INTO colores (color) VALUES 
('Rojo'), ('Azul'), ('Verde'), ('Negro'), ('Blanco');

-- Datos de tallas
INSERT INTO tallas (talla) VALUES 
('S'), ('M'), ('L'), ('XL');

-- Datos de tipos de descuento
INSERT INTO tipos_descuento (tipo_descuento, porcentaje) VALUES 
('Sin descuento', 0.00),
('Descuento estudiante', 10.00),
('Descuento empleado', 15.00),
('Descuento VIP', 20.00);

-- Datos extensos de ventas para análisis complejos
INSERT INTO ventas (fecha_venta, id_empleado, id_producto, cantidad, precio_unitario) VALUES
('2024-01-15', 4, 1, 2, 25.00),
('2024-01-16', 5, 2, 1, 45.00),
('2024-01-17', 4, 3, 3, 85.00),
('2024-01-20', 2, 1, 1, 25.00),
('2024-01-22', 3, 4, 2, 65.00),
('2024-02-01', 5, 1, 1, 25.00),
('2024-02-02', 4, 2, 2, 45.00),
('2024-02-05', 7, 4, 1, 65.00),
('2024-02-10', 4, 5, 4, 15.00),
('2024-02-15', 2, 3, 1, 85.00),
('2024-03-01', 5, 3, 1, 85.00),
('2024-03-15', 7, 1, 3, 25.00),
('2024-03-20', 4, 4, 2, 65.00),
('2024-03-25', 8, 2, 1, 45.00),
('2024-04-01', 9, 5, 2, 15.00),
('2024-04-10', 2, 1, 4, 25.00),
('2024-04-15', 3, 3, 1, 85.00),
('2024-04-20', 7, 4, 3, 65.00),
('2024-05-01', 4, 2, 2, 45.00),
('2024-05-10', 5, 5, 1, 15.00);
('2024-01-17', 4, 3, 3, 15.00),
('2024-02-01', 5, 1, 1, 25.00),
('2024-02-02', 4, 2, 2, 45.00);

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================

-- *** EJERCICIOS BÁSICOS CON JOINS AVANZADOS (1-10) ***
-- 1) MÚLTIPLE JOIN: Empleado, departamento, ventas y productos en una consulta.
-- 2) JOIN con subconsulta: Empleados con ventas superiores al promedio.
-- 3) JOIN con agregación: Ventas totales por empleado y departamento.
-- 4) JOIN condicional: Empleados y sus ventas con filtros avanzados.
-- 5) MÚLTIPLE JOIN: Análisis básico de ventas por empleado y producto.
-- 6) JOIN con UNION: Combinando resultados de múltiples consultas.
-- 7) JOIN con subconsulta correlacionada: Empleados vs promedio departamental.
-- 8) MÚLTIPLE JOIN con filtros: Análisis de ventas por período y ubicación.
-- 9) JOIN con EXISTS: Empleados que han realizado ventas.
-- 10) JOIN optimizado: Consulta eficiente con múltiples tablas.

-- *** EJERCICIOS AVANZADOS CON JOINS COMPLEJOS (11-20) ***
-- 11) JOINs múltiples con DISTINCT: Análisis único de relaciones complejas.
-- 12) JOINs con agregaciones avanzadas: Métricas organizacionales complejas.
-- 13) JOINs con campos calculados: Rendimiento y comisiones por departamento.
-- 14) JOINs con CASE: Clasificación de empleados y análisis de rendimiento.
-- 15) JOINs con COALESCE: Manejo avanzado de datos faltantes en relaciones.
-- 16) JOINs con subconsultas correlacionadas: Análisis comparativo departamental.
-- 17) JOINs optimizados: Análisis de rendimiento con múltiples relaciones.
-- 18) JOIN integral: Dashboard organizacional con todas las métricas.
-- 19) JOINs con ventanas: Ranking y análisis temporal de ventas.
-- 20) JOIN complejo: Análisis multidimensional de rendimiento empresarial.

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================

-- *** SOLUCIONES EJERCICIOS BÁSICOS (1-10) ***

-- 1) MÚLTIPLE JOIN: Empleado, departamento, ventas y productos en una consulta.
SELECT 
    eh.nombre AS empleado,
    d.nombre_dept AS departamento,
    v.fecha_venta,
    p.nombre_producto,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
INNER JOIN ventas v ON eh.id_empleado = v.id_empleado
INNER JOIN productos p ON v.id_producto = p.id_producto
ORDER BY v.fecha_venta DESC, eh.nombre;

-- 2) JOIN con subconsulta: Empleados con ventas superiores al promedio.
SELECT 
    eh.nombre AS empleado,
    d.nombre_dept AS departamento,
    SUM(v.cantidad * v.precio_unitario) AS total_ventas
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
INNER JOIN ventas v ON eh.id_empleado = v.id_empleado
GROUP BY eh.id_empleado, eh.nombre, d.nombre_dept
HAVING total_ventas > (
    SELECT AVG(total_por_empleado) 
    FROM (
        SELECT SUM(v2.cantidad * v2.precio_unitario) AS total_por_empleado
        FROM ventas v2 
        GROUP BY v2.id_empleado
    ) AS promedios
);

-- 3) JOIN con agregación: Ventas totales por empleado y departamento.
SELECT 
    d.nombre_dept AS departamento,
    eh.nombre AS empleado,
    COUNT(v.id_venta) AS num_ventas,
    COALESCE(SUM(v.cantidad * v.precio_unitario), 0) AS total_ventas,
    COALESCE(AVG(v.cantidad * v.precio_unitario), 0) AS promedio_venta
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
LEFT JOIN ventas v ON eh.id_empleado = v.id_empleado
GROUP BY d.id_departamento, d.nombre_dept, eh.id_empleado, eh.nombre
ORDER BY d.nombre_dept, total_ventas DESC;

-- 4) JOIN condicional: Empleados y sus ventas con filtros avanzados.
SELECT 
    eh.nombre AS empleado,
    eh.puesto,
    d.nombre_dept AS departamento,
    d.ubicacion,
    COUNT(v.id_venta) AS num_ventas,
    SUM(v.cantidad * v.precio_unitario) AS total_ventas
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
INNER JOIN ventas v ON eh.id_empleado = v.id_empleado
WHERE v.fecha_venta >= '2024-01-01'
    AND d.ubicacion IN ('Madrid', 'Barcelona', 'Valencia')
    AND v.precio_unitario > 20
GROUP BY eh.id_empleado, eh.nombre, eh.puesto, d.nombre_dept, d.ubicacion
HAVING total_ventas > 50
ORDER BY total_ventas DESC;

-- 5) MÚLTIPLE JOIN: Análisis básico de ventas por empleado y producto.
SELECT 
    eh.nombre AS empleado,
    d.nombre_dept AS departamento,
    p.nombre_producto AS producto,
    SUM(v.cantidad) AS cantidad_vendida,
    SUM(v.cantidad * v.precio_unitario) AS ingresos_producto,
    COUNT(v.id_venta) AS num_transacciones,
    ROUND(AVG(v.precio_unitario), 2) AS precio_promedio
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
INNER JOIN ventas v ON eh.id_empleado = v.id_empleado
INNER JOIN productos p ON v.id_producto = p.id_producto
GROUP BY eh.id_empleado, eh.nombre, d.nombre_dept, p.id_producto, p.nombre_producto
ORDER BY ingresos_producto DESC;

-- 6) JOIN con UNION: Combinando resultados de múltiples consultas.
SELECT 'EMPLEADOS TOP VENTAS' AS categoria, eh.nombre AS nombre, SUM(v.cantidad * v.precio_unitario) AS valor
FROM empleados_jerarquia eh
INNER JOIN ventas v ON eh.id_empleado = v.id_empleado
GROUP BY eh.id_empleado, eh.nombre
ORDER BY valor DESC
LIMIT 3

UNION ALL

SELECT 'DEPARTAMENTOS TOP INGRESOS' AS categoria, d.nombre_dept AS nombre, SUM(v.cantidad * v.precio_unitario) AS valor
FROM departamentos d
INNER JOIN empleados_jerarquia eh ON d.id_departamento = eh.id_departamento
INNER JOIN ventas v ON eh.id_empleado = v.id_empleado
GROUP BY d.id_departamento, d.nombre_dept
ORDER BY valor DESC
LIMIT 3;

-- 7) JOIN con subconsulta correlacionada: Empleados vs promedio departamental.
SELECT 
    eh.nombre AS empleado,
    d.nombre_dept AS departamento,
    eh.salario,
    (SELECT AVG(e2.salario) 
     FROM empleados_jerarquia e2 
     WHERE e2.id_departamento = eh.id_departamento) AS salario_promedio_dept,
    CASE 
        WHEN eh.salario > (SELECT AVG(e3.salario) FROM empleados_jerarquia e3 WHERE e3.id_departamento = eh.id_departamento)
        THEN 'Por encima del promedio departamental'
        ELSE 'Por debajo del promedio departamental'
    END AS comparacion_salarial,
    COALESCE(ventas_info.total_ventas, 0) AS ventas_personales
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
LEFT JOIN (
    SELECT id_empleado, SUM(cantidad * precio_unitario) AS total_ventas
    FROM ventas GROUP BY id_empleado
) ventas_info ON eh.id_empleado = ventas_info.id_empleado
ORDER BY d.nombre_dept, eh.salario DESC;

-- 8) MÚLTIPLE JOIN con filtros: Análisis de ventas por período y ubicación.
SELECT 
    d.ubicacion,
    QUARTER(v.fecha_venta) AS trimestre,
    YEAR(v.fecha_venta) AS año,
    COUNT(DISTINCT eh.id_empleado) AS empleados_activos,
    COUNT(v.id_venta) AS num_ventas,
    SUM(v.cantidad * v.precio_unitario) AS ingresos_totales,
    ROUND(AVG(v.cantidad * v.precio_unitario), 2) AS ticket_promedio
FROM departamentos d
INNER JOIN empleados_jerarquia eh ON d.id_departamento = eh.id_departamento
INNER JOIN ventas v ON eh.id_empleado = v.id_empleado
WHERE v.fecha_venta BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY d.ubicacion, YEAR(v.fecha_venta), QUARTER(v.fecha_venta)
ORDER BY año, trimestre, ingresos_totales DESC;

-- 9) JOIN con EXISTS: Empleados que han realizado ventas.
SELECT 
    eh.nombre AS empleado,
    d.nombre_dept AS departamento,
    eh.puesto,
    eh.salario
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
WHERE EXISTS (
    SELECT 1 FROM ventas v 
    WHERE v.id_empleado = eh.id_empleado
)
ORDER BY eh.salario DESC;

-- 10) JOIN optimizado: Consulta eficiente con múltiples tablas.
-- Usar índices y limitar resultados para optimización
SELECT 
    eh.nombre AS empleado,
    d.nombre_dept AS departamento,
    p.nombre_producto AS producto_estrella,
    ventas_max.max_venta AS mejor_venta,
    ventas_max.fecha_mejor_venta
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
INNER JOIN (
    SELECT 
        v.id_empleado,
        v.id_producto,
        MAX(v.cantidad * v.precio_unitario) AS max_venta,
        MAX(v.fecha_venta) AS fecha_mejor_venta
    FROM ventas v
    GROUP BY v.id_empleado, v.id_producto
) ventas_max ON eh.id_empleado = ventas_max.id_empleado
INNER JOIN productos p ON ventas_max.id_producto = p.id_producto
ORDER BY ventas_max.max_venta DESC
LIMIT 10;
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

-- 7) JOIN con agregación: Ventas totales por empleado y departamento.
SELECT 
    d.nombre_dept AS departamento,
    eh.nombre AS empleado,
    COUNT(v.id_venta) AS num_ventas,
    COALESCE(SUM(v.cantidad * v.precio_unitario), 0) AS total_ventas,
    COALESCE(AVG(v.cantidad * v.precio_unitario), 0) AS promedio_venta
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
LEFT JOIN ventas v ON eh.id_empleado = v.id_empleado
GROUP BY d.id_departamento, d.nombre_dept, eh.id_empleado, eh.nombre
ORDER BY d.nombre_dept, total_ventas DESC;

-- 8) JOIN condicional: Empleados y sus ventas con filtros.
SELECT 
    eh.nombre AS empleado,
    eh.puesto,
    d.nombre_dept AS departamento,
    SUM(v.cantidad * v.precio_unitario) AS total_ventas
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
INNER JOIN ventas v ON eh.id_empleado = v.id_empleado
WHERE v.fecha_venta >= '2024-01-01'
GROUP BY eh.id_empleado, eh.nombre, eh.puesto, d.nombre_dept
HAVING total_ventas > 50
ORDER BY total_ventas DESC;

-- 9) SELF JOIN: Comparar empleados del mismo departamento.
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

-- 10) MÚLTIPLE JOIN: Análisis básico de ventas por empleado.
SELECT 
    eh.nombre AS empleado,
    d.nombre_dept AS departamento,
    COUNT(DISTINCT v.id_venta) AS num_ventas,
    COUNT(DISTINCT v.id_producto) AS productos_vendidos,
    SUM(v.cantidad) AS cantidad_total,
    SUM(v.cantidad * v.precio_unitario) AS ingresos_generados
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
LEFT JOIN ventas v ON eh.id_empleado = v.id_empleado
GROUP BY eh.id_empleado, eh.nombre, d.nombre_dept
ORDER BY ingresos_generados DESC;

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

-- 12) JOINs múltiples con DISTINCT: Análisis único de relaciones complejas.
SELECT DISTINCT
    eh.nombre AS empleado,
    d.nombre_dept AS departamento,
    jefe.nombre AS jefe,
    p.nombre_producto AS producto_vendido,
    v.fecha_venta,
    CASE 
        WHEN v.id_venta IS NOT NULL THEN 'Con Ventas'
        ELSE 'Sin Ventas'
    END AS estado_ventas,
    CASE 
        WHEN eh.id_jefe IS NOT NULL THEN 'Con Supervisor'
        ELSE 'Independiente'
    END AS estado_supervision
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
LEFT JOIN empleados_jerarquia jefe ON eh.id_jefe = jefe.id_empleado
LEFT JOIN ventas v ON eh.id_empleado = v.id_empleado
LEFT JOIN productos p ON v.id_producto = p.id_producto
ORDER BY eh.nombre, v.fecha_venta;

-- 13) JOINs con agregaciones avanzadas: Métricas organizacionales complejas.
SELECT 
    d.nombre_dept AS departamento,
    jefe.nombre AS jefe_departamento,
    COUNT(DISTINCT emp.id_empleado) AS empleados_bajo_supervision,
    COUNT(DISTINCT v.id_venta) AS ventas_totales_equipo,
    COALESCE(SUM(v.cantidad * v.precio_unitario), 0) AS ingresos_equipo,
    COALESCE(AVG(emp.salario), 0) AS salario_promedio_equipo,
    COALESCE(SUM(emp.salario), 0) AS costo_salarial_equipo,
    -- Métricas de eficiencia
    CASE 
        WHEN SUM(emp.salario) > 0 
        THEN ROUND(COALESCE(SUM(v.cantidad * v.precio_unitario), 0) / SUM(emp.salario), 2)
        ELSE 0 
    END AS ratio_ingresos_salarios,
    CASE 
        WHEN COUNT(DISTINCT emp.id_empleado) > 0 
        THEN ROUND(COALESCE(SUM(v.cantidad * v.precio_unitario), 0) / COUNT(DISTINCT emp.id_empleado), 2)
        ELSE 0 
    END AS ingresos_per_capita
FROM departamentos d
LEFT JOIN empleados_jerarquia jefe ON d.id_departamento = jefe.id_departamento AND jefe.puesto LIKE '%Gerente%'
LEFT JOIN empleados_jerarquia emp ON jefe.id_empleado = emp.id_jefe
LEFT JOIN ventas v ON emp.id_empleado = v.id_empleado
GROUP BY d.id_departamento, d.nombre_dept, jefe.id_empleado, jefe.nombre
HAVING empleados_bajo_supervision > 0
ORDER BY ingresos_equipo DESC;

-- 14) JOINs con campos calculados: Rendimiento y comisiones por jerarquía.
SELECT 
    emp.nombre AS empleado,
    emp.puesto,
    emp.salario AS salario_base,
    d.nombre_dept AS departamento,
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
        WHEN COALESCE(SUM(v.cantidad * v.precio_unitario), 0) > 100 THEN 250
        WHEN COALESCE(SUM(v.cantidad * v.precio_unitario), 0) > 50 THEN 100
        ELSE 0
    END AS bonificacion_rendimiento,
    -- Salario total
    emp.salario + 
    (COALESCE(SUM(v.cantidad * v.precio_unitario), 0) * 0.02) +
    (CASE 
        WHEN emp.puesto LIKE '%Gerente%' THEN emp.salario * 0.15
        WHEN emp.puesto LIKE '%Supervisor%' THEN emp.salario * 0.10
        ELSE emp.salario * 0.05
    END) +
    (CASE 
        WHEN COALESCE(SUM(v.cantidad * v.precio_unitario), 0) > 200 THEN 500
        WHEN COALESCE(SUM(v.cantidad * v.precio_unitario), 0) > 100 THEN 250
        WHEN COALESCE(SUM(v.cantidad * v.precio_unitario), 0) > 50 THEN 100
        ELSE 0
    END) AS salario_total_calculado
FROM empleados_jerarquia emp
INNER JOIN departamentos d ON emp.id_departamento = d.id_departamento
LEFT JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
LEFT JOIN ventas v ON emp.id_empleado = v.id_empleado
GROUP BY emp.id_empleado, emp.nombre, emp.puesto, emp.salario, d.nombre_dept, jefe.nombre
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

-- 16) JOINs con COALESCE: Manejo avanzado de datos faltantes en relaciones.
SELECT 
    COALESCE(emp.nombre, 'Empleado Desconocido') AS empleado,
    COALESCE(emp.puesto, 'Puesto No Definido') AS puesto,
    COALESCE(emp.salario, 0) AS salario,
    COALESCE(d.nombre_dept, 'Departamento No Asignado') AS departamento,
    COALESCE(jefe.nombre, 'Sin Supervisor') AS supervisor,
    COALESCE(ventas_info.num_ventas, 0) AS numero_ventas,
    COALESCE(ventas_info.total_ventas, 0) AS total_ventas,
    -- Información avanzada con COALESCE
    IFNULL(emp.fecha_contratacion, 'Fecha No Registrada') AS fecha_contratacion,
    NULLIF(emp.salario, 0) AS salario_sin_ceros,  -- Convierte 0 a NULL
    COALESCE(NULLIF(emp.salario, 0), 1500) AS salario_con_minimo,  -- Mínimo si es 0 o NULL
    -- Estados calculados
    CASE 
        WHEN emp.id_empleado IS NULL THEN 'Registro Fantasma'
        WHEN d.id_departamento IS NULL THEN 'Empleado Flotante'  
        WHEN jefe.id_empleado IS NULL AND emp.id_jefe IS NOT NULL THEN 'Supervisor Faltante'
        WHEN COALESCE(ventas_info.total_ventas, 0) = 0 THEN 'Sin Actividad Comercial'
        ELSE 'Registro Completo'
    END AS estado_registro,
    -- Prioridad de revisión
    CASE 
        WHEN emp.id_empleado IS NULL OR d.id_departamento IS NULL THEN 'URGENTE'
        WHEN jefe.id_empleado IS NULL AND emp.id_jefe IS NOT NULL THEN 'ALTA'
        WHEN COALESCE(emp.salario, 0) = 0 THEN 'MEDIA'
        ELSE 'BAJA'
    END AS prioridad_revision
FROM empleados_jerarquia emp
LEFT JOIN departamentos d ON emp.id_departamento = d.id_departamento
LEFT JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
LEFT JOIN (
    SELECT 
        id_empleado, 
        COUNT(*) AS num_ventas,
        SUM(cantidad * precio_unitario) AS total_ventas
    FROM ventas 
    GROUP BY id_empleado
) ventas_info ON emp.id_empleado = ventas_info.id_empleado
ORDER BY 
    CASE prioridad_revision
        WHEN 'URGENTE' THEN 1
        WHEN 'ALTA' THEN 2  
        WHEN 'MEDIA' THEN 3
        ELSE 4
    END,
    emp.nombre;

-- 17) JOINs con subconsultas correlacionadas: Análisis comparativo por niveles.
SELECT 
    emp.nombre AS empleado,
    emp.puesto,
    emp.salario,
    d.nombre_dept AS departamento,
    jefe.nombre AS supervisor,
    -- Comparaciones con subconsultas correlacionadas
    (SELECT AVG(e2.salario) 
     FROM empleados_jerarquia e2 
     WHERE e2.puesto = emp.puesto) AS salario_promedio_puesto,
    (SELECT COUNT(*) 
     FROM empleados_jerarquia e3 
     WHERE e3.id_departamento = emp.id_departamento 
     AND e3.salario > emp.salario) AS empleados_mejor_pagados_dept,
    (SELECT COUNT(*) 
     FROM empleados_jerarquia e4 
     WHERE e4.id_jefe = emp.id_jefe 
     AND e4.id_empleado != emp.id_empleado) AS compañeros_equipo,
    (SELECT SUM(v.cantidad * v.precio_unitario) 
     FROM ventas v 
     WHERE v.id_empleado = emp.id_empleado) AS ventas_personales,
    (SELECT AVG(ventas_promedio.total) 
     FROM (
         SELECT SUM(v2.cantidad * v2.precio_unitario) AS total
         FROM ventas v2 
         WHERE v2.id_empleado IN (
             SELECT e5.id_empleado 
             FROM empleados_jerarquia e5 
             WHERE e5.id_departamento = emp.id_departamento
         )
         GROUP BY v2.id_empleado
     ) ventas_promedio) AS ventas_promedio_departamento,
    -- Análisis de posición relativa
    CASE 
        WHEN emp.salario > (SELECT AVG(e6.salario) FROM empleados_jerarquia e6 WHERE e6.puesto = emp.puesto)
        THEN 'Salario por encima del promedio del puesto'
        ELSE 'Salario por debajo del promedio del puesto'
    END AS posicion_salarial,
    CASE 
        WHEN (SELECT COUNT(*) FROM empleados_jerarquia e7 WHERE e7.id_departamento = emp.id_departamento AND e7.salario > emp.salario) = 0
        THEN 'Mejor pagado del departamento'
        WHEN (SELECT COUNT(*) FROM empleados_jerarquia e8 WHERE e8.id_departamento = emp.id_departamento AND e8.salario > emp.salario) <= 2
        THEN 'Entre los mejor pagados del departamento'
        ELSE 'Salario estándar en el departamento'
    END AS posicion_departamental
FROM empleados_jerarquia emp
INNER JOIN departamentos d ON emp.id_departamento = d.id_departamento
LEFT JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
ORDER BY emp.salario DESC;

-- 18) JOINs optimizados: Análisis de rendimiento con múltiples relaciones.
-- Consulta optimizada usando índices y subconsultas eficientes
SELECT 
    d.nombre_dept AS departamento,
    emp.nombre AS empleado,
    emp.puesto,
    emp.salario,
    rendimiento.total_ventas,
    rendimiento.num_ventas,
    jerarquia.nivel_jerarquico,
    jerarquia.subordinados_directos,
    equipos.tamaño_equipo_total,
    -- Métricas de eficiencia
    ROUND(
        CASE 
            WHEN emp.salario > 0 THEN rendimiento.total_ventas / emp.salario 
            ELSE 0 
        END, 2
    ) AS ratio_ventas_salario,
    ROUND(
        CASE 
            WHEN equipos.tamaño_equipo_total > 0 
            THEN rendimiento.total_ventas / equipos.tamaño_equipo_total 
            ELSE rendimiento.total_ventas 
        END, 2
    ) AS ventas_per_capita_equipo,
    -- Clasificación de rendimiento
    CASE 
        WHEN rendimiento.total_ventas > 200 AND jerarquia.subordinados_directos > 0 THEN 'LÍDER DE ALTO RENDIMIENTO'
        WHEN rendimiento.total_ventas > 150 THEN 'VENDEDOR ESTRELLA'  
        WHEN rendimiento.total_ventas > 75 THEN 'RENDIMIENTO SÓLIDO'
        WHEN rendimiento.total_ventas > 0 THEN 'EN DESARROLLO'
        ELSE 'SIN VENTAS REGISTRADAS'
    END AS clasificacion_rendimiento
FROM empleados_jerarquia emp
INNER JOIN departamentos d ON emp.id_departamento = d.id_departamento
LEFT JOIN (
    -- Subconsulta para rendimiento de ventas
    SELECT 
        id_empleado,
        COUNT(*) AS num_ventas,
        SUM(cantidad * precio_unitario) AS total_ventas
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
    -- Subconsulta para tamaño de equipos
    SELECT 
        COALESCE(jefe_info.id_empleado, emp_info.id_empleado) AS id_empleado,
        COUNT(DISTINCT emp_info.id_empleado) AS tamaño_equipo_total
    FROM empleados_jerarquia emp_info
    LEFT JOIN empleados_jerarquia jefe_info ON emp_info.id_jefe = jefe_info.id_empleado
    GROUP BY COALESCE(jefe_info.id_empleado, emp_info.id_empleado)
) equipos ON emp.id_empleado = equipos.id_empleado
ORDER BY clasificacion_rendimiento, rendimiento.total_ventas DESC;

-- 19) JOIN integral: Dashboard organizacional con todas las métricas.
WITH resumen_organizacional AS (
    SELECT 
        d.nombre_dept AS departamento,
        COUNT(DISTINCT emp.id_empleado) AS total_empleados,
        COUNT(DISTINCT CASE WHEN emp.id_jefe IS NULL THEN emp.id_empleado END) AS directores,
        COUNT(DISTINCT CASE WHEN emp.puesto LIKE '%Gerente%' THEN emp.id_empleado END) AS gerentes,
        COUNT(DISTINCT CASE WHEN emp.puesto LIKE '%Supervisor%' THEN emp.id_empleado END) AS supervisores,
        AVG(emp.salario) AS salario_promedio,
        SUM(emp.salario) AS masa_salarial,
        COUNT(DISTINCT v.id_venta) AS total_ventas_transacciones,
        COALESCE(SUM(v.cantidad * v.precio_unitario), 0) AS ingresos_totales,
        COUNT(DISTINCT v.id_producto) AS productos_vendidos_diferentes
    FROM departamentos d
    LEFT JOIN empleados_jerarquia emp ON d.id_departamento = emp.id_departamento
    LEFT JOIN ventas v ON emp.id_empleado = v.id_empleado
    GROUP BY d.id_departamento, d.nombre_dept
)
SELECT 
    departamento,
    total_empleados,
    directores,
    gerentes, 
    supervisores,
    (total_empleados - directores - gerentes - supervisores) AS empleados_base,
    ROUND(salario_promedio, 2) AS salario_promedio,
    masa_salarial AS masa_salarial_total,
    total_ventas_transacciones,
    ROUND(ingresos_totales, 2) AS ingresos_totales,
    productos_vendidos_diferentes,
    -- KPIs Organizacionales
    ROUND(
        CASE 
            WHEN masa_salarial > 0 THEN ingresos_totales / masa_salarial 
            ELSE 0 
        END, 2
    ) AS roi_capital_humano,
    ROUND(
        CASE 
            WHEN total_empleados > 0 THEN ingresos_totales / total_empleados 
            ELSE 0 
        END, 2
    ) AS ingresos_per_capita,
    ROUND(
        CASE 
            WHEN total_ventas_transacciones > 0 THEN ingresos_totales / total_ventas_transacciones 
            ELSE 0 
        END, 2
    ) AS ticket_promedio,
    -- Análisis de estructura
    ROUND((gerentes + supervisores) / NULLIF(total_empleados, 0) * 100, 1) AS porcentaje_management,
    CASE 
        WHEN total_empleados = 0 THEN 'DEPARTAMENTO INACTIVO'
        WHEN ingresos_totales = 0 THEN 'SIN INGRESOS'
        WHEN roi_capital_humano > 3 THEN 'MUY RENTABLE'
        WHEN roi_capital_humano > 1.5 THEN 'RENTABLE'
        WHEN roi_capital_humano > 0.8 THEN 'EQUILIBRADO'
        ELSE 'NECESITA OPTIMIZACIÓN'
    END AS estado_financiero,
    -- Recomendaciones estratégicas
    CASE 
        WHEN total_empleados = 0 THEN 'Evaluar necesidad del departamento'
        WHEN ingresos_totales = 0 THEN 'Implementar estrategia de ventas'
        WHEN porcentaje_management > 40 THEN 'Reducir niveles gerenciales'
        WHEN porcentaje_management < 10 AND total_empleados > 5 THEN 'Necesita más supervisión'
        WHEN roi_capital_humano < 1 THEN 'Optimizar costos o aumentar ventas'
        ELSE 'Mantener estrategia actual'
    END AS recomendacion_estrategica
FROM resumen_organizacional
ORDER BY roi_capital_humano DESC, ingresos_totales DESC;

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
WHERE emp.salario > jefe.salario;

-- 4) MÚLTIPLE JOIN: Empleado, departamento, ventas y productos en una consulta.
SELECT 
    eh.nombre AS empleado,
    d.nombre_dept AS departamento,
    v.fecha_venta,
    p.nombre_producto,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
INNER JOIN ventas v ON eh.id_empleado = v.id_empleado
INNER JOIN productos p ON v.id_producto = p.id_producto
ORDER BY v.fecha_venta DESC, eh.nombre;

-- 5) JOIN con subconsulta: Empleados con ventas superiores al promedio.
SELECT 
    eh.nombre AS empleado,
    d.nombre_dept AS departamento,
    SUM(v.cantidad * v.precio_unitario) AS total_ventas
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
INNER JOIN ventas v ON eh.id_empleado = v.id_empleado
GROUP BY eh.id_empleado, eh.nombre, d.nombre_dept
HAVING total_ventas > (
    SELECT AVG(total_por_empleado) 
    FROM (
        SELECT SUM(v2.cantidad * v2.precio_unitario) AS total_por_empleado
        FROM ventas v2 
        GROUP BY v2.id_empleado
    ) AS promedios
);

-- 6) SELF JOIN jerárquico: Muestra la cadena completa de jefes para cada empleado.
-- Usando recursividad con CTE (Common Table Expression)
WITH RECURSIVE jerarquia AS (
    -- Caso base: empleados sin jefe (nivel 0)
    SELECT 
        id_empleado,
        nombre,
        puesto,
        id_jefe,
        0 AS nivel,
        CAST(nombre AS CHAR(1000)) AS cadena_jerarquica
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
        CAST(CONCAT(j.cadena_jerarquica, ' > ', emp.nombre) AS CHAR(1000))
    FROM empleados_jerarquia emp
    INNER JOIN jerarquia j ON emp.id_jefe = j.id_empleado
)
SELECT 
    nombre AS empleado,
    puesto,
    nivel,
    cadena_jerarquica
FROM jerarquia
ORDER BY nivel, nombre;

-- 7) JOIN con agregación: Ventas totales por empleado, jefe y departamento.
SELECT 
    d.nombre_dept AS departamento,
    jefe.nombre AS jefe,
    emp.nombre AS empleado,
    COUNT(v.id_venta) AS num_ventas,
    COALESCE(SUM(v.cantidad * v.precio_unitario), 0) AS total_ventas,
    COALESCE(AVG(v.cantidad * v.precio_unitario), 0) AS promedio_venta
FROM empleados_jerarquia emp
LEFT JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado
INNER JOIN departamentos d ON emp.id_departamento = d.id_departamento
LEFT JOIN ventas v ON emp.id_empleado = v.id_empleado
GROUP BY d.id_departamento, d.nombre_dept, jefe.id_empleado, jefe.nombre, emp.id_empleado, emp.nombre
ORDER BY d.nombre_dept, jefe.nombre, total_ventas DESC;

-- 8) JOIN condicional: Empleados y sus ventas solo si superan cierto monto.
SELECT 
    eh.nombre AS empleado,
    eh.puesto,
    d.nombre_dept AS departamento,
    SUM(v.cantidad * v.precio_unitario) AS total_ventas
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
INNER JOIN ventas v ON eh.id_empleado = v.id_empleado
GROUP BY eh.id_empleado, eh.nombre, eh.puesto, d.nombre_dept
HAVING total_ventas > 50  -- Solo empleados con más de 50€ en ventas
ORDER BY total_ventas DESC;

-- 9) JOIN con CASE: Clasificación de empleados según su rendimiento en ventas.
SELECT 
    eh.nombre AS empleado,
    eh.puesto,
    d.nombre_dept AS departamento,
    jefe.nombre AS jefe,
    COALESCE(SUM(v.cantidad * v.precio_unitario), 0) AS total_ventas,
    CASE 
        WHEN SUM(v.cantidad * v.precio_unitario) IS NULL THEN 'Sin ventas'
        WHEN SUM(v.cantidad * v.precio_unitario) > 100 THEN 'Excelente'
        WHEN SUM(v.cantidad * v.precio_unitario) > 50 THEN 'Bueno'
        WHEN SUM(v.cantidad * v.precio_unitario) > 20 THEN 'Regular'
        ELSE 'Bajo'
    END AS clasificacion_rendimiento
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
LEFT JOIN empleados_jerarquia jefe ON eh.id_jefe = jefe.id_empleado
LEFT JOIN ventas v ON eh.id_empleado = v.id_empleado
GROUP BY eh.id_empleado, eh.nombre, eh.puesto, d.nombre_dept, jefe.nombre
ORDER BY total_ventas DESC;

-- 10) JOIN complejo: Análisis comparativo entre empleados del mismo nivel jerárquico.
SELECT 
    emp1.nombre AS empleado1,
    emp1.salario AS salario1,
    emp2.nombre AS empleado2,
    emp2.salario AS salario2,
    jefe.nombre AS jefe_comun,
    ABS(emp1.salario - emp2.salario) AS diferencia_salarial
FROM empleados_jerarquia emp1
INNER JOIN empleados_jerarquia emp2 ON emp1.id_jefe = emp2.id_jefe 
    AND emp1.id_empleado < emp2.id_empleado  -- Evita duplicados
INNER JOIN empleados_jerarquia jefe ON emp1.id_jefe = jefe.id_empleado
ORDER BY jefe.nombre, diferencia_salarial DESC;

-- =============================================
-- EJEMPLOS AVANZADOS ADICIONALES
-- =============================================

-- Ejemplo 1: SELF JOIN para encontrar pares de empleados
SELECT '=== PARES DE EMPLEADOS DEL MISMO DEPARTAMENTO ===' AS ejemplo;
SELECT 
    emp1.nombre AS empleado1,
    emp2.nombre AS empleado2,
    d.nombre_dept AS departamento,
    emp1.puesto AS puesto1,
    emp2.puesto AS puesto2
FROM empleados_jerarquia emp1
INNER JOIN empleados_jerarquia emp2 ON emp1.id_departamento = emp2.id_departamento 
    AND emp1.id_empleado < emp2.id_empleado
INNER JOIN departamentos d ON emp1.id_departamento = d.id_departamento
ORDER BY d.nombre_dept, emp1.nombre;

-- Ejemplo 2: JOIN con subconsultas correlacionadas
SELECT '=== EMPLEADOS CON ANÁLISIS DE RENDIMIENTO ===' AS ejemplo;
SELECT 
    eh.nombre AS empleado,
    eh.salario,
    (SELECT COUNT(*) 
     FROM ventas v 
     WHERE v.id_empleado = eh.id_empleado) AS num_ventas,
    (SELECT COALESCE(SUM(v.cantidad * v.precio_unitario), 0) 
     FROM ventas v 
     WHERE v.id_empleado = eh.id_empleado) AS total_ventas,
    (SELECT AVG(e2.salario) 
     FROM empleados_jerarquia e2 
     WHERE e2.puesto = eh.puesto) AS promedio_salarial_puesto
FROM empleados_jerarquia eh
ORDER BY total_ventas DESC;

-- Ejemplo 3: JOIN con ventana deslizante (Window Functions)
SELECT '=== RANKING DE EMPLEADOS POR VENTAS ===' AS ejemplo;
SELECT 
    eh.nombre AS empleado,
    d.nombre_dept AS departamento,
    COALESCE(SUM(v.cantidad * v.precio_unitario), 0) AS total_ventas,
    RANK() OVER (PARTITION BY d.id_departamento ORDER BY SUM(v.cantidad * v.precio_unitario) DESC) AS ranking_dept,
    RANK() OVER (ORDER BY SUM(v.cantidad * v.precio_unitario) DESC) AS ranking_general
FROM empleados_jerarquia eh
INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
LEFT JOIN ventas v ON eh.id_empleado = v.id_empleado
GROUP BY eh.id_empleado, eh.nombre, d.id_departamento, d.nombre_dept
ORDER BY ranking_general;

-- =============================================
-- CASOS PRÁCTICOS EMPRESARIALES
-- =============================================

-- Caso 1: Reporte de estructura organizacional
SELECT '=== ESTRUCTURA ORGANIZACIONAL COMPLETA ===' AS caso;
WITH empleados_con_info AS (
    SELECT 
        eh.id_empleado,
        eh.nombre,
        eh.puesto,
        eh.salario,
        eh.id_jefe,
        d.nombre_dept AS departamento,
        COALESCE(SUM(v.cantidad * v.precio_unitario), 0) AS total_ventas
    FROM empleados_jerarquia eh
    INNER JOIN departamentos d ON eh.id_departamento = d.id_departamento
    LEFT JOIN ventas v ON eh.id_empleado = v.id_empleado
    GROUP BY eh.id_empleado, eh.nombre, eh.puesto, eh.salario, eh.id_jefe, d.nombre_dept
)
SELECT 
    emp.nombre AS empleado,
    emp.puesto,
    emp.departamento,
    emp.salario,
    jefe.nombre AS jefe_directo,
    emp.total_ventas,
    (SELECT COUNT(*) 
     FROM empleados_con_info sub 
     WHERE sub.id_jefe = emp.id_empleado) AS num_subordinados
FROM empleados_con_info emp
LEFT JOIN empleados_con_info jefe ON emp.id_jefe = jefe.id_empleado
ORDER BY emp.departamento, emp.total_ventas DESC;

-- Caso 2: Análisis de eficiencia por equipo
SELECT '=== ANÁLISIS DE EFICIENCIA POR EQUIPO ===' AS caso;
SELECT 
    jefe.nombre AS jefe_equipo,
    jefe.puesto AS puesto_jefe,
    COUNT(sub.id_empleado) AS tamaño_equipo,
    AVG(sub.salario) AS salario_promedio_equipo,
    SUM(COALESCE(ventas_sub.total_ventas, 0)) AS total_ventas_equipo,
    SUM(COALESCE(ventas_sub.total_ventas, 0)) / COUNT(sub.id_empleado) AS ventas_por_empleado
FROM empleados_jerarquia jefe
INNER JOIN empleados_jerarquia sub ON jefe.id_empleado = sub.id_jefe
LEFT JOIN (
    SELECT 
        v.id_empleado,
        SUM(v.cantidad * v.precio_unitario) AS total_ventas
    FROM ventas v
    GROUP BY v.id_empleado
) AS ventas_sub ON sub.id_empleado = ventas_sub.id_empleado
GROUP BY jefe.id_empleado, jefe.nombre, jefe.puesto
ORDER BY ventas_por_empleado DESC;

-- =============================================
-- OPTIMIZACIÓN Y BUENAS PRÁCTICAS
-- =============================================

-- Ejemplo de índices recomendados para mejorar rendimiento
SELECT '=== RECOMENDACIONES DE ÍNDICES ===' AS optimizacion;

/*
-- Índices recomendados para optimizar las consultas de este archivo:

CREATE INDEX idx_empleados_jefe ON empleados_jerarquia(id_jefe);
CREATE INDEX idx_empleados_departamento ON empleados_jerarquia(id_departamento);
CREATE INDEX idx_ventas_empleado ON ventas(id_empleado);
CREATE INDEX idx_ventas_producto ON ventas(id_producto);
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);

-- Índice compuesto para consultas que filtran por empleado y fecha
CREATE INDEX idx_ventas_empleado_fecha ON ventas(id_empleado, fecha_venta);
*/

-- Ejemplo de consulta optimizada vs no optimizada
SELECT '=== COMPARACIÓN DE RENDIMIENTO ===' AS rendimiento;

-- Versión optimizada (usando EXISTS en lugar de IN)
EXPLAIN SELECT 
    eh.nombre 
FROM empleados_jerarquia eh 
WHERE EXISTS (
    SELECT 1 FROM ventas v WHERE v.id_empleado = eh.id_empleado
);

-- =============================================
-- ERRORES COMUNES EN JOINS AVANZADOS
-- =============================================

-- Error 1: SELF JOIN sin alias
-- INCORRECTO:
-- SELECT empleados_jerarquia.nombre, empleados_jerarquia.nombre 
-- FROM empleados_jerarquia 
-- JOIN empleados_jerarquia ON empleados_jerarquia.id_jefe = empleados_jerarquia.id_empleado;

-- CORRECTO:
-- SELECT emp.nombre, jefe.nombre 
-- FROM empleados_jerarquia emp 
-- JOIN empleados_jerarquia jefe ON emp.id_jefe = jefe.id_empleado;

-- Error 2: No considerar la recursividad infinita
-- Al usar CTE recursivo, siempre incluir una condición de parada

-- Error 3: Cartesian product accidental en múltiples JOINs
-- Siempre verificar que las condiciones de JOIN sean correctas

-- =============================================
-- CONCEPTOS CLAVE DE JOINS AVANZADOS
-- =============================================
/*
SELF JOIN:
- Une una tabla consigo misma usando alias diferentes
- Útil para datos jerárquicos (empleado-jefe, categoría-subcategoría)
- Requiere siempre alias de tabla para evitar ambigüedad

MÚLTIPLES JOINS:
- Pueden combinar muchas tablas en una sola consulta
- El orden de los JOINs puede afectar el rendimiento
- Usar paréntesis para clarificar precedencia cuando sea necesario

JOINS CON SUBCONSULTAS:
- Permiten filtros complejos y cálculos avanzados
- Pueden estar en SELECT, WHERE, o FROM
- Considerar el rendimiento vs consultas separadas

CTE RECURSIVO:
- Útil para estructuras jerárquicas de profundidad variable
- Requiere caso base + caso recursivo
- Incluir límite para evitar recursión infinita

OPTIMIZACIÓN:
- Usar índices en columnas de JOIN
- Considerar el orden de las tablas en FROM
- EXPLAIN para analizar planes de ejecución
- EXISTS vs IN para subconsultas correlacionadas

BUENAS PRÁCTICAS:
- Usar alias descriptivos
- Comentar consultas complejas
- Dividir consultas muy complejas en CTEs
- Validar resultados con datasets conocidos
*/

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================