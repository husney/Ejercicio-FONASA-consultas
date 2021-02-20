api = {
    url : 'http://127.0.0.1:5000'
}

const cantidadConsultas = document.getElementById('cantidadConsultas');
const btnAsignarCatnidad = document.getElementById('btnAsignarCantidad');
const activarCambioCantidad = document.getElementById('modificarCantidadConsutlas');
const enEspera = document.getElementById('consultasLibres');
const tablaPacientesEnEspera = document.getElementById('table-espera-body');
const consultaMasAtendida = document.getElementById('consulta-mas-atendida');
const cantidadConsultasAtendidas = document.getElementById('cantidad-consultas-atendidas');
const tablaConsultasActuales = document.getElementById('table-consultas-actuales-body');
const liberarConsultas = document.getElementById('btnLiberarConsultas');
const btnPacienteMasAnciano = document.getElementById('btn-paciente-mas-anciano');
const tablaAnciano = document.getElementById('table-anciano-body');
const btnPacientesMayorRiesgo = document.getElementById('btn-pacientes-mayor-riesgo');
const btnPacientesFumadores = document.getElementById('btn-pacientes-fumadores');
const pacientesFumadoresList = document.getElementById('pacientes-fumadores-list');
const tablaMayorRiesgo = document.getElementById('table-riesgo-body');
const historiaClinicaBusqueda = document.getElementById('historia-clinica-pacientes-input');
const btnCerrarMayorRiesgo = document.getElementById('cerrar-mayor-riesgo');
const vistaPacienteAnciano = document.getElementById('paciente-mas-anciano');
let estado = {
    citasAgendadas: ""
};
let consultasEnProceso = [];
let idRow = 0;

window.onload = cargarCantidad();

const consultasActuales = $("#table-consultas-actuales").DataTable({
    language : SpanishDataTable
});

const pacientesEnEspera = $("#table-espera-actuales").DataTable({
    language: SpanishDataTable,
    "ordering": false
});

const pacienteAnciano = $("#table-espera-anciano").DataTable({
    language: SpanishDataTable
});

const pacientesMayorRiesgo = $("#table-espera-riesgo").DataTable({
    language: SpanishDataTable
})




function cargarCantidad(){
    axios.get(`${api.url}/cantidadConsultas`).then(response =>{
        cantidadConsultas.value =  response.data['cantidad'];
    }).catch(e =>{
        console.log(e);
    })

    axios.get(`${api.url}/enConsulta`).then(response =>{
        enEspera.textContent = Number.parseInt(cantidadConsultas.value) - Number.parseInt(response.data['enEspera']);
    }).catch(e =>{
        console.log(e);
    })

    axios.get(`${api.url}/InfConsultaMasAtendida`).then(response =>{
        consultaMasAtendida.textContent = response.data['consulta'];
        //cantidadConsultasAtendidas.textContent = response.data['cantidad'];
    }).catch(e =>{
        console.log(e);
    });
    
    actualizarConsultasActuales();
    actualizarTablaEspera();    
}

liberarConsultas.addEventListener('click', () =>{
    axios.put(`${api.url}/liberarTodasConsultas`).then(response =>{
        console.log(response);
    }).catch(e =>{
        console.log(e);
    });
    consultasActuales.clear().draw();
    pacientesEnEspera.clear().draw();
    cargarCantidad();
});


activarCambioCantidad.addEventListener('change', e =>{
    if(e.target.checked){
        cantidadConsultas.removeAttribute('readonly');
        btnAsignarCatnidad.classList.remove('disabled');
        btnAsignarCatnidad.removeAttribute('disabled');
    }else{
        cantidadConsultas.setAttribute('readonly', true);
        btnAsignarCatnidad.classList.add('disabled');
        btnAsignarCatnidad.removeAttribute('disabled', true);
    }    
});

// Actualiza la cantidad de citas
btnAsignarCatnidad.addEventListener('click', e=>{
    datos = {
        cantidad: cantidadConsultas.value
    };    
    axios.put(`${api.url}/cantidadConsultas`, datos).then(response =>{
        console.log(response);
    }).catch(e =>{
        console.log(e);
    })

    cargarCantidad();
});


