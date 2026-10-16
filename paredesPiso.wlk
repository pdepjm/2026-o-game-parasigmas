import wollok.game.*

class BloqueSolido {
    var property position

    //valores default de un bloque 1x1, si el sprite es mas grande se hace override
    method xIzquierdo() = position.x()
    method xDerecho()   = position.x() + 1
    method yPiso()      = position.y()
    method yTecho()     = position.y() + 1
}

class Muro inherits BloqueSolido {
    var property image = "muro.png"
    override method xDerecho() = position.x() + 3
    override method yTecho() = position.y() + 6
}

class Plataforma inherits BloqueSolido {
    method image() = "plataforma.png"
    override method xDerecho() = position.x() + 3
}

class Piso inherits BloqueSolido {
}

class Pasto inherits Piso {
    method image() = "pisoPasto.png"
}