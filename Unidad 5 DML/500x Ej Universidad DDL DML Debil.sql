-- ==========================================================================================
-- 0) EJERCICIO COMPLETO: SISTEMA DE GESTIÓN UNIVERSITARIA - DESCRIPCIÓN.
-- ==========================================================================================
-- El alumno debe 
    -- 1) Obtener (abstraer) el Modelo Conceptual MER/MERE de la BBDD: Entidades, atributos y relaciones.
    -- 2) Pasar dicho grafo al modelo MR: tablas y restricciones.
    -- 3) Programar en SQL dicho modelo MR, escribiendo y ejecutando cada sentencia en db-fiddle.com (MySQL), observando los resultados y posibles errores.

-- DESCRIPCIÓN DEL NEGOCIO:
-- Base de datos: Sistema de gestión universitaria.
-- Una universidad gestiona alumnos, profesores, asignaturas y aulas.
    -- Cada alumno puede estar matriculado en una o varias asignaturas, y cada asignatura puede ser 
    --   matriculada por uno o varios alumnos (relación N:M).
    -- Cuando un alumno se matricula en una asignatura, se registra la fecha de matricula y la calificacion.
    -- Cada asignatura solo puede ser impartida por un profesor, pero un profesor puede impartir 
    --   muchas asignaturas (relación 1:N).
    -- Cada asignatura es impartida en un único aula, y cada aula puede utilizarse para impartir 
    --   una o muchas asignaturas (relación 1:N).
    -- Los alumnos pueden tener asignada una taquilla o ninguna, y cada taquilla solo puede ser 
    --   asignada a un alumno (relación 1:1 opcional).
    
    -- Los atributos de un alumno incluyen: dni (único), nombre, apellidos (descompuesto en 
    --   apellido_pat y apellido_mat), telefonos (multivaluado, tabla separada), direccion (descompuesto en 
    --   calle, ciudad, codigo_postal), edad (atributo derivado calculado a partir de fecha_nacimiento), num_asignaturas (indica 
    --   el nº de asignaturas en que se ha matriculado; por defecto 0).
    -- Los atributos de un profesor incluyen: dni (único), nombre, departamento, email (obligatorio).
    -- Los atributos de una asignatura incluyen: id_asignatura, nombre_asignatura, creditos, curso.
    -- Los atributos de un aula incluyen: numero_aula, capacidad (entidad débil - su PK depende de asignatura).
    -- Los atributos de una taquilla incluyen: numero_taquilla, estado ('Asignada' o 'Libre') (obligatorio, y por defecto, 'Libre').


-- ==========================================================================================
-- 1) MODELO CONCEPTUAL SIMPLIFICADO: ENTIDADES, ATRIBUTOS Y RELACIONES (MER/MERE)
-- ==========================================================================================
-- Grafo (no incluido en SQL, debe hacerse en papel o herramienta gráfica).

    -- ENTIDADES IDENTIFICADAS:
        -- 1. ALUMNOS (entidad fuerte)
        -- 2. PROFESORES (entidad fuerte)
        -- 3. ASIGNATURAS (entidad fuerte)
        -- 4. AULAS (entidad débil - identificada por ASIGNATURAS)
        -- 5. TAQUILLAS (entidad débil - identificada por ALUMNOS)
    
    -- RELACIONES IDENTIFICADAS:
        -- RELACIÓN: ALUMNO - ASIGNATURA (N:M) - MATRICULAS
        -- RELACIÓN: PROFESOR - ASIGNATURA (1:N) - IMPARTE
        -- RELACIÓN: ASIGNATURA - AULA (1:N) - SE_IMPARTE_EN
        -- RELACIÓN: ALUMNO - TAQUILLA (1:1 opcional) - TIENE_ASIGNADA


-- ENTIDAD: ALUMNOS
-- - id_alumno (PK): Identificador único
-- - dni: Documento de identidad (debe ser único)
-- - nombre: Nombre del alumno
-- - apellidos: Apellidos del alumno -- atributo múltiple, se descompone en apellido_pat y apellido_mat
-- - telefonos: Números de teléfono -- atributo multivaluado, se crea tabla aparte
-- - direccion: Dirección completa -- atributo múltiple, se descompone en calle, ciudad, codigo_postal
-- - fecha_nacimiento: Fecha de nacimiento
-- - edad: Edad del alumno -- atributo derivado, se calcula a partir de fecha_nacimiento

-- ENTIDAD: PROFESORES
-- - id_profesor (PK): Identificador único del profesor
-- - dni: Documento de identidad (debe ser único)
-- - nombre: Nombre del profesor
-- - apellidos: Apellidos del profesor
-- - email: Correo electrónico

-- ENTIDAD: ASIGNATURAS
-- - id_asignatura (PK): Identificador único de la asignatura
-- - nombre_asignatura: Nombre de la asignatura
-- - creditos: Número de créditos
-- - curso: Curso en el que se imparte

-- ENTIDAD: AULAS (ENTIDAD DÉBIL)
-- - numero_aula: Número del aula (puede repetirse entre edificios)
-- - edificio: Edificio donde se encuentra el aula
-- - capacidad: Capacidad máxima del aula
-- - PK compuesta: (numero_aula, edificio, id_asignatura) -- hereda la PK de asignaturas

