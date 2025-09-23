/*
================================================================================
                        40.2 EJERCICIOS DDL - SQL
================================================================================
Asignatura: Bases de Datos
Unidad 4: DDL (Data Definition Language)
Tema: Ejercicios de Definición de Datos
================================================================================
*/

DROP DATABASE ddl_01;
CREATE DATABASE ddl_01;
USE ddl_01;
-- =============================================================================
-- EJERCICIO 1: Crear la tabla empleados con solo las columnas básicas y definir 
-- su clave principal:
-- - ID_empleado (ENTERO, clave principal)
-- - nombre (TEXTO(30), obligatorio)
-- - contrato (DATETIME, obligatorio)
-- =============================================================================

-- Solución:
CREATE TABLE empleados (
    ID_empleado INT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    contrato DATETIME NOT NULL
);

/*
EXPLICACIÓN:
Se crea la tabla con las columnas básicas. La clave principal se define con 
nomenclatura ID_empleado y la restricción se nombra PK_empleado.
*/

-- =============================================================================
-- EJERCICIO 2: Añadir las siguientes columnas a la tabla empleados:
-- - edad (ENTERO)
-- - titulo (TEXTO(20))
-- - cuota (DINERO CON DOS DECIMALES)
-- - ventas (DINERO CON DOS DECIMALES)
-- =============================================================================

-- Solución:
ALTER TABLE empleados
	ADD COLUMN edad INTEGER,
	ADD COLUMN titulo VARCHAR(20),
	ADD COLUMN cuota DECIMAL(10,2),
	ADD COLUMN ventas DECIMAL(10,2);

/*
EXPLICACIÓN:
Se añaden las columnas adicionales usando ALTER TABLE con múltiples ADD COLUMN.
*/

-- =============================================================================
-- EJERCICIO 3: Crear la tabla oficinas con las columnas básicas:
-- - ID_oficina (INT, clave principal)
-- - ciudad (TEXTO(30))
-- - region (TEXTO(20))
-- =============================================================================

-- Solución:
CREATE TABLE oficinas (
    ID_oficina INT PRIMARY KEY,
    ciudad VARCHAR(30),
    region VARCHAR(20)
);

/*
EXPLICACIÓN:
Se crea la tabla oficinas con estructura básica y clave principal siguiendo 
la nomenclatura establecida (ID_oficina, PK_oficina).
*/

-- =============================================================================
-- EJERCICIO 4: Añadir las siguientes columnas a la tabla oficinas:
-- - FK_director (INT, clave foránea que hace referencia a empleados)
-- - objetivo (DINERO CON DOS DECIMALES)
-- - ventas (DINERO CON DOS DECIMALES)
-- =============================================================================

-- Solución:
ALTER TABLE oficinas
	ADD COLUMN FK_director INT,
    ADD CONSTRAINT FK_dir FOREIGN KEY (FK_director) REFERENCES empleados(ID_empleado),
	ADD COLUMN objetivo DECIMAL(10,2),
	ADD COLUMN ventas DECIMAL(10,2);

/*
EXPLICACIÓN:
Se añaden las columnas restantes, incluyendo la clave foránea FK_director que 
hace referencia a la tabla empleados.
*/

-- =============================================================================
-- EJERCICIO 5: Crear la tabla productos con las siguientes columnas y clave 
-- principal compuesta:
-- - ID_fabricante (TEXTO(10))
-- - ID_producto (TEXTO(20))
-- - descripcion (TEXTO(30), obligatorio)
-- - precio (DINERO CON DOS DECIMALES, obligatorio)
-- - existencias (INT)
-- La clave principal está formada por ID_fabricante e ID_producto.
-- =============================================================================

-- Solución:
CREATE TABLE productos (
    ID_fabricante VARCHAR(10),
    ID_producto VARCHAR(20),
    descripcion VARCHAR(30) NOT NULL,
    precio DECIMAL(19,2) NOT NULL,
    existencias INT,
    CONSTRAINT PK_productos PRIMARY KEY (ID_fabricante, ID_producto)
);

/*
EXPLICACIÓN:
Se crea tabla con clave principal compuesta usando restricción con nombre PK_productos.
La clave principal está formada por dos columnas.
*/

-- =============================================================================
-- EJERCICIO 6: Crear la tabla clientes con las columnas básicas (SIN la columna 
-- limitecredito):
-- - ID_cliente (INT, clave principal)
-- - nombre (TEXTO(30), obligatorio)
-- =============================================================================

-- Solución:
CREATE TABLE clientes (
    ID_cliente INT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL
);

/*
EXPLICACIÓN:
Se crea la tabla clientes con estructura mínima. La columna limitecredito 
se añadirá en ejercicio posterior.
*/

-- =============================================================================
-- EJERCICIO 7: Añadir a la tabla clientes la columna:
-- - FK_representante (INT, clave foránea que hace referencia a empleados)
-- =============================================================================

-- Solución:
ALTER TABLE clientes
	ADD COLUMN FK_representante INT,
    ADD CONSTRAINT FK_repre FOREIGN KEY (FK_representante) REFERENCES empleados(ID_empleado);

