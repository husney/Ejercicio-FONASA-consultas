DELIMITER //
CREATE PROCEDURE `crudPacienteAnciano`(
	IN operacion INT,    
    IN tieneDietaP BIT,
    IN idPacienteP INT
)
BEGIN
	
    SET @LtieneDieta = tieneDietaP;
    SET @LidPaciente = idPacienteP;
    
	IF operacion = 0 THEN
		INSERT INTO PAnciano(tieneDieta, idPaciente) 
        VALUES (@LtieneDieta, @LidPaciente);
        SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 1 THEN
		UPDATE PAnciano SET tieneDieta = @LtieneDieta WHERE idPaciente = @LidPaciente;
    END IF;
    
    IF operacion = 2 THEN
		DELETE FROM PAnciano WHERE idPaciente = @LidPaciente;
    END IF;
    
    IF operacion = 3 THEN
		SELECT id, tieneDieta, idPaciente FROM PAnciano;
    END IF;
    
    IF operacion = 4 THEN
		SELECT id, tieneDieta, idPaciente FROM PAnciano WHERE idPaciente = @LidPaciente;
    END IF;
    
END //
DELIMITER ;