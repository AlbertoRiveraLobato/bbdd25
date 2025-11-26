-- =============================================================
-- EJERCICIO MIXTO: CONSULTAS MULTITABLA Y DIFICULTAD PROGRESIVA
-- =============================================================
-- Contexto: Base de datos de una empresa de gestión de proyectos
-- Tablas principales:
--   - empleados (id_empleado, nombre, salario, id_departamento)
--   - departamentos (id_departamento, nombre_dept, ubicacion)
--   - proyectos (id_proyecto, nombre_proyecto, presupuesto, id_departamento)
--   - asignaciones (id_asignacion, id_empleado, id_proyecto, fecha_inicio, fecha_fin)
--   - jerarquia (id_empleado, id_jefe) -- relación reflexiva: cada empleado puede tener un jefe (que también es empleado)
--   - log (id_log, accion, tabla_afectada, fecha_accion) -- para triggers
-- Relaciones:
--   - Un empleado pertenece a un departamento
--   - Un proyecto está asignado a un departamento
--   - Un empleado puede estar asignado a varios proyectos (N:M mediante asignaciones)
--   - Un empleado puede tener un jefe (relación reflexiva en jerarquia)

-- =============================
-- ENUNCIADOS PARA RESOLVER
-- =============================
/*
-- DDL: CREACIÓN DE TABLAS
1) Crea las tablas empleados (sin campo email, con salario tipo INT, sin restricciones de jerarquía), departamentos, proyectos, asignaciones, jerarquia y log, sin definir las claves foráneas.
2) Añade las claves foráneas necesarias para mantener la integridad referencial.
3) Vacía la tabla proyectos sin eliminar su estructura (aunque ahora no tenga aún datos).
4) Renombra la tabla asignaciones a tareas_empleados.

-- DDL: MODIFICACIÓN DE ESTRUCTURA
5) Añade un campo email a la tabla empleados, que no pueda ser nulo.
6) Modifica la tabla proyectos para que el presupuesto tenga un valor por defecto de 0.
7) Elimina el campo ubicación de la tabla departamentos.
8) Cambia el tipo de dato del campo salario en empleados a DECIMAL(12,2).
9) Añade una restricción para que un empleado no pueda ser su propio jefe en la tabla jerarquia.

-- DDL: TRIGGERS
10) Crea un trigger vacío.
11) Elimina dicho trigger vacío.
12) Crea un trigger que registre en una tabla log cada vez que se inserte un nuevo empleado.
13) Crea un trigger que impida insertar proyectos con presupuesto negativo.
14) Crea un trigger que impida introducir un empleado cuyo jefe sea a su vez subordinado suyo (evitar ciclos directos en jerarquía).

-- DML: INSERCIÓN Y MODIFICACIÓN DE DATOS
15) Inserta 3 empleados, 2 departamentos y 2 proyectos, yasigna a cada empleado al menos un proyecto mediante la tabla de asignaciones.
16) Pon el contador de AUTO_INCREMENT de la tabla proyectos a 100.
17) Inserta nuevamente los 2 proyectos.
18) Modifica el salario de un empleado concreto: Ana a 2500.
19) Elimina un proyecto y todas sus tareas: proyecto con id_proyecto = 100.
20) Inserta relaciones jefe-empleado en la tabla jerarquia (al menos dos niveles de jerarquía).
21) Actualiza el email de un empleado concreto usando REPLACE.
22) Inserta o actualiza un empleado usando INSERT INTO ... ON DUPLICATE KEY UPDATE.
23) Haz una copia de la tabla empleados, llamada empleados_backup, que incluya todos los datos, y después vacía la tabla empleados, y vuelve a pegar en ella los datos desde empleados_backup.

-- CONSULTAS UNITABLA
24) Lista todos los empleados ordenados por salario descendente.
25) Muestra cuantos empleados hay en cada departamento, incluyendo los departamentos sin empleados.
26) Lista los proyectos según su presupuesto, y clasifícalos: inferior o mayor a 50.000.
27) Lista los empleados cuyo nombre empiece por 'A'.
28) Lista los jefes y cuántos empleados tienen a su cargo, y ordénalos de mayor a menor.

-- CONSULTAS MULTITABLA
29) Muestra los empleados y el nombre de su departamento.
30) Muestra los empleados asignados a cada proyecto, incluyendo fechas de asignación.
31) Consulta los empleados que no tienen ningún proyecto asignado.
32) Muestra el total de presupuesto gestionado por cada departamento.
33) Muestra la cadena de mando completa de un empleado (empleado, jefe directo, jefe del jefe, ...).
34) Lista los empleados junto con el nombre de su jefe (si lo tienen).
*/

-- =============================
-- SOLUCIONES A LOS ENUNCIADOS
-- =============================
-- Previamente, creamos la base de datos y usamos esa base:
DROP DATABASE IF EXISTS ejercicio_700_10_1;
CREATE DATABASE IF NOT EXISTS ejercicio_700_10_1;
USE ejercicio_700_10_1;


-- DDL: CREACIÓN DE TABLAS
-- 1) Crea las tablas empleados (sin campo email, con salario tipo INT, sin restricciones de jerarquía), departamentos, proyectos, asignaciones, jerarquia y log, sin definir las claves foráneas.

CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    salario INT,
    id_departamento INT
);
CREATE TABLE departamentos (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_dept VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(50)
);
CREATE TABLE proyectos (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_proyecto VARCHAR(100) NOT NULL,
    presupuesto INT,
    id_departamento INT
);
CREATE TABLE asignaciones (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT,
    id_proyecto INT,
    fecha_inicio DATE,
    fecha_fin DATE
);
CREATE TABLE jerarquia (
    id_empleado INT,
    id_jefe INT
);
CREATE TABLE log (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    accion VARCHAR(100),
    tabla_afectada VARCHAR(50),
    fecha_accion DATETIME
);

-- 2) Añade las claves foráneas necesarias para mantener la integridad referencial.
ALTER TABLE empleados ADD CONSTRAINT fk_empleado_departamento FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento);
ALTER TABLE proyectos ADD CONSTRAINT fk_proyecto_departamento FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento);
ALTER TABLE asignaciones ADD CONSTRAINT fk_asignacion_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado);
ALTER TABLE asignaciones ADD CONSTRAINT fk_asignacion_proyecto FOREIGN KEY (id_proyecto) REFERENCES proyectos(id_proyecto);
ALTER TABLE jerarquia ADD CONSTRAINT fk_jerarquia_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado);
ALTER TABLE jerarquia ADD CONSTRAINT fk_jerarquia_jefe FOREIGN KEY (id_jefe) REFERENCES empleados(id_empleado);

-- 3) Vacía la tabla proyectos sin eliminar su estructura (aunque ahora no tenga aún datos).
TRUNCATE TABLE proyectos; -- vacía la tabla y reinicia el AUTO_INCREMENT.
	-- Da error por tener FK .
    -- OPCIONES:
		-- 1) DESACTIVAR la protección por restricción de FK
			SET FOREIGN_KEY_CHECKS = 0;
			TRUNCATE TABLE proyectos;
			SET FOREIGN_KEY_CHECKS = 1;
			
		-- 2) Desactivar la protección safe_updates y usar delete sin clave: lo más recomendable.
			DELETE FROM proyectos;  -- da error por safe_mode
				SET SQL_SAFE_UPDATES = 0;
				DELETE FROM proyectos;
				SET SQL_SAFE_UPDATES = 1;
                
                -- y reseteamos el contador
                ALTER TABLE proyectos AUTO_INCREMENT = 1;
                
		-- 3) modificar la restricción para que tenga ON DELETE CASCADE.
			ALTER TABLE asignaciones
				DROP FOREIGN KEY fk_asignacion_proyecto,
                
				ADD CONSTRAINT fk_new_asignacion_proyecto
				FOREIGN KEY (id_proyecto) REFERENCES proyectos(id_proyecto)
				ON DELETE CASCADE;
        
			TRUNCATE TABLE proyectos; -- Sigue dando error, porque TRUNCATE no es un DELETE normal, 
									  -- sino que internamente se trata como un DROP + CREATE de la tabla, 
									  -- y MySQL lo bloquea para preservar la integridad referencial.
        