/*
EXPLICACIÓN:
Se añade la columna FK_representante como clave foránea hacia empleados.
*/

-- =============================================================================
-- EJERCICIO 8: Crear la tabla pedidos SIN definir clave principal (se añadirá 
-- posteriormente):
-- - codigo (COUNTER)
-- - ID_pedido (INT)
-- - fechapedido (DATETIME, obligatorio)
-- - FK_cliente (INT, obligatorio, clave foránea hacia clientes)
-- - FK_representante (INT, obligatorio, clave foránea hacia empleados)
-- - FK_fabricante (TEXTO(10), obligatorio)
-- - FK_producto (TEXTO(20), obligatorio)
-- - cantidad (INT, obligatorio)
-- - importe (DINERO CON DOS DECIMALES, obligatorio)
-- Las columnas FK_fabricante y FK_producto forman clave foránea compuesta hacia productos.
-- =============================================================================

-- Solución:
CREATE TABLE pedidos (
    codigo DECIMAL(10,2),
    ID_pedido INT,
    fechapedido DATETIME NOT NULL,
    FK_cliente INT NOT NULL,
    FK_representante INT NOT NULL,
    FK_fabricante VARCHAR(10) NOT NULL,
    FK_producto VARCHAR(20) NOT NULL,
    cantidad INT NOT NULL,
    importe DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_cli FOREIGN KEY (FK_cliente) REFERENCES clientes(ID_cliente),
    CONSTRAINT FK_rep_ped FOREIGN KEY (FK_representante) REFERENCES empleados(ID_empleado),
    CONSTRAINT FK_prod FOREIGN KEY (FK_fabricante, FK_producto) REFERENCES productos(ID_fabricante, ID_producto)
);

/*
EXPLICACIÓN:
Se crea la tabla pedidos con todas las claves foráneas pero sin clave principal.
La clave foránea FK_producto es compuesta (FK_fabricante, FK_producto).
*/

-- =============================================================================
-- EJERCICIO 9: Añadir a la tabla clientes la columna limitecredito de tipo 
-- DECIMAL(10,2).
-- =============================================================================

-- Solución:
ALTER TABLE clientes
	ADD COLUMN limitecredito DECIMAL(10,2);

/*
EXPLICACIÓN:
Se añade la columna limitecredito usando ALTER TABLE ADD COLUMN.
*/

-- =============================================================================
-- EJERCICIO 9.1: Modificar el tipo de datos de la columna edad en empleados 
-- de ENTERO a TINYINT (ya que la edad no supera los 255 años).
-- =============================================================================

-- Solución:
ALTER TABLE empleados
	MODIFY COLUMN edad TINYINT;

/*
EXPLICACIÓN:
Se modifica el tipo de datos de la columna edad usando ALTER TABLE MODIFY COLUMN.
TINYINT ocupa menos espacio que ENTERO para valores entre 0-255.
*/

-- =============================================================================
-- EJERCICIO 10: Añadir a la tabla empleados la columna:
-- - FK_oficina (ENTERO, clave foránea que hace referencia a oficinas)
-- =============================================================================

-- Solución:
ALTER TABLE empleados
	ADD COLUMN FK_oficina INT,
    ADD CONSTRAINT FK_ofi FOREIGN KEY (FK_oficina) REFERENCES oficinas(ID_oficina);

/*
EXPLICACIÓN:
Se añade la columna FK_oficina como clave foránea hacia la tabla oficinas.
*/

-- =============================================================================
-- EJERCICIO 11: Añadir a la tabla empleados la columna:
-- - FK_director (ENTERO, clave foránea que hace referencia a la propia tabla empleados)
-- =============================================================================

-- Solución:
ALTER TABLE empleados
	ADD COLUMN FK_director INT,
    ADD CONSTRAINT FK_dir_emp FOREIGN KEY (FK_director) REFERENCES empleados(ID_empleado); 
    -- tenemos que poner un nombre diferenciador de la FK en empleados, porque MySQL no permite dos CONSTRAINT con el mismo nombre en la misma BBDD.

/*
EXPLICACIÓN:
Se añade una clave foránea autoreferencial para indicar el director de cada empleado.
*/

-- =============================================================================
-- EJERCICIO 12: Hacer que no puedan existir dos empleados con el mismo nombre 
-- (restricción UNIQUE).
-- =============================================================================

-- Solución:
ALTER TABLE empleados
	ADD CONSTRAINT UK_nombre_empleado UNIQUE (nombre);

/*
EXPLICACIÓN:
Se añade una restricción UNIQUE para evitar nombres duplicados en empleados.
*/

-- =============================================================================
-- EJERCICIO 12.1: Cambiar el nombre de la columna "descripcion" en la tabla 
-- productos por "nombre_producto".
-- =============================================================================

-- Solución:
ALTER TABLE productos
	CHANGE COLUMN descripcion nombre_producto VARCHAR(30) NOT NULL;

