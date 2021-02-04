/*
	1 - INSERTAR
    2 - ACTUALIZAR
*/
    
DROP PROCEDURE crudPaciente;
DELIMITER //
CREATE PROCEDURE crudPaciente(
    IN operacion INT,
	IN idP INT ,
    IN nombreP VARCHAR(100),
    IN edadP INT,
    IN noHistoriaClinicaP INT,
    IN prioridadP decimal(5,2),
    IN riesgoP decimal(5,2)  
    )
BEGIN

    IF operacion = 0 THEN   	
		INSERT INTO Paciente (nombre, edad, noHistoriaClinica, prioridad, riesgo)
        VALUES (nombreP, edadP, noHistoriaClinicaP, prioridadP, riesgoP);
       
        SELECT LAST_INSERT_ID();
	END IF;
    
    IF operacion = 1 THEN
		UPDATE paciente SET nombre = nombreP, edad = edadP, noHistoriaClinica = noHistoriaClinicaP, prioridad = prioridadP, riesgo = riesgoP WHERE id = idP;       
    END IF;
    
    IF operacion = 2 THEN
		DELETE FROM Paciente WHERE id = idP;
    END IF;
    
    IF operacion = 3 THEN		
        SELECT id, nombre, edad, noHistoriaClinica, prioridad, riesgo FROM paciente;
    END IF;
    
    IF operacion = 4 THEN
		SELECT id, nombre, edad, noHistoriaClinica, prioridad, riesgo FROM paciente WHERE ID = idP;
    END IF;
    
END//
DELIMITER ;

USE FONASA;
SELECT * FROM registroConsultas;
SELECT * FROM paciente;


DROP procedure sp_Informes;
DELIMITER //
CREATE PROCEDURE sp_Informes(
	IN operacion INT,
    IN noHistoriaClinicaP INT
)
BEGIN
	
    IF operacion = 1 THEN
    #Pacientes con mayor riesgo
		SET @riesgoPaciente = (SELECT riesgo FROM paciente WHERE noHistoriaClinica = noHistoriaClinicaP);
        
        SELECT 
			ingresados.idPaciente AS IdPaciente,
            ingresados.fechaIngreso AS FechaIngreso,
			paciente.nombre AS NombrePaciente,
			paciente.edad AS EdadPaciente,
			paciente.noHistoriaClinica AS NumeroHistoriaClinica,
			paciente.riesgo AS RiesgoPaciente,
			paciente.prioridad AS PrioridadPaciente
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente
		WHERE paciente.riesgo > @riesgoPaciente
        ORDER BY paciente.riesgo DESC;
    END IF;
    
    IF operacion = 2 THEN
    #Consulta que ha atendido más pacientes
		SELECT idConsulta AS consulta, COUNT(*) AS cantidad FROM registroConsultas GROUP BY idConsulta ORDER BY cantidad DESC LIMIT 1;
    END IF;
    
    IF operacion = 3 THEN
    #Paciente mas anciano
		SELECT 
			ingresados.idPaciente AS IdPaciente,
            ingresados.fechaIngreso AS FechaIngreso,
			paciente.nombre AS NombrePaciente,
			paciente.edad AS EdadPaciente,
			paciente.noHistoriaClinica AS NumeroHistoriaClinica,
			paciente.riesgo AS RiesgoPaciente,
			paciente.prioridad AS PrioridadPaciente
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente
		ORDER BY paciente.edad DESC LIMIT 1;
    END IF;
    
END //
DELIMITER ; 

SELECT 
			ingresados.idPaciente AS IdPaciente,
            ingresados.fechaIngreso AS FechaIngreso,
			paciente.nombre AS NombrePaciente,
			paciente.edad AS EdadPaciente,
			paciente.noHistoriaClinica AS NumeroHistoriaClinica,
			paciente.riesgo AS RiesgoPaciente,
			paciente.prioridad AS PrioridadPaciente
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente
		WHERE paciente.riesgo > @riesgoPaciente
        ORDER BY paciente.riesgo DESC;

#Pacientes con mayor riesgo
SELECT * FROM paciente;
		SET @riesgoPaciente = (SELECT riesgo FROM paciente WHERE noHistoriaClinica = 11111);
        SELECT id, nombre, edad, noHistoriaClinica, riesgo, prioridad FROM paciente WHERE riesgo > @riesgoPaciente;

SELECT 
			ingresados.idPaciente AS IdPaciente,
            ingresados.fechaIngreso AS FechaIngreso,
			paciente.nombre AS NombrePaciente,
			paciente.edad AS EdadPaciente,
			paciente.noHistoriaClinica AS NumeroHistoriaClinica,
			paciente.riesgo AS RiesgoPaciente,
			paciente.prioridad AS PrioridadPaciente
		FROM ingresados
		INNER JOIN paciente ON paciente.id = ingresados.idPaciente
		WHERE paciente.riesgo > @riesgoPaciente
        ORDER BY paciente.riesgo DESC;
        
SELECT * FROM ingresados;

SELECT * FROM ingresados;

SELECT * FROM registroConsultas;

SELECT * FROM paciente;
SELECT * FROM estado;
SELECT * FROM consulta;

INSERT INTO consulta(hospital, estado)
VALUES (1,2);

SELECT * FROM cantidadConsultas;




SELECT idConsulta AS consulta, COUNT(*) AS cantidad FROM registroConsultas GROUP BY idConsulta ORDER BY cantidad DESC LIMIT 1;
SELECT * FROM registroConsultas;
SELECT * FROM consulta;

SELECT * FROM paciente;
SELECT * FROM ingresados;

SELECT id, nombre, edad, noHistoriaClinica, riesgo, prioridad 
FROM paciente
WHERE paciente.id IN (SELECT IFNULL(idPaciente, 0) FROM ingresados) ORDER BY edad DESC LIMIT 1;

   
# operacion # id # nombre # edad # historia clinica # prioridad # riesgo    
CALL crudPaciente(0,null,'e',90,123,1,5); # Insertando
CALL crudPaciente(1,1,'UPDATE',0,0,0); # Acutalizando
CALL crudPaciente(2,1,null,null,null,null); # Eliminando
CALL crudPaciente(3,null,null,null,null,null,null); # Seleccionado Todos
CALL crudPaciente(4,1,null,null,null,null,null); # Seleccionado por ID


SELECT * FROM paciente;
delete from paciente;

insert into paciente(nombre, edad, noHistoriaClinica, riesgo, prioridad)
values ('p',42,232323,5.3,2);

ALTER TABLE paciente CHANGE COLUMN riesgo riesgo decimal(5,2);
ALTER TABLE paciente CHANGE COLUMN prioridad prioridad decimal(5,2);
DELETE FROM paciente;
DELETE FROM registroConsultas;

INSERT INTO paciente(nombre, edad, noHistoriaClinica) VALUES ('1',1,1);

SET @Lid = 1;
SELECT id, nombre, edad, noHistoriaClinica, riesgo FROM paciente WHERE ID = @Lid;



SELECT * FROM paciente;

