-- =============================================
-- 7.01_INNER_JOIN.sql
-- =============================================
-- Ejemplos de uso de INNER JOIN en consultas multitabla
-- Incluye: INNER JOIN básico, múltiples tablas, condiciones WHERE adicionales y alias.

-- CREACIÓN COMPLETA DE TABLAS Y DATOS
DROP DATABASE IF EXISTS ejemplo_joins;
CREATE DATABASE ejemplo_joins;
USE ejemplo_joins;

-- =============================================
-- CREACIÓN DE TABLAS
-- =============================================

-- Tabla de departamentos
CREATE TABLE departamentos (
    id_departamento INT PRIMARY KEY,
    nombre_dept VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(50)
);

-- Habilitar AUTO_INCREMENT en id_departamento
ALTER TABLE departamentos
MODIFY id_departamento INT AUTO_INCREMENT;



-- Tabla de empleados básica
CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    salario DECIMAL(10,2),
    id_departamento INT
    -- FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

-- Añadir la clave foránea después de la creación de la tabla
ALTER TABLE empleados
ADD FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento);


-- Tabla de proyectos
CREATE TABLE proyectos (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_proyecto VARCHAR(100) NOT NULL,
    -- presupuesto DECIMAL(12,2),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

-- Añadir la columna presupuesto después de la creación de la tabla
ALTER TABLE proyectos
ADD COLUMN presupuesto DECIMAL(12,2);

-- =============================================
-- INSERCIÓN DE DATOS
-- =============================================

-- Datos de departamentos
INSERT INTO departamentos (nombre_dept, ubicacion) VALUES
('Ventas', 'MadriZ'),  -- error en texto intencionado
('Marketing', 'Barcelona'),
('IT', 'Valencia'),
('Recursos Humanos', 'Sevilla'),
('Finanzas', 'Bilbao'),
('Investigación', 'Granada'),
('Legal', 'Toledo'),
('Calidad', 'Santander'),
('Logística', 'Zaragoza');

-- Corrección de 'MadriZ' a 'Madrid'
SET SQL_SAFE_UPDATES = 0;

UPDATE departamentos
SET ubicacion = 'Madrid'
WHERE ubicacion = 'MadriZ';  -- da error por safe-mode, ya que ubicacion no es índice

SET SQL_SAFE_UPDATES = 1;
    -- alternativa 1: deshabilitar safe-mode temporalmente
        -- SET SQL_SAFE_UPDATES = 0; -- y luego volver a activarlo con SET SQL_SAFE_UPDATES = 1;
    -- alternativa 2: usar subconsulta para evitar el error
        -- UPDATE departamentos
            -- SET ubicacion = 'Madrid'
            -- WHERE id_departamento IN (
            -- SELECT id_departamento FROM (SELECT id_departamento FROM departamentos WHERE nombre_dept = 'Ventas' AND ubicacion = 'Madriz') AS sub
            -- );
    -- alternativa 3: buscar el id del departamento primero
         SELECT id_departamento FROM departamentos WHERE nombre_dept = 'Ventas' AND ubicacion = 'Madrid';
        -- Luego usar ese id en el UPDATE:
         UPDATE departamentos
         SET ubicacion = 'Madrid'
         WHERE id_departamento = 1; -- el id obtenido


-- Datos de empleados básicos
INSERT INTO empleados (nombre, salario, id_departamento) VALUES
('Ana García', 1800, 1),
('Luis Pérez', 2000, 2),
('Marta Ruiz', 2200, 1),
('Pedro López', 2500, 3),
('Lucía Gómez', 2100, 3),
('Carmen Silva', 1900, NULL),
('Roberto Díaz', 2300, NULL),
('Sandra Martín', 1950, NULL),
('Elena Vázquez', 2400, NULL),
('Diego Moreno', 1850, NULL);

-- Vacía la tabla y vuelve a insertar empleados con departamento NULL
DELETE FROM empleados;   -- NO REINICIA el AUTO_INCREMENT.
    -- además, da error por el Safe_mode: SET SQL_SAFE_UPDATES = 0
    -- Deshabilitar safe-mode temporalmente con SET SQL_SAFE_UPDATES = 0;
    -- La forma correcta es usarlo con WHERE y un index:
            DELETE FROM empleados
            WHERE (id_departamento IS NULL) or (id_departamento IS NOT NULL); 

        -- Si quieres ahora reiniciar el contador del id:
            -- ALTER TABLE empleados AUTO_INCREMENT = 1;
                 -- Recuerda: Si la tabla no está vacía, 
                 -- el valor debe ser mayor que el id más alto existente.
    
    -- Alternativa: TRUNCATE TABLE empleados; -- reinicia el AUTO_INCREMENT.

INSERT INTO empleados (nombre, salario, id_departamento) VALUES
('Ana García', 1800, 1),
('Luis Pérez', 2000, 2),
('Marta Ruiz', 2200, 1),
('Pedro López', 2500, 3),
('Lucía Gómez', 2100, 3),
('Carmen Silva', 1900, NULL),
('Roberto Díaz', 2300, NULL),
('Sandra Martín', 1950, NULL),
('Elena Vázquez', 2400, NULL),
('Diego Moreno', 1850, NULL);

-- Datos de proyectos
INSERT INTO proyectos (nombre_proyecto, presupuesto, id_departamento) VALUES
('Campaña Primavera', 50000, 1),
('Web Corporativa', 75000, 3),
('App Móvil', 120000, 3),
('Evento Anual', 30000, 2),
('Auditoría Anual', 25000, 5),
('Consulta Legal', 15000, 7),
('Sistema Calidad', 45000, 8),
('Optimización Logística', 60000, 9);

-- =============================================
-- ENUNCIADOS DE PROBLEMAS PROPUESTOS
-- =============================================

-- *** EJERCICIOS BÁSICOS CON INNER JOIN (1-11) ***
-- 1) Muestra todos los empleados con el nombre de su departamento.
-- 2) Muestra los empleados del departamento 'Ventas' con el nombre del departamento.
-- 3) Muestra todos los proyectos con el nombre del departamento responsable.
-- 4) Muestra el nombre del empleado, su salario y la ubicación de su departamento.
-- 5) Muestra los empleados que trabajan en departamentos ubicados en 'Madrid'.
-- 6) Muestra los proyectos del departamento 'IT' con el nombre del departamento.
-- 7) Muestra el nombre del empleado y su departamento, ordenados por nombre del empleado.
-- 8) Muestra todos los proyectos con presupuesto mayor a 40000 y el nombre de su departamento.
-- 9) Muestra empleados cuyo salario esté entre 1900 y 2200, con el nombre del departamento.
-- 10) Muestra los departamentos que tienen al menos un empleado (usando INNER JOIN).
        -- prueba el resultado con left y right join para ver la diferencia.
