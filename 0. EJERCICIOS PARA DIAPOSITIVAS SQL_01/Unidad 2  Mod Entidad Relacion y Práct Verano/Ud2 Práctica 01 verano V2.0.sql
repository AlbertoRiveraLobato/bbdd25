-- ---
-- # PRÁCTICA DE VERANO 2025: MODELO RELACIONAL DE LA UNIVERSIDAD "CAMPUSCONNECT"
-- # (ADAPTADO: SIN SENTENCIAS SELECT EN TRIGGERS/CHECK CONSTRAINTS)
-- ---

-- ##########################################################################################################
-- # NOTA IMPORTANTE PARA EL ALUMNO:
-- # ESTE SCRIPT IMPLEMENTA LA MAYOR PARTE DEL MODELO RELACIONAL PERO NO TODAS LAS RESTRICCIONES.
-- # LAS RESTRICCIONES MÁS COMPLEJAS QUE REQUIEREN CONSULTAR OTRAS TABLAS (USANDO SELECT)
-- # NO SE HAN PODIDO IMPLEMENTAR DIRECTAMENTE EN DDL NI CON TRIGGERS SIMPLES DEBIDO A LAS LIMITACIONES
-- # IMPUESTAS DE NO UTILIZAR SENTENCIAS SELECT. ESTAS RESTRICCIONES SE DESCRIBEN AL FINAL.
-- ##########################################################################################################

-- 1. PREPARACIÓN DEL ENTORNO: Borrar, crear y seleccionar la base de datos.
DROP DATABASE IF EXISTS UniversidadDB;
CREATE DATABASE UniversidadDB;
USE UniversidadDB;

-- **************************************************************
-- ENTIDADES FUERTES Y SU TRANSFORMACIÓN
-- **************************************************************

-- TABLA: Departamentos
CREATE TABLE Departamentos (
    idDepartamento INT PRIMARY KEY AUTO_INCREMENT,
    nombreDepartamento VARCHAR(100) UNIQUE NOT NULL,
    anosExistencia INT NOT NULL CHECK (anosExistencia >= 0),
    nombrePrimerProfesor VARCHAR(100) NOT NULL
);

-- TABLA: Aulas
-- PK Compuesta: (numeroAula, edificio, planta)
CREATE TABLE Aulas (
    numeroAula VARCHAR(10) NOT NULL,
    edificio VARCHAR(50) NOT NULL,
    planta VARCHAR(10) NOT NULL,
    capacidad INT NOT NULL CHECK (capacidad > 0),
    tieneTablonAnuncios BOOLEAN NOT NULL,
    PRIMARY KEY (numeroAula, edificio, planta)
);

-- TABLA: Convocatorias
CREATE TABLE Convocatorias (
    idConvocatoria VARCHAR(20) PRIMARY KEY,
    nombreConvocatoria VARCHAR(50) UNIQUE NOT NULL
);

-- TABLA: Premios
CREATE TABLE Premios (
    idPremio INT PRIMARY KEY AUTO_INCREMENT,
    nombrePremio VARCHAR(100) UNIQUE NOT NULL,
    descripcion VARCHAR(255)
);

-- **************************************************************
-- HERENCIA: "Personal" (Generalización) y sus Especializaciones
-- Estrategia: Una única tabla para la superclase 'Personal' (Single Table Inheritance).
-- Atributos específicos de cada subclase son NULLable.
-- **************************************************************

