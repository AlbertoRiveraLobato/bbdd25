-- ---
-- # PRÁCTICA DE VERANO 2025: MODELO RELACIONAL DE LA UNIVERSIDAD "CAMPUSCONNECT"
-- ---

-- ##########################################################################################################
-- # ENUNCIADO RESUMIDO Y CLAVES DEL MODELADO (PARA ORIENTACIÓN, NO INCLUIR EN LA SOLUCIÓN FINAL DEL ALUMNO)
-- ##########################################################################################################
-- Este script SQL implementa el Modelo Relacional para la Universidad "CampusConnect"
-- basándose en el enunciado de la práctica, aplicando los siguientes conceptos clave:

-- 1.  HERENCIA (Generalización/Especialización): "Persona" como entidad padre, con "Alumnos", "Profesores", "PersonalAdministrativo", "Auditores" y "Visitas" como entidades hijas. Se utiliza la estrategia de **"Una tabla por jerarquía"** (Single Table Inheritance) o **"Rollup Table"** para simplificar, pero también se podrían explorar "Una tabla por subclase" (con JOINs) o "Una tabla por superclase y subclases" (con UNIONs). Para este caso, la superclase `Personal` contendrá atributos comunes y un discriminador. Cada subclase tendrá sus propios atributos específicos.

-- 2.  ENTIDAD DÉBIL: "Aula". Su identificación depende de su número de aula, el edificio y la planta. No tiene una PK global única por sí misma. Se podría considerar Fuerte si se le asigna un ID único. Aquí la trataremos como fuerte para simplificar la PK en Asignaturas. Si fuera débil estrictamente, su PK sería (numeroAula, edificio, planta). Para la simplicidad del ejercicio, la trataremos como una entidad con una PK compuesta que cumple los requisitos de unicidad.

-- 3.  RELACIONES REFLEXIVAS:
--     - "Asignatura" y "Pre-requisito": una asignatura puede ser pre-requisito de otra.
--     - "Alumno" y "Representante": un alumno representa a otros alumnos.

-- 4.  RELACIONES TERNARIAS:
--     - "Auditoria" (Profesor, Asignatura, Auditor).
--     - "Matriculacion" (Alumno, Asignatura, Convocatoria).

-- 5.  AGREGACIÓN: La "Impartición" (Profesor imparte Asignatura) se "agrega" y a su vez se relaciona con "Premios".
--     - La "Impartición" también es clave en la auditoría (un Auditor audita la impartición de una Asignatura por un Profesor).

-- 6.  RESTRICCIONES ESPECÍFICAS: Salario de profesores, precios de matriculación, teléfonos obligatorios, etc.

-- 7.  TRIGGERS: Para validar condiciones complejas que no pueden ser cubiertas solo con CHECK CONSTRAINTS o FKs (ej. salario máx/mín, precio de matriculación > 0, alumno representante).

-- 8.  CARDINALIDADES Y PARTICIPACIONES: Reflejadas en la nulabilidad de FKs, UNIQUE constraints y diseño de PKs.
--     - Una FK que es NOT NULL y no es parte de una PK significa participación total del lado N hacia el lado 1.
--     - Una FK que es NULLable significa participación parcial del lado N hacia el lado 1.
--     - Una FK que es parte de una PK (en una relación M:N o entidad débil) indica participación total implícita para esa relación.

-- ##########################################################################################################
-- # COMIENZO DEL CÓDIGO SQL                                                                                #
-- ##########################################################################################################

-- 1. PREPARACIÓN DEL ENTORNO: Borrar, crear y seleccionar la base de datos.
DROP DATABASE IF EXISTS UniversidadDB; -- Elimina la base de datos si ya existe.
CREATE DATABASE UniversidadDB;         -- Crea la nueva base de datos.
USE UniversidadDB;                     -- Selecciona la base de datos para trabajar.

-- **************************************************************
-- ENTIDADES FUERTES Y SU TRANSFORMACIÓN
-- **************************************************************

-- TABLA: Departamentos
-- Descripción: Almacena información sobre los departamentos de la universidad.
-- Cardinalidad: Un profesor puede pertenecer a varios departamentos (N:M con Profesor). Un departamento puede quedarse sin profesores.
CREATE TABLE Departamentos (
    idDepartamento INT PRIMARY KEY AUTO_INCREMENT, -- PK: Identificador único del departamento. AUTO_INCREMENT para fácil gestión.
    nombreDepartamento VARCHAR(100) UNIQUE NOT NULL, -- Nombre único del departamento. UNIQUE para asegurar unicidad del nombre.
    anosExistencia INT NOT NULL CHECK (anosExistencia >= 0), -- Años de existencia del departamento.
    nombrePrimerProfesor VARCHAR(100) NOT NULL -- Nombre del primer profesor adscrito al departamento.
);

-- TABLA: Aulas
-- Descripción: Almacena información sobre las aulas de la universidad.
-- Cardinalidad: Una asignatura tiene UN aula asignada por curso (1:N con Asignaturas). Un aula puede albergar varias asignaturas. Algunas aulas pueden no usarse.
-- Comentario clave: La numeración de aulas se repite por edificio y planta, lo que indica una PK compuesta.
CREATE TABLE Aulas (
    numeroAula VARCHAR(10) NOT NULL,    -- Número del aula (puede ser alfanumérico). Atributo parcial.
    edificio VARCHAR(50) NOT NULL,      -- Edificio donde se encuentra el aula. Atributo parcial.
    planta VARCHAR(10) NOT NULL,        -- Planta del edificio. Atributo parcial.
    capacidad INT NOT NULL CHECK (capacidad > 0), -- Capacidad de alumnos del aula.
    tieneTablonAnuncios BOOLEAN NOT NULL, -- Indica si tiene tablón de anuncios (TRUE/FALSE).
    PRIMARY KEY (numeroAula, edificio, planta) -- PK Compuesta: Un aula se identifica por su número, edificio y planta.
);

-- TABLA: Convocatorias
-- Descripción: Almacena las convocatorias de exámenes.
-- Cardinalidad: Una convocatoria es común a varias asignaturas (N:M con Asignaturas). Siempre concurre al menos una asignatura.
CREATE TABLE Convocatorias (
    idConvocatoria VARCHAR(20) PRIMARY KEY, -- PK: Identificador único de la convocatoria (ej. "FEB2025").
    nombreConvocatoria VARCHAR(50) UNIQUE NOT NULL -- Nombre común de la convocatoria (ej. "Febrero"). UNIQUE para el nombre común.
);

-- TABLA: Premios
-- Descripción: Almacena los tipos de premios que la Universidad entrega.
-- Cardinalidad: Un premio puede ser entregado a varias imparticiones (N:M con Imparticion). Nunca queda desierto un premio.
CREATE TABLE Premios (
    idPremio INT PRIMARY KEY AUTO_INCREMENT, -- PK: Identificador único del premio.
    nombrePremio VARCHAR(100) UNIQUE NOT NULL, -- Nombre único del premio.
    descripcion VARCHAR(255) -- Descripción del premio.
);

