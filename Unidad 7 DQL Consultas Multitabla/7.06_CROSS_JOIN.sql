-- =============================================
-- 7.05_CROSS_JOIN.sql
-- =============================================
-- Ejercicios y teoría sobre CROSS JOIN (producto cartesiano) en SQL.
-- Incluye:
--   - Ejercicios básicos y avanzados con enunciados y soluciones.
--   - Ejemplos prácticos y casos de uso.
--   - Explicaciones teóricas y advertencias sobre el uso de CROSS JOIN.
--   - Estructura didáctica para formación y consulta.
--
-- CROSS JOIN permite combinar todas las filas de dos o más tablas, generando el producto cartesiano.
-- Es útil para catálogos, combinaciones, análisis y generación de datos de prueba.
-- ¡Cuidado! Puede generar grandes volúmenes de datos si las tablas son grandes.

DROP DATABASE IF EXISTS ejemplo_cross_joins;
CREATE DATABASE ejemplo_cross_joins;
USE ejemplo_cross_joins;


CREATE TABLE departamentos (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_dept VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(50)
);

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

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    precio_base DECIMAL(10,2)
);

CREATE TABLE colores (
    id_color INT AUTO_INCREMENT PRIMARY KEY,
    color VARCHAR(50) NOT NULL
);

CREATE TABLE tallas (
    id_talla INT AUTO_INCREMENT PRIMARY KEY,
    talla VARCHAR(10) NOT NULL
);

CREATE TABLE tipos_descuento (
    id_descuento INT AUTO_INCREMENT PRIMARY KEY,
    tipo_descuento VARCHAR(50) NOT NULL,
    porcentaje DECIMAL(5,2)
);



INSERT INTO departamentos (nombre_dept, ubicacion) VALUES
('Ventas', 'Madrid'),
('Marketing', 'Barcelona'),
('IT', 'Valencia'),
('Recursos Humanos', 'Sevilla'),
('Finanzas', 'Bilbao');

INSERT INTO empleados (nombre, salario, id_departamento) VALUES
('Ana García', 1800, 1),
('Luis Pérez', 2000, 2),
('Marta Ruiz', 2200, 1),
('Pedro López', 2500, 3),
('Lucía Gómez', 2100, 3);

INSERT INTO proyectos (nombre_proyecto, presupuesto, id_departamento) VALUES
('Campaña Primavera', 50000, 1),
('Web Corporativa', 75000, 3),
('App Móvil', 120000, 3),
('Evento Anual', 30000, 2),
('Auditoría Anual', 25000, 5);

INSERT INTO productos (nombre_producto, precio_base) VALUES
('Camiseta', 25.00),
('Pantalón', 45.00),
('Chaqueta', 85.00),
('Zapatos', 65.00),
('Accesorios', 15.00);

INSERT INTO colores (color) VALUES 
('Rojo'), 
('Azul'), 
('Verde'), 
('Negro'), 
('Blanco'),
('Gris'),
('Amarillo');

INSERT INTO tallas (talla) VALUES 
('XS'),
('S'), 
('M'), 
('L'), 
('XL'),
('XXL');

INSERT INTO tipos_descuento (tipo_descuento, porcentaje) VALUES 
('Sin descuento', 0.00),
('Descuento estudiante', 10.00),
('Descuento empleado', 15.00),
('Descuento VIP', 20.00),
('Descuento promocional', 25.00);

-- =============================================

-- *** EJERCICIOS BÁSICOS CON CROSS JOIN (1-10) ***

-- 1) Muestra todas las combinaciones posibles de colores y tallas.
-- 2) Muestra todas las combinaciones de productos con colores y tallas.
-- 3) Muestra todas las combinaciones de empleados con departamentos (producto cartesiano).
-- 4) Calcula el precio de todos los productos con todos los tipos de descuento.
-- 5) Muestra todas las combinaciones de productos y colores con precio calculado.
-- 6) Crea una matriz de empleados con todos los proyectos existentes.
-- 7) Muestra todas las combinaciones posibles de dos colores diferentes.
-- 8) Combina todos los departamentos con todas las ubicaciones posibles.
-- 9) Crea un catálogo completo: productos × colores × tallas.
-- 10) Muestra todas las combinaciones de empleados con tipos de descuento.