-- TABLA: Personal
CREATE TABLE Personal (
    DNI VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    emailPrincipal VARCHAR(100),
    tipoPersona ENUM('Alumno', 'Profesor', 'Administrativo', 'Auditor', 'Visita') NOT NULL,

    -- Atributos específicos de Alumnos (NULL si no es Alumno)
    especialidadAlumno ENUM('Ingenierías', 'Filologías', 'Biologías', 'Medicinas', 'Humanidades'),
    fechaMatriculacionInicial DATE,

    -- Atributos específicos de Profesores (NULL si no es Profesor)
    departamentoPrincipalProfesor VARCHAR(100), -- Aquí se podría considerar una FK a Departamentos, pero no con CHECK CONSTRAINTS complejos.
    salarioAnual DECIMAL(10, 2),
    categoriaAcademicaProfesor VARCHAR(50),

    -- Atributos específicos de Personal Administrativo (NULL si no es Administrativo)
    especializacionAdmin VARCHAR(100),
    extensionTelefonicaAdmin VARCHAR(10),

    -- Atributos específicos de Auditores (NULL si no es Auditor)
    anosExperienciaAuditor INT,
    trabajaFueraUniversidad BOOLEAN,

    -- Atributos específicos de Visitas (NULL si no es Visita)
    motivoVisita VARCHAR(255),
    DNIContactoUniversidad VARCHAR(10),

    -- Restricciones de Dominio para 'Personal' (solo las que no usan SELECT)
    CONSTRAINT chk_salario_profesor CHECK (
        (tipoPersona = 'Profesor' AND salarioAnual > 0 AND salarioAnual <= 60000) OR
        (tipoPersona <> 'Profesor' AND salarioAnual IS NULL)
    ),
    -- El resto de CHECKs que validan que los atributos de especialización sean NULL o NOT NULL
    -- para el tipo de persona correspondiente son complejos sin SELECT.
    -- Por simplicidad y evitar el error, los omitimos aquí, asumiendo que la aplicación los gestiona.
    -- En un entorno real, estos se implementarían con triggers AFTER INSERT/UPDATE.

    -- FK reflexiva para el contacto de la visita.
    CONSTRAINT fk_visita_contacto FOREIGN KEY (DNIContactoUniversidad) REFERENCES Personal(DNI)
    ON DELETE SET NULL -- Si el contacto es borrado, se anula la referencia en la visita.
    ON UPDATE CASCADE
);

