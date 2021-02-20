CREATE DATABASE Fonasa;

SET GLOBAL sql_mode = 'NO_ENGINE_SUBSTITUTION';
SET SESSION sql_mode = 'NO_ENGINE_SUBSTITUTION';

USE Fonasa;

CREATE TABLE `paciente` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `edad` int(11) NOT NULL,
  `noHistoriaClinica` int(11) DEFAULT NULL,
  `riesgo` decimal(5,2) DEFAULT NULL,
  `prioridad` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `panciano` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tieneDieta` bit(1) DEFAULT NULL,
  `idPaciente` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_PAnciano_Paciente` (`idPaciente`),
  CONSTRAINT `fk_PAnciano_Paciente` FOREIGN KEY (`idPaciente`) REFERENCES `paciente` (`id`) ON DELETE CASCADE
);

CREATE TABLE `pjoven` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fumador` bit DEFAULT NULL,
  `aniosFumador` int DEFAULT NULL,
  `idPaciente` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_PJoven_Paciente` (`idPaciente`),
  CONSTRAINT `fk_PJoven_Paciente` FOREIGN KEY (`idPaciente`) REFERENCES `paciente` (`id`) ON DELETE CASCADE
);

CREATE TABLE `pninno` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `relacionPesoEstatura` int(11) DEFAULT NULL,
  `idPaciente` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_PNinno_Paciente` (`idPaciente`),
  CONSTRAINT `fk_PNinno_Paciente` FOREIGN KEY (`idPaciente`) REFERENCES `paciente` (`id`) ON DELETE CASCADE
);

CREATE TABLE `tipoconsulta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `estado` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `hospital` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fechaCreacion` datetime DEFAULT current_timestamp(),
  `nombre` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `consulta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cantidadPacientes` int(11) DEFAULT NULL,
  `nombreEspecialista` varchar(100) DEFAULT NULL,
  `paciente` int(11) DEFAULT NULL,
  `hospital` int(11) NOT NULL,
  `tipoConsulta` int(11) DEFAULT NULL,
  `estado` int(11) NOT NULL,
  `fechaInicio` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Consulta_TipoConsulta` (`tipoConsulta`),
  KEY `fk_Consulta_Estado` (`estado`),
  KEY `fk_Consulta_Paciente` (`paciente`),
  KEY `fk_Consulta_Hospital` (`hospital`),
  CONSTRAINT `fk_Consulta_Estado` FOREIGN KEY (`estado`) REFERENCES `estado` (`id`),
  CONSTRAINT `fk_Consulta_Hospital` FOREIGN KEY (`hospital`) REFERENCES `hospital` (`id`),
  CONSTRAINT `fk_Consulta_Paciente` FOREIGN KEY (`paciente`) REFERENCES `paciente` (`id`),
  CONSTRAINT `fk_Consulta_TipoConsulta` FOREIGN KEY (`tipoConsulta`) REFERENCES `tipoconsulta` (`id`)
);

CREATE TABLE `registroconsultas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cantidadPacientes` int(11) DEFAULT NULL,
  `nombreEspecialista` varchar(100) DEFAULT NULL,
  `paciente` int(11) DEFAULT NULL,
  `hospital` int(11) DEFAULT NULL,
  `tipoConsulta` int(11) DEFAULT NULL,
  `fechaInicio` datetime DEFAULT NULL,
  `fechaFin` datetime DEFAULT current_timestamp(),
  `idConsulta` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_registroConsulta_paciente` (`paciente`),
  KEY `fk_registroConsulta_hospital` (`hospital`),
  KEY `fk_registroConsulta_tipoConsulta` (`tipoConsulta`),
  KEY `fk_registroConsulta_idConsulta` (`idConsulta`),
  CONSTRAINT `fk_registroConsulta_hospital` FOREIGN KEY (`hospital`) REFERENCES `hospital` (`id`),
  CONSTRAINT `fk_registroConsulta_idConsulta` FOREIGN KEY (`idConsulta`) REFERENCES `consulta` (`id`),
  CONSTRAINT `fk_registroConsulta_paciente` FOREIGN KEY (`paciente`) REFERENCES `paciente` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_registroConsulta_tipoConsulta` FOREIGN KEY (`tipoConsulta`) REFERENCES `tipoconsulta` (`id`)
);

CREATE TABLE `cantidadconsultas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cantidad` int(11) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `ingresados` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idPaciente` int(11) DEFAULT NULL,
  `fechaIngreso` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_ingresados_paciente` (`idPaciente`),
  CONSTRAINT `fk_ingresados_paciente` FOREIGN KEY (`idPaciente`) REFERENCES `paciente` (`id`)
);

/* Registros TipoConsulta */
INSERT INTO TipoConsulta (descripcion)
VALUES ('Pediatría'),('Urgencia'),('CGI'); /* CGI === Consulta General Integral */

/* Registros Estado */
INSERT INTO Estado(descripcion)
VALUES ('Ocupada'), ('En espera');

INSERT INTO hospital(nombre)
VALUES ("Fonasa");

INSERT INTO consulta(hospital, estado)
VALUES (1,2),(1,2),(1,2),(1,2),(1,2),(1,2),(1,2),(1,2),(1,2),(1,2);

INSERT INTO cantidadconsultas(cantidad)
VALUES (5);
