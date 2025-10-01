-- =============================================
-- GUION INTEGRADO
-- =============================================
-- El alumno debe escribir y ejecutar cada sentencia en db-fiddle.com (MySQL), observando los resultados y posibles errores.


-- 0) Crea las siguientes tablas, necesarias para los ejercicios de productos y empleados.

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    departamento VARCHAR(50),
    salario DECIMAL(10,2),
    fecha_contratacion DATE
);

-- Tabla adicional para practicar ENUM, valores por defecto y NULL
CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    genero ENUM('Masculino', 'Femenino', 'No especificado') DEFAULT 'No especificado',
    telefono VARCHAR(15) NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50) DEFAULT 'No especificada',
    estado ENUM('Activo', 'Inactivo', 'Suspendido') DEFAULT 'Activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notas TEXT NULL
);

-- Query de comprobación:
SHOW TABLES;
DESCRIBE productos;
DESCRIBE empleados;
DESCRIBE clientes;

-- ----------------------------------------------------------------------------------------
-- Enunciados de problemas propuestos:
-- ----------------------------------------------------------------------------------------

-- 1) Inserta un nuevo producto en la tabla productos con nombre 'Ratón' y precio 12.50.
-- Query de comprobación:
SELECT * FROM productos;

-- Solución:
INSERT INTO productos (nombre, precio) VALUES ('Ratón', 12.50);

-- 2) Inserta dos empleados en la tabla empleados: ('Juan', 'Pérez', 'juan@empresa.com', 'IT', 45000.00, '2023-01-15') y ('Ana', 'López', 'ana@empresa.com', 'Ventas', 39000.00, '2023-02-01').
-- Query de comprobación:
SELECT * FROM empleados;

-- Solución:
INSERT INTO empleados (nombre, apellido, email, departamento, salario, fecha_contratacion) VALUES
('Juan', 'Pérez', 'juan@empresa.com', 'IT', 45000.00, '2023-01-15'),
('Ana', 'López', 'ana@empresa.com', 'Ventas', 39000.00, '2023-02-01');

-- 3) Actualiza el salario de 'Juan Pérez' a 47000.00.
-- Query de comprobación:
SELECT * FROM empleados WHERE nombre = 'Juan' AND apellido = 'Pérez';

-- Solución:
UPDATE empleados SET salario = 47000.00 WHERE nombre = 'Juan' AND apellido = 'Pérez';

-- 4) Borra el producto cuyo nombre sea 'Ratón'.
-- Query de comprobación:
SELECT * FROM productos;

-- Solución:
DELETE FROM productos WHERE nombre = 'Ratón';

-- 5) Inserta un nuevo producto con nombre 'Monitor' y precio 120.00, y luego actualiza su precio a 110.00.
-- Query de comprobación:
SELECT * FROM productos WHERE nombre = 'Monitor';

-- Solución:
INSERT INTO productos (nombre, precio) VALUES ('Monitor', 120.00);
UPDATE productos SET precio = 110.00 WHERE nombre = 'Monitor';

-- 6) Borra todos los empleados del departamento 'Ventas'.
-- Query de comprobación:
SELECT * FROM empleados WHERE departamento = 'Ventas';

-- Solución:
DELETE FROM empleados WHERE departamento = 'Ventas';

-- 7) Inserta varios productos de una sola vez: ('Teclado', 25.00), ('Altavoz', 35.00), ('Webcam', 50.00).
-- Query de comprobación:
SELECT * FROM productos;

-- Solución:
INSERT INTO productos (nombre, precio) VALUES
('Teclado', 25.00),
('Altavoz', 35.00),
('Webcam', 50.00);

-- 8) Actualiza el departamento de todos los empleados cuyo salario sea mayor de 40000 a 'Dirección'.
-- Query de comprobación:
SELECT * FROM empleados WHERE salario > 40000;

-- Solución:
UPDATE empleados SET departamento = 'Dirección' WHERE salario > 40000;

-- 9) Borra todos los productos cuyo precio sea menor de 30.00.
-- Query de comprobación:
SELECT * FROM productos;

-- Solución:
DELETE FROM productos WHERE precio < 30.00;

-- 10) Inserta un empleado con datos nulos en el campo email y departamento.
-- Query de comprobación:
SELECT * FROM empleados WHERE email IS NULL OR departamento IS NULL;

-- Solución:
INSERT INTO empleados (nombre, apellido, email, departamento, salario, fecha_contratacion) VALUES ('Luis', 'Martín', NULL, NULL, 32000.00, '2023-03-10');

-- 11) Actualiza el email de 'Luis Martín' a 'luis@empresa.com'.
-- Query de comprobación:
SELECT * FROM empleados WHERE nombre = 'Luis' AND apellido = 'Martín';

