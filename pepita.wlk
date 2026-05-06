import wollok.game.*
import colisiones.*
import huevo.*

object pepita {

	var property position = game.at(6, 5)
	var property direccion = "fren"

	method image() = "pep" + direccion + ".png"
	
	method esPared() {
		return false
	}

	method irA(nuevaPosicion) {
		if (colisiones.puedeMoverA(nuevaPosicion)) {
			position = nuevaPosicion
		}
	}

	method moverDerecha() {
		direccion = "der"
		const nueva = position.right(1)
		if (nueva.x() < game.width()) self.irA(nueva)
	}

	method moverIzquierda() {
		direccion = "izq"
		const nueva = position.left(1)
		if (nueva.x() >= 0) self.irA(nueva)
	}

	method moverArriba() {
		direccion = "tras"
		const nueva = position.up(1)
		if (nueva.y() < game.height()) self.irA(nueva)
	}

	method moverAbajo() {
		direccion = "fren"
		const nueva = position.down(1)
		if (nueva.y() >= 0) self.irA(nueva)
	}

	method colocarHuevo() {
		const h = new Huevo(position = position)
		h.activar()
	}
}
