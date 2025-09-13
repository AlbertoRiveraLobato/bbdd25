
-- =============================================
-- 06_EXPLAIN.sql
-- =============================================
-- Ejemplos de uso de EXPLAIN en MySQL para analizar y optimizar consultas.
-- Incluye: creación de base de datos y tablas, ejemplos de uso y errores comunes.

-- CREACIÓN DE BASE DE DATOS Y TABLAS
CREATE DATABASE IF NOT EXISTS ejemplo_explain;
USE ejemplo_explain;

CREATE TABLE clientes (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50),
	email VARCHAR(100) UNIQUE
);

CREATE TABLE pedidos (
	id INT AUTO_INCREMENT PRIMARY KEY,
	cliente_id INT,
	producto VARCHAR(50),
	cantidad INT,
	FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes (nombre, email) VALUES ('Ana', 'ana@email.com'), ('Luis', 'luis@email.com');
INSERT INTO pedidos (cliente_id, producto, cantidad) VALUES (1, 'Ratón', 2), (2, 'Teclado', 1);

-- =============================================
-- EJEMPLOS DE USO
-- =============================================

-- Analizar una consulta simple
EXPLAIN SELECT * FROM clientes WHERE nombre = 'Ana';

-- Analizar un JOIN
EXPLAIN SELECT c.nombre, p.producto FROM clientes c JOIN pedidos p ON c.id = p.cliente_id;

-- Analizar una consulta con subconsulta
EXPLAIN SELECT * FROM clientes WHERE id IN (SELECT cliente_id FROM pedidos);

-- =============================================
-- ERRORES COMUNES
-- =============================================

-- Error 1: Sintaxis incorrecta
-- EXPLAIN clientes; -- Error: falta SELECT

-- Error 2: Analizar una tabla inexistente
-- EXPLAIN SELECT * FROM tabla_que_no_existe; -- Error: tabla no existe
