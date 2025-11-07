/*
Ejercicio 316-1: Implementación ISA TOTAL y EXCLUSIVA
Título: Sistema de Vehículos de Reparto de Comida

Descripción:
Una empresa de delivery de comida necesita gestionar su flota de vehículos de reparto.
Según las regulaciones de la empresa, TODOS los vehículos deben clasificarse obligatoriamente 
en una de estas dos categorías (TOTAL), pero NO pueden pertenecer a ambas a la vez (EXCLUSIVA):

1. TRANSPORTE_LIGERO: Bicicletas y patinetes (vehículos sin motor)
2. TRANSPORTE_MOTORIZADO: Motocicletas y coches (vehículos con motor)

REQUISITOS DE NEGOCIO:
- Todo vehículo DEBE ser asignado a una categoría (restricción TOTAL)
- Ningún vehículo puede estar en ambas categorías simultáneamente (restricción EXCLUSIVA)
- Los alumnos solo pueden usar DDL, DML y consultas uni-tabla (SIN JOINS)

ATRIBUTOS COMUNES: id_vehiculo, matricula, marca
ATRIBUTOS ESPECÍFICOS:
- Transporte Ligero: tipo_vehiculo (bicicleta/patinete), peso_maximo_kg
- Transporte Motorizado: cilindrada, tipo_combustible
*/

-- =============================================================
-- IMPLEMENTACIÓN 1: TABLA ÚNICA CON DISCRIMINADOR
-- =============================================================

DROP DATABASE IF EXISTS delivery_vehiculos_opcion1;
CREATE DATABASE delivery_vehiculos_opcion1;
USE delivery_vehiculos_opcion1;

CREATE TABLE vehiculos_delivery (
    -- atributos comunes    
    id_vehiculo INT PRIMARY KEY AUTO_INCREMENT,
    matricula VARCHAR(15) UNIQUE NOT NULL,
    marca VARCHAR(50) NOT NULL,
    
    -- DISCRIMINADOR para ISA Total y Exclusiva
    categoria ENUM('TRANSPORTE_LIGERO', 'TRANSPORTE_MOTORIZADO') NOT NULL,
    
    -- Atributos específicos de TRANSPORTE_LIGERO (NULLables para motorizados)
    tipo_vehiculo_ligero ENUM('bicicleta', 'patinete') NULL,
    peso_maximo_ligero DECIMAL(5,2) NULL,
    
    -- Atributos específicos de TRANSPORTE_MOTORIZADO (NULLables para ligeros)
    cilindrada INT NULL,
    tipo_combustible ENUM('gasolina', 'diesel', 'electrico') NULL,
    
    -- RESTRICCIONES DE TABLA para garantizar ISA Total y Exclusiva
    CONSTRAINT chk_transporte_ligero CHECK (
        categoria != 'TRANSPORTE_LIGERO' OR (
            tipo_vehiculo_ligero IS NOT NULL AND 
            peso_maximo_ligero IS NOT NULL AND 
            peso_maximo_ligero > 0 AND
            -- Los ligeros NO deben tener atributos de motorizados
            cilindrada IS NULL AND 
            tipo_combustible IS NULL
        )
    ),
    CONSTRAINT chk_transporte_motorizado CHECK (
        categoria != 'TRANSPORTE_MOTORIZADO' OR (
            cilindrada IS NOT NULL AND 
            tipo_combustible IS NOT NULL AND 
            cilindrada > 0 AND
            -- Los motorizados NO deben tener atributos de ligeros
            tipo_vehiculo_ligero IS NULL AND 
            peso_maximo_ligero IS NULL
        )
    )
);

-- DATOS DE EJEMPLO
INSERT INTO vehiculos_delivery VALUES
-- Vehículos de Transporte Ligero
(NULL, 'BIC-001', 'Trek', 'TRANSPORTE_LIGERO', 'bicicleta', 25.50, NULL, NULL),
(NULL, 'BIC-002', 'Specialized', 'TRANSPORTE_LIGERO', 'bicicleta', 30.00, NULL, NULL),
(NULL, 'PAT-001', 'Xiaomi', 'TRANSPORTE_LIGERO', 'patinete', 15.75, NULL, NULL),

-- Vehículos de Transporte Motorizado
(NULL, '1234-ABC', 'Honda', 'TRANSPORTE_MOTORIZADO', NULL, NULL, 160, 'gasolina'),
(NULL, '5678-DEF', 'Yamaha', 'TRANSPORTE_MOTORIZADO', NULL, NULL, 155, 'gasolina'),
(NULL, '9012-GHI', 'Nissan', 'TRANSPORTE_MOTORIZADO', NULL, NULL, 1500, 'electrico');


