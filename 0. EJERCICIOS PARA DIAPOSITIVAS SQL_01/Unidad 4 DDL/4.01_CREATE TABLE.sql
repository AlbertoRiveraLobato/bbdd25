-- Cuando la BBDD NO está seleccionada por defecto.
CREATE TABLE comandos.empresa (
  `idEmpresa` INT NULL,
  `nombre` VARCHAR(45) NULL,
  `dirección` VARCHAR(45) NULL);



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

-- Crear una tabla con una columna de tipo ENUM para limitar los valores posibles
CREATE TABLE Empleados (
    id_empleado INT PRIMARY KEY,
    nombre_empleado VARCHAR(100) NOT NULL,
    genero ENUM('Masculino', 'Femenino', 'No especificado') NOT NULL DEFAULT 'Masculino'
);

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