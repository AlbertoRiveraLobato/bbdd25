DELETE FROM comandos.empresa
	WHERE idEmpresa = '6';
	

-- Método erróneo porque no fija una fila... podrían ser varias.
DELETE FROM comandos.empresa
	WHERE nombre = 'ALCAMPO';