-- =============================================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================================

-- 1) Muestra todas las combinaciones posibles de colores y tallas.
SELECT c.color, t.talla 
FROM colores c 
CROSS JOIN tallas t
ORDER BY c.color, t.talla;

-- 2) Muestra todas las combinaciones de productos con colores y tallas.
SELECT p.nombre_producto, c.color, t.talla 
FROM productos p 
CROSS JOIN colores c 
CROSS JOIN tallas t
ORDER BY p.nombre_producto, c.color, t.talla;

-- 3) Muestra todas las combinaciones de empleados con departamentos (producto cartesiano).
SELECT e.nombre AS empleado, d.nombre_dept AS departamento
FROM empleados e 
CROSS JOIN departamentos d
ORDER BY e.nombre, d.nombre_dept;

-- 4) Calcula el precio de todos los productos con todos los tipos de descuento.
SELECT 
    p.nombre_producto,
    p.precio_base,
    td.tipo_descuento,
    td.porcentaje AS descuento_porcentaje,
    p.precio_base * (1 - td.porcentaje / 100) AS precio_final
FROM productos p 
CROSS JOIN tipos_descuento td
ORDER BY p.nombre_producto, td.porcentaje;

-- 5) Muestra todas las combinaciones de productos y colores con precio calculado.
SELECT 
    p.nombre_producto,
    c.color,
    p.precio_base,
    CASE 
        WHEN c.color = 'Rojo' THEN p.precio_base * 1.10
        WHEN c.color = 'Negro' THEN p.precio_base * 1.05
        ELSE p.precio_base
    END AS precio_con_color
FROM productos p 
CROSS JOIN colores c
ORDER BY p.nombre_producto, c.color;

-- 6) Crea una matriz de empleados con todos los proyectos existentes.
SELECT 
    e.nombre AS empleado,
    e.salario,
    p.nombre_proyecto,
    p.presupuesto,
    d.nombre_dept AS departamento_empleado,
    d2.nombre_dept AS departamento_proyecto
FROM empleados e 
CROSS JOIN proyectos p
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento
LEFT JOIN departamentos d2 ON p.id_departamento = d2.id_departamento
ORDER BY e.nombre, p.nombre_proyecto;

-- 7) Muestra todas las combinaciones posibles de dos colores diferentes.
SELECT 
    c1.color AS color1,
    c2.color AS color2
FROM colores c1 
CROSS JOIN colores c2
WHERE c1.id_color < c2.id_color  -- Evita duplicados como (Rojo,Azul) y (Azul,Rojo)
ORDER BY c1.color, c2.color;

-- 8) Combina todos los departamentos con todas las ubicaciones posibles.
SELECT 
    d1.nombre_dept AS departamento,
    d2.ubicacion AS nueva_ubicacion,
    d1.ubicacion AS ubicacion_actual,
    CASE 
        WHEN d1.ubicacion = d2.ubicacion THEN 'Sin cambio'
        ELSE 'Reubicación posible'
    END AS tipo_cambio
FROM departamentos d1 
CROSS JOIN (SELECT DISTINCT ubicacion FROM departamentos) d2
ORDER BY d1.nombre_dept, d2.ubicacion;

-- 9) Crea un catálogo completo: productos × colores × tallas.
SELECT 
    p.nombre_producto,
    c.color,
    t.talla,
    p.precio_base,
    CONCAT(p.nombre_producto, ' ', c.color, ' ', t.talla) AS descripcion_completa,
    CASE 
        WHEN c.color IN ('Rojo', 'Negro') AND t.talla IN ('L', 'XL') THEN p.precio_base * 1.15
        WHEN c.color IN ('Rojo', 'Negro') THEN p.precio_base * 1.10
        WHEN t.talla IN ('L', 'XL') THEN p.precio_base * 1.05
        ELSE p.precio_base
    END AS precio_final