// Muestra y actualiza las citas que se atienden acutalmente
function actualizarConsultasActuales(){

    axios.get(`${api.url}/consultasActuales`).then(response =>{
        consultasEnProceso = [...response.data];
        //tablaConsultasActuales.innerText = '';
        const datosConsultas = [];
        response.data.forEach(consulta =>{
            //crearFilaConsultasActuales(consulta);
            let consul = [consulta.prioridadPaciente, consulta.nombrePaciente, consulta.nombreEspecialista, consulta.tipoConsulta, `<a href="javascript:void(0)"; id="despachoPaciente-${consulta.id}" onclick="eliminarConsultaActual(${consulta.idConsulta})" class="despacho-consulta btn btn-danger"><i class="fas fa-sign-out-alt "></i></a>`];
            datosConsultas.push(consul);
        });
        consultasActuales.rows.add(datosConsultas).draw();
    }).catch(e =>{
        console.log(e);
    })   
}

// Crea una fila para la tabla de consultas
function crearFilaConsultasActuales(consulta){

    const row = `
                <tr id="consulta-${consulta.idConsulta}">
                    <td>${consulta.prioridadPaciente}</td>                    
                    <td>${consulta.nombrePaciente}</td>
                    <td>${consulta.nombreEspecialista}</td>
                    <td>${consulta.tipoConsulta}</td>
                    <td><a href="javascript:void(0)"; id="despachoPaciente-${consulta.id}" onclick="eliminarConsultaActual(${consulta.idConsulta})" class="despacho-consulta btn btn-danger"><i class="fas fa-sign-out-alt "></i></a></td>
                </tr>
            `;
            tablaConsultasActuales.innerHTML += row;
}


btnPacienteMasAnciano.addEventListener('click', () =>{
    
    pacienteAnciano.clear().draw();
    axios.get(`${api.url}/PacienteMasAnciano`).then(response =>{
        //tablaAnciano.innerHTML = '';
        idRow = 0;
        const masAnciano = [];
        if(response.data.id > 0){
            //crearFilaMasAnciano(response.data)
            paciente = response.data;
            let pac = [paciente.nombre, paciente.edad, paciente.prioridad, paciente.noHistoriaClinica, `<select class="custom-select" id="anciano-espera-select-${paciente.id}"></select>`,
            `<input type="text" name="EspecialistaNombre" id="nombreEspecialista-paciente-anciano${paciente.id}" class="form-control">`,`<a href="javascript:void(0);" id="asignarConsulta-${paciente.id}" onclick="asignarConsultaPaciente('nombreEspecialista-paciente-anciano${paciente.id}', ${paciente.id})" class="asignar-consulta "><i class="fas fa-paste h4 text-info"></i></a>`, paciente];
            masAnciano.push(pac);
            pacienteAnciano.rows.add(masAnciano).draw();
            let tiposConsulta = crearTiposConsulta(masAnciano[0][7]);
            agregarTiposConsulta(`anciano-espera-select-${masAnciano[0][7].id}`, tiposConsulta);
            
        }
    }).catch(e =>{  
        console.log(e);
    });

    

    if(vistaPacienteAnciano.classList.contains('d-none')){
        vistaPacienteAnciano.classList.remove('d-none');
    }else{
        vistaPacienteAnciano.classList.add('d-none');
    }

})

btnPacientesMayorRiesgo.addEventListener('click', cargarPacientesMayorRiesgo);
btnPacientesFumadores.addEventListener('click', mostrarFumadoresUrgentes);

