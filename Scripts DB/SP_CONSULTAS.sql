

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
				tipoConsulta.descripcion as TipoConsulta,
				consulta.estado as Estado,
                consulta.fechaInicio as FechaInicio,
				paciente.nombre as NombrePaciente,
				paciente.edad as EdadPaciente,
				paciente.riesgo as RiesgoPaciente,
				paciente.prioridad as PrioridadPaciente,
                consulta.tipoConsulta as idTipoConsulta
		FROM consulta
		INNER JOIN paciente ON paciente.id = consulta.paciente
        INNER JOIN tipoConsulta ON tipoConsulta.id = consulta.tipoConsulta
		WHERE consulta.estado = 1
		ORDER BY paciente.prioridad DESC;
    END IF;
    
END //
DELIMITER ; 

SELECT * FROM registroconsultas;

SELECT consulta.id as IdConsulta,
				consulta.cantidadPacientes as CantidadPacientes,
				consulta.nombreEspecialista as NombreEspecialista,
				consulta.paciente as idPaciente,
				consulta.hospital as Hospital,
				tipoConsulta.descripcion as TipoConsulta,
				consulta.estado as Estado,
                consulta.fechaInicio as FechaInicio,
				paciente.nombre as NombrePaciente,
				paciente.edad as EdadPaciente,
				paciente.riesgo as RiesgoPaciente,
				paciente.prioridad as PrioridadPaciente,
                consulta.tipoConsulta as idTipoConsulta
		FROM consulta
		INNER JOIN paciente ON paciente.id = consulta.paciente
        INNER JOIN tipoConsulta ON tipoConsulta.id = consulta.tipoConsulta
		WHERE consulta.estado = 1
		ORDER BY paciente.prioridad DESC;


SELECT consulta.id as IdConsulta,
				consulta.cantidadPacientes as CantidadPacientes,
				consulta.nombreEspecialista as NombreEspecialista,
				consulta.paciente as idPaciente,
				consulta.hospital as Hospital,
				tipoConsulta.descripcion as TipoConsulta,
				consulta.estado as Estado,
                consulta.fechaInicio as FechaInicio,
				paciente.nombre as NombrePaciente,
				paciente.edad as EdadPaciente,
				paciente.riesgo as RiesgoPaciente,
				paciente.prioridad as PrioridadPaciente    
		FROM consulta
		INNER JOIN paciente ON paciente.id = consulta.paciente
        INNER JOIN tipoConsulta ON tipoConsulta.id = consulta.tipoConsulta
		WHERE consulta.estado = 1
		ORDER BY paciente.prioridad DESC;

SELECT * FROM tipoConsulta;

SELECT consulta.id as IdConsulta,
				consulta.cantidadPacientes as CantidadPacientes,
				consulta.nombreEspecialista as NombreEspecialista,
				consulta.paciente as idPaciente,
				consulta.hospital as Hospital,
				consulta.tipoConsulta as TipoConsulta,
				consulta.estado as Estado,
                consulta.fechaInicio as FechaInicio,
				paciente.nombre as NombrePaciente,
				paciente.edad as EdadPaciente,
				paciente.riesgo as RiesgoPaciente,
				paciente.prioridad as PrioridadPaciente    
		FROM consulta
		INNER JOIN paciente ON paciente.id = consulta.paciente
		WHERE consulta.estado = 1
		ORDER BY paciente.prioridad DESC;
        
        SELECT * FROM consulta;

SELECT * FROM consulta;

#db.callproc('sp_ConsultasPaciente', (Operacion.seleccionarById.value, None, None, None, request.json['paciente'], None, None, None))
CALL sp_ConsultasPaciente(4,null, null, null, 34, null, null, null);

CALL sp_ConsultasPaciente(7,2,null, null, null, null, null, null, null);
SELECT * FROM consulta;

CALL sp_Ingresados(3,NULL);

DESC CONSULTA;
SELECT * FROM estado;
UPDATE consulta SET cantidadPacientes = null, nombreEspecialista = null, paciente = null, tipoConsulta = null, estado = 2;


SELECT consulta.id as IdConsulta,
				consulta.cantidadPacientes as CantidadPacientes,
				consulta.nombreEspecialista as NombreEspecialista,
				consulta.paciente as idPaciente,
				consulta.hospital as Hospital,
				consulta.tipoConsulta as TipoConsulta,
				consulta.estado as Estado,
                consulta.fechaInicio as FechaInicio,
				paciente.nombre as NombrePaciente,
				paciente.edad as EdadPaciente,
				paciente.riesgo as RiesgoPaciente,
				paciente.prioridad as PrioridadPaciente    
		FROM consulta
		INNER JOIN paciente ON paciente.id = consulta.paciente
		WHERE consulta.estado = 1
		ORDER BY paciente.prioridad DESC;

SELECT * FROM Ingresados;


SELECT * FROM paciente;
SELECT * FROM consulta;
SELECT * FROM registroConsultas;

CALL sp_ConsultasPaciente(8,2,0,'pruebaBitacora1',39,1,2, null, '2021-02-01 19:55:26');

DROP PROCEDURE sp_ConsultasPaciente;

SELECT * FROM paciente;
CALL sp_ConsultasPaciente(1,null,0,'p',54,1,1,1,null);

