-- ==========================================================================================
-- 0) EJERCICIO COMPLETO: EMPRESA DE COMUNICACIONES MÓVILES - DESCRIPCIÓN.
-- ==========================================================================================
-- El alumno debe 
    -- 1) Obtener (abstraer) el Modelo Conceptual MER/MERE de la BBDD: Entidades, atributos y relaciones.
    -- 2) Pasar dicho grafo al modelo MR: tablas y restricciones.
    -- 3) Programar en SQL dicho modelo MR, escribiendo y ejecutando cada sentencia en db-fiddle.com (MySQL), observando los resultados y posibles errores.

-- DESCRIPCIÓN DEL NEGOCIO:
-- Base de datos: Empresas de comunicaciones móviles.
-- Una empresa de comunicaciones móviles gestiona clientes y planes de telefonía.
    -- Un cliente puede tener múltiples planes (histórico), y un plan puede ser contratado por múltiples clientes.
    -- Los atributos de un cliente incluyen: id_cliente, nombre, apellidos (descompuesto en apellido_pat y apellido_mat), 
    --   teléfonos (multivaluado, tabla separada), email (único con CHECK '@'), fecha_nacimiento (opcional, NULL), 
    --   num_lineas (contador automático de teléfonos actualizado por triggers).
    -- Los atributos de un plan incluyen: id_plan, nombre_plan, precio_mensual (CHECK > 0), 
    --   minutos_incluidos (CHECK >= 0), datos_gb (CHECK > 0).
    -- Cuando un cliente contrata un plan, se registra la fecha de inicio (CHECK no futura), 
    --   el estado del contrato (ENUM: 'Activo', 'Inactivo' con DEFAULT 'Activo').
    -- Todas las relaciones tienen ON DELETE CASCADE para integridad referencial automática.

-- ==========================================================================================
-- 1) MODELO CONCEPTUAL SIMPLIFICADO: ENTIDADES, ATRIBUTOS Y RELACIONES (MER/MERE)
-- ==========================================================================================
-- Grafo (no incluido en SQL, debe hacerse en papel o herramienta gráfica).

    -- ENTIDADES IDENTIFICADAS:
        -- 1. CLIENTES (entidad fuerte)
        -- 2. PLANES (entidad fuerte)  
    
    -- RELACIONES IDENTIFICADAS:
        -- RELACIÓN: CLIENTE - PLAN (N:M)-- 


-- ENTIDAD: CLIENTES
-- - id_cliente (PK): Identificador único
-- - nombre: Nombre del cliente
-- - apellidos: Apellidos del cliente -- atributo multiple, se descompone en apellido_pat y apellido_mat.
-- - telefonos: Números de teléfono  -- atributo multivaluado, se crea tabla aparte.
-- - email: Correo electrónico (debe ser único)
-- - fecha_nacimiento: Fecha de nacimiento (opcional)

-- ENTIDAD: PLANES
-- - id_plan (PK): Identificador único del plan
-- - nombre_plan: Nombre comercial del plan
-- - precio_mensual: Precio mensual del plan
-- - minutos_incluidos: Minutos de llamadas incluidos
-- - datos_gb: Gigas de datos incluidos

-- ==========================================================================================
-- 2) MODELO LOGICO (MR): TABLAS, RELACIONES Y RESTRICCIONES
-- ==========================================================================================
-- La relación N:M entre CLIENTES y PLANES se resuelve con la tabla intermedia: CONTRATOS

