# SQL-Prueba-1 Pregunta 1 a 16

Pruebas SQL- y transformación de datos. 


SELECT
    COALESCE(ep.rol, 'Sin rol') AS rol,
    COALESCE(p.nombre, 'Sin nombre') AS proyecto
FROM empleados_proyectos ep
INNER JOIN proyectos p ON ep.proyecto_id = p.id
GROUP BY p.nombre, ep.rol
ORDER BY p.nombre, ep.rol;
-- Esta sentencia SELECT muestra los roles de los empleados y los nombres de los proyectos, agrupados por proyecto y rol.

SELECT e.nombre AS empleado, e.fecha_ingreso, COUNT(ep.proyecto_id) AS total_proyectos
FROM empleados e
JOIN empleados_proyectos ep ON e.id = ep.empleado_id
WHERE e.fecha_ingreso < '2021-01-01'
GROUP BY e.nombre, e.fecha_ingreso
HAVING COUNT(ep.proyecto_id) > 1
ORDER BY e.nombre;
-- Esta sentencia SELECT lista los empleados que ingresaron antes de 2021-01-01 y están asignados a más de un proyecto.

use PRU1

WITH RolFrecuencia AS (
    SELECT rol, COUNT(*) AS total
    FROM empleados_proyectos
    GROUP BY rol
),
RolMasRepetido AS (
    SELECT TOP 1 rol
    FROM RolFrecuencia
    ORDER BY total DESC
)
SELECT COALESCE(e.nombre, 'Sin nombre') AS empleado, COALESCE(ep.rol, 'Sin rol') AS rol
FROM empleados_proyectos ep
INNER JOIN empleados e ON ep.empleado_id = e.id
WHERE ep.rol = (SELECT rol FROM RolMasRepetido)
ORDER BY e.nombre;
-- Esta sentencia SELECT recupera los nombres de los empleados y sus roles para aquellos que tienen el rol más frecuente en la tabla 'empleados_proyectos'.

use PRU1

SELECT
    SUM(COALESCE(e.salario, 0) * 1.10) AS nuevo_salario_total
FROM empleados e
INNER JOIN empleados_proyectos ep ON e.id = ep.empleado_id
WHERE ep.proyecto_id = 2;
-- Esta sentencia SELECT calcula la suma total de los salarios de los empleados en el proyecto con ID 2, aumentados en un 10%.

--OP2

SELECT
    SUM(e.salario * 1.10) AS nuevo_salario_total
FROM empleados e
JOIN empleados_proyectos ep ON e.id = ep.empleado_id
WHERE ep.proyecto_id = 2;
-- Esta sentencia SELECT calcula la suma total de los salarios de los empleados en el proyecto con ID 2, aumentados en un 10%.

--op3
SELECT
    e.nombre AS empleado,
    e.salario AS salario_original,
    ROUND(e.salario * 1.10, 2) AS salario_aumentado
FROM empleados e
JOIN empleados_proyectos ep ON e.id = ep.empleado_id
WHERE ep.proyecto_id = 2
ORDER BY e.nombre;
-- Esta sentencia SELECT muestra el nombre, salario original y salario aumentado en un 10% para los empleados en el proyecto con ID 2.

-- Total acumulado de los nuevos salarios
SELECT
    SUM(ROUND(e.salario * 1.10, 2)) AS total_nuevo_salario
FROM empleados e
JOIN empleados_proyectos ep ON e.id = ep.empleado_id
WHERE ep.proyecto_id = 2;
-- Esta sentencia SELECT calcula la suma total de los salarios aumentados en un 10% para los empleados en el proyecto con ID 2.
