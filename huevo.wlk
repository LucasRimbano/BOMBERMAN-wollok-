import wollok.game.*

object huevoCounter {
	var count = 0

	method next() {
		count += 1
		return count
	}

}

object imagenHuevoUno {
	method archivo() = "huevo1.png"
	method siguiente() = imagenHuevoDos
}

object imagenHuevoDos {
	method archivo() = "huevo2.png"
	method siguiente() = imagenHuevoUno
}

object cuentaRegresivaHuevo {
	method resultadoPara(huevo) = [huevoExplota, huevoEspera]
		.filter({ resultado => resultado.aplica(huevo) })
		.anyOne()
}

object huevoExplota {
	method aplica(huevo) = huevo.estaListoParaExplotar()
	method ejecutar(huevo) { huevo.explotar() }
}

object huevoEspera {
	method aplica(huevo) = !huevo.estaListoParaExplotar()
	method ejecutar(huevo) {}
}

object direccionesExplosion {
	method todas() = [direccionDerecha, direccionIzquierda, direccionArriba, direccionAbajo]
}

object direccionDerecha {
	method posicionDesde(posicion, distancia) = posicion.right(distancia)
}

object direccionIzquierda {
	method posicionDesde(posicion, distancia) = posicion.left(distancia)
}

object direccionArriba {
	method posicionDesde(posicion, distancia) = posicion.up(distancia)
}

object direccionAbajo {
	method posicionDesde(posicion, distancia) = posicion.down(distancia)
}

object brazoActivo {
	method expandir(explosion, direccion, distancia) {
		const posicion = direccion.posicionDesde(explosion.position(), distancia)
		const objetos = game.getObjectsIn(posicion)
		return efectoExplosion.para(objetos).aplicar(explosion, posicion, objetos)
	}
}

object brazoDetenido {
	method expandir(explosion, direccion, distancia) = self
}

object efectoExplosion {
	method para(objetos) = [efectoParedFija, efectoBloqueDestructible, efectoCaminoLibre]
		.filter({ efecto => efecto.aplica(objetos) })
		.anyOne()
}

object efectoParedFija {
	method aplica(objetos) = objetos.any({ objeto => objeto.esPared() && !objeto.esDestructible() })
	method aplicar(explosion, posicion, objetos) = brazoDetenido
}

object efectoBloqueDestructible {
	method aplica(objetos) = objetos.any({ objeto => objeto.esDestructible() })

	method aplicar(explosion, posicion, objetos) {
		objetos
			.filter({ objeto => objeto.esDestructible() })
			.forEach({ objeto => game.removeVisual(objeto) })
		explosion.agregarCelda(posicion)
		return brazoDetenido
	}
}

object efectoCaminoLibre {
	method aplica(objetos) = !objetos.any({ objeto => objeto.esPared() })

	method aplicar(explosion, posicion, objetos) {
		explosion.agregarCelda(posicion)
		return brazoActivo
	}
}

object cuentaRegresivaExplosion {
	method resultadoPara(explosion) = [explosionDesaparece, explosionContinua]
		.filter({ resultado => resultado.aplica(explosion) })
		.anyOne()
}

object explosionDesaparece {
	method aplica(explosion) = explosion.termino()
	method ejecutar(explosion) { explosion.desaparecer() }
}

object explosionContinua {
	method aplica(explosion) = !explosion.termino()
	method ejecutar(explosion) {}
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
	var ticsParaDesaparecer = 2

	method activar(explosionId) {
		id = explosionId
		self.reproducirSonido()
		self.crearCentro()
		self.expandirBrazos()
		const objetosDanados = self.objetosEnExplosion()
		self.iniciarCuentaRegresiva()
		game.schedule(450, { self.verificarDanio(objetosDanados) })
	}

	method reproducirSonido() {
		game.sound("explosion.mp3").play()
	}

	method crearCentro() {
		self.agregarCelda(position)
	}

	method expandirBrazos() {
		direccionesExplosion.todas().forEach({ direccion => self.calcularBrazo(direccion) })
	}

	method calcularBrazo(direccion) {
		brazoActivo.expandir(self, direccion, 1).expandir(self, direccion, alcance)
	}

	method iniciarCuentaRegresiva() {
		game.onTick(200, self.eventoExplosion(), { self.avanzarCuentaRegresiva() })
	}

	method avanzarCuentaRegresiva() {
		ticsParaDesaparecer -= 1
		cuentaRegresivaExplosion.resultadoPara(self).ejecutar(self)
	}

	method termino() = ticsParaDesaparecer <= 0

	method eventoExplosion() = "expl_" + id

	method desaparecer() {
		celdas.forEach({ celda => game.removeVisual(celda) })
		game.removeTickEvent(self.eventoExplosion())
	}

	method agregarCelda(posicion) {
		const celda = new CeldaExplosion(position = posicion)
		celdas.add(celda)
		game.addVisual(celda)
	}

	method objetosEnExplosion() {
		const objetos = []
		celdas.forEach({ celda =>
			game.getObjectsIn(celda.position()).forEach({ objeto =>
				objetos.add(objeto)
			})
		})
		return objetos
	}

	method verificarDanio(objetos) {
		objetos.forEach({ objeto =>
			objeto.recibirDanio()
		})
	}

}

class Huevo {
	var property position
	var id = 0
	var ticsParaExplotar = 4
	var imagen = imagenHuevoUno

	method image() = imagen.archivo()

	method esPared() = false
	method esGato() = false
	method esDestructible() = false
	method recibirDanio() {}

	method activar() {
		self.asignarId()
		self.mostrar()
		self.iniciarCuentaRegresiva()
	}

	method asignarId() {
		id = huevoCounter.next()
	}

	method mostrar() {
		game.addVisual(self)
	}

	method iniciarCuentaRegresiva() {
		game.onTick(500, self.eventoHuevo(), { self.avanzarCuentaRegresiva() })
	}

	method avanzarCuentaRegresiva() {
		ticsParaExplotar -= 1
		imagen = imagen.siguiente()
		cuentaRegresivaHuevo.resultadoPara(self).ejecutar(self)
	}

	method estaListoParaExplotar() = ticsParaExplotar <= 0

	method eventoHuevo() = "huevo_" + id

	method explotar() {
		game.removeVisual(self)
		game.removeTickEvent(self.eventoHuevo())
		const explosion = new Explosion(position = position)
		explosion.activar(id)
	}

}
