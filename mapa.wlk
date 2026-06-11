import wollok.game.*
import pepita.*

class Celda {
	var property position
	const sufijo

	method image() = self.prefijo() + sufijo + ".png"
	method prefijo()

	method esGato() = false
	method recibirDanio() {}
}

class Piso inherits Celda {
	override method prefijo() = "piso"
	method esPared() = false
	method esDestructible() = false
}

class BloqueIndestructible inherits Celda {
	override method prefijo() = "indes"
	method esPared() = true
	method esDestructible() = false
}

class BloqueDestructible inherits Celda {
	override method prefijo() = "dest"
	method esPared() = true
	method esDestructible() = true
}

class Nivel {
	const sufijo

	method agregarAlJuego() {
		(0..12).forEach({ x =>
			(0..10).forEach({ y =>
				game.addVisual(new Piso(position = game.at(x, y), sufijo = sufijo))
			})
		})
		self.posicionesIndestructibles().forEach({ pos =>
			game.addVisual(new BloqueIndestructible(position = pos, sufijo = sufijo))
		})
		self.posicionesDestructibles().forEach({ pos =>
			game.addVisual(new BloqueDestructible(position = pos, sufijo = sufijo))
		})
	}

	method posicionesIndestructibles() {
		const result = []
		(0..12).forEach({ x =>
			result.add(game.at(x, 0))
			result.add(game.at(x, 10))
		})
		(1..9).forEach({ y =>
			result.add(game.at(0, y))
			result.add(game.at(12, y))
		})
		[2, 4, 6, 8, 10].forEach({ x =>
			[2, 4, 6, 8].forEach({ y =>
				result.add(game.at(x, y))
			})
		})
		return result
	}

	method posicionesDestructibles()
}

object nivel1 inherits Nivel(sufijo = 1) {

	override method posicionesDestructibles() {
		return [
			game.at(1, 3), game.at(1, 4), game.at(1, 6),
			game.at(3, 3), game.at(3, 4), game.at(3, 5), game.at(3, 8), game.at(3, 9),
			game.at(5, 1), game.at(5, 3), game.at(5, 8),
			game.at(6, 9),
			game.at(7, 7), game.at(7, 9),
			game.at(8, 1), game.at(8, 3),
			game.at(9, 1), game.at(9, 5), game.at(9, 6), game.at(9, 8),
			game.at(11, 4), game.at(11, 5), game.at(11, 6)
		]
	}

}

object nivel2 inherits Nivel(sufijo = 2) {

	override method posicionesDestructibles() {
		return [
			game.at(1, 2), game.at(1, 4), game.at(1, 6),
			game.at(2, 5),
			game.at(3, 4), game.at(3, 8), game.at(3, 9),
			game.at(5, 2), game.at(5, 6), game.at(5, 7), game.at(5, 9),
			game.at(7, 1), game.at(7, 4),
			game.at(8, 5),
			game.at(9, 1), game.at(9, 2), game.at(9, 4), game.at(9, 6), game.at(9, 7), game.at(9, 8),
			game.at(11, 5), game.at(11, 7), game.at(11, 8)
		]
	}

}

object nivel3 inherits Nivel(sufijo = 3) {

	override method posicionesDestructibles() {
		return [
			game.at(1, 4), game.at(1, 6),
			game.at(3, 2), game.at(3, 5),
			game.at(5, 1), game.at(5, 4), game.at(5, 8), game.at(5, 9),
			game.at(7, 1), game.at(7, 2), game.at(7, 8), game.at(7, 9),
			game.at(9, 2), game.at(9, 6), game.at(9, 8),
			game.at(11, 4), game.at(11, 5)
		]
	}

}

object nivelManager {

	var nivelActual = 1
	var gatos = []
	var alCambiarNivel = {}
	var alGanar = {}
	var nivelCompletadoAvisado = false
	const niveles = [nivel1, nivel2, nivel3]

	method registrarCallback(cb) {
		alCambiarNivel = cb
	}

	method registrarCallbackGanar(cb) {
		alGanar = cb
	}

	method resetear() {
		nivelActual = 1
		gatos = []
		alCambiarNivel = {}
		nivelCompletadoAvisado = false
	}

	method iniciar(listaGatos) {
		gatos = listaGatos
		nivelCompletadoAvisado = false
	}

	method actualizarGatos(nuevosGatos) {
		gatos = nuevosGatos
		nivelCompletadoAvisado = false
	}

	method moverGatos() {
		gatos.forEach({ g => g.mover() })
	}

	method gatoMurio() {
		[self].filter({ manager => !nivelCompletadoAvisado && manager.nivelCompletado() }).forEach({ manager =>
			nivelCompletadoAvisado = true
			manager.avanzarNivel()
		})
	}

	method nivelCompletado() = !gatos.isEmpty() && gatos.all({ g => !g.estaVivo() })

	method avanzarNivel() {
		pepita.silenciarDanio()
		nivelActual += 1
		game.clear()
		[self].filter({ manager => manager.juegoTerminado() }).forEach({ manager =>
			alGanar.apply()
		})
		[self].filter({ manager => !manager.juegoTerminado() }).forEach({ manager =>
			manager.reproducirSonidoCambioNivel()
			manager.cargarNivel()
		})
	}

	method juegoTerminado() = nivelActual > niveles.size()

	method reproducirSonidoCambioNivel() {
		game.sound("gananivel.mp3").play()
	}

	method cargarNivel() {
		self.obtenerNivel().agregarAlJuego()
		self.reposicionarPepita()
		self.reiniciarTickGatos()
		alCambiarNivel.apply()
	}

	method reposicionarPepita() {
		pepita.position(game.at(6, 5))
		game.addVisual(pepita)
		game.say(pepita, "Nivel " + nivelActual)
	}

	method reiniciarTickGatos() {
		game.removeTickEvent("movimientoGatos")
		game.onTick(500, "movimientoGatos", { self.moverGatos() })
	}

	method obtenerNivel() = niveles.get(nivelActual - 1)

}
