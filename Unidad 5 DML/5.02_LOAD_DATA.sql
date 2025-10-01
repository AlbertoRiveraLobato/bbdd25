
-- =============================================
-- 02_LOAD_DATA.sql
-- =============================================
-- Importación de datos CSV usando MySQL Workbench (Interfaz Gráfica)
-- Contenido:
--   - Creación de base de datos y tablas necesarias.
--   - Proceso paso a paso para importar CSV con MySQL Workbench.
--   - Formatos de archivos CSV requeridos.
--   - Alternativas de importación.

-- =============================================
-- CREACIÓN DE BASE DE DATOS Y TABLAS
-- =============================================

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    departamento VARCHAR(50),
    salario DECIMAL(10,2),
    fecha_contratacion DATE
);

-- =============================================
-- MÉTODO 1: IMPORTAR CSV CON SQLITEONLINE.COM (MÁS SIMPLE)
-- =============================================

-- PASO 1: Preparar el archivo CSV
-- Crea el archivo productos.csv (debe tener el nombre de la tabla y los datos) con el siguiente contenido:
        -- id,nombre,precio
        -- 1,"Ratón",12.50
        -- 2,"Teclado",25.00
        -- 3,"Monitor",150.99
        -- 4,"Altavoces",35.75

-- PASO 2: Importar en SQLiteOnline
-- 1). Ve al sitio web: https://sqliteonline.com/
-- 2). Pulsa el botón "Import" (parte superior)
-- 3). Selecciona el archivo productos.csv
-- 4). En la opción "Nombre columna" selecciona "Usar primera fila como nombres de columna"
-- 5). En la opción "Comando" selecciona "Muestra código" (por si tuvieras ya creada la tabla, 
--     elimina la parte de creación de tabla)
-- 6). Haz clic en "Import"

-- PASO 3: Verificar la importación
-- SELECT * FROM productos;

-- =============================================
-- MÉTODO 2: IMPORTAR CSV CON MYSQL WORKBENCH (RECOMENDADO)
-- =============================================

-- PASO 1: Preparar el archivo CSV
-- Crea el archivo productos.csv en C:\Windows\Temp\ con el siguiente contenido:
        -- id,nombre,precio
        -- 1,"Ratón",12.50
        -- 2,"Teclado",25.00
        -- 3,"Monitor",150.99
        -- 4,"Altavoces",35.75

-- PASO 2: Usar Table Data Import Wizard en MySQL Workbench
-- 1). En MySQL Workbench, conéctate a tu servidor
-- 2). En el panel izquierdo (Navigator), expande tu base de datos "ejemplo_load_data"
-- 3). Haz clic derecho sobre la tabla "productos"
-- 4). Selecciona "Table Data Import Wizard"
-- 5). En la ventana que se abre:
--     a) Selecciona "Import from Self-Contained File"
--     b) Busca y selecciona tu archivo: C:\Windows\Temp\productos.csv
--     c) En "Destination", selecciona "Use existing table: ejemplo_load_data.productos"
--     d) Haz clic en "Next"

-- PASO 3: Configurar columnas
-- 6). En la siguiente pantalla verás las columnas del CSV:
--     a) Verifica que las columnas coincidan: id -> id, nombre -> nombre, precio -> precio
--     b) Si necesitas omitir alguna columna, desmarca la casilla correspondiente
--     c) Haz clic en "Next"

-- PASO 4: Importar datos
-- 7). Revisa el resumen de la importación
-- 8). Haz clic en "Next" para iniciar la importación
-- 9). Una vez completado, verás un resumen con el número de filas importadas
-- 10). Haz clic en "Finish"

-- PASO 5: Verificar la importación
SELECT * FROM productos;

-- =============================================
-- MÉTODO 3: IMPORTAR EMPLEADOS CON WORKBENCH
-- =============================================

