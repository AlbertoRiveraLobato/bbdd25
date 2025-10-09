-- ==========================================================================================
-- 0) EJERCICIO COMPLETO: GESTIÓN DE PRÉSTAMOS Y PAGOS - DESCRIPCIÓN.
-- ==========================================================================================
-- El alumno debe 
    -- 1) Obtener (abstraer) el Modelo Conceptual MER/MERE de la BBDD: Entidades, atributos y relaciones.
    -- 2) Pasar dicho grafo al modelo MR: tablas y restricciones.
    -- 3) Programar en SQL dicho modelo MR, escribiendo y ejecutando cada sentencia en db-fiddle.com (MySQL), observando los resultados y posibles errores.

-- DESCRIPCIÓN DEL NEGOCIO:
-- Base de datos: Gestión de préstamos y pagos asociados.
-- Una entidad financiera gestiona préstamos concedidos y los pagos realizados sobre cada préstamo.
    -- Un préstamo puede tener 0, 1 o muchos pagos realizados (relación 1:N).
        -- Cada préstamos lleva control de los pagos realizados.
    -- Un pago solo puede estar asociado a un único préstamo (relación N:1).
    -- Los atributos de un préstamo incluyen: código (irrepetible, clave primaria), importe (obligatorio, positivo), y num_pagos_realizados (por defecto 0).
    -- Los pagos tienen como atributos un número secuencial (único para cada préstamo), fecha de realización (La fecha del pago no puede ser futura) y el importe pagado (positivo).
    -- La entidad pagos es débil en identificación: depende del préstamo al que pertenece, por lo que su clave primaria es compuesta (código_préstamo, num_pago).
    -- Si se borra un préstamo, se deben borrar automáticamente todos sus pagos asociados (ON DELETE CASCADE en la relación).

-- ==========================================================================================
-- 1) MODELO CONCEPTUAL SIMPLIFICADO: ENTIDADES, ATRIBUTOS Y RELACIONES (MER/MERE)
-- ==========================================================================================
-- Grafo (no incluido en SQL, debe hacerse en papel o herramienta gráfica).

    -- ENTIDADES IDENTIFICADAS:
        -- 1. PRÉSTAMOS (entidad fuerte)
        -- 2. PAGOS (entidad débil - identificada por el préstamo al que pertenece)  
    
    -- RELACIÓN IDENTIFICADA:
        -- RELACIÓN: PRÉSTAMO - PAGO (1:N)

-- ENTIDAD: PRÉSTAMOS
-- - codigo (PK): Código único del préstamo
-- - importe: Importe del préstamo (positivo)
-- - importe_pendiente: diferencia con respecto a los pagos realizados (por defecto igual al importe del préstamo)

-- ENTIDAD: PAGOS
-- - num_pago: Número secuencial del pago (único para cada préstamo)
-- - fecha_pago: Fecha de realización del pago (no futura)
-- - importe_pago: Importe abonado en el pago (positivo)

-- ==========================================================================================
-- 2) MODELO LOGICO (MR): TABLAS, RELACIONES Y RESTRICCIONES
-- ==========================================================================================
-- La relación 1:N entre PRÉSTAMOS y PAGOS se resuelve con la clave foránea en la tabla PAGOS.

-- MODELO RESULTANTE: 2 TABLAS CON RESTRICCIONES COMPLETAS
    -- TABLA PRESTAMOS (entidad principal)
        -- - codigo VARCHAR(20) (PK): Código único del préstamo
        -- - importe DECIMAL(10,2) (CHECK > 0): Importe del préstamo (debe ser positivo)
        -- - importe_pendiente DECIMAL(10,2) (CHECK >= 0): Importe pendiente de pago (por defecto igual al importe del préstamo)
    
    -- TABLA PAGOS (entidad débil)
        -- - codigo_préstamo VARCHAR(20) (FK, parte de PK): Referencia a PRESTAMOS
        -- - num_pago INT (PK): Número secuencial del pago para ese préstamo
        -- - fecha_pago DATE: Fecha de realización del pago (no puede ser futura)
        -- - importe_pago DECIMAL(10,2) (CHECK > 0): Importe abonado en el pago (positivo)
        -- - Restricción PRIMARY KEY (codigo_préstamo, num_pago): Clave compuesta para identificación débil
        -- - Restricción FOREIGN KEY (codigo_préstamo) REFERENCES prestamos(codigo) ON DELETE CASCADE: Borra los pagos si se borra el préstamo asociado

    -- TRIGGERS (opcional, para validaciones adicionales)
        -- - Trigger para asegurar que importe_pendiente en PRESTAMOS se actualiza correctamente al insertar un nuevo pago en PAGOS.
        -- - Trigger para inicializar el importe_pendiente al crear un nuevo préstamo.
        -- - Trigger para validar que la fecha de pago no sea futura.
        -- - Trigger para asegurar que el número de pago es secuencial por préstamo.
        
