
CALL sp_Ingresados(0,33);
DROP PROCEDURE sp_Ingresados;
DELIMITER //
CREATE PROCEDURE sp_Ingresados(
	IN operacion INT,
    IN idPacientep INT
)
BEGIN
	SET @LidPaciente = idPacienteP;
    
    IF operacion = 0 THEN
		INSERT INTO ingresados(idPaciente) 
        VALUES (@LidPaciente);
		SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 2 THEN
		DELETE FROM ingresados WHERE idPaciente = @LidPaciente;
    END IF;
    
    IF operacion = 3 THEN
		SELECT 
			id AS IdPaciente,
			nombre AS NombrePaciente,
			noHistoriaClinica AS NoHistoriaClinica,
			edad AS Edad,
			riesgo AS RiesgoPaciente,
			prioridad AS PrioridadPaciente
		FROM paciente
		WHERE id NOT IN (SELECT idPaciente FROM ingresados)
		AND id NOT IN (SELECT IFNULL(paciente,0) FROM consulta );
    END IF;
    
    IF operacion = 4 THEN
		SELECT 
			ingresados.id as idInsertado,
			ingresados.idPaciente as idPaciente,
			paciente.nombre as NombrePaciente,
			paciente.edad as NombreEdad,
			paciente.noHistoriaClinica as NumeroHistoriaClinica,
			paciente.riesgo as Riesgo,
			paciente.prioridad as Prioridad
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente;
    END IF;
    
    IF operacion = 5 THEN
		(SELECT 
			ingresados.idPaciente AS IdPaciente,
            ingresados.fechaIngreso AS FechaIngreso,
			paciente.nombre AS NombrePaciente,
			paciente.edad AS EdadPaciente,
			paciente.noHistoriaClinica AS NumeroHistoriaClinica,
			paciente.riesgo AS RiesgoPaciente,
			paciente.prioridad AS PrioridadPaciente
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente
		WHERE paciente.edad > 0 and paciente.edad < 16 OR paciente.edad > 40
        ORDER BY paciente.prioridad DESC)
		 UNION       
		(SELECT 
				ingresados.idPaciente AS IdPaciente,
				ingresados.fechaIngreso AS FechaIngreso,
				paciente.nombre AS NombrePaciente,
				paciente.edad AS EdadPaciente,
				paciente.noHistoriaClinica AS NumeroHistoriaClinica,
				paciente.riesgo AS RiesgoPaciente,
				paciente.prioridad AS PrioridadPaciente
			FROM ingresados
			INNER JOIN paciente ON paciente.id = ingresados.idPaciente
			WHERE paciente.edad > 15 and paciente.edad < 41
			ORDER BY paciente.prioridad DESC );
    END IF;
END//
DELIMITER ;

(SELECT 
			ingresados.idPaciente AS IdPaciente,
            ingresados.fechaIngreso AS FechaIngreso,
			paciente.nombre AS NombrePaciente,
			paciente.edad AS EdadPaciente,
			paciente.noHistoriaClinica AS NumeroHistoriaClinica,
			paciente.riesgo AS RiesgoPaciente,
			paciente.prioridad AS PrioridadPaciente
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente
		WHERE paciente.edad > 0 and paciente.edad < 16 OR paciente.edad > 40
        ORDER BY paciente.prioridad DESC, ingresados.fechaIngreso ASC)
		 UNION       
		(SELECT 
				ingresados.idPaciente AS IdPaciente,
				ingresados.fechaIngreso AS FechaIngreso,
				paciente.nombre AS NombrePaciente,
				paciente.edad AS EdadPaciente,
				paciente.noHistoriaClinica AS NumeroHistoriaClinica,
				paciente.riesgo AS RiesgoPaciente,
				paciente.prioridad AS PrioridadPaciente
			FROM ingresados
			INNER JOIN paciente ON paciente.id = ingresados.idPaciente
			WHERE paciente.edad > 15 and paciente.edad < 41
			ORDER BY paciente.prioridad DESC, ingresados.fechaIngreso ASC );



/*
SELECT 
			ingresados.idPaciente AS IdPaciente,
            ingresados.fechaIngreso AS FechaIngreso,
			paciente.nombre AS NombrePaciente,
			paciente.edad AS EdadPaciente,
			paciente.noHistoriaClinica AS NumeroHistoriaClinica,
			paciente.riesgo AS RiesgoPaciente,
			paciente.prioridad AS PrioridadPaciente
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente
		ORDER BY paciente.prioridad DESC;


*/
        
        
SELECT 
			ingresados.idPaciente AS IdPaciente,
            ingresados.fechaIngreso AS FechaIngreso,
			paciente.nombre AS NombrePaciente,
			paciente.edad AS EdadPaciente,
			paciente.noHistoriaClinica AS NumeroHistoriaClinica,
			paciente.riesgo AS RiesgoPaciente,
			paciente.prioridad AS PrioridadPaciente
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente
		ORDER BY paciente.prioridad DESC;