-- =============================================================
-- CUADERNO DE EJERCICIOS - ENUNCIADOS DE CONSULTAS (SOLO UNITABLA - SIN JOINS)
-- =============================================================

/*
INSTRUCCIONES:
Resuelve los siguientes ejercicios escribiendo las consultas SQL correspondientes.
Recuerda usar solo consultas uni-tabla (SIN JOINS) según los requisitos del ejercicio.
*/

-- 1. Ver todos los vehículos

-- 2. Ver solo vehículos de transporte ligero

-- 3. Ver solo vehículos motorizados de gasolina

-- 4. Contar vehículos por categoría

-- 5. Ver todos los datos de: bicicletas con capacidad mayor a 25kg

-- 6. Ver matricula, marca, cilindrada, tipo_combustible de: motorizados eléctricos (combustible ecológico)

-- 7. Promedio de cilindrada de todos los vehículos motorizados

-- 8. Listar marcas únicas de vehículos ligeros

-- 9. Vehículos motorizados con cilindrada mayor al promedio

-- 10. Contar vehículos por tipo de vehículo ligero

-- 11. Consulta con CASE y con IF: mostrar "matricula, origen_marca, estado" donde estado es:
-- 'LIGERO' si es transporte ligero, 'MOTORIZADO' si es transporte motorizado
-- Y usando IF para marca, indicando si es marca "Oriental" o "Occidental"

-- 12.1 Consulta con COALESCE (alternativa con IFNULL): mostrar "matricula, marca, peso_maximo_ligero" y si peso_ligero es NULL mostrar "N/A"

-- 12.2 Consulta con NULLIF: mostrar "matricula, marca, cilindrada" y si cilindrada es 0 mostrar NULL

-- 13. Consulta con subconsulta correlacionada: mostrar "matricula, marca, peso_maximo_ligero" de vehículos ligeros 
-- cuyo peso máximo sea mayor que el peso máximo promedio de todos los vehículos ligeros

-- 14. Consulta con substring: mostrar "matricula, marca" de vehículos motorizados cuya matrícula comience con '123'



-- =============================================================
-- SOLUCIONES A LOS EJERCICIOS PROPUESTOS
-- =============================================================


-- 1. Ver todos los vehículos
SELECT * FROM vehiculos_delivery;

-- 2. Ver solo vehículos de transporte ligero
SELECT * FROM vehiculos_delivery WHERE categoria = 'TRANSPORTE_LIGERO';

-- 3. Ver solo vehículos motorizados de gasolina
SELECT * FROM vehiculos_delivery 
WHERE categoria = 'TRANSPORTE_MOTORIZADO' AND tipo_combustible = 'gasolina';

-- 4. Contar vehículos por categoría
-- El orden de evaluación es: FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY
SELECT categoria, COUNT(*) as total_vehiculos 
FROM vehiculos_delivery 
GROUP BY categoria;

-- 5. Ver todos los datos de: bicicletas con capacidad mayor a 25kg
SELECT * FROM vehiculos_delivery 
WHERE categoria = 'TRANSPORTE_LIGERO' 
  AND tipo_vehiculo_ligero = 'bicicleta' 
  AND peso_maximo_ligero > 25;

-- 6. Ver matricula, marca, cilindrada, tipo_combustible de: motorizados eléctricos (combustible ecológico)
SELECT matricula, marca, cilindrada, tipo_combustible 
FROM vehiculos_delivery 
WHERE categoria = 'TRANSPORTE_MOTORIZADO' 
  AND tipo_combustible = 'electrico';

-- 7. Promedio de cilindrada de todos los vehículos motorizados
SELECT AVG(cilindrada) as promedio_cilindrada
FROM vehiculos_delivery
WHERE categoria = 'TRANSPORTE_MOTORIZADO';

-- 8. Listar marcas únicas de vehículos ligeros
SELECT DISTINCT marca
FROM vehiculos_delivery
WHERE categoria = 'TRANSPORTE_LIGERO';

-- 9. Vehículos motorizados con cilindrada mayor al promedio
SELECT * FROM vehiculos_delivery
WHERE categoria = 'TRANSPORTE_MOTORIZADO' 
  AND cilindrada > (
      SELECT AVG(cilindrada) 
      FROM vehiculos_delivery 
      WHERE categoria = 'TRANSPORTE_MOTORIZADO'
  );

  -- 10. Contar vehículos por tipo de vehículo ligero
SELECT tipo_vehiculo_ligero, COUNT(*) as total_por_tipo
FROM vehiculos_delivery
WHERE categoria = 'TRANSPORTE_LIGERO'
GROUP BY tipo_vehiculo_ligero;

