import wollok.game.*
import personaje.*
import motorfisico.*
import controles.*
import niveles.*


class ImagenMenu {
    const property position
    const property image
}

// Una opcion del menu: se ve distinta si esta seleccionada y sabe que hacer al elegirla.
// `menuActual` es el menu al que pertenece (menu o menuVictoria): asi cada menu
// resalta SU opcion seleccionada y no la del otro.
// Para agregar una opcion nueva alcanza con sumarla a la lista `opciones` del menu.
class OpcionMenu {
    const property position
    const imagenNormal
    const imagenSeleccionada
    const accion
    const menuActual

    method image() = if (menuActual.opcionSeleccionada() == self) imagenSeleccionada else imagenNormal

    method ejecutar() { accion.apply() }
}

class OpcionNivel inherits OpcionMenu {
    const nivelAsociado

    override method image() {
        if (not nivelAsociado.estaDesbloqueado()) {
            return "btnCandado2.png"
        }
        return super()
    }

    override method ejecutar() {
        if (nivelAsociado.estaDesbloqueado()) {
            super()
            sonidosMenu.reproducir(sonidosMenu.seleccion())
        }
        else {
            game.sound("nivelBloqueado.mp3").play()
        }
    }
}
// Sonidos compartidos por los menus: el nombre tiene que ser EXACTO, con la extension
// (.mp3 / .ogg / .wav), igual que el archivo que esta en la carpeta de assets.
object sonidosMenu {
    const navegacion = "sonido menu1.mp3"
    const seleccion  = "sonido seleccion.mp3"

    method navegacion() = navegacion
    method seleccion()  = seleccion

    method reproducir(archivo) {
        game.sound(archivo).play()
    }
}

object menu {
    // Tablero de 50 x 30 celdas de 25 px = 1250 x 750 px
    const fondo  = new ImagenMenu(position = game.at(0, 0),  image = "menuFondo.png")
    const titulo = new ImagenMenu(position = game.at(9, 20), image = "menuTitulo.png") // 800 x 150
    const ayuda  = new ImagenMenu(position = game.at(9, 2),  image = "menuAyuda.png")  // 800 x 50

    const pantallaControles = new ImagenMenu(position = game.at(0, 0), image = "pantallaControles.png")

    // botones de 400 x 75 (16 x 3 celdas), centrados en x = 17
    const opciones = [
        new OpcionMenu(menuActual = self, position = game.at(17, 14), imagenNormal = "btnJugar.png",
                       imagenSeleccionada = "btnJugarSel.png", accion = { menuNiveles.mostrar() }),
        new OpcionMenu(menuActual = self, position = game.at(17, 10), imagenNormal = "btnControles.png",
                       imagenSeleccionada = "btnControlesSel.png", accion = { self.mostrarControles() }),
        new OpcionMenu(menuActual = self, position = game.at(17, 6), imagenNormal = "btnSalir.png",
                       imagenSeleccionada = "btnSalirSel.png", accion = { game.stop() })
    ]

    var indice = 0
    var nivelAJugar = null

    // getters (los usan las opciones y los tests)
    method opciones() = opciones
    method indiceSeleccionado() = indice
    method opcionSeleccionada() = opciones.get(indice)

    // ---------------- punto de entrada ----------------

    // Se llama desde el programa: muestra el menu y deja listo el nivel que arranca con JUGAR.
    method abrir(unNivel) {
        nivelAJugar = unNivel
        self.mostrar()
    }

    // ---------------- navegacion ----------------

    method subir() {
        indice = (indice - 1 + opciones.size()) % opciones.size()
        sonidosMenu.reproducir(sonidosMenu.navegacion())
    }

    method bajar() {
        indice = (indice + 1) % opciones.size()
        sonidosMenu.reproducir(sonidosMenu.navegacion())
    }

    method seleccionar() {
        self.opcionSeleccionada().ejecutar()
        sonidosMenu.reproducir(sonidosMenu.seleccion())
    }

    // ---------------- pantallas ----------------

    method mostrar() {
        game.clear() // borra visuales, teclas, ticks y colisiones de la pantalla anterior
        indice = 0

        game.addVisual(fondo)
        game.addVisual(titulo)
        opciones.forEach({ opcion => game.addVisual(opcion) })
        game.addVisual(ayuda)

        keyboard.up().onPressDo({ self.subir() })
        keyboard.w().onPressDo({ self.subir() })
        keyboard.down().onPressDo({ self.bajar() })
        keyboard.s().onPressDo({ self.bajar() })
        keyboard.enter().onPressDo({ self.seleccionar() })
    }

