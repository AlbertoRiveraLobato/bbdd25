
-- =============================================
-- 05_EXPLAIN.sql
-- =============================================
-- Ejemplo de uso de EXPLAIN en MySQL/MariaDB para analizar y optimizar consultas.
-- Contenido:
--   - Creación de base de datos y tablas necesarias.
--   - Ejemplos de sentencias correctas de uso de EXPLAIN.
--   - Ejemplos de sentencias erróneas y explicación de los errores más comunes.

-- =============================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS
-- =============================================


CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    producto VARCHAR(50),
    cantidad INT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes (nombre, email) VALUES ('Ana', 'ana@email.com'), ('Luis', 'luis@email.com');
INSERT INTO pedidos (cliente_id, producto, cantidad) VALUES (1, 'Ratón', 2), (2, 'Teclado', 1);

-- =============================================
-- EJEMPLOS DE USO CORRECTO
-- =============================================

-- Analizar una consulta simple
EXPLAIN SELECT * FROM clientes WHERE nombre = 'Ana'; -- el resultado muestra cómo se ejecuta la consulta,
-- incluyendo el uso de índices, tipo de unión, etc.

-- Analizar un JOIN
EXPLAIN SELECT c.nombre, p.producto FROM clientes c JOIN pedidos p ON c.id = p.cliente_id;

-- Analizar una consulta con subconsulta
EXPLAIN SELECT * FROM clientes WHERE id IN (SELECT cliente_id FROM pedidos);

-- =============================================
-- EJEMPLOS DE SENTENCIAS ERRÓNEAS Y EXPLICACIÓN
-- =============================================

-- Error 1: Sintaxis incorrecta
-- EXPLAIN clientes; -- Error: falta SELECT

-- Error 2: Analizar una tabla inexistente
-- EXPLAIN SELECT * FROM tabla_que_no_existe; -- Error: tabla no existe

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
