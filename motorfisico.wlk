import personaje.*
import wollok.game.*

object motorFisico {
    const gravedad = -0.15
    const friccionSuelo = 0.85     
    const friccionAire = 0.95
    const nivelSuelo = 1 

    //getters para testing
    method gravedad() = gravedad
    method nivelSuelo() = nivelSuelo

    const bloques = [] // mapea todos los bloques fisicos
    
    method registrar(bloque) {
        bloques.add(bloque)
    }

    method actualizarFisica(personaje) {
        personaje.estaApoyado(false) //estado inicial
        const accelActual = if (self.estaEnElSuelo(personaje)) personaje.aceleracionSuelo() else personaje.aceleracionAire() 
        
        if (personaje.yendoDerecha()) {
            personaje.vx(personaje.vx() + accelActual)
        }
        if (personaje.yendoIzquierda()) {
            personaje.vx(personaje.vx() - accelActual)
        }

        if (self.estaEnElSuelo(personaje)) {
            personaje.vx(personaje.vx() * friccionSuelo)
        } else {
            personaje.vx(personaje.vx() * friccionAire)
        }   
        
        personaje.vx(personaje.vx().min(personaje.velMaximaX()).max(personaje.velMaximaX() * -1))
        
        // se calcula posicion "a futuro" para ver si colisionaría con un bloque de la lista
        // primero en X
        const futuroX = personaje.xReal() + personaje.vx()

        const colisionesX = bloques.filter({ bloque => 
            (futuroX + personaje.anchoPersonaje() > bloque.xIzquierdo() and futuroX < bloque.xDerecho()) // si se "superpondrian" significa que chocaron
            and 
            (personaje.yReal() < bloque.yTecho() and personaje.yReal() + personaje.altoPersonaje() > bloque.yPiso()) // si se superponen en X pero no en Y significa que saltó. no cuenta como colision
        })

        if (!colisionesX.isEmpty()) {
            const bloqueChocadoX = colisionesX.first() // elijo un bloque, por si hay choques entre dos bloques apilados
            if (personaje.vx() > 0) { // si corría hacia la derecha
                personaje.xReal(bloqueChocadoX.xIzquierdo() - personaje.anchoPersonaje()) // se lo ubica a la izquierda del bloque - ancho del personaje
            } else {
                if (personaje.vx() < 0) {
                    personaje.xReal(bloqueChocadoX.xDerecho()) // lo mismo a derecha
                }
            }
            personaje.vx(0) // se anula la velocidad
        } else {
            personaje.xReal(futuroX) // si no hay colision, avanza
        }

        //limite izquierdo del mapa
        if (personaje.xReal() < 0) {
            personaje.xReal(0)
            personaje.vx(0)
        }
        
        //limite derecho del mapa
        const limiteDerecho = game.width() - 3
        if (personaje.xReal() > limiteDerecho) {
            personaje.xReal(limiteDerecho)
            personaje.vx(0) 
        }
        
        personaje.vy(personaje.vy() + gravedad)

        // calculo colisiones en Y
        const futuroY = personaje.yReal() + personaje.vy()

        const colisionesY = bloques.filter({ bloque =>
            (personaje.xReal() + personaje.anchoPersonaje() > bloque.xIzquierdo() and personaje.xReal() < bloque.xDerecho())
            and 
            (futuroY < bloque.yTecho() and futuroY + personaje.altoPersonaje() > bloque.yPiso())
        })

        if (!colisionesY.isEmpty()) {
            const bloqueChocadoY = colisionesY.first()
            if (personaje.vy() < 0) { // si se desacelera en Y, viene cayendo. entonces es un piso
                personaje.yReal(bloqueChocadoY.yTecho())
                personaje.estaApoyado(true)
            } else { 
                if (personaje.vy() > 0) {
                    personaje.yReal(bloqueChocadoY.yPiso() - personaje.altoPersonaje()) // si se acelera en Y, viene saltando. entonces es un techo
                }
            }
            personaje.vy(0) //se anula velocidad
        } else {
            personaje.yReal(futuroY) // si no hay colision
        }
        
        if (personaje.yReal() < nivelSuelo) {
            personaje.yReal(nivelSuelo)
            personaje.vy(0) 
            personaje.estaApoyado(true)
        }
        
        personaje.position(game.at(personaje.xReal().truncate(0), personaje.yReal().truncate(0)))
    }

    method estaEnElSuelo(personaje) = personaje.yReal() <= nivelSuelo or personaje.estaApoyado()

    method salto(personaje) {
        if(self.estaEnElSuelo(personaje)) {
            personaje.vy(personaje.impulsoSalto())
        }
    }

    method irA(nuevaPosicion, personaje) {
        personaje.xReal(nuevaPosicion.x())
        personaje.yReal(nuevaPosicion.y())
        personaje.vx(0)
        personaje.vy(0)
    }
}