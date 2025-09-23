-- Añadir comentario a una tabla
ALTER TABLE comandos.empresa_nueva COMMENT = 'Tabla de empresas actualizada';

-- Añadir comentario a una columna
ALTER TABLE comandos.empresa_nueva
    MODIFY nombre VARCHAR(100) COMMENT 'Nombre de la empresa';

-- Ver comentarios de la tabla
SHOW TABLE STATUS LIKE 'empresa_nueva';