
-- =============================================
-- 7.04_FULL_OUTER_JOIN.sql
-- =============================================
-- Ejemplos de FULL OUTER JOIN en MySQL usando UNION
-- Incluye: simulación de FULL OUTER JOIN, casos prácticos, y comparación con otros JOINs.

-- NOTA IMPORTANTE: MySQL no soporta FULL OUTER JOIN nativo
-- Se simula usando UNION de LEFT JOIN y RIGHT JOIN

-- CREACIÓN COMPLETA DE TABLAS Y DATOS
DROP DATABASE IF EXISTS ejemplo_full_outer_join;
CREATE DATABASE ejemplo_full_outer_join;
USE ejemplo_full_outer_join;
-- =============================================
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

CREATE TABLE proyectos (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_proyecto VARCHAR(100) NOT NULL,
    presupuesto DECIMAL(12,2),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

-- =============================================
-- INSERCIÓN DE DATOS PARA FULL OUTER JOIN
-- =============================================

-- Insertar departamentos (incluyendo algunos sin empleados ni proyectos)
INSERT INTO departamentos (nombre_dept, ubicacion) VALUES
('Ventas', 'Madrid'),
('Marketing', 'Barcelona'),
('IT', 'Valencia'),
('Recursos Humanos', 'Sevilla'),
('Investigación', 'Granada'), -- Sin empleados ni proyectos
('Legal', 'Toledo'),           -- Sin empleados ni proyectos
('Calidad', 'Santander'),      -- Sin empleados ni proyectos
('Logística', 'Zaragoza'),     -- Sin empleados ni proyectos
('Desarrollo', 'Murcia'),      -- Sin empleados ni proyectos
('Internacional', 'Alicante'), -- Sin empleados ni proyectos
('Innovación', 'Córdoba');     -- Sin empleados ni proyectos

-- Insertar empleados (incluyendo algunos sin departamento)
INSERT INTO empleados (nombre, salario, id_departamento) VALUES
('Ana García', 2000, 1), 
('Luis Pérez', 1800, 2), 
('Marta Ruiz', 2200, 1),
('Pedro López', 2500, 3),
('Lucía Gómez', 2100, 3),
('Carmen Silva', 1900, NULL), -- Sin departamento
('Roberto Díaz', 2300, NULL), -- Sin departamento
('Sandra Martín', 1950, NULL),-- Sin departamento
('Carlos Freelance', 3000, NULL), -- Sin departamento
('María Temporal', 2200, NULL);   -- Sin departamento

-- Insertar proyectos (incluyendo algunos sin departamento y en departamentos sin empleados)
INSERT INTO proyectos (nombre_proyecto, presupuesto, id_departamento) VALUES
('Campaña Primavera', 50000, 1),
('Web Corporativa', 75000, 3),
('App Móvil', 120000, 3),
('Evento Anual', 30000, 2),
('Auditoría Anual', 25000, 5),
('Sistema Calidad', 45000, 7),         -- Proyecto en departamento sin empleados
('Proyecto Investigación', 80000, 5),  -- Proyecto en departamento sin empleados
('Proyecto Desarrollo', 95000, 9),     -- Proyecto en departamento sin empleados
('Proyecto Externo', 40000, NULL),     -- Sin departamento
('Proyecto Consultoría', 55000, NULL); -- Sin departamento

-- =============================================
-- INSERCIÓN DE DATOS PARA FULL OUTER JOIN
-- =============================================

-- PRIMERO vamos a ver las estructuras creadas:
SHOW TABLES;

DESCRIBE empleados;
DESCRIBE departamentos;
DESCRIBE proyectos;

-- 1) Simula FULL OUTER JOIN entre empleados y departamentos (muestra todos los empleados y todos los departamentos).
SELECT e.id_empleado, e.nombre AS empleado, e.salario, d.id_departamento, d.nombre_dept AS departamento, d.ubicacion
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
UNION
SELECT e.id_empleado, e.nombre AS empleado, e.salario, d.id_departamento, d.nombre_dept AS departamento, d.ubicacion
FROM empleados e
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento;

    -- 1.1) Probar a cambiar de orden los SELECTs para ver si afecta al resultado.
    -- 1.2) Probar a cambiar de orden los JOINs (LEFT y RIGHT) para ver si afecta al resultado.
    -- 1.3) Probar a usar dos LEFT JOIN seguidos en lugar de LEFT y RIGHT JOIN.
    -- 1.4) Probar a añadir más columnas calculadas en ambos SELECTs para ver cómo se comportan con NULLs.
        -- 1.4.0) Utilización de REPLACE y INSERT INTO...ON DUPLICATE KEY para actualizar datos de un registro existente.
            REPLACE INTO empleados (id_empleado, nombre, salario, id_departamento) VALUES
            (1, 'Ana García', NULL, 1); -- BORRA el registro de Ana, y después vuelv a crear UNO NUEVO.
            
            INSERT INTO empleados (id_empleado, nombre, salario, id_departamento) VALUES
				(2, 'Luis Pérez', 1800, 2)
                ON DUPLICATE KEY UPDATE salario = NULL; -- Actualiza el salario de Luis Pérez (NO LO BORRA).
        -- 1.4.1) Ahora borramos nuevamente la tabla, e insertamos nuevos datos.
            -- Uso de EXPLAIN para analizar el plan de ejecución y optimizar el rendimiento antes de ejecutar:
            EXPLAIN DELETE FROM empleados WHERE 1=1;  -- me indicará cuántos registros se verán afectados.

			-- Diferencias en el auto-increment entre "DELETE * FROM TABLE WHERE" Y "TRUNCATE TABLE"
            DELETE FROM empleados WHERE 1=1;  -- da error porque no hay condición válida: no es clave.
            DELETE FROM empleados WHERE (id_empleado is null) or (id_empleado is not null); -- da error porque aunque es clave, el SGBD detecta que estamos intentando borrar todo.
            SET SQL_SAFE_UPDATES = 0;
            DELETE FROM empleados WHERE 1=1;
            SET SQL_SAFE_UPDATES = 1;
            -- versus: TRUNCATE TABLE empleados;
            -- versus: DROP TABLE empleados; CREATE TABLE empleados (...);
        -- 1.4.2) Insertar nuevos datos con algunos salarios NULL o 0.
        INSERT INTO empleados (nombre, salario, id_departamento) VALUES
        ('Ana García', NULL, 1), -- sin salario
        ('Luis Pérez', 0, 2),  -- salario 0
        ('Marta Ruiz', 2200, 1),
        ('Pedro López', NULL, 3), -- sin salario
        ('Lucía Gómez', 2100, 3),
        ('Carmen Silva', NULL, NULL), -- Sin departamento, y sin salario
        ('Roberto Díaz', 0, NULL),    -- Sin departamento y con salario 0
        ('Sandra Martín', 1950, NULL),-- Sin departamento
        ('Carlos Freelance', NULL, NULL), -- Sin departamento y sin salario
        ('María Temporal', 2200, NULL);   -- Sin departamento

        -- 1.4.3) Añadimos columnas calculadas en ambos SELECTs usando COALESCE, IFNULL, NULLIF.
        SELECT e.id_empleado, e.nombre AS empleado, 
            COALESCE(e.salario, 1500) AS salario_con_minimo,  -- Salario mínimo por defecto
            d.id_departamento, d.nombre_dept AS departamento, d.ubicacion,
            IFNULL(e.salario, 'Salario No Definido') AS salario_texto, -- si e.salario es NULL, muestra texto
            NULLIF(e.salario, 0) AS salario_sin_ceros,  -- Si e.salario es 0, lo convierte a NULL
            IFNULL(NULLIF(e.salario, 0), 'Sin Salario Válido') AS salario_validado
            FROM empleados e
            LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento  
        UNION
            SELECT e.id_empleado, e.nombre AS empleado, 
                COALESCE(e.salario, 1500) AS salario_con_minimo,
                d.id_departamento, d.nombre_dept AS departamento, d.ubicacion,
                IFNULL(e.salario, 'Salario No Definido') AS salario_texto,
                NULLIF(e.salario, 0) AS salario_sin_ceros,
                IFNULL(NULLIF(e.salario, 0), 'Sin Salario Válido') AS salario_validado   
            FROM empleados e
            RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento;   
            

