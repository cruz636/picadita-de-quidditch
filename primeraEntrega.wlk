class Jugador {
	
	var equipo
	var posicion 
	var peso
	var skills
	var escoba
	var fuerza
	var reflejos
	var punteria
	var vision
	
	constructor(_equipo,_posicion,_escoba,_peso,_skills,_fuerza){
		
		equipo = _equipo
		posicion = _posicion
		escoba = _escoba
		peso =_peso
		skills = _skills
		fuerza = _fuerza
		
	}
	
	method punteria() = punteria
	method vision() = vision
	method punteria(_punteria){punteria = _punteria}
	method vision(_vision){vision = _vision}
	

	method nivelDeManejo()= self.skills() / self.peso() // para dividir poner flotantes (ej 2.0)
	
	method velocidad() = escoba.velocidadEscoba() * self.nivelDeManejo()
	
	method habilidad()= posicion.habilidad(self)
	
	method reflejos(){ 
		reflejos = (self.velocidad() * skills * 0.01)
		return reflejos
	}
	
	
	method fuerza(){return fuerza}
	method skills(){return skills}
	method pierdeSkills(cantidad){ skills -= cantidad}
	method peso(){return peso}
	
	
	method lePasaElTrapo(jugadorDos)= self.habilidad() > (jugadorDos.habilidad() * 2)
	method golpeado(){ 
		if (escoba == saetaDeFuego){
			self.pierdeSkills(2)
		}
		else{
			self.pierdeSkills(2)
			escoba.salud(escoba.salud() - 0.1)}
		
	}
}

//escobas

class Nimbus{
	var salud
	var anioDeFabricacion
	var anioActual = new Date().year()
	
	constructor(_salud,_anioDeFabricacion){
		salud = _salud
		anioDeFabricacion = _anioDeFabricacion
	}
	
	
	method salud()=salud	
	method salud(_salud2){salud = _salud2}
	
	method velocidadEscoba()= (80 - (anioActual-anioDeFabricacion))*self.salud()	

}

object saetaDeFuego{
	var velocidad = 100
	method velocidadEscoba()= velocidad
}



// posiciones

object cazador{
	method habilidad(jugador)= jugador.velocidad() + jugador.skills() + jugador.punteria() * jugador.fuerza() 
}

object guardian{
	var reflejos
	method reflejos(jugador){
		reflejos = jugador.reflejos() + 20 }
		
	method habilidad(jugador) = jugador.velocidad() + jugador.skills() + reflejos + jugador.fuerza()
}

object golpeador{
	method habilidad(jugador) = jugador.velocidad() + jugador.skills() + jugador.punteria() + jugador.fuerza()
}

object buscador{
	
	method habilidad(jugador)= jugador.velocidad() + jugador.skills() + jugador.reflejos() + jugador.vision()
}

//equipos

class Equipo{
	var nombre
	var puntos = 0
	var jugadores = []
	
	constructor(_nombre){
		nombre = _nombre
	}
	method nombre() = nombre
	method puntos() = puntos
	method sumarPuntos(sumar){puntos += sumar}
	
	method agregar(jugador){
		jugadores.add(jugador)
	}

}
