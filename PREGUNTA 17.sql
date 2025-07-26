USE PRU2;
GO
-- 1. CONTROL DE ACCESO CON ROLES Y VISTAS


--1 Creacion roles de seguridad
CREATE ROLE rol_publico;
CREATE ROLE rol_rh;
GO

-- 2 Revocar SELECT directo sobre tablas sensibles
DENY SELECT ON dbo.empleados TO rol_publico;
DENY SELECT ON dbo.empleados_proyectos TO rol_publico;
GO

--3 Crear vistas con control de acceso

-- Vista pública sin salarios ni asignaciones
CREATE VIEW vista_empleados_publica AS
SELECT id, nombre, departamento_id
FROM dbo.empleados;
GO

-- 4 Vista solo para RH
CREATE VIEW vista_empleados_rh AS
SELECT id, nombre, salario, departamento_id
FROM dbo.empleados
WHERE departamento_id = 2; -- Recursos Humanos
GO

-- 5 Conceder acceso solo a las vistas
GRANT SELECT ON vista_empleados_publica TO rol_publico;
GRANT SELECT ON vista_empleados_rh TO rol_rh;
GO


-- 6 Cifrado para columna con Always Encrypted, se debe configurar desde la terminal PowerShell o SSMS.
-- script es referencial y solo se ejecuta definiendo las claves válidas.

-- clave maestra y clave de cifrado (solo referencial aquí)
-- Estas acciones normalmente se hacen en el asistente de Always Encrypted

/*
CREATE COLUMN MASTER KEY CMK_Seguridad
WITH (
    KEY_STORE_PROVIDER_NAME = 'MSSQL_CERTIFICATE_STORE',
    KEY_PATH = 'CurrentUser/My/CN=ClaveAlwaysEncrypted'
);
GO

CREATE COLUMN ENCRYPTION KEY CEK_Seguridad
WITH VALUES (
    COLUMN_MASTER_KEY = CMK_Seguridad,
    ALGORITHM = 'RSA_OAEP',
    ENCRYPTED_VALUE = <valor_cifrado>);
GO
-- Aplicar cifrado a la columna salario
ALTER TABLE empleados
ALTER COLUMN salario 
ADD ENCRYPTED WITH (
    ENCRYPTION_TYPE = RANDOMIZED,
    COLUMN_ENCRYPTION_KEY = CEK_Seguridad );
GO
*/

-- 7. Enmascaramiento de datosS (DDM)

-- Verificar si ya existe enmascaramiento, y aplicarlo si no
-- IMPORTANTE: solo se puede aplicar si la tabla es nueva o no tiene restricciones de encriptado.

-- Aplicar máscara a salario
-- *Solo si no tiene encriptación activa*

ALTER TABLE empleados
ALTER COLUMN salario 
ADD MASKED WITH (FUNCTION = 'default()');
GO

-- Prueba con usuario sin privilegios
-- SELECT nombre, salario FROM empleados;


-- 8.Registro( AUDITORÍA DE ACCESOS).
-- Crear auditoría (a nivel servidor)
CREATE SERVER AUDIT Audit_Salarios
TO FILE (FILEPATH = 'C:\AuditLogs\')
WITH (ON_FAILURE = CONTINUE);
GO

-- Activar auditoría
ALTER SERVER AUDIT Audit_Salarios
WITH (STATE = ON);
GO

-- Crear especificación a nivel de base de datos
CREATE DATABASE AUDIT SPECIFICATION AuditSelectSalario
FOR SERVER AUDIT Audit_Salarios
ADD (SELECT ON OBJECT::dbo.empleados BY PUBLIC)
WITH (STATE = ON);
GO
