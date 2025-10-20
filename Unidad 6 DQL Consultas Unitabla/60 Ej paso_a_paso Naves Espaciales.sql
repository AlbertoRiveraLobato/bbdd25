-- =============================================
-- GUION INTEGRADO: Naves Espaciales - VERSIÓN EJERCICIOS
-- =============================================

-- El alumno debe escribir y ejecutar cada sentencia SQL en su entorno de base de datos,
-- observando los resultados y posibles errores.

-- ================================
-- EJERCICIOS DDL: CREACIÓN Y MODIFICACIÓN DE ESTRUCTURA
-- ================================
-- EJERCICIO DDL-0
-- ENUNCIADO: Limpia el espacio de trabajo y crea la base de datos 'naves_espaciales' y usarla por defecto
-- SOLUCIÓN:
DROP DATABASE IF EXISTS naves_espaciales;
CREATE DATABASE naves_espaciales;
USE naves_espaciales;

-- EJERCICIO DDL-1
-- ENUNCIADO: Crear la tabla 'naves' con las siguientes columnas:
-- - id: entero (será clave primaria más adelante)
-- - nombre: texto hasta 100 caracteres, obligatorio, único
-- - tipo: texto hasta 50 caracteres
-- - capacidad: número entero
-- - fecha_lanzamiento: fecha

-- SOLUCIÓN:
CREATE TABLE naves (
    id INT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    tipo VARCHAR(50),
    capacidad INT,
    fecha_lanzamiento DATE
);

-- RESULTADO ESPERADO (Ejecutar: DESCRIBE naves;):
-- +-------------------+--------------+------+-----+---------+----------------+
-- | Field             | Type         | Null | Key | Default | Extra          |
-- +-------------------+--------------+------+-----+---------+----------------+
-- | id                | int          | NO   |     | NULL    | auto_increment |
-- | nombre            | varchar(100) | NO   |     | NULL    |                |
-- | tipo              | varchar(50)  | YES  |     | NULL    |                |
-- | capacidad         | int          | YES  |     | NULL    |                |
-- | fecha_lanzamiento | date         | YES  |     | NULL    |                |
-- +-------------------+--------------+------+-----+---------+----------------+

-- EJERCICIO DDL-2
-- ENUNCIADO: Crear la tabla 'pilotos' con las siguientes columnas:
-- - id: entero autoincremental (será clave primaria más adelante)
-- - nombre: texto hasta 100 caracteres, obligatorio, único
-- - rango: texto hasta 50 caracteres
-- - planeta_origen: texto hasta 100 caracteres
-- - activo: booleano con valor por defecto TRUE

-- SOLUCIÓN:
CREATE TABLE pilotos (
    id INT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    rango VARCHAR(50),
    planeta_origen VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE
);

-- RESULTADO ESPERADO (Ejecutar: DESCRIBE pilotos;):
-- +----------------+--------------+------+-----+---------+----------------+
-- | Field          | Type         | Null | Key | Default | Extra          |
-- +----------------+--------------+------+-----+---------+----------------+
-- | id             | int          | NO   |     | NULL    | auto_increment |
-- | nombre         | varchar(100) | NO   |     | NULL    |                |
-- | rango          | varchar(50)  | YES  |     | NULL    |                |
-- | planeta_origen | varchar(100) | YES  |     | NULL    |                |
-- | activo         | tinyint(1)   | YES  |     | 1       |                |
-- +----------------+--------------+------+-----+---------+----------------+

-- EJERCICIO DDL-3
-- ENUNCIADO: Añadir las claves primarias a ambas tablas, cambiando además
-- el nombre de las columnas 'id' a 'id_nave' y 'id_piloto' respectivamente.

-- SOLUCIÓN:
alter table naves change column id id_nave INT AUTO_INCREMENT PRIMARY KEY;
alter table pilotos change column id id_piloto INT AUTO_INCREMENT PRIMARY KEY;