-- ==========================================================================================
-- 3) IMPLEMENTACIÓN EN SQL DEL MODELO RELACIONAL (MR)
-- ==========================================================================================
-- ==========================================================================================
-- SECCIÓN DDL: CREACIÓN Y MODIFICACIÓN DE ESTRUCTURA
-- ==========================================================================================
-- 1) Crea una base de datos llamada 'prestamos_bbdd'. (esta parte no se puede hacer en db-fiddle.com)
-- Query de comprobación:
SHOW DATABASES;

-- Solución:
DROP DATABASE IF EXISTS prestamos_bbdd;
CREATE DATABASE IF NOT EXISTS prestamos_bbdd;
USE prestamos_bbdd;


-- 2) Creación de la tabla PRESTAMOS (con restricciones pero sin clave primaria aún).
-- Query de comprobación:
SHOW TABLES;
DESCRIBE prestamos;

-- Solución:
CREATE TABLE prestamos (
    codigo VARCHAR(20),
    importe DECIMAL(10,2) CHECK (importe > 0),
    importe_pendiente DECIMAL(10,2) CHECK (importe_pendiente >= 0)
);


-- 3) Creación de la tabla PAGOS (entidad débil, con restricciones pero sin clave primaria aún).
-- Query de comprobación:
DESCRIBE pagos;

-- Solución:
CREATE TABLE pagos (
    FK_codigo_prestamo VARCHAR(20),
    num_pago INT,
    fecha_pago DATE,
    importe_pago DECIMAL(10,2) CHECK (importe_pago > 0)
);

-- Podríamos sin embargo, crear la tabla pagos completamente con la clave primaria y foránea:
-- DROP TABLE pagos;  -- Descomenta esta línea si necesitas eliminar la tabla pagos para rehacerla.
-- CREATE TABLE pagos ( 
--     FK_codigo_prestamo VARCHAR(20),
--     num_pago INT,
--     fecha_pago DATE,
--     importe_pago DECIMAL(10,2) CHECK (importe_pago > 0),

--     PRIMARY KEY (FK_codigo_prestamo, num_pago),
--     FOREIGN KEY (FK_codigo_prestamo) REFERENCES prestamos(codigo) ON DELETE CASCADE

        -- O bien: 
            -- CONSTRAINT pk_pagos PRIMARY KEY (FK_codigo_prestamo, num_pago), 
            -- CONSTRAINT fk_pagos_prestamos FOREIGN KEY (FK_codigo_prestamo) REFERENCES prestamos(codigo) ON DELETE CASCADE
-- );

-- 4) Añadir las claves primarias.
-- Query de comprobación:
DESCRIBE prestamos;
DESCRIBE pagos;

-- Solución:
ALTER TABLE prestamos ADD PRIMARY KEY (codigo);
ALTER TABLE pagos ADD PRIMARY KEY (FK_codigo_prestamo, num_pago);


-- 5) Añadir la clave foránea con ON DELETE CASCADE.
-- Query de comprobación:
SHOW CREATE TABLE pagos;

-- Solución:
ALTER TABLE pagos ADD CONSTRAINT fk_pagos_prestamos FOREIGN KEY (FK_codigo_prestamo) 
    REFERENCES prestamos(codigo) ON DELETE CASCADE;

-- BORRAR RESTRICCIONES (si es necesario):
ALTER TABLE pagos DROP FOREIGN KEY fk_pagos_prestamos;
-- 6) Añade un trigger para validar que la fecha de pago no sea futura (validación adicional al CHECK).
-- Query de comprobación:
SHOW TRIGGERS;

-- Solución:
DELIMITER //
CREATE TRIGGER trg_check_fecha_pago
BEFORE INSERT ON pagos 
FOR EACH ROW
BEGIN
    IF NEW.fecha_pago > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de pago no puede ser futura.';
    END IF;
END//
DELIMITER ;


-- 7) Añade un trigger para asegurar que el número de pago es secuencial por préstamo.
-- Query de comprobación:
SHOW TRIGGERS;

