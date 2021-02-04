
class Paciente():
    
    idPaciente = 0
    
    def __init__(self, nombre, edad, noHistoriaClinica):
        self.__id = Paciente.idPaciente-1
        self.__nombre = nombre
        self.__edad = int(edad)
        self.__noHistoriaClinica = noHistoriaClinica
        self.__prioridad = None
        self.__riesgo = None
        self.__pesoEstatura = None
        self.__fumador = None
        self.__tiempoFumador = None
        self.__dieta = None
    
    def getId(self):
        return self.__id

    def setId(self, id):
        self.__id = id
    
    def getNombre(self):
        return self.__nombre
    
    def setNombre(self, nombre):
        self.__nombre = nombre
        
    def setEdad(self, edad):
        self.__edad = edad
        
    def getEdad(self):
        return self.__edad
        
    def getNoHistoriaClinica(self):
        return self.__noHistoriaClinica
    
    def setNoHistoriaClinica(self, noHistoriaClinica):
        self.__noHistoriaClinica = noHistoriaClinica
        
    def setPrioridad(self, prioridad):
        self.__prioridad = prioridad
    
    def getPrioridad(self):
        return self.__prioridad
        
    def setRiesgo(self, riesgo):
        self.__riesgo = riesgo
        
    def getRiesgo(self):
        return self.__riesgo
    
    def setPesoEstatura(self, pesoEstatura):
        self.__pesoEstatura = int(pesoEstatura)
    
    def getPesoEstatura(self):
        return self.__pesoEstatura
    
    def setFumador(self, fumador):
        self.__fumador = fumador
        
    def getFumador(self):
        return self.__fumador

    def setTiempoFumador(self, tiempoFumador):
        self.__tiempoFumador = int(tiempoFumador)
        
    def getTiempoFumador(self):
        return self.__tiempoFumador
    
    def setDieta(self, dieta):
        self.__dieta = dieta
    
    def getDieta(self):
        return self.__dieta
        
    def __str__(self):
        return (
            'Id: ' + str(self.__id) + '\n'
            'Nombre: ' + self.__nombre + '\n'
            'Edad: ' + str(self.__edad) + '\n'
            'Numero historia clinica: ' + str(self.__noHistoriaClinica)
        )
        
        
    def calcularPrioridad(self):
    #Calcula la prioridad de un paciente
    
        prioridad = None
        
        if self.__edad >0 and self.__edad <16:
        
            if self.__edad >0 and self.__edad <6:
                prioridad = self.__pesoEstatura + 3
        
            elif self.__edad >5 and self.__edad <13:
                prioridad = self.__pesoEstatura + 2

            elif self.__edad >12 and self.__edad <16:
                prioridad = self.__pesoEstatura + 1

        elif self.__edad >15 and self.__edad <41:
            
            if(self.__fumador and self.__tiempoFumador != None):
                prioridad = self.__tiempoFumador / 4 + 2
            else:
                prioridad = 2

        elif self.__edad >40:     
            if(self.__dieta and self.__edad >59 and self.__edad <101):
                prioridad = self.__edad / 20 + 4
            else:
                prioridad = self.__edad / 30 + 3 
        
        self.__prioridad = prioridad        
        
        
    def calcularRiesgo(self):
        
        # Calcula el riesgo de un paciente
        
        riesgo = None
        
        if self.__edad <41:
            riesgo = (self.__edad * self.__prioridad) / 100
        else:
            riesgo = ((self.__edad * self.__prioridad) / 100) + 5.3
            
        self.__riesgo = riesgo