    method mostrarControles() {
        game.clear()
        game.addVisual(pantallaControles)
        keyboard.enter().onPressDo({ self.mostrar() })
    }

    // ---------------- empezar a jugar ----------------

    method jugar() {
        if (nivelAJugar == null) {
            self.error("Falta indicar el nivel: usar menu.abrir(unNivel) en lugar de menu.mostrar()")
        }
        self.jugarNivel(nivelAJugar)
    }

    // Arranca un nivel cualquiera y lo recuerda, asi reiniciarNivel() reinicia el que se esta jugando
    // (tambien lo usa menuVictoria para pasar al siguiente nivel).
    method jugarNivel(unNivel) {
        nivelAJugar = unNivel
        unNivel.iniciarNivel() // hace game.clear(), ubica personaje y meta, dibuja el entorno
        self.activarJuego()
    }

    // game.clear() se llevo puestas las teclas, las colisiones y el pulso de la fisica: se revive todo
    method activarJuego() {
        configuracionControles.configurar()
        keyboard.p().onPressDo({ menuPausa.alternarPausa() })
        game.onCollideDo(personaje, { elemento => elemento.chocar(personaje) })
        game.onTick(25, "bucleFisica", { motorFisico.actualizarFisica(personaje) })
    }

    method reiniciarNivel() {
        nivelAJugar.iniciarNivel()
        self.activarJuego()
    }
}

object menuVictoria {
    var nivelActual = null
    var indice = 0
    var opciones = []

    const fondo = new ImagenMenu(position = game.at(0, 0), image = "fondoVictoria.png")
    const cartel = new ImagenMenu(position = game.at(17, 14), image = "victoria.png") // 800 x 150
    
    method opcionSeleccionada() = opciones.get(indice)

    method abrir(unNivel) {
        nivelActual = unNivel 
        indice = 0
        opciones = []

        if (unNivel.siguienteNivel() != null) {
            opciones.add(new OpcionMenu(menuActual = self, position = game.at(17, 10), imagenNormal = "btnSiguiente.png",
                                        imagenSeleccionada = "btnSiguienteSel.png", accion = { unNivel.irAlSiguiente() }))
        }

        opciones.add(new OpcionMenu(menuActual = self, position = game.at(17, 5), imagenNormal = "btnMenu.png",
                                    imagenSeleccionada = "btnMenuSel.png", accion = { menu.mostrar() }))

        self.mostrar()
    }

    method subir() {
        indice = (indice - 1 + opciones.size()) % opciones.size()
        sonidosMenu.reproducir(sonidosMenu.navegacion())
    }

    method bajar() {
        indice = (indice + 1) % opciones.size()
        sonidosMenu.reproducir(sonidosMenu.navegacion())
    }

    method seleccionar() {
        self.opcionSeleccionada().ejecutar()
        sonidosMenu.reproducir(sonidosMenu.seleccion())
    }

    method mostrar() {
        game.clear()
        game.addVisual(fondo)
        game.addVisual(cartel)
        opciones.forEach({ opcion => game.addVisual(opcion) })

        keyboard.up().onPressDo({ self.subir() })
        keyboard.w().onPressDo({ self.subir() })
        keyboard.down().onPressDo({ self.bajar() })
        keyboard.s().onPressDo({ self.bajar() })
        keyboard.enter().onPressDo({ self.seleccionar() })
    }
}

object menuNiveles {
    var indice = 0

    const titulo = new ImagenMenu(position = game.at(10, 20), image = "seleccionarNivel.png")

    const fondo = new ImagenMenu(position = game.at(0, 0), image = "fondoMenuNivel.png")

    const opciones = [
        new OpcionNivel(menuActual = self, position = game.at(17, 14), imagenNormal = "btnNivel1.png",
                       imagenSeleccionada = "btnNivel1Sel.png", nivelAsociado = nivel1, accion = { nivel1.iniciarNivel(); menu.activarJuego() }
        ),

        new OpcionNivel(menuActual = self, position = game.at(17, 10), imagenNormal = "btnNivel2.png",
                       imagenSeleccionada = "btnNivel2Sel.png", nivelAsociado = nivel2, accion = { nivel2.iniciarNivel(); menu.activarJuego() }
        ),

        new OpcionNivel(menuActual = self, position = game.at(17, 6), imagenNormal = "btnNivel3.png",
                       imagenSeleccionada = "btnNivel3Sel.png", nivelAsociado = nivel3, accion = { nivel3.iniciarNivel(); menu.activarJuego() }
        ),

        new OpcionMenu(menuActual = self, position = game.at(17, 2), imagenNormal = "btnMenu.png",
                       imagenSeleccionada = "btnMenuSel.png", accion = { menu.mostrar() })
    ]