-- 4) Renombra la tabla asignaciones a tareas_empleados.
RENAME TABLE asignaciones TO tareas_empleados;

-- 5) Añade un campo email a la tabla empleados, que no pueda ser nulo.
ALTER TABLE empleados ADD COLUMN email VARCHAR(100) NOT NULL;

-- 6) Modifica la tabla proyectos para que el presupuesto tenga un valor por defecto de 0.
ALTER TABLE proyectos MODIFY COLUMN presupuesto INT DEFAULT 0;

-- 7) Elimina el campo ubicación de la tabla departamentos.
ALTER TABLE departamentos DROP COLUMN ubicacion;

-- 8) Cambia el tipo de dato del campo salario en empleados a DECIMAL(12,2).
ALTER TABLE empleados MODIFY COLUMN salario DECIMAL(12,2);

-- 9) Añade una restricción para que un empleado no pueda ser su propio jefe en la tabla jerarquia.
ALTER TABLE jerarquia ADD CONSTRAINT chk_no_autojefe CHECK (id_empleado <> id_jefe);

-- 10) Crea un trigger vacío.
DELIMITER //
CREATE TRIGGER trigger_vacio BEFORE INSERT ON empleados
FOR EACH ROW
BEGIN
    -- No hace nada
END;//
DELIMITER ;

-- 11) Elimina dicho trigger vacío.
DROP TRIGGER IF EXISTS trigger_vacio;

-- 12) Crea un trigger que registre en una tabla log cada vez que se inserte un nuevo empleado.
DELIMITER //
CREATE TRIGGER log_insert_empleado AFTER INSERT ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO log (accion, tabla_afectada, fecha_accion)
    VALUES ('INSERT', 'empleados', NOW());
END;//
DELIMITER ;

-- 13) Crea un trigger que impida insertar proyectos con presupuesto negativo.
DELIMITER //
CREATE TRIGGER check_presupuesto_proyecto BEFORE INSERT ON proyectos
FOR EACH ROW
BEGIN
    IF NEW.presupuesto < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite presupuesto negativo';
    END IF;
END;//
DELIMITER ;

-- 14) Crea un trigger que impida introducir un empleado cuyo jefe sea a su vez subordinado suyo (evitar ciclos directos en jerarquía).
DELIMITER //
CREATE TRIGGER check_ciclo_jerarquia BEFORE INSERT ON jerarquia
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM jerarquia WHERE id_empleado = NEW.id_jefe AND id_jefe = NEW.id_empleado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite ciclo directo en jerarquía';
    END IF;
END;//
DELIMITER ;

-- 15) Inserta 3 empleados, 2 departamentos y 2 proyectos, y asigna a cada empleado al menos un proyecto mediante la tabla de asignaciones.
INSERT INTO departamentos (nombre_dept) VALUES ('Ventas'), ('IT');
INSERT INTO empleados (nombre, salario, id_departamento, email) VALUES ('Ana', 2000, 1, 'ana@empresa.com'), ('Luis', 1800, 2, 'luis@empresa.com'), ('Marta', 2200, 1, 'marta@empresa.com');
INSERT INTO proyectos (nombre_proyecto, presupuesto, id_departamento) VALUES ('Web', 50000, 2), ('CRM', 30000, 1);
INSERT INTO tareas_empleados (id_empleado, id_proyecto, fecha_inicio, fecha_fin) VALUES (1, 1, '2025-01-01', '2025-06-01'), (2, 2, '2025-02-01', '2025-07-01'), (3, 1, '2025-03-01', '2025-08-01');

