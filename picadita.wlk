 class Jugador {
	
	var equipo
	var skills
	var peso
	var fuerza
	var escoba
	var tieneQuaffle = false
	
	
	constructor(_equipo,_skills,_peso,_fuerza,_escoba){
		
		equipo = _equipo
		skills = _skills
		peso = _peso
		fuerza = _fuerza
		escoba = _escoba
		
		equipo.agregar(self)
	}
	

	method skills() = skills
	method peso() = peso
	method fuerza() = fuerza
	method escoba() = escoba
	method escoba(_escoba){escoba = _escoba}
	method equipo() = equipo
	
	method habilidad()
	
	method nivelDeReflejos() = (self.velocidad() * self.skills() / 100 )
	method nivelDeManejo()= self.skills() / self.peso() 
	
	method velocidad() = escoba.velocidadEscoba() * self.nivelDeManejo()
	

	method pierdeSkills(cantidad){ skills -= cantidad}
	method aumentarSkills(cantidad){skills += cantidad}
		
	
	method lePasaElTrapo(jugadorDos)= self.habilidad() >= (jugadorDos.habilidad() * 2)
	
	method esMasVeloz(jugadorDos)= self.velocidad() > (jugadorDos.velocidad())
	method lePasaElTrapoATodos(lista)= lista.all({jugadorContrario => self.lePasaElTrapo(jugadorContrario)})
	
	
	method esGroso() =  self.habilidad() > equipo.promedio() && self.velocidad() >= mercadoDeEscobas.velocidadMercado() 
	
	method golpeado(){
		self.pierdeSkills(2)
		escoba.golpe()
	}
	method golpeado(porQuien){
		self.golpeado()
	}
	
	method obtenerQuaffle()
	
	method poseeQuaffle()=tieneQuaffle
	method poseeQuaffle(_quaffle){tieneQuaffle = _quaffle}
	method puedePerderQuaffle()= self.poseeQuaffle()
	
		
	
	method perderQuaffle(_equipo){
		if(self.puedePerderQuaffle()){
		self.poseeQuaffle(false)
		equipo.perderQuaffle(_equipo)}else{false}
	}
	
	method hacerJugada(aQuien)
	
	
	method blancoUtil(otroEquipo)=self.esJugadorEstrella(otroEquipo)
	
	method esJugadorEstrella(otroEquipo)=equipo.jugadorEstrella(otroEquipo).contains(self)
	
	method puedeBloquear(cazador) = self.lePasaElTrapo(cazador) or suerte.tieneSuerte()
	method aumentarSkillPorBloquear(){self.aumentarSkills(3)}
}




// posiciones

class Cazador inherits Jugador{

	
	var punteria
	constructor(_equipo,_skills,_peso,_fuerza,_escoba,_punteria)=super(_equipo,_skills,_peso,_fuerza,_escoba){
		punteria = _punteria

	}
	
	method punteria() = punteria
	
	override method habilidad()= self.velocidad() + self.skills() + self.punteria() * self.fuerza() 
	
	override method golpeado(equipoContrario){
		self.perderQuaffle(equipoContrario)
		self.golpeado()
		
	}
	
	override method obtenerQuaffle(){
		if(not(self.poseeQuaffle())){
		quaffle.equipoConQuaffle(self.equipo())
		quaffle.jugadorConQuaffle(self)}}
	
	
	
	override method blancoUtil(otroEquipo)=self.poseeQuaffle() or self.esJugadorEstrella(otroEquipo)
	
	override method hacerJugada(otroEquipo){
		if (self.poseeQuaffle()){
			if(otroEquipo.puedeBloquear(self)){
				otroEquipo.bloquear(self)
				self.perderQuaffle(otroEquipo)
			}else{
				self.equipo().puntos(10)
				self.aumentarSkills(5)
				self.poseeQuaffle(false)
			}
			
		}
	}
}

