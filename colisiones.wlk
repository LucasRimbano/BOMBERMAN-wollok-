import wollok.game.*
import huevo.*

object colisiones {

	method puedeMoverA(unaPosicion) {
		return self.estaDentroDelTablero(unaPosicion) && !self.hayBloqueEn(unaPosicion)
	}

	method estaDentroDelTablero(unaPosicion) {
		return unaPosicion.x() >= 0 &&
			unaPosicion.x() < game.width() &&
			unaPosicion.y() >= 0 &&
			unaPosicion.y() < game.height()
	}

	method hayBloqueEn(unaPosicion) {
		return game.getObjectsIn(unaPosicion).any({ objeto => objeto.esPared() })
	}
}