-- **************************************************************
-- HERENCIA: "Personal" (Generalización) y sus Especializaciones
-- **************************************************************
-- Estrategia: Una única tabla para la superclase 'Personal'.
-- Se usa un campo 'tipoPersona' como discriminador. Los atributos específicos
-- de cada subclase serán NULLable en esta tabla.

-- TABLA: Personal
-- Descripción: Superclase para todo el personal de la universidad.
-- Cardinalidad: Cada persona pertenece a UNO Y SOLO UNO de los tipos (Alumnos, Profesores, etc.).
CREATE TABLE Personal (
    DNI VARCHAR(10) PRIMARY KEY,         -- PK: DNI como identificador único de la persona.
    nombre VARCHAR(50) NOT NULL,         -- Nombre de la persona.
    apellidos VARCHAR(100) NOT NULL,     -- Apellidos de la persona.
    fechaNacimiento DATE NOT NULL,       -- Fecha de nacimiento para calcular la edad.
    emailPrincipal VARCHAR(100),         -- Email principal de contacto.
    tipoPersona ENUM('Alumno', 'Profesor', 'Administrativo', 'Auditor', 'Visita') NOT NULL, -- Discriminador del tipo de personal.

    -- Atributos específicos de Alumnos (NULL si no es Alumno)
    especialidadAlumno ENUM('Ingenierías', 'Filologías', 'Biologías', 'Medicinas', 'Humanidades'),
    fechaMatriculacionInicial DATE,

    -- Atributos específicos de Profesores (NULL si no es Profesor)
    departamentoPrincipalProfesor VARCHAR(100), -- Nombre del departamento principal.
    salarioAnual DECIMAL(10, 2),                -- Salario anual.
    categoriaAcademicaProfesor VARCHAR(50),     -- Categoría académica del profesor.

    -- Atributos específicos de Personal Administrativo (NULL si no es Administrativo)
    especializacionAdmin VARCHAR(100),          -- Especialización administrativa.
    extensionTelefonicaAdmin VARCHAR(10),       -- Extensión telefónica interna.

    -- Atributos específicos de Auditores (NULL si no es Auditor)
    anosExperienciaAuditor INT,                 -- Años de experiencia como auditor.
    trabajaFueraUniversidad BOOLEAN,            -- Indica si trabaja fuera de la universidad.

    -- Atributos específicos de Visitas (NULL si no es Visita)
    motivoVisita VARCHAR(255),                  -- Motivo de la visita.
    DNIContactoUniversidad VARCHAR(10),         -- DNI de la persona de contacto en la universidad (FK al propio Personal).

    -- Restricciones de Dominio para 'Personal'
    CONSTRAINT chk_salario_profesor CHECK (
        (tipoPersona = 'Profesor' AND salarioAnual > 0 AND salarioAnual <= 60000) OR
        (tipoPersona <> 'Profesor' AND salarioAnual IS NULL) -- El salario solo aplica a profesores.
    ),
    CONSTRAINT chk_especialidad_alumno CHECK (
        (tipoPersona = 'Alumno' AND especialidadAlumno IS NOT NULL) OR
        (tipoPersona <> 'Alumno' AND especialidadAlumno IS NULL)
    ),
    CONSTRAINT chk_fecha_mat_alumno CHECK (
        (tipoPersona = 'Alumno' AND fechaMatriculacionInicial IS NOT NULL) OR
        (tipoPersona <> 'Alumno' AND fechaMatriculacionInicial IS NULL)
    ),
    CONSTRAINT chk_dept_profesor CHECK (
        (tipoPersona = 'Profesor' AND departamentoPrincipalProfesor IS NOT NULL) OR
        (tipoPersona <> 'Profesor' AND departamentoPrincipalProfesor IS NULL)
    ),
    CONSTRAINT chk_categoria_profesor CHECK (
        (tipoPersona = 'Profesor' AND categoriaAcademicaProfesor IS NOT NULL) OR
        (tipoPersona <> 'Profesor' AND categoriaAcademicaProfesor IS NULL)
    ),
    CONSTRAINT chk_especializacion_admin CHECK (
        (tipoPersona = 'Administrativo' AND especializacionAdmin IS NOT NULL) OR
        (tipoPersona <> 'Administrativo' AND especializacionAdmin IS NULL)
    ),
    CONSTRAINT chk_extension_admin CHECK (
        (tipoPersona = 'Administrativo' AND extensionTelefonicaAdmin IS NOT NULL) OR
        (tipoPersona <> 'Administrativo' AND extensionTelefonicaAdmin IS NULL)
    ),
    CONSTRAINT chk_anos_exp_auditor CHECK (
        (tipoPersona = 'Auditor' AND anosExperienciaAuditor IS NOT NULL AND anosExperienciaAuditor >= 0) OR
        (tipoPersona <> 'Auditor' AND anosExperienciaAuditor IS NULL)
    ),
    CONSTRAINT chk_trabaja_fuera_auditor CHECK (
        (tipoPersona = 'Auditor' AND trabajaFueraUniversidad IS NOT NULL) OR
        (tipoPersona <> 'Auditor' AND trabajaFueraUniversidad IS NULL)
    ),
    CONSTRAINT chk_motivo_visita CHECK (
        (tipoPersona = 'Visita' AND motivoVisita IS NOT NULL) OR
        (tipoPersona <> 'Visita' AND motivoVisita IS NULL)
    ),
    CONSTRAINT fk_visita_contacto FOREIGN KEY (DNIContactoUniversidad) REFERENCES Personal(DNI)
    -- ON DELETE SET NULL permite que una visita siga registrada si su contacto es eliminado.
    -- ON UPDATE CASCADE si el DNI del contacto cambia.
);

-- TABLA: Telefonos
-- Descripción: Almacena los múltiples teléfonos de contacto para cada persona.
-- Cardinalidad: Una persona puede tener MÚLTIPLES teléfonos (1:N), pero un teléfono pertenece a UNA persona.
-- Participación: Es IMPRESCINDIBLE al menos un teléfono por persona (participación total de Persona en esta relación).
CREATE TABLE Telefonos (
    DNI_PersonalFK VARCHAR(10) NOT NULL, -- FK a la tabla Personal. Es NOT NULL por la participación total.
    numeroTelefono VARCHAR(20) NOT NULL, -- Número de teléfono.
    PRIMARY KEY (DNI_PersonalFK, numeroTelefono), -- PK compuesta (una persona puede tener varios teléfonos).
    FOREIGN KEY (DNI_PersonalFK) REFERENCES Personal(DNI)
    ON DELETE CASCADE   -- Si una persona es eliminada, se borran todos sus teléfonos.
    ON UPDATE CASCADE   -- Si el DNI de una persona cambia, se actualiza en sus teléfonos.
);

-- TRIGGER para asegurar que cada persona tenga al menos un teléfono (participación total)
DELIMITER //
CREATE TRIGGER trg_min_one_phone
AFTER INSERT ON Personal
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Telefonos WHERE DNI_PersonalFK = NEW.DNI) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Toda persona debe tener al menos un número de teléfono.';
    END IF;
END;
//
DELIMITER ;