-- MODELO RESULTANTE: 4 TABLAS CON RESTRICCIONES COMPLETAS
    -- TABLA CLIENTES (entidad principal)
        -- - id_cliente INT (PK): Identificador único
        -- - nombre VARCHAR(50): Nombre del cliente
        -- - apellido_pat VARCHAR(50): Apellido paterno
        -- - apellido_mat VARCHAR(50): Apellido materno
        -- - email VARCHAR(100) (UNIQUE + CHECK LIKE '%@%'): Correo electrónico con validación
        -- - fecha_nacimiento DATE NULL: Fecha de nacimiento (opcional, permite NULL)
        -- - num_lineas INT DEFAULT 0: Contador automático de teléfonos (actualizado por triggers)
    
    -- TABLA TELEFONOS (para almacenar múltiples teléfonos por cliente)
        -- - num_telefono INT (PK): Número de teléfono como identificador único
        -- - FK_id_cliente INT (FK ON DELETE CASCADE): Referencia a CLIENTES
    
    -- TABLA PLANES (entidad principal)
        -- - id_plan INT (PK): Identificador único del plan
        -- - nombre_plan VARCHAR(50): Nombre comercial del plan
        -- - precio_mensual DECIMAL(8,2) (CHECK > 0): Precio mensual (debe ser positivo)
        -- - minutos_incluidos INT (CHECK >= 0): Minutos incluidos (no negativos)
        -- - datos_gb INT (CHECK > 0): Gigas de datos (debe ser positivo)
    
    -- TABLA CONTRATOS (tabla intermedia - resuelve la relación N:M)
        -- - id_contrato INT (PK): Identificador único del contrato
        -- - FK_id_cliente INT (FK ON DELETE CASCADE): Referencia a CLIENTES
        -- - FK_id_plan INT (FK ON DELETE CASCADE): Referencia a PLANES
        -- - fecha_inicio DATE (CHECK <= CURDATE()): Fecha de inicio (no puede ser futura)
        -- - estado ENUM('Activo', 'Inactivo') DEFAULT 'Activo': Estado del contrato

-- TRIGGERS IMPLEMENTADOS:
    -- tr_actualizar_num_lineas_insert: AFTER INSERT en telefonos - incrementa num_lineas
    -- tr_actualizar_num_lineas_delete: AFTER DELETE en telefonos - decrementa num_lineas


-- ==========================================================================================
-- SECCIÓN DDL: CREACIÓN Y MODIFICACIÓN DE ESTRUCTURA
-- ==========================================================================================

-- 1) Crea una base de datos llamada 'telecom_empresa'. (esta parte no se puede hacer en db-fiddle.com)
-- Query de comprobación:
SHOW DATABASES;

-- Solución:
CREATE DATABASE IF NOT EXISTS telecom_empresa;
USE telecom_empresa;


-- 2) Crea una tabla 'clientes' (sólo definiendo tipos, sin restricciones) con: id_cliente INT, 
-- nombre VARCHAR(50), apellido_pat VARCHAR(50), apellido_mat VARCHAR(50), email VARCHAR(100), fecha_nacimiento DATE.
-- Añade una restricción CHECK para validar que el email contenga '@'.
-- Query de comprobación:
SHOW TABLES;
DESCRIBE clientes;

-- Solución:
CREATE TABLE clientes (
    id_cliente INT,
    nombre VARCHAR(50),
    apellido_pat VARCHAR(50),  -- descomposición del atributo múltiple apellidos
    apellido_mat VARCHAR(50),  -- descomposición del atributo múltiple apellidos
    -- telefono VARCHAR(20), -- no es necesario, se crea tabla aparte.
    email VARCHAR(100) CHECK (email LIKE '%@%'),  -- CHECK: el email debe contener '@'
    fecha_nacimiento DATE
);


-- 3) Crea una tabla 'telefonos' (sólo definiendo tipos, sin restricciones) con: num_telefono INT, id_cliente INT.
-- Query de comprobación:
DESCRIBE telefonos;

-- Solución:
CREATE TABLE telefonos (
    num_telefono INT,
    id_cliente INT
);


-- 4) Crea una tabla 'planes' (sólo definiendo tipos, sin restricciones) con: id_plan INT, nombre_plan VARCHAR(50), precio_mensual DECIMAL(8,2), minutos_incluidos INT, datos_gb INT.
-- Añade restricciones CHECK: precio_mensual > 0, minutos_incluidos >= 0, datos_gb > 0.
-- Query de comprobación:
DESCRIBE planes;

-- Solución:
CREATE TABLE planes (
    id_plan INT,
    nombre_plan VARCHAR(50),
    precio_mensual DECIMAL(8,2) CHECK (precio_mensual > 0),  -- CHECK: precio debe ser positivo
    minutos_incluidos INT CHECK (minutos_incluidos >= 0),    -- CHECK: minutos no negativos
    datos_gb INT CHECK (datos_gb > 0)                        -- CHECK: datos debe ser positivo
);


