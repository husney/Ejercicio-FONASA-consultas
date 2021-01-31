if(window.location.pathname === '/pacientes/registro' || window.location.pathname.includes('/pacientes/editar')){
    validarFormularioPaciente();
}else if(window.location.pathname === '/pacientes/ok'){
    notificar('¡Registro Exitoso!', 'success');
}else if(window.location.pathname === '/pacientes/upt'){
    notificar('¡Paciente Actualizado!', 'info');
}else if(window.location.pathname === '/pacientes/del'){
    notificar('¡Paciente Eliminado!', 'danger');
    
}


// Validación para el forulario paciente
//validarFormularioPaciente()
function validarFormularioPaciente(){
    const datosAdicionales = document.getElementById('datos-adicionales');
    const nombre = document.getElementById('nombre');
    const noHistoriaClinica = document.getElementById('noHistoriaClinica');
    const edad = document.getElementById('edad');
    const enviarDatos = document.getElementById('btnGuardarPaciente');
    const errores = document.getElementById('mensajes-errores');    

    const validacion = {
        nombre : false,
        noHistoriaClinica: false,
        edad : false,
        relacionPesoEstatura : false,
        relacionPesoEstaturaExiste : false
    }

    const mensajes = {
        faltaNombre : "El nombre es requerido",
        nombreInvalido: "El nombre no es valido",
        faltaNoHistoria : "El número de la historia clinica es requerido",
        noHistoriaInValido: "El número de la historia clinica no es valido",
        faltaEdad: "La edad es requerida",
        edadInvalida: "La edad no es valida",
        faltaRelacionPeso: "La relación peso estatura es requerida",
        relacionPesoInvalida: "La relación peso estatura no es valida debe ser un rango entre 1 hasta 4"
    }

    nombre.addEventListener('blur', e =>{
        limpiarErrores();
        if(e.target.value.trim().length > 0){
            const valor = e.target.value;
            const nombreExpr = /^([A-Za-zÁÉÍÓÚñáéíóúÑ]{0}?[A-Za-zÁÉÍÓÚñáéíóúÑ\']+[\s])+([A-Za-zÁÉÍÓÚñáéíóúÑ]{0}?[A-Za-zÁÉÍÓÚñáéíóúÑ\'])+[\s]?([A-Za-zÁÉÍÓÚñáéíóúÑ]{0}?[A-Za-zÁÉÍÓÚñáéíóúÑ\'])?$/;

            if(nombreExpr.test(valor)){
                validacion.nombre = true;
            }else{
                mostrarError(mensajes.nombreInvalido);
            }
        }else{
            mostrarError(mensajes.faltaNombre);
        }
        validarEnvio();
    });

    noHistoriaClinica.addEventListener('blur', e =>{
        limpiarErrores();
        if(e.target.value.trim().length > 0 ){
            const valor = e.target.value;
            const noHistoriaExpr = /[0-9]{5,30}/

            if(noHistoriaExpr.test(valor)){
                validacion.noHistoriaClinica = true;
            }else{
                mostrarError(mensajes.noHistoriaInValido);
            }
        }else{
            mostrarError(mensajes.faltaNoHistoria);
        }
        validarEnvio();
    });

    edad.addEventListener('blur', e=>{
        limpiarErrores();
        if(e.target.value.length > 0){
            if (parseInt(e.target.value) && parseInt(e.target.value) < 121){
                validacion.edad = true;

                valorEdad = parseInt(e.target.value);
                
                limpiarDatosAdicionales();

                // Se agregan los datos adicionales dependiendo de la edad seleccionada
                if(valorEdad > 0 && valorEdad < 16){
                    datosAdicionales.innerHTML +=`
                    <div class="form-group">
                        <label for="relPesoEstatura">Relación de peso-estatura</label>
                        <input type="number" min="1" max="4" name="relPesoEstatura" id="relPesoEstatura" class="form-control w-25 relacion-peso-estatura">
                    </div>
                        `;

                    const pesoEstatura = document.getElementById('relPesoEstatura');
                    validacion.relacionPesoEstaturaExiste = true;
                    validacion.relacionPesoEstatura = false;
                    pesoEstatura.addEventListener('blur', e =>{
                        limpiarErrores();
                        if(e.target.value.trim().length > 0){
                            valor = parseInt(e.target.value);
                            if(valor > 0 && valor < 5){
                                validacion.relacionPesoEstatura = true;
                            }else{
                                mostrarError(mensajes.relacionPesoInvalida);
                            }
                        }else{
                            mostrarError(mensajes.faltaRelacionPeso)
                        }
                        validarEnvio();
                    });
                }else if(valorEdad > 15 && valorEdad < 41){
                    validacion.relacionPesoEstaturaExiste = false;
                    datosAdicionales.innerHTML += `
                    <div class="row" id="datosFumador">
                        <div class="col-4  pr-0">
                            <div class="form-check ">
                            <input class="form-check-input fuma" type="checkbox" id="fumador" name="fumador">
                            <label class="form-check-label" for="fumador">
                                ¿Fuma o ha fumado?
                            </label>
                            </div>
                        </div>                   

                        <div class="form-group col-5 pl-4 pr-0 d-none tiempo-fumador" id="label-tiempo-fumador">
                            <label for="tiempoFumando" class="d-none tiempo-fumador">¿Cuantos años ha fumado?</label>                       
                        </div>

                        <div class="col-3 px-0 d-none tiempo-fumador" id="input-tiempo-fumador">
                            <input type="number" min="0" max="100" name="tiempoFumando" id="tiempoFumando" class="form-control w-75 d-none tiempo-fumador">
                        </div>
                    </div>
                    `;
                    
                    const isFumador = document.getElementById('fumador');
                    isFumador.addEventListener('change', e =>{
                        if(e.target.checked){                            
                            mostrarTiempoFumador();
                        }else{
                            ocultarTiempoFumador();
                        }
                    });

                }else if(valorEdad > 40){
                    validacion.relacionPesoEstaturaExiste = false;
                    datosAdicionales.innerHTML += `
                    <div class="col-12">
                        <div class="form-check px-1">
                            <input class="form-check-input dieta" type="checkbox" id="dieta" name="dieta">
                            <label class="form-check-label" for="dieta">
                            ¿Tiene dieta?
                            </label>
                        </div>
                    </div>`;
                }
                
            }else{
                mostrarError(mensajes.edadInvalida);
            }
        }else{
           mostrarError(mensajes.faltaEdad);
        }
        validarEnvio();
    });

    
    enviarDatos.addEventListener('click', e =>{
        e.preventDefault();
        //const form = document.getElementById('form-paciente');
        if(validarEnvio(true)){
            guardarDatos();
        }
    });

    // Limpia el contendor de los datos adicionales
    function limpiarDatosAdicionales(){
        datosAdicionales.innerHTML = '';
    }

    // Muestra los errores
    function mostrarError(error){
        errores.innerHTML = `
                <p class="font-weight-bold text-danger">${error}</p>
            `;
    }

    // Limpia el contenedor de los errores
    function limpiarErrores(){
        errores.innerHTML = '';
    }


    // Valida los campos para activar el boton de enviar
    function validarEnvio(regreso = false){
        let envio = false;
        if(validacion.nombre && validacion.noHistoriaClinica && validacion.edad){
            if(document.getElementById('relPesoEstatura')){
                if(validacion.relacionPesoEstaturaExiste &&validacion.relacionPesoEstatura){
                    enviarDatos.removeAttribute('disabled');
                    enviarDatos.classList.remove('disabled');
                    envio = true;
                }else{
                    enviarDatos.setAttribute('disabled', true);
                    enviarDatos.classList.contains('disabled') ? null : enviarDatos.classList.add('disabled');
                }
            }else{
                enviarDatos.removeAttribute('disabled');
                enviarDatos.classList.remove('disabled');
                envio = true;
            }
            if(regreso === true){
                return envio;
            }
        }
    }

    // muestra el tiempo si es fumador
    function mostrarTiempoFumador(){
        const elementos = document.getElementsByClassName('tiempo-fumador');
        
        for(let i = 0; i < elementos.length; i++){
            if(elementos[i].classList.contains('d-none')){
                elementos[i].classList.remove('d-none');
            }
        }
    }

    // oculta el tiempo fumador
    function ocultarTiempoFumador(){
        const elementos = document.getElementsByClassName('tiempo-fumador');

        for(let i = 0; i < elementos.length; i++){
            if(!elementos[i].classList.contains('d-none')){
                elementos[i].classList.add('d-none');
            }
        }
    }

    // Ejecuta el evento submit del formulario
    function guardarDatos(){
        const form = document.getElementById('form-paciente');
        form.submit();
    }

    if(window.location.pathname.includes('/pacientes/editar')){
        cargarDatosPaciente();
    }

    // Carga los datos de un paciente cuando se esta eidtando
    function cargarDatosPaciente(){
        const idPaciente = document.getElementById('idPaciente');

        idPaciente.value = datosPaciente.id;

        edad.value = datosPaciente.edad;
        edad.focus();
        edad.blur();
        
        nombre.value = datosPaciente.nombre;
        nombre.focus();
        nombre.blur();

        noHistoriaClinica.value = datosPaciente.noHistoriaClinica;
        noHistoriaClinica.focus();
        noHistoriaClinica.blur();



        if(edad.value > 0 && edad.value <16){
            const pesoEstaturaEditar = document.getElementById('relPesoEstatura');
            pesoEstaturaEditar.value = datosPaciente.pesoEstatura;
            pesoEstaturaEditar.focus();
            pesoEstaturaEditar.blur();
            
        }else if(edad.value > 15 && edad.value < 41){
            const fumadorEditar = document.getElementById('fumador');
            const tiempoFumadorEditar = document.getElementById('tiempoFumando');

            if(datosPaciente.fumador != "None"){
                fumadorEditar.checked = true;
                tiempoFumadorEditar.value = datosPaciente.tiempoFumador;
                mostrarTiempoFumador();
            }
            
        }else if(edad.value > 40){
            const tieneDietaEditar = document.getElementById('dieta');
            if(datosPaciente.dieta != "None"){
                tieneDietaEditar.checked = true;
            }
        }
        
    }
}

function notificar(mensaje, color){
    const notificaciones = document.getElementById('notificaciones');

    notificaciones.innerHTML =`
        <div class="alert alert-${color} alert-dismissible fade show" role="alert">
            ${mensaje}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        `;
    
    setTimeout(()=>{
        notificaciones.remove();
        window.location.href = '/pacientes';
    }, 3000);
    
}

if(window.location.pathname.includes === '/pacientes/'){
    eliminarPaciente();
}

function eliminarPaciente(url){
    //let links = document.getElementsByClassName('eliminar-paciente');
    
    if(confirm('¿Desea eliminar este paciente?')){
        window.location = url;
    }

    // for(let i = 0; i < links.length; i++){
    //     links[i].addEventListener('click', e => {
    //         e.preventDefault();
    //         if(confirm('¿Desea eliminar este paciente?')){
    //             window.location.href = links[i].href;
    //         }
    //     });
    // }

}