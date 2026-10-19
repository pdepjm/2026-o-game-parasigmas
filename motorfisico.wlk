import personaje.*
import wollok.game.*

object motorFisico {
    const gravedad = -0.15
    const friccionAire = 0.92
    const nivelSuelo = 1 

    method gravedad() = gravedad
    method nivelSuelo() = nivelSuelo

    const bloques = [] 
    const interactuables = [] 
    
    method registrar(bloque) {
        bloques.add(bloque)
    }

    method registrarInteractuable(elemento) {
        interactuables.add(elemento)
    }

    method limpiarBloques() {
        bloques.clear()
        interactuables.clear()
    }

    method actualizarFisica(personaje) {
        const enSuelo = self.estaEnElSuelo(personaje)
        const accelActual = if (enSuelo) personaje.aceleracionSuelo() else personaje.aceleracionAire() 
        
        if (personaje.yendoDerecha()) {
            personaje.vx(personaje.vx() + accelActual)
        }
        if (personaje.yendoIzquierda()) {
            personaje.vx(personaje.vx() - accelActual)
        }

        // Fricción fluida y natural
        if (enSuelo) {
            personaje.vx(personaje.vx() * personaje.friccionSuelo())
            // Si no aprieta teclas y no está en hielo, frena rápido pero suave
            if (!personaje.yendoDerecha() and !personaje.yendoIzquierda() and !personaje.enHielo()) {
                personaje.vx(personaje.vx() * 0.6)
                if (personaje.vx().abs() < 0.05) { personaje.vx(0) }
            }
        } else {
            personaje.vx(personaje.vx() * friccionAire)
        }
        
        personaje.vx(personaje.vx().min(personaje.velMaximaX()).max(personaje.velMaximaX() * -1))

        //COLISIONES EN X
        const futuroX = personaje.xReal() + personaje.vx()

        const colisionesX = bloques.filter({ bloque => 
            (futuroX + personaje.anchoPersonaje() > bloque.xIzquierdo() and futuroX < bloque.xDerecho())
            and 
            (personaje.yReal() < bloque.yTecho() and personaje.yReal() + personaje.altoPersonaje() > bloque.yPiso())
        })

        if (!colisionesX.isEmpty()) {
            const bloqueChocadoX = colisionesX.first()
            if (personaje.vx() > 0) {
                personaje.xReal(bloqueChocadoX.xIzquierdo() - personaje.anchoPersonaje())
            } else if (personaje.vx() < 0) {
                personaje.xReal(bloqueChocadoX.xDerecho())
            }
            personaje.vx(0)
        } else {
            personaje.xReal(futuroX)
        }

        if (personaje.xReal() < 0) {
            personaje.xReal(0)
            personaje.vx(0)
        }
        const limiteDerecho = game.width() - personaje.anchoPersonaje()
        if (personaje.xReal() > limiteDerecho) {
            personaje.xReal(limiteDerecho)
            personaje.vx(0) 
        }
        
        //COLISIONES EN Y 
        personaje.estaApoyado(false)
        personaje.pisarPasto() 
        personaje.vy(personaje.vy() + gravedad)
        const futuroY = personaje.yReal() + personaje.vy()

        const colisionesY = bloques.filter({ bloque =>
            (personaje.xReal() + personaje.anchoPersonaje() > bloque.xIzquierdo() and personaje.xReal() < bloque.xDerecho())
            and 
            (futuroY <= bloque.yTecho() and futuroY + personaje.altoPersonaje() > bloque.yPiso())
        })

        if (!colisionesY.isEmpty()) {
            const bloqueChocadoY = colisionesY.first()
            if (personaje.vy() <= 0) { 
                personaje.yReal(bloqueChocadoY.yTecho())
                personaje.estaApoyado(true)
                // Aplica el efecto de todos los bloques pisados (para que el barro sobre el pasto tenga prioridad)
                colisionesY.forEach({ b => b.aplicarEfectoSuperficie(personaje) })
            } else if (personaje.vy() > 0) { 
                personaje.yReal(bloqueChocadoY.yPiso() - personaje.altoPersonaje())
            }
            personaje.vy(0)
        } else {
            personaje.yReal(futuroY)
        }
        
        if (personaje.yReal() <= nivelSuelo) {
            personaje.yReal(nivelSuelo)
            personaje.vy(0) 
            personaje.estaApoyado(true)
        }
        
        personaje.position(game.at(personaje.xReal().truncate(0), personaje.yReal().truncate(0)))

        self.chequearInteractuables(personaje)
    }

    method chequearInteractuables(personaje) {
        const px = personaje.xReal()
        const py = personaje.yReal()
        const tocados = interactuables.filter({ elem =>
            game.hasVisual(elem) and
            (px + 3 > elem.position().x() and px < elem.position().x() + elem.ancho()) and
            (py + 3 > elem.position().y() and py <= elem.position().y() + elem.alto())
        })
        tocados.forEach({ elem => elem.chocar(personaje) })
    }

    method estaEnElSuelo(personaje) = personaje.yReal() <= nivelSuelo or personaje.estaApoyado()

    method salto(personaje) {
        if(self.estaEnElSuelo(personaje)) {
            personaje.vy(personaje.impulsoSalto())
            personaje.estaApoyado(false)
        }
    }

    method irA(nuevaPosicion, personaje) {
        personaje.xReal(nuevaPosicion.x())
        personaje.yReal(nuevaPosicion.y())
        personaje.vx(0)
        personaje.vy(0)
        personaje.position(nuevaPosicion)
    }
}