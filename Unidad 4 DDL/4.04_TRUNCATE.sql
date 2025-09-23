-- Vaciar todos los registros de una tabla, pero mantener su estructura
TRUNCATE TABLE comandos.empresa_nueva;

-- =============================================================
-- ERRORES COMUNES Y MALAS PRÁCTICAS EN TRUNCATE (MySQL)
-- =============================================================
-- A continuación se muestran ejemplos de comandos incorrectos o confusos que suelen causar errores o comportamientos inesperados en MySQL.

-- Error: Usar TRUNCATE en una tabla referenciada por una clave foránea activa.
-- TRUNCATE TABLE empleados;
-- Comentario: Si la tabla está referenciada por una FOREIGN KEY con restricción, MySQL puede impedir el TRUNCATE o eliminar en cascada según la configuración.

-- Error: Pensar que TRUNCATE es reversible como DELETE.
-- TRUNCATE TABLE empleados;
-- Comentario: TRUNCATE elimina todos los datos de forma irreversible y no activa triggers DELETE.

-- Error: Usar TRUNCATE en tablas temporales sin cuidado.
-- TRUNCATE TABLE temp_empleados;
-- Comentario: Aunque es válido, asegúrate de que no necesitas los datos antes de vaciar la tabla.

-- Error: Olvidar el punto y coma al final de la instrucción.
-- TRUNCATE TABLE empleados
-- Comentario: MySQL espera un punto y coma (;) al final de cada instrucción.

-- Error: Usar TRUNCATE en tablas con AUTO_INCREMENT esperando que el contador no se reinicie.
-- TRUNCATE TABLE empleados;
-- Comentario: TRUNCATE reinicia el valor AUTO_INCREMENT a 1 en MySQL.