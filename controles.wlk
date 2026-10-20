import wollok.game.*
import personaje.*
import niveles.* // Necesario para acceder a la meta y el nivel actual

object configuracionControles {
    
    method configurar() {
        keyboard.up().onPressDo({ personaje.saltar() })
        keyboard.w().onPressDo({ personaje.saltar() }) 

        keyboard.right().onPressDo({ personaje.avanzarDerecha() })
        keyboard.d().onPressDo({ personaje.avanzarDerecha() })

        keyboard.right().onReleaseDo({personaje.frenarDerecha()})
        keyboard.d().onReleaseDo({personaje.frenarDerecha()})

        keyboard.left().onPressDo({ personaje.avanzarIzquierda() })
        keyboard.a().onPressDo({ personaje.avanzarIzquierda() })

        keyboard.left().onReleaseDo({personaje.frenarIzquierda()})
        keyboard.a().onReleaseDo({personaje.frenarIzquierda()})

        keyboard.c().onPressDo({ personaje.centrar() })

        // para pasar el nivel directo
        keyboard.t().onPressDo({ 
            if (meta.nivelActual() != null) {
                meta.nivelActual().victoria()
            }
        })
    }
}