-- Solución:
UPDATE empleados SET email = 'luis@empresa.com' WHERE nombre = 'Luis' AND apellido = 'Martín';

-- 12) Borra todos los empleados.
-- Query de comprobación:
SELECT * FROM empleados;

-- Solución:
DELETE FROM empleados;

-- 13) Borra todos los productos.
-- Query de comprobación:
SELECT * FROM productos;

-- Solución:
DELETE FROM productos;

-- 14) Inserta un producto con nombre 'Tablet' y precio 200.00, y un empleado con nombre 'Sara', apellido 'Ruiz', email 'sara@empresa.com', departamento 'IT', salario 48000.00 y fecha_contratacion '2023-04-01'.
-- Query de comprobación:
SELECT * FROM productos;
SELECT * FROM empleados;

-- Solución:
INSERT INTO productos (nombre, precio) VALUES ('Tablet', 200.00);
INSERT INTO empleados (nombre, apellido, email, departamento, salario, fecha_contratacion) VALUES ('Sara', 'Ruiz', 'sara@empresa.com', 'IT', 48000.00, '2023-04-01');

-- 15) Actualiza el salario de todos los empleados a 50000.00.
-- Query de comprobación:
SELECT * FROM empleados;

-- Solución:
UPDATE empleados SET salario = 50000.00;

-- 16) Borra todos los empleados contratados antes de '2023-02-01'.
-- Query de comprobación:
SELECT * FROM empleados WHERE fecha_contratacion < '2023-02-01';

-- Solución:
DELETE FROM empleados WHERE fecha_contratacion < '2023-02-01';

-- 17) Inserta un producto con nombre 'Impresora' y precio 90.00, y luego actualiza su nombre a 'Impresora Láser'.
-- Query de comprobación:
SELECT * FROM productos WHERE nombre LIKE 'Impresora%';

-- Solución:
INSERT INTO productos (nombre, precio) VALUES ('Impresora', 90.00);
UPDATE productos SET nombre = 'Impresora Láser' WHERE nombre = 'Impresora';

-- 18) Borra todos los productos cuyo nombre contenga la palabra 'Teclado'.
-- Query de comprobación:
SELECT * FROM productos WHERE nombre LIKE '%Teclado%';

-- Solución:
DELETE FROM productos WHERE nombre LIKE '%Teclado%';

-- 19) Inserta un empleado con todos los campos excepto el email.
-- Query de comprobación:
SELECT * FROM empleados WHERE email IS NULL;

-- Solución:
INSERT INTO empleados (nombre, apellido, departamento, salario, fecha_contratacion) VALUES ('Mario', 'Santos', 'IT', 42000.00, '2023-05-01');

-- 20) Borra todos los productos y empleados para dejar las tablas vacías.
-- Query de comprobación:
SELECT * FROM productos;
SELECT * FROM empleados;

-- Solución:
DELETE FROM productos;
DELETE FROM empleados;

-- ----------------------------------------------------------------------------------------
-- EJERCICIOS ESPECÍFICOS PARA COLUMNAS ENUM, VALORES POR DEFECTO Y NULL
-- ----------------------------------------------------------------------------------------

-- 21) Inserta un cliente con nombre 'Carlos', apellido 'Ruiz', email 'carlos@email.com'. Los demás campos deben usar valores por defecto.
-- Query de comprobación:
SELECT * FROM clientes WHERE nombre = 'Carlos';

-- Solución:
INSERT INTO clientes (nombre, apellido, email) VALUES ('Carlos', 'Ruiz', 'carlos@email.com');

-- 22) Inserta un cliente con nombre 'María', apellido 'García', género 'Femenino', email 'maria@email.com' y ciudad 'Madrid'.
-- Query de comprobación:
SELECT * FROM clientes WHERE nombre = 'María';

-- Solución:
INSERT INTO clientes (nombre, apellido, genero, email, ciudad) VALUES ('María', 'García', 'Femenino', 'maria@email.com', 'Madrid');

-- 23) Inserta un cliente con nombre 'Juan', apellido 'López', género 'Masculino', teléfono '123456789', email 'juan@email.com', ciudad 'Barcelona' y estado 'Inactivo'.
-- Query de comprobación:
SELECT * FROM clientes WHERE nombre = 'Juan';

-- Solución:
INSERT INTO clientes (nombre, apellido, genero, telefono, email, ciudad, estado) VALUES ('Juan', 'López', 'Masculino', '123456789', 'juan@email.com', 'Barcelona', 'Inactivo');

-- 24) Inserta un cliente con nombre 'Ana', apellido 'Martín', dejando el teléfono como NULL y el género usando el valor por defecto.
-- Query de comprobación:
SELECT * FROM clientes WHERE nombre = 'Ana';

