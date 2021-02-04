CREATE DEFINER=`root`@`localhost` PROCEDURE `crudPacienteNinno`(
	IN operacion INT,    
    IN relacionPesoEstaturaP INT,
    IN idPacienteP INT
)
BEGIN

    IF operacion = 0 THEN
		INSERT INTO PNinno(relacionPesoEstatura, idPaciente)
        VALUES (relacionPesoEstaturaP, idPacienteP);
        SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 1 THEN
		UPDATE PNinno SET relacionPesoEstatura = relacionPesoEstaturaP WHERE idPaciente = idPacienteP;		
    END IF;
    
    IF operacion = 2 THEN
		DELETE FROM PNinno WHERE idPaciente = idPacienteP;
    END IF;
    
    IF operacion = 3 THEN
		SELECT id, relacionPesoEstatura, idPaciente FROM PNinno;
    END IF;
    
    IF operacion = 4 THEN
		SELECT id, relacionPesoEstatura, idPaciente FROM PNinno WHERE idPaciente = idPacienteP;
    END IF;
END