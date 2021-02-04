from flask import Flask, request, jsonify, url_for, redirect, render_template, request, session
#from flask_mysqldb import MySQL
from database import mysql, dbInfo
from data import Cursor
from paciente import Paciente
from OperacionesEnum import Operacion, Consultas, Informes


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
        db.callproc('crudPaciente', (Operacion.insertar.value,
                                    None,
                                    paciente.getNombre(),
                                    paciente.getEdad(),
                                    paciente.getNoHistoriaClinica(),
                                    paciente.getPrioridad(),
                                    paciente.getRiesgo()))
        pacId = db.fetchone()[0]
    datosAdicionalesPaciente(paciente, pacId)

def actualizarPacienteDB(paciente):
    
    # Actualiza un paciente en la base de datos
    
    with Cursor(mysql) as db:
        db.callproc('crudPaciente', (Operacion.actualizar.value,
                                    paciente.getId(),
                                    paciente.getNombre(),
                                    paciente.getEdad(),
                                    paciente.getNoHistoriaClinica(),
                                    paciente.getPrioridad(),
                                    paciente.getRiesgo()))
    eliminarReferencias(paciente.getId() )
    datosAdicionalesPaciente(paciente, paciente.getId())

def datosAdicionalesPaciente(paciente, pacId):
    
    # Agrega los datos adicionales de un paciente
    
    edad = paciente.getEdad()

    with Cursor(mysql) as db:
        if (edad > 0 and edad < 16):
            db.callproc('crudPacienteNinno', (Operacion.insertar.value,
                                                   paciente.getPesoEstatura(),
                                                   pacId))

        elif (edad > 15 and edad < 41):
            db.callproc('crudPacienteJoven', (Operacion.insertar.value,
                                              paciente.getFumador(),
                                              paciente.getTiempoFumador(),
                                              pacId))

        elif (edad > 40):
            db.callproc('crudPacienteAnciano', (Operacion.insertar.value,
                                                paciente.getDieta(),
                                                pacId))

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
        db.callproc('crudPacienteNinno', (Operacion.eliminar.value,
                                          None,
                                          id))

def eliminarRefrenciaJoven(id):
    
    # Elimina los registros de un paciente en la tabla PJoven
    
    with Cursor(mysql) as db:
        db.callproc('crudPacienteJoven', (Operacion.eliminar.value,
                                          None,
                                          None,
                                          id))

def eliminarRefrenciaAnciano(id):
    
    # Elimina los registros de un paciente en la tabla PAnciano
    
    with Cursor(mysql) as db:
        db.callproc('crudPacienteAnciano', [Operacion.eliminar.value,
                                            None,
                                            id])

def modelarPacienteObject(id):

    #Consulta un paciente y lo transofmra en un objeto Paciente

    with Cursor(mysql) as db:
        db.callproc('crudPaciente', (Operacion.seleccionarById.value,
                                     id,
                                     None,
                                     None,
                                     None,
                                     None,
                                     None
                                    ))

        datos = db.fetchone()

        paciente = Paciente(datos[1], datos[2], datos[3])
        paciente.setId(datos[0])        
        paciente.setPrioridad(datos[4])
        paciente.setRiesgo(datos[5])
    
    with Cursor(mysql) as db:
        edad = paciente.getEdad()
        
        if (edad > 0 and edad < 16):

            db.callproc('crudPacienteNinno', (Operacion.seleccionarById.value,
                                                None,
                                                id))
            
            paciente.setPesoEstatura(db.fetchone()[1])

        elif (edad > 15 and edad < 41):
            db.callproc('crudPacienteJoven', (Operacion.seleccionarById.value,
                                              None,
                                              None,
                                              id))

            datosFumador = db.fetchone()
            
            if(datosFumador[1]):
                paciente.setFumador(datosFumador[1])
            if(datosFumador[2]):
                paciente.setTiempoFumador(datosFumador[2])

        elif (edad > 40):
            db.callproc('crudPacienteAnciano', (Operacion.seleccionarById.value,
                                                None,
                                                id))

            datos = db.fetchone()
            if(datos[0]):
                paciente.setDieta(datos[1])
        
    
    return paciente

def listarPacientes():
    
    # Obitene todos los pacientes de la Base de datos
    
    with Cursor(mysql) as db:
        db.callproc('crudPaciente', (Operacion.seleccionarTodos.value,
                                     None,
                                     None,
                                     None,
                                     None,
                                     None,
                                     None))
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
        db.callproc('crudPaciente', (Operacion.eliminar.value,
                                     id,
                                     None,
                                     None,
                                     None,
                                     None,
                                     None))
        

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

@app.route('/ingresarPaciente')
def ingresarPaciente():
    return render_template('IngresoPaciente.html')
    
    
from flask_restful import Resource, Api

api = Api(app)

