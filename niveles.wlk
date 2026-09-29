import wollok.game.*
import personaje.*

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