FROM productos p 
CROSS JOIN colores c 
CROSS JOIN tallas t
ORDER BY p.nombre_producto, c.color, t.talla;

-- 10) Muestra todas las combinaciones de empleados con tipos de descuento.
SELECT 
    e.nombre AS empleado,
    e.salario,
    td.tipo_descuento,
    td.porcentaje,
    CASE 
        WHEN td.tipo_descuento = 'Descuento empleado' THEN 'Aplicable'
        WHEN td.tipo_descuento = 'Descuento estudiante' AND e.salario < 2000 THEN 'Aplicable'
        ELSE 'No aplicable'
    END AS elegibilidad
FROM empleados e 
CROSS JOIN tipos_descuento td
ORDER BY e.nombre, td.porcentaje;

-- 6) Crea una tabla de horarios: combina empleados con días de la semana.
-- Primero crear una tabla temporal de días
SELECT '=== HORARIOS DE EMPLEADOS ===' AS seccion;

WITH dias_semana AS (
    SELECT 'Lunes' AS dia, 1 AS orden
    UNION SELECT 'Martes', 2
    UNION SELECT 'Miércoles', 3
    UNION SELECT 'Jueves', 4
    UNION SELECT 'Viernes', 5
)
SELECT 
    e.nombre AS empleado,
    ds.dia,
    '09:00-17:00' AS horario_base
FROM empleados e 
CROSS JOIN dias_semana ds
ORDER BY e.nombre, ds.orden;

-- 7) Muestra todas las combinaciones posibles de dos colores diferentes.
SELECT 
    c1.color AS color_principal,
    c2.color AS color_secundario
FROM colores c1 
CROSS JOIN colores c2
WHERE c1.id_color != c2.id_color  -- Evita combinaciones del mismo color
ORDER BY c1.color, c2.color;

-- 8) Genera un catálogo completo: productos × colores × tallas con precios.
SELECT 
    p.nombre_producto,
    c.color,
    t.talla,
    p.precio_base,
    CONCAT(p.nombre_producto, ' ', c.color, ' ', t.talla) AS descripcion_completa,
    CASE 
        WHEN t.talla IN ('XL') THEN p.precio_base * 1.15  -- Sobreprecio talla grande
        WHEN c.color IN ('Rojo', 'Negro') THEN p.precio_base * 1.05  -- Sobreprecio colores especiales
        ELSE p.precio_base
    END AS precio_final
FROM productos p 
CROSS JOIN colores c 
CROSS JOIN tallas t
ORDER BY p.nombre_producto, c.color, t.talla;

-- 9) Muestra el número total de combinaciones posibles entre tres tablas.
SELECT 
    (SELECT COUNT(*) FROM productos) AS num_productos,
    (SELECT COUNT(*) FROM colores) AS num_colores,
    (SELECT COUNT(*) FROM tallas) AS num_tallas,
    (SELECT COUNT(*) FROM productos) * 
    (SELECT COUNT(*) FROM colores) * 
    (SELECT COUNT(*) FROM tallas) AS total_combinaciones;

-- Verificación del conteo con CROSS JOIN
SELECT COUNT(*) AS combinaciones_reales
FROM productos p 
CROSS JOIN colores c 
CROSS JOIN tallas t;

-- 10) Encuentra combinaciones específicas usando WHERE con CROSS JOIN.
-- Ejemplo: Productos rojos en tallas grandes (L, XL)
SELECT 
    p.nombre_producto,
    c.color,
    t.talla,
    p.precio_base
FROM productos p 
CROSS JOIN colores c 
CROSS JOIN tallas t
WHERE c.color = 'Rojo' 
  AND t.talla IN ('L', 'XL')
ORDER BY p.nombre_producto;


-- ============================================
-- ** EJERCICIOS AVANZADOS CON CROSS JOIN **
-- ============================================

