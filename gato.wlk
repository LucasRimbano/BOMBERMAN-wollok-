import wollok.game.*
import colisiones.*
import pepita.*

class Gato {
	var property position
	const property tipo
	var property direccion = "fren"
	var vivo = true

	method image() = tipo + direccion + ".png"
	method esPared() = false
	method esGato() = true
	method esDestructible() = false
	method recibirDanio() {
		vivo = false
		game.removeVisual(self)
	}

	method mover() {
		if (vivo) {
			const validas = ["der", "izq", "tras", "fren"]
				.filter({ dir => colisiones.puedeMoverA(self.posicionEn(dir)) })
			if (!validas.isEmpty()) {
				const dir = validas.anyOne()
				position = self.posicionEn(dir)
				direccion = dir
				if (position == pepita.position()) pepita.perderVida()
			}
		}
	}

	method posicionEn(dir) {
		if (dir == "der")  return position.right(1)
		if (dir == "izq")  return position.left(1)
		if (dir == "tras") return position.up(1)
		return position.down(1)
	}
}