function cargarPacientesMayorRiesgo(){
    const busqueda = historiaClinicaBusqueda.value;

    //if(busqueda.value != null){

        axios.get(`${api.url}/pacientesHistoriaClinica?noHistoriaClinica=${busqueda}`).then(response =>{
            //idRow = 0;
            //tablaMayorRiesgo.innerHTML = '';
            const pacientes = [];
            response.data.forEach(paciente =>{
                let pac = [paciente.nombre, paciente.edad, paciente.prioridad, paciente.noHistoriaClinica, `<select class="custom-select" id="pacientes-riesgo-select-${paciente.id}"></select>`,`<input type="text" name="EspecialistaNombre" id="nombreEspecialista-paciente-mayor-${paciente.id}" class="form-control">`,`<a href="javascript:void(0);" id="asignarConsulta-${paciente.id}" onclick="asignarConsultaPaciente('nombreEspecialista-paciente-mayor-${paciente.id}', ${paciente.id})" class="asignar-consulta "><i class="fas fa-paste h4 text-info"></i></a>`, paciente];
                pacientes.push(pac);
                })
                pacientesMayorRiesgo.rows.add(pacientes).draw();
                pacientes.forEach(paciente =>{
                    let tiposConsulta = crearTiposConsulta(paciente[7]);
                    agregarTiposConsulta(`pacientes-riesgo-select-${paciente[7].id}`, tiposConsulta);
                })
        }).catch(e =>{
            console.log(e);
        });    
    //}

    document.getElementById('pacientes-mayor-riesgo').classList.remove('d-none');
}

function mostrarFumadoresUrgentes(){
    limpiarPacientesFumadores();
    const pacientesFumadoresSet = document.getElementById('pacientes-fumadores');
    if(pacientesFumadoresSet.classList.contains('d-none')){
        pacientesFumadoresSet.classList.remove('d-none');
    }else{
        pacientesFumadoresSet.classList.add('d-none');
    }
    axios.get(`${api.url}/pacientesFumadoresUrgentes`).then(response =>{
        console.log(response.data);
        response.data.forEach(dato =>{
            const li = document.createElement('li');
            li.textContent = dato.nombre;
            pacientesFumadoresList.appendChild(li);
        })
    }).catch(e =>{
        console.log(e);
    })
}

function limpiarPacientesFumadores(){
    while(pacientesFumadoresList.firstChild){
        pacientesFumadoresList.removeChild(pacientesFumadoresList.firstChild);
    }
}

// Elimina una consulta Actual
function eliminarConsultaActual(id){

    const consultaSeleccionada = consultasEnProceso.find( consulta => consulta.idConsulta = id);
    guardarRegistroConsulta(consultaSeleccionada);

    const datos = {
        "consulta" : id
    }

    axios.put(`${api.url}/LiberarConsutlas`, datos).then(response =>{
        console.log(response);
    }).catch(e =>{
        console.log(e);
    });
    
    //document.getElementById(`consulta-${id}`).remove();
    setTimeout(() =>{
        consultasActuales.clear().draw();
        pacientesEnEspera.clear().draw();
        cargarCantidad();
    },200);
}

// Guarda una consulta en la tabla de registro
function guardarRegistroConsulta(consulta){
    
    moment.locale('es');
    const datos = {
        "consulta": consulta.idConsulta,
        "cantidadPacientes" : consulta.cantidadPacientes,
        "nombreEspecialista" : consulta.nombreEspecialista,
        "paciente" : consulta.idPaciente,
        "hospital" : consulta.hospital,
        "tipoConsulta" : consulta.idTipoConsulta,
        //"fechaInicio" : consulta.fechaInicio
        "fechaInicio" : moment().format('YYYY-MM-D', consulta.fechaInicio)
        
    }
    axios.post(`${api.url}/bitacoraConsultas`, datos).then(response =>{
    }).catch(e =>{  
        console.log(e);
    })
}

axios.get(`${api.url}/pacientesFumadoresUrgentes`).then(response =>{
    console.log(response.data);
}).catch(e =>{
    console.log(e);
})

// Muestra y actualiza la tabla de los pacientes
function actualizarTablaEspera(){
        
    axios.get(`${api.url}/pacientesEspera`).then(response =>{
        let idRow = 0;
        const pacientesEsperando = [];
        response.data.forEach(paciente =>{
            idRow = 0;            
            let pac = [paciente.nombre, paciente.edad ,paciente.prioridad, paciente.noHistoriaClinica, `<select class="custom-select" id="en-espera-select-${paciente.id}"></select>`,
            `<input type="text" name="EspecialistaNombre" id="nombreEspecialista-paciente-espera${paciente.id}" class="form-control">`,`<a href="javascript:void(0);" id="asignarConsulta-${paciente.id}" onclick="asignarConsultaPaciente('nombreEspecialista-paciente-espera${paciente.id}', ${paciente.id})" class="asignar-consulta "><i class="fas fa-paste h4 text-info"></i></a>`, paciente];
            pacientesEsperando.push(pac);
        });
        pacientesEnEspera.rows.add(pacientesEsperando).draw();
        pacientesEsperando.forEach(paciente =>{
            let tiposConsulta = crearTiposConsulta(paciente[7]);
            agregarTiposConsulta(`en-espera-select-${paciente[7].id}`, tiposConsulta);
        })
    }).catch(e =>{
        console.log(e);
    })
}

