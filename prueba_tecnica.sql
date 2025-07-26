
-- Tabla de departamentos
CREATE TABLE departamentos (
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Tabla de empleados
CREATE TABLE empleados (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    departamento_id INT,
    salario DECIMAL(10, 2),
    fecha_ingreso DATE,
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id)
);

-- Tabla de proyectos
CREATE TABLE proyectos (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    fecha_inicio DATE,
    fecha_fin DATE
);

-- Relación muchos a muchos: empleados asignados a proyectos
CREATE TABLE empleados_proyectos (
    empleado_id INT,
    proyecto_id INT,
    rol VARCHAR(100),
    PRIMARY KEY (empleado_id, proyecto_id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id),
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id)
);

-- Inserts
INSERT INTO departamentos VALUES
(1, 'TI'), (2, 'Recursos Humanos'), (3, 'Marketing'), (4, 'Finanzas');

INSERT INTO empleados VALUES
(1, 'Luis Pérez', 1, 28000, '2021-05-10'),
(2, 'Ana Torres', 1, 29000, '2020-11-20'),
(3, 'Carlos Gómez', 2, 21000, '2023-01-01'),
(4, 'Marta Díaz', 3, 23000, '2022-03-15'),
(5, 'Juan López', 2, 22000, '2019-09-09'),
(6, 'Elena Vargas', 4, 31000, '2020-02-10'),
(7, 'Pedro Ramírez', 1, 27500, '2023-07-01'),
(8, 'Lucía Sánchez', 3, 24000, '2023-02-01');

INSERT INTO proyectos VALUES
(1, 'Sistema Interno', '2024-01-01', '2024-06-01'),
(2, 'Rediseño Web', '2024-03-01', NULL),
(3, 'Campaña RRHH', '2023-10-15', '2024-04-01'),
(4, 'Rebranding', '2023-11-01', NULL),
(5, 'Auditoría Fiscal', '2023-07-01', '2023-12-15');

INSERT INTO empleados_proyectos VALUES
(1, 1, 'Dev'),
(2, 1, 'QA'),
(2, 2, 'Dev'),
(3, 3, 'Analista'),
(5, 3, 'Asistente'),
(6, 5, 'Asesor'),
(7, 2, 'Front-End'),
(1, 4, 'DevOps'),
(8, 4, 'Diseño');