-- 5) Crea la tabla intermedia 'contratos' (sólo definiendo tipos, sin restricciones) para la relación N:M entre clientes y planes.
-- Campos: id_contrato INT, id_cliente INT, id_plan INT, fecha_inicio DATE, estado VARCHAR(20).
-- Añade una restricción CHECK para validar que fecha_inicio no sea futura.
-- Query de comprobación:
DESCRIBE contratos;

-- Solución:
CREATE TABLE contratos (
    id_contrato INT,
    id_cliente INT,
    id_plan INT,
    fecha_inicio DATE, -- CHECK (fecha_inicio <= CURDATE()),  -- CHECK: fecha no puede ser futura. Ésto da un error
    -- tanto en db-fiddle.com como en MySQL Workbench, porque no se puede utilizar una función no-determinstica en CHECK.
    -- Alternativa: quitar el CHECK y validar en la aplicación o mediante triggers.
    estado VARCHAR(20)  -- estado puede ser 'Activo', 'Cancelado', 'Suspendido' (más adelante se puede cambiar a ENUM)
);


-- 6) Añade claves primarias a las tablas.
-- Query de comprobación:
DESCRIBE clientes;
DESCRIBE telefonos;
DESCRIBE planes;
DESCRIBE contratos;

-- Solución:
ALTER TABLE clientes ADD PRIMARY KEY (id_cliente);
ALTER TABLE telefonos ADD PRIMARY KEY (num_telefono);
ALTER TABLE planes ADD PRIMARY KEY (id_plan);
ALTER TABLE contratos ADD PRIMARY KEY (id_contrato);

-- 7) Modifica la columna 'estado' ENUM('Activo', 'Inactivo') con valor por defecto 'Activo' a la tabla contratos.
-- Query de comprobación:
DESCRIBE contratos;

-- Solución:
ALTER TABLE contratos MODIFY COLUMN estado ENUM('Activo', 'Inactivo') DEFAULT 'Activo';
    -- Alternativa (CHANGE COLUMN):
    -- ALTER TABLE contratos CHANGE COLUMN estado estado ENUM('Activo', 'Inactivo') DEFAULT 'Activo';

-- 8) Identifica las claves foráneas necesarias en las tablas y renómbralas.
-- Claves foráneas:
    -- contratos.id_cliente será FK_id_cliente y apunta a -> clientes.id_cliente
    -- contratos.id_plan será FK_id_plan y apuntará a -> planes.id_plan
    -- telefonos.id_cliente será FK_id_cliente -> clientes.id_cliente
-- Queries de comprobación:
DESCRIBE contratos;
DESCRIBE telefonos;

-- Solución:
ALTER TABLE contratos CHANGE COLUMN id_cliente FK_id_cliente INT;
ALTER TABLE contratos CHANGE COLUMN id_plan FK_id_plan INT;
ALTER TABLE telefonos CHANGE COLUMN id_cliente FK_id_cliente INT;


-- 9) Añade las claves foráneas con ON DELETE CASCADE a las claves foráneas a la tablas CONTRATOS Y TELEFONOS.
-- Query de comprobación:
SHOW CREATE TABLE contratos;
SHOW CREATE TABLE telefonos;

ALTER TABLE contratos ADD CONSTRAINT fk_contratos_clientes FOREIGN KEY (FK_id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE;
ALTER TABLE contratos ADD CONSTRAINT fk_contratos_planes FOREIGN KEY (FK_id_plan) REFERENCES planes(id_plan) ON DELETE CASCADE;
ALTER TABLE telefonos ADD CONSTRAINT fk_telefonos_clientes FOREIGN KEY (FK_id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE;


-- 11) Añade la restricción UNIQUE al campo email de la tabla clientes.
-- Query de comprobación:   
DESCRIBE clientes;

-- Solución:
ALTER TABLE clientes ADD CONSTRAINT uq_clientes_email UNIQUE (email);


-- 12) Modifica la tabla clientes para que el campo fecha_nacimiento permita NULL.
-- Query de comprobación:
DESCRIBE clientes;

