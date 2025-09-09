INSERT INTO comandos.empresa
	(idEmpresa, Nombre, Dirección) VALUES (1, 'PRYCA', 'San Fernando');
	
-- Si quiero meter datos, sin tener que indicar la PRIMARY_KEY, debo definir esa columna como PRIMARY_KEY, y para ello, entre otras cosas, ha de ser AUTO_INCREMENT
INSERT INTO comandos.empresa
	(nombre, ciudad, país) VALUES ('CARREFOUR', 'San Fernando', 'España');
	
-- Varias filas de golpe
INSERT INTO comandos.empresa
	(nombre, ciudad, país) VALUES 
		('ECI', 'Mejorada', 'España'),
		('CARRODS', 'Oxford', 'Ingalterra'),
		('ALCAMPO', '', ''),
		('LIDL', 'Berlín', 'Alemania');