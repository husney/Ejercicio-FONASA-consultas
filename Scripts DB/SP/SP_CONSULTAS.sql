DELIMITER //
CREATE PROCEDURE `sp_Consultas`(
	IN operacion INT,
	IN cantidadP INT
)
BEGIN
	
    SET @Lcantiadad = cantidadP;

	IF operacion = 0 THEN
		INSERT INTO cantidadConsultas(cantidad)
		VALUES (cantidadP);
		SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 1 THEN
		UPDATE cantidadConsultas SET cantidad = @Lcantiadad WHERE id = 1;
    END IF;
    
    IF operacion = 3 THEN
		select cantidad FROM cantidadConsultas WHERE id = 1;
    END IF;
    
    IF operacion = 5 THEN		
		SELECT COUNT(*) FROM consulta WHERE estado = 1;	
    END IF;
    
    IF operacion = 6 THEN 
		SELECT consulta.id as IdConsulta,
				consulta.cantidadPacientes as CantidadPacientes,
				consulta.nombreEspecialista as NombreEspecialista,
				consulta.paciente as idPaciente,
				consulta.hospital as Hospital,
				tipoConsulta.descripcion as TipoConsulta,
				consulta.estado as Estado,
                consulta.fechaInicio as FechaInicio,
				paciente.nombre as NombrePaciente,
				paciente.edad as EdadPaciente,
				paciente.riesgo as RiesgoPaciente,
				paciente.prioridad as PrioridadPaciente,
                consulta.tipoConsulta as idTipoConsulta
		FROM consulta
		INNER JOIN paciente ON paciente.id = consulta.paciente
        INNER JOIN tipoConsulta ON tipoConsulta.id = consulta.tipoConsulta
		WHERE consulta.estado = 1
		ORDER BY paciente.prioridad DESC;
    END IF;
    
END //
DELIMITER ;