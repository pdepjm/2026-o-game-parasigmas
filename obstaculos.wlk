import wollok.game.*

class Obstaculo
{
    var property position 

    method chocar(unPersonaje)//cuando toca con un obstaculo lo manda al prinicipio
        {
            unPersonaje.centrar()
        }
}

class Pinche inherits Obstaculo
{
    method image() = "pinchos.png"
}

class Sierra inherits Obstaculo
{
    method image() = "sierra.png"
}