/*
Ejercicio 317-1: Implementación de AGREGACIÓN
Título: Sistema de Supermercados con Pedidos y Artículos

Descripción:
Este ejercicio se centra en cómo implementar una AGREGACIÓN en un modelo Entidad-Relación.
La agregación permite tratar un conjunto de entidades y relaciones como una entidad de nivel superior.

En este caso:
- Las entidades base son: SUPER, PEDIDOS, EMPLEADOS, ARTICULOS
- La agregación está sobre la relación M:N "Consta_de" entre Pedidos y Artículos
- La relación agregada "Realizar" conecta SUPER con el conjunto agregado (PEDIDOS + ARTICULOS)

REQUISITOS DE NEGOCIO:
- Una cadena de Supermercados registra los Pedidos que recibe
- Los pedidos se componen de varios Artículos (relación M:N)
- Un pedido lo Entrega un Empleado
- Los alumnos solo pueden usar DDL, DML y consultas uni-tabla (SIN JOINS)

ENTIDADES Y RELACIONES:
- SUPER (Supermercados): Información de cada sucursal
- EMPLEADOS: Información de los empleados
- PEDIDOS: Información de cada pedido (clave compuesta con SUPER)
- ARTICULOS: Información de los artículos disponibles
- CONSTA_DE: Relación M:N entre Pedidos y Artículos (implementa la agregación)

ATRIBUTOS PRINCIPALES:
- SUPER: IDsuper (PK), nombre
- EMPLEADOS: IDempleado (PK), nombre
- PEDIDOS: IDsuperFK + Numpedido (PK compuesta), fechaPedido, IDempleadoFK
- ARTICULOS: IDarticulo (PK), nombre
- CONSTA_DE: IDarticuloFK + IDsuperFK + NumpedidoFK (PK compuesta), cantidad
*/

-- =============================================================
-- IMPLEMENTACIÓN: AGREGACIÓN CON CLAVES COMPUESTAS
-- =============================================================

DROP DATABASE IF EXISTS supermercados_agregacion;
CREATE DATABASE supermercados_agregacion;
USE supermercados_agregacion;

-- =============================================================
-- CREACIÓN DE TABLAS (ENTIDADES BASE)
-- =============================================================

-- 1. Tabla SUPERMERCADOS (Supermercados)
CREATE TABLE SUPERMERCADOS (
    IDsuper VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(15)
);

-- 2. Tabla EMPLEADOS
CREATE TABLE EMPLEADOS (
    IDempleado VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100),
    cargo VARCHAR(50)
);

-- 3. Tabla ARTICULOS
CREATE TABLE ARTICULOS (
    IDarticulo VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(8,2),
    categoria VARCHAR(50)
);

-- =============================================================
-- IMPLEMENTACIÓN DE LA AGREGACIÓN
-- =============================================================

