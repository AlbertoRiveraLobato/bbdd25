-- Borramos la base de datos si ya existe
DROP DATABASE IF EXISTS Triggers303;

-- Creamos la base de datos
CREATE DATABASE Triggers303;

-- Seleccionamos esta base de datos para trabajar
USE Triggers303;

-- Creamos la tabla Vehiculos con todas las restricciones necesarias
CREATE TABLE Vehiculos (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,  -- Clave primaria autoincremental
    matricula VARCHAR(10) UNIQUE NOT NULL,       -- Matrícula única y obligatoria
    tipo ENUM('Turismo', 'Camion', 'Motocicleta', 'Autobus') NOT NULL,  -- Solo se permiten estos tipos
    capacidad_pasajeros INT NOT NULL,            -- Capacidad obligatoria
    peso_maximo_kg DECIMAL(10,2) NOT NULL,       -- Peso máximo obligatorio
    fecha_fabricacion DATE NOT NULL,             -- Fecha obligatoria, se validará con trigger

    -- Restricción 1: Para los autobuses, deben tener al menos 20 plazas y pesar al menos 5000 kg
    -- Si no es un autobús, la condición no se evalúa
    CONSTRAINT vehiculo_chk_tipo_pesado CHECK (
        tipo != 'Autobus' OR 
        (capacidad_pasajeros >= 20 AND peso_maximo_kg >= 5000)
    ),

    -- Restricción 2: Para motocicletas, máximo 2 pasajeros y peso máximo 300 kg
    -- Si no es una motocicleta, la condición no se evalúa
    CONSTRAINT vehiculo_chk_motocicleta CHECK (
        tipo != 'Motocicleta' OR 
        (capacidad_pasajeros <= 2 AND peso_maximo_kg <= 300)
    )
);

-- Eliminamos el trigger anterior si existía (por si se ejecuta varias veces)
DROP TRIGGER IF EXISTS comprobar_fecha_fab_no_fut_insert;
DROP TRIGGER IF EXISTS comprobar_fecha_fab_no_fut_update;

-- Creamos un trigger que se ejecuta antes de insertar un nuevo vehículo
-- Su propósito es evitar que se introduzca una fecha de fabricación futura
DELIMITER //

CREATE TRIGGER comprobar_fecha_fab_no_fut_insert
BEFORE INSERT ON Vehiculos
FOR EACH ROW
BEGIN
    IF (NEW.fecha_fabricacion > CURDATE()) THEN
        -- Si la fecha es posterior a la actual, lanzamos un error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TRIGGER ANTES DE LA INSERCIÓN: La fecha de fabricación no puede ser futura';
    END IF;
END;
//

-- Trigger similar para evitar actualizaciones con fechas futuras
CREATE TRIGGER comprobar_fecha_fab_no_fut_update
BEFORE UPDATE ON Vehiculos
FOR EACH ROW
BEGIN
    IF (NEW.fecha_fabricacion > CURDATE()) THEN
        -- También aquí se impide modificar la fecha a una del futuro
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TRIGGER ANTES DE LA ACTUALIZACIÓN: La fecha de fabricación no puede ser futura';
    END IF;
END;
//
DELIMITER ;

-- Ahora realizamos algunas inserciones de prueba:

-- ✅ Inserción válida: Autobús con suficientes plazas y peso
INSERT INTO Vehiculos VALUES (
    NULL, 'AB-123-CD', 'Autobus', 45, 7500.00, '2020-05-10'
);

-- ❌ Inserción inválida: Autobús con capacidad insuficiente
-- Violará la restricción CHECK de autobuses
INSERT INTO Vehiculos VALUES (
    NULL, 'AB-456-EF', 'Autobus', 15, 7500.00, '2021-03-15'
);

-- ✅ Inserción válida: Motocicleta con 1 plaza y poco peso
INSERT INTO Vehiculos VALUES (
    NULL, 'M-7890-FG', 'Motocicleta', 1, 150.00, '2022-01-20'
);

-- ❌ Inserción inválida: Motocicleta con peso excesivo
-- Violará la restricción CHECK de motocicletas
INSERT INTO Vehiculos VALUES (
    NULL, 'M-9999-ZZ', 'Motocicleta', 2, 350.00, '2022-02-05'
);

-- ❌ Inserción inválida: Turismo con fecha de fabricación en el futuro
-- Fallará el trigger de inserción
INSERT INTO Vehiculos VALUES (
    NULL, 'XX-888-YY', 'Turismo', 5, 1500.00, '2026-01-01'
);

-- ✅ Inserción válida: Turismo con fecha pasada
INSERT INTO Vehiculos VALUES (
    NULL, 'XX-123-YY', 'Turismo', 5, 1500.00, '2020-01-01'
);

-- ❌ Actualización inválida: intentar poner una fecha futura
-- Este UPDATE será bloqueado por el trigger de actualización
UPDATE Vehiculos 
SET fecha_fabricacion = '2030-01-01' 
WHERE matricula = 'XX-123-YY';


