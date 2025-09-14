-- Añadir columna
ALTER TABLE comandos.empresa
	ADD país VARCHAR(20);
	
-- Borrar columna	
ALTER TABLE comandos.empresa
	DROP país;
	
-- Modificar TIPO columna (DIFERENCIAS entre SGBD)	
ALTER TABLE comandos.empresa
	MODIFY país VARCHAR(40);
	
-- Si quiero modificar otros parámetros de la columna (no sólo el tipo datos) usar CHANGE
ALTER TABLE `comandos`.`empresa` 
	CHANGE COLUMN `idEmpresa` `idEmpresa` INT NOT NULL AUTO_INCREMENT ;
	
-- Indicar qué columna es PRIMARY_KEY
ALTER TABLE `comandos`.`empresa` 
	CHANGE COLUMN `idEmpresa` `idEmpresa` INT NOT NULL ,
	ADD PRIMARY KEY (`idEmpresa`);

-- Añadir PRIMARY_KEY a una tabla ya creada.
ALTER TABLE comandos.empresa
	ADD PRIMARY KEY (idEmpresa);
	
-- Quitar PRIMARY_KEY
ALTER TABLE `comandos`.`empresa` 
	DROP PRIMARY KEY;

-- Cambiar nombre columna (OPCIÓN 1)
ALTER TABLE `comandos`.`empresa` 
RENAME COLUMN `old_name` to `new_name`;

-- Cambiar nombre columna (OPCIÓN 2) (y obligatoriamente definir tipo datos)
ALTER TABLE `comandos`.`empresa` 
	CHANGE COLUMN `dirección` `ciudad` VARCHAR(20);

-- Añadir varias columnas a la vez
ALTER TABLE comandos.empresa
    ADD provincia VARCHAR(30),
    ADD telefono VARCHAR(15);

-- Modificar varias columnas a la vez
ALTER TABLE comandos.empresa
    MODIFY país VARCHAR(50),
    MODIFY nombre VARCHAR(100);

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
    ADD fecha_creacion DATE DEFAULT (CURRENT_DATE);

-- Cambiar el orden de una columna
ALTER TABLE comandos.empresa_nueva
    MODIFY COLUMN telefono VARCHAR(15) AFTER nombre;

-- Eliminar restricción UNIQUE
ALTER TABLE comandos.empresa_nueva
    DROP INDEX unique_nombre;

-- Eliminar restricción CHECK (MySQL 8.0+)
ALTER TABLE comandos.empresa_nueva
    DROP CHECK chk_pais;