-- 11) Muestra el nombre del proyecto, presupuesto y ubicación del departamento responsable.

-- *** EJERCICIOS AVANZADOS CON INNER JOIN (12-20) ***
-- 12) Muestra el salario promedio, máximo y mínimo por departamento (solo departamentos con empleados).
-- 13) Muestra los empleados únicos (DISTINCT) que trabajan en proyectos con presupuesto superior a 50000.
        -- Comportamiento DISTINCT: DISTINCT aplica a la combinación completa de las 
        -- tres columnas. La consulta devolverá filas únicas solo si la combinación de
        -- nombre de empleado, nombre de departamento y presupuesto es diferente de las 
        -- demás filas. La palabra clave DISTINCT siempre se aplica a todas las columnas 
        -- listadas en la cláusula SELECT, no sirve aplicar paréntesis a atributos.
-- 14) Calcula el presupuesto total, promedio y número de proyectos por departamento.
-- 15) Muestra empleados con salario calculado (salario + bonificación del 10% si está en Madrid, 5% en otros casos).
    -- Lo que quiero mostar es el nombre del empleado, departamento, ubicación, salario base,
    -- salario con bonificación y el monto de la bonificación aplicada.
-- 16) Clasifica empleados según su salario: 'Alto' (>2200), 'Medio' (1900-2200), 'Bajo' (<1900).
-- 17) Muestra empleados con información de salario usando operadores condicionales. Mostraremos:
    -- nombre del empleado, nombre del departamento, salario original,
    -- salario mostrado (mostrando 'No definido' si es NULL): COALESCE,
    -- salario para cálculos (si es NULL, usar 0): IFNULL,
    -- salario sin ceros (si es 0, convertir a NULL): NULLIF.
