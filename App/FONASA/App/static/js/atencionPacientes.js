api = {
    url : 'http://127.0.0.1:5000'
}

// axios.get(`${url}/pacientesBusqueda`).then(response =>{
//         console.log(response)
//     })


const cantidadConsultas = document.getElementById('cantidadConsultas');
const btnAsignarCatnidad = document.getElementById('btnAsignarCantidad');

btnAsignarCatnidad.addEventListener('click', e=>{
    datos = {
        cantidad: cantidadConsultas.value
    };
    const urlP = 'http://127.0.0.1:5000';

    // axios.post(`${urlP}/cantidadConsultas`,
    // {
    //     cantidad: parseInt(cantidadConsultas.value)
    // }).then(response =>{
    //     console.log(response.data);
    // }).catch(e =>{
    //     console.log(e);
    // })

    // axios.put(`${api.url}/cantidadConsultas`, {'cantidad':20}).then(response =>{
    //     console.log(response);
    // }).catch(e =>{
    //     console.log(e);
    // })

    // axios.post(`${api.url}/cantidadConsultas`, {'cantidad'  : 20}).then(response =>{
    //     console.log(response);
    // }).catch(e =>{
    //     console.log(e);
    // })

    // axios.post(`${api.url}/cantidadConsultas`, datos).then(response =>{
    //     console.log(response);
    // }).catch(e =>{
    //     console.log(e);
    // })

    axios.put(`${api.url}/cantidadConsultas`, datos).then(response =>{
        console.log(response);
    }).catch(e =>{
        console.log(e);
    })

});