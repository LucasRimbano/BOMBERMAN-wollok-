import wollok.game.*


class Piso {
	var property position

	method image() = "piso1.png"

	method esPared() {
		return false
	}
}

class BloqueIndestructible {
	var property position
	method image() = "indes1.png"
    method esPared() {
		return true
    }
}

class BloqueDestructible {
	var property position
	method image() = "dest1.png"

	method esPared() {
		return true
	}
}

object nivel1 {

	method agregarAlJuego() {
		(0..12).forEach({ x =>
			(0..10).forEach({ y =>
				game.addVisual(new Piso(position = game.at(x, y)))
			})
		})
		self.posicionesIndestructibles().forEach({ pos =>
			game.addVisual(new BloqueIndestructible(position = pos))
		})
		self.posicionesDestructibles().forEach({ pos =>
			game.addVisual(new BloqueDestructible(position = pos))
		})
	}

	method posicionesIndestructibles() {
		const result = []
		// Borde superior e inferior
		(0..12).forEach({ x =>
			result.add(game.at(x, 0))
			result.add(game.at(x, 10))
		})
		// Borde izquierdo y derecho 
		(1..9).forEach({ y =>
			result.add(game.at(0, y))
			result.add(game.at(12, y))
		})

		// pilares interiores: cada x par con cada y par
		[2, 4, 6, 8, 10].forEach({ x =>
			[2, 4, 6, 8].forEach({ y =>
				result.add(game.at(x, y))
			})
		})
		return result
	}

	method posicionesDestructibles() {
		return [
		
			game.at(3, 3), game.at(5, 3), game.at(7, 3), game.at(8, 3),
			
			game.at(3, 4), game.at(7, 4),
			
			game.at(3, 5), game.at(9, 5),
			
			game.at(3, 6), game.at(9, 6),
			
			game.at(4, 7), game.at(6, 7), game.at(7, 7), game.at(9, 7),
			
			game.at(3, 8), game.at(5, 8), game.at(9, 8)
		]
	}

}
