class Movimiento {
    method posicionDesde(posicion, distancia) = posicion
    method direccion() = ""
}

object movimientoDerecha inherits Movimiento {
    override method posicionDesde(posicion, distancia) = posicion.right(distancia)
    override method direccion() = "der"
}

object movimientoIzquierda inherits Movimiento {
    override method posicionDesde(posicion, distancia) = posicion.left(distancia)
    override method direccion() = "izq"
}

object movimientoArriba inherits Movimiento {
    override method posicionDesde(posicion, distancia) = posicion.up(distancia)
    override method direccion() = "tras"
}

object movimientoAbajo inherits Movimiento {
    override method posicionDesde(posicion, distancia) = posicion.down(distancia)
    override method direccion() = "fren"
}

object movimientos {
    method todos() = [movimientoDerecha, movimientoIzquierda, movimientoArriba, movimientoAbajo]
}