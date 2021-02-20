DELIMITER //
CREATE PROCEDURE `crudPacienteNinno`(
	IN operacion INT,    
    IN relacionPesoEstaturaP INT,
    IN idPacienteP INT
)
BEGIN
	    
    SET @LrelacionPesoEstatura = relacionPesoEstaturaP;
    SET @LidPaciente = idPacienteP;
    
    IF operacion = 0 THEN
		INSERT INTO PNinno(relacionPesoEstatura, idPaciente)
        VALUES (@LrelacionPesoEstatura, @LidPaciente);
        SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 1 THEN
		UPDATE PNinno SET relacionPesoEstatura = @LrelacionPesoEstatura WHERE idPaciente = @LidPaciente;		
    END IF;
    
    IF operacion = 2 THEN
		DELETE FROM PNinno WHERE idPaciente = @LidPaciente;
    END IF;
    
    IF operacion = 3 THEN
		SELECT id, relacionPesoEstatura, idPaciente FROM PNinno;
    END IF;
    
    IF operacion = 4 THEN
		SELECT id, relacionPesoEstatura, idPaciente FROM PNinno WHERE idPaciente = @LidPaciente;
    END IF;
END //
DELIMITER ;