import wollok.game.*
import paredesPiso.*
import motorfisico.*

class Obstaculo {
    var property position 
    method ancho() = 2
    method alto()  = 2

    method chocar(unPersonaje) {
        unPersonaje.morir()
    }
}

class Pinche inherits Obstaculo {
    method image() = "pinchos.png"
    override method ancho() = 5
    override method alto()  = 2
}

class Sierra inherits Obstaculo {
    method image() = "sierra.gif"
    override method ancho() = 3
    override method alto()  = 3
}

class Hielo inherits BloqueHielo {}
class Barro inherits BloqueBarro {}

//OBSTÁCULO NUEVO 1 BLOQUE APLASTANTE
class BloqueAplastante inherits Obstaculo {
    const yArriba = 6      // altura con el bloque levantado
    const yAbajo  = 1      // altura con el bloque apoyado en el piso
    var bajando = false
    var espera  = 8        // ticks de desfase inicial: usar distinto en cada bloque

    method image() = "bloqueAplastante.png"
    override method ancho() = 8
    override method alto()  = 3

    method activar() {
        motorFisico.registrarInteractuable(self)
        game.onTick(100, "aplastante_" + self.identity().toString(), { self.avanzar() })
    }

    method avanzar() {
        if (espera > 0) {
            espera = espera - 1
        } else if (bajando) {
            position = game.at(position.x(), (position.y() - 2).max(yAbajo))   // cae rapido
            if (position.y() == yAbajo) {
                bajando = false
                espera = 6        // se queda abajo 0.6 s
            }
        } else {
            position = game.at(position.x(), (position.y() + 1).min(yArriba))  // sube lento
            if (position.y() == yArriba) {
                bajando = true
                espera = 12       // se queda arriba 1.2 s
            }
        }
    }
}

//OBSTÁCULO LANZADOR DE SIERRAs
class LanzadorDeSierras inherits Obstaculo {
    const alcance = 13                                   // celdas que recorre la sierra
    const proyectil = new ProyectilSierra(position = game.at(0, 0))
    var avance = 0
    var espera = 10                                      // ticks hasta el proximo disparo

    method image() = "lanzadorCanon.png"
    override method ancho() = 3
    override method alto()  = 3
    override method chocar(unPersonaje) {}

    method activar() {
        motorFisico.registrarInteractuable(proyectil)
        game.onTick(70, "lanzador_" + self.identity().toString(), { self.avanzar() })
    }

    method avanzar() {
        if (espera > 0) {
            espera = espera - 1
        } else if (avance <= alcance) {
            proyectil.position(game.at(position.x() + 3 + avance, position.y()))
            if (!game.hasVisual(proyectil)) { game.addVisual(proyectil) }
            avance = avance + 1
        } else {
            if (game.hasVisual(proyectil)) { game.removeVisual(proyectil) }
            avance = 0
            espera = 20
        }
    }
}

class ProyectilSierra inherits Obstaculo {
    method image() = "proyectilSierra.gif"
    override method ancho() = 3
    override method alto()  = 3
}