-- Solución:
DELIMITER //
CREATE TRIGGER trg_check_num_pago
BEFORE INSERT ON pagos
FOR EACH ROW
BEGIN
-- Este código declara una variable para almacenar el máximo num_pago actual para el préstamo dado.
-- Luego localiza el máximo num_pago en la tabla pagos para el préstamo específico (FK_codigo_prestamo).
-- Si no hay pagos previos, COALESCE devuelve 0.
-- Finalmente, verifica que el nuevo num_pago sea exactamente uno más que el máximo actual.
    DECLARE max_num_pago INT;
    SELECT COALESCE(MAX(num_pago), 0) INTO max_num_pago FROM pagos WHERE FK_codigo_prestamo = NEW.FK_codigo_prestamo;
    IF NEW.num_pago != max_num_pago + 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El número de pago debe ser secuencial para cada préstamo.';
    END IF;
END//
DELIMITER ;

-- 8) Crear trigger para inicializar importe_pendiente al crear un nuevo préstamo.
-- Query de comprobación:
SHOW TRIGGERS;

-- Solución:
DELIMITER //
CREATE TRIGGER trg_init_importe_pendiente
BEFORE INSERT ON prestamos
FOR EACH ROW
BEGIN
    SET NEW.importe_pendiente = NEW.importe;
END//
DELIMITER ;


-- 9) Crear trigger para actualizar importe_pendiente al insertar un nuevo pago.
-- Query de comprobación:
SHOW TRIGGERS;

-- Solución:
DELIMITER //
CREATE TRIGGER trg_update_importe_pendiente
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN
    UPDATE prestamos
    SET importe_pendiente = importe_pendiente - NEW.importe_pago
    WHERE codigo = NEW.FK_codigo_prestamo;
END//
DELIMITER ;


-- 10) Crear trigger para actualizar importe_pendiente al eliminar un pago.
-- Query de comprobación:
SHOW TRIGGERS;

-- Solución:
DELIMITER //
CREATE TRIGGER trg_revert_importe_pendiente
AFTER DELETE ON pagos
FOR EACH ROW
BEGIN
    UPDATE prestamos
    SET importe_pendiente = importe_pendiente + OLD.importe_pago
    WHERE codigo = OLD.FK_codigo_prestamo;
END//
DELIMITER ;



-- ==========================================================================================
-- SECCIÓN DML: INSERCIÓN Y MANIPULACIÓN DE DATOS
-- ==========================================================================================

-- 11) Prueba las restricciones CHECK intentando insertar datos inválidos.
-- a) Intenta insertar un préstamo con importe negativo
-- b) Intenta insertar un pago con importe negativo
-- c) Intenta insertar un pago con fecha futura
-- Query de comprobación:
SELECT * FROM prestamos;
SELECT * FROM pagos;

-- Soluciones (estas consultas DEBEN FALLAR):
-- INSERT INTO prestamos (codigo, importe) VALUES ('P999', -1000.00);  -- ERROR: importe negativo
-- INSERT INTO pagos (FK_codigo_prestamo, num_pago, fecha_pago, importe_pago) VALUES ('P001', 1, '2024-01-15', -100.00);  -- ERROR: importe negativo
-- INSERT INTO pagos (FK_codigo_prestamo, num_pago, fecha_pago, importe_pago) VALUES ('P001', 1, '2025-12-31', 100.00);  -- ERROR: fecha futura


-- 12) Insertar datos de prueba en PRESTAMOS y observar cómo se inicializa importe_pendiente automáticamente.
-- Query de comprobación ANTES:
SELECT COUNT(*) as total_prestamos FROM prestamos;

-- Solución:
INSERT INTO prestamos (codigo, importe) VALUES
('P001', 1000.00),
('P002', 5000.00),
('P003', 750.00);

-- Query de comprobación DESPUÉS:
SELECT * FROM prestamos;


-- 13) Insertar datos de prueba en PAGOS y observar cómo se actualiza importe_pendiente automáticamente.
-- Query de comprobación ANTES:
SELECT codigo, importe, importe_pendiente FROM prestamos;

-- Solución:
INSERT INTO pagos (FK_codigo_prestamo, num_pago, fecha_pago, importe_pago) VALUES
('P001', 1, '2024-01-15', 200.00),
('P001', 2, '2024-02-15', 300.00),
('P002', 1, '2024-01-20', 1000.00);

-- Query de comprobación DESPUÉS:
SELECT * FROM prestamos;
SELECT * FROM pagos;


-- 14) Prueba la validación de número de pago secuencial.
-- Intenta insertar un pago con número no secuencial (DEBE FALLAR).
-- Query de comprobación:
SELECT FK_codigo_prestamo, num_pago FROM pagos WHERE FK_codigo_prestamo = 'P001' ORDER BY num_pago;

