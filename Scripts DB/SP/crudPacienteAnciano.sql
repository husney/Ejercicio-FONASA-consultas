CREATE DEFINER=`root`@`localhost` PROCEDURE `crudPacienteAnciano`(
	IN operacion INT,    
    IN tieneDietaP BIT,
    IN idPacienteP INT
)
BEGIN

	IF operacion = 0 THEN
		INSERT INTO PAnciano(tieneDieta, idPaciente) 
        VALUES (tieneDietaP, idPacienteP);
        SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 1 THEN
		UPDATE PAnciano SET tieneDieta = tieneDietaP WHERE idPaciente = idPacienteP;
    END IF;
    
    IF operacion = 2 THEN
		DELETE FROM PAnciano WHERE idPaciente = idPacienteP;
    END IF;
    
    IF operacion = 3 THEN
		SELECT id, tieneDieta, idPaciente FROM PAnciano;
    END IF;
    
    IF operacion = 4 THEN
		SELECT id, tieneDieta, idPaciente FROM PAnciano WHERE idPaciente = idPacienteP;
    END IF;
    
END