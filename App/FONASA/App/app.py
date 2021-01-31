from flask import Flask, request, jsonify, url_for, redirect, render_template, request
#from flask_mysqldb import MySQL
from database import mysql, dbInfo
from data import Cursor
from paciente import Paciente
from OperacionesEnum import Operacion


app = Flask(__name__)

app.secret_key = "12345"

# Conexión a la Base de datos
app.config['MYSQL_HOST'] = dbInfo["host"]
app.config['MYSQL_USER'] = dbInfo["user"]
app.config['MYSQL_PASSWORD'] = dbInfo["password"]
app.config['MYSQL_DB'] = dbInfo["database"]


mysql.init_app(app)

@app.route('/')
def index():
    return render_template('Base.html')



def modelarPacienteForm(request):

    # Obtiene un formulario y modela los datos a un objeto Persona
    
    nombre = request['nombre']
    edad = request['edad']
    noHisoriaClinica = request['noHistoriaClinica']
        
    paciente = Paciente(nombre, edad, noHisoriaClinica)
    
    if request.get('relPesoEstatura'):
        paciente.setPesoEstatura(request['relPesoEstatura'])        
        
    if request.get('fumador'):        
        paciente.setFumador(request['fumador'])
        
    if  request.get('tiempoFumando'):
        paciente.setTiempoFumador(request['tiempoFumando'])
    
    if  request.get('dieta'):        
        paciente.setDieta(request['dieta'])
        
    if request.get('idPaciente'):
        paciente.setId(request['idPaciente'])
    
    paciente.calcularPrioridad()
    paciente.calcularRiesgo()
    return paciente

def guardarPacienteDB(paciente):
    
    # Guarda un paciente en la base de datos
    
    with Cursor(mysql) as db:
        db.callproc('crudPaciente', [Operacion.insertar.value,
                                    None,
                                    paciente.getNombre(),
                                    paciente.getEdad(),
                                    paciente.getNoHistoriaClinica(),
                                    paciente.getPrioridad(),
                                    paciente.getRiesgo()])
        pacId = db.fetchone()[0]
    datosAdicionalesPaciente(paciente, pacId)

def actualizarPacienteDB(paciente):
    
    # Actualiza un paciente en la base de datos
    
    with Cursor(mysql) as db:
        db.callproc('crudPaciente', [Operacion.actualizar.value,
                                    paciente.getId(),
                                    paciente.getNombre(),
                                    paciente.getEdad(),
                                    paciente.getNoHistoriaClinica(),
                                    paciente.getPrioridad(),
                                    paciente.getRiesgo()])
    eliminarReferencias(paciente.getId() )
    datosAdicionalesPaciente(paciente, paciente.getId())

def datosAdicionalesPaciente(paciente, pacId):
    
    # Agrega los datos adicionales de un paciente
    
    edad = paciente.getEdad()

    with Cursor(mysql) as db:
        if (edad > 0 and edad < 16):
            db.callproc('crudPacienteNinno', [Operacion.insertar.value,
                                                   paciente.getPesoEstatura(),
                                                   pacId])

        elif (edad > 15 and edad < 41):
            db.callproc('crudPacienteJoven', [Operacion.insertar.value,
                                              paciente.getFumador(),
                                              paciente.getTiempoFumador(),
                                              pacId])

        elif (edad > 40):
            db.callproc('crudPacienteAnciano', [Operacion.insertar.value,
                                                paciente.getDieta(),
                                                pacId])

# def datosAdicionalesPacienteUpdate(paciente, pacId):
    
    
    
#     edad = paciente.getEdad()

#     with Cursor(mysql) as db:
#         if (edad > 0 and edad < 16):
#             db.callproc('crudPacienteNinno', [Operacion.actualizar.value,
#                                                    paciente.getPesoEstatura(),
#                                                    pacId])

#         elif (edad > 15 and edad < 41):
#             db.callproc('crudPacienteJoven', [Operacion.actualizar.value,
#                                               paciente.getFumador(),
#                                               paciente.getTiempoFumador(),
#                                               pacId])

#         elif (edad > 40):
#             db.callproc('crudPacienteAnciano', [Operacion.actualizar.value,
#                                                 paciente.getDieta(),
#                                                 pacId])

def eliminarReferencias(id):
    
    # Elimina las referencias de un paciente en las demas tablas
    
    eliminarRefrenciaNino(id)
    eliminarRefrenciaJoven(id)
    eliminarRefrenciaAnciano(id)

def eliminarRefrenciaNino(id):
    
    # Elimina los registros de un paciente en la tabla PNinno
    
    with Cursor(mysql) as db:
        db.callproc('crudPacienteNinno', [Operacion.eliminar.value,
                                          None,
                                          id])

def eliminarRefrenciaJoven(id):
    
    # Elimina los registros de un paciente en la tabla PJoven
    
    with Cursor(mysql) as db:
        db.callproc('crudPacienteJoven', [Operacion.eliminar.value,
                                          None,
                                          None,
                                          id])

def eliminarRefrenciaAnciano(id):
    
    # Elimina los registros de un paciente en la tabla PAnciano
    
    with Cursor(mysql) as db:
        db.callproc('crudPacienteAnciano', [Operacion.eliminar.value,
                                            None,
                                            id])