-- 11) Crea una tabla de horarios: combina empleados con días de la semana.
-- 12) Muestra todas las combinaciones posibles de dos colores diferentes (sin repetidos).
-- 13) Genera un catálogo completo: productos × colores × tallas con precios ajustados.
-- 14) Muestra el número total de combinaciones posibles entre tres tablas.
-- 15) Encuentra combinaciones específicas usando WHERE con CROSS JOIN (ejemplo: productos rojos en tallas grandes).


-- *** SOLUCIONES A LOS EJERCICIOS PRÁCTICOS Y AVANZADOS CON CROSS JOIN ***

-- 11) Crea una tabla de horarios: combina empleados con días de la semana.
SELECT '=== HORARIOS DE EMPLEADOS ===' AS seccion;
WITH dias_semana AS (
    SELECT 'Lunes' AS dia, 1 AS orden
    UNION SELECT 'Martes', 2
    UNION SELECT 'Miércoles', 3
    UNION SELECT 'Jueves', 4
    UNION SELECT 'Viernes', 5
)
SELECT 
    e.nombre AS empleado,
    ds.dia,
    '09:00-17:00' AS horario_base
FROM empleados e 
CROSS JOIN dias_semana ds
ORDER BY e.nombre, ds.orden;

-- 12) Muestra todas las combinaciones posibles de dos colores diferentes (sin repetidos).
SELECT 
    c1.color AS color_principal,
    c2.color AS color_secundario
FROM colores c1 
CROSS JOIN colores c2
WHERE c1.id_color != c2.id_color  -- Evita combinaciones del mismo color
ORDER BY c1.color, c2.color;

-- 13) Genera un catálogo completo: productos × colores × tallas con precios ajustados.
SELECT 
    p.nombre_producto,
    c.color,
    t.talla,
    p.precio_base,
    CONCAT(p.nombre_producto, ' ', c.color, ' ', t.talla) AS descripcion_completa,
    CASE 
        WHEN t.talla IN ('XL') THEN p.precio_base * 1.15  -- Sobreprecio talla grande
        WHEN c.color IN ('Rojo', 'Negro') THEN p.precio_base * 1.05  -- Sobreprecio colores especiales
        ELSE p.precio_base
    END AS precio_final
FROM productos p 
CROSS JOIN colores c 
CROSS JOIN tallas t
ORDER BY p.nombre_producto, c.color, t.talla;

-- 14) Muestra el número total de combinaciones posibles entre tres tablas.
SELECT 
    (SELECT COUNT(*) FROM productos) AS num_productos,
    (SELECT COUNT(*) FROM colores) AS num_colores,
    (SELECT COUNT(*) FROM tallas) AS num_tallas,
    (SELECT COUNT(*) FROM productos) * 
    (SELECT COUNT(*) FROM colores) * 
    (SELECT COUNT(*) FROM tallas) AS total_combinaciones;
-- Verificación del conteo con CROSS JOIN
SELECT COUNT(*) AS combinaciones_reales
FROM productos p 
CROSS JOIN colores c 
CROSS JOIN tallas t;

-- 15) Encuentra combinaciones específicas usando WHERE con CROSS JOIN (ejemplo: productos rojos en tallas grandes).
SELECT 
    p.nombre_producto,
    c.color,
    t.talla,
    p.precio_base
FROM productos p 
CROSS JOIN colores c 
CROSS JOIN tallas t
WHERE c.color = 'Rojo' 
  AND t.talla IN ('L', 'XL')
ORDER BY p.nombre_producto;
SELECT '=== CONSIDERACIONES DE RENDIMIENTO ===' AS seccion;

-- Mostrar cómo crece el número de registros
SELECT 
    'Productos' AS tabla, COUNT(*) AS registros FROM productos
UNION
SELECT 'Colores' AS tabla, COUNT(*) AS registros FROM colores  
UNION
SELECT 'Tallas' AS tabla, COUNT(*) AS registros FROM tallas
UNION
SELECT 'CROSS JOIN resultado' AS tabla, COUNT(*) AS registros 
FROM productos CROSS JOIN colores CROSS JOIN tallas;