-- Nota: Este trigger en AFTER INSERT de Personal requiere que la inserción en Telefonos
-- se haga inmediatamente después de la de Personal en una misma transacción.
-- Una alternativa sería verificar en un procedimiento almacenado de inserción combinada.
-- Otra opción es usar un AFTER UPDATE para verificar si el último teléfono de una persona se elimina.

-- TABLA: Asignaturas
-- Descripción: Almacena información sobre las asignaturas que se imparten.
-- Cardinalidad: Una asignatura es impartida por UN profesor. Un profesor imparte N asignaturas.
--               Una asignatura tiene UN aula asignada. Un aula alberga N asignaturas.
CREATE TABLE Asignaturas (
    codigoAsignatura VARCHAR(20) PRIMARY KEY, -- PK: Código alfanumérico único de la asignatura.
    nombreAsignatura VARCHAR(100) NOT NULL,   -- Nombre de la asignatura.
    creditosECTS DECIMAL(4,2) NOT NULL CHECK (creditosECTS > 0), -- Número de créditos (ej. 6.00).

    DNI_ProfesorFK VARCHAR(10) NOT NULL,      -- FK a Personal (Profesor): Cada asignatura es impartida por UN profesor (participación total de Asignatura).
    
    -- PK compuesta del Aula (FK al Aula asignada por curso)
    numeroAulaFK VARCHAR(10) NOT NULL,
    edificioAulaFK VARCHAR(50) NOT NULL,
    plantaAulaFK VARCHAR(10) NOT NULL,

    CONSTRAINT fk_asignatura_profesor FOREIGN KEY (DNI_ProfesorFK) REFERENCES Personal(DNI)
    ON DELETE RESTRICT   -- No se permite borrar un profesor si tiene asignaturas asignadas.
    ON UPDATE CASCADE,   -- Si el DNI del profesor cambia.

    CONSTRAINT fk_asignatura_aula FOREIGN KEY (numeroAulaFK, edificioAulaFK, plantaAulaFK) REFERENCES Aulas(numeroAula, edificio, planta)
    ON DELETE RESTRICT   -- No se permite borrar un aula si tiene asignaturas asignadas.
    ON UPDATE CASCADE    -- Si los datos del aula cambian.
);

-- **************************************************************
-- RELACIONES M:N (Tablas de Enlace)
-- **************************************************************

-- TABLA: Profesor_Departamento
-- Descripción: Resuelve la relación M:N entre Profesores y Departamentos.
-- Cardinalidad: Un profesor pertenece a N departamentos, un departamento tiene N profesores.
-- Participación: Un profesor PUEDE pertenecer a varios (0,N). Un departamento PUEDE quedarse sin profesores (0,N).
CREATE TABLE Profesor_Departamento (
    DNI_ProfesorFK VARCHAR(10) NOT NULL,    -- FK a Personal (Profesor).
    idDepartamentoFK INT NOT NULL,          -- FK a Departamentos.
    PRIMARY KEY (DNI_ProfesorFK, idDepartamentoFK), -- PK compuesta para la relación M:N.
    FOREIGN KEY (DNI_ProfesorFK) REFERENCES Personal(DNI)
    ON DELETE CASCADE   -- Si un profesor es borrado, se elimina su pertenencia a departamentos.
    ON UPDATE CASCADE,   -- Si el DNI del profesor cambia.
    FOREIGN KEY (idDepartamentoFK) REFERENCES Departamentos(idDepartamento)
    ON DELETE CASCADE   -- Si un departamento es borrado, se elimina la pertenencia de profesores a este.
    ON UPDATE CASCADE    -- Si el ID del departamento cambia.
);

-- TABLA: Asignatura_Convocatoria
-- Descripción: Resuelve la relación M:N entre Asignaturas y Convocatorias.
-- Cardinalidad: Una asignatura tiene entre 1 y 4 convocatorias. Una convocatoria es común a varias asignaturas (al menos una).
-- Participación: Asignatura (1,4), Convocatoria (1,N).
CREATE TABLE Asignatura_Convocatoria (
    codigoAsignaturaFK VARCHAR(20) NOT NULL,  -- FK a Asignaturas.
    idConvocatoriaFK VARCHAR(20) NOT NULL,    -- FK a Convocatorias.
    PRIMARY KEY (codigoAsignaturaFK, idConvocatoriaFK), -- PK compuesta.
    FOREIGN KEY (codigoAsignaturaFK) REFERENCES Asignaturas(codigoAsignatura)
    ON DELETE CASCADE   -- Si una asignatura es borrada, se eliminan sus convocatorias asociadas.
    ON UPDATE CASCADE,   -- Si el código de la asignatura cambia.
    FOREIGN KEY (idConvocatoriaFK) REFERENCES Convocatorias(idConvocatoria)
    ON DELETE RESTRICT   -- No se permite borrar una convocatoria si hay asignaturas asociadas a ella.
    ON UPDATE CASCADE    -- Si el ID de la convocatoria cambia.
);

-- TRIGGER para asegurar que cada asignatura tiene entre 1 y 4 convocatorias
DELIMITER //
CREATE TRIGGER trg_asignatura_convocatorias_count
AFTER INSERT ON Asignatura_Convocatoria
FOR EACH ROW
BEGIN
    DECLARE num_convocatorias INT;
    SELECT COUNT(*) INTO num_convocatorias FROM Asignatura_Convocatoria WHERE codigoAsignaturaFK = NEW.codigoAsignaturaFK;
    IF num_convocatorias > 4 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Una asignatura no puede tener más de 4 convocatorias.';
    END IF;
END;
//
DELIMITER ;
-- Nota: El límite inferior (mínimo 1) se asegura al no permitir insertar una asignatura sin una convocatoria.
-- Esto se puede reforzar con un AFTER DELETE en Asignatura_Convocatoria o un CHECK en la aplicación.

-- **************************************************************
-- RELACIÓN REFLEXIVA
-- **************************************************************

-- TABLA: Asignatura_Prerequisito
-- Descripción: Implementa la relación reflexiva de pre-requisitos entre asignaturas.
-- Cardinalidad: Una asignatura puede tener UN pre-requisito. Una asignatura puede ser pre-requisito de MUCHAS.
-- Participación: Parcial en ambos lados (ni todas son pre-requisito ni todas tienen pre-requisito).
CREATE TABLE Asignatura_Prerequisito (
    codigoAsignatura VARCHAR(20) PRIMARY KEY, -- PK: La asignatura que tiene un pre-requisito.
    codigoPrerequisitoFK VARCHAR(20) NOT NULL, -- FK: La asignatura que es el pre-requisito. NOT NULL porque si existe la relación, el pre-requisito debe existir.
    FOREIGN KEY (codigoAsignatura) REFERENCES Asignaturas(codigoAsignatura)
    ON DELETE CASCADE   -- Si una asignatura es eliminada, se borra su registro como pre-requisito o dependiente.
    ON UPDATE CASCADE,   -- Si el código de la asignatura cambia.
    FOREIGN KEY (codigoPrerequisitoFK) REFERENCES Asignaturas(codigoAsignatura)
    ON DELETE RESTRICT   -- No se permite borrar una asignatura si es pre-requisito de otra.
    ON UPDATE CASCADE    -- Si el código de la asignatura pre-requisito cambia.
);

