DROP PROCEDURE crudPacienteJoven;
DELIMITER //
CREATE PROCEDURE crudPacienteJoven(
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

SELECT * FROM Paciente;
SELECT * FROM PJoven;




# operacion #fumador # tiempoFumador #idpaciente   
CALL crudPacienteJoven(0,false,3,3); #Insertar
CALL crudPacienteJoven(1,true,8,1); #Acutalizar
CALL crudPacienteJoven(2,null,null,1); #Eliminar
CALL crudPacienteJoven(3,null,null,null); #Seleccionar todos
CALL crudPacienteJoven(4,null,null,3); #Seleccionar por ID


CREATE TABLE IF NOT EXISTS PJoven(
id INT AUTO_INCREMENT PRIMARY KEY,
fumador BIT,
aniosFumador INT, 
idPaciente INT NOT NULL,
CONSTRAINT fk_PJoven_Paciente
	FOREIGN KEY (idPaciente) REFERENCES Paciente(id)
	ON DELETE CASCADE
);