-- RESULTADO ESPERADO (Ejecutar: DESCRIBE naves; y DESCRIBE pilotos;):
-- TABLA NAVES:
-- +-------------------+--------------+------+-----+---------+----------------+
-- | Field             | Type         | Null | Key | Default | Extra          |
-- +-------------------+--------------+------+-----+---------+----------------+
-- | id_nave           | int          | NO   | PRI | NULL    |                |
-- | nombre            | varchar(100) | NO   |     | NULL    |                |
-- | tipo              | varchar(50)  | YES  |     | NULL    |                |
-- | capacidad         | int          | YES  |     | NULL    |                |
-- | fecha_lanzamiento | date         | YES  |     | NULL    |                |
-- +-------------------+--------------+------+-----+---------+----------------+
-- TABLA PILOTOS:
-- +----------------+--------------+------+-----+---------+----------------+
-- | Field          | Type         | Null | Key | Default | Extra          |
-- +----------------+--------------+------+-----+---------+----------------+
-- | id_piloto      | int          | NO   | PRI | NULL    |                |
-- | nombre         | varchar(100) | NO   |     | NULL    |                |
-- | rango          | varchar(50)  | YES  |     | NULL    |                |
-- | planeta_origen | varchar(100) | YES  |     | NULL    |                |
-- | activo         | tinyint(1)   | YES  |     | 1       |                |
-- +----------------+--------------+------+-----+---------+----------------+

-- EJERCICIO DDL-4
-- ENUNCIADO: Añadir la columna 'velocidad_maxima' de tipo DECIMAL(8,2) a la tabla naves

-- SOLUCIÓN:
ALTER TABLE naves ADD COLUMN velocidad_maxima DECIMAL(8,2);

-- RESULTADO ESPERADO (Ejecutar: DESCRIBE naves;):
-- +-------------------+--------------+------+-----+---------+----------------+
-- | Field             | Type         | Null | Key | Default | Extra          |
-- +-------------------+--------------+------+-----+---------+----------------+
-- | id                | int          | NO   | PRI | NULL    | auto_increment |
-- | nombre            | varchar(100) | NO   |     | NULL    |                |
-- | tipo              | varchar(50)  | YES  |     | NULL    |                |
-- | capacidad         | int          | YES  |     | NULL    |                |
-- | fecha_lanzamiento | date         | YES  |     | NULL    |                |
-- | velocidad_maxima  | decimal(8,2) | YES  |     | NULL    |                |
-- +-------------------+--------------+------+-----+---------+----------------+

-- EJERCICIO DDL-5
-- ENUNCIADO: Crear una tabla 'asignaciones' para relacionar pilotos con naves:
-- - id_piloto: entero (será clave foránea a pilotos.id_piloto)
-- - id_nave: entero (será clave foránea a naves.id_nave)
-- - fecha_asignacion: fecha, obligatoria

-- SOLUCIÓN:
CREATE TABLE asignaciones (
    id_piloto INT,
    id_nave INT,
    fecha_asignacion DATE NOT NULL
);

-- RESULTADO ESPERADO (Ejecutar: DESCRIBE asignaciones;):
-- +------------------+------+------+-----+---------+-------+
-- | Field            | Type | Null | Key | Default | Extra |
-- +------------------+------+------+-----+---------+-------+
-- | id_piloto        | int  | NO   | PRI | NULL    |       |
-- | id_nave          | int  | NO   | PRI | NULL    |       |
-- | fecha_asignacion | date | NO   |     | NULL    |       |
-- +------------------+------+------+-----+---------+-------+

-- EJERCICIO DDL-6: 
-- ENUNCIADO: Añadir claves foráneas a la tabla 'asignaciones', 
-- añadiendo integridad referencial con ON DELETE CASCADE,
-- y renombrando además las columnas para que empiecen por "FK_".
-- Añadir también clave primaria compuesta por (FK_id_piloto, FK_id_nave).

-- SOLUCIÓN:
ALTER TABLE asignaciones
    RENAME COLUMN id_piloto TO FK_id_piloto,
    RENAME COLUMN id_nave TO FK_id_nave,