-- 4. Tabla PEDIDOS (Parte de la agregación)
-- NOTA: La clave primaria es COMPUESTA (IDsuperFK + Numpedido)
-- Esto implementa la relación "Realizar" entre SUPER y la agregación
CREATE TABLE PEDIDOS (
    IDsuperFK VARCHAR(10) NOT NULL,     -- FK hacia SUPER (relación "Realizar")
    Numpedido INT NOT NULL,             -- Número de pedido (único por supermercado)
    fechaPedido DATE NOT NULL,
    IDempleadoFK VARCHAR(10),           -- FK hacia EMPLEADOS (relación "Entregar")
    estado ENUM('pendiente', 'procesando', 'entregado') DEFAULT 'pendiente',

    -- CLAVE PRIMARIA COMPUESTA (implementa la agregación)
    PRIMARY KEY (IDsuperFK, Numpedido),

    -- CLAVES FORÁNEAS
    FOREIGN KEY (IDsuperFK) REFERENCES SUPER(IDsuper) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (IDempleadoFK) REFERENCES EMPLEADOS(IDempleado) 
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 5. Tabla CONSTA_DE (Implementa la relación M:N de la agregación)
-- Esta tabla conecta ARTICULOS con la agregación (SUPER + PEDIDOS)
CREATE TABLE CONSTA_DE (
    IDarticuloFK VARCHAR(10) NOT NULL,  -- FK hacia ARTICULOS
    IDsuperFK VARCHAR(10) NOT NULL,     -- FK hacia SUPER (parte de la agregación)
    NumpedidoFK INT NOT NULL,           -- FK hacia PEDIDOS (parte de la agregación)
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(8,2),

    -- CLAVE PRIMARIA COMPUESTA (todas las FK forman la PK)
    PRIMARY KEY (IDarticuloFK, IDsuperFK, NumpedidoFK),

    -- CLAVES FORÁNEAS
    FOREIGN KEY (IDarticuloFK) REFERENCES ARTICULOS(IDarticulo) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- FK COMPUESTA hacia PEDIDOS (implementa la agregación)
    FOREIGN KEY (IDsuperFK, NumpedidoFK) REFERENCES PEDIDOS(IDsuperFK, Numpedido) 
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- =============================================================
-- DATOS DE EJEMPLO
-- =============================================================

-- Insertar datos en las tablas base (entidades independientes)
INSERT INTO SUPER (IDsuper, nombre, direccion, telefono) VALUES
('S001', 'Mercado Central', 'Calle Mayor 123, Madrid', '915551234'),
('S002', 'Super Norte', 'Avenida Norte 456, Barcelona', '934567890'),
('S003', 'Hiper Sur', 'Plaza Sur 789, Valencia', '963334455');

INSERT INTO EMPLEADOS (IDempleado, nombre, apellidos, cargo) VALUES
('E001', 'Ana', 'García López', 'Repartidor'),
('E002', 'Carlos', 'Martín Ruiz', 'Repartidor'),
('E003', 'María', 'Fernández Vila', 'Supervisor');

INSERT INTO ARTICULOS (IDarticulo, nombre, precio, categoria) VALUES
('A001', 'Pan integral', 2.50, 'Panadería'),
('A002', 'Leche entera', 1.20, 'Lácteos'),
('A003', 'Manzanas', 3.80, 'Frutas'),
('A004', 'Yogur natural', 0.75, 'Lácteos'),
('A005', 'Pasta italiana', 1.95, 'Conservas');

-- Insertar pedidos (implementa la agregación SUPER + PEDIDOS)
INSERT INTO PEDIDOS (IDsuperFK, Numpedido, fechaPedido, IDempleadoFK, estado) VALUES
('S001', 1, '2025-10-28', 'E001', 'entregado'),
('S001', 2, '2025-10-28', 'E002', 'procesando'),
('S002', 1, '2025-10-28', 'E001', 'pendiente'),
('S003', 1, '2025-10-29', 'E003', 'entregado');

-- Insertar líneas de pedido (implementa la relación M:N de la agregación)
INSERT INTO CONSTA_DE (IDarticuloFK, IDsuperFK, NumpedidoFK, cantidad, precio_unitario) VALUES
-- Pedido 1 del Super S001
('A001', 'S001', 1, 5, 2.50),   -- 5 panes
('A002', 'S001', 1, 2, 1.20),   -- 2 leches
('A003', 'S001', 1, 3, 3.80),   -- 3 kg manzanas

-- Pedido 2 del Super S001
('A004', 'S001', 2, 10, 0.75),  -- 10 yogures
('A005', 'S001', 2, 4, 1.95),   -- 4 pastas

-- Pedido 1 del Super S002
('A001', 'S002', 1, 8, 2.50),   -- 8 panes
('A002', 'S002', 1, 6, 1.20),   -- 6 leches

-- Pedido 1 del Super S003
('A003', 'S003', 1, 5, 3.80),   -- 5 kg manzanas
('A004', 'S003', 1, 12, 0.75),  -- 12 yogures
('A005', 'S003', 1, 3, 1.95);   -- 3 pastas

-- =============================================================
-- CONSULTAS DE EJEMPLO (SOLO UNITABLA - SIN JOINS)
-- =============================================================

-- 1. Ver todos los supermercados
SELECT * FROM SUPER;

-- 2. Ver todos los empleados
SELECT * FROM EMPLEADOS;

-- 3. Ver todos los artículos disponibles
SELECT * FROM ARTICULOS;

-- 4. Ver todos los pedidos (con clave compuesta)
SELECT IDsuperFK, Numpedido, fechaPedido, IDempleadoFK, estado 
FROM PEDIDOS;

-- 5. Ver todas las líneas de pedido (implementación de la agregación)
SELECT IDarticuloFK, IDsuperFK, NumpedidoFK, cantidad, precio_unitario 
FROM CONSTA_DE;

-- 6. Ver pedidos de un supermercado específico: S001
SELECT IDsuperFK, Numpedido, fechaPedido, estado 
FROM PEDIDOS 
WHERE IDsuperFK = 'S001';

-- 7. Ver líneas de pedido de un pedido específico: S001, pedido 1
SELECT IDarticuloFK, cantidad, precio_unitario 
FROM CONSTA_DE 
WHERE IDsuperFK = 'S001' AND NumpedidoFK = 1;

-- 8. Contar pedidos por supermercado
SELECT IDsuperFK, COUNT(*) as total_pedidos 
FROM PEDIDOS 
GROUP BY IDsuperFK;

-- 9. Ver los artículos más pedidos (por cantidad total) y mostrar sólo los top 5
SELECT IDarticuloFK, SUM(cantidad) as cantidad_total 
FROM CONSTA_DE 
GROUP BY IDarticuloFK 
ORDER BY cantidad_total DESC
LIMIT 5;

-- 10. Calcular valor total por línea de pedido
SELECT IDarticuloFK, IDsuperFK, NumpedidoFK, cantidad, 
       precio_unitario, (cantidad * precio_unitario) as valor_linea
FROM CONSTA_DE;

-- =============================================================
-- VERIFICACIONES DE INTEGRIDAD DE LA AGREGACIÓN
-- =============================================================

-- Esta inserción debe FALLAR (pedido sin supermercado válido)
-- INSERT INTO PEDIDOS VALUES ('S999', 1, '2025-10-28', 'E001', 'pendiente');

-- Esta inserción debe FALLAR (línea de pedido sin pedido válido)
-- INSERT INTO CONSTA_DE VALUES ('A001', 'S999', 999, 1, 2.50);

-- Esta inserción debe FALLAR (línea de pedido con FK compuesta incorrecta)
-- INSERT INTO CONSTA_DE VALUES ('A001', 'S001', 999, 1, 2.50);

-- =============================================================
-- OPERACIONES DML DE EJEMPLO
-- =============================================================

-- Actualizar estado de un pedido específico
UPDATE PEDIDOS 
SET estado = 'entregado' 
WHERE IDsuperFK = 'S002' AND Numpedido = 1;

-- Actualizar cantidad en una línea de pedido
UPDATE CONSTA_DE 
SET cantidad = 6 
WHERE IDarticuloFK = 'A001' AND IDsuperFK = 'S001' AND NumpedidoFK = 1;

-- Añadir nuevo artículo a un pedido existente
INSERT INTO CONSTA_DE (IDarticuloFK, IDsuperFK, NumpedidoFK, cantidad, precio_unitario) 
VALUES ('A002', 'S003', 1, 4, 1.20);

-- Eliminar una línea de pedido
DELETE FROM CONSTA_DE 
WHERE IDarticuloFK = 'A005' AND IDsuperFK = 'S001' AND NumpedidoFK = 2;

-- =============================================================
-- ANÁLISIS DE LA IMPLEMENTACIÓN DE AGREGACIÓN
-- =============================================================

/*
✅ VENTAJAS DE LA AGREGACIÓN:
- Modela relaciones complejas de forma natural
- Las claves compuestas garantizan integridad referencial
- Permite relacionar conjuntos de entidades como una unidad
- Escalable para sistemas complejos con múltiples niveles

❌ INCONVENIENTES:
- Claves compuestas más complejas de manejar
- Consultas requieren especificar múltiples campos de clave
- Mayor complejidad en las operaciones DML
- Curva de aprendizaje más pronunciada

🎯 IDEAL PARA:
- Sistemas con relaciones jerárquicas complejas
- Casos donde necesitas tratar múltiples entidades como una unidad
- Modelos que requieren alta integridad referencial
- Aplicaciones con estructuras de datos multinivel

📊 CÓMO FUNCIONA LA AGREGACIÓN:
- SUPER se relaciona con la agregación (PEDIDOS + ARTICULOS)
- PEDIDOS tiene clave compuesta (IDsuperFK + Numpedido)
- CONSTA_DE conecta ARTICULOS con la agregación completa
- Las FK compuestas garantizan la integridad de la agregación

🔧 CONCEPTOS CLAVE:
- Agregación: Tratar un conjunto de entidades y relaciones como una entidad
- Clave compuesta: PK formada por múltiples campos
- FK compuesta: FK que referencia a una PK compuesta
- Integridad referencial: Garantizada por las restricciones FK
*/

-- =============================================================
-- EJERCICIOS PROPUESTOS PARA EL ALUMNO
-- =============================================================

/*
EJERCICIO A: Inserta un nuevo pedido (número 3) para el supermercado S001
EJERCICIO B: Añade 3 líneas de pedido al pedido recién creado
EJERCICIO C: Calcula el valor total de cada pedido (suma de cantidad * precio_unitario)
EJERCICIO D: Encuentra qué supermercado tiene más pedidos
EJERCICIO E: Lista todos los artículos que nunca se han pedido

EJERCICIO AVANZADO F: Intenta insertar una línea de pedido con una FK compuesta incorrecta
¿Qué error obtienes? ¿Por qué es importante la integridad referencial en agregaciones?

PREGUNTA DE REFLEXIÓN:
¿Qué diferencias observas entre una relación M:N normal y una relación M:N 
que forma parte de una agregación? ¿Por qué la tabla CONSTA_DE necesita 
una clave compuesta de 3 campos en lugar de 2?

DESAFÍO PRÁCTICO:
Si quisiéramos añadir información sobre "Promociones" que se aplican a 
pedidos completos (no a artículos individuales), ¿cómo modificarías 
el modelo? ¿Dónde colocarías la relación con Promociones: en PEDIDOS 
o en CONSTA_DE? Justifica tu respuesta.
*/