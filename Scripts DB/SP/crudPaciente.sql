CREATE DEFINER=`root`@`localhost` PROCEDURE `crudPaciente`(
    IN operacion INT,
	IN idP INT ,
    IN nombreP VARCHAR(100),
    IN edadP INT,
    IN noHistoriaClinicaP INT,
    IN prioridadP decimal(5,2),
    IN riesgoP decimal(5,2)  
    )
BEGIN

    IF operacion = 0 THEN   	
		INSERT INTO Paciente (nombre, edad, noHistoriaClinica, prioridad, riesgo)
        VALUES (nombreP, edadP, noHistoriaClinicaP, prioridadP, riesgoP);
       
        SELECT LAST_INSERT_ID();
	END IF;
    
    IF operacion = 1 THEN
		UPDATE paciente SET nombre = nombreP, edad = edadP, noHistoriaClinica = noHistoriaClinicaP, prioridad = prioridadP, riesgo = riesgoP WHERE id = idP;       
    END IF;
    
    IF operacion = 2 THEN
		DELETE FROM Paciente WHERE id = idP;
    END IF;
    
    IF operacion = 3 THEN		
        SELECT id, nombre, edad, noHistoriaClinica, prioridad, riesgo FROM paciente;
    END IF;
    
    IF operacion = 4 THEN
		SELECT id, nombre, edad, noHistoriaClinica, prioridad, riesgo FROM paciente WHERE ID = idP;
    END IF;
    
END