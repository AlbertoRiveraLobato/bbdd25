
-- La notación utilizada es: "Ejemplo nºUnidad.nºDiapositiva.nºEjemplo"
-- Por ejemplo: 3.25.1 =  "unidad 3, diapositiva 25, ejemplo 1."

-- Ejemplo 3.25.1
/*Crear una tabla sencilla con dos atributos, ninguno PK, y uno UNIQUE, y darle dos filas con valores NULL: ver que es posible.
-- -------------
*/

create table tabla1 (
	atr1 int unique,
    atr2 int
);
use ejercicio10;

-- Inserción sin problemas, ya que UNIQUE no impide que existan varios NULL en su columna.
insert into tabla1 (atr1, atr2) values
	(null, 1),
    (null, 2),
    (3, 3),
    (4, 4);


-- -----------------------
-- Ejemplo 3.26.1
drop database if exists primaria01;
create database primaria01;
use primaria01;

CREATE TABLE Estudiantes_Cursos (
    estudiante_id INT,
    curso_id INT,
    fecha_inscripcion DATE,
    calificacion DECIMAL(3,1),
    PRIMARY KEY (estudiante_id, curso_id)
);

-- Datos válidos (combinaciones únicas de estudiante_id y curso_id)
INSERT INTO Estudiantes_Cursos VALUES (1, 101, '2023-09-01', 8.5);
INSERT INTO Estudiantes_Cursos VALUES (1, 102, '2023-09-01', 7.0);
INSERT INTO Estudiantes_Cursos VALUES (2, 101, '2023-09-02', 9.0);
INSERT INTO Estudiantes_Cursos VALUES (3, 103, '2023-09-03', NULL);


-- Error: Violación de clave primaria (ya existe estudiante 1 en curso 101)
INSERT INTO Estudiantes_Cursos VALUES (1, 101, '2023-09-05', 6.5);

-- Error: Valor NULL en columna de clave primaria (curso_id no puede ser NULL)
INSERT INTO Estudiantes_Cursos VALUES (4, NULL, '2023-09-04', NULL);

-- Error: Valor NULL en columna de clave primaria (estudiante_id no puede ser NULL)
INSERT INTO Estudiantes_Cursos VALUES (NULL, 104, '2023-09-04', 8.0);

-- Error: Ambos valores NULL en clave primaria
INSERT INTO Estudiantes_Cursos VALUES (NULL, NULL, '2023-09-04', 7.5);


-- --------------------------
-- Ejemplo 3.30.1

-- Código completo para el ejemplo Trigger de la diapositiva:

-- DROP DATABASE PRUEBAS01;
CREATE DATABASE PRUEBAS01;
USE PRUEBAS01;

-- Creación de la tabla SOLICITA
CREATE TABLE SOLICITA (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT,
    id_curso INT,
    fecha_solicitud DATE
);

-- Creación de la tabla MENSAJES para almacenar los mensajes del trigger
CREATE TABLE MENSAJES (
    id_mensaje INT AUTO_INCREMENT PRIMARY KEY,
    mensaje VARCHAR(100),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creación del trigger para MySQL
DELIMITER //
CREATE TRIGGER Comprobar_Matriculados
AFTER INSERT ON SOLICITA
FOR EACH ROW
BEGIN
    DECLARE NUM_SOLICITUDES INT;
    
    SELECT COUNT(*) INTO NUM_SOLICITUDES FROM SOLICITA;
    
    IF NUM_SOLICITUDES > 5 THEN
        INSERT INTO MENSAJES (mensaje) 
        VALUES ('Hay más de 5 solicitudes');
    END IF;
END//
DELIMITER ;


-- Inserción de datos de prueba (menos de 50 solicitudes)
INSERT INTO SOLICITA (id_alumno, id_curso, fecha_solicitud) VALUES 
(1001, 10, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(1002, 11, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(1030, 14, DATE_SUB(CURDATE(), INTERVAL 30 DAY));

-- Verificar que no hay mensaje aún (porque solo hay 30 solicitudes)
SELECT * FROM MENSAJES;

-- Insertar más datos para superar el límite de 50
INSERT INTO SOLICITA (id_alumno, id_curso, fecha_solicitud) VALUES 
(1031, 10, DATE_SUB(CURDATE(), INTERVAL 31 DAY)),
(1032, 11, DATE_SUB(CURDATE(), INTERVAL 32 DAY)),
(1060, 14, DATE_SUB(CURDATE(), INTERVAL 60 DAY));

-- Verificar que ahora sí se ha generado el mensaje
SELECT * FROM MENSAJES;

-- Consulta para ver todas las solicitudes
SELECT COUNT(*) AS total_solicitudes FROM SOLICITA;

INSERT INTO SOLICITA (id_alumno, id_curso, fecha_solicitud) VALUES 
(1036, 12, DATE_SUB(CURDATE(), INTERVAL 31 DAY)),
(1037, 11, DATE_SUB(CURDATE(), INTERVAL 31 DAY));

-- Verificar que ahora tb se ha generado el mensaje
SELECT * FROM MENSAJES;

-- -------------------------
-- Ejemplo 3.31.1
-- Código completo para el ejemplo Trigger de la diapositiva::

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS gestion_pedidos;
USE gestion_pedidos;

-- Crear tabla Clientes
CREATE TABLE Clientes (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    NumeroPedidos INT DEFAULT 0,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla Pedidos
CREATE TABLE Pedidos (
    PedidoID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    FechaPedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Total DECIMAL(10,2),
    Estado VARCHAR(20) DEFAULT 'Pendiente',
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Insertar datos de prueba en Clientes
INSERT INTO Clientes (Nombre, Email) VALUES 
('Juan Pérez', 'juan@example.com'),
('María García', 'maria@example.com'),
('Carlos López', 'carlos@example.com');

-- Crear el trigger para actualizar el contador de pedidos
DELIMITER //
CREATE TRIGGER despues_insertar_pedido
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    UPDATE Clientes
    SET NumeroPedidos = NumeroPedidos + 1
    WHERE ClienteID = NEW.ClienteID;
END//
DELIMITER ;

-- Verificar los resultados
SELECT c.ClienteID, c.Nombre, c.NumeroPedidos, 
       COUNT(p.PedidoID) as PedidosReales
FROM Clientes c
LEFT JOIN Pedidos p ON c.ClienteID = p.ClienteID
GROUP BY c.ClienteID, c.Nombre, c.NumeroPedidos
;

-- Insertar algunos pedidos para probar el trigger
INSERT INTO Pedidos (ClienteID, Total) VALUES 
(1, 125.50),  -- Pedido para Juan Pérez
(2, 89.99),   -- Pedido para María García
(1, 45.25),   -- Otro pedido para Juan Pérez
(3, 210.00);  -- Pedido para Carlos López

-- Verificar los resultados
SELECT c.ClienteID, c.Nombre, c.NumeroPedidos, 
       COUNT(p.PedidoID) as PedidosReales -- la columna p.PedidoID está "agregada"
FROM Clientes c
LEFT JOIN Pedidos p ON c.ClienteID = p.ClienteID
GROUP BY c.ClienteID, c.Nombre, c.NumeroPedidos -- Todas las columnas no agregadas en el SELECT deben aparecer en el GROUP BY
;