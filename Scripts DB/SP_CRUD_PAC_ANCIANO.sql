DROP PROCEDURE crudPacienteAnciano;
DELIMITER //
CREATE PROCEDURE crudPacienteAnciano(
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
    
END//
DELIMITER ;

CALL crudPacienteAnciano(4,null, 56);

SELECT * FROM Paciente;
SELECT * FROM PAnciano;
DELETE FROM PAnciano;

# Operacion #Tiene dieta #id paciente
CALL crudPacienteAnciano(0,false,3); #Insertar
CALL crudPacienteAnciano(1,false,1); #Acutalizar
CALL crudPacienteAnciano(2,null,1); #Eliminar
CALL crudPacienteAnciano(3,null,null); #Seleccionar todos
CALL crudPacienteAnciano(4,null,2); #Seleccionar Por ID


