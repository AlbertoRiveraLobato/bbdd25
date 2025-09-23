-- =============================================================
-- EJEMPLOS DE CREATE DATABASE (MySQL)
-- =============================================================
-- Sintaxis básica:
-- CREATE DATABASE [IF NOT EXISTS] nombre_base_de_datos
-- [CHARACTER SET conjunto_de_caracteres]
-- [COLLATE intercalación]
-- [OWNER 'usuario']  -- No soportado en MySQL
-- [LOCATION 'ruta']  -- No soportado en MySQL
-- [COMMENT 'comentario']  -- No soportado en MySQL
-- ;
-- Notas:
-- - El nombre de la base de datos debe ser único dentro del servidor de bases de datos.
-- - CHARACTER SET y COLLATE son opcionales y definen el conjunto de caracteres y la intercalación (collation) para la base de datos.
-- - IF NOT EXISTS evita un error si la base de datos ya existe.
-- - OWNER, LOCATION y COMMENT son opciones que no son soportadas por MySQL, pero sí por otros SGBD como PostgreSQL.    
-- =============================================================

-- Mostrar la base de datos actual
SELECT DATABASE();
-- Cambiar a una base de datos existente
USE comandos;
 
-- Ver DDBB en el sistema
SHOW DATABASES;

-- Crear una base de datos simple
CREATE DATABASE MiBaseDeDatos;

-- Crear una base de datos con un conjunto de caracteres específico
CREATE DATABASE MiBaseDeDatos CHARSET utf8mb4;

-- Crear una base de datos con un conjunto de caracteres y una intercalación específicos (comparación, ordenación...)
CREATE DATABASE MiBaseDeDatos CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Crear una base de datos si no existe
CREATE DATABASE IF NOT EXISTS MiBaseDeDatos;

-- Crear una base de datos con una ubicación específica para el almacenamiento de datos (para sistemas que soportan esta opción)
CREATE DATABASE MiBaseDeDatos LOCATION '/ruta/a/mi/directorio';

-- Crear una base de datos con un propietario específico (para sistemas que soportan esta opción)
CREATE DATABASE MiBaseDeDatos OWNER 'usuario';

-- Crear una base de datos con un comentario descriptivo (para sistemas que soportan esta opción)
CREATE DATABASE MiBaseDeDatos COMMENT 'Esta es mi base de datos de prueba';

-- Todo junto
CREATE DATABASE IF NOT EXISTS MiBaseDeDatos
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci
OWNER 'usuario'
LOCATION '/ruta/a/mi/directorio'
COMMENT 'Esta es mi base de datos de prueba';

-- Usar la base de datos especificada como la base de datos por defecto
USE MiBaseDeDatos;



-- =============================================================
-- ERRORES COMUNES Y MALAS PRÁCTICAS EN CREATE DATABASE (MySQL)
-- =============================================================
-- A continuación se muestran ejemplos de comandos incorrectos o confusos que suelen causar errores o comportamientos inesperados en MySQL.

-- Error: Usar CREATE DATABASE sin privilegios suficientes.
-- CREATE DATABASE otraBase;
-- Comentario: Si el usuario no tiene privilegios de creación, MySQL dará un error de permisos.

-- Error: Intentar crear una base de datos que ya existe sin IF NOT EXISTS.
-- CREATE DATABASE MiBaseDeDatos;
-- Comentario: Si la base de datos ya existe, MySQL dará error. Usa IF NOT EXISTS para evitarlo.

-- Error: Especificar opciones no soportadas por MySQL (por ejemplo, OWNER o LOCATION).
-- CREATE DATABASE MiBaseDeDatos OWNER 'usuario';
-- Comentario: MySQL no soporta la opción OWNER. Solo algunos SGBD como PostgreSQL la aceptan.

-- Error: Usar un nombre de base de datos con caracteres no permitidos.
-- CREATE DATABASE 'mi-base';
-- Comentario: MySQL no permite guiones ni comillas en los nombres de bases de datos. Usa solo letras, números y guiones bajos.

-- Error: Olvidar el punto y coma al final de la instrucción.
-- CREATE DATABASE MiBaseDeDatos
-- Comentario: MySQL espera un punto y coma (;) al final de cada instrucción.
