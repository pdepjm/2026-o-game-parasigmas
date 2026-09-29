import personaje.*
import wollok.game.*

class Objeto { 
    var property position

    method chocar(unPersonaje) {
        game.removeVisual(self)
    }
}

class Llave inherits Objeto { 
    method image() = "llave.png" 

    override method chocar(unPersonaje) {
        unPersonaje.agarrarLlave()
        super(unPersonaje)
    }
}