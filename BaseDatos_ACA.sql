-- ==========================================================
-- Script SQL ejecutable - Proyecto ACA: Bases de Datos
-- Contexto: Empresa de Soporte Técnico y Reparación de PC
-- Archivo: BaseDatos_ACA.sql
-- ==========================================================

-- 1. Sentencias DDL (CREATE DATABASE, CREATE TABLE)
CREATE DATABASE ACA_SoporteTecnico;
USE ACA_SoporteTecnico;

-- Tabla Cliente
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE,
    telefono VARCHAR(20) NOT NULL
);

-- Tabla Tecnico
CREATE TABLE Tecnico (
    id_tecnico INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(50),
    telefono VARCHAR(20)
);

-- Tabla Equipo
CREATE TABLE Equipo (
    id_equipo INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    tipo_equipo VARCHAR(50) NOT NULL, -- Laptop, Desktop, All-in-One
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Tabla Servicio
CREATE TABLE Servicio (
    id_servicio INT PRIMARY KEY AUTO_INCREMENT,
    nombre_servicio VARCHAR(100) NOT NULL,
    precio_base DECIMAL(10, 2) NOT NULL
);

-- Tabla OrdenServicio
CREATE TABLE OrdenServicio (
    id_orden INT PRIMARY KEY AUTO_INCREMENT,
    id_equipo INT NOT NULL,
    id_tecnico INT NOT NULL,
    id_servicio INT NOT NULL,
    fecha_recepcion DATE NOT NULL,
    estado VARCHAR(20) NOT NULL, -- Recibido, En Diagnostico, Reparado, Entregado
    costo_final DECIMAL(10, 2),
    FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo),
    FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id_tecnico),
    FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio)
);

-- 2. Sentencias DML (INSERT) con datos de prueba realistas
INSERT INTO Cliente (nombre, correo, telefono) VALUES
('Ana Gomez', 'ana.gomez@email.com', '3001234567'),
('Luis Perez', 'luis.perez@email.com', '3109876543'),
('Carlos Ruiz', 'carlos.ruiz@email.com', '3205554433'),
('Maria Lopez', 'maria.lopez@email.com', '3004445566');

INSERT INTO Tecnico (nombre, especialidad, telefono) VALUES
('Javier Torres', 'Hardware y Soldadura', '3112223344'),
('Sofia Castro', 'Software y Redes', '3123334455');

INSERT INTO Equipo (id_cliente, tipo_equipo, marca, modelo) VALUES
(1, 'Laptop', 'Lenovo', 'ThinkPad T14'),
(1, 'Desktop', 'HP', 'Pavilion'),
(2, 'Laptop', 'Dell', 'XPS 15'),
(3, 'Laptop', 'Apple', 'MacBook Pro'),
(4, 'All-in-One', 'Asus', 'ZenAiO');

INSERT INTO Servicio (nombre_servicio, precio_base) VALUES
('Mantenimiento Preventivo', 80000.00),
('Reinstalacion Sistema Operativo', 120000.00),
('Cambio de Pantalla', 250000.00),
('Reparacion de Placa Base', 350000.00);

INSERT INTO OrdenServicio (id_equipo, id_tecnico, id_servicio, fecha_recepcion, estado, costo_final) VALUES
(1, 1, 1, '2026-08-01', 'Entregado', 80000.00),
(2, 2, 2, '2026-08-05', 'Entregado', 120000.00),
(3, 1, 3, '2026-08-10', 'Reparado', 280000.00),
(4, 2, 2, '2026-08-15', 'En Diagnostico', NULL),
(5, 1, 4, '2026-08-20', 'Recibido', NULL),
(1, 2, 2, '2026-08-25', 'Recibido', NULL);

-- 3. Consultas SQL de Negocio (5 consultas)

-- Q1: ¿Qué información básica necesita consultar el responsable? (Estado actual de las órdenes)
SELECT o.id_orden, c.nombre AS cliente, e.tipo_equipo, e.marca, s.nombre_servicio, o.estado 
FROM OrdenServicio o
JOIN Equipo e ON o.id_equipo = e.id_equipo
JOIN Cliente c ON e.id_cliente = c.id_cliente
WHERE o.estado IN ('Recibido', 'En Diagnostico', 'Reparado');

-- Q2: ¿Qué elemento tiene mayor movimiento? (Servicios más solicitados)
SELECT s.nombre_servicio, COUNT(o.id_servicio) AS total_solicitudes
FROM OrdenServicio o
JOIN Servicio s ON o.id_servicio = s.id_servicio
GROUP BY s.nombre_servicio
ORDER BY total_solicitudes DESC;

-- Q3: ¿Qué ocurrió durante un periodo? (Ingresos generados por servicios finalizados)
SELECT SUM(costo_final) AS ingresos_totales
FROM OrdenServicio
WHERE estado = 'Entregado';

-- Q4: ¿Qué comportamiento o relación es relevante? (Clientes frecuentes con más órdenes)
SELECT c.nombre, COUNT(o.id_orden) AS total_ordenes
FROM Cliente c
JOIN Equipo e ON c.id_cliente = e.id_cliente
JOIN OrdenServicio o ON e.id_equipo = o.id_equipo
GROUP BY c.nombre
ORDER BY total_ordenes DESC;

-- Q5: ¿Qué dato puede apoyar una decisión? (Carga de trabajo por técnico para asignaciones)
SELECT t.nombre, COUNT(o.id_orden) AS ordenes_activas
FROM Tecnico t
JOIN OrdenServicio o ON t.id_tecnico = o.id_tecnico
WHERE o.estado IN ('Recibido', 'En Diagnostico', 'Reparado')
GROUP BY t.nombre
ORDER BY ordenes_activas DESC;
