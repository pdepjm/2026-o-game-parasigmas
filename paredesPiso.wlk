import wollok.game.*

class BloqueSolido {
    var property position

    method xIzquierdo() = position.x()
    method xDerecho()   = position.x() + 1
    method yPiso()      = position.y()
    method yTecho()     = position.y() + 1

    method chocar(personaje) {}
    
    method superficie() = pasto
    method aplicarEfectoSuperficie(personaje) {
        personaje.pisar(self.superficie())
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

    override method superficie() = hielo
}

class BloqueBarro inherits BloqueSolido {
    method image() = "pisoDeBarro.png"
    override method xDerecho() = position.x() + 4
    override method yTecho()   = position.y() + 1

    override method superficie() = barro
}

class Piso inherits BloqueSolido {
    override method xDerecho() = position.x() + 30
    override method yTecho()   = position.y() + 1
}

class Pasto inherits Piso {
    method image() = "pisoPasto.png"
}

object pasto {
    method esHielo() = false
    method friccion() = 0.85
    method aceleracion() = 0.24
    method velMaximaX() = 0.6
}
object hielo {
    method esHielo() = true
    method friccion() = 0.98
    method aceleracion() = 0.08
    method velMaximaX() = 0.65
}
object barro {
    method esHielo() = false
    method friccion() = 0.40
    method aceleracion() = 0.08
    method velMaximaX() = 0.20
}