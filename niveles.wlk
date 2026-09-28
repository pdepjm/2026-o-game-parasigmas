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
        personaje.irA(posicionSpawn) // importar el objeto del jugador
        game.addVisual(personaje)
    }

    method configurarMeta() {
        meta.position(posicionMeta) // lo mismo para la meta
        game.addVisual(meta)
        //agregar colisión con la meta
        game.onCollideDo(meta, { elementoQueChocaMeta => self.victoria() }) // esto si solo hay un jugador, si hay más de personaje que pueda moverse y tocar la meta, habría que cambiarlo
    }

    method dibujarEntorno() {
        // Dibujar el entorno del nivel; plataformas, obstáculos, etc.
    }

    method victoria() {
        game.clear()
        game.addVisual(cartelVictoria)
        // acá podría ir logica para reiniciar el nivel o pasar al siguiente
    }
}

object meta {
    var property position = game.at(0,0)
    method image() = "meta.png" 
    method chocar(personaje){
        game.clear()
        game.addVisual(cartelVictoria)
}
}
object cartelVictoria {
    var property position = game.at(20,10)
    method image() = "victoria.png"
}