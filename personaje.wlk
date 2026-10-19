import motorfisico.*
import wollok.game.*
import menu.*

object personaje {
    
    var property xReal = 5.0
    var property yReal = 5.0

    var property position = game.at(25, 25)
    var property posicionInicial = game.at(5, 5)
    method image() = "personaje.png" 
    
    var property vx = 0.0 
    var property vy = 0.0

    var property yendoDerecha = false
    var property yendoIzquierda = false
    var property enHielo = false
    
    const gravedad = -0.15       
    var aceleracionSuelo = 0.24 
    const aceleracionAire = 0.12  
    var friccionSuelo = 0.85 
    const friccionAire = 0.95     
    const impulsoSalto = 1.5     
    var velMaximaX = 0.6
    const anchoPersonaje = 3 
    const altoPersonaje = 3

    method aceleracionSuelo() = aceleracionSuelo
    method aceleracionAire() = aceleracionAire  
    method friccionSuelo() = friccionSuelo
    method impulsoSalto() = impulsoSalto     
    method velMaximaX() = velMaximaX
    method anchoPersonaje() = anchoPersonaje
    method altoPersonaje()  = altoPersonaje       

    var property estaApoyado = false

    method avanzarDerecha() { yendoDerecha = true }
    method frenarDerecha()  { yendoDerecha = false }
    method detener() {
        yendoDerecha = false
        yendoIzquierda = false
        vx = 0.0
        vy = 0.0
    }

    method avanzarIzquierda() { yendoIzquierda = true }
    method frenarIzquierda()  { yendoIzquierda = false }

    method saltar() {
        motorFisico.salto(self)
    }

    method centrar() { 
        xReal = 5.0
        yReal = 5.0
        vx = 0.0
        vy = 0.0
        position = game.at(5, 5)        
        self.pisarPasto()
    }

    method irA(nuevaPosicion) {
        motorFisico.irA(nuevaPosicion, self)
        self.pisarPasto()
    }

    // llave
    var llavesAgarradas = 0

    method cantidadLlaves() = llavesAgarradas
        
    method agarrarLlave() {
        llavesAgarradas += 1
    }

    method reiniciarLlaves() {
        llavesAgarradas = 0
    }

    method morir() {
        self.irA(posicionInicial)
    }

    method pisarHielo() {  
        enHielo = true
        friccionSuelo = 0.98    
        aceleracionSuelo = 0.08 
        velMaximaX = 0.65
    }

    method pisarBarro() {
        enHielo = false
        friccionSuelo = 0.40    
        aceleracionSuelo = 0.08 
        velMaximaX = 0.20       
    }

    method pisarPasto() { 
        enHielo = false
        friccionSuelo = 0.85    
        aceleracionSuelo = 0.24 
        velMaximaX = 0.6
    }
}