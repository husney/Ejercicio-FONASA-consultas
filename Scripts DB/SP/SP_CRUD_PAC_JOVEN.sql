DELIMITER //
CREATE PROCEDURE `crudPacienteJoven`(
	IN operacion INT,    
    IN fumadorP BIT,
    IN aniosFumadorP INT,
    IN idPacienteP INT
)
BEGIN
	    
    SET @Lfumador = fumadorP;
    SET @LaniosFumador = aniosFumadorP;
    SET @idPaciente = idPacienteP;
    
    IF operacion = 0 THEN
		INSERT INTO PJoven(fumador, aniosFumador, idPaciente)
        VALUES (@Lfumador, @LaniosFumador, @idPaciente);
        SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 1 THEN
		UPDATE PJoven SET fumador = @Lfumador, aniosFumador = @LaniosFumador WHERE idPaciente = @idPaciente;
    END IF;
    
    IF operacion = 2 THEN
		DELETE FROM PJoven WHERE idPaciente = @idPaciente;
    END IF;
    
    IF operacion = 3 THEN 
		SELECT id, fumador, aniosFumador, idPaciente FROM PJoven;
    END IF;
    
    IF operacion = 4 THEN
		SELECT id, fumador, aniosFumador, idPaciente FROM PJoven WHERE idPaciente = @idPaciente;
    END IF;
	
END //
DELIMITER ;