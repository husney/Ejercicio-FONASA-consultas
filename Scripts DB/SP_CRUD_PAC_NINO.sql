
DELIMITER //
CREATE PROCEDURE crudPacienteNinno(
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
END//
DELIMITER ;

USE fonasa;
SELECT * FROM Paciente;
SELECT * FROM PNinno;


# operacion # relacionPesoEstatura #idPaciente
CALL crudPacienteNinno(0,4,1); #Insertar
CALL crudPacienteNinno(1,10,2); #Acutalizar
CALL crudPacienteNinno(2,null,1); #Eliminar
CALL crudPacienteNinno(3,null,null); # Seleccionar todos
CALL crudPacienteNinno(4,null,2); # Seleccionar por ID

CREATE TABLE IF NOT EXISTS PNinno(
id INT AUTO_INCREMENT PRIMARY KEY,
relacionPesoEstatura INT,
idPaciente INT NOT NULL,
CONSTRAINT fk_PNinno_Paciente
	FOREIGN KEY (idPaciente) REFERENCES Paciente(id)
	ON DELETE CASCADE
);