-- 2) Simula FULL OUTER JOIN entre departamentos y proyectos (muestra todos los departamentos y todos los proyectos).
SELECT d.id_departamento, d.nombre_dept AS departamento, d.ubicacion, p.id_proyecto, p.nombre_proyecto, p.presupuesto
FROM departamentos d
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
UNION
SELECT d.id_departamento, d.nombre_dept AS departamento, d.ubicacion, p.id_proyecto, p.nombre_proyecto, p.presupuesto
FROM departamentos d
RIGHT JOIN proyectos p ON d.id_departamento = p.id_departamento;

-- 3) Encuentra todos los registros sin relación (empleados sin departamento Y departamentos sin empleados).
SELECT e.id_empleado, e.nombre AS empleado, e.salario, e.id_departamento, d.nombre_dept AS departamento
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE e.id_departamento IS NULL OR d.id_departamento IS NULL
UNION
SELECT NULL AS id_empleado, NULL AS empleado, NULL AS salario, d.id_departamento, d.nombre_dept AS departamento
FROM departamentos d
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
WHERE e.id_empleado IS NULL;

-- 4) Muestra un reporte completo: todos los empleados y departamentos con información de ambos lados. (Usando COALESCE para manejar NULLs)
SELECT COALESCE(e.nombre, 'Sin Empleado') AS empleado,
       COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
       COALESCE(e.salario, 0) AS salario,
       COALESCE(d.ubicacion, 'Sin Ubicación') AS ubicacion
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
UNION
SELECT COALESCE(e.nombre, 'Sin Empleado') AS empleado,
       COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
       COALESCE(e.salario, 0) AS salario,
       COALESCE(d.ubicacion, 'Sin Ubicación') AS ubicacion
