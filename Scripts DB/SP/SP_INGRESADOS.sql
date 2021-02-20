DELIMITER //
CREATE PROCEDURE `sp_Ingresados`(
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
    
    IF operacion = 6 THEN
		SELECT 
		paciente.id AS IdPaciente,
		paciente.nombre AS Nombre,
		paciente.riesgo AS Riesgo,
		paciente.prioridad AS Prioridad,
		pjoven.fumador AS Fumador,
		pjoven.aniosFumador AS TiempoFumador
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente AND paciente.edad between 21 AND 40
		INNER JOIN pjoven ON pjoven.idPaciente = paciente.id
		ORDER BY paciente.prioridad desc , paciente.riesgo desc;
    END IF;
END //
DELIMITER ;