-- PASO 1: Preparar el archivo empleados.csv
-- Crea el archivo empleados.csv en C:\Windows\Temp\ con el siguiente contenido:
        -- nombre,apellido,email,departamento,salario,fecha_contratacion
        -- "Juan","Pérez","juan@empresa.com","IT",45000.00,"2023-01-15"
        -- "María","García","maria@empresa.com","Ventas",38000.50,"2023-02-20"
        -- "Carlos","López","carlos@empresa.com","IT",50000.00,"2023-03-10"
        -- "Ana","Martín","ana@empresa.com","RRHH",42000.75,"2023-01-25"

-- PASO 2: Repetir el proceso del Table Data Import Wizard
-- 1). Haz clic derecho sobre la tabla "empleados"
-- 2). Selecciona "Table Data Import Wizard"
-- 3). Selecciona el archivo empleados.csv
-- 4). Configura las columnas (omite la columna 'id' ya que es AUTO_INCREMENT)
-- 5). Importa los datos

-- PASO 3: Verificar la importación
SELECT * FROM empleados;

-- =============================================
-- MÉTODO 4: USANDO EL MENÚ SERVER (ALTERNATIVO)
-- =============================================

-- PASO 1: Desde el menú principal de MySQL Workbench
-- 1). Ve al menú "Server" > "Data Import"
-- 2). Selecciona "Import from Self-Contained File"
-- 3). Busca tu archivo CSV
-- 4). En "Default Target Schema" selecciona "ejemplo_load_data"
-- 5). Haz clic en "Start Import"

-- Nota: Este método puede requerir que el CSV tenga un formato específico
-- y puede crear automáticamente las tablas si no existen.

-- =============================================
-- FORMATO CORRECTO DE ARCHIVOS CSV
-- =============================================

-- REGLAS IMPORTANTES:
-- 1). Primera fila DEBE contener los nombres de las columnas
-- 2). Usar comas (,) como separador de campos
-- 3). Usar comillas dobles (") para encerrar texto que contenga comas o espacios
-- 4). Las fechas deben estar en formato YYYY-MM-DD
-- 5). Los números decimales usar punto (.) no coma
-- 6). Codificación recomendada: UTF-8
-- 7). Extensión del archivo: .csv

-- EJEMPLO DE CSV CORRECTO:
-- id,nombre,precio
-- 1,"Producto con, coma",25.50
-- 2,"Producto normal",15.99

-- EJEMPLO DE CSV INCORRECTO:
-- 1;Producto;25,50  -- Usa punto y coma y coma decimal (Europa)

-- =============================================
-- SOLUCIÓN A PROBLEMAS COMUNES
-- =============================================

-- PROBLEMA 1: "Error importing data"
-- SOLUCIÓN: Verificar que los tipos de datos coincidan
-- - Números en campos numéricos
-- - Fechas en formato YYYY-MM-DD
-- - Texto en campos VARCHAR

-- PROBLEMA 2: "Duplicate entry for key PRIMARY"
-- SOLUCIÓN: 
-- - Omitir la columna ID si es AUTO_INCREMENT
-- - O vaciar la tabla antes: TRUNCATE TABLE productos;

-- PROBLEMA 3: "Data too long for column"
-- SOLUCIÓN: Aumentar el tamaño del campo VARCHAR o TEXT

-- PROBLEMA 4: Caracteres especiales (acentos, ñ)
-- SOLUCIÓN: Guardar el CSV con codificación UTF-8

-- =============================================
-- VERIFICACIÓN Y LIMPIEZA DE DATOS
-- =============================================

-- Contar registros importados
SELECT COUNT(*) as total_productos FROM productos;
SELECT COUNT(*) as total_empleados FROM empleados;

-- Verificar datos específicos
SELECT * FROM productos WHERE precio > 100;
SELECT * FROM empleados WHERE departamento = 'IT';

-- Limpiar tabla si necesitas reimportar
-- TRUNCATE TABLE productos;
-- TRUNCATE TABLE empleados;

-- =============================================
-- FIN DEL ARCHIVO
-- =============================================
