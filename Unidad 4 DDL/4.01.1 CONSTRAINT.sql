-- Las restricciones SQL se utilizan para especificar reglas para los datos de una tabla.
-- Se pueden especificar cuando se crea la tabla (CREATE TABLE), o después de haber creado la tabla (ALTER TABLE).

-- Crear una tabla con una restricción CHECK para asegurar que el precio sea mayor que 0
CREATE TABLE Productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre_producto VARCHAR(100) NOT NULL,
    part_number_producto VARCHAR(10) UNIQUE,
    precio_producto DECIMAL(10, 2) CHECK (precio_producto > 0),
    tipo_producto ENUM('Limpieza', 'Bricolaje', 'No especificado') NOT NULL DEFAULT 'Limpieza',
    fk_proveedor_id INT,
    CREATE INDEX idx_pn ON Productos (part_number_producto),
    FOREIGN KEY (fk_proveedor_id) REFERENCES Proveedores(id_proveedor)
);


-- crea una tabla llamada "Productos" con una restricción CHECK que asegura que el precio de los productos sea siempre mayor que cero.
CREATE TABLE Productos (
    producto_id INT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10, 2),
    CONSTRAINT precio_positivo CHECK (precio > 0)


-- Crear una tabla con una restricción CHECK para asegurar que el precio sea mayor que 0
CREATE TABLE Productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2),
    CHECK (precio > 0)
);

-- Creación de la tabla empleados con todas las restricciones 
CREATE TABLE empleados ( 
    -- Declaraciones de columna y restricciones de column
    id INT PRIMARY KEY AUTO_INCREMENT, 
    nombre VARCHAR(50) NOT NULL,
    correo VARCHAR(100) UNIQUE, a 
    salario DECIMAL(10, 2), 
    fecha_contratacion DATE DEFAULT (CURRENT_DATE), 
    departamento_id INT, 
    
    -- RESTRICCIONES DE TABLA. 
    CONSTRAINT chk_salario_positivo CHECK (salario > 0), 
    
    CONSTRAINT fk_departamento FOREIGN KEY (departamento_id) REFERENCES departamentos(id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE ); 


-- Creación de la tabla empleados con todas las restricciones
CREATE TABLE empleados (
    -- Declaraciones de columna 
	id INT, 
	nombre VARCHAR(50), 
	correo VARCHAR(100), 
	salario DECIMAL(10, 2), 
	fecha_contratacion DATE, 
	FOREIGN KEY (departamento_id) REFERENCES departamentos(id) -- Restricción de columna 

    -- Restricciones a nivel de tabla (no de columna) 
	-- 1. Clave primaria compuesta (ejemplo alternativo) 
	CONSTRAINT pk_empleado_departamento PRIMARY KEY (id, departamento_id), 
	-- 2. Restricción UNIQUE compuesta (nombre + correo) 
	CONSTRAINT uk_nombre_correo UNIQUE (nombre, correo), 
	-- 3. Restricción de nombre completo (no solo espacios) 
	CONSTRAINT chk_nombre_valido CHECK ( 
		nombre IS NOT NULL AND 
		TRIM(nombre) != ‘’ AND 
		nombre NOT LIKE '% %' AND 
		nombre = TRIM(nombre) ),
    -- 4. Restricción de salario positivo 
	CONSTRAINT chk_salario CHECK (salario > 0), 
	);

-- =============================================================
-- ERRORES COMUNES Y MALAS PRÁCTICAS EN CONSTRAINT (MySQL)
-- =============================================================
-- A continuación se muestran ejemplos de comandos incorrectos o confusos que suelen causar errores o comportamientos inesperados en MySQL.

-- Error: Usar nombres de restricción duplicados en la misma base de datos.
-- CONSTRAINT uk_nombre_correo UNIQUE (nombre, correo),
-- Comentario: El nombre de la restricción debe ser único en la base de datos.

-- Error: Definir una restricción CHECK en versiones antiguas de MySQL (antes de 8.0).
-- CONSTRAINT chk_salario CHECK (salario > 0),
-- Comentario: En versiones anteriores a 8.0, MySQL ignora las restricciones CHECK.

-- Error: Usar ON DELETE CASCADE en una clave foránea sin entender su efecto.
-- FOREIGN KEY (departamento_id) REFERENCES departamentos(id) ON DELETE CASCADE
-- Comentario: ON DELETE CASCADE elimina automáticamente los registros hijos al borrar el padre. Úsalo solo si realmente lo necesitas.

-- Error: Olvidar asociar la restricción a la columna o tabla correcta.
-- CONSTRAINT fk_departamento FOREIGN KEY (departamento_id)
-- Comentario: Asegúrate de que la restricción hace referencia a columnas existentes y correctas.

-- Error: Usar palabras reservadas como nombre de restricción.
-- CONSTRAINT `select` UNIQUE (nombre)
-- Comentario: Evita usar palabras reservadas de SQL como nombres de restricciones.
