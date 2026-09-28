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
    var property position = game.at(30, 1)
    
    method image() = "muro3.png" 

    method chocar(personaje) {
        personaje.rebotarHaciaIzquierda()
    }
}





