

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
		SELECT cantidad FROM cantidadConsultas WHERE id = 1;
    END IF;
    
END //
DELIMITER ; 


SELECT * FROM cantidadConsultas;


CALL sp_Consultas(0,5);
CALL sp_Consultas(1,10);
CALL sp_Consultas(3,null);


