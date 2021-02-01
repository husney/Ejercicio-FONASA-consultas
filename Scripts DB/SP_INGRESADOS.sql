

DELIMITER //
DROP PROCEDURE sp_ingresados(
	IN operacion INT,
    IN idPacientep INT
)
BEGIN
	SET @LidPaciente = idPacienteP;
    
    IF operacion = 4 THEN
		SELECT 
			insertado.id as IdInsertado

    END IF;
END//
DELIMITER ;

CREATE TABLE ingresados(
id INT,
idPaciente INT,
CONSTRAINT fk_ingresados_paciente
	FOREIGN KEY (idPaciente) REFERENCES Paciente(id)
);

SELECT * FROM paciente;

SELECT 
	ingresados.id as idInsertado,
    ingresados.idPaciente as idPaciente,
    paciente.nombre as NombrePaciente,
    paciente.edad as NombreEdad,
    paciente.noHistoriaClinica as NumeroHistoriaClinica,
    paciente.riesgo as Riesgo,
    paciente.prioridad as Prioridad
FROM ingresados
INNER JOIN paciente ON paciente.id = insertado.idPaciente
    