-- 16) Pon el contador de AUTO_INCREMENT de la tabla proyectos a 100.
ALTER TABLE proyectos AUTO_INCREMENT = 100;

-- 17)  Inserta nuevamente los 2 proyectos.
INSERT INTO proyectos (nombre_proyecto, presupuesto, id_departamento) VALUES ('Web', 50000, 2), ('CRM', 30000, 1);

-- 18) Modifica el salario de un empleado concreto: Ana a 2500.
UPDATE empleados SET salario = 2500 WHERE nombre = 'Ana'; -- da error porque el nombre no es clave
-- OPCIONES:
    -- 1) Desactivar safe_mode
        -- SET SQL_SAFE_UPDATES = 0;
        -- UPDATE empleados SET salario = 2500 WHERE nombre = 'Ana';
        -- SET SQL_SAFE_UPDATES = 1;
    -- 2) Usar la clave primaria (id_empleado), localizando primero el id de Ana en una subconsulta intermedia:
        UPDATE empleados SET salario = 2500 WHERE id_empleado = (
            SELECT id FROM (
                SELECT id_empleado AS id FROM empleados WHERE nombre = 'Ana'
            ) AS sub
        );  
        -- lo tengo que hacer así, con subconsulta intermedia, porque MySQL no permite actualizar la misma tabla que se usa en la subconsulta directa.
           -- UPDATE empleados SET salario = 2500 WHERE id_empleado = (
            -- SELECT id_empleado AS id FROM empleados WHERE nombre = 'Ana'); -- da error porque uso la misma tabla en subconsulta directa.

-- 19) Elimina un proyecto y todas sus tareas: proyecto con id_proyecto = 100.
DELETE FROM tareas_empleados WHERE id_proyecto = 100;
DELETE FROM proyectos WHERE id_proyecto = 100;

-- 20) Inserta relaciones jefe-empleado en la tabla jerarquia (al menos dos niveles de jerarquía).
INSERT INTO jerarquia (id_empleado, id_jefe) VALUES (2, 1), (3, 2);

-- 21) Actualiza el email de un empleado concreto usando REPLACE.
REPLACE INTO empleados (id_empleado, nombre, salario, id_departamento, email) VALUES (1, 'Ana', 2500, 1, 'ana.nuevo@empresa.com');
    -- esto me da error "Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`ejercicio_700_10_1`.`tareas_empleados`, CONSTRAINT `fk_asignacion_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`))
    -- OPCIONES:
        -- 1) Desactivar la restricción FK temporalmente
            -- SET FOREIGN_KEY_CHECKS = 0;
            -- REPLACE INTO empleados (id_empleado, nombre, salario, id_departamento, email) VALUES (1, 'Ana', 2500, 1, 'ana.nuevo@empresa.com');
            -- SET FOREIGN_KEY_CHECKS = 1;

        -- 2) Usar UPDATE directamente (más recomendable)
            UPDATE empleados SET email = 'ana.nuevo@empresa.com' WHERE id_empleado = 1;

        -- 3) Utilizar insert into ... on duplicate key update
            INSERT INTO empleados (id_empleado, nombre, salario, id_departamento, email) VALUES (1, 'Ana', 2500, 1, 'ana.nuevo@empresa.com')
            ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), salario = VALUES(salario), id_departamento = VALUES(id_departamento), email = VALUES(email);   


-- 22) Inserta o actualiza un empleado usando INSERT INTO ... ON DUPLICATE KEY UPDATE.
INSERT INTO empleados (id_empleado, nombre, salario, id_departamento, email) VALUES (4, 'Carlos', 2100, 2, 'carlos@empresa.com')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), salario = VALUES(salario), id_departamento = VALUES(id_departamento), email = VALUES(email);

