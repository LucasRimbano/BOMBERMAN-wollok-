import wollok.game.*

object huevoCounter {
	var count = 0
	method next() {
		count += 1
		return count
	}
}

class CeldaExplosion {
	var property position
	method image() = "explosion.png"
	method esPared() = false
	method esGato() = false
	method esDestructible() = false
	method recibirDanio() {}
}

class Explosion {
	var property position
	const alcance = 2
	const celdas = []
	var id = 0
	var tics = 0

	method activar(explosionId) {
		id = explosionId
		self.agregarCelda(position)
		self.calcularBrazo("der")
		self.calcularBrazo("izq")
		self.calcularBrazo("tras")
		self.calcularBrazo("fren")
		self.verificarDanio()
		game.onTick(400, "expl_" + id, {
			tics += 1
			if (tics >= 2) {
				celdas.forEach({ c => game.removeVisual(c) })
				game.removeTickEvent("expl_" + id)
			}
		})
	}

	method calcularBrazo(dir) {
		var parar = false
		(1..alcance).forEach({ i =>
			if (!parar) {
				const pos = self.posicionEn(dir, i)
				const objetos = game.getObjectsIn(pos)
				if (objetos.any({ o => o.esPared() && !o.esDestructible() })) {
					parar = true
				} else if (objetos.any({ o => o.esDestructible() })) {
					objetos.filter({ o => o.esDestructible() }).forEach({ o => game.removeVisual(o) })
					self.agregarCelda(pos)
					parar = true
				} else {
					self.agregarCelda(pos)
				}
			}
		})
	}

	method posicionEn(dir, i) {
		if (dir == "der")  return position.right(i)
		if (dir == "izq")  return position.left(i)
		if (dir == "tras") return position.up(i)
		return position.down(i)
	}

	method agregarCelda(pos) {
		const celda = new CeldaExplosion(position = pos)
		celdas.add(celda)
		game.addVisual(celda)
	}

	method verificarDanio() {
		celdas.forEach({ c =>
			game.getObjectsIn(c.position()).forEach({ obj =>
				obj.recibirDanio()
			})
		})
	}
}

class Huevo {
	var property position
	var tics = 0
	var id = 0

	method image() = if (tics.even()) "huevo1.png" else "huevo2.png"
	method esPared() = false
	method esGato() = false
	method esDestructible() = false
	method recibirDanio() {}

	method activar() {
		id = huevoCounter.next()
		game.addVisual(self)
		game.onTick(500, "huevo_" + id, {
			tics += 1
			if (tics >= 4) {
				game.removeVisual(self)
				game.removeTickEvent("huevo_" + id)
				const exp = new Explosion(position = position)
				exp.activar(id)
			}
		})
	}
}
