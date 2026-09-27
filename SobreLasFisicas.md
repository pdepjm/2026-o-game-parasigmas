## Aclaración sobre las físicas

Objeto jugador:
Para que el juego se vea fluido, el jugador no ocupa visualmente una sola celda sino 20x20 (una celda ocupa 10px, el png es de 200x200). La movilidad entonces es de a varias celdas por tick: el salto son 7.5 casillas, la movilidad lateral de a 3 casillas, etc. 

Hitboxes:
El jugador ocupa visualmente 20x20 casillas pero la hitbox real es la primer casilla inferior izquierda, por lo que para que se vea correcta la hitbox (que no se atraviesen visualmente los objetos) se debe "atrasar" 20 celdas para la izquierda toda colisión a derecha del personaje, pero no los objetos que colisione a su izquierda. 
Además, como el jugador se mueve de a 3 bloques por tick, las colisiones deben ser de un grosor mayor para evitar que no registre la colisión: tanto los limites del mundo como las paredes son de grosor 4 celdas