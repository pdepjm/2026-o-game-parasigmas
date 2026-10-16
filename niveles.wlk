import wollok.game.*
import personaje.*
import obstaculos.*
import motorfisico.*
import paredesPiso.*
import objetos.*

class Nivel { 
    const posicionSpawn 
    const posicionMeta

    method iniciarNivel() {
        game.clear()
        self.configurarSpawn()
        self.configurarMeta()
        self.dibujarEntorno()
    }

    method configurarSpawn() {
        personaje.irA(posicionSpawn) 
        game.addVisual(personaje)
    }

    method configurarMeta() {
        meta.position(posicionMeta) 
        game.addVisual(meta)
    }

    method dibujarEntorno() {
        // Dibujar el entorno del nivel; plataformas, obstáculos, etc.
    }

    method victoria() {
        game.clear()
        game.addVisual(cartelVictoria)
    }
}

object meta { 
    var property position = game.at(0,0) 
    method image() = "meta.png" 

    method chocar(unPersonaje){ 
        if (unPersonaje.tieneLlave()) { // para ganar tiene que tener la llave
            game.clear() 
            game.addVisual(cartelVictoria) 
        }
    } 
}

object cartelVictoria { 
    var property position = game.at(20,10) 
    method image() = "victoria.png" 
}

object nivel1 inherits Nivel(posicionSpawn = game.at(5, 5), posicionMeta = game.at(45, 1)) {
    
    override method dibujarEntorno() {
        // Todo lo que estaba en juego.wpgm ahora esta aca
        const pinche1 = new Pinche(position = game.at(10, 1))
        const pinche2 = new Pinche(position = game.at(11, 1))
        const sierra1 = new Sierra(position = game.at(20, 5))

        game.addVisual(pinche1)
        game.addVisual(pinche2)
        game.addVisual(sierra1)

        const pasto = new Pasto(position = game.at(0,0))
        const pasto2 = new Pasto(position = game.at(30,0))
        game.addVisual(pasto)
        game.addVisual(pasto2)
        motorFisico.registrar(pasto)
        motorFisico.registrar(pasto2)

        const muroPrueba = new Muro(position = game.at(30, 1))
        game.addVisual(muroPrueba)
        motorFisico.registrar(muroPrueba)

        const plataformaPrueba = new Plataforma(position = game.at(35, 12))
        game.addVisual(plataformaPrueba)
        motorFisico.registrar(plataformaPrueba)

        const plataformaPrueba2 = new Plataforma(position = game.at(25, 15))
        game.addVisual(plataformaPrueba2)
        motorFisico.registrar(plataformaPrueba2)

        const llave = new Llave(position = game.at(25, 16))
        game.addVisual(llave)
    }
}