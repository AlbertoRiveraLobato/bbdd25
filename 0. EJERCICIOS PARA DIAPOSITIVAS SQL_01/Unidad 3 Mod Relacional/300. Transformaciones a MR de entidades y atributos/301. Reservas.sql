/*
VAMOS a modelar un sistema de reservas para un hotel con las siguientes reglas:
1.	Cada habitación tiene un número único, tipo y precio por noche.
2.	Los clientes nos proporcionarán su nombre y DNI (pero no usaremos éste como identificador de cliente).
3.	Una habitación no puede estar reservada dos veces para las mismas fechas.
4.	El precio de la reserva debe ser positivo.
5.	No se permiten reservas con fecha de salida anterior a la fecha de entrada.
6.	Las habitaciones de tipo "Suite" deben tener un precio mínimo de 100€ por noche.
7.  Un cliente puede realizar más de una reserva.
8.  Una habitación puede ser reservada por varios clientes (en fechas diferentes).

------

Lo vamos a resolver de dos formas: 
	CASO 1: resolviendo la restricción en la propia tabla.
	CASO 2: implementando un trigger.
*/

-- Borra la bbdd si ya existe
DROP DATABASE IF EXISTS triggers301;

-- Crear y poner por defecto la bbdd
CREATE DATABASE triggers301;
USE triggers301;

-- Creación de tablas
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dni VARCHAR(9) UNIQUE NOT NULL
);

-- CASO 1: resolviendo la restricción en la propia tabla.
CREATE TABLE Habitaciones (
    num_habitacion INT PRIMARY KEY,
    tipo ENUM('Individual', 'Doble', 'Suite') NOT NULL,
    precio_noche DECIMAL(10,2) NOT NULL CHECK (precio_noche > 0), -- comenta esta coma  para probar el "caso 2"
    CONSTRAINT habaitacion_chk_2 CHECK  (tipo != 'Suite' OR precio_noche >= 100) -- comenta esta línea para probar el "caso 2"
);

-- Prueba de error en la restricción de la tabla Habitaciones.
INSERT INTO Habitaciones VALUES 
(102, 'Suite', 49.00);

/*
-- error si definimos el check con un AND (ya que no está reflejando la semántica real del enunciado)
ALTER TABLE Habitaciones DROP CONSTRAINT habaitacion_chk_2;
ALTER TABLE Habitaciones ADD CONSTRAINT habaitacion_chk_2
	CHECK (tipo = 'Suite' AND precio_noche >= 100);

INSERT INTO Habitaciones VALUES 
(102, 'Individual', 49.00);

drop trigger auxTrigger;
*/

-- CASO 2: Usar un trigger para definir la restricción de la tabla Habitaciones
-- Creamos el trigger BEFORE INSERT
-- Cambio del delimitador para permitir el uso de punto y coma dentro del trigger
DELIMITER //  

/*
 * Trigger: valida_precio_suite_insert
 * Descripción: Trigger que valida el precio mínimo para habitaciones tipo Suite
 * Tabla afectada: Habitaciones
 * Evento: BEFORE INSERT (antes de insertar un nuevo registro)
 * Objetivo: Asegurar que las suites tengan un precio mínimo de 100€ por noche
 */
CREATE TRIGGER valida_precio_suite_insert
BEFORE INSERT ON Habitaciones  -- Se ejecuta antes de cada operación INSERT
FOR EACH ROW  -- Para cada fila que se intenta insertar
BEGIN
    /*
     * Condición de validación:
     * - NEW hace referencia al nuevo registro que se está insertando
     * - NEW.tipo accede al campo 'tipo' del nuevo registro
     * - NEW.precio_noche accede al campo 'precio_noche' del nuevo registro
     * La condición verifica si es una Suite con precio inferior al mínimo
     */
    IF NEW.tipo = 'Suite' AND NEW.precio_noche < 100 THEN
        -- Si la condición se cumple, genera un error personalizado
        SIGNAL SQLSTATE '45000'  -- Código para errores personalizados
        SET MESSAGE_TEXT = 'Las suites deben tener un precio mínimo de 100€ por noche';
    END IF;
END//

