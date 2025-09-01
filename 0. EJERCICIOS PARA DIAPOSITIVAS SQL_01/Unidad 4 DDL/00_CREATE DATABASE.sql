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