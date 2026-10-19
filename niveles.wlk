import wollok.game.*
import personaje.*
import obstaculos.*
import motorfisico.*
import paredesPiso.*
import objetos.*
import menu.*

class Nivel { 
    const posicionSpawn 
    const posicionMeta
    const property siguienteNivel = null
    const property llavesNecesarias = 1
    var desbloqueado = false

    method desbloquearNivel () { desbloqueado = true}
    method estaDesbloqueado() = desbloqueado

    method iniciarNivel() {
        game.clear()
        self.configurarSpawn()
        self.configurarMeta()
        self.dibujarEntorno()
    }

    method configurarSpawn() {
        personaje.irA(posicionSpawn) 
        personaje.reiniciarLlaves()
        game.addVisual(personaje)
    }

    method configurarMeta() {
        meta.position(posicionMeta) 
        meta.nivelActual(self)
        meta.llavesNecesarias(llavesNecesarias)
        game.addVisual(meta)
    }

    method dibujarEntorno() {
        // Dibujar el entorno del nivel; plataformas, obstáculos, etc.
    }

    method victoria() {
        if (siguienteNivel != null) {
                siguienteNivel.desbloquearNivel()
            }
        menuVictoria.abrir(self)
    }

    method irAlSiguiente() {
        if (siguienteNivel != null) {
            siguienteNivel.iniciarNivel()
            menu.activarJuego()
        } else {
            menu.mostrar()
        }
    }
}

object meta { 
    var property position = game.at(0,0) 
    var property nivelActual = null
    var property llavesNecesarias = 1

    method image() = "meta.png" 

    method chocar(unPersonaje){ 
        if (unPersonaje.cantidadLlaves() >= llavesNecesarias) { // para ganar tiene que tener la llave
            nivelActual.victoria()
        }
    } 
}

object nivel1 inherits Nivel(posicionSpawn = game.at(5, 5), posicionMeta = game.at(45, 1), siguienteNivel = nivel2) {

    override method estaDesbloqueado() = true // El primer nivel siempre está desbloqueado
    
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

object nivel2 inherits Nivel(posicionSpawn = game.at(2, 5), posicionMeta = game.at(40, 10), llavesNecesarias = 2) {
    
    override method dibujarEntorno() {
        const pasto = new Pasto(position = game.at(0, 0))
        game.addVisual(pasto)
        motorFisico.registrar(pasto)

        const llave1 = new Llave(position = game.at(15, 5))
        const llave2 = new Llave(position = game.at(30, 8))
        game.addVisual(llave1)
        game.addVisual(llave2)
    }
}