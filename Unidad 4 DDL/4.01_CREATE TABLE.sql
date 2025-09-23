
-- Cuando la BBDD NO está seleccionada por defecto.
CREATE TABLE comandos.empresa (
  `idEmpresa` INT NULL,
  `nombre` VARCHAR(45) NULL,
  `dirección` VARCHAR(45) NULL)
  ;

-- Cuando la BBDD está seleccionada por defecto.
CREATE TABLE Empleados (
    ID_Empleado INT PRIMARY KEY,
    Nombre VARCHAR(255),
    Departamento VARCHAR(255)
);

-- Crear una tabla simple con una clave primaria
CREATE TABLE Estudiantes (
    id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE
);

-- Crear una tabla con una clave única para la columna codigo_curso
CREATE TABLE Cursos (
    id_curso INT PRIMARY KEY,
    nombre_curso VARCHAR(100) NOT NULL,
    codigo_curso VARCHAR(10) UNIQUE
);

-- Crear una tabla con claves foráneas que referencian a otras tablas
CREATE TABLE Inscripciones (
    id_inscripcion INT PRIMARY KEY,
    id_estudiante INT,
    id_curso INT,
    fecha_inscripcion DATE,
    FOREIGN KEY (id_estudiante) REFERENCES Estudiantes(id),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);

-- Crear una tabla con una columna autoincremental
CREATE TABLE Profesores (
    id_profesor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_profesor VARCHAR(100) NOT NULL,
    fecha_contratacion DATE
);

-- Crear una tabla con una restricción CHECK para asegurar que el precio sea mayor que 0
CREATE TABLE Productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2),
    CHECK (precio > 0)
);

-- Crear una tabla con una columna que permite valores nulos
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    email_cliente VARCHAR(100) NULL
);

-- Crear una tabla con una columna de tipo ENUM para limitar los valores posibles,
-- y que además tiene un valor por defecto y otra columna que permite NULL.
CREATE TABLE Empleados (
        id_empleado INT PRIMARY KEY AUTO_INCREMENT,
        nombre_empleado VARCHAR(100) NOT NULL,
        genero ENUM('Masculino', 'Femenino', 'No especificado') NOT NULL DEFAULT 'No especificado',
        edad INT NULL
    );
        -- y aquí tienes algunos ejemplos de inserciones válidas:
        INSERT INTO Empleados (nombre_empleado, genero, edad) VALUES
        ('Lara Ruiz', 'Femenino', 11);

        INSERT INTO Empleados (nombre_empleado, genero) VALUES
        ('Ana García', 'Femenino'),
        ('Luis Martínez', DEFAULT);

        INSERT INTO Empleados (nombre_empleado) VALUES
        ('Jorge López'),
        ('Abel Ramos');



-- crea una tabla llamada "Productos" con una restricción CHECK que asegura que el precio de los productos sea siempre mayor que cero.
CREATE TABLE Productos (
    producto_id INT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10, 2),
    CONSTRAINT precio_positivo CHECK (precio > 0)
);

-- Crear una tabla a partir de otra (incluidos los datos)
CREATE TABLE testAutores AS
  SELECT *
  FROM autores;

  -- o solo con ciertas columnas 
  CREATE TABLE testAutores2 AS
    SELECT nacionalidad, nombre
    FROM autores;

-- o sin datos, solo la estructura
CREATE TABLE testAutores3 AS
  SELECT *
  FROM autores
  WHERE 1=0;

    -- alternativa
    CREATE TABLE testAutores4 LIKE autores;

-- =============================================================
-- EJEMPLO COMPLETO: CREACIÓN DE TABLA UNIVERSIDAD
-- =============================================================
-- Este ejemplo combina:
-- - Clave primaria
-- - Clave única
-- - Clave foránea
-- - Columna autoincremental
-- - Restricción CHECK
-- - Valores por defecto
-- - Permitir nulos
-- - Columna ENUM
-- - Creación a partir de otra tabla
-- - Comentarios y formato

CREATE TABLE Universidad_Alumnos (
    id_alumno INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_nacimiento DATE DEFAULT '2000-01-01',
    genero ENUM('M', 'F', 'X') NOT NULL DEFAULT 'X',
    id_curso INT,
    nota DECIMAL(4,2) DEFAULT NULL,
    
    CONSTRAINT chk_nota CHECK (nota IS NULL OR (nota >= 0 AND nota <= 10)),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);


-- =============================================================
-- ERRORES COMUNES Y MALAS PRÁCTICAS EN CREATE TABLE (MySQL)
-- =============================================================
-- A continuación se muestran ejemplos de comandos incorrectos o confusos que suelen causar errores o comportamientos inesperados en MySQL.

-- Error: Usar CREATE TABLE con un nombre de tabla ya existente sin IF NOT EXISTS.
-- CREATE TABLE Estudiantes (...);
-- Comentario: Si la tabla ya existe, MySQL dará error. Usa IF NOT EXISTS para evitarlo.

-- Error: Definir una columna AUTO_INCREMENT sin clave primaria o índice único.
-- CREATE TABLE ejemplo (id INT AUTO_INCREMENT, nombre VARCHAR(50));
-- Comentario: MySQL requiere que AUTO_INCREMENT esté asociado a una clave primaria o índice único.

-- Error: Usar tipos de datos no soportados por MySQL (por ejemplo, SERIAL, BOOLEAN).
-- CREATE TABLE ejemplo (activo BOOLEAN);
-- Comentario: BOOLEAN en MySQL es un sinónimo de TINYINT(1). SERIAL no existe como tipo nativo.

-- Error: Definir una restricción CHECK en versiones antiguas de MySQL (antes de 8.0).
-- CREATE TABLE ejemplo (edad INT CHECK (edad > 0));
-- Comentario: En versiones anteriores a 8.0, MySQL ignora las restricciones CHECK.

-- Error: Olvidar el punto y coma al final de la instrucción.
-- CREATE TABLE ejemplo (id INT)
-- Comentario: MySQL espera un punto y coma (;) al final de cada instrucción.