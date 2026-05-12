[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/hlX9xZQr)

# 💣 Bomberman en Wollok
(Los pepitos)

## Equipo de desarrollo

- Nahuel Galeano
- Lucas Rimbano
- Ivan Iaffar

## Capturas

 cuando tengamos el juego vamos a sacar las capturas correspondientes...

Por ejemplo:

- Pantalla inicial del mapa.
- Bomberman moviéndose por el escenario.
- Bomba colocada en el mapa.
- Explosión de una bomba.
- Bloques destruidos.
- Pantalla de victoria o derrota, si corresponde.

## Reglas de Juego / Instrucciones

El juego es una recreación del clásico **Bomberman**, desarrollado en **Wollok** utilizando `wollok.game`.

El jugador controla a Bomberman dentro de un escenario. El objetivo principal es moverse por el mapa, colocar bombas estratégicamente, destruir obstáculos y evitar ser alcanzado por enemigos o explosiones.

### Controles

- Usar las teclas de dirección para mover al personaje por el mapa.
- Usar la tecla correspondiente para colocar una bomba.
- Evitar quedar dentro del rango de explosión.
- Evitar el contacto con los enemigos, si los hay.
- Destruir bloques rompibles para abrir caminos dentro del escenario.

### Mecánicas principales

- El personaje puede moverse por los espacios libres del mapa.
- Las bombas se colocan en la posición actual del jugador.
- Las bombas explotan luego de un tiempo determinado.
- La explosión puede destruir bloques rompibles.
- Los bloques indestructibles no pueden ser eliminados.
- El jugador debe evitar las explosiones y los enemigos.
- El juego puede tener condiciones de victoria y derrota según el avance del desarrollo.

### Uso de polimorfismo

En el desarrollo del juego se aplica **polimorfismo** haciendo que distintos objetos entiendan los mismos mensajes, aunque cada uno responda de manera diferente según su comportamiento.

Por ejemplo, distintos objetos del mapa pueden recibir el mensaje `chocarContra(personaje)`:

- Una pared indestructible bloquea el movimiento.
- Un bloque destructible también bloquea el movimiento, pero puede desaparecer cuando explota una bomba.
- Un espacio libre permite que el personaje avance.

También se puede aplicar polimorfismo en los movimientos. Tanto el jugador como los enemigos pueden entender mensajes relacionados con el movimiento, como `moverArriba()`, `moverAbajo()`, `moverIzquierda()` o `moverDerecha()`:

- El jugador se mueve según las teclas presionadas.
- Los enemigos pueden moverse automáticamente siguiendo otra lógica.

Otro ejemplo importante aparece cuando explota una bomba. Distintos objetos pueden recibir el mensaje `recibirExplosion()`:

- Un bloque destructible desaparece.
- Una pared indestructible no se ve afectada.
- Un enemigo puede ser eliminado.
- El jugador puede perder la partida si queda dentro del rango de explosión.

De esta manera, el juego evita preguntar constantemente qué tipo de objeto es cada elemento. En lugar de usar muchos condicionales, se envía el mismo mensaje y cada objeto responde según su propia responsabilidad.

### Elementos del juego

#### Personaje principal

Bomberman es el personaje controlado por el jugador. Puede moverse por el mapa y colocar bombas.

#### Bombas

Las bombas se colocan en una posición del tablero y explotan luego de un tiempo. La explosión puede afectar al jugador, enemigos y bloques destructibles.

#### Bloques

El mapa cuenta con distintos tipos de bloques:

- Bloques indestructibles.
- Bloques destructibles.
- Espacios libres por donde puede moverse el jugador.

#### Enemigos

Los enemigos representan un peligro para el jugador. Dependiendo de la implementación, pueden moverse por el mapa y provocar la derrota si alcanzan al personaje.

## Otros

- Curso: Algoritmos 1
- Facultad: Universidad Nacional de San Martín - UNSAM
- Lenguaje: Wollok
- Versión de Wollok: 1.0.3
- Herramientas utilizadas:
  - Wollok
  - Wollok Game
  - Visual Studio Code
  - Git
  - GitHub
  

## Code inicial

```bash
wollok init --project bomberman --game
```