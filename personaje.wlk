import wollok.game.*

object personaje {
    
    var xReal = 5.0
    var yReal = 5.0

    method xReal() = xReal 
    method yReal() = yReal 

    var property position = game.at(25, 25)
    method image() = "personaje.png" 
    
    var vx = 0.0 
    var vy = 0.0

    method vx() = vx
    method vy() = vy

    var yendoDerecha = false
    var yendoIzquierda = false
    
    const gravedad = -0.15       
    const aceleracionSuelo = 0.24
    const aceleracionAire = 0.12
    const friccionSuelo = 0.85     
    const friccionAire = 0.95     
    const impulsoSalto = 1.5     
    const velMaximaX = 0.6       
    const nivelSuelo = 1         

    var estaApoyado = false 

    method gravedad() = gravedad
    method impulsoSalto() = impulsoSalto
    method nivelSuelo() = nivelSuelo
    method velMaximaX() = velMaximaX 

    method avanzarDerecha() { yendoDerecha = true }
    method frenarDerecha()   { yendoDerecha = false }

    method avanzarIzquierda() { yendoIzquierda = true }
    method frenarIzquierda()   { yendoIzquierda = false }

    method estaEnElSuelo() = yReal <= nivelSuelo or estaApoyado

    method actualizarFisica() {
        estaApoyado = false // Se reinicia en cada tick; la colisión lo volverá a activar si sigue sobre el bloque
        
        const accelActual = if (self.estaEnElSuelo()) aceleracionSuelo else aceleracionAire 
        
        // Movimiento lateral
        if (yendoDerecha) {
            vx = vx + accelActual
        }
        if (yendoIzquierda) {
            vx = vx - accelActual
        }

        // Caida
        if (!self.estaEnElSuelo()) {
            vy = vy + gravedad
        }

        // Friccion de suelo/aire
        if (self.estaEnElSuelo()) {
            vx = vx * friccionSuelo
        } else {
            vx = vx * friccionAire
        }   
        
        vx = vx.min(velMaximaX).max(velMaximaX * -1)
        
        xReal = xReal + vx
        
        // limite izquierdo
        if (xReal < 0) {
            xReal = 0
            vx = 0 
        }
        
        // limite derecho
        const limiteDerecho = game.width() - 3
        if (xReal > limiteDerecho) {
            xReal = limiteDerecho
            vx = 0 
        }
        
        yReal = yReal + vy
        
        // Colision con suelo original
        if (yReal < nivelSuelo) {
            yReal = nivelSuelo
            vy = 0 
        }
        
        position = game.at(xReal.truncate(0), yReal.truncate(0))
    }

    method saltar() {
        if (self.estaEnElSuelo()) {
            vy = impulsoSalto
        }
    }

    method centrar() { 
        xReal = 5.0
        yReal = 5.0
        vx = 0.0
        vy = 0.0
    }

    method irA(nuevaPosicion) {
        xReal = nuevaPosicion.x()
        yReal = nuevaPosicion.y()
        vx = 0
        vy = 0
    }

    method chocarPared(){
        vx = vx * -0.5 
    }


    // se llama cuando me choco con una estructura en su parte de la derecha, estaria con v negativa
    method rebotarHaciaDerecha() {
        xReal = xReal + 1.0 // me voy 1 a la derecha 
        vx = 0.0            // se resetea la vx
        position = game.at(xReal.truncate(0), yReal.truncate(0))  // actualizo la posicion actual del pj      
    }

    // lo mismo que rebotarHaciaDerecha pero en izquierda
    method rebotarHaciaIzquierda() {
        xReal = xReal - 1.0 
        vx = 0.0
        position = game.at(xReal.truncate(0), yReal.truncate(0))
    }


    // se llama cuando caemos sobre una estructura
    method apoyarseEn(nuevaY) {
        yReal = nuevaY - gravedad // se compensa la gravedad del proximo tick para mantener todo estable
        vy = 0.0  // se resetea la vy
        estaApoyado = true  // esto se hace para que se pueda saltar devuelta
        position = game.at(xReal.truncate(0), yReal.truncate(0))  // actaulizo la posicion actual del pj
    }

    // se llama cuando golpeo la cabeza con un techo
    method rebotarTecho() {
        vy = -0.5 // lo empuja ligeramente hacia abajo al chocar la cabeza
    }


    // llave
    var tieneLlave = false

    method tieneLlave() = tieneLlave
    method agarrarLlave() { tieneLlave = true }



}