-- Solución:
ALTER TABLE clientes MODIFY COLUMN fecha_nacimiento DATE NULL;


-- 13) Añade una columna 'num_lineas' INT con valor por defecto 0 a la tabla clientes para contar automáticamente los teléfonos.
-- Query de comprobación:
DESCRIBE clientes;

-- Solución:
ALTER TABLE clientes ADD COLUMN num_lineas INT DEFAULT 0;


-- =============================================
-- SECCIÓN DDL: CREACIÓN DE TRIGGERS
-- =============================================
-- 14) Trigger para validar la fecha de inicio en contratos (no puede ser futura).
-- Query de comprobación:
SHOW TRIGGERS;
-- Solución:
DELIMITER //
CREATE TRIGGER tr_validar_fecha_inicio
    BEFORE INSERT ON contratos
    FOR EACH ROW
BEGIN
    IF NEW.fecha_inicio > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La fecha de inicio no puede ser futura.';
    END IF;
END//
DELIMITER ; 

-- 14) Crea un trigger que se ejecute DESPUÉS de INSERT en la tabla telefonos para actualizar automáticamente num_lineas en clientes.
-- El trigger debe incrementar en 1 el contador num_lineas del cliente correspondiente.
-- Query de comprobación:
SHOW TRIGGERS;

-- Solución:
DELIMITER //
CREATE TRIGGER tr_actualizar_num_lineas_insert
    AFTER INSERT ON telefonos
    FOR EACH ROW
BEGIN
    UPDATE clientes 
    SET num_lineas = num_lineas + 1 
    WHERE id_cliente = NEW.FK_id_cliente;
END//
DELIMITER ;


-- 15) Crea un trigger que se ejecute DESPUÉS de DELETE en la tabla telefonos para decrementar num_lineas en clientes.
-- El trigger debe decrementar en 1 el contador num_lineas del cliente correspondiente.
-- Query de comprobación:
SHOW TRIGGERS;

-- Solución:
DELIMITER //
CREATE TRIGGER tr_actualizar_num_lineas_delete
    AFTER DELETE ON telefonos
    FOR EACH ROW
BEGIN
    UPDATE clientes 
    SET num_lineas = num_lineas - 1 
    WHERE id_cliente = OLD.FK_id_cliente;
END//
DELIMITER ;


-- =============================================
-- SECCIÓN DML: INSERCIÓN Y MANIPULACIÓN DE DATOS
-- =============================================

-- 16) Prueba las restricciones CHECK intentando insertar datos inválidos.
-- a) Intenta insertar un cliente con email sin '@'
-- b) Intenta insertar un plan con precio negativo
-- c) Intenta insertar un contrato con fecha futura
-- Query de comprobación:
SELECT * FROM clientes;
SELECT * FROM planes;
SELECT * FROM contratos;

-- Soluciones (estas consultas DEBEN FALLAR):
-- INSERT INTO clientes (id_cliente, nombre, apellido_pat, apellido_mat, email) VALUES (99, 'Test', 'User', 'Error', 'email_sin_arroba');  -- ERROR: Violación CHECK email
-- INSERT INTO planes (id_plan, nombre_plan, precio_mensual, minutos_incluidos, datos_gb) VALUES (99, 'Plan Error', -10.00, 100, 1);  -- ERROR: Violación CHECK precio
-- INSERT INTO contratos (id_contrato, id_cliente, id_plan, fecha_inicio, estado) VALUES (99, 1, 1, '2025-12-31', 'Activo');  -- ERROR: Violación CHECK fecha


-- 17) Inserta tres clientes en la tabla clientes, sin sus fechas de nacimiento.

-- Solución:
INSERT INTO clientes (id_cliente, nombre, apellido_pat, apellido_mat, email) VALUES
(1, 'Carlos', 'García', 'Pérez', 'carlos@email.com'),
(2, 'María', 'López', 'Gómez', 'maria@email.com'),
(3, 'Juan', 'Martín', 'Sánchez', 'juan@email.com');


-- 18) Inserta dos planes de telefonía.

