-- =============================================================
-- NOTA SOBRE ALTER TABLE ... MODIFY EN MYSQL
-- -------------------------------------------------------------
-- Sintaxis básica para modificar columnas de una tabla:
--     ALTER TABLE nombre_tabla MODIFY columna tipo_dato [nueva_restricción];
-- Puedes modificar el tipo de datos y las propiedades de una columna.
-- Todos los cambios son posibles si la tabla no contiene datos.
-- Si la tabla tiene datos, en general SÓLO podrás:
--   - Aumentar la longitud de una columna VARCHAR/CHAR
--   - Aumentar o disminuir el número de posiciones decimales en FLOAT/DOUBLE/DECIMAL
--   - Reducir la anchura de una columna SOLO si ningún dato existente supera la nueva longitud
--   - Cambiar restricciones si no afectan a los datos existentes
-- Si intentas reducir la longitud y existen datos que no caben, MySQL dará error.
-- Estas reglas son similares en otros SGBD, pero pueden variar en detalles y restricciones.
-- =============================================================

-- Añadir columna
ALTER TABLE comandos.empresa
    ADD COLUMN país VARCHAR(20);

-- Borrar columna (MySQL 5.7+)
ALTER TABLE comandos.empresa
    DROP COLUMN país;

-- Modificar TIPO columna (MySQL: usar MODIFY)
ALTER TABLE comandos.empresa
    MODIFY COLUMN país VARCHAR(40);

-- Modificar otros parámetros de la columna (no sólo el tipo de datos) usar CHANGE
ALTER TABLE comandos.empresa
    CHANGE COLUMN idEmpresa idEmpresa INT NOT NULL AUTO_INCREMENT;

-- Indicar qué columna es PRIMARY KEY (puede requerir que la columna sea NOT NULL)
ALTER TABLE comandos.empresa
    CHANGE COLUMN idEmpresa idEmpresa INT NOT NULL,
    ADD PRIMARY KEY (idEmpresa);

-- Añadir PRIMARY KEY a una tabla ya creada
ALTER TABLE comandos.empresa
    ADD PRIMARY KEY (idEmpresa);

-- Quitar PRIMARY KEY
ALTER TABLE comandos.empresa
    DROP PRIMARY KEY;

-- Cambiar nombre columna (OPCIÓN 1, MySQL 8.0+)
ALTER TABLE comandos.empresa
    RENAME COLUMN old_name TO new_name;

-- Cambiar nombre columna (OPCIÓN 2, usando CHANGE y definiendo tipo de datos)
ALTER TABLE comandos.empresa
    CHANGE COLUMN dirección ciudad VARCHAR(20);

-- Añadir varias columnas a la vez
ALTER TABLE comandos.empresa
    ADD COLUMN provincia VARCHAR(30),
    ADD COLUMN telefono VARCHAR(15);

-- Modificar varias columnas a la vez
ALTER TABLE comandos.empresa
    MODIFY COLUMN país VARCHAR(50),
    MODIFY COLUMN nombre VARCHAR(100);

-- Añadir restricción UNIQUE
ALTER TABLE comandos.empresa
    ADD CONSTRAINT unique_nombre UNIQUE (nombre);

-- Añadir restricción CHECK (MySQL 8.0+)
ALTER TABLE comandos.empresa
    ADD CONSTRAINT chk_pais CHECK (país IN ('España', 'Francia', 'Italia'));

-- Renombrar la tabla
RENAME TABLE comandos.empresa TO comandos.empresa_nueva;

-- Añadir columna con valor por defecto
ALTER TABLE comandos.empresa_nueva
    ADD COLUMN fecha_creacion DATE DEFAULT (CURRENT_DATE);

-- Cambiar el orden de una columna
ALTER TABLE comandos.empresa_nueva
    MODIFY COLUMN telefono VARCHAR(15) AFTER nombre;

-- Eliminar restricción UNIQUE de la columna unique_nombre, y mantener la columna.
ALTER TABLE comandos.empresa_nueva
    DROP INDEX unique_nombre;

-- Eliminar restricción CHECK (MySQL 8.0+)
ALTER TABLE comandos.empresa_nueva
    DROP CHECK chk_pais;

-- =============================================================
-- ERRORES COMUNES Y MALAS PRÁCTICAS EN ALTER TABLE (MySQL)
-- =============================================================
-- A continuación se muestran ejemplos de comandos incorrectos o confusos que suelen causar errores o comportamientos inesperados en MySQL.

-- Error: DROP COLUMN no está soportado en versiones antiguas.
-- ALTER TABLE comandos.empresa DROP COLUMN pais;

-- Código correcto (MySQL 5.7+):
ALTER TABLE comandos.empresa DROP COLUMN pais;

-- ¿Y en versiones antiguas de MySQL (antes de 5.7)?
-- En versiones antiguas donde DROP COLUMN no está soportado, el proceso correcto consiste en:
--   1. Crear una nueva tabla igual a la original pero sin la columna que deseas eliminar.
--   2. Copiar los datos de la tabla original a la nueva (usando INSERT INTO ... SELECT ...).
--   3. Borrar la tabla original.
--   4. Renombrar la nueva tabla con el nombre de la original.
-- Este proceso requiere especial atención para mantener claves primarias, índices y restricciones.

-- Error: MODIFY solo cambia el tipo, no el nombre. Para cambiar el nombre usa CHANGE o RENAME COLUMN.
-- ALTER TABLE comandos.empresa MODIFY COLUMN direccion ciudad VARCHAR(20);

-- Código correcto:
ALTER TABLE comandos.empresa CHANGE COLUMN direccion ciudad VARCHAR(20);
-- o en MySQL 8.0+:
ALTER TABLE comandos.empresa RENAME COLUMN direccion TO ciudad;

-- Error: MySQL no reconoce 'ADD CONSTRAINT ... PRIMARY KEY' como en otros SGBD, debe ser 'ADD PRIMARY KEY'.
-- ALTER TABLE comandos.empresa ADD CONSTRAINT pk_id PRIMARY KEY (idEmpresa);

-- Código correcto:
ALTER TABLE comandos.empresa ADD PRIMARY KEY (idEmpresa);

-- Error: En MySQL se usa DROP INDEX para UNIQUE y DROP PRIMARY KEY para la clave primaria.
-- ALTER TABLE comandos.empresa DROP CONSTRAINT unique_nombre;

-- Código correcto para UNIQUE:
ALTER TABLE comandos.empresa DROP INDEX unique_nombre;
-- Código correcto para PRIMARY KEY:
ALTER TABLE comandos.empresa DROP PRIMARY KEY;

-- Error: CHECK es ignorado en versiones anteriores a 8.0, no da error pero no se aplica la restricción.
-- ALTER TABLE comandos.empresa ADD CONSTRAINT chk_pais CHECK (pais IN ('España', 'Francia'));

-- Código correcto (solo MySQL 8.0+):
ALTER TABLE comandos.empresa ADD CONSTRAINT chk_pais CHECK (pais IN ('España', 'Francia'));