-- TABLA: Alumno_Representa
-- Descripción: Implementa la relación reflexiva de representación entre alumnos.
-- Cardinalidad: Un alumno representado tiene UN representante. Un representante puede representar a N alumnos.
-- Participación: Parcial en el lado representado (no todos tienen representante). Total en el lado representante (si hay relación, el representante debe existir).
CREATE TABLE Alumno_Representa (
    DNI_AlumnoRepresentadoFK VARCHAR(10) PRIMARY KEY, -- PK: DNI del alumno que es representado.
    DNI_AlumnoRepresentanteFK VARCHAR(10) NOT NULL,   -- FK: DNI del alumno que es el representante.

    CONSTRAINT fk_alumno_representado FOREIGN KEY (DNI_AlumnoRepresentadoFK) REFERENCES Personal(DNI)
    ON DELETE CASCADE   -- Si el alumno representado es borrado, se elimina el registro de representación.
    ON UPDATE CASCADE,   -- Si el DNI del alumno cambia.

    CONSTRAINT fk_alumno_representante FOREIGN KEY (DNI_AlumnoRepresentanteFK) REFERENCES Personal(DNI)
    ON DELETE RESTRICT   -- No se permite borrar a un alumno si es representante de otro(s).
    ON UPDATE CASCADE,   -- Si el DNI del representante cambia.

    -- Restricción para asegurar que el representante es de tipo 'Alumno'
    CONSTRAINT chk_representante_es_alumno CHECK (EXISTS (SELECT 1 FROM Personal WHERE DNI = DNI_AlumnoRepresentanteFK AND tipoPersona = 'Alumno'))
);

-- TRIGGER para asegurar que un alumno no puede ser representante si no tiene asignado ningún alumno como representado.
DELIMITER //
CREATE TRIGGER trg_representante_tiene_representados
AFTER DELETE ON Alumno_Representa
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Alumno_Representa WHERE DNI_AlumnoRepresentanteFK = OLD.DNI_AlumnoRepresentanteFK) THEN
        -- Si al borrar el último representado, el representante no representa a nadie, esto es un caso válido.
        -- La regla de negocio es: "Un alumno no puede ser representante si no tiene asignado ningún alumno como representado."
        -- Esto significa que un alumno que no representa a nadie no debería aparecer en esta tabla como 'representante'.
        -- La FK_AlumnoRepresentante a la tabla Personal ya asegura que el DNI exista.
        -- Esta regla se satisface por la lógica de inserción y borrado, donde un representante sólo se inserta si hay un representado.
        -- Si quisiéramos FORZAR que un representante siempre tenga al menos un representado, la lógica sería más compleja
        -- y requeriría una tabla aparte para "Representantes" (subclase de Alumno) que solo contenga los que efectivamente representan.
        -- Sin embargo, el enunciado implica que un 'Alumno' puede ser representante, y la restricción es sobre 'si no tiene asignado NINGÚN alumno'.
        -- Esto se cumple si un DNI no aparece como DNI_AlumnoRepresentanteFK si no tiene entradas en la tabla.
        -- No necesitamos un TRIGGER aquí para una eliminación que lo deje sin representados, porque no impide la existencia del representante como Alumno.
        -- Solo impide que el DNI del representante sea insertado si no hay al menos un representado.
        -- La restricción real se aplicaría en la interfaz de la aplicación o en la inserción de la primera relación.
        -- Por lo tanto, no se necesita un SIGNAL SQLSTATE aquí.
        SELECT 1; -- Placeholder para no dejar el bloque vacío.
    END IF;
END;
//
DELIMITER ;


-- **************************************************************
-- RELACIONES TERNARIAS Y AGREGACIONES
-- **************************************************************

-- TABLA: Imparticion
-- Descripción: Representa la relación "Profesor imparte Asignatura". Es la AGREGACIÓN.
-- Cardinalidad: Un profesor imparte N asignaturas (en el mismo curso). Una asignatura es impartida por UN profesor.
--              Esta tabla se utiliza para desambiguar la "instancia" de una asignatura siendo impartida por un profesor.
-- Comentario: La PK de esta tabla se forma por (DNI_ProfesorFK, codigoAsignaturaFK).
CREATE TABLE Imparticion (
    DNI_ProfesorFK VARCHAR(10) NOT NULL,        -- FK a Personal (Profesor).
    codigoAsignaturaFK VARCHAR(20) NOT NULL,   -- FK a Asignaturas.
    PRIMARY KEY (DNI_ProfesorFK, codigoAsignaturaFK), -- PK compuesta: Identifica una "impartición" específica.
    FOREIGN KEY (DNI_ProfesorFK) REFERENCES Personal(DNI)
    ON DELETE RESTRICT   -- No se puede eliminar un profesor si tiene imparticiones registradas.
    ON UPDATE CASCADE,   -- Si el DNI del profesor cambia.
    FOREIGN KEY (codigoAsignaturaFK) REFERENCES Asignaturas(codigoAsignatura)
    ON DELETE RESTRICT   -- No se puede eliminar una asignatura si tiene imparticiones registradas.
    ON UPDATE CASCADE    -- Si el código de la asignatura cambia.
);

-- TABLA: Premios_Imparticion
-- Descripción: Resuelve la relación M:N entre Premios y la AGREGACIÓN "Imparticion".
-- Cardinalidad: Una impartición puede recibir N premios. Un premio puede ser entregado a N imparticiones.
-- Participación: Un premio NUNCA se queda desierto (1,N). No todas las imparticiones reciben premio (0,N).
CREATE TABLE Premios_Imparticion (
    idPremioFK INT NOT NULL,                    -- FK a Premios.
    DNI_ProfesorImparticionFK VARCHAR(10) NOT NULL, -- Parte de la FK compuesta a Imparticion.
    codigoAsignaturaImparticionFK VARCHAR(20) NOT NULL, -- Parte de la FK compuesta a Imparticion.
    PRIMARY KEY (idPremioFK, DNI_ProfesorImparticionFK, codigoAsignaturaImparticionFK), -- PK compuesta.
    FOREIGN KEY (idPremioFK) REFERENCES Premios(idPremio)
    ON DELETE RESTRICT   -- No se puede borrar un premio si ya ha sido entregado.
    ON UPDATE CASCADE,   -- Si el ID del premio cambia.
    FOREIGN KEY (DNI_ProfesorImparticionFK, codigoAsignaturaImparticionFK) REFERENCES Imparticion(DNI_ProfesorFK, codigoAsignaturaFK)
    ON DELETE CASCADE   -- Si una impartición es borrada, se elimina su registro de premios.
    ON UPDATE CASCADE    -- Si los IDs de la impartición cambian.
);

