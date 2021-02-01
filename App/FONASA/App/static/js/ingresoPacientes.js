api = {
    url : 'http://127.0.0.1:5000'
}
window.onload = cargarPacientes();

const tablaPacientes = document.getElementById('table-pacientes-body');

// Lista todos los pacientes de la base de datos
function cargarPacientes(){

    axios.get(`${api.url}/consultarPacientes`).then( response =>{
        tablaPacientes.innerHTML = '';
        response.data.forEach(paciente =>{
            actualizarTablaConsultas(paciente);
        });
    }).catch(e =>{
        console.log(e);
    })
}

// Actualiza la tabla con los datos del paciente
function actualizarTablaConsultas(paciente){
    
    const row = `
        <tr>
            <td>${paciente.nombre}</td>
            <td>${paciente.edad}</td>
            <td>${paciente.noHistoriaClinica}</td>
            <td>${paciente.prioridad}</td>
            <td>${paciente.riesgo}</td>
            <td><a href="javascript:void(0);" onclick=ingresarPaciente(${paciente.id})><i class="fas fa-ticket-alt text-success h4"></i></a></td>
        </tr>
    `;
    tablaPacientes.innerHTML += row;
}

// Ingresa un paciente a la sala de espera
function ingresarPaciente(id){
    datos = {
        "paciente":id
    }
    axios.post(`${api.url}/consultarPacientes`, datos).then(response =>{
        console.log(response);
    }).catch(e =>{
        console.log(e);
    })

}