-- Restauración del delimitador original
DELIMITER ;  


CREATE TABLE Reservas (
    idReserva INT AUTO_INCREMENT PRIMARY KEY,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    precio_total DECIMAL(10,2) NOT NULL,
    id_cliente INT NOT NULL,
    num_habitacion INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (num_habitacion) REFERENCES Habitaciones(num_habitacion),
    CHECK (fecha_salida > fecha_entrada),
    CHECK (precio_total > 0)
);

-- Inserción de datos
INSERT INTO Clientes (nombre, dni) VALUES 
('Juan Pérez', '12345678A'),
('María Gómez', '87654321B');

INSERT INTO Habitaciones VALUES 
(101, 'Individual', 50.00),
(201, 'Doble', 80.00),
(301, 'Suite', 150.00);

INSERT INTO Reservas (fecha_entrada, fecha_salida, precio_total, id_cliente, num_habitacion) VALUES
('2023-06-01', '2023-06-05', 200.00, 1, 101),
('2023-06-10', '2023-06-15', 400.00, 2, 201);

-- Probando las Restricciones...
INSERT INTO Habitaciones VALUES (102, 'Individual', -50.00);
-- Error: CHECK constraint failed: precio_noche > 0

INSERT INTO Habitaciones VALUES (303, 'Suite', 90.00);
-- Error: CHECK constraint failed: tipo != 'Suite' OR precio_noche >= 100

INSERT INTO Reservas VALUES (3, '2023-06-20', '2023-06-15', 300.00, 1, 201);
-- Error: CHECK constraint failed: fecha_salida > fecha_entrada

INSERT INTO Clientes (nombre, dni) VALUES ('Otro Cliente', '12345678A');
-- Error: Duplicate entry '12345678A' for key 'dni'

INSERT INTO Reservas VALUES (4, '2023-06-01', '2023-06-05', 200.00, 1, 999);
-- Error: Cannot add or update a child row: a foreign key constraint fails

-- Trigger para asegurar que una habitación se reserva en una fecha en la que está disponible.
DELIMITER //  -- Cambiamos el delimitador para poder usar punto y coma dentro del trigger

/*
 * Trigger: check_solapamiento_reservas
 * Objetivo: Verificar que no existan reservas solapadas para la misma habitación
 *           antes de insertar una nueva reserva
 * Tipo: BEFORE INSERT (se ejecuta antes de insertar un registro)
 */
CREATE TRIGGER check_solapamiento_reservas
BEFORE INSERT ON Reservas  -- Se activa antes de cada inserción en la tabla Reservas
FOR EACH ROW  -- Se ejecuta para cada fila que se intente insertar
BEGIN
    -- Variable para almacenar el conteo de reservas solapadas
    DECLARE solapadas INT;
    
    /*
     * Consulta que cuenta reservas existentes para la misma habitación
     * donde las fechas se solapan con la nueva reserva (NEW)
     * 
     * La condición NOT (A OR B) es equivalente a:
     *   - La nueva fecha de salida NO es anterior a una fecha de entrada existente
     *   - Y la nueva fecha de entrada NO es posterior a una fecha de salida existente
     * Es decir, detecta cuando los rangos de fechas se superponen
     */
    SELECT COUNT(*) INTO solapadas
    FROM Reservas
    WHERE num_habitacion = NEW.num_habitacion  -- Misma habitación
    AND NOT (NEW.fecha_salida <= fecha_entrada OR NEW.fecha_entrada >= fecha_salida);
    
    -- Si encontramos reservas solapadas (count > 0)...
    IF solapadas > 0 THEN
        -- Generamos un error personalizado para evitar la inserción
        SIGNAL SQLSTATE '45000'  -- Código de estado para excepciones definidas por el usuario
        SET MESSAGE_TEXT = 'La habitación ya está reservada para esas fechas';
    END IF;
END//

DELIMITER ;  -- Restauramos el delimitador original

-- Prueba del trigger
INSERT INTO Reservas VALUES (5, '2023-06-03', '2023-06-07', 300.00, 2, 101);
-- Error: La habitación ya está reservada para esas fechas (solapamiento con reserva existente)