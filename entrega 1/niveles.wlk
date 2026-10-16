import wollok.game.*

class Nivel {
    const jugador
    const meta
    const cartelVictoria
    const posicionSpawn
    const posicionMeta

    method iniciarNivel() {
        game.clear()
        self.configurarSpawn()
        self.configurarMeta()
        self.dibujarEntorno()
    }

    method configurarSpawn() {
        jugador.position(posicionSpawn)
        game.addVisual(jugador)
    }

    method configurarMeta() {
        meta.position(posicionMeta)
        game.addVisual(meta)

        game.whenCollideDo(meta, { elementoQueChocaMeta => self.victoria() })
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