FROM departamentos d
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
WHERE e.id_empleado IS NULL;

-- 5) Reporte financiero avanzado: empleados, departamentos y presupuestos con totales globales.
SELECT COALESCE(e.nombre, 'Sin Empleado') AS empleado,
       COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
       COALESCE(p.nombre_proyecto, 'Sin Proyecto') AS proyecto,
       COALESCE(e.salario, 0) AS salario,
       COALESCE(p.presupuesto, 0) AS presupuesto
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
UNION
SELECT COALESCE(e.nombre, 'Sin Empleado') AS empleado,
       COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
       COALESCE(p.nombre_proyecto, 'Sin Proyecto') AS proyecto,
       COALESCE(e.salario, 0) AS salario,
       COALESCE(p.presupuesto, 0) AS presupuesto
FROM empleados e
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
RIGHT JOIN proyectos p ON d.id_departamento = p.id_departamento;

-- 6) Simula FULL OUTER JOIN con conteo: empleados por departamento incluyendo empleados sin departamento.
SELECT d.nombre_dept AS departamento, COUNT(e.id_empleado) AS num_empleados
FROM departamentos d
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
GROUP BY d.id_departamento
UNION
SELECT 'Sin Departamento' AS departamento, COUNT(*) AS num_empleados
FROM empleados e
WHERE e.id_departamento IS NULL;

-- 7) Comparación: muestra la diferencia entre INNER, LEFT, RIGHT y FULL OUTER JOIN.
-- INNER JOIN
SELECT e.nombre AS empleado, d.nombre_dept AS departamento
FROM empleados e
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento;
-- LEFT JOIN
SELECT e.nombre AS empleado, d.nombre_dept AS departamento
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento;
-- RIGHT JOIN
SELECT e.nombre AS empleado, d.nombre_dept AS departamento
FROM empleados e
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento;
-- FULL OUTER JOIN (simulado)
SELECT e.nombre AS empleado, d.nombre_dept AS departamento
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
UNION
SELECT e.nombre AS empleado, d.nombre_dept AS departamento
FROM empleados e
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- 8) Reporte de auditoría: empleados y departamentos con estado de asignación. (Usando CASE y COALESCE)
SELECT e.nombre AS empleado, d.nombre_dept AS departamento,
             CASE 
                 WHEN e.id_departamento IS NULL THEN 'Empleado sin departamento'
                 WHEN d.id_departamento IS NULL THEN 'Departamento sin empleados'
                 ELSE 'Asignado'
             END AS estado
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
UNION
SELECT e.nombre AS empleado, d.nombre_dept AS departamento,
             CASE 
                 WHEN e.id_departamento IS NULL THEN 'Empleado sin departamento'
                 WHEN d.id_departamento IS NULL THEN 'Departamento sin empleados'
                 ELSE 'Asignado'
             END AS estado
