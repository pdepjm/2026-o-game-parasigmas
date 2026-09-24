import wollok.game.*

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
        jugador.position(posicionSpawn) // importar el objeto del jugador
        game.addVisual(jugador)
    }

    method configurarMeta() {
        meta.position(posicionMeta) // lo mismo para la meta
        game.addVisual(meta)
        // agregar colisión con la meta
        game.onCollideDo({ elementoQueChocaMeta => self.victoria() }) // esto si solo hay un jugador, si hay más de personaje que pueda moverse y tocar la meta, habría que cambiarlo
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