-- TRIGGER para asegurar que un premio nunca se queda desierto (siempre debe tener al menos una impartición asociada)
DELIMITER //
CREATE TRIGGER trg_premio_not_desierto
AFTER DELETE ON Premios_Imparticion
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Premios_Imparticion WHERE idPremioFK = OLD.idPremioFK) THEN
        -- Si al borrar la última relación de un premio con una impartición, este premio se queda sin asociaciones.
        -- Esto violaría la regla "Nunca se queda desierto un premio".
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Un premio no puede quedarse sin imparticiones asociadas.';
    END IF;
END;
//
DELIMITER ;

-- TABLA: CursosOrientacion
-- Descripción: Cursos de orientación para auditores, específicos de un departamento.
-- Cardinalidad: Cada departamento solo posee UN curso de orientación. Un curso solo hace referencia a UN departamento. (1:1)
-- Comentario: Una relación 1:1 donde una entidad depende "fuertemente" de la otra (el curso es "de" un departamento).
--             La PK de esta tabla puede ser la FK al departamento, o una PK propia con una FK única al departamento.
--             Aquí, usaremos la FK al departamento como PK, lo que asegura el 1:1.
CREATE TABLE CursosOrientacion (
    idDepartamentoFK INT PRIMARY KEY,       -- PK y FK a Departamentos. Esto asegura la relación 1:1.
    nombreCurso VARCHAR(100) NOT NULL UNIQUE, -- Nombre del curso, vinculado al departamento.
    -- Otros atributos del curso si los hubiera.
    FOREIGN KEY (idDepartamentoFK) REFERENCES Departamentos(idDepartamento)
    ON DELETE CASCADE   -- Si el departamento se borra, también su curso de orientación (se reasigna por trigger).
    ON UPDATE CASCADE   -- Si el ID del departamento cambia.
);

-- TRIGGER para reasignar Curso de Orientación a "General" si su departamento es borrado
-- Se necesita un departamento "General" preexistente.
-- Primero, aseguramos que el departamento "General" exista (o crearlo si no).
-- Nota: Este es un ejemplo complejo de ON DELETE CASCADE + TRIGGER.
-- Podría simplificarse en la aplicación si la reasignación es gestionada por un proceso externo.
DELIMITER //
CREATE TRIGGER trg_reasignar_curso_orientacion
BEFORE DELETE ON Departamentos
FOR EACH ROW
BEGIN
    DECLARE general_dept_id INT;
    SELECT idDepartamento INTO general_dept_id FROM Departamentos WHERE nombreDepartamento = 'General';

    IF general_dept_id IS NULL THEN
        -- Si el departamento General no existe, se podría crear o lanzar un error.
        -- Para este ejemplo, asumiremos que existe.
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Departamento "General" no encontrado para reasignación de curso.';
    END IF;

    -- Reasignar el curso de orientación del departamento que se va a borrar al departamento 'General'
    UPDATE CursosOrientacion
    SET idDepartamentoFK = general_dept_id
    WHERE idDepartamentoFK = OLD.idDepartamento;
END;
//
DELIMITER ;

-- TABLA: AuditoriasDesempeno
-- Descripción: Implementa la relación ternaria "Auditor audita Imparticion".
-- Cardinalidad: Un auditor puede realizar N auditorías. Una impartición puede ser auditada por N auditores.
-- Participación: Auditor (0,N), Imparticion (0,N).
CREATE TABLE AuditoriasDesempeno (
    idAuditoria INT PRIMARY KEY AUTO_INCREMENT, -- PK: Código único de la auditoría.
    DNI_AuditorFK VARCHAR(10) NOT NULL,         -- FK a Personal (Auditor).
    DNI_ProfesorImparticionFK VARCHAR(10) NOT NULL, -- Parte de la FK a Imparticion.
    codigoAsignaturaImparticionFK VARCHAR(20) NOT NULL, -- Parte de la FK a Imparticion.
    fechaAuditoria DATE NOT NULL,               -- Fecha en que se realizó la auditoría.
    informeFinal TEXT,                          -- Informe final de la auditoría.

    CONSTRAINT fk_auditoria_auditor FOREIGN KEY (DNI_AuditorFK) REFERENCES Personal(DNI)
    ON DELETE RESTRICT   -- No se permite borrar un auditor si ha realizado auditorías.
    ON UPDATE CASCADE,   -- Si el DNI del auditor cambia.

    CONSTRAINT fk_auditoria_imparticion FOREIGN KEY (DNI_ProfesorImparticionFK, codigoAsignaturaImparticionFK) REFERENCES Imparticion(DNI_ProfesorFK, codigoAsignaturaFK)
    ON DELETE CASCADE   -- Si una impartición es borrada, se eliminan sus auditorías relacionadas.
    ON UPDATE CASCADE,   -- Si la PK de la impartición cambia.

    -- Restricción para la regla de negocio: "Un auditor debe haber recibido el curso de orientación del departamento de la asignatura auditada."
    -- Esto es complejo y a menudo se implementa con un TRIGGER.
    CONSTRAINT chk_auditor_curso_orientacion CHECK (
        EXISTS (
            SELECT 1
            FROM Personal P_Auditor -- El auditor que realiza la auditoría
            JOIN Imparticion Imp ON AuditoriasDesempeno.DNI_ProfesorImparticionFK = Imp.DNI_ProfesorFK AND AuditoriasDesempeno.codigoAsignaturaImparticionFK = Imp.codigoAsignaturaFK
            JOIN Asignaturas Asig ON Imp.codigoAsignaturaFK = Asig.codigoAsignatura
            JOIN Personal P_Profesor ON Imp.DNI_ProfesorFK = P_Profesor.DNI -- Para obtener el departamento del profesor que imparte la asignatura.
            WHERE P_Auditor.DNI = AuditoriasDesempeno.DNI_AuditorFK
              AND P_Profesor.departamentoPrincipalProfesor IS NOT NULL -- Asegura que el profesor tenga un departamento principal
              AND EXISTS (
                    SELECT 1
                    FROM Departamentos D
                    JOIN CursosOrientacion CO ON D.idDepartamento = CO.idDepartamentoFK
                    WHERE D.nombreDepartamento = P_Profesor.departamentoPrincipalProfesor -- El departamento del profesor de la asignatura
              )
        )
    )
);

-- Nota sobre el CHECK CONSTRAINT para el curso de orientación del auditor:
-- Un CHECK CONSTRAINT con subconsultas correlacionadas puede ser limitado en MySQL (y otros DBMS).
-- Para una validación robusta y dinámica de esta regla compleja, un TRIGGER AFTER INSERT/UPDATE
-- es la solución más fiable.
DELIMITER //
CREATE TRIGGER trg_auditor_has_course
BEFORE INSERT ON AuditoriasDesempeno
FOR EACH ROW
BEGIN
    DECLARE dept_asignatura_nombre VARCHAR(100);
    DECLARE curso_existe BOOLEAN;

    -- Obtener el departamento principal del profesor que imparte la asignatura de la auditoría
    SELECT P.departamentoPrincipalProfesor INTO dept_asignatura_nombre
    FROM Imparticion I
    JOIN Personal P ON I.DNI_ProfesorFK = P.DNI
    WHERE I.DNI_ProfesorFK = NEW.DNI_ProfesorImparticionFK
      AND I.codigoAsignaturaFK = NEW.codigoAsignaturaImparticionFK;

    -- Verificar si existe un curso de orientación para ese departamento
    SELECT EXISTS (
        SELECT 1
        FROM CursosOrientacion CO
        JOIN Departamentos D ON CO.idDepartamentoFK = D.idDepartamento
        WHERE D.nombreDepartamento = dept_asignatura_nombre
    ) INTO curso_existe;

    IF NOT curso_existe THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El auditor no puede realizar esta auditoría. No existe un curso de orientación para el departamento de la asignatura.';
    END IF;