FROM empleados e
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- 9) FULL OUTER JOIN con campos calculados: salarios, bonificaciones y presupuestos.
SELECT COALESCE(e.nombre, 'Sin Empleado') AS empleado,
       COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
       COALESCE(e.salario, 0) AS salario,
       COALESCE(p.presupuesto, 0) AS presupuesto,
       COALESCE(e.salario, 0) * 0.10 AS bonificacion,
       COALESCE(e.salario, 0) + COALESCE(e.salario, 0) * 0.10 AS salario_total
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
UNION
SELECT COALESCE(e.nombre, 'Sin Empleado') AS empleado,
       COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
       COALESCE(e.salario, 0) AS salario,
       COALESCE(p.presupuesto, 0) AS presupuesto,
       COALESCE(e.salario, 0) * 0.10 AS bonificacion,
       COALESCE(e.salario, 0) + COALESCE(e.salario, 0) * 0.10 AS salario_total
FROM empleados e
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
RIGHT JOIN proyectos p ON d.id_departamento = p.id_departamento;

-- 10) FULL OUTER JOIN básico con tres tablas: empleados, departamentos y proyectos.
SELECT COALESCE(e.nombre, 'Sin Empleado') AS empleado,
       COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
       COALESCE(p.nombre_proyecto, 'Sin Proyecto') AS proyecto
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
UNION
SELECT COALESCE(e.nombre, 'Sin Empleado') AS empleado,
       COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
       COALESCE(p.nombre_proyecto, 'Sin Proyecto') AS proyecto
FROM empleados e
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
RIGHT JOIN proyectos p ON d.id_departamento = p.id_departamento;

-- 11) Encuentra registros "huérfanos" en ambas direcciones usando UNION.
SELECT e.nombre AS empleado, d.nombre_dept AS departamento
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE d.id_departamento IS NULL
UNION
SELECT e.nombre AS empleado, d.nombre_dept AS departamento
FROM empleados e
RIGHT JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE e.id_empleado IS NULL;

-- 12) Manejo avanzado de NULLs con COALESCE en FULL OUTER JOIN. Reporte básico: todos los empleados con información de departamento usando FULL OUTER JOIN.
SELECT COALESCE(e.nombre, 'Sin Empleado') AS empleado,
       COALESCE(e.salario, 1500) AS salario_con_minimo,
       COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
       COALESCE(d.ubicacion, 'Ubicación Remota') AS ubicacion,
       COALESCE(p.nombre_proyecto, 'Proyecto En Definición') AS proyecto,
       COALESCE(p.presupuesto, 10000) AS presupuesto_con_minimo,
       IFNULL(e.salario, 'Salario No Definido') AS salario_texto,
       NULLIF(e.salario, 0) AS salario_sin_ceros,
       IFNULL(NULLIF(e.salario, 0), 'Sin Salario Válido') AS salario_validado
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
UNION
SELECT COALESCE(e.nombre, 'Sin Empleado') AS empleado,
       COALESCE(e.salario, 1500) AS salario_con_minimo,
       COALESCE(d.nombre_dept, 'Sin Departamento') AS departamento,
       COALESCE(d.ubicacion, 'Ubicación Remota') AS ubicacion,
       COALESCE(p.nombre_proyecto, 'Proyecto En Definición') AS proyecto,
       COALESCE(p.presupuesto, 10000) AS presupuesto_con_minimo,
       IFNULL(e.salario, 'Salario No Definido') AS salario_texto,
       NULLIF(e.salario, 0) AS salario_sin_ceros,
       IFNULL(NULLIF(e.salario, 0), 'Sin Salario Válido') AS salario_validado
FROM departamentos d
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
WHERE e.id_empleado IS NULL;
UNION

