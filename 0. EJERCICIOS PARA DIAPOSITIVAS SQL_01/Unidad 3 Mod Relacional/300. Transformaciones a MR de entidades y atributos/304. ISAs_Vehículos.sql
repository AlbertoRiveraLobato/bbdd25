/*Ejercicio 304

Título: Implementación de una Jerarquía ISA para Vehículos en MySQL

Descripción:
Una empresa de gestión de flotas necesita modelar su sistema de vehículos. Existen dos tipos principales (pero no los únicos): coches y motos. 
Todos los vehículos comparten ciertos atributos comunes (matrícula, fecha de fabricación, marca y modelo), 
pero cada tipo tiene atributos específicos:

    Coche: número de puertas, capacidad del maletero

    Moto: cilindrada, tipo de carenado

Se pide implementar esta jerarquía ISA en MySQL utilizando los tres enfoques estudiados:

    Tabla única con discriminador

    Tabla para superclase + tablas para subclases

    Solo tablas para subclases

Para cada implementación, deberás:

    Crear las tablas con sus restricciones

    Insertar datos de ejemplo

    Comentar las ventajas e inconvenientes del enfoque.
*/

--1. Tabla Única (Single Table Inheritance)
-- Enfoque: Todos los atributos en una sola tabla con columna discriminadora
CREATE TABLE Vehiculo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    matricula VARCHAR(10) UNIQUE NOT NULL,
    fecha_fabricacion DATE NOT NULL,
    
    -- Atributos comunes
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    
    -- Atributos específicos (NULLables)
    num_puertas INT,           -- Solo para coches
    capacidad_maletero DECIMAL(5,2), -- Solo para coches
    cilindrada INT,            -- Solo para motos
    tipo_carenado VARCHAR(30), -- Solo para motos
    
    -- Columna discriminadora (ENUM para MySQL)
    tipo ENUM('COCHE', 'MOTO') NOT NULL,
    
    -- Restricciones específicas para cada tipo
    CONSTRAINT chk_coche CHECK (
        tipo != 'COCHE' OR (
            num_puertas IS NOT NULL AND 
            capacidad_maletero IS NOT NULL
        )
    ),
    CONSTRAINT chk_moto CHECK (
        tipo != 'MOTO' OR (
            cilindrada IS NOT NULL AND 
            tipo_carenado IS NOT NULL
        )
    )
);

-- Inserción de ejemplo:
INSERT INTO Vehiculo VALUES
(NULL, '1234ABC', '2020-05-15', 'Toyota', 'Corolla', 5, 480.50, NULL, NULL, 'COCHE'),
(NULL, '5678DEF', '2021-03-20', 'Honda', 'CBR600', NULL, NULL, 600, 'Deportivo', 'MOTO');




/*

Ventajas e Inconvenientes de cada Implementación
1. Tabla Única (Single Table Inheritance)
Ventajas:

✅ Simplicidad: Solo una tabla para gestionar

✅ Rendimiento en consultas: No necesita JOINs

✅ Facilidad para consultas polimórficas: Todas las entidades están en un solo lugar

✅ Bueno para herencias simples: Con pocos atributos específicos

Inconvenientes:

❌ Muchos campos NULL: Los atributos no aplicables a un subtipo quedan NULL

❌ Dificultad para restricciones específicas: Las CHECK constraints pueden volverse complejas

❌ Problemas de escalabilidad: Añadir nuevos subtipos requiere modificar la tabla

❌ Desperdicio de espacio: Por los campos no utilizados en cada subtipo
*/


--2. Superclase + Subclases (Class Table Inheritance)
-- Tabla superclase (atributos comunes)
CREATE TABLE Vehiculo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    matricula VARCHAR(10) UNIQUE NOT NULL,
    fecha_fabricacion DATE NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL
);

-- Tabla subclase Coche
CREATE TABLE Coche (
    id INT PRIMARY KEY,
    num_puertas INT NOT NULL,
    capacidad_maletero DECIMAL(5,2) NOT NULL,

    FOREIGN KEY (id) REFERENCES Vehiculo(id) ON DELETE CASCADE
);

-- Tabla subclase Moto
CREATE TABLE Moto (
    id INT PRIMARY KEY,
    cilindrada INT NOT NULL,
    tipo_carenado VARCHAR(30) NOT NULL,

    FOREIGN KEY (id) REFERENCES Vehiculo(id) ON DELETE CASCADE
);

-- Insertar vehículos genéricos (primero en la tabla padre)
INSERT INTO Vehiculo (matricula, fecha_fabricacion, marca, modelo) VALUES
('ABC1234', '2020-05-15', 'Toyota', 'Corolla'),
('DEF5678', '2021-03-20', 'Honda', 'Civic'),
('GHI9012', '2019-11-10', 'Yamaha', 'MT-07'),
('JKL3456', '2022-01-25', 'BMW', 'R 1250 GS');

-- Insertar coches (usando los ID generados en Vehiculo)
INSERT INTO Coche (id, num_puertas, capacidad_maletero) VALUES
(1, 5, 480.50),  -- Corolla
(2, 3, 350.00);  -- Civic

