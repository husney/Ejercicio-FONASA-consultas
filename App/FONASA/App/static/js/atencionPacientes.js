api = {
    url : 'http://127.0.0.1:5000'
}

const cantidadConsultas = document.getElementById('cantidadConsultas');
const btnAsignarCatnidad = document.getElementById('btnAsignarCantidad');
const activarCambioCantidad = document.getElementById('modificarCantidadConsutlas');
const enEspera = document.getElementById('consultasLibres');

window.onload = cargarCantidad();

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

    actualizarConsultasActuales();
    actualizarTablaEspera();
    //actualizarConsultasLibres();
}

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

    const tablaConsultasActuales = document.getElementById('table-consultas-actuales-body');    

    axios.get(`${api.url}/consultasActuales`).then(response =>{
        tablaConsultasActuales.innerText = '';
        response.data.forEach(consulta =>{

            const row = `
                <tr>
                    <td>${consulta.prioridad}</td>
                    <td>${consulta.nombrePaciente}</td>
                    <td>${consulta.nombreEspecialista}</td>
                    <td><a href="javascript:void(0)"; id="despachoPaciente-${consulta.id}" class="despacho-consulta btn btn-danger"><i class="fas fa-sign-out-alt "></i></a></td>
                </tr>
            `;
            tablaConsultasActuales.innerHTML += row;
        });

    }).catch(e =>{
        console.log(e);
    })   
}


// Acutaliza el campo de las consultas libres
function actualizarConsultasLibres(){

}

// Muestra y actualiza la tabla de los pacientes
function actualizarTablaEspera(){
    const tablaPacientesEnEspera = document.getElementById('table-espera-body');
    tablaPacientesEnEspera.innerHTML = '';
    axios.get(`${api.url}/pacientesEspera`).then(response =>{
        //console.log(response);
        let idRow = 0;
        response.data.forEach(paciente =>{

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
                    <td>
                        <select class="custom-select" id="en-espera-row-${idRow}"></select>
                    </td>
                    <td><input type="text" name="EspecialistaNombre" id="nombreEspecialista${idRow}" class="form-control"></td>
                    <td><a href="javascript:void(0);" id="asignarConsulta-${idRow}" onclick="asignarConsultaPaciente(${paciente.id})" class="asignar-consulta "><i class="fas fa-paste h4 text-info"></i></a></td>
                </tr>
            `;
            tablaPacientesEnEspera.innerHTML += row;
            agregarTiposConsulta(idRow, tiposConsulta);
            idRow++;
        })
    }).catch(e =>{
        console.log(e);
    })
}

// Agrega las opciones a los select de tipo consulta
function agregarTiposConsulta(idFila, tipos){
    const select = document.getElementById(`en-espera-row-${idFila}`);

    tipos.forEach(tipo =>{
        option = document.createElement('option');
        option.value = Object.values(tipo)[0];
        option.text = Object.keys(tipo)[0];
        select.appendChild(option);
    })
}

function asignarConsultaPaciente(id){
    const datosPaciente = document.getElementById(`en-espera-pac-${id}`)
    const tipoConsulta = datosPaciente.children[2].children[0].value;
    const especialistaConsulta = datosPaciente.children[3].children[0].value;

    const datos = {
        "cantidadPacientes" : 0,
        "nombreEspecialista" : especialistaConsulta,
        "paciente" : id,
        "hospital" : 1,
        "tipoConsulta" : tipoConsulta,
        "estado" : 1
    }

    // axios.post(`${api.url}/consultasPacientes`, datos).then( response =>{
    //     console.log(response.data);
    // }).catch(e =>{
    //     console.log(e);
    // });

    eliminarPacienteEspera(id);
    actualizarTablaEspera();
    actualizarConsultasActuales();    
    cargarCantidad();

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