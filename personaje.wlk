import wollok.game.*

object personaje {
    
    
    var xReal = 25.0
    var yReal = 25.0 

    var property position = game.at(25, 25) 
    method image() = "personaje.png" 
    
    var vx = 0.0 
    var vy = 0.0

    
    const gravedad = -0.75       
    const aceleracionSuelo = 5.0
    const friccionSuelo = 0.9     // Es porcentaje, se mantiene igual
    const friccionAire = 0.95     // Es porcentaje, se mantiene igual
    const impulsoSalto = 7.5     
    const velMaximaX = 9.0       
    const nivelSuelo = 0         

    method actualizarFisica() {
        
        if (!self.estaEnElSuelo()) {
            vy = vy + gravedad
        }
        
        if (self.estaEnElSuelo()) {
            vx = vx * friccionSuelo
        } else {
            vx = vx * friccionAire
        }
        
        vx = vx.min(velMaximaX).max(velMaximaX * -1)
        
        xReal = xReal + vx
        yReal = yReal + vy
        
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
    
    method moverDerecha() { vx = vx + aceleracionSuelo }
    method moverIzquierda() { vx = vx - aceleracionSuelo }

    method centrar() { 
        // Coordenadas escaladas por 5 (antes 15 y 10)
        xReal = 75.0
        yReal = 50.0
        vx = 0.0
        vy = 0.0
    }
}