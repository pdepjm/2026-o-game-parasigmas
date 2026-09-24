import wollok.game.*

class Pared {

    var property position 

    method chocar(personaje) {
        personaje.chocarPared()
    }

}

class Limite inherits Pared
{
    method image() = "paredInvisible.png"
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









