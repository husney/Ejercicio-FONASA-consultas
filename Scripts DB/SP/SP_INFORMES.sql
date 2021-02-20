DELIMITER //
CREATE PROCEDURE `sp_Informes`(
	IN operacion INT,
    IN noHistoriaClinicaP INT
)
BEGIN
	
    IF operacion = 1 THEN
    #Pacientes con mayor riesgo
		SET @riesgoPaciente = (SELECT riesgo FROM paciente WHERE noHistoriaClinica = noHistoriaClinicaP);
        
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
		WHERE paciente.riesgo > @riesgoPaciente
        ORDER BY paciente.riesgo DESC;
    END IF;
    
    IF operacion = 2 THEN
    #Consulta que ha atendido más pacientes
		SELECT idConsulta AS consulta, COUNT(*) AS cantidad FROM registroConsultas GROUP BY idConsulta ORDER BY cantidad DESC LIMIT 1;
    END IF;
    
    IF operacion = 3 THEN
    #Paciente mas anciano
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
		ORDER BY paciente.edad DESC LIMIT 1;
    END IF;
    
END //
DELIMITER ;