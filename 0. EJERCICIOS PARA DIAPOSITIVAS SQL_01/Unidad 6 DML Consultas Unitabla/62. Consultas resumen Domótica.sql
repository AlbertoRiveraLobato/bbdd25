-- Código SQL para crear una base de datos de domótica en el hogar, con tablas, inserción de datos y ejemplos de vistas.

-- Creación de la base de datos de domótica
CREATE DATABASE domotica_db;
USE domotica_db;

-- Tabla de dispositivos
CREATE TABLE dispositivos (
    id_dispositivo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50),
    ubicacion VARCHAR(100),
    estado ENUM('activado', 'desactivado', 'modo_ahorro') DEFAULT 'desactivado',
    consumo_watts DECIMAL(8,2),
    fecha_instalacion DATE
);

-- Tabla de registros de uso
CREATE TABLE registros_uso (
    id_registro INT PRIMARY KEY AUTO_INCREMENT,
    id_dispositivo INT,
    fecha_hora DATETIME,
    accion ENUM('encendido', 'apagado', 'ajuste'),
    valor_ajuste DECIMAL(10,2)
);

-- Tabla de consumos energéticos
CREATE TABLE consumos (
    id_consumo INT PRIMARY KEY AUTO_INCREMENT,
    id_dispositivo INT,
    fecha DATE,
    horas_uso DECIMAL(5,2),
    consumo_total DECIMAL(10,2)
);

-- Inserción de datos de ejemplo
INSERT INTO dispositivos (nombre, tipo, ubicacion, estado, consumo_watts, fecha_instalacion) VALUES
('Termostato Salón', 'climatización', 'Salón', 'activado', 5.50, '2023-01-15'),
('Luces LED Cocina', 'iluminación', 'Cocina', 'activado', 15.75, '2023-02-10'),
('Persianas Dormitorio', 'automatización', 'Dormitorio Principal', 'desactivado', 8.25, '2023-03-05'),
('Cámara Seguridad', 'seguridad', 'Entrada', 'activado', 12.30, '2023-01-20'),
('Aspiradora Robot', 'limpieza', 'Salón', 'modo_ahorro', 45.00, '2023-04-12'),
('Aire Acondicionado', 'climatización', 'Salón', 'desactivado', 850.00, '2023-05-20');

INSERT INTO registros_uso (id_dispositivo, fecha_hora, accion, valor_ajuste) VALUES
(1, '2024-01-15 08:00:00', 'encendido', 21.5),
(1, '2024-01-15 12:00:00', 'ajuste', 23.0),
(1, '2024-01-15 22:00:00', 'ajuste', 19.0),
(2, '2024-01-15 18:00:00', 'encendido', NULL),
(2, '2024-01-15 23:00:00', 'apagado', NULL),
(3, '2024-01-15 09:00:00', 'encendido', NULL),
(4, '2024-01-15 00:00:00', 'encendido', NULL),
(5, '2024-01-15 10:00:00', 'encendido', NULL),
(5, '2024-01-15 11:30:00', 'apagado', NULL);

INSERT INTO consumos (id_dispositivo, fecha, horas_uso, consumo_total) VALUES
(1, '2024-01-15', 8.5, 46.75),
(2, '2024-01-15', 5.0, 78.75),
(3, '2024-01-15', 2.5, 20.63),
(4, '2024-01-15', 24.0, 295.20),
(5, '2024-01-15', 1.5, 67.50),
(1, '2024-01-16', 7.0, 38.50),
(2, '2024-01-16', 4.5, 70.88);

/* BATERÍA 2: CONSULTAS DOMÓTICA SIN JOINS

1. Mostrar todos los dispositivos del sistema
2. Mostrar dispositivos con consumo superior a 50W
3. Mostrar dispositivos activados con consumo menor a 20W
4. Mostrar dispositivos con consumo entre 10W y 100W
5. Mostrar dispositivos de climatización o iluminación
6. Mostrar dispositivos que contengan "Salón" en su nombre
7. Mostrar dispositivos en ubicaciones que coincidan con el patrón "S_l_n"
8. Mostrar registros de uso donde no se especificó valor de ajuste
9. Calcular consumo diario y costo diario de cada dispositivo
10. Contar número de dispositivos por tipo
11. Contar dispositivos por tipo y estado
12. Mostrar tipos de dispositivo con consumo promedio superior a 50W
13. Mostrar tipos de dispositivo con consumo diario total superior a 100W
14. Mostrar dispositivos que han tenido consumos superiores a 50W
15. Mostrar tipos de dispositivo con consumo promedio superior a 20W (usando subconsulta en FROM)
16. Mostrar dispositivos con el número total de acciones registradas
17. Mostrar consumos superiores al promedio de su dispositivo
18. Mostrar dispositivos no desactivados con consumo no inferior a 10W, instalados antes de junio 2023
19. Reporte de consumo por ubicación para dispositivos activados que no son de seguridad
20. Reporte final de consumo por tipo con todos los filtros aplicados

*/