SELECT 
    COALESCE(e.nombre, 'Puesto Vacante') AS empleado,
    d.nombre_dept AS departamento,
    d.ubicacion AS ubicacion,
    COALESCE(e.salario, 0) AS salario_base,
    CASE 
        WHEN d.ubicacion = 'Madrid' THEN COALESCE(e.salario, 0) * 0.15
        WHEN d.ubicacion IN ('Barcelona', 'Valencia') THEN COALESCE(e.salario, 0) * 0.10
        ELSE COALESCE(e.salario, 0) * 0.05
    END AS bonificacion_ubicacion,
    COALESCE(e.salario, 0) + 
    CASE 
        WHEN d.ubicacion = 'Madrid' THEN COALESCE(e.salario, 0) * 0.15

-- 11) Encuentra registros "huérfanos" en ambas direcciones usando UNION.
        WHEN d.ubicacion IN ('Barcelona', 'Valencia') THEN COALESCE(e.salario, 0) * 0.10
        ELSE COALESCE(e.salario, 0) * 0.05
    END AS salario_total,
    COALESCE(p.presupuesto, 0) AS presupuesto_disponible
FROM departamentos d 
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento

ORDER BY salario_total DESC, presupuesto_disponible DESC;

-- 12) Manejo avanzado de NULLs con COALESCE en FULL OUTER JOIN. Reporte básico: todos los empleados con información de departamento usando FULL OUTER JOIN.
SELECT 
    COALESCE(e.nombre, 'Empleado Pendiente') AS empleado,
    COALESCE(e.salario, 1500, 0) AS salario_con_minimo,  -- Salario mínimo por defecto
    COALESCE(d.nombre_dept, 'Departamento Por Asignar') AS departamento,
    COALESCE(d.ubicacion, 'Ubicación Remota') AS ubicacion,
    COALESCE(p.nombre_proyecto, 'Proyecto En Definición') AS proyecto,
    COALESCE(p.presupuesto, 10000, 0) AS presupuesto_con_minimo,  -- Presupuesto mínimo
    -- Campos calculados con manejo de NULLs
    IFNULL(e.salario, 'Salario No Definido') AS salario_texto, -- si e.salario es NULL, muestra texto
    NULLIF(e.salario, 0) AS salario_sin_ceros,  -- Si e.salario es 0, lo convierte a NULL
    IFNULL(NULLIF(e.salario, 0), 'Sin Salario Válido') AS salario_validado
FROM empleados e 
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento

UNION

SELECT 
    COALESCE(e.nombre, 'Empleado Pendiente') AS empleado,
    COALESCE(e.salario, 1500, 0) AS salario_con_minimo,
    d.nombre_dept AS departamento,
    d.ubicacion AS ubicacion,
    COALESCE(p.nombre_proyecto, 'Proyecto En Definición') AS proyecto,
    COALESCE(p.presupuesto, 10000, 0) AS presupuesto_con_minimo,
    IFNULL(e.salario, 'Salario No Definido') AS salario_texto,
    NULLIF(e.salario, 0) AS salario_sin_ceros,
    IFNULL(NULLIF(e.salario, 0), 'Sin Salario Válido') AS salario_validado
FROM departamentos d 
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
WHERE e.id_empleado IS NULL

ORDER BY salario_con_minimo DESC;



-- =============================================
-- CONCEPTOS CLAVE DEL FULL OUTER JOIN
-- =============================================
/*
FULL OUTER JOIN (simulado en MySQL):
- Combina LEFT JOIN y RIGHT JOIN usando UNION
- Devuelve TODAS las filas de ambas tablas
- Rellena con NULL donde no hay coincidencias en cualquier lado
- Útil para análisis completos y auditorías

SINTAXIS EN MySQL (simulado):
SELECT columnas
FROM tabla1
LEFT JOIN tabla2 ON tabla1.columna = tabla2.columna
UNION
SELECT columnas  
FROM tabla1
RIGHT JOIN tabla2 ON tabla1.columna = tabla2.columna;

CUÁNDO USAR FULL OUTER JOIN:
- Análisis de datos completos (todos los registros de ambas tablas)
- Auditorías para encontrar datos huérfanos en ambas direcciones
- Reportes que deben mostrar el estado completo de las relaciones
- Identificar registros que necesitan limpieza o asignación

VENTAJAS:
- Visión completa de los datos
- Identifica problemas en ambas direcciones
- Útil para migraciones de datos

DESVENTAJAS:
- Más complejo en MySQL (requiere UNION)
- Puede devolver muchos registros
- Requiere manejo cuidadoso de NULLs
*/

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================