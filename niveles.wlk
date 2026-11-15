import wollok.game.*
import personaje.*
import obstaculos.*
import motorfisico.*
import paredesPiso.*
import objetos.*
import menu.*


class ImagenNivel {
    const property position
    const property image
}

class Nivel { 
    const posicionSpawn 
    const posicionMeta
    const property siguienteNivel = sinSiguienteNivel
    const property llavesNecesarias = 1
    var desbloqueado = false
    const llaves = []
    method existe() = true

    method desbloquearNivel () { desbloqueado = true}
    method estaDesbloqueado() = desbloqueado
    

    method iniciarNivel() {
        game.clear()
        motorFisico.limpiarBloques()
        llaves.clear()        
        personaje.detener()
        self.dibujarEntorno() // tiene que ir primero porq si no, el pj esta atras del fondo
        self.configurarSpawn()
        self.configurarMeta()
    }

    method dibujarPisoBase() {
        self.agregarBloque(new Pasto(position = game.at(0, 0)))
        self.agregarBloque(new Pasto(position = game.at(30, 0)))
    }

    method configurarSpawn() {
        personaje.posicionInicial(posicionSpawn)
        personaje.irA(posicionSpawn) 
        personaje.reiniciarLlaves()
        game.addVisual(personaje)
    }

    method configurarMeta() {
        meta.position(posicionMeta) 
        meta.nivelActual(self)
        meta.llavesNecesarias(llavesNecesarias)
        game.addVisual(meta)
        motorFisico.registrarInteractuable(meta)
    }

    method agregarBloque(unBloque) {
        game.addVisual(unBloque)
        motorFisico.registrar(unBloque)
    }

    method agregarPeligro(unPeligro) {
        game.addVisual(unPeligro)
        motorFisico.registrarInteractuable(unPeligro)
    }

    method agregarLlaveEn(pos) {
        const llave = new Llave(position = pos)
        llaves.add(llave)
        game.addVisual(llave)
        motorFisico.registrarInteractuable(llave)
    }

    method agregarLlavePlateadaEn(pos) {
        const llave = new LlavePlateada(position = pos)
        llaves.add(llave)
        game.addVisual(llave)
        motorFisico.registrarInteractuable(llave)
    }

    method reponerLlaves() {
        llaves.forEach({ llave => if (!game.hasVisual(llave)) { // si el personaje no la agarró
                game.addVisual(llave)
                motorFisico.registrarInteractuable(llave)
            }
        })
    }

    // Al llegar a la meta SIEMPRE se muestra el menu de victoria:
    // "Siguiente nivel" (si existe) y "Menu".
    method completarNivel() {
        self.victoria()
    }

    method dibujarEntorno() {}

    method victoria() {
        siguienteNivel.desbloquearNivel()
        menuVictoria.abrir(self)
    }

    method irAlSiguiente() {
       siguienteNivel.iniciarComoSiguiente()
    }

    method iniciarComoSiguiente() {
        self.iniciarNivel()
        menu.activarJuego()
    }
}

object meta { 
    var property position = game.at(0,0) 
    var property nivelActual = null
    var property llavesNecesarias = 1

    method image() = "meta.png" 
    method ancho() = 3
    method alto()  = 4

    method chocar(unPersonaje){ 
        if (unPersonaje.cantidadLlaves() >= llavesNecesarias) { // para ganar tiene que tener la llave
            nivelActual.victoria()
        }
    } 
}

object nivel1 inherits Nivel(posicionSpawn = game.at(5, 5), posicionMeta = game.at(45, 1), siguienteNivel = nivel2) {

    override method estaDesbloqueado() = true // El primer nivel siempre está desbloqueado
    
    override method dibujarEntorno() {
        const fondo  = new ImagenNivel(position = game.at(0, 0),  image = "fondoNivel1.jpg")
        game.addVisual(fondo)

        self.dibujarPisoBase() // se tiene que poner adentro de entorno, porq sino se superponen los pisos y los fondos

        // Todo lo que estaba en juego.wpgm ahora esta aca
        self.agregarPeligro(new Pinche(position = game.at(10, 1)))
        self.agregarPeligro(new Sierra(position = game.at(20, 5)))


        self.agregarBloque(new Muro(position = game.at(30, 1)))

        self.agregarBloque(new Plataforma(position = game.at(35, 12)))
        self.agregarBloque(new Plataforma(position = game.at(25, 15)))

        self.agregarLlaveEn(game.at(25, 16))
    }
}

// NIVEL 2: escalera de plataformas hasta la bandera
object nivel2 inherits Nivel(posicionSpawn = game.at(2, 5), posicionMeta = game.at(40, 10), llavesNecesarias = 2, siguienteNivel = nivel3) {
    
    override method dibujarEntorno() {
        const fondo  = new ImagenNivel(position = game.at(0, 0),  image = "fondoNivel2.jpg")
        game.addVisual(fondo)

        self.dibujarPisoBase()

        self.agregarPeligro(new Pinche(position = game.at(20, 1)))
        self.agregarPeligro(new Pinche(position = game.at(32, 1)))
        self.agregarPeligro(new Pinche(position = game.at(44, 1)))

        // escalera hacia la bandera (la ultima plataforma queda justo debajo de la meta)
        self.agregarBloque(new Plataforma(position = game.at(8, 4)))
        self.agregarBloque(new Plataforma(position = game.at(16, 7)))
        self.agregarBloque(new Plataforma(position = game.at(24, 8)))
        self.agregarBloque(new Plataforma(position = game.at(32, 9)))
        self.agregarBloque(new Plataforma(position = game.at(39, 9)))

        // llaves sobre las plataformas (ahora SI se ven y se pueden agarrar)
        self.agregarLlavePlateadaEn(game.at(16, 8))
        self.agregarLlavePlateadaEn(game.at(32, 10))
    }
}

//agrega Tahiel para ver si funcionan los nuevos obstaculos
object nivel3 inherits Nivel(posicionSpawn = game.at(2, 5), posicionMeta = game.at(45, 1)) {

    override method dibujarEntorno() {
        const fondo  = new ImagenNivel(position = game.at(0, 0),  image = "fondoNivel3b.png")
        game.addVisual(fondo)
        
        self.dibujarPisoBase()

        // Zona de barro (y = 0: se dibuja SOBRE el pasto, al ras del piso)
        self.agregarBloque(new BloqueBarro(position = game.at(7, 0)))
        self.agregarBloque(new BloqueBarro(position = game.at(11, 0)))

        self.agregarPeligro(new Pinche(position = game.at(17, 1)))

        self.agregarBloque(new BloqueHielo(position = game.at(22, 0)))
        self.agregarBloque(new BloqueHielo(position = game.at(26, 0)))

        const prensa = new BloqueAplastante(position = game.at(30, 8), yArriba = 8)
        game.addVisual(prensa)
        prensa.activar()

        self.agregarBloque(new Plataforma(position = game.at(14, 4)))
        self.agregarBloque(new Plataforma(position = game.at(19, 7)))

        self.agregarBloque(new PisoElevado(position = game.at(25, 11)))

        self.agregarBloque(new Muro(position = game.at(46, 11)))

        const lanzador = new LanzadorDeSierras(position = game.at(26, 12))
        game.addVisual(lanzador)
        lanzador.activar()

        self.agregarLlaveEn(game.at(40, 12))
    }
}

// nivel vacio
object sinSiguienteNivel {
    method existe() = false
    method desbloquearNivel() {}
    method iniciarComoSiguiente() {
        menu.mostrar() // si no hay siguiente nivel, vuelve al menu
    }
}