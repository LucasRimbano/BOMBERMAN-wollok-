import wollok.game.*

object huevoCounter {
	var count = 0
	method next() {
		count += 1
		return count
	}
}

class Huevo {
	var property position
	var tics = 0
	var id = 0

	method image() = if (tics.even()) "huevo1.png" else "huevo2.png"

	method activar() {
		id = huevoCounter.next()
		game.addVisual(self)
		game.onTick(500, "huevo_" + id, {
			tics += 1
			if (tics >= 4) {
				game.removeVisual(self)
				game.removeTickEvent("huevo_" + id)
			}
		})
	}
}
