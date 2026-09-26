import wollok.game.*

class Limite {

    var property position

}

class LimiteIzquierdo inherits Limite{

    method chocar(personaje) {
        personaje.rebotarHaciaDerecha()
    }
}

class LimiteDerecho inherits Limite{

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
    var property position = game.at(150, 0)
    
    method image() = "muro3.png" 

    method chocar(personaje) {
        personaje.rebotarHaciaIzquierda()
    }
}





