import motorfisico.*
import wollok.game.*

object personaje {
    
    var property xReal = 5.0
    var property yReal = 5.0

    var property position = game.at(25, 25)
    method image() = "personaje.png" 
    
    var property vx = 0.0 
    var property vy = 0.0

    var property yendoDerecha = false
    var property yendoIzquierda = false
           
    const aceleracionSuelo = 0.24
    const aceleracionAire = 0.12     
    const impulsoSalto = 1.5     
    const velMaximaX = 0.6
    const anchoPersonaje = 3 // en celdas
    const altoPersonaje = 3

    // solo getters y no properties porque no se modifican, distinto de, por ejemplo, las velocidades que las cambia el motor fisico
    method aceleracionSuelo() = aceleracionSuelo
    method aceleracionAire() = aceleracionAire  
    method impulsoSalto() = impulsoSalto     
    method velMaximaX() = velMaximaX
    method anchoPersonaje() = anchoPersonaje
    method altoPersonaje()  = altoPersonaje       

    var property estaApoyado = false // REVISAR CUANDO CAMBIEMOS LOGICA DE PAREDES

    method avanzarDerecha() { yendoDerecha = true }
    method frenarDerecha()   { yendoDerecha = false }

    method avanzarIzquierda() { yendoIzquierda = true }
    method frenarIzquierda()   { yendoIzquierda = false }


    method saltar() {
        motorFisico.salto(self)
    }

    method centrar() { 
        xReal = 5.0
        yReal = 5.0
        vx = 0.0
        vy = 0.0
    }

    method irA(nuevaPosicion) {
        motorFisico.irA(nuevaPosicion, self)
    }

    // llave
    var tieneLlave = false

    method tieneLlave() = tieneLlave
    method agarrarLlave() { tieneLlave = true }
}