-- 1. SELECT básico
SELECT * FROM dispositivos;

-- 2. WHERE con operadores de comparación
SELECT * FROM dispositivos WHERE consumo_watts > 50;

-- 3. WHERE con operadores lógicos
SELECT * FROM dispositivos 
WHERE estado = 'activado' AND consumo_watts < 20;

-- 4. WHERE con BETWEEN
SELECT * FROM dispositivos 
WHERE consumo_watts BETWEEN 10 AND 100;

-- 5. WHERE con IN
SELECT * FROM dispositivos 
WHERE tipo IN ('climatización', 'iluminación');

-- 6. WHERE con LIKE y %
SELECT * FROM dispositivos 
WHERE nombre LIKE '%Salón%';

-- 7. WHERE con LIKE y _
SELECT * FROM dispositivos 
WHERE ubicacion LIKE 'S_l_n';

-- 8. WHERE con IS NULL
SELECT * FROM registros_uso 
WHERE valor_ajuste IS NULL;

-- 9. OPERADORES ARITMÉTICOS
SELECT nombre, 
       consumo_watts,
       consumo_watts * 24 as consumo_diario,
       consumo_watts * 24 * 0.30 as costo_diario
FROM dispositivos;

-- 10. GROUP BY básico
SELECT tipo, COUNT(*) as cantidad_dispositivos
FROM dispositivos 
GROUP BY tipo;

-- 11. GROUP BY con múltiples columnas
SELECT tipo, estado, COUNT(*) as cantidad
FROM dispositivos 
GROUP BY tipo, estado;

-- 12. HAVING con condición sobre agregación
SELECT tipo, AVG(consumo_watts) as consumo_promedio
FROM dispositivos 
GROUP BY tipo
HAVING AVG(consumo_watts) > 50;

-- 13. HAVING con operadores aritméticos
SELECT tipo, 
       SUM(consumo_watts) as consumo_total,
       SUM(consumo_watts) * 24 as consumo_diario_total
FROM dispositivos 
GROUP BY tipo
HAVING SUM(consumo_watts) * 24 > 100;

-- 14. Sub-consulta en WHERE
SELECT * FROM dispositivos 
WHERE id_dispositivo IN (
    SELECT id_dispositivo 
    FROM consumos 
    WHERE consumo_total > 50
);

-- 15. Sub-consulta en FROM
SELECT t.tipo, t.consumo_promedio
FROM (
    SELECT tipo, AVG(consumo_watts) as consumo_promedio
    FROM dispositivos 
    GROUP BY tipo
) AS t
WHERE t.consumo_promedio > 20;

-- 16. Sub-consulta en SELECT
SELECT nombre, tipo,
       (SELECT COUNT(*) FROM registros_uso 
        WHERE registros_uso.id_dispositivo = dispositivos.id_dispositivo) as total_acciones
FROM dispositivos;

-- 17. Sub-consulta correlacionada
SELECT * FROM consumos c1
WHERE consumo_total > (
    SELECT AVG(consumo_total)
    FROM consumos c2
    WHERE c2.id_dispositivo = c1.id_dispositivo
);

-- 18. Consulta compleja con NOT y operadores lógicos
SELECT * FROM dispositivos 
WHERE NOT (estado = 'desactivado' OR consumo_watts < 10)
AND fecha_instalacion < '2023-06-01';

-- 19. Consulta con múltiples condiciones y operadores
SELECT ubicacion,
       COUNT(*) as total_dispositivos,
       SUM(consumo_watts) as consumo_total,
       AVG(consumo_watts) as consumo_promedio
FROM dispositivos
WHERE estado != 'desactivado'
AND tipo NOT IN ('seguridad')
GROUP BY ubicacion
HAVING AVG(consumo_watts) > 15
ORDER BY consumo_total DESC;

-- 20. Consulta final con todos los operadores
SELECT tipo,
       COUNT(*) as cantidad,
       MAX(consumo_watts) as max_consumo,
       MIN(consumo_watts) as min_consumo,
       AVG(consumo_watts) as promedio_consumo
FROM dispositivos
WHERE fecha_instalacion BETWEEN '2023-01-01' AND '2023-12-31'
AND (estado LIKE 'act%' OR estado = 'modo_ahorro')
GROUP BY tipo
HAVING COUNT(*) >= 1 AND AVG(consumo_watts) BETWEEN 10 AND 500
ORDER BY promedio_consumo DESC;