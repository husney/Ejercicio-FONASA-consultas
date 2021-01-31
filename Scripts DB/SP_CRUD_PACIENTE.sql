/*
	1 - INSERTAR
    2 - ACTUALIZAR
*/
    
DROP PROCEDURE crudPaciente;
DELIMITER //
CREATE PROCEDURE crudPaciente(
    IN operacion INT,
	IN idP INT ,
    IN nombreP VARCHAR(100),
    IN edadP INT,
    IN noHistoriaClinicaP INT,
    IN prioridadP INT,
    IN riesgoP INT  
    )
BEGIN
	SET @Lid = idP;
    SET @Lnombre = nombreP;
    SET @Ledad = edadP;    
    SET @LnoHistoriaClinica = noHistoriaClinicaP;    
    SET @Lprioridad = prioridadP;
    SET @Lriesgo = riesgoP;
    
    IF operacion = 0 THEN   	
		INSERT INTO Paciente (nombre, edad, noHistoriaClinica, prioridad, riesgo)
        VALUES (@Lnombre, @Ledad, @LnoHistoriaClinica, @Lprioridad ,@Lriesgo);
       
        SELECT LAST_INSERT_ID();
	END IF;
    
    IF operacion = 1 THEN
		UPDATE paciente SET nombre = @Lnombre, edad = @Ledad, noHistoriaClinica = @LnoHistoriaClinica, prioridad = @Lprioridad, riesgo = @Lriesgo WHERE id = @Lid;       
    END IF;
    
    IF operacion = 2 THEN
		DELETE FROM Paciente WHERE id = @Lid;
    END IF;
    
    IF operacion = 3 THEN		
        SELECT id, nombre, edad, noHistoriaClinica, prioridad, riesgo FROM paciente;
    END IF;
    
    IF operacion = 4 THEN
		SELECT id, nombre, edad, noHistoriaClinica, prioridad, riesgo FROM paciente WHERE ID = @Lid;
    END IF;
    
END//
DELIMITER ;
   
# operacion # id # nombre # edad # historia clinica # prioridad # riesgo    
CALL crudPaciente(0,null,'D',90,123,1,5); # Insertando
CALL crudPaciente(1,1,'UPDATE',0,0,0); # Acutalizando
CALL crudPaciente(2,1,null,null,null,null); # Eliminando
CALL crudPaciente(3,null,null,null,null,null,null); # Seleccionado Todos
CALL crudPaciente(4,1,null,null,null,null,null); # Seleccionado por ID

SELECT * FROM paciente;
delete from paciente;




INSERT INTO paciente(nombre, edad, noHistoriaClinica) VALUES ('1',1,1);

SET @Lid = 1;
SELECT id, nombre, edad, noHistoriaClinica, riesgo FROM paciente WHERE ID = @Lid;





