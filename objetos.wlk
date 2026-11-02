import personaje.*
import wollok.game.*

class Objeto { 
    var property position
    method ancho() = 2 //para que el personaje se pueda agarrar
    method alto()  = 2

    method chocar(unPersonaje) {
        if (game.hasVisual(self)) {
            game.removeVisual(self)
        }
    }
}

class Llave inherits Objeto { 
    method image() = "llave.png" 

    override method chocar(unPersonaje) {
        unPersonaje.agarrarLlave() // Suma 1 al contador numérico del personaje
        super(unPersonaje)
    }
}

class LlavePlateada inherits Llave {
    override method image() = "llavePlata.png"
}