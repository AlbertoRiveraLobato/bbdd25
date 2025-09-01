-- Ejemplos de Vistas en una Base de Datos para un Sistema de Domótica en el Hogar.

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS domotica_hogar;
USE domotica_hogar;

-- Crear tabla de dispositivos
CREATE TABLE dispositivos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('iluminacion', 'climatizacion', 'seguridad', 'entretenimiento') NOT NULL,
    ubicacion VARCHAR(100) NOT NULL,
    estado ENUM('activado', 'desactivado', 'modo_ahorro') DEFAULT 'desactivado',
    consumo_energia DECIMAL(8,2), -- en vatios
    fecha_instalacion DATE
);

-- Crear tabla de sensores
CREATE TABLE sensores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('temperatura', 'humedad', 'movimiento', 'luz', 'puerta_ventana') NOT NULL,
    ubicacion VARCHAR(100) NOT NULL,
    valor_actual DECIMAL(8,2),
    unidad VARCHAR(20),
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Crear tabla de eventos
CREATE TABLE eventos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dispositivo_id INT NULL,
    sensor_id INT NULL,
    tipo_evento VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dispositivo_id) REFERENCES dispositivos(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (sensor_id) REFERENCES sensores(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Insertar datos de ejemplo
INSERT INTO dispositivos (nombre, tipo, ubicacion, estado, consumo_energia, fecha_instalacion) VALUES
('Luz Sala Principal', 'iluminacion', 'Sala', 'activado', 15.50, '2024-01-15'),
('Aire Acondicionado', 'climatizacion', 'Sala', 'modo_ahorro', 850.00, '2024-02-10'),
('Alarma Principal', 'seguridad', 'Entrada', 'activado', 5.75, '2024-01-20'),
('TV Smart', 'entretenimiento', 'Sala', 'desactivado', 120.00, '2024-03-05'),
('Luz Cocina', 'iluminacion', 'Cocina', 'activado', 12.30, '2024-01-15'),
('Calefactor', 'climatizacion', 'Dormitorio', 'desactivado', 1500.00, '2024-02-20');

INSERT INTO sensores (nombre, tipo, ubicacion, valor_actual, unidad) VALUES
('Sensor Temp Sala', 'temperatura', 'Sala', 22.5, '°C'),
('Sensor Humedad', 'humedad', 'Sala', 45.0, '%'),
('Sensor Movimiento', 'movimiento', 'Entrada', 1, 'estado'),
('Sensor Luz', 'luz', 'Sala', 300, 'lux'),
('Sensor Puerta Principal', 'puerta_ventana', 'Entrada', 0, 'estado');

INSERT INTO eventos (dispositivo_id, sensor_id, tipo_evento, descripcion) VALUES
(1, NULL, 'encendido', 'Luz encendida manualmente'),
(NULL, 1, 'umbral_temperatura', 'Temperatura superó los 22°C'),
(2, 1, 'activacion_automatica', 'AC activado por temperatura alta'),
(4, NULL, 'apagado', 'TV apagado por inactividad'),
(NULL, 3, 'deteccion_movimiento', 'Movimiento detectado en entrada');

-- =============================================================================
-- EJEMPLOS DE VISTAS
-- =============================================================================

-- 1. Vista para dispositivos activos con su consumo
CREATE OR REPLACE VIEW vista_dispositivos_activos AS
SELECT 
    nombre,
    tipo,
    ubicacion,
    estado,
    consumo_energia,
    -- Calcular consumo diario estimado (8 horas para algunos dispositivos)
    CASE 
        WHEN tipo = 'iluminacion' THEN consumo_energia * 8
        WHEN tipo = 'climatizacion' THEN consumo_energia * 6
        ELSE consumo_energia * 4
    END AS consumo_diario_estimado
FROM dispositivos
WHERE estado = 'activado' OR estado = 'modo_ahorro';

-- Consultar la vista
SELECT * FROM vista_dispositivos_activos;

-- 2. Vista para estadísticas de consumo por tipo de dispositivo
CREATE OR REPLACE VIEW vista_consumo_por_tipo AS
SELECT 
    tipo,
    COUNT(*) as cantidad_dispositivos,
    SUM(consumo_energia) as consumo_total,
    AVG(consumo_energia) as consumo_promedio,
    MAX(consumo_energia) as consumo_maximo,
    MIN(consumo_energia) as consumo_minimo
FROM dispositivos
WHERE estado != 'desactivado'
GROUP BY tipo;

-- Consultar la vista
SELECT * FROM vista_consumo_por_tipo;

-- 3. Vista para eventos recientes con información de dispositivos y sensores
CREATE OR REPLACE VIEW vista_eventos_recientes AS
SELECT 
    e.fecha_hora,
    COALESCE(d.nombre, 'Sistema') as dispositivo,
    COALESCE(s.nombre, 'N/A') as sensor,
    e.tipo_evento,
    e.descripcion
FROM eventos e
LEFT JOIN dispositivos d ON e.dispositivo_id = d.id     -- Vería los eventos de cada dispositvo.
LEFT JOIN sensores s ON e.sensor_id = s.id              -- Vería los eventos de cada sensor.
ORDER BY e.fecha_hora DESC;

-- Consultar la vista
SELECT * FROM vista_eventos_recientes;

-- 4. Vista para sensores con valores críticos
CREATE OR REPLACE VIEW vista_sensores_criticos AS
SELECT 
    nombre,
    tipo,
    ubicacion,
    valor_actual,
    unidad,
    CASE 
        WHEN tipo = 'temperatura' AND valor_actual > 25 THEN 'ALTA'
        WHEN tipo = 'temperatura' AND valor_actual < 18 THEN 'BAJA'
        WHEN tipo = 'humedad' AND valor_actual > 60 THEN 'ALTA'
        WHEN tipo = 'humedad' AND valor_actual < 30 THEN 'BAJA'
        WHEN tipo = 'movimiento' AND valor_actual = 1 THEN 'DETECTADO'
        WHEN tipo = 'puerta_ventana' AND valor_actual = 1 THEN 'ABIERTO'
        ELSE 'NORMAL'
    END as estado_critico
FROM sensores;

-- Consultar la vista
SELECT * FROM vista_sensores_criticos;

-- 5. Vista para resumen del hogar inteligente
CREATE OR REPLACE VIEW vista_resumen_hogar AS
SELECT 
    (SELECT COUNT(*) FROM dispositivos WHERE estado != 'desactivado') as dispositivos_activos,
    (SELECT COUNT(*) FROM sensores) as sensores_totales,
    (SELECT COUNT(*) FROM eventos WHERE fecha_hora >= CURDATE()) as eventos_hoy,
    (SELECT SUM(consumo_energia) FROM dispositivos WHERE estado != 'desactivado') as consumo_total_actual;

-- Consultar la vista
SELECT * FROM vista_resumen_hogar;

-- =============================================================================
-- EJEMPLOS DE CONSULTAS SOBRE VISTAS
-- =============================================================================

-- 1. Mostrar solo los sensores en estado crítico
SELECT * FROM vista_sensores_criticos 
WHERE estado_critico != 'NORMAL';

-- 2. Calcular el consumo energético total diario estimado
SELECT 
    SUM(consumo_diario_estimado) as consumo_total_diario,
    ROUND(SUM(consumo_diario_estimado) * 0.15 / 1000, 2) as costo_diario_estimado -- Suponiendo €0.15/kWh
FROM vista_dispositivos_activos;

-- 3. Eventos de las últimas 24 horas
SELECT * FROM vista_eventos_recientes 
WHERE fecha_hora >= NOW() - INTERVAL 24 HOUR;

-- =============================================================================
-- VENTAJAS DE USAR VISTAS
-- =============================================================================

/*
1. SEGURIDAD: Limitan el acceso a datos sensibles
2. SIMPLICIDAD: Ocultar consultas complejas
3. CONSISTENCIA: Misma lógica para todos los usuarios
4. MANTENIMIENTO: Fácil actualización sin afectar aplicaciones
5. ORGANIZACIÓN: Mejor estructuración de consultas frecuentes
*/

-- Mostrar todas las vistas creadas
SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW';