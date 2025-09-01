	
-- Método correcto para actualizar datos en una fila ya existente
UPDATE comandos.empresa SET
	ciudad = "Zaragoza" WHERE idEmpresa = 6;
	
-- Método NO seguro, ya que al no usar una PRIMARY_KEY, podríamos modificar TODA la tabla.
UPDATE comandos.empresa SET
	ciudad = "Zaragoza";