-- Nota: Agregamos un empleado con salario NULL para demonstrar, y ponemos otro salario a 0.
-- 18) Muestra departamentos con empleados cuyo salario sea superior al salario promedio general.
-- 19) Calcula la diferencia entre el presupuesto máximo y mínimo por departamento.
    -- Mostraremos el nombre del departamento, número de proyectos,
    -- presupuesto mínimo, presupuesto máximo, diferencia entre ambos,
    -- y el porcentaje (redondeado, y con símbolo '%') que representa esa diferencia respecto al presupuesto mínimo.
-- 20) Muestra empleados que NO tienen el salario más bajo de su departamento (usando subconsulta).
    -- Éste sería el salario mínimo de toda la empresa:
        -- select salario from empleados where (salario is not null) and (salario <> 0) order by salario ASC limit 1; 
    -- Pero me piden el mínimo por departamento, así que uso una subconsulta correlacionada.

-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================

-- *** SOLUCIONES EJERCICIOS BÁSICOS (1-11) ***

-- 1) Muestra todos los empleados con el nombre de su departamento.
SELECT e.nombre, d.nombre_dept 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- 2) Muestra los empleados del departamento 'Ventas' con el nombre del departamento.
SELECT e.nombre, d.nombre_dept 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE d.nombre_dept = 'Ventas';

    -- alternativa con subconsulta
    /* SELECT e.nombre, 
           (SELECT nombre_dept 
            FROM departamentos d 
            WHERE d.id_departamento = e.id_departamento) AS nombre_dept
            FROM empleados e
            WHERE e.id_departamento = (SELECT id_departamento 
                                        FROM departamentos 
                                        WHERE nombre_dept = 'Ventas') */

-- 3) Muestra todos los proyectos con el nombre del departamento responsable.
SELECT p.nombre_proyecto, d.nombre_dept 
FROM proyectos p 
INNER JOIN departamentos d ON p.id_departamento = d.id_departamento;

-- 4) Muestra el nombre del empleado, su salario y la ubicación de su departamento.
SELECT e.nombre, e.salario, d.ubicacion 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- 5) Muestra los empleados que trabajan en departamentos ubicados en 'Madrid'.
SELECT e.nombre, d.nombre_dept, d.ubicacion 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE d.ubicacion = 'Madrid';

-- 6) Muestra los proyectos del departamento 'IT' con el nombre del departamento.
SELECT p.nombre_proyecto, p.presupuesto, d.nombre_dept 
FROM proyectos p 
INNER JOIN departamentos d ON p.id_departamento = d.id_departamento
WHERE d.nombre_dept = 'IT';

-- 7) Muestra el nombre del empleado y su departamento, ordenados por nombre del empleado.
SELECT e.nombre, d.nombre_dept 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY e.nombre;

-- 8) Muestra todos los proyectos con presupuesto mayor a 40000 y el nombre de su departamento.
SELECT p.nombre_proyecto, p.presupuesto, d.nombre_dept 
FROM proyectos p 
INNER JOIN departamentos d ON p.id_departamento = d.id_departamento
WHERE p.presupuesto > 40000;

-- 9) Muestra empleados cuyo salario esté entre 1900 y 2200, con el nombre del departamento.
SELECT e.nombre, e.salario, d.nombre_dept 
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE e.salario BETWEEN 1900 AND 2200;

-- 10) Muestra los departamentos que tienen al menos un empleado (usando INNER JOIN).
SELECT DISTINCT d.nombre_dept, d.ubicacion 
FROM departamentos d 
INNER JOIN empleados e ON d.id_departamento = e.id_departamento;