class pacientesApi(Resource):
    
    def get(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('crudPaciente', (Operacion.seleccionarTodos.value,
                                        None,
                                        None,
                                        None,
                                        None,
                                        None,
                                        None))
                datos = db.fetchall()
                pacientes = []
                for paciente in datos:
                    pac = {
                        "id" : paciente[0],
                        "nombre" : paciente[1],
                        "edad" : paciente[2],
                        "noHistoriaClinica" : paciente[3],
                        "prioridad" : float(str(paciente[4])),
                        "riesgo" : float(str(paciente[5]))
                    }
                    pacientes.append(pac)
                return jsonify(pacientes)
            except Exception as ex:
                return jsonify({"estado": f"Error al realizar la consulta {ex}"})
    
api.add_resource(pacientesApi, '/pacientesBusqueda')

class cantidadConsultas(Resource):
    
    def get(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_Consultas', (Operacion.seleccionarTodos.value,None))
                datos = db.fetchone()
                return jsonify({"cantidad":datos[0]})
            except Exception as ex:
                return jsonify({"estado": f"error al realizar la consulta {ex}"})
    
    
    def post(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_Consultas', (Operacion.insertar.value,request.json['cantidad']))
                return jsonify({"Estado":"Cantidad guardada"})
            except Exception as ex:
                return jsonify({"estado": f"error al guardar {ex}"})
            

    def put(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_Consultas', (Operacion.actualizar.value, request.json['cantidad']))
                return jsonify({"Estado":"Cantidad actualizada"})
            except Exception as ex:
                return jsonify({"estado": f"error al actualizar {ex}"})

api.add_resource(cantidadConsultas, '/cantidadConsultas')

class enConsulta(Resource):
    def get(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_Consultas', [Consultas.enEspera.value,None,])
                datos = db.fetchone()
                return jsonify({'enEspera':datos[0]})
            except Exception as ex:
                return jsonify({"estado": f"error al realizar la consulta {ex}"})
            
            
            
api.add_resource(enConsulta, '/enConsulta')


class consultasActuales(Resource):
    def get(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_Consultas',[Consultas.enConsulta.value, None])
                consultas = db.fetchall()
                datos = []
                for consulta in consultas:
                    consul = {
                        'idConsulta': consulta[0],
                        'cantidadPacientes': consulta[1],
                        'nombreEspecialista': consulta[2],
                        'idPaciente': consulta[3],
                        'hospital' : consulta[4],
                        'tipoConsulta' : consulta[5],
                        'estado' : consulta[6],
                        'fechaInicio' : consulta[7],
                        'nombrePaciente' : consulta[8],
                        'edadPaciente' : consulta[9],
                        'riesgoPaciente' : float(str(consulta[10])),
                        'prioridadPaciente' : float(str(consulta[11])),
                        'idTipoConsulta' : consulta[12]
                    }
                    datos.append(consul)
                return jsonify(datos)
            except Exception as ex:
                return jsonify({"estado": f"Error al realizar la consulta {ex}"})
    


class consultarPacientes(Resource):
    def get(self):
         with Cursor(mysql) as db:
            try:
                db.callproc('sp_Ingresados', (Operacion.seleccionarTodos.value, None))
                pacientes = db.fetchall()
                datos = []
                for paciente in pacientes:
                    pac = {
                        'id' : paciente[0],
                        'nombre' : paciente[1],
                        'noHistoriaClinica' : paciente[2],
                        'edad' : paciente[3],
                        'riesgo' : float(str(paciente[4])),
                        'prioridad' : float(str(paciente[5]))
                    }
                    datos.append(pac)
                return datos
            except Exception as ex:
                return jsonify({"estado": f"Error al realizar la consulta {ex}"})
        
    def post(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_Ingresados', (Operacion.insertar.value, request.json['paciente']))
                return jsonify({"Estado":"Ingresado"})
            except Exception as ex:
                return jsonify({"estado": f"Error al guardar {ex}"})
        

class consultarPacientesEspera(Resource):
    
    def get(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_Ingresados', (Consultas.enEspera.value, None))
                pacientes = db.fetchall()
                datos = []
                for paciente in pacientes:
                    pac = {
                        'id': paciente[0],
                        'fechaIngreso' : paciente[1],
                        'nombre' : paciente[2],
                        'edad' : paciente[3],
                        'noHistoriaClinica' : paciente[4],
                        'riesgo' : float(str( paciente[5])),
                        'prioridad' : float(str(paciente[6]))
                    }
                    datos.append(pac)
                return jsonify(datos)
            except Exception as ex:
                return jsonify({"estado": f"Error al realizar la consulta {ex}"})
        
    def delete(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_Ingresados', (Operacion.eliminar.value, request.json['paciente']))
                return jsonify({"estado":"Ingreso eliminado"})
            except Exception as ex:
                return jsonify({"estado": f"Error al eliminar {ex}"})


class ConsultasPacientes(Resource):
    
    def get(self):
        with Cursor(mysql) as db:
            try:
                paciente = request.args.get('paciente')
                db.callproc('sp_ConsultasPaciente', (Operacion.seleccionarById.value, None, None, None, paciente, None, None, None, None))
                respuesta = db.fetchone() 
                if respuesta is not None:
                    return jsonify({"estado":respuesta[0]})
            except Exception as ex:
                return jsonify({"estado": f"Error al validar la consulta {ex}"})
    
    def post(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_ConsultasPaciente', (Operacion.insertar.value, None,request.json['cantidadPacientes'], request.json['nombreEspecialista'], request.json['paciente'], request.json['hospital'], request.json['tipoConsulta'], request.json['estado'], None))
                respuesta = db.fetchone()
                return jsonify({"estado":"Consulta registrada"})
            except Exception as ex:
                return jsonify({"estado":"Error al registrar consulta"})
            
    def put(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_ConsultasPaciente', (Operacion.actualizar.value, None,request.json['cantidadPacientes'], request.json['nombreEspecialista'], request.json['paciente'], request.json['hospital'], request.json['tipoConsulta'], request.json['estado'], None))
                return jsonify({"estado": "consulta registrada"})
            except Exception as ex:
                return jsonify({"estado": f"Error al modificar la consulta {ex}"})

class LiberarConsultas(Resource):
    
    def put(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_ConsultasPaciente', (Consultas.eliminarConsulta.value, request.json['consulta'], None, None, None,None, None, None, None))
                return jsonify({"estado": "Consulta eliminada"})
            except Exception as ex:
                return jsonify({"estado": f"Error al eliminar la consulta {ex}"})

class BitacoraConsultas(Resource):

    def post(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_ConsultasPaciente', (Consultas.registroConsultaBitacora.value, request.json['consulta'], request.json['cantidadPacientes'], request.json['nombreEspecialista'], request.json['paciente'], request.json['hospital'], request.json['tipoConsulta'], None, request.json['fechaInicio']))
                return jsonify({"estado": "Consulta registrada en el historial"})
            except Exception as ex:
                return jsonify({"estado": f"Error al registrar la consulta {ex}"})

class InfConsultaMasAtendida(Resource):
    
    def get(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_Informes', (Informes.consultaMasAtendida.value, None))
                datos = db.fetchone()
                consulta = {
                    "consulta" : datos[0],
                    "cantidad" : datos[1]
                }
                return jsonify(consulta)
            except Exception as ex:
                return jsonify({"estado": f"Error al realizar la consulta {ex}"})

class LiberarTodasConsultas(Resource):
    
    def put(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_ConsultasPaciente', (Consultas.liberarTodas.value, None, None, None, None,None, None, None, None))
                return jsonify({"estado": "Consultas liberadas"})
            except Exception as ex:
                return jsonify({"estado": f"Error al liberar las consultas {ex}"})

class PacienteMasAnciano(Resource):
    
    def get(self):
        with Cursor(mysql) as db:
            try:
                db.callproc('sp_Informes', (Informes.pacienteMasAnciano.value, None))
                datos = db.fetchone()
                paciente = {
                    'id': datos[0],
                    'fechaIngreso' : datos[1],
                    'nombre' : datos[2],
                    'edad' : datos[3],
                    'noHistoriaClinica' : datos[4],
                    'riesgo' : float(str(datos[5])),
                    'prioridad' : float(str(datos[6]))
                }
                return jsonify(paciente);
            except Exception as ex:
                return jsonify({"estado": f"Error al consultar paciente {ex}"})

class PacientesBusquedaHistoriaclinica(Resource):
    
    def get(self):
        with Cursor(mysql) as db:
            try:
                noHistoriaClinica = request.args.get('noHistoriaClinica')
                db.callproc('sp_Informes', (Informes.pacientesMayorRiesgo.value, noHistoriaClinica))
                pacientes = db.fetchall()
                datos = []
                for paciente in pacientes:
                    pac = {
                        'id': paciente[0],
                        'fechaIngreso': paciente[1],
                        'nombre': paciente[2],
                        'edad': paciente[3],
                        'noHistoriaClinica': paciente[4],
                        'riesgo': float(str(paciente[5])),
                        'prioridad': float(str(paciente[6]))
                    }
                    datos.append(pac)
                return jsonify(datos)
                return jsonify(pacientes)
            except Exception as ex:
                return jsonify({"estado" : f"Error al consultar pacientes {ex}"})
            
            
# Endpoints
api.add_resource(consultasActuales, '/consultasActuales')
api.add_resource(consultarPacientes, '/consultarPacientes')
api.add_resource(consultarPacientesEspera, '/pacientesEspera')
api.add_resource(ConsultasPacientes, '/consultasPacientes')
api.add_resource(LiberarConsultas, '/LiberarConsutlas')
api.add_resource(BitacoraConsultas, '/bitacoraConsultas')            
api.add_resource(InfConsultaMasAtendida, '/InfConsultaMasAtendida')
api.add_resource(LiberarTodasConsultas, '/liberarTodasConsultas')
api.add_resource(PacienteMasAnciano, '/PacienteMasAnciano')
api.add_resource(PacientesBusquedaHistoriaclinica, '/pacientesHistoriaClinica')

if __name__ == ('__main__'):
    app.run(debug=True)