-- =============================================
-- EJEMPLOS PRÁCTICOS DE CROSS JOIN
-- =============================================

-- Ejemplo 1: Matriz de precios con descuentos
SELECT '=== MATRIZ DE PRECIOS CON DESCUENTOS ===' AS ejemplo;
SELECT 
    p.nombre_producto,
    td.tipo_descuento,
    CONCAT(FORMAT(p.precio_base, 2), ' €') AS precio_original,
    CONCAT(FORMAT(p.precio_base * (1 - td.porcentaje / 100), 2), ' €') AS precio_final,
    CONCAT(td.porcentaje, '%') AS descuento
FROM productos p 
CROSS JOIN tipos_descuento td
ORDER BY p.nombre_producto, td.porcentaje;

-- Ejemplo 2: Planificación de turnos
    UNION SELECT 'Tarde', '16:00-24:00'
)
SELECT 
    e.nombre AS empleado,
    d.nombre_dept AS departamento,
    t.turno,
FROM empleados e 
CROSS JOIN departamentos d 
CROSS JOIN turnos t
WHERE e.id_departamento = d.id_departamento  -- Filtro para empleados reales
ORDER BY d.nombre_dept, e.nombre, t.turno;

SELECT '=== ANÁLISIS DE COMBINACIONES ===' AS ejemplo;
SELECT 
    COUNT(*) AS total_combinaciones,
    COUNT(DISTINCT p.id_producto) AS productos_diferentes,
    COUNT(DISTINCT c.id_color) AS colores_diferentes,
    MIN(p.precio_base) AS precio_minimo,
    MAX(p.precio_base) AS precio_maximo,
    AVG(p.precio_base) AS precio_promedio
FROM productos p 
CROSS JOIN colores c 
CROSS JOIN tallas t;

-- =============================================
-- CROSS JOIN vs INNER JOIN - COMPARACIÓN
-- =============================================

-- CROSS JOIN: Todas las combinaciones posibles (sin condición)
SELECT 'CROSS JOIN - Todas las combinaciones:' AS tipo;
SELECT COUNT(*) AS num_registros
FROM empleados e 
CROSS JOIN departamentos d;

-- INNER JOIN: Solo combinaciones con relación real
SELECT 'INNER JOIN - Solo relaciones reales:' AS tipo;
SELECT COUNT(*) AS num_registros
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento;

SELECT 'CROSS JOIN - Ejemplo visual:' AS tipo;
SELECT e.nombre, d.nombre_dept, 'TODAS las combinaciones' AS nota
FROM empleados e 
CROSS JOIN departamentos d
ORDER BY e.nombre, d.nombre_dept
LIMIT 10;

SELECT 'INNER JOIN - Ejemplo visual:' AS tipo;
SELECT e.nombre, d.nombre_dept, 'Solo relaciones reales' AS nota
FROM empleados e 
INNER JOIN departamentos d ON e.id_departamento = d.id_departamento
ORDER BY e.nombre, d.nombre_dept
LIMIT 10;



-- =============================================
-- CASOS PRÁCTICOS AVANZADOS
-- =============================================

-- Caso 1: Generador de configuraciones de productos
SELECT '=== GENERADOR DE CONFIGURACIONES ===' AS caso;
CREATE TEMPORARY TABLE configuraciones_producto AS
SELECT 
    p.id_producto,
    p.nombre_producto,
    c.id_color,
    c.color,
    t.id_talla,
    t.talla,
    p.precio_base AS precio_base,
    CASE 
        WHEN c.color = 'Negro' AND t.talla = 'XL' THEN p.precio_base * 1.20
        WHEN c.color IN ('Rojo', 'Negro') THEN p.precio_base * 1.05
        WHEN t.talla = 'XL' THEN p.precio_base * 1.10
        ELSE p.precio_base
FROM productos p 
CROSS JOIN colores c 
CROSS JOIN tallas t;

