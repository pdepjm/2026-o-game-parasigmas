import wollok.game.*

object personaje {
    
    
    var xReal = 25.0
    var yReal = 25.0 

    var property position = game.at(25, 25) 
    method image() = "personaje.png" 
    
    var vx = 0.0 
    var vy = 0.0

    var yendoDerecha = false
    var yendoIzquierda = false
    
    const gravedad = -0.75       
    const aceleracionSuelo = 1.2
    const aceleracionAire = 0.6
    const friccionSuelo = 0.85     // Es porcentaje, se mantiene igual
    const friccionAire = 0.95     // Es porcentaje, se mantiene igual
    const impulsoSalto = 7.5     
    const velMaximaX = 9.0       
    const nivelSuelo = 0         

    method avanzarDerecha() { yendoDerecha = true }
    method frenarDerecha()   { yendoDerecha = false }

    method avanzarIzquierda() { yendoIzquierda = true }
    method frenarIzquierda()   { yendoIzquierda = false }

    method actualizarFisica() {
        const accelActual = if (self.estaEnElSuelo()) aceleracionSuelo else aceleracionAire // Distintas para controlar mejor el personaje
        
        //Movimiento lateral
        if (yendoDerecha) {
            vx = vx + accelActual
        }
        if (yendoIzquierda) {
            vx = vx - accelActual
        }

        //Caida
        if (!self.estaEnElSuelo()) {
            vy = vy + gravedad
        }

        //Friccion de suelo/aire
        if (self.estaEnElSuelo()) {
            vx = vx * friccionSuelo
        } else {
            vx = vx * friccionAire
        }   
        
        vx = vx.min(velMaximaX).max(velMaximaX * -1)
        
        //Para actualizar posicion
        xReal = xReal + vx
        yReal = yReal + vy
        
        //Colision con suelo
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
        // Coordenadas escaladas por 5 (antes 15 y 10)
        xReal = 75.0
        yReal = 50.0
        vx = 0.0
        vy = 0.0
    }

    method chocarPared(){
        vx = vx * -0.5 // hace que "rebote" con la pared
    }

    method chocarPiso(){
        vy = 0
    }

}