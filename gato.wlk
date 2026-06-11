import wollok.game.*
import colisiones.*
import pepita.*
import mapa.*
import movimientos.*

class ComportamientoMovimiento {
    method mover(gato) {}
}

object movimientoGatoVivo inherits ComportamientoMovimiento {
    override method mover(gato) {
        const validas = gato.movimientosValidos()
        if (!validas.isEmpty()) {
            gato.ejecutarMovimiento(validas.anyOne())
        }
    }
}

object movimientoGatoMuerto inherits ComportamientoMovimiento {}

class ComportamientoDanio {
    method recibirDanio(gato) {}
    method estaVivo() = false
}

object danioGatoVivo inherits ComportamientoDanio {
    override method recibirDanio(gato) {
        gato.morir()
        game.removeVisual(gato)
        nivelManager.gatoMurio()
    }
    override method estaVivo() = true
}

object danioGatoMuerto inherits ComportamientoDanio {}

class Gato {
    var property position
    const property tipo
    var property direccion = "fren"
    var estadoMovimiento = movimientoGatoVivo
    var estadoDanio = danioGatoVivo

    method image() = tipo + direccion + ".png"

    method esPared() = false
    method esGato() = true
    method esDestructible() = false

    method estaVivo() = estadoDanio.estaVivo()

    method recibirDanio() { estadoDanio.recibirDanio(self) }

    method mover() { estadoMovimiento.mover(self) }

    method morir() {
        estadoMovimiento = movimientoGatoMuerto
        estadoDanio = danioGatoMuerto
    }

    method movimientosValidos() {
        return movimientos.todos()
            .filter({ mov => colisiones.puedeMoverA(mov.posicionDesde(position, 1)) })
    }

    method ejecutarMovimiento(mov) {
        position = mov.posicionDesde(position, 1)
        direccion = mov.direccion()
        if (position == pepita.position()) pepita.perderVida()
    }

}