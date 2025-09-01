-- ---
-- # EJERCICIO DE TRANSFORMACIÓN MER/MERE a MR
-- # CASO: Entidad Débil "Pedidos" Agregada a Supermercados
-- ---

-- ##########################################################################
-- # ENUNCIADO DEL EJERCICIO (PARA ALUMNOS)                                 #
-- ##########################################################################

-- Se nos pide diseñar una base de datos para gestionar pedidos de supermercados.
-- En este sistema, un supermercado realiza pedidos. La "realización de un pedido"
-- (que es la relación entre Supermercado y Pedido) es, a su vez, una entidad
-- en sí misma, ya que se relaciona con Artículos y Empleados.

-- ENTIDADES PRINCIPALES:
-- 1.  Supermercados: Cada supermercado se identifica por un `idSupermercado` único y tiene un `nombreSupermercado`.
--     - Atributos: `idSupermercado` (PK), `nombreSupermercado`.
-- 2.  Artículos: Cada artículo se identifica por un `idArticulo` único y tiene un `nombreArticulo`.
--     - Atributos: `idArticulo` (PK), `nombreArticulo`.
-- 3.  Empleados: Cada empleado se identifica por un `idEmpleado` único y tiene un `nombreEmpleado`.
--     - Atributos: `idEmpleado` (PK), `nombreEmpleado`.

-- ENTIDAD DÉBIL:
-- 4.  Pedidos: Cada pedido se identifica por un `numPedido` (atributo parcial).
--     - Depende de Supermercados → **PK compuesta: (idSupermercadoFK, numPedido)**
--     - **Participación total** desde Pedidos hacia Supermercados (cada pedido pertenece a 1 supermercado).

-- RELACIONES:
-- 1. RELACIÓN AGREGADA: SUPERMERCADO realiza N PEDIDOS (1:N)
--    → Implícita en la entidad débil Pedidos, mediante la Clave Foránea (FK) y la Clave Primaria (PK) compuesta.

-- 2. RELACIÓN M:N ENTRE (Pedido completo) Y ARTÍCULOS → "Consta_de"
--    • Un pedido puede incluir varios artículos, y cada artículo estar en varios pedidos.
--    • Atributo de la relación: `cantidad`.

-- 3. RELACIÓN 1:N ENTRE (Pedido completo) Y EMPLEADOS
--    • Cada pedido lo entrega un único empleado.
--    • **Participación total** de la agregación "Realiza_Pedido" hacia Empleados (1,1): Cada realización de pedido **DEBE** ser entregada por un único empleado.
--    • **Participación parcial** de Empleados hacia Agregación "Realiza_Pedido" (0,N): Un empleado puede no haber entregado ningún pedido.

-- OBJETIVO:
-- Transformar este Modelo E-R con una relación agregada y una entidad débil al Modelo Relacional,
-- creando las tablas SQL necesarias y aplicando las restricciones que deriven
-- de las cardinalidades y participaciones.

-- ##########################################################################
-- # COMIENZO DEL CÓDIGO SQL                                                #
-- ##########################################################################

-- 🔄 CREACIÓN Y SELECCIÓN DE LA BASE DE DATOS
DROP DATABASE IF EXISTS SuperPedidosDB_v3; -- Se cambia el nombre para no colisionar con versiones anteriores.
CREATE DATABASE SuperPedidosDB_v3;         -- Crea una nueva base de datos.
USE SuperPedidosDB_v3;                     -- Selecciona la base de datos activa.

-- **************************************************************
-- ENTIDADES FUERTES
-- **************************************************************

-- TABLA SUPERMERCADOS
CREATE TABLE Supermercados (
    idSupermercado INT PRIMARY KEY,         -- Clave primaria.
    nombre VARCHAR(50)                      -- Nombre del supermercado.
);

-- TABLA ARTÍCULOS
CREATE TABLE Articulos (
    idArticulo INT PRIMARY KEY,             -- Clave primaria.
    nombre VARCHAR(50)                      -- Nombre del artículo.
);