ADD CONSTRAINT PK_asignaciones PRIMARY KEY (FK_id_piloto, FK_id_nave),
ADD CONSTRAINT FK_asignaciones_pilotos FOREIGN KEY (FK_id_piloto) REFERENCES pilotos(id_piloto) ON DELETE CASCADE,
ADD CONSTRAINT FK_asignaciones_naves FOREIGN KEY (FK_id_nave) REFERENCES naves(id_nave) ON DELETE CASCADE;

-- RESULTADO ESPERADO (Ejecutar: DESCRIBE asignaciones;):
-- +------------------+------+------+-----+---------+-------+
-- | Field            | Type | Null | Key | Default | Extra |
-- +------------------+------+------+-----+---------+-------+
-- | FK_id_piloto     | int  | NO   | PRI | NULL    |       |
-- | FK_id_nave       | int  | NO   | PRI | NULL    |       |
-- | fecha_asignacion | date | NO   |     | NULL    |       |
-- +------------------+------+------+-----+---------+-------+


-- ===============================
-- EJERCICIOS DML: INSERCIÓN Y MODIFICACIÓN DE DATOS
-- ================================

-- EJERCICIO DML-1
-- ENUNCIADO: Insertar las siguientes naves espaciales en la tabla naves:
-- - 'Explorer I', tipo 'Exploración', capacidad 5, fecha '2022-05-01', velocidad 12000.50
-- - 'Falcon Z', tipo 'Combate', capacidad 2, fecha '2023-03-15', velocidad 18000.00
-- - 'Galaxy Cruiser', tipo 'Transporte', capacidad 20, fecha '2021-11-20', velocidad 9500.75

-- SOLUCIÓN:
INSERT INTO naves (nombre, tipo, capacidad, fecha_lanzamiento, velocidad_maxima) VALUES
('Explorer I', 'Exploración', 5, '2022-05-01', 12000.50),
('Falcon Z', 'Combate', 2, '2023-03-15', 18000.00),
('Galaxy Cruiser', 'Transporte', 20, '2021-11-20', 9500.75);

-- RESULTADO ESPERADO (Ejecutar: SELECT * FROM naves;):
-- +----+----------------+-------------+-----------+-------------------+------------------+
-- | id | nombre         | tipo        | capacidad | fecha_lanzamiento | velocidad_maxima |
-- +----+----------------+-------------+-----------+-------------------+------------------+
-- |  1 | Explorer I     | Exploración |         5 | 2022-05-01        |         12000.50 |
-- |  2 | Falcon Z       | Combate     |         2 | 2023-03-15        |         18000.00 |
-- |  3 | Galaxy Cruiser | Transporte  |        20 | 2021-11-20        |          9500.75 |
-- +----+----------------+-------------+-----------+-------------------+------------------+

-- EJERCICIO DML-2
-- ENUNCIADO: Insertar los siguientes pilotos en la tabla pilotos:
-- - 'Luna Star', rango 'Capitana', planeta 'Tierra'
-- - 'Orion Blaze', rango 'Teniente', planeta 'Marte'
-- - 'Nova Sky', rango 'Comandante', planeta 'Júpiter'

-- SOLUCIÓN:
INSERT INTO pilotos (nombre, rango, planeta_origen) VALUES
('Luna Star', 'Capitana', 'Tierra'),
('Orion Blaze', 'Teniente', 'Marte'),
('Nova Sky', 'Comandante', 'Júpiter');

-- RESULTADO ESPERADO (Ejecutar: SELECT * FROM pilotos;):
-- +----+-------------+------------+----------------+--------+
-- | id | nombre      | rango      | planeta_origen | activo |
-- +----+-------------+------------+----------------+--------+
-- |  1 | Luna Star   | Capitana   | Tierra         |      1 |
-- |  2 | Orion Blaze | Teniente   | Marte          |      1 |
-- |  3 | Nova Sky    | Comandante | Júpiter        |      1 |
-- +----+-------------+------------+----------------+--------+