function crearFilaEnEspera(paciente){    

    const tiposConsulta = []

            if(paciente.edad > 0 && paciente.edad <16 && paciente.prioridad <5){
                tiposConsulta.push({"Pediatría":1});
            }else{
                tiposConsulta.push({"CGI":3});
            }            
            if(paciente.prioridad > 4){
                tiposConsulta.push({"Urgencia":2});
            }
            
            const row = `
                <tr id="en-espera-pac-${paciente.id}" >
                    <td>${paciente.nombre}</td>
                    <td>${paciente.prioridad}</td>
                    <td>${paciente.noHistoriaClinica}</td>
                    <td>
                        <select class="custom-select" id="en-espera-select-${idRow}"></select>
                    </td>
                    <td><input type="text" name="EspecialistaNombre" id="nombreEspecialista${idRow}" class="form-control"></td>
                    <td><a href="javascript:void(0);" id="asignarConsulta-${idRow}" onclick="asignarConsultaPaciente(${paciente.id})" class="asignar-consulta "><i class="fas fa-paste h4 text-info"></i></a></td>
                </tr>
            `;
            tablaPacientesEnEspera.innerHTML += row;
            agregarTiposConsulta(`en-espera-select-${idRow}`, tiposConsulta);
            idRow++;
}

function crearFilaMasAnciano(paciente){    

    if(paciente.id > 0){
        const tiposConsulta = []

            if(paciente.edad > 0 && paciente.edad <16 && paciente.prioridad <5){
                tiposConsulta.push({"Pediatría":1});
            }else{
                tiposConsulta.push({"CGI":3});
            }            
            if(paciente.prioridad > 4){
                tiposConsulta.push({"Urgencia":2});
            }
            
            const row = `
                <tr id="en-espera-pac-${paciente.id}-anciano" >
                    <td>${paciente.nombre}</td>
                    <td>${paciente.prioridad}</td>
                    <td>${paciente.noHistoriaClinica}</td>
                    <td>
                        <select class="custom-select" id="en-espera-anciano-select-${idRow}"></select>
                    </td>
                    <td><input type="text" name="EspecialistaNombre" id="nombreEspecialista${idRow}" class="form-control"></td>
                    <td><a href="javascript:void(0);" id="asignarConsulta-${idRow}" onclick="asignarConsultaPaciente(${paciente.id})" class="asignar-consulta-anciano${paciente.id}"><i class="fas fa-paste h4 text-info"></i></a></td>
                </tr>
            `;
            tablaAnciano.innerHTML += row;
            agregarTiposConsulta(`en-espera-anciano-select-${idRow}`, tiposConsulta);
            idRow++;
    }
}

function crearTiposConsulta(paciente){
    if(paciente.id > 0){
        const tiposConsulta = []

            if(paciente.prioridad > 4){
                tiposConsulta.push({"Urgencia":2});
            }

            if(paciente.edad > 15){
                tiposConsulta.push({"CGI":3});
            }     

            if(paciente.edad > 0 && paciente.edad <16 && paciente.prioridad <5){
                tiposConsulta.push({"Pediatría":1});
            }
            return tiposConsulta;
    }
}


