import wollok.game.*

class BloqueSolido {
    var property position

    method xIzquierdo() = position.x()
    method xDerecho()   = position.x() + 1
    method yPiso()      = position.y()
    method yTecho()     = position.y() + 1

    method chocar(personaje) {}
    
    method aplicarEfectoSuperficie(personaje) {
        personaje.pisarPasto()
    }
}

class Muro inherits BloqueSolido {
    var property image = "muro.png"
    override method xDerecho() = position.x() + 4
    override method yTecho()   = position.y() + 6
}

class Plataforma inherits BloqueSolido {
    method image() = "plataformaPiedra.png"
    override method xDerecho() = position.x() + 3
    override method yTecho()   = position.y() + 1
}

class PisoElevado inherits BloqueSolido { //para las plataformas
    method image() = "pisoPastoElevado.png"
    override method xDerecho() = position.x() + 22
    override method yTecho()   = position.y() + 1
}

class Techo inherits BloqueSolido {
    method image() = "techo.png"
    override method xDerecho() = position.x() + 35
    override method yTecho()   = position.y() + 1
}

class BloqueHielo inherits BloqueSolido {
    method image() = "pisoDeHielo.png"
    override method xDerecho() = position.x() + 4
    override method yTecho()   = position.y() + 1

    override method aplicarEfectoSuperficie(personaje) {
        personaje.pisarHielo()
    }
}

class BloqueBarro inherits BloqueSolido {
    method image() = "pisoDeBarro.png"
    override method xDerecho() = position.x() + 4
    override method yTecho()   = position.y() + 1

    override method aplicarEfectoSuperficie(personaje) {
        personaje.pisarBarro()
    }
}

class Piso inherits BloqueSolido {
    override method xDerecho() = position.x() + 30
    override method yTecho()   = position.y() + 1
}

class Pasto inherits Piso {
    method image() = "pisoPasto.png"
    
    override method aplicarEfectoSuperficie(personaje) {
        personaje.pisarPasto()
    }
}