-- EJERCICIO DML-3
-- ENUNCIADO: Insertar las siguientes asignaciones de pilotos a naves:
-- - Piloto 1 (Luna Star) asignado a nave 1 (Explorer I) el '2024-01-15'
-- - Piloto 2 (Orion Blaze) asignado a nave 2 (Falcon Z) el '2024-02-01'
-- - Piloto 3 (Nova Sky) asignado a nave 3 (Galaxy Cruiser) el '2024-01-20'

-- SOLUCIÓN:
INSERT INTO asignaciones (FK_id_piloto, FK_id_nave, fecha_asignacion) VALUES
(1, 1, '2024-01-15'),
(2, 2, '2024-02-01'),
(3, 3, '2024-01-20');

-- RESULTADO ESPERADO (Ejecutar: SELECT * FROM asignaciones;):
-- +-----------+---------+------------------+
-- | FK_id_piloto | FK_id_nave | fecha_asignacion |
-- +-----------+---------+------------------+
-- |         1 |       1 | 2024-01-15       |
-- |         2 |       2 | 2024-02-01       |
-- |         3 |       3 | 2024-01-20       |
-- +-----------+---------+------------------+

-- EJERCICIO DML-4
-- ENUNCIADO: Actualizar la capacidad de la nave 'Falcon Z' a 3

-- SOLUCIÓN:
UPDATE naves SET capacidad = 3 WHERE nombre = 'Falcon Z';

-- RESULTADO ESPERADO (Ejecutar: SELECT * FROM naves;):
-- +----+----------------+-------------+-----------+-------------------+------------------+
-- | id | nombre         | tipo        | capacidad | fecha_lanzamiento | velocidad_maxima |
-- +----+----------------+-------------+-----------+-------------------+------------------+
-- |  1 | Explorer I     | Exploración |         5 | 2022-05-01        |         12000.50 |
-- |  2 | Falcon Z       | Combate     |         3 | 2023-03-15        |         18000.00 |
-- |  3 | Galaxy Cruiser | Transporte  |        20 | 2021-11-20        |          9500.75 |
-- +----+----------------+-------------+-----------+-------------------+------------------+

-- EJERCICIO DML-5
-- ENUNCIADO: Desactivar al piloto 'Orion Blaze' (cambiar activo a FALSE)

-- SOLUCIÓN:
UPDATE pilotos SET activo = FALSE WHERE nombre = 'Orion Blaze';

-- RESULTADO ESPERADO (Ejecutar: SELECT * FROM pilotos;):
-- +----+-------------+------------+----------------+--------+
-- | id | nombre      | rango      | planeta_origen | activo |
-- +----+-------------+------------+----------------+--------+
-- |  1 | Luna Star   | Capitana   | Tierra         |      1 |
-- |  2 | Orion Blaze | Teniente   | Marte          |      0 |
-- |  3 | Nova Sky    | Comandante | Júpiter        |      1 |
-- +----+-------------+------------+----------------+--------+


-- ================================================================
-- EJERCICIOS DQL: CONSULTAS UNITABLA
-- ================================================================

-- EJERCICIO DQL-1
-- ENUNCIADO: Mostrar todas las naves

-- SOLUCIÓN:
SELECT * FROM naves;

-- RESULTADO ESPERADO:
-- +----+----------------+-------------+-----------+-------------------+------------------+
-- | id | nombre         | tipo        | capacidad | fecha_lanzamiento | velocidad_maxima |
-- +----+----------------+-------------+-----------+-------------------+------------------+
-- |  1 | Explorer I     | Exploración |         5 | 2022-05-01        |         12000.50 |
-- |  2 | Falcon Z       | Combate     |         3 | 2023-03-15        |         18000.00 |
-- |  3 | Galaxy Cruiser | Transporte  |        20 | 2021-11-20        |          9500.75 |
-- +----+----------------+-------------+-----------+-------------------+------------------+