-- Solución (DEBE FALLAR):
-- INSERT INTO pagos (FK_codigo_prestamo, num_pago, fecha_pago, importe_pago) VALUES ('P001', 4, '2024-03-15', 100.00);  -- ERROR: debería ser num_pago = 3


-- 15) Inserta correctamente el siguiente pago secuencial.
-- Query de comprobación ANTES:
SELECT FK_codigo_prestamo, num_pago FROM pagos WHERE FK_codigo_prestamo = 'P001' ORDER BY num_pago;

-- Solución:
INSERT INTO pagos (FK_codigo_prestamo, num_pago, fecha_pago, importe_pago) VALUES
('P001', 3, '2024-03-15', 150.00);

-- Query de comprobación DESPUÉS:
SELECT * FROM prestamos WHERE codigo = 'P001';
SELECT * FROM pagos WHERE FK_codigo_prestamo = 'P001';


-- 16) Elimina un pago y verificar que importe_pendiente se actualiza correctamente.
-- Query de comprobación ANTES:
SELECT codigo, importe, importe_pendiente FROM prestamos WHERE codigo = 'P001';

-- Solución:
DELETE FROM pagos WHERE FK_codigo_prestamo = 'P001' AND num_pago = 2;

-- Query de comprobación DESPUÉS:
SELECT codigo, importe, importe_pendiente FROM prestamos WHERE codigo = 'P001';
SELECT * FROM pagos WHERE FK_codigo_prestamo = 'P001';


-- 17) Prueba ON DELETE CASCADE: eliminar un préstamo y verificar que sus pagos se eliminan automáticamente.
-- Query de comprobación ANTES:
SELECT 'ANTES DE ELIMINAR PRÉSTAMO:' as estado;
SELECT * FROM prestamos WHERE codigo = 'P001';
SELECT * FROM pagos WHERE FK_codigo_prestamo = 'P001';

-- Solución:
DELETE FROM prestamos WHERE codigo = 'P001';

-- Query de comprobación DESPUÉS:
SELECT 'DESPUÉS DE ELIMINAR PRÉSTAMO:' as estado;
SELECT * FROM prestamos;
SELECT * FROM pagos;

-- 18) Insertar un nuevo préstamo y varios pagos para demostrar el funcionamiento completo.
-- Query de comprobación ANTES:
SELECT COUNT(*) as total_prestamos FROM prestamos;

-- Solución:
INSERT INTO prestamos (codigo, importe) VALUES ('P004', 2000.00);
INSERT INTO pagos (FK_codigo_prestamo, num_pago, fecha_pago, importe_pago) VALUES
('P004', 1, '2024-04-01', 500.00),
('P004', 2, '2024-05-01', 750.00);

-- Query de comprobación DESPUÉS:
SELECT * FROM prestamos WHERE codigo = 'P004';
SELECT * FROM pagos WHERE FK_codigo_prestamo = 'P004';


-- 19) Eliminar todos los triggers.
-- Query de comprobación:
SHOW TRIGGERS;

-- Solución:
DROP TRIGGER IF EXISTS trg_check_fecha_pago;
DROP TRIGGER IF EXISTS trg_check_num_pago;
DROP TRIGGER IF EXISTS trg_init_importe_pendiente;
DROP TRIGGER IF EXISTS trg_update_importe_pendiente;
DROP TRIGGER IF EXISTS trg_revert_importe_pendiente;


-- 20) Eliminar la clave foránea.
-- Query de comprobación:
SHOW CREATE TABLE pagos;

-- Solución:
ALTER TABLE pagos DROP FOREIGN KEY fk_pagos_prestamos;


-- 21) Vaciar las tablas manteniendo su estructura.
-- Query de comprobación:
SELECT COUNT(*) as total_prestamos FROM prestamos;
SELECT COUNT(*) as total_pagos FROM pagos;

-- Solución:
TRUNCATE TABLE pagos;
TRUNCATE TABLE prestamos;


-- 22) Eliminar las tablas.
-- Query de comprobación:
SHOW TABLES;

-- Solución:
DROP TABLE pagos;
DROP TABLE prestamos;


-- 23) Eliminar la base de datos. (esta parte no se puede hacer en db-fiddle.com)
-- Query de comprobación:
SHOW DATABASES;

-- Solución:
DROP DATABASE prestamos_bbdd;

-- =============================================
-- FIN DEL EJERCICIO COMPLETO
-- =============================================