-- TABLA EMPLEADOS
CREATE TABLE Empleados (
    idEmpleado INT PRIMARY KEY,             -- Clave primaria.
    nombre VARCHAR(50)                      -- Nombre del empleado.
);

-- **************************************************************
-- ENTIDAD DÉBIL: Pedidos
-- **************************************************************
-- La tabla Pedidos es una ENTIDAD DÉBIL. Su PK es compuesta (idSupermercadoFK, numPedido).
-- Incluye la FK a Empleados, que ahora es NOT NULL por la participación total.
CREATE TABLE Pedidos (
    idSupermercadoFK INT NOT NULL,          -- Clave Foránea a Supermercados. NOT NULL por participación total de Pedidos hacia Supermercados.
                                            -- Forma parte de la PK compuesta de Pedidos.
    numPedido INT,                          -- Atributo parcial que, junto con idSupermercadoFK, forma la PK.
    idEmpleadoFK INT NOT NULL,              -- Clave Foránea a Empleados. **ES NOT NULL** debido a la **participación total** (1,1)
                                            -- del Pedido hacia el Empleado (cada pedido DEBE ser entregado por un empleado).
    PRIMARY KEY (idSupermercadoFK, numPedido), -- Clave Primaria compuesta que identifica un pedido de forma única.
    
    CONSTRAINT fk_pedidos_supermercado FOREIGN KEY (idSupermercadoFK) REFERENCES Supermercados(idSupermercado)
    ON DELETE RESTRICT                      -- No se permite borrar un supermercado si tiene pedidos asociados.
    ON UPDATE CASCADE,                      -- Si el ID del supermercado cambia, se actualiza la FK.
    
    CONSTRAINT fk_pedidos_empleado FOREIGN KEY (idEmpleadoFK) REFERENCES Empleados(idEmpleado)
    ON DELETE RESTRICT                      -- **AHORA ES RESTRICT**. Si un empleado es borrado, NO se permite si tiene pedidos asociados.
                                            -- Esto se debe a que idEmpleadoFK es NOT NULL; un pedido siempre debe tener un empleado.
    ON UPDATE CASCADE                       -- Si el ID del empleado cambia, se actualiza la FK.
);

-- **************************************************************
-- RELACIÓN M:N ENTRE Pedidos Y Artículos → "Consta_de"
-- **************************************************************
-- Esta tabla resuelve la relación M:N entre la entidad débil 'Pedidos' y la entidad fuerte 'Articulos'.
CREATE TABLE Consta_de (
    idSupermercadoFK INT NOT NULL,          -- Parte de la PK compuesta de Pedidos, y parte de esta PK.
    numPedidoFK INT NOT NULL,                 -- Parte de la PK compuesta de Pedidos, y parte de esta PK.
    idArticuloFK INT NOT NULL,              -- Clave Foránea a Articulos, y parte de esta PK.
    cantidad INT NOT NULL CHECK (cantidad > 0), -- Atributo propio de la relación, la cantidad de un artículo en un pedido.

    PRIMARY KEY (idSupermercadoFK, numPedidoFK, idArticuloFK), -- PK compuesta de las tres FKs, reflejando la relación M:N.

    CONSTRAINT fk_consta_de_pedidos FOREIGN KEY (idSupermercadoFK, numPedidoFK) REFERENCES Pedidos(idSupermercadoFK, numPedido)
    ON DELETE CASCADE                       -- Si un pedido es borrado, se borran todas las líneas de artículo asociadas.
    ON UPDATE CASCADE,                      -- Si el ID del pedido (compuesto) cambia, se actualizan las FKs.

    CONSTRAINT fk_consta_de_articulos FOREIGN KEY (idArticuloFK) REFERENCES Articulos(idArticulo)
    ON DELETE RESTRICT                      -- Si un artículo es borrado, NO se permite si está en algún pedido.
    ON UPDATE CASCADE                       -- Si el ID del artículo cambia, se actualiza la FK.
);

-- **************************************************************
-- DATOS DE PRUEBA
-- **************************************************************

-- Supermercados
INSERT INTO Supermercados (idSupermercado, nombre) VALUES
(1, 'SuperMax'),
(2, 'EcoMarket');

