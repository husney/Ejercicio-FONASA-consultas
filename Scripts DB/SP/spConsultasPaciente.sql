CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ConsultasPaciente`(
	IN operacion INT,
    IN idP INT,
    IN cantidadPacientesP INT,
    IN nombreEspecialistaP VARCHAR(100),
    IN pacienteP INT,
    IN hospitalP INT,
    IN tipoConsultaP INT,
    IN estadoP INT,
    IN fechaInicio DATETIME
)
BEGIN

	IF operacion = 0 THEN
		INSERT INTO Consulta(cantidadPacientes, nombreEspecialista, paciente, hospital, tipoConsulta, estado)
        VALUES (cantidadPacientesP, nombreEspecialistaP, pacienteP, hospitalP, tipoConsultaP, estadoP);
        SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 1 THEN
		SET @libre = (SELECT id FROM consulta WHERE estado = 2 LIMIT  1); 

		UPDATE consulta SET cantidadPacientes = cantidadPacientesP, 
							nombreEspecialista = nombreEspecialistaP , 
                            paciente = pacienteP,
                            hospital = hospitalP,
                            tipoConsulta = tipoConsultaP,
                            estado = estadoP,
                            fechaInicio = CURRENT_TIMESTAMP
                            WHERE id = @libre;
    END IF;
    
    IF operacion = 2 THEN
		DELETE FROM Consulta WHERE paciente = pacienteP;
    END IF;
    
    IF operacion = 4 THEN
		# Verifica si el paciente esta en consulta
		SELECT COUNT(*) as verificacion FROM consulta WHERE paciente = pacienteP;
    END IF;
    
    IF operacion = 7 THEN
		#liberar consulta
		UPDATE consulta SET cantidadPacientes = null, nombreEspecialista = null, paciente = null, tipoConsulta = null, estado = 2 , fechaInicio = null WHERE id = idP;
    END IF;
    
    IF operacion = 8 THEN
		INSERT INTO registroConsultas(cantidadPacientes, nombreEspecialista, paciente, hospital, tipoConsulta, fechaInicio, idConsulta)
        VALUES (cantidadPacientesP, nombreEspecialistaP, pacienteP, hospitalP, tipoConsultaP, fechaInicio, idP);
        SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 9 THEN
		#liberar todas las consultas
		UPDATE consulta SET cantidadPacientes = null, nombreEspecialista = null, paciente = null, tipoConsulta = null, estado = 2 , fechaInicio = null;
    END IF;
    

END