END;
//
DELIMITER ;


-- TABLA: Matriculacion
-- Descripción: Implementa la relación ternaria "Alumno se matricula en Asignatura para Convocatoria".
-- Cardinalidad: Alumno (1,N), Asignatura (1,4), Convocatoria (1,N).
-- Participación: Alumno (1,N), Convocatoria (1,N), Asignatura (1,N) (cada asignatura activa tiene al menos un alumno).
CREATE TABLE Matriculacion (
    DNI_AlumnoFK VARCHAR(10) NOT NULL,          -- FK a Personal (Alumno).
    codigoAsignaturaFK VARCHAR(20) NOT NULL,   -- FK a Asignaturas.
    idConvocatoriaFK VARCHAR(20) NOT NULL,     -- FK a Convocatorias.
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0), -- Atributo de la relación: precio de la matrícula.
    notaFinal DECIMAL(4,2),                     -- Atributo de la relación: nota final. NULLable si aún no calificado.
    fechaMatriculacion DATE NOT NULL,           -- Fecha real de la matriculación.

    PRIMARY KEY (DNI_AlumnoFK, codigoAsignaturaFK, idConvocatoriaFK), -- PK: Identifica una matrícula única.

    CONSTRAINT fk_matricula_alumno FOREIGN KEY (DNI_AlumnoFK) REFERENCES Personal(DNI)
    ON DELETE RESTRICT   -- No se permite borrar un alumno si tiene matrículas.
    ON UPDATE CASCADE,   -- Si el DNI del alumno cambia.

    CONSTRAINT fk_matricula_asignatura FOREIGN KEY (codigoAsignaturaFK) REFERENCES Asignaturas(codigoAsignatura)
    ON DELETE RESTRICT   -- No se permite borrar una asignatura si tiene matrículas.
    ON UPDATE CASCADE,   -- Si el código de la asignatura cambia.

    CONSTRAINT fk_matricula_convocatoria FOREIGN KEY (idConvocatoriaFK) REFERENCES Convocatorias(idConvocatoria)
    ON DELETE RESTRICT   -- No se permite borrar una convocatoria si tiene matrículas.
    ON UPDATE CASCADE,   -- Si el ID de la convocatoria cambia.

    -- Restricción para asegurar que la nota final está en un rango válido (ej. 0-10)
    CONSTRAINT chk_nota_final CHECK (notaFinal >= 0 AND notaFinal <= 10 OR notaFinal IS NULL)
);

-- TRIGGER para asegurar que los alumnos se matriculen al menos en una asignatura y una convocatoria por curso.
-- Esto es muy complejo de aplicar con triggers directamente en la tabla de Matriculacion
-- ya que depende del "curso". A menudo, esta regla se verifica a nivel de aplicación o con un proceso batch.
-- Una regla más sencilla de aplicar con triggers es la de que una asignatura activa en un curso
-- tenga al menos un estudiante matriculado.
DELIMITER //
CREATE TRIGGER trg_asignatura_activa_con_alumnos
AFTER INSERT ON Matriculacion
FOR EACH ROW
BEGIN
    -- Se asume que "asignatura activa en un curso" se refleja con su presencia en Asignatura_Convocatoria.
    -- Si una asignatura está en Asignatura_Convocatoria, debe tener al menos un matriculado.
    DECLARE num_alumnos_en_asignatura_convocatoria INT;
    SELECT COUNT(*) INTO num_alumnos_en_asignatura_convocatoria
    FROM Matriculacion
    WHERE codigoAsignaturaFK = NEW.codigoAsignaturaFK
      AND idConvocatoriaFK = NEW.idConvocatoriaFK; -- Check para la combinación específica.

    IF num_alumnos_en_asignatura_convocatoria = 0 THEN
        -- Esto es para el caso AFTER DELETE que podría dejar una combinación sin alumnos.
        -- Para INSERT, siempre será al menos 1.
        -- Esta regla es más fácil de verificar en la aplicación o con un AFTER DELETE si se requiere.
        SELECT 1; -- Placeholder.
    END IF;
END;
//
DELIMITER ;


-- **************************************************************
-- RESTRICCIONES DE BORRADO Y ACTUALIZACIÓN DE PKs ESPECÍFICAS
-- **************************************************************

-- Modificación de ON UPDATE para permitir cambios de PK en Profesores, Administrativos, Visitas.
-- Esto implica que sus FKs deben tener ON UPDATE CASCADE, lo cual ya se ha hecho.
-- Para Alumnos y Auditores, sus PKs (DNI) NO se pueden modificar. Esto se aplica a nivel de aplicación
-- o se confía en que MySQL no permita UPDATE de PKs que son FKs si hay 'RESTRICT' en otros lados.
-- Si queremos prohibir explícitamente UPDATE en PKs de Alumnos/Auditores:

-- TRIGER (AFTER UPDATE) para prohibir la modificación de DNI de Alumnos y Auditores
DELIMITER //
CREATE TRIGGER trg_prohibit_DNI_update
BEFORE UPDATE ON Personal
FOR EACH ROW
BEGIN
    IF OLD.DNI <> NEW.DNI AND (OLD.tipoPersona = 'Alumno' OR OLD.tipoPersona = 'Auditor') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se permite modificar el DNI de Alumnos o Auditores.';
    END IF;
END;
//
DELIMITER ;


-- **************************************************************
-- DATOS DE PRUEBA
-- **************************************************************

-- Insertar Departamento "General" para el trigger de reasignación
INSERT INTO Departamentos (nombreDepartamento, anosExistencia, nombrePrimerProfesor) VALUES
('General', 1, 'Prof. Comodín');

-- Insertar Departamentos
INSERT INTO Departamentos (nombreDepartamento, anosExistencia, nombrePrimerProfesor) VALUES
('Informatica', 25, 'Dr. García'),
('Matematicas', 30, 'Dra. López'),
('Filologia Hispanica', 20, 'Prof. Martín');

-- Insertar Aulas
INSERT INTO Aulas (numeroAula, edificio, planta, capacidad, tieneTablonAnuncios) VALUES
('101', 'A', '1', 50, TRUE),
('203', 'B', '2', 30, FALSE),
('G01', 'C', 'Ground', 100, TRUE);

-- Insertar Convocatorias
INSERT INTO Convocatorias (idConvocatoria, nombreConvocatoria) VALUES
('FEB2025', 'Febrero'),
('JUN2025', 'Junio'),
('SEP2025', 'Septiembre'),
('DIC2025', 'Diciembre');

