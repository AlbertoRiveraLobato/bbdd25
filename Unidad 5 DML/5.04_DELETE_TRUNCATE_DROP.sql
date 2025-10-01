
-- =============================================
-- 04_DELETE_TRUNCATE_DROP.sql
-- =============================================
-- Ejemplo de uso de DELETE, TRUNCATE y DROP en MySQL/MariaDB.
-- Contenido:
--   - Creación de base de datos y tablas necesarias.
--   - Ejemplos de sentencias correctas de borrado y eliminación.
--   - Ejemplos de sentencias erróneas y explicación de los errores más comunes.

-- =============================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS
-- =============================================

-- Crear base de datos para los ejemplos de DELETE, TRUNCATE y DROP

-- Crear tabla empresa con campos básicos
CREATE TABLE IF NOT EXISTS empresas (
    idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    ciudad VARCHAR(50),
    pais VARCHAR(50)
);

-- Crear tabla temporal para ejemplos de TRUNCATE y DROP
CREATE TABLE IF NOT EXISTS temporal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dato VARCHAR(50)
);

-- Insertar datos de ejemplo en la tabla empresa
-- Datos: ('PRYCA', 'San Fernando', 'España'), ('CARREFOUR', 'San Fernando', 'España'), ('ALCAMPO', 'Madrid', 'España'), ('LIDL', 'Berlín', 'Alemania')
INSERT INTO empresas (nombre, ciudad, pais) VALUES 
('PRYCA', 'San Fernando', 'España'),
('CARREFOUR', 'San Fernando', 'España'),
('ALCAMPO', 'Madrid', 'España'),
('LIDL', 'Berlín', 'Alemania');

-- Insertar datos de ejemplo en la tabla temporal
-- Datos: ('Dato1'), ('Dato2'), ('Dato3')
INSERT INTO temporal (dato) VALUES ('Dato1'), ('Dato2'), ('Dato3');

-- =============================================
-- EJEMPLOS DE USO CORRECTO
-- =============================================

-- DELETE: elimina registros específicos que cumplen una condición.
-- Elimina la empresa llamada 'ALCAMPO' de la tabla.
DELETE FROM empresas WHERE nombre = 'ALCAMPO';

-- DELETE con múltiples condiciones usando AND.
-- Elimina todas las empresas que estén en Madrid O sean de España.
DELETE FROM empresas WHERE ciudad = 'Madrid' OR pais = 'España';
-- Elimina todas las empresas que estén en Madrid Y sean de España.
DELETE FROM empresas WHERE ciudad = 'Madrid' AND pais = 'España';
-- DELETE con LIMIT: eliminar solo un número específico de registros
-- Elimina máximo 1 empresa que sea de España
DELETE FROM empresas WHERE pais = 'España' LIMIT 1;


-- TRUNCATE: elimina TODOS los registros de una tabla de forma rápida.
-- Vacía completamente la tabla temporal, reiniciando el AUTO_INCREMENT.
TRUNCATE TABLE temporal;

-- DROP: elimina la tabla por completo (estructura y datos).
-- Borra definitivamente la tabla temporal. Ya no existirá en la base de datos.
DROP TABLE IF EXISTS temporal;

-- Recrear la tabla para mostrar la diferencia entre TRUNCATE y DELETE.
-- Volvemos a crear la tabla temporal con la misma estructura.
CREATE TABLE IF NOT EXISTS temporal (
    id INT,
    dato VARCHAR(50)
);
-- Actualiza la tabla para que id sea AUTO_INCREMENT PRIMARY KEY
ALTER TABLE temporal MODIFY COLUMN id INT AUTO_INCREMENT PRIMARY KEY;
-- otra opcion:
ALTER TABLE temporal CHANGE COLUMN id id INT AUTO_INCREMENT PRIMARY KEY;


-- Insertar nuevos datos para demostrar la diferencia entre DELETE y TRUNCATE.
-- Datos: ('X'), ('Y'), ('Z')
INSERT INTO temporal (dato) VALUES ('X'), ('Y'), ('Z');

-- Verificar diferencia: TRUNCATE vs DELETE.
-- TRUNCATE elimina TODO, DELETE solo lo que cumple la condición.
-- Contar registros antes del DELETE
SELECT COUNT(*) as registros_antes_delete FROM temporal;
-- Eliminar solo el registro con dato = 'X'
DELETE FROM temporal WHERE dato = 'X';
-- Contar registros después del DELETE (debería quedar 2: 'Y' y 'Z')
SELECT COUNT(*) as registros_despues_delete FROM temporal;

-- =============================================
-- EJEMPLOS ADICIONALES
-- =============================================



-- DELETE con subconsulta: eliminar basado en otra tabla
-- (Ejemplo teórico - requeriría otra tabla)
-- DELETE FROM empresa WHERE idEmpresa IN (SELECT id FROM otra_tabla WHERE condicion);

-- Diferencia entre TRUNCATE y DELETE FROM (sin WHERE)
-- TRUNCATE es más rápido, reinicia AUTO_INCREMENT
-- DELETE FROM sin WHERE es más lento, mantiene AUTO_INCREMENT

-- =============================================
-- EJEMPLOS DE SENTENCIAS ERRÓNEAS Y EXPLICACIÓN
-- =============================================

-- Error 1: Olvidar WHERE en DELETE (¡MUY PELIGROSO!)
-- DELETE FROM empresa; -- ¡Elimina TODOS los registros de la tabla!

-- Error 2: TRUNCATE con restricciones FOREIGN KEY
-- Si temporal tuviera claves foráneas, TRUNCATE fallaría con error
-- TRUNCATE no puede usarse en tablas referenciadas por FOREIGN KEY

-- Error 3: DROP de tabla inexistente sin IF EXISTS
-- DROP TABLE tabla_que_no_existe; -- Error: tabla no encontrada

-- Error 4: Intentar usar tabla después de DROP
-- SELECT * FROM temporal; -- Error si la tabla fue eliminada con DROP

-- Error 5: DELETE con sintaxis incorrecta
-- DELETE empresa WHERE nombre = 'PRYCA'; -- Error: falta FROM

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
