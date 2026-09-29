import wollok.game.*

class Estructura {
    var property position

    method chocar(personaje) {
        // calculamos donde estaba el personaje antes de chocar
        const yAnterior = personaje.yReal() - personaje.vy()
        
        // veo de donde salio el choque con la estructura y dependiendo eso se hace una funcion
        // no funca el else if

        // 1) techo: cae desde arriba hacia la estructura
        // velocidad en y es negativa y la altura anterior era mas alta
        if (personaje.vy() < 0 && yAnterior >= self.position().y() + 1.0) {
            personaje.apoyarseEn(self.position().y() + 1.0)
            
        } else {
            // 2) base: salta y choca la estructura por abajo
            // velocidad en y era mas alta y la altura anterior era mas chica 
            if (personaje.vy() > 0 && yAnterior <= self.position().y()) {
                personaje.rebotarTecho()
                
            } else {
                // 3) lado izquierdo: viene corriendo hacia la derecha
                // la velocidad x era mayor a 0, va a favor del eje x, es v positivo
                if (personaje.vx() > 0) {
                    personaje.rebotarHaciaIzquierda()
                    
                } else {
                    // 4) lado derecho: Viene corriendo hacia la izquierda
                    // la velocidad x era menor a 0, va en contra del eje x, es v negativo
                    if (personaje.vx() < 0) {
                        personaje.rebotarHaciaDerecha()
                    }
                }
            }
        }
    }
}

class Muro inherits Estructura {
    var property image = "muro.png" // algunas estructuras van a tener la misma imagen pero varian coordenadas
}

class Piso {
    var property position

    method chocar(personaje){
        // el piso del juego se basa en un sprite nomas, se agrega el sprite y se sube la altura inicial del nivel 
    }
}

class Pasto inherits Piso {
    method image() = "pisoPasto.png"
}