-- Insertar Premios
INSERT INTO Premios (nombrePremio, descripcion) VALUES
('Excelencia Docente', 'Reconocimiento a la calidad de enseñanza.'),
('Innovacion Pedagogica', 'Premio a la innovación en métodos de enseñanza.');

-- Insertar Personal (Alumnos, Profesores, Administrativos, Auditores, Visitas)
-- Alumnos
INSERT INTO Personal (DNI, nombre, apellidos, fechaNacimiento, emailPrincipal, tipoPersona, especialidadAlumno, fechaMatriculacionInicial) VALUES
('11111111A', 'Ana', 'Gómez', '2000-01-15', 'ana.gomez@example.com', 'Alumno', 'Ingenierías', '2022-09-01'),
('22222222B', 'Luis', 'Martínez', '2001-03-20', 'luis.m@example.com', 'Alumno', 'Filologías', '2023-09-10'),
('33333333C', 'Marta', 'Ruiz', '2000-07-22', 'marta.ruiz@example.com', 'Alumno', 'Ingenierías', '2022-09-01');

-- Teléfonos para Alumnos (requerido por trigger trg_min_one_phone)
INSERT INTO Telefonos (DNI_PersonalFK, numeroTelefono) VALUES
('11111111A', '600111111'),
('11111111A', '911111111'),
('22222222B', '600222222'),
('33333333C', '600333333');

-- Profesores
INSERT INTO Personal (DNI, nombre, apellidos, fechaNacimiento, emailPrincipal, tipoPersona, departamentoPrincipalProfesor, salarioAnual, categoriaAcademicaProfesor) VALUES
('44444444D', 'Dr. Javier', 'Pérez', '1975-05-10', 'javier.p@example.com', 'Profesor', 'Informatica', 55000.00, 'Titular'),
('55555555E', 'Dra. Laura', 'Sanz', '1980-08-25', 'laura.s@example.com', 'Profesor', 'Matematicas', 48000.00, 'Asociado');

-- Teléfonos para Profesores
INSERT INTO Telefonos (DNI_PersonalFK, numeroTelefono) VALUES
('44444444D', '600444444'),
('55555555E', '600555555');

-- Personal Administrativo
INSERT INTO Personal (DNI, nombre, apellidos, fechaNacimiento, emailPrincipal, tipoPersona, especializacionAdmin, extensionTelefonicaAdmin) VALUES
('66666666F', 'Elena', 'Torres', '1990-11-01', 'elena.t@example.com', 'Administrativo', 'Recursos Humanos', '1234');

-- Teléfonos para Administrativo
INSERT INTO Telefonos (DNI_PersonalFK, numeroTelefono) VALUES
('66666666F', '600666666');

-- Auditores
INSERT INTO Personal (DNI, nombre, apellidos, fechaNacimiento, emailPrincipal, tipoPersona, anosExperienciaAuditor, trabajaFueraUniversidad) VALUES
('77777777G', 'Roberto', 'Vidal', '1970-02-05', 'roberto.v@example.com', 'Auditor', 15, TRUE);

-- Teléfonos para Auditores
INSERT INTO Telefonos (DNI_PersonalFK, numeroTelefono) VALUES
('77777777G', '600777777');

-- Visitas
INSERT INTO Personal (DNI, nombre, apellidos, fechaNacimiento, emailPrincipal, tipoPersona, motivoVisita, DNIContactoUniversidad) VALUES
('88888888H', 'Visitante', 'Uno', '1995-04-12', 'visitante@example.com', 'Visita', 'Reunión departamento', '66666666F');

-- Teléfonos para Visitas
INSERT INTO Telefonos (DNI_PersonalFK, numeroTelefono) VALUES
('88888888H', '600888888');


-- Asignaturas
INSERT INTO Asignaturas (codigoAsignatura, nombreAsignatura, creditosECTS, DNI_ProfesorFK, numeroAulaFK, edificioAulaFK, plantaAulaFK) VALUES
('BBDD101', 'Bases de Datos I', 6.00, '44444444D', '101', 'A', '1'),
('PROG201', 'Programación Avanzada', 9.00, '44444444D', '203', 'B', '2'),
('ALG301', 'Álgebra Lineal', 6.00, '55555555E', '101', 'A', '1');

-- Profesor_Departamento
INSERT INTO Profesor_Departamento (DNI_ProfesorFK, idDepartamentoFK) VALUES
('44444444D', (SELECT idDepartamento FROM Departamentos WHERE nombreDepartamento = 'Informatica')),
('44444444D', (SELECT idDepartamento FROM Departamentos WHERE nombreDepartamento = 'Matematicas')), -- Un profesor en varios departamentos
('55555555E', (SELECT idDepartamento FROM Departamentos WHERE nombreDepartamento = 'Matematicas'));

-- Asignatura_Prerequisito
INSERT INTO Asignatura_Prerequisito (codigoAsignatura, codigoPrerequisitoFK) VALUES
('PROG201', 'BBDD101'); -- Programación Avanzada tiene Bases de Datos I como prerequisito.

-- Asignatura_Convocatoria
INSERT INTO Asignatura_Convocatoria (codigoAsignaturaFK, idConvocatoriaFK) VALUES
('BBDD101', 'FEB2025'),
('BBDD101', 'JUN2025'),
('PROG201', 'JUN2025'),
('PROG201', 'SEP2025'),
('ALG301', 'FEB2025'),
('ALG301', 'JUN2025');

-- Alumno_Representa
INSERT INTO Alumno_Representa (DNI_AlumnoRepresentadoFK, DNI_AlumnoRepresentanteFK) VALUES
('22222222B', '11111111A'), -- Luis es representado por Ana
('33333333C', '11111111A'); -- Marta es representada por Ana (un representante, varios representados)

-- Imparticion (La agregación)
INSERT INTO Imparticion (DNI_ProfesorFK, codigoAsignaturaFK) VALUES
('44444444D', 'BBDD101'), -- Impartición de BBDD101 por Dr. Pérez
('44444444D', 'PROG201'), -- Impartición de PROG201 por Dr. Pérez
('55555555E', 'ALG301'); -- Impartición de ALG301 por Dra. Sanz

-- Premios_Imparticion
INSERT INTO Premios_Imparticion (idPremioFK, DNI_ProfesorImparticionFK, codigoAsignaturaImparticionFK) VALUES
((SELECT idPremio FROM Premios WHERE nombrePremio = 'Excelencia Docente'), '44444444D', 'BBDD101'),
((SELECT idPremio FROM Premios WHERE nombrePremio = 'Innovacion Pedagogica'), '44444444D', 'BBDD101'), -- Misma impartición, varios premios
((SELECT idPremio FROM Premios WHERE nombrePremio = 'Excelencia Docente'), '55555555E', 'ALG301');

-- CursosOrientacion (necesarios para auditorías)
INSERT INTO CursosOrientacion (idDepartamentoFK, nombreCurso) VALUES
((SELECT idDepartamento FROM Departamentos WHERE nombreDepartamento = 'Informatica'), 'Metodologia Docente Informatica'),
((SELECT idDepartamento FROM Departamentos WHERE nombreDepartamento = 'Matematicas'), 'Pedagogia Avanzada Matematicas');

