-- #######################################################
-- # EJEMPLO COMPLETO DE SCRIPT SQL CON CASOS DE PRUEBA  #
-- # Incluye:                                           #
-- # - Creación de BBDD y tablas                        #
-- # - Inserciones válidas                              #
-- # - Inserciones que generan errores (comentadas)     #
-- # - Consultas variadas                               #
-- # - Transacciones con rollback                       #
-- #######################################################

-- Creación de la base de datos (ejecutar primero)
CREATE DATABASE IF NOT EXISTS prueba_tecnicos;
USE prueba_tecnicos;

-- Creación de tablas
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    saldo DECIMAL(10,2) CHECK (saldo >= 0)
);

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    producto VARCHAR(50) NOT NULL,
    cantidad INT DEFAULT 1,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- ##########################################
-- # INSERCIONES VÁLIDAS                    #
-- ##########################################

INSERT INTO clientes (nombre, email, saldo) VALUES 
('Juan Pérez', 'juan@example.com', 150.75),
('María García', 'maria@example.com', 200.00);

INSERT INTO pedidos (cliente_id, producto, cantidad) VALUES
(1, 'Portátil HP', 1),
(1, 'Ratón inalámbrico', 2),
(2, 'Teclado mecánico', 1);

-- ##########################################
-- # INSERCIONES QUE GENERAN ERRORES        #
-- # (descomentar para probar)              #
-- ##########################################

-- Violación de UNIQUE (email repetido)
-- INSERT INTO clientes (nombre, email, saldo) VALUES ('Ana López', 'juan@example.com', 50.00);

-- Violación de CHECK (saldo negativo)
-- INSERT INTO clientes (nombre, email, saldo) VALUES ('Carlos Ruiz', 'carlos@example.com', -100.00);

-- Violación de FOREIGN KEY (cliente_id no existe)
-- INSERT INTO pedidos (cliente_id, producto) VALUES (999, 'Monitor LED');

-- Violación de NOT NULL
-- INSERT INTO clientes (email, saldo) VALUES ('otro@example.com', 75.50);



/*
Ejemplo para probar en diferentes sistemas gestores:

MySQL/MariaDB:
- Ejecutar todo el script tal cual

PostgreSQL:
- Cambiar CURRENT_DATE por CURRENT_DATE()
- Cambiar DEFAULT CURRENT_TIMESTAMP por DEFAULT NOW()

SQL Server:
- Cambiar AUTO_INCREMENT por IDENTITY
- Cambiar CURRENT_DATE por GETDATE()
*/