-- Solución:
INSERT INTO clientes (nombre, apellido, telefono, email) VALUES ('Ana', 'Martín', NULL, 'ana@email.com');

-- 25) Inserta un cliente especificando explícitamente el valor DEFAULT para el género y la ciudad.
-- Query de comprobación:
SELECT * FROM clientes WHERE nombre = 'Luis';

-- Solución:
INSERT INTO clientes (nombre, apellido, genero, email, ciudad) VALUES ('Luis', 'Fernández', DEFAULT, 'luis@email.com', DEFAULT);

-- 26) Inserta un cliente con notas 'Cliente VIP' y estado 'Activo'.
-- Query de comprobación:
SELECT * FROM clientes WHERE notas = 'Cliente VIP';

-- Solución:
INSERT INTO clientes (nombre, apellido, email, estado, notas) VALUES ('Carmen', 'Vega', 'carmen@email.com', 'Activo', 'Cliente VIP');

-- 27) Actualiza el estado de todos los clientes de Madrid a 'Suspendido'.
-- Query de comprobación:
SELECT * FROM clientes WHERE ciudad = 'Madrid';

-- Solución:
UPDATE clientes SET estado = 'Suspendido' WHERE ciudad = 'Madrid';

-- 28) Inserta un cliente sin especificar email (debe permitir NULL según la estructura de la tabla).
-- Query de comprobación:
SELECT * FROM clientes WHERE email IS NULL;

-- Solución:
INSERT INTO clientes (nombre, apellido, genero, telefono) VALUES ('Pedro', 'Santos', 'Masculino', '987654321');

-- 29) Actualiza el género de todos los clientes que no tienen teléfono a 'No especificado'.
-- Query de comprobación:
SELECT * FROM clientes WHERE telefono IS NULL;

-- Solución:
UPDATE clientes SET genero = 'No especificado' WHERE telefono IS NULL;

-- 30) Inserta varios clientes de una vez con diferentes combinaciones de valores por defecto y NULL.
-- Query de comprobación:
SELECT * FROM clientes ORDER BY id DESC LIMIT 3;

-- Solución:
INSERT INTO clientes (nombre, apellido, genero, telefono, email, ciudad, estado, notas) VALUES
('Sofia', 'Morales', 'Femenino', NULL, 'sofia@email.com', DEFAULT, 'Activo', 'Contactar por email'),
('Miguel', 'Herrera', DEFAULT, '555123456', 'miguel@email.com', 'Valencia', DEFAULT, NULL),
('Elena', 'Castro', 'Femenino', '666789012', NULL, 'Sevilla', 'Inactivo', 'Sin email registrado');

-- 31) Actualiza las notas de todos los clientes activos que no tienen teléfono.
-- Query de comprobación:
SELECT * FROM clientes WHERE estado = 'Activo' AND telefono IS NULL;

-- Solución:
UPDATE clientes SET notas = 'Pendiente teléfono' WHERE estado = 'Activo' AND telefono IS NULL;

-- 32) Borra todos los clientes que tienen estado 'Suspendido' y no tienen notas.
-- Query de comprobación:
SELECT * FROM clientes WHERE estado = 'Suspendido' AND notas IS NULL;

-- Solución:
DELETE FROM clientes WHERE estado = 'Suspendido' AND notas IS NULL;

-- 33) Intenta insertar un cliente con un género no válido para observar el error.
-- Query de comprobación:
-- Esto debería dar error al intentar ejecutarlo:

-- Solución (comentada porque da error):
-- INSERT INTO clientes (nombre, apellido, genero, email) VALUES ('Error', 'Test', 'Otro', 'error@email.com');
-- Error esperado: Data truncated for column 'genero' at row 1

-- 34) Inserta un cliente usando solo los campos obligatorios (NOT NULL).
-- Query de comprobación:
SELECT * FROM clientes WHERE nombre = 'Mínimo';

-- Solución:
INSERT INTO clientes (nombre, apellido) VALUES ('Mínimo', 'Campos');

-- 35) Actualiza todos los clientes sin ciudad especificada para ponerles 'Madrid' como ciudad.
-- Query de comprobación:
SELECT * FROM clientes WHERE ciudad = 'No especificada';

-- Solución:
UPDATE clientes SET ciudad = 'Madrid' WHERE ciudad = 'No especificada';

-- 36) Borra todos los clientes para dejar la tabla vacía.
-- Query de comprobación:
SELECT * FROM clientes;

-- Solución:
DELETE FROM clientes;

-- =============================================
-- FIN DE GUION INTEGRADO
-- =============================================
