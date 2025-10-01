-- =============================================
-- 06_PRECAUCIONES_UPDATE_DELETE.sql
-- =============================================
-- Precauciones a la hora de actualizar o borrar datos masivos en MySQL/MariaDB.
-- Contenido:
--   - Creación de base de datos y tablas necesarias.
--   - Precauciones esenciales antes de operaciones masivas.
--   - Uso de transacciones para operaciones seguras.
--   - Ejemplos de backups y puntos de restauración.
--   - Buenas prácticas para DELETE y UPDATE masivos.

-- =============================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS
-- =============================================

CREATE DATABASE IF NOT EXISTS ejemplo_precauciones;
USE ejemplo_precauciones;

CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    departamento VARCHAR(30),
    salario DECIMAL(10,2),
    fecha_contratacion DATE,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    categoria VARCHAR(30),
    precio DECIMAL(10,2),
    stock INT,
    descatalogado BOOLEAN DEFAULT FALSE
);

-- Insertar datos de ejemplo
INSERT INTO empleados (nombre, apellido, departamento, salario, fecha_contratacion) VALUES
('Juan', 'Pérez', 'IT', 45000.00, '2020-01-15'),
('María', 'García', 'Ventas', 38000.00, '2021-03-20'),
('Carlos', 'López', 'IT', 50000.00, '2019-06-10'),
('Ana', 'Martín', 'RRHH', 42000.00, '2022-01-25'),
('Luis', 'Rodríguez', 'Ventas', 35000.00, '2023-02-15');

INSERT INTO productos (nombre, categoria, precio, stock) VALUES
('Ratón', 'Hardware', 25.99, 100),
('Teclado', 'Hardware', 45.50, 50),
('Monitor', 'Hardware', 199.99, 25),
('Silla', 'Mobiliario', 150.00, 10),
('Mesa', 'Mobiliario', 300.00, 5);

-- =============================================
-- PRECAUCIÓN 1: HACER BACKUP ANTES DE OPERACIONES MASIVAS
-- =============================================

-- ANTES de cualquier operación masiva, crear backup de la tabla o base de datos

-- Opción A: Backup de tabla específica
CREATE TABLE empleados_backup AS SELECT * FROM empleados;
CREATE TABLE productos_backup AS SELECT * FROM productos;

-- Opción B: Backup usando mysqldump (desde terminal/cmd)
-- mysqldump -u usuario -p ejemplo_precauciones > backup_ejemplo_precauciones.sql

-- Opción C: Backup de tabla específica con mysqldump
-- mysqldump -u usuario -p ejemplo_precauciones empleados > backup_empleados.sql

-- =============================================
-- PRECAUCIÓN 2: USAR TRANSACCIONES PARA OPERACIONES COMPLEJAS
-- =============================================

-- EJEMPLO 1: UPDATE masivo con transacción
START TRANSACTION;

-- Aumentar salario a empleados de IT en un 10%
UPDATE empleados 
SET salario = salario * 1.10 
WHERE departamento = 'IT';

-- Verificar los cambios antes de confirmar
SELECT * FROM empleados WHERE departamento = 'IT';

-- Si todo está correcto, confirmar cambios
COMMIT;

-- Si algo está mal, deshacer cambios
-- ROLLBACK;

-- =============================================
-- PRECAUCIÓN 3: PROBAR CONSULTAS CON SELECT ANTES DE UPDATE/DELETE
-- =============================================

-- NUNCA ejecutes directamente UPDATE o DELETE masivo
-- SIEMPRE prueba primero con SELECT para ver qué registros se afectarán

-- INCORRECTO (PELIGROSO):
-- DELETE FROM empleados WHERE fecha_contratacion < '2021-01-01';

-- CORRECTO (SEGURO):
-- 1). Primero verificar qué se va a eliminar
SELECT * FROM empleados WHERE fecha_contratacion < '2021-01-01';

-- 2). Si el resultado es correcto, entonces proceder con transacción
START TRANSACTION;

DELETE FROM empleados WHERE fecha_contratacion < '2021-01-01';

-- 3). Verificar resultado
SELECT COUNT(*) as empleados_restantes FROM empleados;

-- 4). Si está correcto, confirmar
COMMIT;
-- Si está mal: ROLLBACK;

-- =============================================
-- PRECAUCIÓN 4: USAR LIMIT EN OPERACIONES MASIVAS
-- =============================================

-- Para evitar bloqueos prolongados, procesar datos en lotes pequeños

-- INCORRECTO (puede bloquear la tabla mucho tiempo):
-- UPDATE productos SET precio = precio * 1.15 WHERE categoria = 'Hardware';

-- CORRECTO (procesar por lotes):
START TRANSACTION;

UPDATE productos 
SET precio = precio * 1.15 
WHERE categoria = 'Hardware' 
LIMIT 1000;  -- Procesar máximo 1000 registros por vez

COMMIT;

-- Para tablas muy grandes, repetir el proceso hasta que no haya más registros que actualizar



-- =============================================
-- PRECAUCIÓN 6: USAR WHERE ESPECÍFICO Y EVITAR OPERACIONES SIN WHERE
-- =============================================