class Guardian inherits Jugador{

	
	
	constructor(_equipo,_skills,_peso,_fuerza,_escoba)=super(_equipo,_skills,_peso,_fuerza,_escoba)
	
	override method nivelDeReflejos() = (self.velocidad() * self.skills() / 100 ) + 20

	 
	override method habilidad()= self.velocidad() + self.skills() + self.nivelDeReflejos() + self.fuerza() 

	override method blancoUtil(otroEquipo)=self.equipo().tieneQuaffle() or self.esJugadorEstrella(otroEquipo)

	override method aumentarSkillPorBloquear(){self.aumentarSkills(10)}
	
	override method hacerJugada(aquien){}
	
	override method obtenerQuaffle(){
		if(not(self.poseeQuaffle())){
		quaffle.equipoConQuaffle(self.equipo())
		quaffle.jugadorConQuaffle(self.equipo().jugadorMasHabilidoso(self))
	}
	}
	
	
}

class Golpeador inherits Jugador{

	var punteria
	var blancos = []
	var blanco
	
	constructor(_equipo,_skills,_peso,_fuerza,_escoba,_punteria)=super(_equipo,_skills,_peso,_fuerza,_escoba){
		punteria = _punteria
	}
	
	
	method punteria() = punteria
	override method habilidad()= self.velocidad() + self.skills() + self.punteria() + self.fuerza() 

	override method hacerJugada(equipoContrario){
		self.blancos(equipoContrario.jugadores().filter({jugadorDelOtroEquipo => jugadorDelOtroEquipo.blancoUtil(self.equipo())}))
		self.blanco( blancos.max({blancop => blancop.habilidad()}))
		if(suerte.tieneSuerte() or self.punteria() >blanco.nivelDeReflejos()){
			self.aumentarSkills(5)
			blanco.golpeado(self)
			
		}
	}
	override method obtenerQuaffle(){}
	method blancos()=blancos
	method blancos(lista){blancos=lista}
	method blanco()=blanco
	method blanco(target){blanco = target}
}

class Buscador inherits Jugador{

	var nivelDeVision
	var metrosRecorridos = 0
	var capturoSnitch = false
	var turnos = 0
	
	constructor(_equipo,_skills,_peso,_fuerza,_escoba,_vision)=super(_equipo,_skills,_peso,_fuerza,_escoba){
		nivelDeVision = _vision
	}
	
	

	method nivelDeVision() = nivelDeVision
	
	override method obtenerQuaffle(){}
	
	
	override method habilidad()= self.velocidad() + self.skills() + self.nivelDeReflejos() * self.nivelDeVision()

	override method hacerJugada(equipoContrario){
		
		if (self.encontroSnitch()){
			self.perseguirSnitch()
			if(self.capturoSnitch()){
				self.equipo().puntos(150)
				self.aumentarSkills(30)
		}
	}else{self.buscandoSnitch()}}
	
	method encontroSnitch()=suerte.tieneSuerte() or self.turnosDeBusqueda()==10
	method buscandoSnitch(){self.turnosDeBusqueda(turnos+1)}
	
	method turnosDeBusqueda(_turnos){turnos =_turnos}
	method turnosDeBusqueda()=turnos
	
	method perseguirSnitch(){
		
		self.metrosRecorridos(self.metrosRecorridos()+self.velocidad()*2)
		if(self.metrosRecorridos()>5000){
		self.capturoSnitch(true)
	}}
	
	
	method capturoSnitch()=capturoSnitch
	method capturoSnitch(valor){capturoSnitch = valor}
	
	method metrosRecorridos()=metrosRecorridos
	method metrosRecorridos(_metros){metrosRecorridos = _metros}
	
	override method golpeado(atacante){
		if (not(self.esGroso())){
			self.metrosRecorridos(0)
			self.pierdeSkills(2)
			self.turnosDeBusqueda(0)
			escoba.golpe()
			
		}else{
			self.pierdeSkills(2)
			self.turnosDeBusqueda(turnos)
			escoba.golpe()
		}
	}
	
