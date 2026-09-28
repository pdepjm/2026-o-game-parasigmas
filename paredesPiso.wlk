import wollok.game.*

class Pared {
    var property position
}

class ParedIzquierda inherits Pared {
    method chocar(personaje) {
        personaje.rebotarHaciaDerecha()
    }
}

class ParedDerecha inherits Pared {
    method chocar(personaje) {
        personaje.rebotarHaciaIzquierda()
    }
}

object creadorDeHitboxes {
    method crearParedDerecha(xInicio, xFin, y) {
        (xInicio..xFin).forEach({ x => // el .. genera una lista de numeros enteros entre xInicio y xFin, incluyendolos, de forma que la pared tenga un grosor mayor a una casilla
            game.addVisual(new ParedDerecha(position = game.at(x, y)))
        })
    }
    method crearParedIzquierda(xInicio, xFin, y) {
        (xInicio..xFin).forEach({ x => 
            game.addVisual(new ParedIzquierda(position = game.at(x, y)))
        })
    }
}

class Piso {
    var property position

    method chocar(personaje){
        personaje.chocarPiso()
    }
}

class Pasto inherits Piso
{
    method image() = "pisoPasto.png"
}


object muroPrueba {
    var property position = game.at(150, 5)
    
    method image() = "muro3.png" 

    method chocar(personaje) {
        personaje.rebotarHaciaIzquierda()
    }
}