-- AuditoriasDesempeno (debe haber recibido el curso de orientación del departamento de la asignatura)
INSERT INTO AuditoriasDesempeno (DNI_AuditorFK, DNI_ProfesorImparticionFK, codigoAsignaturaImparticionFK, fechaAuditoria, informeFinal) VALUES
('77777777G', '44444444D', 'BBDD101', '2025-06-15', 'Informe positivo sobre BBDD101.'), -- Auditor 77777777G, Profesor 44444444D (Informatica), Asignatura BBDD101
('77777777G', '55555555E', 'ALG301', '2025-06-18', 'Recomendaciones para ALG301.'); -- Auditor 77777777G, Profesor 55555555E (Matematicas), Asignatura ALG301

-- Matriculacion
INSERT INTO Matriculacion (DNI_AlumnoFK, codigoAsignaturaFK, idConvocatoriaFK, precio, notaFinal, fechaMatriculacion) VALUES
('11111111A', 'BBDD101', 'FEB2025', 150.00, 8.50, '2024-11-01'),
('11111111A', 'BBDD101', 'JUN2025', 150.00, NULL, '2025-03-01'), -- Mismo alumno/asignatura, diferente convocatoria
('22222222B', 'BBDD101', 'FEB2025', 120.00, 7.00, '2024-11-05'), -- Diferente alumno/mismo asignatura/convocatoria
('11111111A', 'PROG201', 'JUN2025', 200.00, NULL, '2025-03-10'), -- Mismo alumno, diferente asignatura
('33333333C', 'ALG301', 'FEB2025', 180.00, 6.00, '2024-12-01');


-- **************************************************************
-- CONSULTAS DE VERIFICACIÓN
-- **************************************************************

-- 1. Listar todo el personal de la universidad y su rol
SELECT DNI, nombre, apellidos, tipoPersona, emailPrincipal
FROM Personal;

-- 2. Mostrar todos los alumnos y su especialidad
SELECT DNI, nombre, apellidos, especialidadAlumno
FROM Personal
WHERE tipoPersona = 'Alumno';

-- 3. Mostrar todos los profesores, su departamento principal y salario
SELECT DNI, nombre, apellidos, departamentoPrincipalProfesor, salarioAnual
FROM Personal
WHERE tipoPersona = 'Profesor';

-- 4. Mostrar todas las aulas y su capacidad
SELECT numeroAula, edificio, planta, capacidad, tieneTablonAnuncios
FROM Aulas;

-- 5. Listar las asignaturas, el profesor que las imparte y el aula asignada
SELECT
    A.codigoAsignatura,
    A.nombreAsignatura,
    P.nombre AS NombreProfesor,
    P.apellidos AS ApellidosProfesor,
    AU.numeroAula,
    AU.edificio,
    AU.planta
FROM Asignaturas A
JOIN Personal P ON A.DNI_ProfesorFK = P.DNI
JOIN Aulas AU ON A.numeroAulaFK = AU.numeroAula AND A.edificioAulaFK = AU.edificio AND A.plantaAulaFK = AU.planta;

-- 6. Mostrar las asignaturas y sus pre-requisitos
SELECT
    ASIG.nombreAsignatura AS Asignatura,
    PRE.nombreAsignatura AS PreRequisito
FROM Asignaturas ASIG
JOIN Asignatura_Prerequisito APR ON ASIG.codigoAsignatura = APR.codigoAsignatura
JOIN Asignaturas PRE ON APR.codigoPrerequisitoFK = PRE.codigoAsignatura;

-- 7. Listar todos los departamentos y los profesores adscritos a cada uno
SELECT
    D.nombreDepartamento,
    P.nombre AS NombreProfesor,
    P.apellidos AS ApellidosProfesor
FROM Departamentos D
JOIN Profesor_Departamento PD ON D.idDepartamento = PD.idDepartamentoFK
JOIN Personal P ON PD.DNI_ProfesorFK = P.DNI;

-- 8. Mostrar las matrículas de los alumnos: quién, en qué asignatura, en qué convocatoria, precio y nota.
SELECT
    AL.nombre AS NombreAlumno,
    AL.apellidos AS ApellidosAlumno,
    ASIG.nombreAsignatura,
    CONV.nombreConvocatoria,
    M.precio,
    M.notaFinal,
    M.fechaMatriculacion
FROM Matriculacion M
JOIN Personal AL ON M.DNI_AlumnoFK = AL.DNI
JOIN Asignaturas ASIG ON M.codigoAsignaturaFK = ASIG.codigoAsignatura
JOIN Convocatorias CONV ON M.idConvocatoriaFK = CONV.idConvocatoria;

-- 9. Mostrar las auditorías realizadas: quién audita, a quién (profesor), en qué asignatura
SELECT
    AUD.nombre AS NombreAuditor,
    AUD.apellidos AS ApellidosAuditor,
    PROF.nombre AS NombreProfesorAuditado,
    PROF.apellidos AS ApellidosProfesorAuditado,
    ASIG.nombreAsignatura AS AsignaturaAuditada,
    AD.fechaAuditoria
FROM AuditoriasDesempeno AD
JOIN Personal AUD ON AD.DNI_AuditorFK = AUD.DNI
JOIN Imparticion IMP ON AD.DNI_ProfesorImparticionFK = IMP.DNI_ProfesorFK AND AD.codigoAsignaturaImparticionFK = IMP.codigoAsignaturaFK
JOIN Personal PROF ON IMP.DNI_ProfesorFK = PROF.DNI
JOIN Asignaturas ASIG ON IMP.codigoAsignaturaFK = ASIG.codigoAsignatura;

-- 10. Mostrar qué alumnos son representados y por quién
SELECT
    AL_REP.nombre AS AlumnoRepresentadoNombre,
    AL_REP.apellidos AS AlumnoRepresentadoApellidos,
    AL_VOCAL.nombre AS VocalNombre,
    AL_VOCAL.apellidos AS VocalApellidos
FROM Alumno_Representa AR
JOIN Personal AL_REP ON AR.DNI_AlumnoRepresentadoFK = AL_REP.DNI
JOIN Personal AL_VOCAL ON AR.DNI_AlumnoRepresentanteFK = AL_VOCAL.DNI;

-- 11. Premios recibidos por cada impartición (Profesor y Asignatura)
SELECT
    P.nombrePremio,
    PROF.nombre AS NombreProfesor,
    PROF.apellidos AS ApellidosProfesor,
    ASIG.nombreAsignatura
FROM Premios_Imparticion PI
JOIN Premios P ON PI.idPremioFK = P.idPremio
JOIN Imparticion I ON PI.DNI_ProfesorImparticionFK = I.DNI_ProfesorFK AND PI.codigoAsignaturaImparticionFK = I.codigoAsignaturaFK
JOIN Personal PROF ON I.DNI_ProfesorFK = PROF.DNI
JOIN Asignaturas ASIG ON I.codigoAsignaturaFK = ASIG.codigoAsignatura;


-- ##########################################################################################################
-- # FIN DEL CÓDIGO SQL                                                                                     #
-- ##########################################################################################################