	override method puedeBloquear(cazador)=false
	
	
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
	method golpe(){ self.salud(self.salud()*0.1)}	
}

object saetaDeFuego{
	var velocidad = 100
	method velocidadEscoba()= velocidad
	method golpe(){}
}


//equipos

object mercadoDeEscobas{
	var velocidad
	method velocidadMercado()= velocidad
	method velocidadMercado(_velocidad){velocidad = _velocidad}
	
}

class Equipo{
	var nombre
	var puntos = 0
	var jugadores = []
	var bloqueadores
	
	constructor(_nombre){
		nombre = _nombre
	}
	method jugadores()=jugadores
	method nombre() = nombre
	
	method agregar(jugador){
		jugadores.add(jugador)
	}
	
	method cantidadJugadores() = jugadores.size()
	method promedio() = jugadores.sum({unJugador => unJugador.habilidad()}) / self.cantidadJugadores()
	
	method jugadoresGrosos() = jugadores.filter({unJugador => unJugador.esGroso()})
	method pasadorDeTrapos() = jugadores.filter({unJugador,otroJugador => unJugador.lePasaElTrapo(otroJugador) && unJugador != otroJugador})
	
	method jugadorEstrella(equipoContrario)= jugadores.filter({unJugador => unJugador.lePasaElTrapoATodos(equipoContrario.jugadores())} )
	
	method jugadorMasVeloz()= jugadores.max({jugador  => jugador.velocidad() })
	
	method jugadorMasHabilidoso(guardian)= jugadores.filter({jugador1 => jugador1 != guardian}).max({jugador => jugador.habilidad()})
	method tieneQuaffle()=jugadores.any({jugador => jugador.poseeQuaffle()})
	
	
	method puedeObtenerQuaffle()=not(self.tieneQuaffle())
	
	
	method obtenerQuaffle(){
		if(self.puedeObtenerQuaffle()){
			quaffle.equipoConQuaffle(self)
			quaffle.jugadorConQuaffle(self.jugadorMasVeloz())
			
		}
	}
	
	
	method perderQuaffle(otroEquipo){otroEquipo.obtenerQuaffle()}

	method puedeBloquear(cazador){
		jugadores.sortBy({unJugador,otroJugador => unJugador.velocidad() > otroJugador.velocidad() and unJugador != otroJugador })
		bloqueadores = jugadores.filter({jugador => jugador.puedeBloquear(cazador)})
		return bloqueadores.size() > 0
	}
	
	method bloquear(cazador){
		if(self.puedeBloquear(cazador)){
		bloqueadores.map({bloqueador=> bloqueador.aumentarSkillPorBloquear()})
		cazador.pierdeSkills(3)}
	}
	
	method puntos()=puntos
	method puntos(_puntos){puntos += _puntos}
}

object quaffle{
	var equipoConQuaffle = 2
	var jugadorConQuaffle = 1
	
	method equipoConQuaffle()=equipoConQuaffle
	method equipoConQuaffle(_equipo){equipoConQuaffle = _equipo}
	
	method jugadorConQuaffle()=jugadorConQuaffle
	method jugadorConQuaffle(jugador){
		jugadorConQuaffle = jugador
		jugador.poseeQuaffle(true)
		
	}
	
	
}

object suerte {
    var tipoDeSuerte = suerteReal
    method tipoDeSuerte(_tipoDeSuerte){
        tipoDeSuerte = _tipoDeSuerte
    }
    method tieneSuerte(){
        return tipoDeSuerte.tieneSuerte()
    }
}

object suerteReal{
    method tieneSuerte() = (1..5).anyOne() == 1
}

object malaSuerte{
    method tieneSuerte() = false
}

object buenaSuerte{
    method tieneSuerte() = true
}


