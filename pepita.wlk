import wollok.game.*
import huevo.*
import colisiones.*

object pepita {

	var property position = game.at(6, 5)
	var property direccion = "fren"
	var vidas = 3

	method image() = "pep" + direccion + ".png"
	method esPared() = false
	method esDestructible() = false
	method recibirDanio() { self.perderVida() }

	method irA(nuevaPosicion) {
		if (colisiones.puedeMoverA(nuevaPosicion)) {
			position = nuevaPosicion
		}
	}

	method moverDerecha() {
		direccion = "der"
		self.irA(position.right(1))
	}

	method moverIzquierda() {
		direccion = "izq"
		self.irA(position.left(1))
	}

	method moverArriba() {
		direccion = "tras"
		self.irA(position.up(1))
	}

	method moverAbajo() {
		direccion = "fren"
		self.irA(position.down(1))
	}

	method colocarHuevo() {
		const h = new Huevo(position = position)
		h.activar()
	}

	method perderVida() {
		vidas -= 1
		position = game.at(6, 5)
		if (vidas == 0) {
			game.say(self, "GAME OVER")
			game.stop()
		}
	}

}