-- Solución:
INSERT INTO planes (id_plan, nombre_plan, precio_mensual, minutos_incluidos, datos_gb) VALUES
(1, 'Plan Básico', 15.99, 300, 2),
(2, 'Plan Premium', 29.99, 1000, 10);


-- 19) Inserta tres contratos (relación N:M entre clientes y planes).

-- Solución:
INSERT INTO contratos (id_contrato, FK_id_cliente, FK_id_plan, fecha_inicio, estado) VALUES
(1, 1, 1, '2024-01-15', 'Activo'),
(2, 2, 2, '2024-02-01', 'Activo'),
(3, 1, 2, '2024-03-10', 'Inactivo');

-- 20) Inserta teléfonos para los clientes y observa cómo los triggers actualizan num_lineas automáticamente.
-- Datos: (600123456, 1), (646123456, 1), (600987654, 2), (646987654, 2), (600555555, 3).
-- Query de comprobación ANTES (verificar que num_lineas está en 0):
SELECT id_cliente, nombre, num_lineas FROM clientes;

-- Solución:
INSERT INTO telefonos (num_telefono, FK_id_cliente) VALUES
(600123456, 1),
(646123456, 1),
(600987654, 2),
(646987654, 2),
(600555555, 3);

-- Query de comprobación DESPUÉS (verificar que num_lineas se actualizó automáticamente):
SELECT id_cliente, nombre, num_lineas FROM clientes;


-- 21) Prueba el trigger de DELETE eliminando un teléfono y verificando que num_lineas se decrementa.
-- Elimina el teléfono del cliente 3 y verifica que su num_lineas se decrementa.
-- Query de comprobación ANTES:
SELECT id_cliente, nombre, num_lineas FROM clientes WHERE id_cliente = 3;

-- Solución:
DELETE FROM telefonos WHERE num_telefono = 600555555; -- ¿por qué funciona con este WHERE y no con FK_id_cliente = 3?
    -- porque num_telefono es PK y es único, mientras que FK_id_cliente no lo es.

-- Query de comprobación DESPUÉS:
SELECT id_cliente, nombre, num_lineas FROM clientes WHERE id_cliente = 3;


-- 22) Inserta la fecha de nacimiento para los clientes 1 y 3 que ya existen en la tabla.
-- Query de comprobación:
SELECT * FROM clientes;

-- Solución:
UPDATE clientes SET fecha_nacimiento = '1990-05-15' WHERE id_cliente = 1;
UPDATE clientes SET fecha_nacimiento = '1985-08-25' WHERE id_cliente = 3;


-- 23) Actualiza el precio del plan 'Plan Básico' a 17.99.
-- Puede dar error 1175 (modo seguro: porque para actualizar un registro deberíamos 
-- utilizar WHERE contra alguna clave o índice) en MySQL Workbench, 
-- en db-fiddle.com no da error.
-- Para MySQL se puede desactivar el modo SET SQL_SAFE_UPDATES = 0 y luego volver activarlo.
-- Query de comprobación:
SELECT * FROM planes WHERE nombre_plan = 'Plan Básico'; -- esto daría error en MySQL Workbench si SQL_SAFE_UPDATES = 1

-- Solución:
SET SQL_SAFE_UPDATES = 0;
UPDATE planes SET precio_mensual = 17.99 WHERE nombre_plan = 'Plan Básico';
SET SQL_SAFE_UPDATES = 1;

-- 24) Cambia el estado del contrato del cliente con id_cliente = 3 a 'Inactivo'.
-- NOTA: Cambiamos a 'Inactivo' porque el ENUM sólo permite 'Activo' e 'Inactivo'
-- Query de comprobación:
SELECT * FROM contratos WHERE FK_id_cliente = 3;

-- Solución:
UPDATE contratos SET estado = 'Inactivo' WHERE FK_id_cliente = 3;


-- 25) Inserta un nuevo plan o si ya existe, actualiza todos sus datos con los siguientes (UPSERT):
-- id_plan, nombre_plan, precio_mensual, minutos_incluidos, datos_gb: (3, 'Plan Estudiante', 12.99, 200, 1)
-- Query de comprobación:
SELECT * FROM planes WHERE id_plan = 3;