function crearFilaMayorRiesgo(paciente){
    if(paciente.id > 0){
        const tiposConsulta = []

            if(paciente.edad > 0 && paciente.edad <16 && paciente.prioridad <5){
                tiposConsulta.push({"Pediatría":1});
            }else{
                tiposConsulta.push({"CGI":3});
            }            
            if(paciente.prioridad > 4){
                tiposConsulta.push({"Urgencia":2});
            }
            
            const row = `
                <tr id="en-espera-pac-${paciente.id}-mayor-riesgo" >
                    <td>${paciente.nombre}</td>
                    <td>${paciente.prioridad}</td>
                    <td>${paciente.noHistoriaClinica}</td>
                    <td>
                        <select class="custom-select" id="en-espera-mayor-riesgo-select-${idRow}"></select>
                    </td>
                    <td><input type="text" name="EspecialistaNombre" id="nombreEspecialista${idRow}" class="form-control"></td>
                    <td><a href="javascript:void(0);" id="asignarConsulta-${idRow}" onclick="asignarConsultaPaciente(${paciente.id})" class="asignar-consulta-anciano${paciente.id}"><i class="fas fa-paste h4 text-info"></i></a></td>
                </tr>
            `;
            tablaMayorRiesgo.innerHTML += row;
            agregarTiposConsulta(`en-espera-mayor-riesgo-select-${idRow}`, tiposConsulta);
            idRow++;
    }
}

btnCerrarMayorRiesgo.addEventListener('click', () =>{

    const vistaMayorRiesgo = document.getElementById('pacientes-mayor-riesgo');

    if(vistaMayorRiesgo.classList.contains('d-none')){
        vistaMayorRiesgo.classList.remove('d-none');
    }else{
        vistaMayorRiesgo.classList.add('d-none');
    }

})

// Agrega las opciones a los select de tipo consulta
function agregarTiposConsulta(idFila, tipos){
    const select = document.getElementById(idFila);

    tipos.forEach(tipo =>{
        option = document.createElement('option');
        option.value = Object.values(tipo)[0];
        option.text = Object.keys(tipo)[0];
        select.appendChild(option);
    })
}

function asignarConsultaPaciente(idRow, idPac){
    const datosPaciente = document.getElementById(idRow).parentElement.parentElement;    
    if(Number.parseInt(enEspera.textContent) > 0){
        //verificarPacienteEstaEnConsulta(id);
        //if (estado.citasAgendadas == 0){
            
            const tipoConsulta = datosPaciente.children[4].children[0].value;
            const especialistaConsulta = datosPaciente.children[5].children[0].value;
        
            const datos = {
                "cantidadPacientes" : 0,
                "nombreEspecialista" : especialistaConsulta,
                "paciente" : idPac,
                "hospital" : 1,
                "tipoConsulta" : tipoConsulta,
                "estado" : 1
            }
        
            axios.put(`${api.url}/consultasPacientes`, datos).then( response =>{
                console.log(response.data);
            }).catch(e =>{
                console.log(e);
            });

            if(idRow.includes("nombreEspecialista-paciente-anciano")){
                btnPacienteMasAnciano.click();
            }else if(idRow.includes("nombreEspecialista-paciente-mayor-")){
                btnCerrarMayorRiesgo.click();
            }
            
            //#region eliminar consulta sin dataTable
            // datosPaciente.remove();
            // if(document.getElementById(`en-espera-pac-${id}-anciano`)){
            //     document.getElementById(`en-espera-pac-${id}-anciano`).remove();
            //     btnPacienteMasAnciano.click();
            // }

            // if(document.getElementById(`en-espera-pac-${id}-mayor-riesgo`)){
            //     document.getElementById(`en-espera-pac-${id}-mayor-riesgo`).remove();
            // }
            //#endregion
        //}
    }
    
    
    consultasActuales.clear().draw();
    pacientesEnEspera.clear().draw();
    pacienteAnciano.clear().draw();
    pacientesMayorRiesgo.clear().draw();
    eliminarPacienteEspera(idPac);
    cargarCantidad();
    btnPacientesFumadores.click();
    //cargarPacientesMayorRiesgo();
}

//Verifica si un paciente esta en consulta
function verificarPacienteEstaEnConsulta(id){    

    axios.get(`${api.url}/consultasPacientes?paciente=${id}`).then(response =>{
        estado.citasAgendadas = response.data["estado"];
    }).catch(e =>{
        console.log(e);
    })
}

// Elimina a un paciente en espera
function eliminarPacienteEspera(id){
    
    const datos = {
        "paciente": id
    }    
    // Delete no recibe cuerpo de datos por lo cual se debe realizar con esta sintaxis
    axios({
        method: 'DELETE',
        url: `${api.url}/pacientesEspera`,
        data: datos
      })    
}