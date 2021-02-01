

CREATE TABLE cantidadConsultas(
id INT AUTO_INCREMENT PRIMARY KEY,
cantidad INT NOT NULL
);

DROP PROCEDURE sp_Consultas;

DELIMITER //
CREATE PROCEDURE sp_Consultas(
	IN operacion INT,
	IN cantidadP INT
)
BEGIN
	
    SET @Lcantiadad = cantidadP;

	IF operacion = 0 THEN
		INSERT INTO cantidadConsultas(cantidad)
		VALUES (cantidadP);
		SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 1 THEN
		UPDATE cantidadConsultas SET cantidad = @Lcantiadad WHERE id = 1;
    END IF;
    
    IF operacion = 3 THEN
		select cantidad FROM cantidadConsultas WHERE id = 1;
    END IF;
    
    IF operacion = 5 THEN		
		SELECT COUNT(*) FROM consulta WHERE estado = 1;	
    END IF;
    
    IF operacion = 6 THEN 
		SELECT consulta.id as IdConsulta,
        consulta.cantidadPacientes as CantidadPacientes,
        consulta.nombreEspecialista as NombreEspecialista,
        consulta.paciente as idPaciente,
        consulta.hospital as Hospital,
        consulta.tipoConsulta as TipoConsulta,
        consulta.estado as Estado,        
        paciente.nombre as NombrePaciente,
        paciente.edad as EdadPaciente,
        paciente.riesgo as RiesgoPaciente,
        paciente.prioridad as PrioridadPaciente    
		FROM consulta
		INNER JOIN paciente ON paciente.id = consulta.paciente
        WHERE consulta.estado = 1;
    END IF;
    
    
END //
DELIMITER ; 


SELECT * FROM cantidadConsultas;

SELECT * FROM Estado;

SELECT cantidad FROM cantidadConsultas WHERE id = 1;


SELECT * FROM paciente;
SELECT * FROM Consulta;
SELECT * FROM TipoConsulta;
SELECT * FROM hospital;





INSERT INTO hospital(nombre)
VALUES ('prueba');


INSERT INTO consulta(cantidadPacientes, nombreEspecialista, paciente, hospital, tipoConsulta, estado)
VALUES (1,'prueba',33,1,3,1);


CALL sp_Consultas(0,5);
CALL sp_Consultas(1,10);
CALL sp_Consultas(3,null);




SELECT * FROM PJoven;
SELECT * FROM PNinno;
SELECT * FROM PAnciano;

# En consulta
SELECT consulta.id as IdConsulta,
        consulta.cantidadPacientes as CantidadPacientes,
        consulta.nombreEspecialista as NombreEspecialista,
        consulta.paciente as idPaciente,
        consulta.hospital as Hospital,
        consulta.tipoConsulta as TipoConsulta,
        consulta.estado as Estado,        
        paciente.nombre as NombrePaciente,
        paciente.edad as EdadPaciente,
        paciente.riesgo as RiesgoPaciente,
        paciente.prioridad as PrioridadPaciente    
FROM consulta
INNER JOIN paciente ON paciente.id = consulta.paciente
WHERE consulta.estado = 1;


# En espera

SELECT * FROM ingresados;
SELECT * FROM paciente;

# Pacientes ingresados ordenados por prioridad
SELECT 
	ingresados.idPaciente as IdPaciente,
    paciente.nombre as NombrePaciente,
    paciente.edad as NombreEdad,
    paciente.noHistoriaClinica as NumeroHistoriaClinica,
    paciente.riesgo as RiesgoPaciente,
    paciente.prioridad as PrioridadPaciente
FROM ingresados
INNER JOIN paciente ON paciente.id = ingresados.idPaciente
ORDER BY paciente.prioridad DESC;
    
    