    method opcionSeleccionada() = opciones.get(indice)

    method mostrar() {
        indice = 0
        game.clear()
        game.addVisual(fondo)
        game.addVisual(titulo)
        opciones.forEach({ opcion => game.addVisual(opcion) })
        self.configurarControles()
    }

    method subir() { 
        indice = (indice - 1 + opciones.size()) % opciones.size()
        sonidosMenu.reproducir(sonidosMenu.navegacion())
    }

    method bajar() { indice = (indice + 1) % opciones.size() 
        sonidosMenu.reproducir(sonidosMenu.navegacion())
    }

    method seleccionar() { self.opcionSeleccionada().ejecutar() }

    method configurarControles() {
        keyboard.up().onPressDo({ self.subir() })
        keyboard.w().onPressDo({ self.subir() })
        keyboard.down().onPressDo({ self.bajar() })
        keyboard.s().onPressDo({ self.bajar() })
        keyboard.enter().onPressDo({ self.seleccionar() })
    }
}

object menuPausa {
    var indice = 0
    var enPausa = false

    const titulo = new ImagenMenu(position = game.at(9, 20), image = "pausa.jpg")

    const opciones = [
        new OpcionMenu(
            menuActual = self,
            position = game.at(17, 14),
            imagenNormal = "btnReanudar.png",
            imagenSeleccionada = "btnReanudarSel.png",
            accion = { self.reanudar() }
        ),
        new OpcionMenu(
            menuActual = self,
            position = game.at(17, 10),
            imagenNormal = "btnReiniciar.png",
            imagenSeleccionada = "btnReiniciarSel.png",
            accion = { self.reiniciarPersonaje() }
        ),
        new OpcionMenu(
            menuActual = self,
            position = game.at(17, 6),
            imagenNormal = "btnMenu.png",
            imagenSeleccionada = "btnMenuSel.png",
            accion = { self.volverAlMenu() }
        )
    ]

    method opciones() = opciones
    method indiceSeleccionado() = indice
    method opcionSeleccionada() = opciones.get(indice)
    method enPausa() = enPausa

    method subir() {
        if (enPausa) {
            indice = (indice - 1 + opciones.size()) % opciones.size()
            sonidosMenu.reproducir(sonidosMenu.navegacion())
        }
    }

    method bajar() {
        if (enPausa) {
            indice = (indice + 1) % opciones.size()
            sonidosMenu.reproducir(sonidosMenu.navegacion())
        }
    }

    method seleccionar() {
        if (enPausa) {
            self.opcionSeleccionada().ejecutar()
            sonidosMenu.reproducir(sonidosMenu.seleccion())
        }
    }

    method mostrar() {
        if (not enPausa) {
            enPausa = true
            indice = 0
            game.removeTickEvent("bucleFisica")
            game.addVisual(titulo)
            opciones.forEach({ opcion => game.addVisual(opcion) })

            self.configurarControles()
        }
    }

    method ocultarVisuales() {
        game.removeVisual(titulo)
        opciones.forEach({ opcion => game.removeVisual(opcion) })
    }

    method reanudar() {
        if (enPausa) {
            enPausa = false
            self.ocultarVisuales()
            game.onTick(25, "bucleFisica", { motorFisico.actualizarFisica(personaje) })
        }
    }

    method reiniciarPersonaje() {
        enPausa = false
        menu.reiniciarNivel()
    }

    method volverAlMenu() {
        enPausa = false
        menu.mostrar()
    }

    method alternarPausa() {
        if (enPausa) self.reanudar() else self.mostrar()
    }

    method configurarControles() {
        keyboard.up().onPressDo({ self.subir() })
        keyboard.w().onPressDo({ self.subir() })
        keyboard.down().onPressDo({ self.bajar() })
        keyboard.s().onPressDo({ self.bajar() })
        keyboard.enter().onPressDo({ self.seleccionar() })
    }
}