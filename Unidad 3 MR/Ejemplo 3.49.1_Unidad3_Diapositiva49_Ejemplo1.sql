-- Ejemplo3_49_1 
-- Entidad débil en identificación.
-- Primero creamos la entidad fuerte (E1) de la que depende la entidad débil (D1)

DROP DATABASE IF EXISTS ejemplo3_49_1;
CREATE DATABASE IF NOT EXISTS ejemplo3_49_1;
USE ejemplo3_49_1;

CREATE TABLE Nombre_E1 (
    id_e1 INT PRIMARY KEY,                   -- Clave primaria de la entidad fuerte
    atributo_e1_1 VARCHAR(50) NOT NULL,      -- Atributo descriptivo 1
    atributo_e1_2 DATE,                      -- Atributo descriptivo 2
    alternativo_e1 VARCHAR(50) UNIQUE        -- Clave alternativa (no es obligatoria)
);

-- Luego creamos la entidad débil (D1) que depende identificatoriamente de E1
CREATE TABLE Nombre_D1 (
    id_d1 INT,                               -- Parte de la clave primaria compuesta
    id_e1_FK INT,                            -- Parte de la clave primaria y FK a E1
    atributo_d1_1 VARCHAR(100),               -- Atributo descriptivo de D1
    
    -- Clave primaria compuesta (id_d1 + id_e1_FK)
    PRIMARY KEY (id_d1, id_e1_FK),
    
    -- Clave foránea que referencia a la entidad fuerte
    FOREIGN KEY (id_e1_FK) REFERENCES Nombre_E1(id_e1)
    ON DELETE CASCADE  -- Si se elimina E1, se eliminan sus D1 relacionadas
    ON UPDATE CASCADE  -- Si se actualiza id_e1, se actualiza en D1
);

-- COMENTARIOS ADICIONALES:
-- 1. La entidad débil NO puede existir sin la entidad fuerte
-- 2. La clave primaria de la entidad débil incluye la FK a la entidad fuerte
-- 3. Esto modela una relación de dependencia de identificación (1:N típicamente)




-- Insertamos datos en la entidad fuerte
INSERT INTO Nombre_E1 VALUES 
(1, 'Ejemplo 1', '2023-01-01', 'ALT001'),
(2, 'Ejemplo 2', '2023-02-15', 'ALT002');

-- Insertamos datos en la entidad débil (notar que necesitan referencia a E1)
INSERT INTO Nombre_D1 VALUES
(101, 1, 'Dependiente A'),  -- Pertenece a E1 con id_e1=1
(102, 1, 'Dependiente B'),  -- Pertenece a E1 con id_e1=1
(201, 2, 'Dependiente C');  -- Pertenece a E1 con id_e1=2

-- Esto daría error porque no existe id_e1=3 en la tabla E1:
INSERT INTO Nombre_D1 VALUES (301, 3, 'Dependiente Inválido');

-- Actualizar PK en clave primaria, actualiza la FK correspondiente
UPDATE Nombre_E1 SET id_e1 = 11 WHERE id_e1 = 1;
SELECT * FROM Nombre_E1;
SELECT * FROM Nombre_D1;


DROP DATABASE IF EXISTS ejemplo3_49_1;