def modelarPacienteObject(id):

    #Consulta un paciente y lo transofmra en un objeto Paciente

    with Cursor(mysql) as db:
        db.callproc('crudPaciente', [Operacion.seleccionarById.value,
                                     id,
                                     None,
                                     None,
                                     None,
                                     None,
                                     None
                                     ])

        datos = db.fetchone()

        paciente = Paciente(datos[1], datos[2], datos[3])
        paciente.setId(datos[0])        
        paciente.setPrioridad(datos[4])
        paciente.setRiesgo(datos[5])
    
    with Cursor(mysql) as db:
        edad = paciente.getEdad()
        
        if (edad > 0 and edad < 16):

            db.callproc('crudPacienteNinno', [Operacion.seleccionarById.value,
                                                None,
                                                id])
            
            paciente.setPesoEstatura(db.fetchone()[1])

        elif (edad > 15 and edad < 41):
            db.callproc('crudPacienteJoven', [Operacion.seleccionarById.value,
                                              None,
                                              None,
                                              id])

            datosFumador = db.fetchone()
            
            if(datosFumador[1]):
                paciente.setFumador(datosFumador[1])
            if(datosFumador[2]):
                paciente.setTiempoFumador(datosFumador[2])

        elif (edad > 40):
            db.callproc('crudPacienteAnciano', [Operacion.seleccionarById.value,
                                                None,
                                                id])

            datos = db.fetchone()
            if(datos[0]):
                paciente.setDieta(datos[1])
        
    
    return paciente

def listarPacientes():
    
    # Obitene todos los pacientes de la Base de datos
    
    with Cursor(mysql) as db:
        db.callproc('crudPaciente', [Operacion.seleccionarTodos.value,
                                     None,
                                     None,
                                     None,
                                     None,
                                     None,
                                     None])
        datos = db.fetchall()
        pacientes = []
        for paciente in datos:
            pac = Paciente(paciente[1], paciente[2], paciente[3])
            pac.setId(paciente[0])
            pac.setRiesgo(paciente[4])
            pacientes.append(pac)
        return pacientes

def eliminarPacienteDB(id):
    
    #Elimina un paciente de la Base de datos
    
    eliminarReferencias(id)
    with Cursor(mysql) as db:
        db.callproc('crudPaciente', [Operacion.eliminar.value,
                                     id,
                                     None,
                                     None,
                                     None,
                                     None,
                                     None])
        

@app.route('/pacientes/ok')
@app.route('/pacientes/upt')
@app.route('/pacientes/del')
@app.route('/pacientes')
def pacientes():
    pacientes = listarPacientes()
    return render_template('PacienteLista.html', pacientes=pacientes)
    

@app.route('/pacientes/registro', methods=['GET', 'POST'])
def registroPacientes():
    if request.method == "POST":
        paciente = modelarPacienteForm(request.form)
        guardarPacienteDB(paciente)
        return redirect('/pacientes/ok')
    else :
        return render_template('PacienteRegistro.html')
    
    
@app.route('/pacientes/editar/<int:id>', methods=['GET', 'POST'])
def editarPaciente(id):
    if request.method == 'POST':
        paciente = modelarPacienteForm(request.form)
        actualizarPacienteDB(paciente)
        return redirect('/pacientes/upt')
    else:
        paciente = modelarPacienteObject(id)
        return render_template('PacienteUpdate.html', paciente=paciente)
    
@app.route('/pacientes/del/<int:id>')
def eliminarPaciente(id):
    eliminarPacienteDB(id)
    return redirect('/pacientes/del')

@app.route('/atencionPacientes')
def atencionPacientes():
    return render_template('AtencionPacientes.html')
    
    
from flask_restful import Resource, Api

api = Api(app)

class pacientesApi(Resource):
    
    def get(self):
        with Cursor(mysql) as db:
            db.callproc('crudPaciente', [Operacion.seleccionarTodos.value,
                                        None,
                                        None,
                                        None,
                                        None,
                                        None,
                                        None])
            datos = db.fetchall()
            pacientes = []
            for paciente in datos:
                pac = {
                    "id" : paciente[0],
                    "nombre" : paciente[1],
                    "edad" : paciente[2],
                    "noHistoriaClinica" : paciente[3],
                    "prioridad" : paciente[4],
                    "riesgo" : paciente[5]
                }
                pacientes.append(pac)
            return jsonify(pacientes)
    
api.add_resource(pacientesApi, '/pacientesBusqueda')

class cantidadConsultas(Resource):
    
    def get(self):
        with Cursor(mysql) as db:
            db.callproc('sp_Consultas', (Operacion.seleccionarTodos.value,None))
            datos = db.fetchone()
            return jsonify({"cantidad":datos[0]})
    
    
    def post(self):
        with Cursor(mysql) as db:
            db.callproc('sp_Consultas', (Operacion.insertar.value,request.json['cantidad']))
            return jsonify({"Estado":"Cantidad guardada"})

    def put(self):
        with Cursor(mysql) as db:
            db.callproc('sp_Consultas', (Operacion.actualizar.value, request.json['cantidad']))
            return jsonify({"Estado":"Cantidad actualizada"})

api.add_resource(cantidadConsultas, '/cantidadConsultas')
    
if __name__ == ('__main__'):
    app.run(debug=True)