-- 11) Muestra el nombre del proyecto, presupuesto y ubicación del departamento responsable.
SELECT p.nombre_proyecto, p.presupuesto, d.ubicacion 
FROM proyectos p 
INNER JOIN departamentos d ON p.id_departamento = d.id_departamento;

-- *** SOLUCIONES EJERCICIOS AVANZADOS (12-20) ***

-- 12) Muestra el número de empleados, salario promedio, máximo y mínimo por departamento (solo departamentos con empleados).
-- y ordena por salario promedio de mayor a menor.
    -- "solo departamentos con empleados" => INNER JOIN garantiza esto.
SELECT 
    d.nombre_dept,
    COUNT(e.id_empleado) AS num_empleados,
    AVG(e.salario) AS salario_promedio,
    MAX(e.salario) AS salario_maximo,
    MIN(e.salario) AS salario_minimo
FROM departamentos d 
INNER JOIN empleados e ON d.id_departamento = e.id_departamento
GROUP BY d.id_departamento, d.nombre_dept
ORDER BY salario_promedio DESC;

-- 13) Muestra los empleados únicos (DISTINCT) que trabajan en proyectos con presupuesto superior a 50000.
        -- Comportamiento DISTINCT: DISTINCT aplica a la combinación completa de las 
        -- tres columnas. La consulta devolverá filas únicas solo si la combinación de
        -- nombre de empleado, nombre de departamento y presupuesto es diferente de las 
        -- demás filas. La palabra clave DISTINCT siempre se aplica a todas las columnas 
        -- listadas en la cláusula SELECT, no sirve aplicar paréntesis a atributos.
SELECT DISTINCT 
    e.nombre, 
    e.salario, 
    d.nombre_dept
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
INNER JOIN proyectos p ON d.id_departamento = p.id_departamento
WHERE p.presupuesto > 50000
ORDER BY e.nombre;

-- 14) Calcula el presupuesto total, promedio y número de proyectos por departamento.
SELECT 
    d.nombre_dept,
    COUNT(p.id_proyecto) AS num_proyectos,
    SUM(p.presupuesto) AS presupuesto_total,
    AVG(p.presupuesto) AS presupuesto_promedio,
    MAX(p.presupuesto) AS presupuesto_maximo
FROM departamentos d 
INNER JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept
ORDER BY presupuesto_total DESC;

-- 15) Muestra empleados con salario calculado (salario + bonificación del 10% si está en Madrid, 5% en otros casos).
    -- Lo que quiero mostar es el nombre del empleado, departamento, ubicación, salario base,
    -- salario con bonificación y el monto de la bonificación aplicada.
SELECT 
    e.nombre,
    d.nombre_dept,
    d.ubicacion,
    e.salario AS salario_base,
    
    CASE 
        WHEN d.ubicacion = 'Madrid' THEN e.salario * 1.10
        ELSE e.salario * 1.05
    END AS salario_con_bonificacion,
    
    IF ( d.ubicacion = 'Madrid', e.salario * 0.10, e.salario * 0.05) AS bonificacion
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY salario_con_bonificacion DESC;

-- 16) Clasifica empleados según su salario: 'Alto' (>2200), 'Medio' (1900-2200), 'Bajo' (<1900).
SELECT 
    e.nombre,
    d.nombre_dept,
    e.salario,
    CASE 
        WHEN e.salario > 2200 THEN 'Alto'
        WHEN e.salario >= 1900 THEN 'Medio'
        ELSE 'Bajo'
    END AS categoria_salarial,
    IF(e.salario > 2000, 'Objetivo cumplido', 'Necesita mejora') AS evaluacion
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY e.salario DESC;

-- 17) Muestra empleados con información de salario usando operadores condicionales. Mostraremos:
    -- nombre del empleado, nombre del departamento, salario original,
    -- salario mostrado (mostrando 'No definido' si es NULL): COALESCE,
    -- salario para cálculos (si es NULL, usar 0): IFNULL,
    -- salario sin ceros (si es 0, convertir a NULL): NULLIF.