-- 11. Consulta con CASE y con IF: mostrar "matricula, origen_marca, estado" donde estado es:
-- 'LIGERO' si es transporte ligero, 'MOTORIZADO' si es transporte motorizado
-- Y usando IF para marca, indicando si es marca "Oriental" o "Occidental"
SELECT matricula, 
    IF(marca IN ('Honda', 'Yamaha', 'Nissan'), 'Oriental', 'Occidental') AS origen_marca, 
    CASE 
        WHEN categoria = 'TRANSPORTE_LIGERO' THEN 'LIGERO'
        WHEN categoria = 'TRANSPORTE_MOTORIZADO' THEN 'MOTORIZADO'
    END AS estado
FROM vehiculos_delivery;

-- 12.1 Consulta con COALESCE (alternativa con IFNULL): mostrar "matricula, marca, peso_maximo_ligero" y si peso_ligero es NULL mostrar "N/A"
SELECT matricula, marca, 
    COALESCE(peso_maximo_ligero, 'N/A') AS peso_maximo_ligero
    -- IFNULL(peso_maximo_ligero, 'N/A') AS peso_maximo_ligero
FROM vehiculos_delivery
WHERE categoria = 'TRANSPORTE_LIGERO';

-- 12.2 Consulta con NULLIF: mostrar "matricula, marca, cilindrada" y si cilindrada es 0 mostrar NULL
SELECT matricula, marca, 
    NULLIF(cilindrada, 0) AS cilindrada
FROM vehiculos_delivery
WHERE categoria = 'TRANSPORTE_MOTORIZADO';

-- 13. Consulta con subconsulta correlacionada: mostrar "matricula, marca, peso_maximo_ligero" de vehículos ligeros 
-- cuyo peso máximo sea mayor que el peso máximo promedio de todos los vehículos ligeros
SELECT v1.matricula, v1.marca, v1.peso_maximo_ligero
FROM vehiculos_delivery v1
WHERE v1.categoria = 'TRANSPORTE_LIGERO'
  AND v1.peso_maximo_ligero > (
      SELECT AVG(v2.peso_maximo_ligero)
      FROM vehiculos_delivery v2
      WHERE v2.categoria = 'TRANSPORTE_LIGERO'
  );

  -- 14. Consulta con substring: mostrar "matricula, marca" de vehículos motorizados cuya matrícula comience con '123'
SELECT matricula, marca
FROM vehiculos_delivery
WHERE categoria = 'TRANSPORTE_MOTORIZADO'
  AND matricula LIKE '123%';



-- =============================================================
-- VERIFICACIONES DE INTEGRIDAD
-- =============================================================

-- Esta inserción debe FALLAR (vehículo ligero con atributos de motorizado)
-- INSERT INTO vehiculos_delivery VALUES
-- (NULL, 'ERROR-1', 'Trek', 'TRANSPORTE_LIGERO', 'bicicleta', 25.50, 160, 'gasolina');

-- Esta inserción debe FALLAR (vehículo motorizado con atributos de ligero)
-- INSERT INTO vehiculos_delivery VALUES
-- (NULL, 'ERROR-2', 'Honda', 'TRANSPORTE_MOTORIZADO', 'bicicleta', 25.50, 160, 'gasolina');

-- =============================================================
-- ANÁLISIS DE LA IMPLEMENTACIÓN TABLA ÚNICA
-- =============================================================

/*
✅ VENTAJAS:
- Simplicidad: Una sola tabla para gestionar
- Consultas rápidas: No requiere JOINs
- ISA garantizada: El ENUM 'categoria' obliga a elegir una opción (TOTAL)
- Exclusividad garantizada: Las CHECK constraints impiden mezclar atributos

❌ INCONVENIENTES:
- Campos NULL: Muchos campos quedan vacíos según la categoría
- Complejidad en restricciones: Las CHECK constraints son complejas
- Escalabilidad limitada: Añadir nuevas categorías requiere ALTER TABLE

🎯 IDEAL PARA:
- Pocas categorías estables
- Consultas frecuentes que cruzan categorías
- Sistemas donde el rendimiento es crítico
*/

-- =============================================================
-- EJERCICIOS PROPUESTOS PARA EL ALUMNO
-- =============================================================

/*
EJERCICIO A: Inserta 3 vehículos nuevos (2 ligeros, 1 motorizado)
EJERCICIO B: Actualiza el estado de todos los patinetes a 'mantenimiento'
EJERCICIO C: Encuentra el vehículo motorizado con mayor cilindrada
EJERCICIO D: Lista todas las marcas que tienen vehículos ligeros
EJERCICIO E: Calcula el peso promedio de las bicicletas activas

PREGUNTA DE REFLEXIÓN:
¿Qué ocurriría si quisiéramos añadir una nueva categoría "TRANSPORTE_AEREO" 
para drones de delivery? ¿Qué cambios necesitaríamos hacer?
*/