-- Mostrar las configuraciones generadas
SELECT * FROM configuraciones_producto ORDER BY nombre_producto, color, talla LIMIT 12;

-- Caso 2: Análisis de inventario necesario
SELECT '=== ANÁLISIS DE INVENTARIO ===' AS caso;
SELECT 
    p.nombre_producto,
    COUNT(*) AS variantes_por_producto,
    MIN(CASE 
        WHEN c.color = 'Negro' AND t.talla = 'XL' THEN p.precio_base * 1.20
        WHEN c.color IN ('Rojo', 'Negro') THEN p.precio_base * 1.05
        WHEN t.talla = 'XL' THEN p.precio_base * 1.10
        ELSE p.precio_base
    MAX(CASE 
        WHEN c.color = 'Negro' AND t.talla = 'XL' THEN p.precio_base * 1.20
        WHEN c.color IN ('Rojo', 'Negro') THEN p.precio_base * 1.05
        WHEN t.talla = 'XL' THEN p.precio_base * 1.10
        ELSE p.precio_base
    END) AS precio_maximo_variante
FROM productos p 
CROSS JOIN colores c 
CROSS JOIN tallas t
GROUP BY p.id_producto, p.nombre_producto
ORDER BY p.nombre_producto;

-- =============================================
-- ERRORES COMUNES CON CROSS JOIN
-- =============================================
-- Error: Usar CROSS JOIN por accidente (olvidar la condición ON)
-- INCORRECTO (devuelve producto cartesiano):
-- SELECT * FROM empleados e JOIN departamentos d;  -- Sin ON

-- CORRECTO:
-- SELECT * FROM empleados e JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- Error: No considerar el volumen de datos resultante
-- CUIDADO: CROSS JOIN puede generar muchos registros muy rápidamente
-- Ejemplo: 1000 productos × 50 colores × 10 tallas = 500,000 registros

-- =============================================
-- LIMITACIONES Y CONSIDERACIONES
-- =============================================
-- 1) Volumen de datos: CROSS JOIN puede generar grandes conjuntos de resultados.
-- 2) Rendimiento: Consultas con CROSS JOIN pueden ser lentas en tablas grandes.
-- 3) Uso adecuado: CROSS JOIN es útil para casos específicos, no para consultas diarias.
-- 4) Filtrado: Usar cláusula WHERE para limitar resultados cuando sea necesario.   

-- =============================================
-- CONCEPTOS CLAVE DEL CROSS JOIN
-- =============================================
/*
CROSS JOIN (Producto Cartesiano):
- Combina cada fila de la primera tabla con cada fila de la segunda tabla
- NO requiere condición de unión (no usa ON)
- Genera n × m filas (donde n y m son el número de filas de cada tabla)
- Equivalente a SELECT * FROM tabla1, tabla2 (sintaxis antigua)

SINTAXIS:
SELECT columnas
FROM tabla1
CROSS JOIN tabla2;

-- O sintaxis antigua:
SELECT columnas  
FROM tabla1, tabla2;

CUÁNDO USAR CROSS JOIN:
- Generar todas las combinaciones posibles (catálogos, configuraciones)
- Crear tablas de referencia cruzada
- Análisis combinatorio
- Generación de datos de prueba
- Planificación de horarios o turnos

CUÁNDO NO USAR:
- Consultas normales de datos relacionados (usar INNER/LEFT/RIGHT JOIN)
- Tablas grandes (puede generar millones de registros)
- Cuando solo necesitas datos relacionados específicos

CONSIDERACIONES:
- El resultado puede ser muy grande: tabla1(n) × tabla2(m) = n×m registros
- Usar siempre WHERE para filtrar cuando sea necesario
- Considerar el impacto en el rendimiento
- Útil para casos específicos, no para consultas cotidianas

ALTERNATIVAS:
- INNER JOIN con condiciones apropiadas para datos relacionados
- Subqueries para casos específicos
- Procedimientos almacenados para generación de datos complejos
*/

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================