-- Nota: Agregamos un empleado con salario NULL para demonstrar, y ponemos otro salario a 0.

INSERT INTO empleados (nombre, salario, id_departamento) VALUES 
('Test Empleado', NULL, 1);
INSERT INTO empleados (nombre, salario, id_departamento) VALUES 
('Empleado Cero', 0, 2);

SELECT 
    e.nombre,
    d.nombre_dept,
    e.salario as salario_original,
    COALESCE(CAST(e.salario AS CHAR), 'No definido') AS salario_mostrado,
    IFNULL(e.salario, 0) AS salario_para_calculos,
    NULLIF(e.salario, 0) AS salario_sin_ceros  -- Convierte 0 a NULL
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY e.salario DESC;

-- 18) Muestra los departamentos con empleados cuyo salario sea superior al salario promedio general.
SELECT 
    d.nombre_dept,
    e.nombre,
    e.salario,
    (SELECT AVG(salario) FROM empleados WHERE salario IS NOT NULL) AS salario_promedio_general
FROM departamentos d 
INNER JOIN empleados e ON d.id_departamento = e.id_departamento
WHERE e.salario > (
    SELECT AVG(salario) 
    FROM empleados 
    WHERE salario IS NOT NULL
)
ORDER BY d.nombre_dept DESC;

-- 19) Calcula la diferencia entre el presupuesto máximo y mínimo por departamento.
    -- Mostraremos el nombre del departamento, número de proyectos,
    -- presupuesto mínimo, presupuesto máximo, diferencia entre ambos,
    -- y el porcentaje (redondeado, y con símbolo '%') que representa esa diferencia respecto al presupuesto mínimo.
SELECT 
    d.nombre_dept,
    COUNT(p.id_proyecto) AS num_proyectos,
    MIN(p.presupuesto) AS presupuesto_minimo,
    MAX(p.presupuesto) AS presupuesto_maximo,
    (MAX(p.presupuesto) - MIN(p.presupuesto)) AS diferencia_presupuesto,
    CONCAT(ROUND((MAX(p.presupuesto) - MIN(p.presupuesto)) / MIN(p.presupuesto) * 100, 2), '%') AS porcentaje_diferencia
FROM departamentos d 
INNER JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept
HAVING COUNT(p.id_proyecto) > 1  -- Solo departamentos con más de un proyecto
ORDER BY diferencia_presupuesto DESC;

-- 20) Muestra empleados que NO tienen el salario más bajo de su departamento (usando subconsulta).
    -- Éste sería el salario mínimo de toda la empresa:
        -- select salario from empleados where (salario is not null) and (salario <> 0) order by salario ASC limit 1; 
    -- Pero me piden el mínimo por departamento, así que uso una subconsulta correlacionada.
SELECT 
    e.nombre,
    d.nombre_dept,
    e.salario,
    (SELECT MIN(e2.salario) 
     FROM empleados e2 
     WHERE e2.id_departamento = e.id_departamento 
     AND e2.salario IS NOT NULL) AS salario_minimo_dept
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE e.salario IS NOT NULL  -- and ( e.salario > salario_minimo_dept ): NO funciona, porque where se ejecuta antes de la consulta.
AND e.salario > (
    SELECT MIN(e2.salario) 
    FROM empleados e2 
    WHERE e2.id_departamento = e.id_departamento 
    AND e2.salario IS NOT NULL
)
ORDER BY d.nombre_dept, e.salario DESC;

-- =============================================
-- EJEMPLOS ADICIONALES CON FUNCIONES AVANZADAS
-- =============================================

-- Ejemplo 1.1: Combinación de agregadores con CASE
    -- Contar empleados con salario mayor y menor o igual a 2000 POR DEPARTAMENTO,
    -- y mostrar el promedio de salarios en Madrid y en otras ciudades.
