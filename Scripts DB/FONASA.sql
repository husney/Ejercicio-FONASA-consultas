CREATE DATABASE IF NOT EXISTS FONASA;

USE FONASA;

CREATE TABLE IF NOT EXISTS Paciente(
id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
edad INT NOT NULL,
noHistoriaClinica INT UNIQUE,
prioridad INT,
riesgo INT
);

CREATE TABLE IF NOT EXISTS PAnciano(
id INT AUTO_INCREMENT PRIMARY KEY,
tieneDieta BIT,
idPaciente INT NOT NULL,
CONSTRAINT fk_PAnciano_Paciente
	FOREIGN KEY (idPaciente) REFERENCES Paciente(id)
	ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PNinno(
id INT AUTO_INCREMENT PRIMARY KEY,
relacionPesoEstatura INT,
idPaciente INT NOT NULL,
CONSTRAINT fk_PNinno_Paciente
	FOREIGN KEY (idPaciente) REFERENCES Paciente(id)
	ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PJoven(
id INT AUTO_INCREMENT PRIMARY KEY,
fumador BIT,
aniosFumador INT, 
idPaciente INT NOT NULL,
CONSTRAINT fk_PJoven_Paciente
	FOREIGN KEY (idPaciente) REFERENCES Paciente(id)
	ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS TipoConsulta(
id INT AUTO_INCREMENT PRIMARY KEY,
descripcion VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Estado(
id INT AUTO_INCREMENT PRIMARY KEY,
descripcion VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Hospital(
id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(150) NOT NULL,
fechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Consulta(
id INT AUTO_INCREMENT PRIMARY KEY,
cantidadPacientes INT,
nombreEspecialista VARCHAR(100),
paciente INT NOT NULL,
hospital INT NOT NULL,
tipoConsulta INT NOT NULL,
estado INT NOT NULL,
CONSTRAINT fk_Consulta_TipoConsulta
	FOREIGN KEY (tipoConsulta) REFERENCES TipoConsulta(id),
CONSTRAINT fk_Consulta_Estado
	FOREIGN KEY (estado) REFERENCES Estado(id),
CONSTRAINT fk_Consulta_Paciente 
	FOREIGN KEY (paciente) REFERENCES Paciente(id),
CONSTRAINT fk_Consulta_Hospital
	FOREIGN KEY (hospital) REFERENCES Hospital(id)
);

CREATE TABLE cantidadConsultas(
id INT AUTO_INCREMENT PRIMARY KEY,
cantidad INT NOT NULL
);

/* Registros TipoConsulta */
INSERT INTO TipoConsulta (descripcion)
VALUES ('Pediatría'),('Urgencia'),('CGI'); /* CGI === Consulta General Integral */

/* Registros Estado */
INSERT INTO Estado(descripcion)
VALUES ('Ocupada'), ('En espera');

