DELIMITER //
CREATE PROCEDURE sp_ConsultasPaciente(
	IN operacion INT,
    IN idP INT,
    IN cantidadPacientesP INT,
    IN nombreEspecialistaP VARCHAR(100),
    IN pacienteP INT,
    IN hospitalP INT,
    IN tipoConsultaP INT,
    IN estadoP INT,
    IN fechaInicio DATETIME
)	
BEGIN

	IF operacion = 0 THEN
		INSERT INTO Consulta(cantidadPacientes, nombreEspecialista, paciente, hospital, tipoConsulta, estado)
        VALUES (cantidadPacientesP, nombreEspecialistaP, pacienteP, hospitalP, tipoConsultaP, estadoP);
        SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 1 THEN
		SET @libre = (SELECT id FROM consulta WHERE estado = 2 LIMIT  1); 

		UPDATE consulta SET cantidadPacientes = cantidadPacientesP, 
							nombreEspecialista = nombreEspecialistaP , 
                            paciente = pacienteP,
                            hospital = hospitalP,
                            tipoConsulta = tipoConsultaP,
                            estado = estadoP,
                            fechaInicio = CURRENT_TIMESTAMP
                            WHERE id = @libre;
    END IF;
    
    IF operacion = 2 THEN
		DELETE FROM Consulta WHERE paciente = pacienteP;
    END IF;
    
    IF operacion = 4 THEN
		# Verifica si el paciente esta en consulta
		SELECT COUNT(*) as verificacion FROM consulta WHERE paciente = pacienteP;
    END IF;
    
    IF operacion = 7 THEN
		#liberar consulta
		UPDATE consulta SET cantidadPacientes = null, nombreEspecialista = null, paciente = null, tipoConsulta = null, estado = 2 , fechaInicio = null WHERE id = idP;
    END IF;
    
    IF operacion = 8 THEN
		INSERT INTO registroConsultas(cantidadPacientes, nombreEspecialista, paciente, hospital, tipoConsulta, fechaInicio, idConsulta)
        VALUES (cantidadPacientesP, nombreEspecialistaP, pacienteP, hospitalP, tipoConsultaP, fechaInicio, idP);
        SELECT LAST_INSERT_ID();
    END IF;
    
    IF operacion = 9 THEN
		#liberar todas las consultas
		UPDATE consulta SET cantidadPacientes = null, nombreEspecialista = null, paciente = null, tipoConsulta = null, estado = 2 , fechaInicio = null;
    END IF;
    

END //
DELIMITER ; 

DESCRIBE CONSULTA;

SELECT * FROM consulta;

DESC registroConsultas;

SELECT COUNT(*) FROM registroConsultas WHERE idConsulta = 2;


DROP PROCEDURE sp_registroConsultas;

SELECT * FROM registroConsultas;
SELECT * FROM consulta;

DROP TABLE registroConsultas;
DELETE FROM registroConsultas;
SELECT * FROM paciente;
SELECT * FROM registroConsultas;
truncate registroConsultas;
DELETE FROM registroConsultas WHERE id = 29;
UPDATE registroConsultas SET paciente = 55 WHERE paciente = 56;

ALTER TABLE registroConsultas DROP COLUMN paciente;
ALTER TABLE registroConsutlas DROP CONSTRAINT fk_registroConsulta_paciente;
TRUNCATE TABLE registroConsutlas;
SELECT * FROM paciente;
DELETE FROM paciente WHERE id = 56;

SELECT * FROM ingresados;

SELECT * FROM consulta;
SELECT * FROM registroConsultas;
DROP TABLE registroConsultas;
CREATE TABLE registroConsultas(
id INT AUTO_INCREMENT PRIMARY KEY,
cantidadPacientes INT,
nombreEspecialista VARCHAR(100),
paciente INT,
hospital INT,
tipoConsulta INT,
fechaInicio DATETIME, 
fechaFin DATETIME DEFAULT CURRENT_TIMESTAMP,
idConsulta INT,

CONSTRAINT fk_registroConsulta_paciente
	FOREIGN KEY (paciente) REFERENCES paciente(id)
		ON DELETE CASCADE,
CONSTRAINT fk_registroConsulta_hospital
	FOREIGN KEY (hospital) REFERENCES hospital(id),
CONSTRAINT fk_registroConsulta_tipoConsulta
	FOREIGN KEY (tipoConsulta) REFERENCES tipoConsulta(id),
CONSTRAINT fk_registroConsulta_idConsulta
    FOREIGN KEY (idConsulta) REFERENCES consulta(id)
);
    


SELECT * FROM hospital;
SELECT * FROM tipoConsulta;


ALTER TABLE consulta  AUTO_INCREMENT = 1;
SELECT * FROM consulta;
SELECT * FROM paciente;
SELECT id FROM consulta WHERE estado = 2 LIMIT  1;
SELECT * FROM estado;
UPDATE consulta SET cantidadPacientes = null, nombreEspecialista = null, paciente = null, tipoConsulta = null, estado = 2 WHERE id = 2;
SELECT * FROM ingresados;
SELECT id FROM consulta WHERE estado = 2 LIMIT  1;
SELECT * FROM paciente;
call sp_Ingresados(2, null);





SELECT * FROM Estado;
SELECT * FROM consulta;
SELECT * FROM paciente;


#eliminar consultas mayores
#DELETE FROM consulta WHERE id > llega

UPDATE consulta SET cantidadPacientes = 1, nombreEspecialista = 1, paciente = 1, hospital = 1, tipoConsulta = 1, estado = 1 WHERE estado = 2;


CALL sp_ConsultasPaciente(0,'prueba consulta',34,1,2,1);
CALL sp_ConsultasPaciente(3,null, null, null,34,null, null, null);

CALL sp_ConsultasPaciente (4,null, null, null, 38, null, null, null);
SELECT COUNT(*) as verificacion FROM consulta WHERE paciente = 39;
SELECT * FROM paciente;
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
    

USE FONASA;
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
WHERE consulta.estado = 1
ORDER BY paciente.prioridad DESC;
    





