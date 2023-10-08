class NaveEspacial {
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	const velocidadMaxima = 100000
	
	method acelerar(cuanto) {
		velocidad = (velocidad + cuanto).min(velocidadMaxima)
	}
	
	method desacelerar(cuanto) {
		velocidad = (velocidad - cuanto).max(0)
	}
	
	method irHaciaElSol() {
		direccion = 10
	}
	
	method escaparDelSol() {
		direccion = -10
	}
	
	method ponerseParaleloAlSol() {
		direccion = 0
	}
	
	method acercarseUnPocoAlSol() {
		direccion = (direccion+1).min(10)
	}
	
	method alejarseUnPocoDelSol() {
		direccion = (direccion-1).max(-10)
	}
	
	method cargarCombustible(cantidad) {
		combustible += cantidad
	}
	
	method descargarCombustible(cantidad) {
		combustible = (combustible - cantidad).max(0)
	}
	
	method prepararViaje() {
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method estaTranquila() {
		return combustible >= 4000 && velocidad <= 12000
	}
	
	method escapar()
	method avisar()
	
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	
	method tienePocaActividad()
	
	method estaRelajada() {
		return self.estaTranquila() && self.tienePocaActividad()
	}
}

class NaveBaliza inherits NaveEspacial {
	var color
	var seCambioColor = false

	method color() = color
	
	method cambiarColorDeBaliza(nuevoColor) {
		seCambioColor = true
		color = nuevoColor
	}
	
	override method prepararViaje() {
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	
	override method estaTranquila() {
		return super() && color != "rojo"
	}
	
	override method avisar() {
		self.cambiarColorDeBaliza("rojo")
	}
	
	override method escapar() {
		self.irHaciaElSol()
	}
	
	override method tienePocaActividad() {
		return !seCambioColor
	}
	
}

class NavePasajeros inherits NaveEspacial {
	var cantidadPasajeros
	var racionesComida = 0
	var racionesBebida = 0
	var racionesComidaRepartidas = 0
	var racionesBebidaRepartidas = 0
	
	method cargarComida(cantidad) {
		racionesComida += cantidad
	}

	method descargarComida(cantidad) {
		racionesComida = (racionesComida - cantidad).max(0)
	}
	
	method cargarBebidas(cantidad) {
		racionesBebida += cantidad
	}

	method descargarBebidas(cantidad) {
		racionesBebida = (racionesBebida - cantidad).max(0)
	}
	
	override method prepararViaje() {
		self.cargarComida(4 * cantidadPasajeros)
		self.cargarBebidas(6 * cantidadPasajeros)
		super()
	}
	
	method darComidaAPasajeros(raciones) {
		const racionesDisponibles = (racionesComida - raciones).max(0)
		
		racionesComidaRepartidas += racionesDisponibles
		racionesComida -= racionesDisponibles 
	}

	method darBebidaAPasajeros(raciones) {
		const racionesDisponibles = (racionesBebida - raciones).max(0)
		
		racionesBebidaRepartidas += racionesDisponibles
		racionesBebida -= racionesDisponibles 
	}
	
	override method avisar() {
		self.darComidaAPasajeros(1)
		self.darBebidaAPasajeros(2)
	}
	
	override method escapar() {
		self.acelerar(velocidad)
	}
	
	override method tienePocaActividad() {
		return racionesComidaRepartidas <= 50
	}
	
}

class NaveCombate inherits NaveEspacial {
	var invisible = false
	var misilesDesplegados = false
	const mensajes = []
	
	method ponerseVisible() {
		invisible = false
	}
	
	method ponerseInvisible() {
		invisible = true
	}
	
	method estaInvisible() = invisible
	
	method desplegarMisiles() {
		misilesDesplegados = true
	}
	
	method replegarMisiles() {
		misilesDesplegados = false
	}
	
	method misilesDesplegados() = misilesDesplegados
	
	method emitirMensaje(mensaje) {
		mensajes.add(mensaje)
	}
	
	method mensajesEmitidos() = mensajes.size()
	
	method primerMensajeEmitido() = mensajes.first()
	
	method emitioMensajesDeMasDe(cantidadCaracteres) = mensajes.any({ m => m.size() > cantidadCaracteres })
	
	method esEscueta() = !self.emitioMensajesDeMasDe(30) 
	
	override method prepararViaje() {
		self.ponerseVisible()
		self.replegarMisiles()
		self.emitirMensaje("Saliendo en misión")
		super()
		self.acelerar(15000)
	}
	
	override method estaTranquila() {
		return super() && !self.misilesDesplegados()
	}

	override method avisar() {
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}

	override method tienePocaActividad() {
		return self.esEscueta()
	}
	
}

class NaveHospital inherits NavePasajeros {
	var tienePreparadoQuirofano = false
	override method estaTranquila() {
		return super() && !tienePreparadoQuirofano
	}
	
	method prepararQuirofano() {
		tienePreparadoQuirofano = true
	}
	
	method liberarQuirofano() {
		tienePreparadoQuirofano = false
	}

	override method recibirAmenaza() {
		super()
		self.prepararQuirofano()
	}
	
}

class NaveCombateSigilosa inherits NaveCombate {	
	override method estaTranquila() {
		return super() && !self.estaInvisible()
	}
	
	override method escapar() {
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}





