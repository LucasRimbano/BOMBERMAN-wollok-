[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/hlX9xZQr)

# 💣 BomberPepita en Wollok
(Los pepitos)

## Equipo de desarrollo

- Nahuel Galeano
- Lucas Rimbano
- Ivan Iaffar

## Reglas de Juego / Instrucciones

El juego es una recreación del clásico **Bomberman**, desarrollado en **Wollok** utilizando `wollok.game`. El jugador controla a **Pepita** dentro de un escenario con tres niveles. El objetivo es eliminar a todos los gatos enemigos colocando huevos bomba, sin ser alcanzado por ellos.

### Controles
Con las flechas movemos a Pepita.
Con la barra espaciadora ponemos huevos.

### Mecánicas principales

- Pepita puede moverse por los espacios libres del mapa.
- Al colocar un huevo, este explota luego de un tiempo, generando una explosión en cruz con alcance de 2 celdas.
- La explosión destruye bloques destructibles y elimina gatos que estén en su rango.
- Los bloques indestructibles no pueden ser eliminados y bloquean la explosión.
- Los gatos se mueven automáticamente y al contacto con Pepita le quitan una vida.
- Pepita tiene 3 vidas. Al perder la última, aparece la pantalla de game over.
- Al eliminar a todos los gatos del nivel se avanza al siguiente.
- El juego tiene 3 niveles. Completar el tercero muestra la pantalla de victoria.

### Pantallas

- **Pantalla de inicio**: se muestra al abrir el juego y al reiniciar. Presionar **Enter** para comenzar.
- **Pantalla de game over**: aparece al perder todas las vidas. Luego de unos segundos vuelve a la pantalla de inicio.
- **Pantalla de victoria**: aparece al completar los 3 niveles. Luego de unos segundos vuelve a la pantalla de inicio.

### Sonidos

Pantalla de inicio: `pantallainicial.mp3`
Pepita pierde una vidA: `muerte.mp3`
Huevo explota: `explosion.mp3` 
Se pasa de niveL: `gananivel.mp3` 
Pantalla de game over: `gameover.mp3` 
Pantalla de victoria: `victoria.mp3` 

### Uso de polimorfismo

En el desarrollo del juego se aplica **polimorfismo** haciendo que distintos objetos entiendan los mismos mensajes, aunque cada uno responda de manera diferente.

Los objetos del mapa (`Piso`, `BloqueIndestructible`, `BloqueDestructible`, `Gato`, `Pepita`, `CeldaExplosion`) responden a los mensajes `esPared()`, `esGato()`, `esDestructible()` y `recibirDanio()`:

- Un `BloqueIndestructible` no puede ser destruido ni atravesado.
- Un `BloqueDestructible` bloquea el paso pero desaparece al recibir una explosión.
- Un `Gato` muere al recibir daño y notifica al `nivelManager`.
- `Pepita` pierde una vida al recibir daño.
- Un `Piso` o `CeldaExplosion` no reacciona a ninguno de estos mensajes.

Esto permite que la lógica de colisiones y explosiones envíe siempre el mismo mensaje sin necesidad de preguntar qué tipo de objeto es cada elemento.

### Uso de listas

Las listas se utilizan en varias partes del juego para manejar colecciones de objetos de forma uniforme:

**`gato.wlk` — direcciones válidas de movimiento**
En `Gato.mover()`, se crea una lista literal con las cuatro direcciones posibles y se filtra con `.filter()` para quedarse solo con las que no tienen obstáculos. Luego se elige una al azar con `.anyOne()`:
```wollok
const validas = ["der", "izq", "tras", "fren"]
    .filter({ dir => colisiones.puedeMoverA(self.posicionEn(dir)) })
const dir = validas.anyOne()
```

**`mapa.wlk` — gestión de gatos en `nivelManager`**
El `nivelManager` mantiene una lista `gatos` que representa los enemigos vivos del nivel actual. Se usa `.forEach()` para moverlos cada tick, `.all()` para verificar si todos murieron y avanzar de nivel, e `.isEmpty()` como guardia antes de esa verificación:
```wollok
gatos.forEach({ g => g.mover() })
gatos.all({ g => !g.estaVivo() })
```

**`mapa.wlk` — posiciones de bloques en los niveles**
Cada nivel construye listas de posiciones para colocar los bloques. `posicionesDestructibles()` devuelve una lista literal, mientras que `posicionesIndestructibles()` acumula posiciones en una lista vacía usando `.add()` dentro de iteraciones con `.forEach()`. Luego se recorren con `.forEach()` para agregar los visuales al juego.

**`bomberPepita.wpgm` — creación de gatos al iniciar y al cambiar de nivel**
Los gatos se crean como una lista literal de instancias de `Gato` y se recorren con `.forEach()` para agregarlos al juego y pasárselos al `nivelManager`:
```wollok
const gatos = [
    new Gato(position = game.at(1, 1),  tipo = "cal"),
    new Gato(position = game.at(11, 1), tipo = "nar"),
    new Gato(position = game.at(1, 9),  tipo = "neg"),
    new Gato(position = game.at(11, 9), tipo = "tux")
]
gatos.forEach({ g => game.addVisual(g) })
```

**`huevo.wlk` — celdas de la explosión**
La clase `Explosion` mantiene una lista `celdas` donde acumula cada celda visual de la explosión con `.add()`. Al finalizar la animación, recorre esa lista con `.forEach()` para remover los visuales del tablero. También la recorre para aplicar daño a todos los objetos en esas posiciones:
```wollok
celdas.forEach({ c => game.removeVisual(c) })
celdas.forEach({ c => game.getObjectsIn(c.position()).forEach({ obj => obj.recibirDanio() }) })
```

### Elementos del juego

#### Pepita (personaje principal)

Pepita es el personaje controlado por el jugador. Se mueve por el mapa, coloca huevos bomba y tiene 3 vidas. Al perder todas las vidas termina la partida.

#### Huevos y explosiones

Los huevos se colocan en la posición actual de Pepita y explotan luego de un tiempo. La explosión se expande en las cuatro direcciones con un alcance de 2 celdas, destruye bloques destructibles y elimina gatos.

#### Bloques

El mapa cuenta con tres tipos de bloques:

- **Indestructibles**: forman los bordes del mapa y columnas internas. No pueden ser destruidos ni atravesados.
- **Destructibles**: bloques que pueden ser eliminados por una explosión.
- **Piso**: espacios libres por donde puede moverse el jugador.

#### Gatos (enemigos)

Los gatos se mueven automáticamente por el mapa eligiendo una dirección válida al azar en cada movimiento. Al contacto con Pepita le quitan una vida. Al recibir el daño de una explosión mueren. Cuando todos los gatos del nivel mueren, se avanza al siguiente nivel.

## Otros

- Curso: Algoritmos 1
- Facultad: Universidad Nacional de San Martín - UNSAM
- Lenguaje: Wollok
- Herramientas utilizadas:
  - Wollok Game
  - Visual Studio Code
  - Git
  - GitHub