SELECT 
    d.nombre_dept,
    COUNT(e.id_empleado) AS total_empleados,
    SUM(CASE WHEN e.salario > 2000 THEN 1 ELSE 0 END) AS empleados_salario_alto,
    SUM(CASE WHEN e.salario <= 2000 THEN 1 ELSE 0 END) AS empleados_salario_bajo,
    AVG(CASE WHEN d.ubicacion = 'Madrid' THEN e.salario ELSE NULL END) AS promedio_madrid,
    AVG(CASE WHEN d.ubicacion != 'Madrid' THEN e.salario ELSE NULL END) AS promedio_otras_ciudades
FROM departamentos d 
INNER JOIN empleados e ON d.id_departamento = e.id_departamento
WHERE e.salario IS NOT NULL
GROUP BY d.id_departamento, d.nombre_dept, d.ubicacion
ORDER BY total_empleados DESC;

-- Ejemplo 1.2: Combinación de agregadores con CASE (variante)
    -- Contar proyectos con presupuesto alto (>60000) y bajo (<=60000) POR DEPARTAMENTO,
    -- y mostrar el presupuesto total y promedio por departamento.
SELECT 
    d.nombre_dept,
    COUNT(p.id_proyecto) AS total_proyectos,
    SUM(CASE WHEN p.presupuesto > 60000 THEN 1 ELSE 0 END) AS proyectos_presupuesto_alto,
    SUM(CASE WHEN p.presupuesto <= 60000 THEN 1 ELSE 0 END) AS proyectos_presupuesto_bajo,
    SUM(p.presupuesto) AS presupuesto_total,
    AVG(p.presupuesto) AS presupuesto_promedio
FROM departamentos d 
INNER JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre_dept
ORDER BY total_proyectos DESC;

-- Ejemplo 2: DISTINCT con funciones de cadena y cálculos.
    -- Mostrar los distintos departamentos con nombre en mayúsculas, ubicación en minúsculas,
    -- descripción completa ("nombre departamento - ubicación"), número de empleados y proyectos asociados.
SELECT DISTINCT
    UPPER(d.nombre_dept) AS departamento_mayusculas,
    LOWER(d.ubicacion) AS ciudad_minusculas,
    CONCAT(d.nombre_dept, ' - ', d.ubicacion) AS descripcion_completa,
    (SELECT COUNT(*) FROM empleados e2 WHERE e2.id_departamento = d.id_departamento) AS num_empleados,
    (SELECT COUNT(*) FROM proyectos p2 WHERE p2.id_departamento = d.id_departamento) AS num_proyectos
FROM departamentos d 
INNER JOIN empleados e ON d.id_departamento = e.id_departamento
ORDER BY departamento_mayusculas;

-- Ejemplo 2.1: DISTINCT con funciones de cadena y cálculos (variante)
    -- Mostrar los diferentes proyectos con nombre en mayúsculas (ordenados), 
    -- presupuesto formateado con símbolo €,
    -- y departamento responsable en minúsculas.
SELECT DISTINCT
    UPPER(p.nombre_proyecto) AS proyecto_mayusculas,
    CONCAT(FORMAT(p.presupuesto, 2), ' €') AS presupuesto_formateado,
    LOWER(d.nombre_dept) AS departamento_minusculas
FROM proyectos p 
INNER JOIN departamentos d ON p.id_departamento = d.id_departamento
ORDER BY proyecto_mayusculas;


-- Ejemplo 3: Múltiples funciones COALESCE, IFNULL y NULLIF
    -- Mostrar nombre del empleado, nombre del departamento,
    -- "salario con valor mínimo" si es NULL: COALESCE,
    -- "salario como texto" si es NULL: IFNULL,
    -- "salario sin valor específico" si es 2000: NULLIF,
    -- y clasificar el tipo de salario con CASE: 
        -- 'No definido' si es NULL,
        -- 'Salario base' si es 2000,
        -- 'Salario personalizado' en otros casos.
SELECT 
    e.nombre,
    d.nombre_dept,
    COALESCE(e.salario, 1500) AS salario_con_minimo,
    IFNULL(e.salario, 'Sin salario') AS salario_texto,
    NULLIF(e.salario, 2000) AS salario_sin_2000,  -- Convierte 2000 a NULL
    CASE 
        WHEN e.salario IS NULL THEN 'No definido'
        WHEN e.salario = 2000 THEN 'Salario base'
        ELSE 'Salario personalizado'
    END AS tipo_salario
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY e.salario;