-- 23) Haz una copia de la tabla empleados, llamada empleados_backup, que incluya todos los datos, y después vacía la tabla empleados, y vuelve a pegar en ella los datos desde empleados_backup.
CREATE TABLE empleados_backup AS SELECT * FROM empleados;
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM empleados;
SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;

INSERT INTO empleados SELECT * FROM empleados_backup;   



-- 24) Lista todos los empleados ordenados por salario descendente.
SELECT * FROM empleados ORDER BY salario DESC;

-- 25) Muestra cuantos empleados hay en cada departamento, incluyendo los departamentos sin empleados.
SELECT d.nombre_dept, COUNT(e.id_empleado) AS num_empleados
FROM departamentos d
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
GROUP BY d.id_departamento;

-- 26) Lista los proyectos según su presupuesto, y clasifícalos: inferior o mayor a 50.000.
SELECT nombre_proyecto, presupuesto,
    CASE WHEN presupuesto > 50000 THEN 'Mayor a 50.000' ELSE 'Inferior o igual a 50.000' END AS clasificacion
FROM proyectos;

-- 27) Lista los empleados cuyo nombre empiece por 'A'.
SELECT * FROM empleados WHERE nombre LIKE 'A%';

-- 28) Lista los jefes y cuántos empleados tienen a su cargo, y ordénalos de mayor a menor.
SELECT j.id_jefe, e.nombre AS jefe, COUNT(j.id_empleado) AS num_subordinados
FROM jerarquia j
JOIN empleados e ON j.id_jefe = e.id_empleado
GROUP BY j.id_jefe
ORDER BY num_subordinados DESC;

-- 29) Muestra los empleados y el nombre de su departamento.
SELECT e.nombre AS empleado, d.nombre_dept AS departamento
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento;

-- 30) Muestra los empleados asignados a cada proyecto, incluyendo fechas de asignación.
SELECT p.nombre_proyecto, e.nombre AS empleado, t.fecha_inicio, t.fecha_fin
FROM tareas_empleados t
JOIN empleados e ON t.id_empleado = e.id_empleado
JOIN proyectos p ON t.id_proyecto = p.id_proyecto;

-- 31) Consulta los empleados que no tienen ningún proyecto asignado.
SELECT e.nombre
FROM empleados e
LEFT JOIN tareas_empleados t ON e.id_empleado = t.id_empleado
WHERE t.id_empleado IS NULL;

-- 32) Muestra el total de presupuesto gestionado por cada departamento.
SELECT d.nombre_dept, SUM(p.presupuesto) AS total_presupuesto
FROM departamentos d
LEFT JOIN proyectos p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento;

-- 33) Muestra la cadena de mando completa de un empleado (empleado, jefe directo, jefe del jefe, ...).
WITH RECURSIVE cadena_mando AS (
    SELECT id_empleado, id_jefe, 1 AS nivel
    FROM jerarquia
    WHERE id_empleado = 3
    UNION ALL
    SELECT j.id_empleado, j.id_jefe, cm.nivel + 1
    FROM jerarquia j
    INNER JOIN cadena_mando cm ON j.id_empleado = cm.id_jefe
)
SELECT cm.id_empleado, e.nombre AS empleado, cm.id_jefe, ej.nombre AS jefe, cm.nivel
FROM cadena_mando cm
LEFT JOIN empleados e ON cm.id_empleado = e.id_empleado
LEFT JOIN empleados ej ON cm.id_jefe = ej.id_empleado;

-- 34) Lista los empleados junto con el nombre de su jefe (si lo tienen).
SELECT e.nombre AS empleado, ej.nombre AS jefe
FROM empleados e
LEFT JOIN jerarquia j ON e.id_empleado = j.id_empleado
LEFT JOIN empleados ej ON j.id_jefe = ej.id_empleado;
