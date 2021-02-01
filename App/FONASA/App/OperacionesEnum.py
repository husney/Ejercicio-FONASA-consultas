from enum import Enum

class Operacion(Enum):
    insertar = 0
    actualizar = 1
    eliminar = 2
    seleccionarTodos = 3
    seleccionarById = 4
    
    
class Consultas(Enum):
    enEspera = 5
    enConsulta = 6