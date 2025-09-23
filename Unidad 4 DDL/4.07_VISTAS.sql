-- Crear una vista simple
CREATE VIEW vista_empresas AS
SELECT nombre, país FROM comandos.empresa_nueva;

-- Crear una vista con condición
CREATE VIEW vista_empresas_es AS
SELECT * FROM comandos.empresa_nueva WHERE país = 'España';

-- Actualizar una vista
CREATE OR REPLACE VIEW vista_empresas AS
SELECT nombre, ciudad FROM comandos.empresa_nueva;

-- Eliminar una vista
DROP VIEW IF EXISTS vista_empresas;