/*
EXPLICACIÓN:
Se cambia el nombre de la columna usando ALTER TABLE CHANGE COLUMN.
Hay que especificar el nuevo nombre y el tipo de datos completo.
*/

-- =============================================================================
-- EJERCICIO 13: Añadir a la tabla pedidos la definición de clave principal 
-- sobre la columna ID_pedido.
-- =============================================================================

-- Solución:
ALTER TABLE pedidos
ADD CONSTRAINT PK_pedido PRIMARY KEY (ID_pedido);

/*
EXPLICACIÓN:
Se añade la clave principal usando ALTER TABLE con restricción nombrada PK_pedido.
*/

-- =============================================================================
-- EJERCICIO 14: Definir un índice llamado IX_region sobre la columna region 
-- de la tabla oficinas.
-- =============================================================================

-- Solución:
CREATE INDEX IX_region ON oficinas (region);

/*
EXPLICACIÓN:
Se crea un índice para mejorar las consultas sobre la columna region.
*/

-- =============================================================================
-- EJERCICIO 15: Crear una tabla llamada empleados_backup que sea una copia 
-- exacta de la estructura de la tabla empleados (sin datos).
-- =============================================================================

-- Solución:
CREATE TABLE empleados_backup AS
	SELECT * FROM empleados WHERE 1=0;

-- Alternativa usando CREATE TABLE LIKE (en algunos SGBD):
-- CREATE TABLE empleados_backup LIKE empleados;

/*
EXPLICACIÓN:
Se crea una tabla copia usando CREATE TABLE AS SELECT con condición falsa 
para copiar solo la estructura sin datos.
*/

-- =============================================================================
-- EJERCICIO 16: Eliminar todos los datos de la tabla empleados_backup pero 
-- mantener su estructura.
-- =============================================================================

-- Solución:
TRUNCATE TABLE empleados_backup;

/*
EXPLICACIÓN:
TRUNCATE elimina todos los datos pero mantiene la estructura de la tabla.
Es más rápido que DELETE sin WHERE.
*/

-- =============================================================================
-- EJERCICIO 17: Eliminar completamente la tabla empleados_backup (estructura y datos).
-- =============================================================================

-- Solución:
DROP TABLE empleados_backup;

/*
EXPLICACIÓN:
DROP TABLE elimina completamente la tabla, su estructura y todos sus datos.
*/

-- =============================================================================
-- EJERCICIO 18: Eliminar el índice IX_region creado en el ejercicio 14.
-- =============================================================================

-- Solución:
DROP INDEX IX_region ON oficinas;

/*
EXPLICACIÓN:
Se elimina el índice usando DROP INDEX especificando la tabla.
*/


/*
================================================================================
                            FIN DE LOS EJERCICIOS
================================================================================
*/



-- BLOQUE DE CÓDIGO PARA DB-FIDDLE.COM (MÁS SIMPLIFICADO)

CREATE TABLE Empleados (
  ID_empleado INT PRIMARY KEY
  );
  
CREATE TABLE Oficinas (
  ID_oficina INT PRIMARY KEY,
  FK_dir INT,
  
  CONSTRAINT FK_director FOREIGN KEY (FK_dir) REFERENCES Empleados(ID_empleado)
  );
  
CREATE TABLE Productos (
  ID_fab INT,
  ID_producto INT,
  
  CONSTRAINT PK_producto PRIMARY KEY (ID_fab, ID_producto) 
  );
  
CREATE TABLE Clientes (
  ID_cliente INT PRIMARY KEY,
  FK_repcli INT,
  
  FOREIGN KEY (FK_repcli) REFERENCES Empleados(ID_empleado)
  );

CREATE TABLE Pedidos (
  ID_pedido INT,
  FK_cli INT,
  FK_repre_emp INT,
  FK_fab INT,
  FK_prod INT,
  
  FOREIGN KEY (FK_cli) REFERENCES Clientes(ID_cliente),
  FOREIGN KEY (FK_repre_emp) REFERENCES Empleados(ID_empleado),
  FOREIGN KEY (FK_fab, FK_prod) REFERENCES Productos(ID_fab, ID_producto)
  );

ALTER TABLE Clientes 
ADD COLUMN limitecredito DECIMAL(10,2);


ALTER TABLE Empleados
	ADD COLUMN FK_oficina INT,
	ADD COLUMN FK_director INT,
	ADD CONSTRAINT FK_ofi FOREIGN KEY (FK_oficina) REFERENCES Oficinas(ID_oficina),
	ADD CONSTRAINT FK_dir FOREIGN KEY (FK_director) REFERENCES Empleados(ID_empleado);


ALTER TABLE Empleados
	ADD COLUMN nombre VARCHAR(50) UNIQUE;

ALTER TABLE Pedidos
	ADD CONSTRAINT PK_ped PRIMARY KEY (ID_pedido);
    
ALTER TABLE Oficinas
	ADD COLUMN region VARCHAR(100);
    
CREATE INDEX i_region ON Oficinas(region);

DROP INDEX i_region ON Oficinas;