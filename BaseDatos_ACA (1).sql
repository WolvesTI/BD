
-- PROYECTO ACA - PITCH FINAL: BASES DE DATOS (CUN)
-- Contexto: Sistema de Gestión de Soporte Técnico y Reparación de PC


CREATE DATABASE IF NOT EXISTS ACA_SoporteTecnico;
USE ACA_SoporteTecnico;

-- Eliminar tablas en orden inverso a sus dependencias si existen
DROP TABLE IF EXISTS OrdenServicio;
DROP TABLE IF EXISTS Equipo;
DROP TABLE IF EXISTS Servicio;
DROP TABLE IF EXISTS Tecnico;
DROP TABLE IF EXISTS Cliente;

-- Tabla Cliente: Registro de datos de contacto de propietarios de equipos
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(150)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla Tecnico: Personal técnico encargado de las reparaciones
CREATE TABLE Tecnico (
    id_tecnico INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla Equipo: Dispositivos registrados por cliente
CREATE TABLE Equipo (
    id_equipo INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    tipo_equipo VARCHAR(50) NOT NULL, -- Laptop, Desktop, All-in-One
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50),
    numero_serie VARCHAR(50) UNIQUE,
    CONSTRAINT fk_equipo_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla Servicio: Catálogo comercial de servicios de soporte y precios base
CREATE TABLE Servicio (
    id_servicio INT PRIMARY KEY AUTO_INCREMENT,
    nombre_servicio VARCHAR(100) NOT NULL,
    precio_base DECIMAL(10, 2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla OrdenServicio: Ticket central que integra Cliente, Equipo, Técnico y Servicio
CREATE TABLE OrdenServicio (
    id_orden INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_equipo INT NOT NULL,
    id_tecnico INT NOT NULL,
    id_servicio INT NOT NULL,
    fecha_ingreso DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega DATETIME NULL,
    estado VARCHAR(30) NOT NULL DEFAULT 'En Diagnostico', -- En Recepcion, En Diagnostico, En Reparacion, Finalizado, Entregado
    falla_reportada TEXT NOT NULL,
    observaciones_tecnicas TEXT NULL,
    costo_total DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_orden_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_orden_equipo FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo),
    CONSTRAINT fk_orden_tecnico FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id_tecnico),
    CONSTRAINT fk_orden_servicio FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ----------------------------------------------------------
-- 2. SENTENCIAS DML (CARGA DE DATOS DE PRUEBA REALISTAS)
-- ----------------------------------------------------------

-- Insertar Clientes
INSERT INTO Cliente (nombre, correo, telefono, direccion) VALUES
('Carlos Mendoza', 'carlos.mendoza@gmail.com', '3001234567', 'Calle 45 # 12-34, Bogotá'),
('María Fernanda Gómez', 'mf.gomez@hotmail.com', '3159876543', 'Carrera 7 # 85-20, Bogotá'),
('Andrés Felipe Rocha', 'andres.rocha@outlook.com', '3104567890', 'Av. Suba # 115-05, Bogotá'),
('Laura Sofía Benítez', 'laura.benitez@yahoo.com', '3186543210', 'Calle 100 # 19-45, Bogotá'),
('Empresa Logística del Norte S.A.S.', 'contacto@logisticanorte.com', '6017458900', 'Zona Franca Fontibón Bodega 12, Bogotá');

-- Insertar Técnicos
INSERT INTO Tecnico (nombre, especialidad, telefono, estado) VALUES
('Jorge Eliecer Martínez', 'Hardware y Microelectrónica', '3112223344', 'Activo'),
('Diana Marcela Ruiz', 'Sistemas Operativos y Software', '3123334455', 'Activo'),
('Camilo Ernesto Torres', 'Mantenimiento Preventivo y Redes', '3134445566', 'Activo'),
('Paula Andrea Silva', 'Recuperación de Datos y Almacenamiento', '3145556677', 'Activo');

-- Insertar Equipos
INSERT INTO Equipo (id_cliente, tipo_equipo, marca, modelo, numero_serie) VALUES
(1, 'Laptop', 'Lenovo', 'ThinkPad T14', 'SN-THINK-9981'),
(2, 'Desktop', 'HP', 'Pavilion Gaming TG01', 'SN-HP-4412'),
(3, 'Laptop', 'ASUS', 'ROG Zephyrus G14', 'SN-ASUS-7710'),
(4, 'All-in-One', 'Dell', 'Inspiron 24 5000', 'SN-DELL-3321'),
(5, 'Laptop', 'Apple', 'MacBook Pro M2 16"', 'SN-APPLE-8834'),
(5, 'Desktop', 'Custom PC', 'Core i7 / RTX 3060', 'SN-CUSTOM-1002');

-- Insertar Servicios
INSERT INTO Servicio (nombre_servicio, precio_base) VALUES
('Diagnóstico General de Hardware', 35000.00),
('Mantenimiento Preventivo y Limpieza Térmica', 85000.00),
('Reinstalación de Sistema Operativo y Drivers', 95000.00),
('Cambio de Pantalla o Pantalla LCD', 250000.00),
('Reparación de Tarjeta Madre / Microchip', 320000.00),
('Recuperación Avanzada de Información de Disco', 180000.00);

-- Insertar Órdenes de Servicio
INSERT INTO OrdenServicio (id_cliente, id_equipo, id_tecnico, id_servicio, fecha_ingreso, fecha_entrega, estado, falla_reportada, observaciones_tecnicas, costo_total) VALUES
(1, 1, 1, 5, '2026-09-01 09:30:00', NULL, 'En Diagnostico', 'El equipo no enciende tras descarga eléctrica.', 'Se identifica corto en circuito primario de carga.', 320000.00),
(2, 2, 2, 3, '2026-09-02 11:15:00', '2026-09-03 16:00:00', 'Entregado', 'Pantallazos azules de error de memoria y lentitud.', 'Se reinstaló Windows 11 Pro de 64 bits y drivers oficiales.', 95000.00),
(3, 3, 1, 2, '2026-09-03 14:00:00', NULL, 'En Reparacion', 'Sobrecalentamiento excesivo y apago repentino al jugar.', 'Cambio de crema disipadora de pasta térmica y limpieza de ventiladores.', 85000.00),
(4, 4, 3, 4, '2026-09-04 10:00:00', NULL, 'En Diagnostico', 'Display partido por caída accidental.', 'Se requiere pedir repuesto original Dell de 24 pulgadas.', 250000.00),
(5, 5, 4, 6, '2026-09-04 15:30:00', NULL, 'En Reparacion', 'Disco de almacenamiento no reconocido por el sistema.', 'Proceso de lectura sector por sector con herramienta de laboratorio.', 180000.00),
(5, 6, 3, 2, '2026-09-05 08:45:00', '2026-09-05 17:30:00', 'Finalizado', 'Mantenimiento corporativo programado de rutina.', 'Equipo soplado, cambio de pasta térmica y optimización de discos.', 85000.00),
(1, 1, 2, 1, '2026-09-06 12:00:00', NULL, 'En Diagnostico', 'Revisión secundaria de puertos USB defectuosos.', 'En evaluación por el especialista de software y controladores.', 35000.00);


-- ----------------------------------------------------------
-- 3. CONSULTAS SQL DE NEGOCIO (Q1 A Q5)
-- ----------------------------------------------------------

-- Q1: Listado general de seguimiento de órdenes de servicio registradas
SELECT 
    O.id_orden AS Ticket,
    C.nombre AS Cliente,
    E.marca AS Marca_Equipo,
    E.modelo AS Modelo_Equipo,
    T.nombre AS Tecnico_Asignado,
    S.nombre_servicio AS Servicio_Solicitado,
    O.estado AS Estado_Actual,
    O.costo_total AS Valor_Total
FROM OrdenServicio O
JOIN Cliente C ON O.id_cliente = C.id_cliente
JOIN Equipo E ON O.id_equipo = E.id_equipo
JOIN Tecnico T ON O.id_tecnico = T.id_tecnico
JOIN Servicio S ON O.id_servicio = S.id_servicio
ORDER BY O.fecha_ingreso DESC;

-- Q2: Ranking de servicios con mayor demanda y volumen de ingresos generados
SELECT 
    S.nombre_servicio AS Servicio,
    COUNT(O.id_orden) AS Cantidad_Solicitudes,
    SUM(O.costo_total) AS Facturacion_Total,
    AVG(O.costo_total) AS Promedio_Por_Servicio
FROM OrdenServicio O
JOIN Servicio S ON O.id_servicio = S.id_servicio
GROUP BY S.id_servicio, S.nombre_servicio
ORDER BY Cantidad_Solicitudes DESC, Facturacion_Total DESC;

-- Q3: Control de flujo de ingresos y equipos atendidos en un periodo de tiempo específico
SELECT 
    O.id_orden AS Ticket,
    O.fecha_ingreso AS Fecha_Ingreso,
    C.nombre AS Cliente,
    E.tipo_equipo AS Tipo_PC,
    O.estado AS Estado,
    O.costo_total AS Costo
FROM OrdenServicio O
JOIN Cliente C ON O.id_cliente = C.id_cliente
JOIN Equipo E ON O.id_equipo = E.id_equipo
WHERE O.fecha_ingreso BETWEEN '2026-09-01 00:00:00' AND '2026-09-07 23:59:59'
ORDER BY O.fecha_ingreso ASC;

-- Q4: Carga de trabajo por técnico asignado para detección de cuellos de botella
SELECT 
    T.id_tecnico AS ID_Tecnico,
    T.nombre AS Tecnico,
    T.especialidad AS Especialidad,
    COUNT(O.id_orden) AS Total_Ordenes_Asignadas,
    SUM(CASE WHEN O.estado IN ('En Recepcion', 'En Diagnostico', 'En Reparacion') THEN 1 ELSE 0 END) AS Ordenes_Pendientes,
    SUM(CASE WHEN O.estado IN ('Finalizado', 'Entregado') THEN 1 ELSE 0 END) AS Ordenes_Completadas
FROM Tecnico T
LEFT JOIN OrdenServicio O ON T.id_tecnico = O.id_tecnico
GROUP BY T.id_tecnico, T.nombre, T.especialidad
ORDER BY Total_Ordenes_Asignadas DESC;

-- Q5: Consulta crítica para toma de decisiones ejecutivas (Equipos en Estado 'En Diagnóstico')
SELECT 
    O.id_orden AS Ticket_Diagnostico,
    C.nombre AS Cliente,
    C.telefono AS Contacto_Cliente,
    E.marca AS Marca,
    E.modelo AS Modelo,
    T.nombre AS Tecnico_Responsable,
    O.falla_reportada AS Falla,
    O.costo_total AS Valor_Estimado
FROM OrdenServicio O
JOIN Cliente C ON O.id_cliente = C.id_cliente
JOIN Equipo E ON O.id_equipo = E.id_equipo
JOIN Tecnico T ON O.id_tecnico = T.id_tecnico
WHERE O.estado = 'En Diagnostico'
ORDER BY O.fecha_ingreso ASC;