-- EJERCICIO DQL-2
-- ENUNCIADO: Mostrar nombre y tipo de las naves de tipo 'Combate'

-- SOLUCIÓN:
SELECT nombre, tipo FROM naves WHERE tipo = 'Combate';

-- RESULTADO ESPERADO:
-- +----------+---------+
-- | nombre   | tipo    |
-- +----------+---------+
-- | Falcon Z | Combate |
-- +----------+---------+

-- EJERCICIO DQL-3
-- ENUNCIADO: Mostrar nombre, capacidad y velocidad_maxima de las naves con capacidad >= 5 Y velocidad_maxima > 10000

-- SOLUCIÓN:
SELECT nombre, capacidad, velocidad_maxima FROM naves
WHERE capacidad > 5 AND velocidad_maxima > 10000;

-- RESULTADO ESPERADO:
-- +----------+-----------+------------------+
-- | nombre   | capacidad | velocidad_maxima |
-- +----------+-----------+------------------+
-- | Explorer I |         5 |         12000.50 |
-- +----------+-----------+------------------+

-- EJERCICIO DQL-4
-- ENUNCIADO: Contar el número de naves por tipo (agregación con GROUP BY)

-- SOLUCIÓN:
SELECT tipo, COUNT(*) AS total_naves FROM naves GROUP BY tipo;

-- RESULTADO ESPERADO:
-- +-------------+-------------+
-- | tipo        | total_naves |
-- +-------------+-------------+
-- | Combate     |           1 |
-- | Exploración |           1 |
-- | Transporte  |           1 |
-- +-------------+-------------+

-- EJERCICIO DQL-5
-- ENUNCIADO: Mostrar los diferentes tipos de naves que hay (usando DISTINCT)

-- SOLUCIÓN:
SELECT DISTINCT tipo FROM naves;

-- RESULTADO ESPERADO:
-- +-------------+
-- | tipo        |
-- +-------------+
-- | Combate     |
-- | Exploración |
-- | Transporte  |
-- +-------------+

-- EJERCICIO DQL-6
-- ENUNCIADO: Mostrar el nombre, la velocidad máxima y la velocidad en km/h
-- (sabiendo que la velocidad en km/h se calcula como: velocidad_maxima * 3.6)

-- SOLUCIÓN:
SELECT nombre, velocidad_maxima, 
       velocidad_maxima * 3.6 AS velocidad_kmh 
FROM naves;

-- RESULTADO ESPERADO:
-- +----------------+------------------+---------------+
-- | nombre         | velocidad_maxima | velocidad_kmh |
-- +----------------+------------------+---------------+
-- | Explorer I     |         12000.50 |      43201.80 |
-- | Falcon Z       |         18000.00 |      64800.00 |
-- | Galaxy Cruiser |          9500.75 |      34202.70 |
-- +----------------+------------------+---------------+

-- EJERCICIO DQL-7
-- ENUNCIADO: Mostrar el numero total de naves, y además, 
-- estadísticas de capacidad (agregaciones múltiples): 
-- promedio, máximo, mínimo y suma total de capacidad.

-- SOLUCIÓN:
SELECT COUNT(*) AS total_naves,
       AVG(capacidad) AS capacidad_promedio,
       MAX(capacidad) AS capacidad_maxima,
       MIN(capacidad) AS capacidad_minima,
       SUM(capacidad) AS capacidad_total
FROM naves;

-- RESULTADO ESPERADO:
-- +-------------+--------------------+------------------+------------------+----------------+
-- | total_naves | capacidad_promedio | capacidad_maxima | capacidad_minima | capacidad_total |
-- +-------------+--------------------+------------------+------------------+----------------+
-- |           3 |             9.3333 |               20 |                3 |             28 |
-- +-------------+--------------------+------------------+------------------+----------------+

-- EJERCICIO DQL-8
-- ENUNCIADO: Mostrar el nombre y velocidad_maxima de las naves,
-- clasificándolas por categoría de velocidad (usando CASE WHEN): 
    -- 'Muy rápida' (=>15000), 'Rápida' (10000-15000), 'Lenta' (<=10000).

-- SOLUCIÓN:
SELECT nombre, velocidad_maxima,
       CASE 
           WHEN velocidad_maxima >= 15000 THEN 'Muy rápida'
           WHEN velocidad_maxima BETWEEN 10000 AND 15000 THEN 'Rápida'
           ELSE 'Lenta'
       END AS categoria_velocidad
FROM naves;

-- RESULTADO ESPERADO:
-- +----------------+------------------+--------------------+
-- | nombre         | velocidad_maxima | categoria_velocidad |
-- +----------------+------------------+--------------------+
-- | Explorer I     |         12000.50 | Rápida             |
-- | Falcon Z       |         18000.00 | Muy rápida         |
-- | Galaxy Cruiser |          9500.75 | Lenta              |
-- +----------------+------------------+--------------------+

-- EJERCICIO DQL-9
-- ENUNCIADO: Mostrar naves más rápidas que el promedio (subconsulta)

-- SOLUCIÓN:
SELECT nombre, velocidad_maxima 
FROM naves 
WHERE velocidad_maxima > (SELECT AVG(velocidad_maxima) FROM naves);

-- RESULTADO ESPERADO:
-- +----------+------------------+
-- | nombre   | velocidad_maxima |
-- +----------+------------------+
-- | Falcon Z |         18000.00 |
-- +----------+------------------+

-- EJERCICIO DQL-10
-- ENUNCIADO: mostrar nombre, capacidad y categoria_capaciad de aquella naves cuya capacidad es > 10 
--(usar IF para mostrar si una nave es de alta capacidad (>10))

-- SOLUCIÓN:
SELECT nombre, capacidad,
       IF(capacidad > 10, 'Alta capacidad', 'Baja capacidad') AS categoria_capacidad
FROM naves;

-- RESULTADO ESPERADO:
-- +----------------+-----------+---------------------+
-- | nombre         | capacidad | categoria_capacidad |
-- +----------------+-----------+---------------------+
-- | Explorer I     |         5 | Baja capacidad      |
-- | Falcon Z       |         3 | Baja capacidad      |
-- | Galaxy Cruiser |        20 | Alta capacidad      |
-- +----------------+-----------+---------------------+

-- EJERCICIO DQL-11
-- ENUNCIADO: Mostrar el nombre y las primeras 3 letras del nombre de cada nave (función de cadena)

-- SOLUCIÓN:
SELECT nombre, SUBSTRING(nombre, 1, 3) AS iniciales FROM naves;

-- RESULTADO ESPERADO:
-- +----------------+-----------+
-- | nombre         | iniciales |
-- +----------------+-----------+
-- | Explorer I     | Exp       |
-- | Falcon Z       | Fal       |
-- | Galaxy Cruiser | Gal       |
-- +----------------+-----------+

-- EJERCICIO DQL-12
-- ENUNCIADO: Contar pilotos activos e inactivos por estado

-- SOLUCIÓN:
SELECT activo, COUNT(*) AS total_pilotos FROM pilotos GROUP BY activo;

-- o también:
select if(activo = 1, 'Activo', 'Inactivo') AS Estado, count(*) AS total_pilotos
from pilotos
group by (Estado);


-- RESULTADO ESPERADO:
-- +--------+---------------+
-- | activo | total_pilotos |
-- +--------+---------------+
-- |      0 |             1 |
-- |      1 |             2 |
-- +--------+---------------+

-- ================================
-- SECCIÓN PRÁCTICA: RESUELVE LOS EJERCICIOS
-- ================================

-- Escribe aquí las sentencias SQL para resolver todos los ejercicios anteriores:

-- DDL (Ejercicios DDL-1 a DDL-5):


-- DML (Ejercicios DML-1 a DML-5):


-- DQL (Ejercicios DQL-1 a DQL-12):