-- TABLA: Telefonos
-- PK Compuesta: (DNI_PersonalFK, numeroTelefono)
-- Participación: IMPRESCINDIBLE al menos un teléfono por persona (participación total de Personal).
-- NOTA: Esta participación total (mínimo 1) NO PUEDE ser forzada sin un TRIGGER que use SELECT o lógica de aplicación.
CREATE TABLE Telefonos (
    DNI_PersonalFK VARCHAR(10) NOT NULL,
    numeroTelefono VARCHAR(20) NOT NULL,
    PRIMARY KEY (DNI_PersonalFK, numeroTelefono),
    FOREIGN KEY (DNI_PersonalFK) REFERENCES Personal(DNI)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- TABLA: Asignaturas
CREATE TABLE Asignaturas (
    codigoAsignatura VARCHAR(20) PRIMARY KEY,
    nombreAsignatura VARCHAR(100) NOT NULL,
    creditosECTS DECIMAL(4,2) NOT NULL CHECK (creditosECTS > 0),

    DNI_ProfesorFK VARCHAR(10) NOT NULL, -- FK a Personal (Profesor)
    
    -- PK compuesta del Aula (FK al Aula asignada por curso)
    numeroAulaFK VARCHAR(10) NOT NULL,
    edificioAulaFK VARCHAR(50) NOT NULL,
    plantaAulaFK VARCHAR(10) NOT NULL,

    CONSTRAINT fk_asignatura_profesor FOREIGN KEY (DNI_ProfesorFK) REFERENCES Personal(DNI)
    ON DELETE RESTRICT -- Un profesor no puede ser borrado si imparte asignaturas.
    ON UPDATE CASCADE,

    CONSTRAINT fk_asignatura_aula FOREIGN KEY (numeroAulaFK, edificioAulaFK, plantaAulaFK) REFERENCES Aulas(numeroAula, edificio, planta)
    ON DELETE RESTRICT -- Un aula no puede ser borrada si tiene asignaturas asignadas.
    ON UPDATE CASCADE
);

-- **************************************************************
-- RELACIONES M:N (Tablas de Enlace)
-- **************************************************************

-- TABLA: Profesor_Departamento
-- Resuelve M:N entre Profesores y Departamentos.
CREATE TABLE Profesor_Departamento (
    DNI_ProfesorFK VARCHAR(10) NOT NULL,
    idDepartamentoFK INT NOT NULL,
    PRIMARY KEY (DNI_ProfesorFK, idDepartamentoFK),
    FOREIGN KEY (DNI_ProfesorFK) REFERENCES Personal(DNI)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (idDepartamentoFK) REFERENCES Departamentos(idDepartamento)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- TABLA: Asignatura_Convocatoria
-- Resuelve M:N entre Asignaturas y Convocatorias.
-- NOTA: La restricción "entre 1 y 4 convocatorias por asignatura" NO PUEDE ser forzada sin SELECT.
-- La restricción "siempre, al menos, concurre una asignatura" (para Convocatoria) tampoco.
CREATE TABLE Asignatura_Convocatoria (
    codigoAsignaturaFK VARCHAR(20) NOT NULL,
    idConvocatoriaFK VARCHAR(20) NOT NULL,
    PRIMARY KEY (codigoAsignaturaFK, idConvocatoriaFK),
    FOREIGN KEY (codigoAsignaturaFK) REFERENCES Asignaturas(codigoAsignatura)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (idConvocatoriaFK) REFERENCES Convocatorias(idConvocatoria)
    ON DELETE RESTRICT -- Una convocatoria no puede ser borrada si está asociada a asignaturas.
    ON UPDATE CASCADE
);

-- **************************************************************
-- RELACIONES REFLEXIVAS
-- **************************************************************

-- TABLA: Asignatura_Prerequisito
-- Relación reflexiva de pre-requisitos entre asignaturas.
CREATE TABLE Asignatura_Prerequisito (
    codigoAsignatura VARCHAR(20) PRIMARY KEY,
    codigoPrerequisitoFK VARCHAR(20) NOT NULL,
    FOREIGN KEY (codigoAsignatura) REFERENCES Asignaturas(codigoAsignatura)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (codigoPrerequisitoFK) REFERENCES Asignaturas(codigoAsignatura)
    ON DELETE RESTRICT -- No se puede borrar una asignatura si es pre-requisito de otra.
    ON UPDATE CASCADE
);

-- TABLA: Alumno_Representa
-- Relación reflexiva de representación entre alumnos.
-- NOTA: La restricción "el representante es de tipo 'Alumno'" NO PUEDE ser forzada sin SELECT.
-- La restricción "Un alumno no puede ser representante si no tiene asignado ningún alumno como representado" tampoco (sin SELECT).
CREATE TABLE Alumno_Representa (
    DNI_AlumnoRepresentadoFK VARCHAR(10) PRIMARY KEY,
    DNI_AlumnoRepresentanteFK VARCHAR(10) NOT NULL,

    CONSTRAINT fk_alumno_representado FOREIGN KEY (DNI_AlumnoRepresentadoFK) REFERENCES Personal(DNI)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    CONSTRAINT fk_alumno_representante FOREIGN KEY (DNI_AlumnoRepresentanteFK) REFERENCES Personal(DNI)
    ON DELETE RESTRICT -- No se permite borrar a un alumno si es representante de otro(s).
    ON UPDATE CASCADE
);

-- **************************************************************
-- RELACIONES TERNARIAS Y AGREGACIONES
-- **************************************************************

-- TABLA: Imparticion (Agregación)
-- Representa la relación "Profesor imparte Asignatura".
CREATE TABLE Imparticion (
    DNI_ProfesorFK VARCHAR(10) NOT NULL,
    codigoAsignaturaFK VARCHAR(20) NOT NULL,
    PRIMARY KEY (DNI_ProfesorFK, codigoAsignaturaFK),
    FOREIGN KEY (DNI_ProfesorFK) REFERENCES Personal(DNI)
    ON DELETE RESTRICT -- No se puede eliminar un profesor si tiene imparticiones registradas.
    ON UPDATE CASCADE,
    FOREIGN KEY (codigoAsignaturaFK) REFERENCES Asignaturas(codigoAsignatura)
    ON DELETE RESTRICT -- No se puede eliminar una asignatura si tiene imparticiones registradas.
    ON UPDATE CASCADE
);

-- TABLA: Premios_Imparticion
-- Resuelve M:N entre Premios y la AGREGACIÓN "Imparticion".
-- NOTA: La restricción "Un premio nunca se queda desierto" NO PUEDE ser forzada sin SELECT.
CREATE TABLE Premios_Imparticion (
    idPremioFK INT NOT NULL,
    DNI_ProfesorImparticionFK VARCHAR(10) NOT NULL,
    codigoAsignaturaImparticionFK VARCHAR(20) NOT NULL,
    PRIMARY KEY (idPremioFK, DNI_ProfesorImparticionFK, codigoAsignaturaImparticionFK),
    FOREIGN KEY (idPremioFK) REFERENCES Premios(idPremio)
    ON DELETE RESTRICT -- No se puede borrar un premio si ya ha sido entregado.
    ON UPDATE CASCADE,
    FOREIGN KEY (DNI_ProfesorImparticionFK, codigoAsignaturaImparticionFK) REFERENCES Imparticion(DNI_ProfesorFK, codigoAsignaturaFK)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- TABLA: CursosOrientacion
-- Relación 1:1 con Departamentos (un curso por departamento, un departamento por curso).
CREATE TABLE CursosOrientacion (
    idDepartamentoFK INT PRIMARY KEY, -- PK y FK a Departamentos (asegura el 1:1).
    nombreCurso VARCHAR(100) NOT NULL UNIQUE,
    FOREIGN KEY (idDepartamentoFK) REFERENCES Departamentos(idDepartamento)
    ON DELETE CASCADE -- Este CASCADE se anularía parcialmente por un trigger de reasignación.
    ON UPDATE CASCADE
);

-- Trigger para reasignar Curso de Orientación a "General" si su departamento es borrado
-- NOTA: Este TRIGGER SÍ necesita un SELECT para encontrar el id del departamento 'General'.
-- Por lo tanto, NO SE INCLUYE SU IMPLEMENTACIÓN AQUÍ. Se describe al final.
-- DROP TRIGGER IF EXISTS trg_reasignar_curso_orientacion;

-- TABLA: AuditoriasDesempeno (Relación Ternaria)
-- NOTA: La restricción "Un auditor debe haber recibido el curso de orientación del departamento de la asignatura auditada"
-- NO PUEDE ser forzada sin SELECT.
CREATE TABLE AuditoriasDesempeno (
    idAuditoria INT PRIMARY KEY AUTO_INCREMENT,
    DNI_AuditorFK VARCHAR(10) NOT NULL,
    DNI_ProfesorImparticionFK VARCHAR(10) NOT NULL,
    codigoAsignaturaImparticionFK VARCHAR(20) NOT NULL,
    fechaAuditoria DATE NOT NULL,
    informeFinal TEXT,

    CONSTRAINT fk_auditoria_auditor FOREIGN KEY (DNI_AuditorFK) REFERENCES Personal(DNI)
    ON DELETE RESTRICT -- Un auditor no puede ser borrado si ha realizado auditorías.
    ON UPDATE CASCADE,

    CONSTRAINT fk_auditoria_imparticion FOREIGN KEY (DNI_ProfesorImparticionFK, codigoAsignaturaImparticionFK) REFERENCES Imparticion(DNI_ProfesorFK, codigoAsignaturaFK)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- TABLA: Matriculacion (Relación Ternaria con Atributos)
CREATE TABLE Matriculacion (
    DNI_AlumnoFK VARCHAR(10) NOT NULL,
    codigoAsignaturaFK VARCHAR(20) NOT NULL,
    idConvocatoriaFK VARCHAR(20) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    notaFinal DECIMAL(4,2),
    fechaMatriculacion DATE NOT NULL,

    PRIMARY KEY (DNI_AlumnoFK, codigoAsignaturaFK, idConvocatoriaFK),

    CONSTRAINT fk_matricula_alumno FOREIGN KEY (DNI_AlumnoFK) REFERENCES Personal(DNI)
    ON DELETE RESTRICT -- Un alumno no puede ser borrado si tiene matrículas.
    ON UPDATE CASCADE,

    CONSTRAINT fk_matricula_asignatura FOREIGN KEY (codigoAsignaturaFK) REFERENCES Asignaturas(codigoAsignatura)
    ON DELETE RESTRICT -- Una asignatura no puede ser borrada si tiene matrículas.
    ON UPDATE CASCADE,

    CONSTRAINT fk_matricula_convocatoria FOREIGN KEY (idConvocatoriaFK) REFERENCES Convocatorias(idConvocatoria)
    ON DELETE RESTRICT -- Una convocatoria no puede ser borrada si tiene matrículas.
    ON UPDATE CASCADE,

    CONSTRAINT chk_nota_final CHECK (notaFinal >= 0 AND notaFinal <= 10 OR notaFinal IS NULL)
);

-- **************************************************************
-- TRIGGERS ADICIONALES QUE NO USAN SELECT (MUY LIMITADOS)
-- **************************************************************

-- TRIGGER para prohibir la modificación de DNI de Alumnos y Auditores.
-- Este trigger puede funcionar sin SELECT, comparando OLD.DNI y NEW.DNI y OLD.tipoPersona.
DELIMITER //
CREATE TRIGGER trg_prohibit_DNI_update
BEFORE UPDATE ON Personal
FOR EACH ROW
BEGIN
    -- Se verifica el tipo de persona del registro OLD (el que se está intentando actualizar)
    -- Si era 'Alumno' o 'Auditor' y se intenta cambiar el DNI, se lanza un error.
    IF OLD.DNI <> NEW.DNI AND (OLD.tipoPersona = 'Alumno' OR OLD.tipoPersona = 'Auditor') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se permite modificar el DNI de Alumnos o Auditores.';
    END IF;
END;
//
DELIMITER ;

-- **************************************************************
-- DESCRIPCIÓN DE RESTRICCIONES NO IMPLEMENTADAS DIRECTAMENTE EN DDL
-- (Debido a la restricción de no usar SELECT en triggers/constraints)
-- **************************************************************

---

### **Restricciones de Negocio No Implementadas Directamente y Cómo se Harían (Usando `SELECT`)**

Dado que no podemos usar `SELECT` en `CHECK CONSTRAINTS` ni en los `TRIGGERS` de validación más complejos, las siguientes reglas de negocio no se han podido codificar directamente en el DDL. En un escenario real (o si ya hubieran visto `SELECT`), se implementarían de la siguiente manera:

1.  **Validación de Atributos Específicos de Herencia en `Personal`:**
    * **Regla:** Asegurar que, por ejemplo, `especialidadAlumno` solo tenga valor cuando `tipoPersona` sea 'Alumno', y sea `NULL` en otros casos (y viceversa para cada subclase).
    * **Implementación ideal (con `SELECT`):** Se crearía un `TRIGGER` `BEFORE INSERT` y `BEFORE UPDATE` en la tabla `Personal`. Este trigger contendría una lógica condicional (IF/ELSE) que, basándose en el `NEW.tipoPersona`, verificaría que solo los atributos pertinentes a ese tipo tengan valor (`IS NOT NULL`) y el resto sean `NULL`. Por ejemplo:
        ```sql
        -- Pseudo-código de TRIGGER (NO EJECUTAR CON LAS RESTRICCIONES ACTUALES)
        IF NEW.tipoPersona = 'Alumno' THEN
            IF NEW.especialidadAlumno IS NULL THEN SIGNAL ERROR 'Especialidad obligatoria para Alumno'; END IF;
            -- Verificar que los atributos de Profesor, Administrativo, etc., sean NULL
            IF NEW.salarioAnual IS NOT NULL OR NEW.especializacionAdmin IS NOT NULL THEN SIGNAL ERROR 'Atributo no permitido para Alumno'; END IF;
        ELSEIF NEW.tipoPersona = 'Profesor' THEN
            IF NEW.salarioAnual IS NULL OR NEW.departamentoPrincipalProfesor IS NULL THEN SIGNAL ERROR 'Salario y Depto. obligatorios para Profesor'; END IF;
            -- Verificar que los atributos de Alumno, Administrativo, etc., sean NULL
        END IF;
        ```

2.  **Participación Total de `Personal` en `Telefonos` (Mínimo un teléfono):**
    * **Regla:** Todo personal que accede a la Universidad debe aportar al menos un número de teléfono.
    * **Implementación ideal (con `SELECT`):** Se implementaría un `TRIGGER` `AFTER INSERT` en la tabla `Personal`. Este trigger, después de la inserción de una nueva persona, contaría los teléfonos asociados a ese DNI en la tabla `Telefonos`. Si el recuento es cero, lanzaría un error (`SIGNAL SQLSTATE`). También sería necesario un `TRIGGER` `BEFORE DELETE` en `Telefonos` para evitar que el último teléfono de una persona sea borrado.
        ```sql
        -- Pseudo-código de TRIGGER (NO EJECUTAR CON LAS RESTRICCIONES ACTUALES)
        -- AFTER INSERT ON Personal
        IF (SELECT COUNT(*) FROM Telefonos WHERE DNI_PersonalFK = NEW.DNI) = 0 THEN
            SIGNAL ERROR 'Toda persona debe tener al menos un teléfono.';
        END IF;

        -- BEFORE DELETE ON Telefonos
        IF (SELECT COUNT(*) FROM Telefonos WHERE DNI_PersonalFK = OLD.DNI_PersonalFK) = 1 THEN
            SIGNAL ERROR 'No se puede borrar el último teléfono de una persona.';
        END IF;
        ```

3.  **Cardinalidad de `Asignatura_Convocatoria` (Entre 1 y 4 convocatorias por asignatura):**
    * **Regla:** Las asignaturas tienen desde una convocatoria por curso, hasta 4.
    * **Implementación ideal (con `SELECT`):** Se usaría un `TRIGGER` `AFTER INSERT` y `AFTER UPDATE` en `Asignatura_Convocatoria` que contaría el número de convocatorias para `NEW.codigoAsignaturaFK`. Si el número es mayor a 4, se lanzaría un error. Para la restricción de "al menos 1", un `TRIGGER` `AFTER DELETE` en `Asignatura_Convocatoria` podría verificar si alguna asignatura se queda sin convocatorias y, de ser así, revertir la operación o lanzar un error.
        ```sql
        -- Pseudo-código de TRIGGER (NO EJECUTAR CON LAS RESTRICCIONES ACTUALES)
        -- AFTER INSERT/UPDATE ON Asignatura_Convocatoria
        IF (SELECT COUNT(*) FROM Asignatura_Convocatoria WHERE codigoAsignaturaFK = NEW.codigoAsignaturaFK) > 4 THEN
            SIGNAL ERROR 'Una asignatura no puede tener más de 4 convocatorias.';
        END IF;
        ```

4.  **Validación de `Alumno_Representa` (El representante debe ser 'Alumno' y no puede ser representante sin representados):**
    * **Regla 1:** Si un alumno tiene un representante, solo puede ser representado por uno. (Esto lo cubre la `PRIMARY KEY` en `DNI_AlumnoRepresentadoFK` y la FK).
    * **Regla 2:** El `DNI_AlumnoRepresentanteFK` debe ser de una persona de tipo 'Alumno'.
    * **Regla 3:** Un alumno no puede ser representante si no tiene asignado ningún alumno como representado. (Esto implica que una inserción en `Alumno_Representa` siempre debe tener ambos lados).
    * **Implementación ideal (con `SELECT`):**
        * Para la Regla 2: Un `TRIGGER` `BEFORE INSERT` y `BEFORE UPDATE` en `Alumno_Representa` que consulte `Personal` para verificar `tipoPersona = 'Alumno'` para `NEW.DNI_AlumnoRepresentanteFK`.
        * Para la Regla 3: Es más una consecuencia de cómo se modela. La tabla `Alumno_Representa` solo existiría si la relación se da. Si un alumno es representante, debe tener al menos una entrada aquí como `DNI_AlumnoRepresentanteFK`. Si la regla es que un alumno *nunca* puede ser *designado* representante si no tiene a nadie que representar, eso se valida en el `INSERT`. Si es "no puede *dejar de tener* representados", sería un `AFTER DELETE` con `COUNT`.
        ```sql
        -- Pseudo-código de TRIGGER (NO EJECUTAR CON LAS RESTRICCIONES ACTUALES)
        -- BEFORE INSERT/UPDATE ON Alumno_Representa (para Regla 2)
        IF (SELECT tipoPersona FROM Personal WHERE DNI = NEW.DNI_AlumnoRepresentanteFK) <> 'Alumno' THEN
            SIGNAL ERROR 'El representante debe ser de tipo Alumno.';
        END IF;
        ```

5.  **Reasignación de `CursosOrientacion` al borrar `Departamentos`:**
    * **Regla:** Si un Departamento desaparece, su curso de orientación será reasignado al departamento "General".
    * **Implementación ideal (con `SELECT`):** Un `TRIGGER` `BEFORE DELETE` en `Departamentos`. Este trigger necesitaría un `SELECT` para encontrar el `idDepartamento` del departamento "General" y luego un `UPDATE` en `CursosOrientacion` para reasignar el curso.
        ```sql
        -- Pseudo-código de TRIGGER (NO EJECUTAR CON LAS RESTRICCIONES ACTUALES)
        -- BEFORE DELETE ON Departamentos
        DECLARE general_dept_id INT;
        SELECT idDepartamento INTO general_dept_id FROM Departamentos WHERE nombreDepartamento = 'General';
        IF general_dept_id IS NOT NULL THEN
            UPDATE CursosOrientacion SET idDepartamentoFK = general_dept_id WHERE idDepartamentoFK = OLD.idDepartamento;
        END IF;
        ```

6.  **Validación de `AuditoriasDesempeno` (Auditor con curso de orientación de departamento de asignatura):**
    * **Regla:** Un auditor debe haber recibido un curso de orientación en relación con la metodología del departamento al que pertenece la asignatura referida en la auditoría.
    * **Implementación ideal (con `SELECT`):** Un `TRIGGER` `BEFORE INSERT` y `BEFORE UPDATE` en `AuditoriasDesempeno`. Este trigger realizaría una serie de `JOIN`s y `SELECT`s complejos para verificar toda la cadena de relaciones: Auditor -> Impartición (Profesor, Asignatura) -> Departamento del Profesor -> Curso de Orientación del Departamento. Si la ruta no existe, se lanza un error.
        ```sql
        -- Pseudo-código de TRIGGER (NO EJECUTAR CON LAS RESTRICCIONES ACTUALES)
        -- BEFORE INSERT/UPDATE ON AuditoriasDesempeno
        -- ... (aquí iría la lógica compleja de SELECT y JOINs que ya vimos, para verificar la existencia del curso para el auditor y departamento)
        IF NOT (condicion_de_curso_orientacion_cumplida) THEN
            SIGNAL ERROR 'El auditor no está cualificado para esta auditoría.';
        END IF;
        ```

7.  **Cardinalidad de `Matriculacion` (Asignatura activa tiene al menos un estudiante):**
    * **Regla:** Cualquier asignatura que se activa en un curso, tiene al menos un estudiante matriculado.
    * **Implementación ideal (con `SELECT`):** Podría ser un `TRIGGER` `AFTER DELETE` en `Matriculacion` que, si una fila borrada deja una combinación `(codigoAsignaturaFK, idConvocatoriaFK)` sin alumnos, intente revertir la eliminación o lance un error. Alternativamente, una validación al "activar" la asignatura en la aplicación.

---

Espero que esta doble aproximación les sea muy útil a tus alumnos. Les permitirá ver lo que se puede hacer solo con DDL básico y la necesidad de herramientas más avanzadas (como `SELECT` en triggers) para las reglas de negocio más complejas.