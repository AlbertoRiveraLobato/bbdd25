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