-- Ejemplo 4: Subconsultas correlacionadas complejas
    -- Mostrar nombre del empleado, nombre del departamento, salario,
    -- promedio de salarios en la misma ciudad,
    -- número de empleados en el mismo departamento con salario mayor,
    -- y comparar el salario del empleado con el promedio de su departamento (CASE).
SELECT 
    e.nombre,
    d.nombre_dept,
    e.salario,
    (SELECT AVG(e2.salario) 
     FROM empleados e2 
     INNER JOIN departamentos d2 ON e2.id_departamento = d2.id_departamento
     WHERE d2.ubicacion = d.ubicacion AND e2.salario IS NOT NULL) AS promedio_ciudad,
    (SELECT COUNT(*) 
     FROM empleados e3 
     WHERE e3.id_departamento = e.id_departamento 
     AND e3.salario > e.salario) AS empleados_con_mayor_salario,
    CASE 
        WHEN e.salario > (SELECT AVG(e4.salario) FROM empleados e4 WHERE e4.id_departamento = e.id_departamento AND e4.salario IS NOT NULL) 
        THEN 'Por encima del promedio' 
        ELSE 'Por debajo del promedio' 
    END AS comparacion_departamento
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE e.salario IS NOT NULL
ORDER BY d.nombre_dept, e.salario DESC;

-- Ejemplo 5: Campos calculados avanzados con múltiples operaciones
    -- Mostrar nombre del empleado, nombre del departamento, ubicación,
    -- salario mensual, salario anual,
    -- salario anual con beneficios (15% adicional),
    -- estimación de impuestos según ubicación (25% Madrid, 23% Barcelona, 20% otras): CASE,
    -- y salario neto anual estimado después de impuestos: CASE.
SELECT 
    e.nombre,
    d.nombre_dept,
    d.ubicacion,
    e.salario AS salario_mensual,
    e.salario * 12 AS salario_anual,
    ROUND(e.salario * 12 * 1.15, 2) AS salario_anual_con_beneficios,
    CASE 
        WHEN d.ubicacion = 'Madrid' THEN e.salario * 12 * 0.25  -- 25% impuestos Madrid
        WHEN d.ubicacion = 'Barcelona' THEN e.salario * 12 * 0.23  -- 23% impuestos Barcelona
        ELSE e.salario * 12 * 0.20  -- 20% otras ciudades
    END AS estimacion_impuestos,
    ROUND(
        (e.salario * 12) - 
        CASE 
            WHEN d.ubicacion = 'Madrid' THEN e.salario * 12 * 0.25
            WHEN d.ubicacion = 'Barcelona' THEN e.salario * 12 * 0.23
            ELSE e.salario * 12 * 0.20
        END, 2
    ) AS salario_neto_estimado
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
WHERE e.salario IS NOT NULL
ORDER BY salario_neto_estimado DESC;

-- =============================================
-- ERRORES COMUNES EN JOINS AVANZADOS
-- =============================================

-- Error 1: No especificar la condición de JOIN
-- SELECT e.nombre, d.nombre_dept FROM empleados e INNER JOIN departamentos d; -- Error de sintaxis

-- Error 2: Ambigüedad en nombres de columnas
-- SELECT nombre, nombre_dept FROM empleados INNER JOIN departamentos ON empleados.id_departamento = departamentos.id_departamento; -- Error si no se especifica la tabla

-- Error 3: Usar WHERE en lugar de ON para la condición del JOIN
-- SELECT e.nombre, d.nombre_dept FROM empleados e INNER JOIN departamentos d WHERE e.id_departamento = d.id_departamento; -- Funciona pero no es la forma correcta

-- Error 4: Agregar columnas no agrupadas en GROUP BY
-- INCORRECTO: SELECT d.nombre_dept, e.nombre, AVG(e.salario) FROM empleados e INNER JOIN departamentos d ON e.id_departamento = d.id_departamento GROUP BY d.nombre_dept;
-- CORRECTO:
SELECT d.nombre_dept, AVG(e.salario) AS promedio_salario
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento 
GROUP BY d.id_departamento, d.nombre_dept;

