-- Crear un índice simple
CREATE INDEX idx_nombre ON comandos.empresa(nombre);

-- Crear un índice único
CREATE UNIQUE INDEX idx_unico_nombre ON comandos.empresa(nombre);

-- Crear un índice compuesto
CREATE INDEX idx_nombre_pais ON comandos.empresa(nombre, país);

-- Eliminar un índice
DROP INDEX idx_nombre ON comandos.empresa;

-- Ver índices de una tabla (MySQL)
SHOW INDEX FROM comandos.empresa;