-- PELIGROSÍSIMO (borra TODOS los registros):
-- DELETE FROM empleados;  -- ¡NUNCA hacer esto sin WHERE!
-- UPDATE empleados SET salario = 0;  -- ¡NUNCA hacer esto sin WHERE!

-- CORRECTO: Siempre usar WHERE específico
START TRANSACTION;

-- Marcar empleados como inactivos en lugar de eliminar
UPDATE empleados 
SET activo = FALSE 
WHERE fecha_contratacion < '2020-01-01' 
AND departamento = 'Ventas';

-- Verificar cambio
SELECT * FROM empleados WHERE activo = FALSE;

COMMIT;

-- =============================================
-- PRECAUCIÓN 7: CONFIGURAR SAFE UPDATES MODE
-- =============================================

-- Habilitar modo seguro para prevenir operaciones peligrosas
SET SQL_SAFE_UPDATES = 1;

-- Con safe updates habilitado, estas consultas fallarán:
-- DELETE FROM empleados;  -- Error: requiere WHERE con clave primaria o LIMIT
-- UPDATE empleados SET salario = 0;  -- Error: requiere WHERE con clave primaria o LIMIT

-- Para operaciones legítimas sin clave primaria, usar:
SET SQL_SAFE_UPDATES = 0;
-- ... realizar operación ...
SET SQL_SAFE_UPDATES = 1;  -- Volver a habilitar



-- =============================================
-- NO utilizar hasta siguientes unidades PRECAUCIÓN 5: VERIFICAR RESTRICCIONES Y DEPENDENCIAS
-- =============================================

-- Antes de DELETE, verificar si hay registros relacionados en otras tablas

-- Ejemplo: Verificar dependencias antes de eliminar empleado
SELECT 
    e.id,
    e.nombre,
    e.apellido,
    COUNT(p.id) as proyectos_asignados
FROM empleados e
LEFT JOIN proyectos p ON e.id = p.empleado_id  -- (tabla hipotética)
WHERE e.id = 1
GROUP BY e.id;

-- Solo eliminar si no hay dependencias o manejar las dependencias primero



-- =============================================
-- EJEMPLOS DE OPERACIONES SEGURAS PASO A PASO
-- =============================================

-- EJEMPLO COMPLETO: Descatalogar productos con bajo stock

-- PASO 1: Crear backup
CREATE TABLE productos_backup_descatalogado AS SELECT * FROM productos;

-- PASO 2: Verificar qué se va a actualizar
SELECT id, nombre, stock, descatalogado 
FROM productos 
WHERE stock < 20 AND descatalogado = FALSE;

-- PASO 3: Ejecutar con transacción
START TRANSACTION;

UPDATE productos 
SET descatalogado = TRUE 
WHERE stock < 20 AND descatalogado = FALSE;

-- PASO 4: Verificar resultado
SELECT COUNT(*) as productos_descatalogados 
FROM productos 
WHERE descatalogado = TRUE;

-- PASO 5: Si todo está bien, confirmar
COMMIT;

-- PASO 6: (Opcional) Eliminar backup si todo salió bien
-- DROP TABLE productos_backup_descatalogado;





-- =============================================
-- RESTAURACIÓN DESDE BACKUP
-- =============================================

-- Si algo salió mal, restaurar desde backup

-- Opción 1: Restaurar tabla completa
-- DROP TABLE empleados;
-- CREATE TABLE empleados AS SELECT * FROM empleados_backup;

-- Opción 2: Restaurar registros específicos
-- INSERT INTO empleados SELECT * FROM empleados_backup WHERE id IN (1,2,3);

-- Opción 3: Restaurar desde archivo SQL
-- mysql -u usuario -p ejemplo_precauciones < backup_ejemplo_precauciones.sql

-- =============================================
-- EJEMPLOS DE SENTENCIAS ERRÓNEAS Y EXPLICACIÓN
-- =============================================

-- Error 1: No usar transacciones en operaciones críticas
-- UPDATE empleados SET salario = salario * 2; -- Error: sin protección ante errores

-- Error 2: No hacer backup antes de operaciones masivas
-- DELETE FROM empleados WHERE departamento = 'IT'; -- Error: datos perdidos sin recuperación

-- Error 3: No verificar con SELECT antes de DELETE/UPDATE
-- DELETE FROM productos WHERE precio > 100; -- Error: no sabes cuántos registros afectarás

-- Error 4: Usar operaciones masivas sin WHERE
-- DELETE FROM empleados; -- Error: borra TODA la tabla
-- UPDATE productos SET precio = 0; -- Error: arruina TODOS los precios

-- Error 5: No usar LIMIT en tablas grandes
-- UPDATE productos SET precio = precio * 1.10; -- Error: puede bloquear tabla por mucho tiempo

-- =============================================
-- CHECKLIST DE SEGURIDAD PARA OPERACIONES MASIVAS
-- =============================================

-- ✓ 1. ¿Hice backup de los datos?
-- ✓ 2. ¿Probé la consulta con SELECT primero?
-- ✓ 3. ¿Estoy usando transacciones?
-- ✓ 4. ¿Mi WHERE es específico y correcto?
-- ✓ 5. ¿Verifiqué las dependencias/restricciones?
-- ✓ 6. ¿Consideré usar LIMIT para tablas grandes?
-- ✓ 7. ¿Tengo un plan de recuperación si algo sale mal?

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================