-- ENTIDAD: TAQUILLAS
-- - id_taquilla (PK): Identificador único de la taquilla
-- - numero_taquilla: Número de la taquilla (puede repetirse entre edificios)
-- - edificio: Edificio donde se encuentra la taquilla
-- - estado: Estado de la taquilla (Libre, Ocupada)


-- ==========================================================================================
-- 2) MODELO LOGICO (MR): TABLAS, RELACIONES Y RESTRICCIONES
-- ==========================================================================================
-- Las relaciones se resuelven de la siguiente manera:
-- - N:M entre ALUMNOS y ASIGNATURAS se resuelve con la tabla intermedia: MATRICULAS
-- - 1:N entre PROFESORES y ASIGNATURAS se resuelve añadiendo FK en ASIGNATURAS
-- - 1:N entre ASIGNATURAS y AULAS se resuelve añadiendo FK en AULAS (entidad débil)
-- - 1:1 entre ALUMNOS y TAQUILLAS se resuelve añadiendo FK opcional en ALUMNOS

-- MODELO RESULTANTE: 7 TABLAS CON RESTRICCIONES COMPLETAS
    -- TABLA ALUMNOS (entidad principal)
        -- - id_alumno INT (PK): Identificador único
        -- - dni VARCHAR(10) (UNIQUE + CHECK formato válido): DNI con validación
        -- - nombre VARCHAR(50): Nombre del alumno
        -- - apellido_pat VARCHAR(50): Apellido paterno
        -- - apellido_mat VARCHAR(50): Apellido materno
        -- - calle VARCHAR(100): Dirección - calle
        -- - ciudad VARCHAR(50): Dirección - ciudad
        -- - codigo_postal VARCHAR(5): Dirección - código postal
        -- - fecha_nacimiento DATE: Fecha de nacimiento
        -- - edad INT: Edad calculada (atributo derivado)
        -- - FK_id_taquilla INT NULL (FK): Referencia opcional a TAQUILLAS
    
    -- TABLA TELEFONOS_ALUMNOS (para almacenar múltiples teléfonos por alumno)
        -- - id_telefono INT (PK): Identificador único del registro
        -- - numero_telefono VARCHAR(15): Número de teléfono
        -- - FK_id_alumno INT (FK ON DELETE CASCADE): Referencia a ALUMNOS
    
    -- TABLA PROFESORES (entidad principal)
        -- - id_profesor INT (PK): Identificador único del profesor
        -- - dni VARCHAR(10) (UNIQUE): DNI único
        -- - nombre VARCHAR(50): Nombre del profesor
        -- - apellidos VARCHAR(100): Apellidos completos
        -- - email VARCHAR(100) (UNIQUE + CHECK LIKE '%@%'): Email con validación
    
    -- TABLA ASIGNATURAS (entidad principal)
        -- - id_asignatura INT (PK): Identificador único de la asignatura
        -- - nombre_asignatura VARCHAR(100): Nombre de la asignatura
        -- - creditos INT (CHECK > 0): Número de créditos (debe ser positivo)
        -- - curso INT (CHECK BETWEEN 1 AND 6): Curso (entre 1 y 6)
        -- - FK_id_profesor INT (FK): Referencia a PROFESORES (relación 1:N)
    
    -- TABLA AULAS (entidad débil - depende de ASIGNATURAS)
        -- - numero_aula INT: Número del aula
        -- - edificio VARCHAR(10): Edificio donde se encuentra
        -- - capacidad INT (CHECK > 0): Capacidad máxima (debe ser positiva)
        -- - FK_id_asignatura INT (FK ON DELETE CASCADE): Referencia a ASIGNATURAS
        -- - PK compuesta: (numero_aula, edificio, FK_id_asignatura)
    
    -- TABLA TAQUILLAS (entidad principal)
        -- - id_taquilla INT (PK): Identificador único de la taquilla
        -- - numero_taquilla INT: Número de la taquilla
        -- - edificio VARCHAR(10): Edificio donde se encuentra
        -- - estado ENUM('Libre', 'Ocupada') DEFAULT 'Libre': Estado de la taquilla
    
    -- TABLA MATRICULAS (tabla intermedia - resuelve la relación N:M)
        -- - id_matricula INT (PK): Identificador único de la matrícula
        -- - FK_id_alumno INT (FK ON DELETE CASCADE): Referencia a ALUMNOS
        -- - FK_id_asignatura INT (FK ON DELETE CASCADE): Referencia a ASIGNATURAS
        -- - fecha_matricula DATE (CHECK <= CURDATE()): Fecha de matrícula (no puede ser futura)
        -- - calificacion DECIMAL(4,2) NULL (CHECK BETWEEN 0 AND 10): Calificación (0-10, opcional)

-- TRIGGERS A IMPLEMENTAR:
    -- tr_calcular_edad_insert: AFTER INSERT en alumnos - calcula edad automáticamente
    -- tr_calcular_edad_update: AFTER UPDATE en alumnos - recalcula edad si cambia fecha_nacimiento
    -- tr_ocupar_taquilla: AFTER UPDATE en alumnos - cambia estado taquilla a 'Ocupada'
    -- tr_liberar_taquilla: AFTER UPDATE en alumnos - cambia estado taquilla a 'Libre'

-- =============================================
-- FIN DE LAS DEFINICIONES INICIALES
-- =============================================