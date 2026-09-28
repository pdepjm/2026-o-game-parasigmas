import wollok.game.*

object personaje {
    
    var xReal = 5.0
    var yReal = 5.0 

    var property position = game.at(25, 25)
    method image() = "personaje.png" 
    
    var vx = 0.0 
    var vy = 0.0

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

    method velMaximaX() = velMaximaX 
    method avanzarDerecha() { yendoDerecha = true }
    method frenarDerecha()   { yendoDerecha = false }

    method avanzarIzquierda() { yendoIzquierda = true }
    method frenarIzquierda()   { yendoIzquierda = false }

    method actualizarFisica() {
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
            vx = 0 // frena el impulso contra la pared
        }
        
        // limite derecho
        // al restarle 3 celdas (game.width() - 3) lo movemos mas a la izquierda porq sin esto se pasa
        const limiteDerecho = game.width() - 3
        
        if (xReal > limiteDerecho) {
            xReal = limiteDerecho
            vx = 0 // frena el impulso contra la pared
        }
        

        yReal = yReal + vy
        
        // Colision con suelo original
        if (yReal < nivelSuelo) {
            yReal = nivelSuelo
            vy = 0 
        }
        
        position = game.at(xReal.truncate(0), yReal.truncate(0))
    }

    method estaEnElSuelo() = yReal <= nivelSuelo

    method saltar() {
        if (self.estaEnElSuelo()) {
            vy = impulsoSalto
        }
    }

    method centrar() { 
        xReal = 75.0
        yReal = 50.0
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
    method rebotarHaciaDerecha() {
       xReal = xReal + 1.0 
        vx = 0.0            
        position = game.at(xReal.truncate(0), yReal.truncate(0))           
    }
    method rebotarHaciaIzquierda() {
        xReal = xReal - 1.0 
        vx = 0.0
        position = game.at(xReal.truncate(0), yReal.truncate(0))
    }

    method chocarPiso(){
        vy = 0
    }
}