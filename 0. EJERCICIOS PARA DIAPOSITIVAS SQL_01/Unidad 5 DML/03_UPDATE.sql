
-- UPDATE: Modificación de datos existentes
CREATE DATABASE IF NOT EXISTS ejemplo_ddl;
USE ejemplo_ddl;

CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    salario DECIMAL(10,2)
);

INSERT INTO empleados (nombre, salario) VALUES ('Ana', 2000), ('Luis', 2500);

UPDATE empleados SET salario = 3000 WHERE nombre = 'Ana';

-- Error común: olvidar la cláusula WHERE puede modificar todos los registros
UPDATE empleados SET 
    salario = 1000; -- ¡Cuidado! Todos los salarios se actualizan

-- Método NO seguro, ya que al no usar una PRIMARY_KEY, podríamos modificar TODA la tabla.
UPDATE comandos.empresa SET
	ciudad = "Zaragoza";