-- Solución:
INSERT INTO planes (id_plan, nombre_plan, precio_mensual, minutos_incluidos, datos_gb) VALUES
(3, 'Plan Estudiante', 12.99, 200, 1)
ON DUPLICATE KEY UPDATE 
    nombre_plan = VALUES(nombre_plan),
    precio_mensual = VALUES(precio_mensual),
    minutos_incluidos = VALUES(minutos_incluidos),
    datos_gb = VALUES(datos_gb);


-- 26) Elimina el contrato con id_contrato = 2.
-- Query de comprobación:
SELECT * FROM contratos;

-- Solución:
DELETE FROM contratos WHERE id_contrato = 2;


-- 27) Actualiza masivamente: incrementa en 10% el precio de todos los planes que tengan un precio menor a 20 euros.
-- Query de comprobación:
SELECT * FROM planes WHERE precio_mensual < 20;

-- Solución:
UPDATE planes SET precio_mensual = precio_mensual * 1.10 WHERE precio_mensual < 20;


-- 28) Actualiza masivamente: incrementa en 500 los minutos incluidos para todos los planes que tengan menos de 500 minutos.
-- Query de comprobación:
SELECT * FROM planes WHERE minutos_incluidos < 500;

-- Solución:
UPDATE planes SET minutos_incluidos = minutos_incluidos + 500 WHERE minutos_incluidos < 500;


-- 29) Prueba el funcionamiento de ON DELETE CASCADE eliminando un cliente y observando la eliminación automática.
-- Al eliminar un cliente, se deben eliminar automáticamente todos sus contratos y teléfonos debido a ON DELETE CASCADE.
-- Query de comprobación ANTES (verificar datos existentes):
SELECT 'CLIENTES:' as tabla;
SELECT id_cliente, nombre FROM clientes;
SELECT 'CONTRATOS:' as tabla;
SELECT id_contrato, FK_id_cliente, FK_id_plan FROM contratos;
SELECT 'TELEFONOS:' as tabla;
SELECT num_telefono, FK_id_cliente FROM telefonos;

-- Solución (eliminar cliente 1):
DELETE FROM clientes WHERE id_cliente = 1;

-- Query de comprobación DESPUÉS (verificar eliminación en cascada):
SELECT 'CLIENTES RESTANTES:' as tabla;
SELECT id_cliente, nombre FROM clientes;
SELECT 'CONTRATOS RESTANTES:' as tabla;
SELECT id_contrato, FK_id_cliente, FK_id_plan FROM contratos;
SELECT 'TELEFONOS RESTANTES:' as tabla;
SELECT num_telefono, FK_id_cliente FROM telefonos;


-- 31) Elimina todas las restricciones de clave foránea de la tabla intermedia CONTRATOS.
-- IMPORTANTE: Hay que eliminar primero las FK de la tabla intermedia antes de eliminar las tablas principales.
-- Query de comprobación:
DESCRIBE contratos;

-- Solución:
ALTER TABLE contratos DROP FOREIGN KEY fk_contratos_clientes;
ALTER TABLE contratos DROP FOREIGN KEY fk_contratos_planes;
ALTER TABLE telefonos DROP FOREIGN KEY fk_telefonos_clientes;


-- 32) Vacía todos los registros de la tabla intermedia manteniendo su estructura.
-- Query de comprobación:
SELECT * FROM contratos;

-- Solución:
TRUNCATE TABLE contratos;

-- 33) Elimina la tabla intermedia (se eliminan primero porque dependen de las otras).
-- Query de comprobación:
SHOW TABLES;

-- Solución:
DROP TABLE contratos;

-- 34) Elimina las tablas.
-- Query de comprobación:
SHOW TABLES;

-- Solución:
DROP TABLE planes;
DROP TABLE telefonos;
DROP TABLE clientes;


-- 35) Elimina la base de datos telecom_empresa. (esta parte no se puede hacer en db-fiddle.com)
-- Query de comprobación:
SHOW DATABASES;

-- Solución:
DROP DATABASE telecom_empresa;

-- =============================================
-- FIN DEL EJERCICIO COMPLETO
-- =============================================