-- Artículos
INSERT INTO Articulos (idArticulo, nombre) VALUES
(100, 'Leche'),
(101, 'Pan'),
(102, 'Huevos'),
(103, 'Fruta');

-- Empleados
INSERT INTO Empleados (idEmpleado, nombre) VALUES
(500, 'Carlos'),
(501, 'Lucía'),
(502, 'David');

-- Pedidos (Entidad Débil - (idSupermercado, numPedido) es la PK)
-- **IMPORTANTE**: Ahora idEmpleadoFK NO PUEDE SER NULL. Cada pedido debe tener un empleado.
INSERT INTO Pedidos (idSupermercadoFK, numPedido, idEmpleadoFK) VALUES
(1, 1, 500), -- Pedido 1 de SuperMax, entregado por Carlos
(1, 2, 501), -- Pedido 2 de SuperMax, entregado por Lucía
(2, 1, 500), -- Pedido 1 de EcoMarket, entregado por Carlos
(2, 2, 502); -- Pedido 2 de EcoMarket, entregado por David (antes era NULL, ahora debe tener un empleado)

-- Consta_de (Relación M:N entre Pedidos y Artículos)
INSERT INTO Consta_de (idSupermercadoFK, numPedido, idArticuloFK, cantidad) VALUES
(1, 1, 100, 10), -- Pedido (1,1) contiene 10 Leche
(1, 1, 101, 5),  -- Pedido (1,1) contiene 5 Pan
(1, 2, 102, 12), -- Pedido (1,2) contiene 12 Huevos
(2, 1, 100, 20), -- Pedido (2,1) contiene 20 Leche
(2, 1, 103, 3);  -- Pedido (2,1) contiene 3 Fruta

-- **************************************************************
-- CONSULTAS DE VERIFICACIÓN
-- **************************************************************

-- 1. Ver todos los pedidos con el nombre del supermercado y del empleado de entrega
SELECT
    P.idSupermercadoFK,
    P.numPedido,
    S.nombre AS NombreSupermercado,
    E.nombre AS NombreEmpleadoEntrega,
    'Este pedido fue realizado por ' AS Detalle
FROM
    Pedidos P
JOIN
    Supermercados S ON P.idSupermercadoFK = S.idSupermercado
JOIN -- Ahora usamos JOIN en lugar de LEFT JOIN porque idEmpleadoFK es NOT NULL.
    Empleados E ON P.idEmpleadoFK = E.idEmpleado
ORDER BY
    P.idSupermercadoFK, P.numPedido;

-- 2. Ver el detalle de los artículos que componen cada pedido
SELECT
    C.idSupermercadoFK,
    C.numPedido,
    A.nombre AS NombreArticulo,
    C.cantidad,
    'Cantidad de ' AS DetalleCantidad
FROM
    Consta_de C
JOIN
    Articulos A ON C.idArticuloFK = A.idArticulo
ORDER BY
    C.idSupermercadoFK, C.numPedido, A.nombre;

-- 3. Listar todos los pedidos realizados por un supermercado específico (ej. SuperMax, id=1)
SELECT
    P.numPedido,
    P.idSupermercadoFK,
    S.nombre AS NombreSupermercado,
    E.nombre AS NombreEmpleadoEntrega
FROM
    Pedidos P
JOIN
    Supermercados S ON P.idSupermercadoFK = S.idSupermercado
JOIN -- También JOIN aquí.
    Empleados E ON P.idEmpleadoFK = E.idEmpleado
WHERE
    P.idSupermercadoFK = 1
ORDER BY
    P.numPedido;

-- 4. Mostrar qué artículos se han pedido y en qué cantidad total, agrupados por artículo
SELECT
    A.nombre AS NombreArticulo,
    SUM(C.cantidad) AS CantidadTotalPedidos
FROM
    Consta_de C
JOIN
    Articulos A ON C.idArticuloFK = A.idArticulo
GROUP BY
    A.nombre
ORDER BY
    CantidadTotalPedidos DESC;

-- ##########################################################################
-- # FIN DEL CÓDIGO SQL                                                     #
-- ##########################################################################