SELECT 
			ingresados.idPaciente AS IdPaciente,
            ingresados.fechaIngreso AS FechaIngreso,
			paciente.nombre AS NombrePaciente,
			paciente.edad AS EdadPaciente,
			paciente.noHistoriaClinica AS NumeroHistoriaClinica,
			paciente.riesgo AS RiesgoPaciente,
			paciente.prioridad AS PrioridadPaciente
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente
		ORDER BY paciente.prioridad DESC, paciente.riesgo DESC, ingresados.fechaIngreso ASC;
        #DESC, ingresados.fechaIngreso ASC, paciente.edad ASC;
        
# Niños Ancianos y adultos por prioridad        


# Pacientes No ingresados
		SELECT 
			id AS IdPaciente,
			nombre AS NombrePaciente,
			noHistoriaClinica AS NoHistoriaClinica,
			edad AS Edad,
			riesgo AS RiesgoPaciente,
			prioridad AS PrioridadPaciente
		FROM paciente
		WHERE id NOT IN (SELECT idPaciente FROM ingresados)
		AND id NOT IN (SELECT IFNULL(paciente,0) FROM consulta );

SELECT IFNULL(paciente,0) FROM consulta;

SELECT * FROM paciente where id not in (SELECT idPaciente FROM ingresados);
SELECT * FROM paciente  where id not in (SELECT paciente FROM consulta);
SELECT ISNULL(NULL);
# da error al actualizar las consultas y agregar el id del paciente null

DELETE FROM consulta;

SELECT * FROM consulta;

CALL sp_Ingresados(3,null);

CALL sp_Ingresados(5,null);


call sp_Consultas(5,null);

# Pacientes No ingresados
		SELECT 
			id AS IdPaciente,
			nombre AS NombrePaciente,
			noHistoriaClinica AS NoHistoriaClinica,
			edad AS Edad,
			riesgo AS RiesgoPaciente,
			prioridad AS PrioridadPaciente
            FROM paciente
		WHERE id NOT IN (0, (SELECT idPaciente FROM ingresados))
		AND id NOT IN (0, (SELECT paciente FROM consulta));

SELECT idPaciente FROM ingresados;

SELECT paciente FROM consulta;

SELECT id AS IdPaciente,
			nombre AS NombrePaciente,
			noHistoriaClinica AS NoHistoriaClinica,
			edad AS Edad,
			riesgo AS RiesgoPaciente,
			prioridad AS PrioridadPaciente
            FROM paciente
            WHERE id NOT IN ();

SELECT * FROM paciente;
SELECT * FROM ingresados;
SELECT * FROM consulta;


CREATE TABLE ingresados(
id INT AUTO_INCREMENT PRIMARY KEY,
idPaciente INT,
fechaIngreso DATETIME DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_ingresados_paciente
	FOREIGN KEY (idPaciente) REFERENCES Paciente(id)
);

SELECT * FROM paciente;
SELECT * FROM ingresados;

# Pacientes ingresados ordenados por prioridad
SELECT 
	ingresados.idPaciente AS IdPaciente,
	ingresados.fechaIngreso AS FechaIngreso,
    paciente.nombre AS NombrePaciente,
    paciente.edad AS EdadPaciente,
    paciente.noHistoriaClinica AS NumeroHistoriaClinica,
    paciente.riesgo AS RiesgoPaciente,
    paciente.prioridad AS PrioridadPaciente,    
FROM ingresados
INNER JOIN paciente ON paciente.id = ingresados.idPaciente
ORDER BY paciente.prioridad DESC;

SELECT * FROM consulta;
SELECT * FROM estado;
SELECT * FROM tipoConsulta;
SELECT * FROM ingresados;

SELECT * FROM ingresados;
SELECT * FROM paciente;

SELECT 
	ingresados.id AS IdIngresado,
    ingresados.idPaciente AS IdPaciente,
    paciente.nombre AS NombrePaciente,
    paciente.noHistoriaClinica AS NoHistoriaClinica,
    paciente.riesgo AS RiesgoPaciente,
    paciente.prioridad AS PrioridadPaciente
FROM ingresados
INNER JOIN paciente ON paciente.id = ingresados.idPaciente;


# Pacientes No ingresados
SELECT 
	id AS IdPaciente,
    nombre AS NombrePaciente,
    noHistoriaClinica AS NoHistoriaClinica,
    edad AS Edad,
    riesgo AS RiesgoPaciente,
    prioridad AS PrioridadPaciente
FROM paciente
WHERE id NOT IN (SELECT idPaciente FROM ingresados)
AND id NOT IN (SELECT paciente FROM consulta );

SELECT * FROM consulta;

DESC paciente;
USE FONASA;
ALTER TABLE paciente CHANGE COLUMN riesgo riesgo INT;
ALTER TABLE paciente DROP COLUMN riesgo;

SELECT * FROM consulta;



SELECT * FROM paciente;
SELECT * FROM PJoven;

SELECT 
			ingresados.idPaciente AS IdPaciente,
            ingresados.fechaIngreso AS FechaIngreso,
			paciente.nombre AS NombrePaciente,
			paciente.edad AS EdadPaciente,
			paciente.noHistoriaClinica AS NumeroHistoriaClinica,
			paciente.riesgo AS RiesgoPaciente,
			paciente.prioridad AS PrioridadPaciente
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente
		ORDER BY paciente.prioridad DESC, ingresados.fechaIngreso ASC;

    