class Jugador {
	
	var equipo
	var skills
	var peso
	var fuerza
	var escoba
	
	
	constructor(_equipo,_skills,_peso,_fuerza,_escoba){
		
		equipo = _equipo
		skills = _skills
		peso = _peso
		fuerza = _fuerza
		escoba = _escoba
		
		equipo.agregar(self)
	}
	

	method skills()
	method peso()
	method fuerza()
	method escoba()
	
	method habilidad()
	
	
	method nivelDeManejo()= self.skills() / self.peso() 
	
	method velocidad() = escoba.velocidadEscoba() * self.nivelDeManejo()
	
	
	
	
	
	
	
	method pierdeSkills(cantidad){ skills -= cantidad}
		
	
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




// posiciones

class Cazador inherits Jugador{

	
	var punteria
	constructor(_equipo,_skills,_peso,_fuerza,_escoba,_punteria)=super(_equipo,_skills,_peso,_fuerza,_escoba){
		punteria = _punteria

	}
	
	method punteria() = punteria
	override method skills() = skills
	override method peso() = peso
	override method fuerza() = fuerza
	override method escoba() = escoba
	override method habilidad()= self.velocidad() + self.skills() + self.punteria() * self.fuerza() 
}

class Guardian inherits Jugador{

	var reflejos
	
	constructor(_equipo,_skills,_peso,_fuerza,_escoba)=super(_equipo,_skills,_peso,_fuerza,_escoba)
	
	method nivelDeReflejos() = (self.velocidad() * self.skills() / 100 )+ 20

	 method reflejos(){ 
		reflejos = (self.velocidad() * skills * 0.01)
		return reflejos
	}
	override method skills() = skills
	override method peso() = peso
	override method fuerza() = fuerza
	override method escoba() = escoba
	override method habilidad()= self.velocidad() + self.skills() + self.nivelDeReflejos() + self.fuerza() 

	
}

class Golpeador inherits Jugador{

	var punteria
	
	constructor(_equipo,_skills,_peso,_fuerza,_escoba,_punteria)=super(_equipo,_skills,_peso,_fuerza,_escoba){
		punteria = _punteria
	}
	
	

	override method skills() = skills
	override method peso() = peso
	override method fuerza() = fuerza
	override method escoba() = escoba
	method punteria() = punteria
	override method habilidad()= self.velocidad() + self.skills() + self.punteria() + self.fuerza() 

	
}

class Buscadores inherits Jugador{

	var nivelDeVision
	var reflejos
	
	constructor(_equipo,_skills,_peso,_fuerza,_escoba,_vision)=super(_equipo,_skills,_peso,_fuerza,_escoba){
		nivelDeVision = _vision
	}
	
	method nivelDeReflejos() = (self.velocidad() * self.skills() / 100 )

	method nivelDeVision() = nivelDeVision
	
	method reflejos(){ 
		reflejos = (self.velocidad() * skills * 0.01)
		return reflejos
	}
	override method skills() = skills
	override method peso() = peso
	override method fuerza() = fuerza
	override method escoba() = escoba
	override method habilidad()= self.velocidad() + self.skills() + self.nivelDeReflejos() * self.nivelDeVision()

	
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


//equipos

class Equipo{
	var nombre
	//var puntos = 0
	var jugadores = []
	
	constructor(_nombre){
		nombre = _nombre
	}
	method nombre() = nombre
	//method puntos() = puntos
	//method sumarPuntos(sumar){puntos += sumar}
	
	method agregar(jugador){
		jugadores.add(jugador)
	}

}




