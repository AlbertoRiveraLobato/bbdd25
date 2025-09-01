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