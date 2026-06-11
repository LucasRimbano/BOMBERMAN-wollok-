import wollok.game.*
import huevo.*
import colisiones.*
import movimientos.*

class EstadoDanioPepita {
	method recibirDanio(pepita) {}
}

object danioActivoPepita inherits EstadoDanioPepita {
	override method recibirDanio(pepita) {
		pepita.aplicarDanio()
	}
}

object danioIgnoradoPepita inherits EstadoDanioPepita {
	override method recibirDanio(pepita) {
		pepita.activarDanio()
	}
}

object pepita {

	var property position = game.at(6, 5)
	var property direccion = "fren"
	var vidas = 3
	var estadoDanio = danioActivoPepita
	var alPerder = {}

	method image() = "pep" + direccion + ".png"

	method esPared() = false
	method esDestructible() = false

	method recibirDanio() { self.perderVida() }

	method silenciarDanio() { estadoDanio = danioIgnoradoPepita }
	method activarDanio()   { estadoDanio = danioActivoPepita }

	method registrarCallbackPerder(cb) { alPerder = cb }

	method resetear() {
		position = game.at(6, 5)
		direccion = "fren"
		vidas = 3
		estadoDanio = danioActivoPepita
	}

	method irA(nuevaPosicion) {
		if (colisiones.puedeMoverA(nuevaPosicion)) {
			position = nuevaPosicion
		}
	}

	method mover(movimiento) {
		direccion = movimiento.direccion()
		self.irA(movimiento.posicionDesde(position, 1))
	}

	method colocarHuevo() {
		const h = new Huevo(position = position)
		h.activar()
	}

	method perderVida() {
		game.schedule(50, { estadoDanio.recibirDanio(self) })
	}

	method aplicarDanio() {
		vidas -= 1
		position = game.at(6, 5)
		self.consecuenciaDeDanio()
	}

	method consecuenciaDeDanio() {
		if (vidas == 0) {
			alPerder.apply()
		} else {
			game.sound("muerte.mp3").play()
		}
	}

}
