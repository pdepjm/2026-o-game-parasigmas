import wollok.game.*
import personaje.*

object configuracionControles {
    
    method configurar() {
        keyboard.up().onPressDo({ personaje.saltar() })
        keyboard.w().onPressDo({ personaje.saltar() }) 

        keyboard.right().onPressDo({ personaje.moverDerecha() })
        keyboard.d().onPressDo({ personaje.moverDerecha() })

        keyboard.left().onPressDo({ personaje.moverIzquierda() })
        keyboard.a().onPressDo({ personaje.moverIzquierda() })

        keyboard.c().onPressDo({ personaje.centrar() })
    }
}