-- Error 5: No manejar valores NULL en agregaciones
-- PROBLEMÁTICO:
-- SELECT AVG(salario) FROM empleados; -- Puede dar resultado inesperado si hay NULLs

-- CORRECTO:
SELECT 
    AVG(COALESCE(salario, 0)) AS promedio_con_ceros,
    AVG(salario) AS promedio_sin_nulls,
    COUNT(*) AS total_empleados,
    COUNT(salario) AS empleados_con_salario
FROM empleados;

-- Error 6: CASE sin ELSE puede devolver NULL
-- PROBLEMÁTICO:
-- SELECT nombre, CASE WHEN salario > 2000 THEN 'Alto' END FROM empleados;

-- CORRECTO:
SELECT nombre, 
       CASE 
           WHEN salario > 2000 THEN 'Alto' 
           ELSE 'Normal' 
       END AS categoria
FROM empleados;

-- Error 7: Subconsultas que devuelven múltiples filas donde se esperaba una
-- INCORRECTO: 
-- SELECT * FROM empleados WHERE id_departamento = (SELECT id_departamento FROM departamentos);

-- CORRECTO:
-- SELECT * FROM empleados WHERE id_departamento IN (SELECT id_departamento FROM departamentos);

-- =============================================
-- CONCEPTOS CLAVE DEL INNER JOIN Y FUNCIONES AVANZADAS
-- =============================================
/*
INNER JOIN:
- Devuelve solo las filas que tienen coincidencias en ambas tablas
- Si un empleado no tiene departamento asignado (NULL), no aparecerá en el resultado
- Si un departamento no tiene empleados, no aparecerá en el resultado
- Es el tipo de JOIN más restrictivo

SINTAXIS:
SELECT columnas
FROM tabla1
INNER JOIN tabla2 ON tabla1.columna = tabla2.columna;

FUNCIONES DE AGREGACIÓN:
- COUNT(): Cuenta filas (COUNT(*) incluye NULLs, COUNT(columna) los excluye)
- SUM(): Suma valores numéricos
- AVG(): Promedio (excluye automáticamente NULLs)
- MAX()/MIN(): Valores máximo y mínimo
- GROUP BY: Agrupa resultados para aplicar funciones de agregación

DISTINCT:
- Elimina filas duplicadas del resultado
- Se aplica a toda la fila, no solo a una columna
- Útil para obtener valores únicos

FUNCIONES CONDICIONALES:
- CASE WHEN...THEN...ELSE...END: Lógica condicional compleja
- IF(condicion, valor_true, valor_false): Condición simple (MySQL)
- COALESCE(val1, val2, ...): Devuelve el primer valor no NULL
- IFNULL(valor, reemplazo): Reemplaza NULL con otro valor (MySQL)
- NULLIF(val1, val2): Devuelve NULL si val1 = val2

CAMPOS CALCULADOS:
- Operaciones matemáticas: +, -, *, /, %
- Funciones de cadena: CONCAT(), UPPER(), LOWER()
- Funciones de fecha: NOW(), DATE(), YEAR()
- Combinación con CASE para lógica compleja

SUBCONSULTAS:
- En SELECT: Para calcular valores correlacionados
- En WHERE: Para filtros basados en otras tablas
- En FROM: Como tablas temporales (subquery)
- Correlacionadas: Referencian la consulta externa
- No correlacionadas: Independientes de la consulta externa

BUENAS PRÁCTICAS:
- Usar alias descriptivos para mejorar legibilidad
- Especificar siempre la tabla origen de cada columna
- Usar ON para condiciones del JOIN, WHERE para filtros adicionales
- Manejar valores NULL explícitamente con COALESCE/IFNULL
- Incluir todas las columnas no agregadas en GROUP BY
- Usar subconsultas con moderación para mantener performance
- Validar resultados con datasets conocidos
- Comentar consultas complejas para future mantenimiento
*/

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================