-- Insertar motos (usando los ID generados en Vehiculo)
INSERT INTO Moto (id, cilindrada, tipo_carenado) VALUES
(3, 689, 'Naked'),    -- Yamaha MT-07
(4, 1254, 'Adventure'); -- BMW R 1250 GS



/*
Ventajas e Inconvenientes de cada Implementación
2. Superclase + Subclases (Class Table Inheritance)
Ventajas:

✅ Modelo normalizado: Cada tabla contiene solo los datos que necesita

✅ Flexibilidad: Fácil añadir nuevos subtipos sin modificar estructura existente

✅ Restricciones específicas: Cada subtipo puede tener sus propias constraints

✅ Bueno para herencias complejas: Con muchos atributos específicos

Inconvenientes:

❌ Consultas más complejas: Requieren JOINs para consultas generales

❌ Rendimiento: Puede ser más lento para consultas que cruzan toda la jerarquía

❌ Overhead de joins: Necesidad de múltiples joins para recuperar objetos completos

❌ Gestión de claves: La clave primaria se propaga a las subtablas
*/


-- ------------------------------------------------------------------------------------
--3. Solo Subclases (Concrete Table Inheritance)
-- Tabla Coche (contiene atributos comunes + específicos)
CREATE TABLE Coche (
    id INT PRIMARY KEY AUTO_INCREMENT,
    matricula VARCHAR(10) UNIQUE NOT NULL,
    fecha_fabricacion DATE NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    num_puertas INT NOT NULL,
    capacidad_maletero DECIMAL(5,2) NOT NULL
);


-- Tabla Moto (contiene atributos comunes + específicos)
CREATE TABLE Moto (
    id INT PRIMARY KEY AUTO_INCREMENT,
    matricula VARCHAR(10) UNIQUE NOT NULL,
    fecha_fabricacion DATE NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    cilindrada INT NOT NULL,
    tipo_carenado VARCHAR(30) NOT NULL
);


-- Vista para consultar todos los vehículos (opcional)
CREATE VIEW Vista_Vehiculos AS
SELECT 
    id, matricula, fecha_fabricacion, marca, modelo, 
    'COCHE' AS tipo, 
    num_puertas AS caracteristica_1, 
    capacidad_maletero AS caracteristica_2
FROM Coche
UNION ALL
SELECT 
    id, matricula, fecha_fabricacion, marca, modelo, 
    'MOTO' AS tipo, 
    cilindrada AS caracteristica_1, 
    tipo_carenado AS caracteristica_2
FROM Moto;



INSERT INTO Coche (matricula, fecha_fabricacion, marca, modelo, num_puertas, capacidad_maletero) VALUES
('ABC1234', '2020-05-15', 'Toyota', 'Corolla', 5, 480.50),
('DEF5678', '2021-03-20', 'Honda', 'Civic', 3, 350.00);

INSERT INTO Moto (matricula, fecha_fabricacion, marca, modelo, cilindrada, tipo_carenado) VALUES
('GHI9012', '2019-11-10', 'Yamaha', 'MT-07', 689, 'Naked'),
('JKL3456', '2022-01-25', 'BMW', 'R 1250 GS', 1254, 'Adventure');


-- Consultar todos los vehículos a través de la vista
SELECT * FROM Vista_Vehiculos;

-- Consultar solo coches
SELECT * FROM Coche;

-- Consultar solo motos
SELECT * FROM Moto;





/*
3. Solo Subclases (Concrete Table Inheritance)
Ventajas:

✅ Rendimiento por tipo: Consultas por subtipo son muy eficientes

✅ Sin JOINs necesarios: Cada consulta trabaja con tablas independientes

✅ Bueno para herencias totales/exclusivas: Cuando no hay superclase independiente

✅ Restricciones claras: Cada tabla es autónoma

Inconvenientes:

❌ Duplicación de atributos comunes: Cambios requieren modificar múltiples tablas

❌ Dificultad para consultas generales: Necesidad de UNIONs complejas

❌ Problemas con claves únicas: Las matrículas deben ser únicas entre todas las tablas

❌ Mantenimiento complejo: Modificar atributos comunes afecta a todas las tablas

Recomendaciones de Uso:
Tabla única: Ideal para jerarquías pequeñas con pocos atributos específicos y cuando el rendimiento en consultas generales es crítico.

Superclase+Subclases: Recomendado para modelos complejos donde la normalización es importante y se esperan frecuentes extensiones del modelo.

Solo subclases: Adecuado cuando los subtipos son muy diferentes entre sí y las consultas casi siempre son por tipo específico.

*/




/*
Resumen de las transformaciones:
Para herencia Total:

    Implementación 2: Añadir triggers que verifiquen que cada vehículo tiene exactamente un subtipo

    Implementación 3: Ya es total por diseño (no necesita cambios)

Para herencia Total y Exclusiva:

    Implementación 2: Añadir verificaciones adicionales para asegurar que ningún vehículo pertenece a múltiples subtipos

    Implementación 3: Añadir restricciones de unicidad entre tablas para campos clave como matrícula

Estas modificaciones garantizan que:

    Todo vehículo debe ser coche o moto (total)

    Ningún vehículo puede ser coche y moto simultáneamente (exclusiva)
*/