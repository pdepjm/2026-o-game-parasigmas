import wollok.game.*
import personaje.*
import motorfisico.*
import controles.*
import niveles.*

// Imagen fija del menu (fondo, titulo, ayuda...).
// Wollok la dibuja con su esquina INFERIOR IZQUIERDA en `position`
// y crece hacia arriba y hacia la derecha.
class ImagenMenu {
    const property position
    const property image
}

// Una opcion del menu: se ve distinta si esta seleccionada y sabe que hacer al elegirla.
// Para agregar una opcion nueva alcanza con sumarla a la lista `opciones` de `menu`.
class OpcionMenu {
    const property position
    const imagenNormal
    const imagenSeleccionada
    const accion

    method image() = if (menu.opcionSeleccionada() == self) imagenSeleccionada else imagenNormal

    method ejecutar() { accion.apply() }
}

object menu {
    // Tablero de 50 x 30 celdas de 25 px = 1250 x 750 px
    const fondo  = new ImagenMenu(position = game.at(0, 0),  image = "menuFondo.png")
    const titulo = new ImagenMenu(position = game.at(9, 20), image = "menuTitulo.png") // 800 x 150
    const ayuda  = new ImagenMenu(position = game.at(9, 2),  image = "menuAyuda.png")  // 800 x 50

    const pantallaControles = new ImagenMenu(position = game.at(0, 0), image = "pantallaControles.png")

    // botones de 400 x 75 (16 x 3 celdas), centrados en x = 17
    const opciones = [
        new OpcionMenu(position = game.at(17, 14), imagenNormal = "btnJugar.png",
                       imagenSeleccionada = "btnJugarSel.png", accion = { self.jugar() }),
        new OpcionMenu(position = game.at(17, 10), imagenNormal = "btnControles.png",
                       imagenSeleccionada = "btnControlesSel.png", accion = { self.mostrarControles() }),
        new OpcionMenu(position = game.at(17, 6), imagenNormal = "btnSalir.png",
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
    }

    method bajar() {
        indice = (indice + 1) % opciones.size()
    }

    method seleccionar() {
        self.opcionSeleccionada().ejecutar()
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
        nivelAJugar.iniciarNivel() // hace game.clear(), ubica personaje y meta, dibuja el entorno
        self.activarJuego()
    }

    // game.clear() se llevo puestas las teclas, las colisiones y el pulso de la fisica: se revive todo
    method activarJuego() {
        configuracionControles.configurar()
        game.onCollideDo(personaje, { elemento => elemento.chocar(personaje) })
        game.onTick(25, "bucleFisica", { motorFisico.actualizarFisica(personaje) })
    }
}
