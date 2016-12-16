 class Jugador {
 	
 	var skills
  	var escoba 
 	var nombre
 	var poseeQuaffle
 	var fuerza 
 	var peso
 	var punteria
 	var vision
 	var equipo
 	var esBuscador
 	
 	
 	constructor(_nombre,_skills,_peso,_fuerza,_escoba,_punteria,_vision){
 		nombre=_nombre
 		escoba=_escoba
 		skills=_skills
 		fuerza=_fuerza
 		peso=_peso
 		vision=_vision
 		punteria=_punteria
 		equipo
 		esBuscador=false
 		poseeQuaffle=false
 	}
 	method jugadorSuperior()=self.habilidad()>=self.equipo().habilidadPromedio()
 	method nombre()=nombre
 	method nivelDeManejoDeEscoba(){return skills/peso} 
 	method velocidad(){
 		return escoba.velocidad()*self.nivelDeManejoDeEscoba()}
 	method habilidad()
 	method reflejos() 
 	method lePasaElTrapo(unJugador){
 		return self.habilidad()>=unJugador.habilidad()*2
 	}
 	method skills(){return skills}
 	method perderSkills(_puntos){
 		skills-=_puntos}
 	method punteria(){
 		return punteria}
 	method fuerza(){
 		return fuerza}
 	method vision(){
 		return vision}
 	method escoba(){
 		return escoba}
 	method jugadorVeloz()=self.velocidad()>=mercadoDeEscobas.velocidad()and self.velocidad()>50
 	method poseeQuaffle()=poseeQuaffle	
 	method poseeQuaffle(_valor){
 		poseeQuaffle=_valor}
 	method golpeadoPorBludger(){
 		skills-=2
 		self.escoba().daniarEscoba()
 		}
 		method golpeadoPorBludgerEnemiga(_equipoEnemigo){self.golpeadoPorBludger()}
 	method soyBlancoUtil(_equipoEnemigo)=self.equipo().jugadoresEstrella(_equipoEnemigo).contains(self)
 	
 	method carry(_equipo){return _equipo.jugadores().all({unJugador=>self.lePasaElTrapo(unJugador)})}
	method realizarJugada(_equipoEnemigo)
	method asignarEquipo(_equipo){equipo=_equipo}
	method equipo()=equipo 
	method agregarPuntos(_puntos){}
	method bloquear(unJugador)										
	method puedeBloquear(unJugador)= (suerte.tieneSuerte() or self.lePasaElTrapo(unJugador)) 	
	method puedeBloquear(unJugador,_suerte)= (_suerte or self.lePasaElTrapo(unJugador)) 	and unJugador.poseeQuaffle()						
	method esPortador()=false
	method esBuscador()=esBuscador
	method bloquearTest(unJugador,_suerte){if(self.puedeBloquear(unJugador,_suerte))
										{unJugador.perderQuaffle(self.equipo())
 										skills+=3
 										unJugador.perderSkills(3)}
 										
 }}
 				class PortadoresQuaffle inherits Jugador{
 	
 				constructor(_nombre,_skills,_peso,_fuerza,_escoba,_punteria,_vision)=super(_nombre,_skills,_peso,_fuerza,_escoba,_punteria,_vision){}
 				override method esPortador()=true
 				method portarQuaffle(){poseeQuaffle=true}
 				method perderQuaffle(_equipoEnemigo){poseeQuaffle=false}
				method robarQuaffle(_equipoEnemigo)
 
 
				 method posicionPortador()
 				}
 
class Guardian inherits  PortadoresQuaffle{
 	
constructor(_nombre,_skills,_peso,_fuerza,_escoba,_punteria,_vision)=super(_nombre,_skills,_peso,_fuerza,_escoba,_punteria,_vision){}
override method habilidad()= self.velocidad()+self.skills()+self.reflejos()+self.fuerza()
override method reflejos()=20+self.velocidad()*skills/100.0
override method posicionPortador()="guardian"
override method soyBlancoUtil(_equipoEnemigo)=super(_equipoEnemigo)||!self.equipo().alguienTieneQuaffle()
override method realizarJugada(_equipoEnemigo){}
override method bloquear(unJugador){ if(self.puedeBloquear(unJugador)){unJugador.perderQuaffle(self.equipo())
 										skills+=10
 										unJugador.perderSkills(3)}
 										
 	}

override method robarQuaffle(_equipoEnemigo){_equipoEnemigo.sacarQuaffle(self.equipo())
 			self.equipo().portadores().max({unJugador=>unJugador.habilidad()}).portarQuaffle()
 	}
override method golpeadoPorBludgerEnemiga(_equipoEnemigo){super(_equipoEnemigo)}
override method bloquearTest(unJugador,_suerte){if(self.puedeBloquear(unJugador,_suerte))
										{unJugador.perderQuaffle(self.equipo())
 										skills+=10
 										unJugador.perderSkills(3)}
 										}
 	}
 	
 	
  				class Cazador inherits PortadoresQuaffle{
 				constructor(_nombre,_skills,_peso,_fuerza,_escoba,_punteria,_vision)=super(_nombre,_skills,_peso,_fuerza,_escoba,_punteria,_vision){poseeQuaffle=false}
				override method habilidad()=return self.velocidad()+self.skills()+self.punteria()*self.fuerza()
 				override method reflejos()=self.velocidad()*skills/100.0
 				override method robarQuaffle(_equipoEnemigo){_equipoEnemigo.sacarQuaffle(self.equipo())
 												self.portarQuaffle()
 															}
				override method perderQuaffle(_equipoEnemigo){if (self.poseeQuaffle()){super(_equipoEnemigo)
 												_equipoEnemigo.ganarQuaffle()
 												}	
															 }
 				
 				override method posicionPortador()="cazador"
  				override method golpeadoPorBludgerEnemiga(_equipoEnemigo){
 										self.perderQuaffle(_equipoEnemigo)
 										self.golpeadoPorBludger()
 									 }
 				override method soyBlancoUtil(_equipoEnemigo)=super(_equipoEnemigo)||self.poseeQuaffle()
 				override method realizarJugada(_equipoEnemigo){if(self.poseeQuaffle()) {_equipoEnemigo.bloquear(self)}
 		
 																}
 				 method realizarJugadaTest(_equipoEnemigo,_suerte){ if (self.poseeQuaffle()){_equipoEnemigo.bloquearTest(self,!_suerte)}
 		
 																}
 				override method bloquear(unJugador){ if(self.puedeBloquear(unJugador) and unJugador.poseeQuaffle())
 					{					unJugador.perderQuaffle(self.equipo())
 										skills+=3
 										unJugador.perderSkills(3)}
 										
 					}
 				method anotar(_equipo){self.equipo().aumentarPuntaje(10) 
 				
 									self.poseeQuaffle(false)
 									_equipo.ganarQuaffle()
 				 					skills+=5
								 }
 								}
 	
 	
 	
class Golpeador inherits Jugador{
	constructor(_nombre,_skills,_peso,_fuerza,_escoba,_punteria,_vision)=super(_nombre,_skills,_peso,_fuerza,_escoba,_punteria,_vision){}
	override method habilidad()=self.velocidad()+self.skills()+self.punteria()+self.fuerza()
	override method reflejos()=self.velocidad()*skills/100.0
	override method realizarJugada(_equipoEnemigo){self.golpearBludger(_equipoEnemigo.mejorObjetivo(self.equipo()))}
	override method bloquear(unJugador){if(self.puedeBloquear(unJugador)){unJugador.perderQuaffle(self.equipo())
 										skills+=3
 										unJugador.perderSkills(3)}}
 										
method golpearBludger(unJugador){ 
 									if(unJugador.reflejos()<self.punteria()||suerte.tieneSuerte()){
 									unJugador.golpeadoPorBludgerEnemiga(self.equipo())
 										
 										skills+=5
 										
 									}
 									 
 										
 									}
method golpearBludger(unJugador,_suerte){ 
 									if(unJugador.reflejos()<self.punteria()||_suerte){
 									unJugador.golpeadoPorBludgerEnemiga(self.equipo())
 										
 										skills+=5}
 									}
 									
											 
method realizarJugada(_equipoEnemigo,_suerte){self.golpearBludger(_equipoEnemigo.mejorObjetivo(self.equipo()),_suerte)}

override method golpeadoPorBludgerEnemiga(_equipoEnemigo){super(_equipoEnemigo)}
 }
 
 
class Buscador inherits Jugador{
			var  intentos=[]
			var turnosBuscando
 			var metrosRecorridos
 			var atrapoSnitch
 			var persigueSnitch
 			var vioSnitch
 			var recuperando
 			constructor(_nombre,_skills,_peso,_fuerza,_escoba,_punteria,_vision)=super(_nombre,_skills,_peso,_fuerza,_escoba,_punteria,_vision){recuperando= false turnosBuscando=0 metrosRecorridos=0 atrapoSnitch=false persigueSnitch=false
 			vioSnitch=false
 			esBuscador=true
 				}
 			override method puedeBloquear(unJugador)=false
 			override method golpeadoPorBludgerEnemiga(_equipoEnemigo){
 														super(_equipoEnemigo)
 														if (!self.equipo().jugadoresGrosos().contains(self))
 														{turnosBuscando=0
 														intentos=intentos.filter({unValor=>!unValor})
 														self.vioSnitch(false)
 														metrosRecorridos=0}
 														else self.recuperar(true)
 																		}
 			method turnos()=turnosBuscando
 			method recuperar(_valor){recuperando=_valor}
 			method estado()=recuperando	
 			override method habilidad()=self.velocidad()+self.skills()+self.reflejos()*self.vision()
 			override method reflejos()=self.velocidad()*skills/100.0
 			override method soyBlancoUtil(_equipoEnemigo)=super(_equipoEnemigo) or (self.encontroSnitch() and self.metrosPorAlcanzar()<1000)
 			override method realizarJugada(_EquipoEnemigo){if(!self.estado()){if (!(self.encontroSnitch() or self.vioSnitch()))
 								{self.buscar(suerte.tieneSuerte())} 
 								else self.perseguirSnitch()
 			
 							}else self.recuperar(false) }
 			method realizarJugadaTest(_equipoEnemigo,_suerte){if (!(self.encontroSnitch() or self.vioSnitch()))
 								{self.buscar(_suerte)} 
 								else self.perseguirSnitch()
 		
 																}
 			method vioSnitch(_estado){vioSnitch=_estado}
 			method vioSnitch()=vioSnitch
 			method metrosPorAlcanzar()=5000-metrosRecorridos
 			method atrapoSnitch(){atrapoSnitch=true
 					skills+=30
 					self.equipo().aumentarPuntaje(150)
 					self.recorrer(-5000)
								 }
 			method buscar(_suerte){ 
 			 (self.vision()+turnosBuscando).times({intentos.add(_suerte)})
 			
 			 turnosBuscando+=1
 									}
 			method encontroSnitch()=intentos.any({booleano => booleano})
 			method recorrer(_metros){metrosRecorridos=_metros}														
 													
 			method perseguirSnitch(){
 					persigueSnitch =true 
 					metrosRecorridos+=self.velocidad()*2
 									if(metrosRecorridos<5000){
 									}
 									else self.atrapoSnitch()
 									}
  			override method bloquear(unJugador){ }
 			override method bloquearTest(unJugador,_Suerte){}	
 			override method puedeBloquear(unJugador,_suerte)=false
 								}		
 				
 
 class Escoba{
 	method velocidad()
 	method daniarEscoba()
 			}
 
 class Nimbus inherits Escoba{
 			var anioDeFabricacion
 			var salud
 			constructor(_modelo,_salud){
 					anioDeFabricacion=_modelo
 					salud=_salud
 										}
 			override method velocidad(){return (80-self.antiguedad())*salud*0.01}
 			method antiguedad(){return new Date().year()-anioDeFabricacion}
 			override method daniarEscoba(){ salud-=10}
 			method salud(){return salud}
 										}
 class SaetaDeFuego inherits Escoba{
 override	method velocidad(){return 100}
 override method daniarEscoba(){ }
  									}
class ContadorPuntos{
				var equipo
				var otroEquipo
				constructor(_equipo,_equipo1){
					equipo=0 otroEquipo=0}
				method aumentarPuntos(_equipo)		
								}
 object  mercadoDeEscobas{
 var velocidad=50
 method velocidad(){return velocidad}
 method cambiarVelocidad(_velocidad){velocidad=_velocidad}
 	
 						}
 
 
object jugador{
 	method harryPotter()= new Buscador("harry",30,60.0,80,new SaetaDeFuego(),0,2)
	
    method fredWeasley()=new Golpeador("fred",80,80.0,90,new Nimbus(2001,80),18,0)
	method milesBleatchley()=new Guardian("miles",20,80.0,50,new SaetaDeFuego(),0,0)
	method angelinaJohnson()= new Cazador("angelina",40,55.0,40,new SaetaDeFuego(),3,0)
	method katieBell()= new Cazador("katie",45,60.0,30,new SaetaDeFuego(),4,0)
	method georgeWeasley()= new Golpeador("george",70,80.0,70,new Nimbus(2001,50),17,0)
	method ginnyWeasley()= new Cazador("ginny",50,50.0,40,new Nimbus(2000,50),5,0)
	method ronWeasley()= new Guardian("ron",30,60.0,50,new Nimbus(2000,50),0,0)
	method adrianPaucey()= new Cazador("adrian",30,80.0,70,new Nimbus(2000,70),4,0)
	method vincentCrabbe()= new Golpeador("vincent",80,75.0,80,new SaetaDeFuego(),8,0)
	method grahamMontague()= new Cazador("graham",35,65.0,85,new SaetaDeFuego(),6,0)
	method gregoryGoyle()= new Golpeador("gregory",70,65.0,90,new SaetaDeFuego(),15,0)
	method warrington()= new Cazador("warrington",32,50.0,70,new SaetaDeFuego(),5,0)
	method dracoMalfoy()= new Buscador("draco",27,50.0,30,new Nimbus(2001,100),0,7)
	method nuevoRon()=new Guardian("ron",30,60.0,50,new Nimbus(2016,100),0,0)}
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



class ElEquipoYaPoseeLaQuaffle inherits wollok.lang.Exception{
 	var equipo
 	constructor(_equipo){equipo=_equipo}
 }
 class ElQuePoseeLaPelotaNoEsCazador inherits wollok.lang.Exception{
 	var equipo
 	constructor(_equipo){equipo=_equipo}
 }
 class Equipo{
 	var jugadores
 	var puntaje
 	constructor(_jugadores){
 		jugadores=_jugadores
 		puntaje=0
 		self.asignarEquipo()
 		 	}
 method obtenerQuaffle(equipoEnemigo){if(!self.alguienTieneQuaffle())
 										{equipoEnemigo.sacarQuaffle(self)
 										self.ganarQuaffle()}
 										}
 method puedeRobar()=!self.alguienTieneQuaffle()
 method objetivosUtiles(_equipoEnemigo)=jugadores.filter({unJugador=>unJugador.soyBlancoUtil(_equipoEnemigo)})
 method mejorObjetivo(_equipo)=self.objetivosUtiles(_equipo).max({unJugador=>unJugador.habilidad()})
 method jugadoresGrosos()= self.jugadoresSuperiores().filter({unJugador=>unJugador.jugadorVeloz() 	})
 	
 method jugadorEstrella(_equipo){return jugadores.any({unJugador=>unJugador.carry(_equipo)})}
 method jugadoresEstrella(_equipo)= jugadores.filter({unJugador=>unJugador.carry(_equipo)})
 	
 method jugadorMasRapido()=jugadores.max({unJugador=>unJugador.velocidad()})
 method cazadorMasRapido()=self.cazadores().max({unJugador=>unJugador.velocidad()})
 	
 method portadores()=jugadores.filter({unJugador=>unJugador.esPortador()})
 method cazadores()=jugadores.filter({unJugador=>unJugador.esPortador() and unJugador.posicionPortador()=="cazador"}) 	
 method jugadoresSuperiores()= jugadores.filter({unJugador=>unJugador.jugadorSuperior()})
 	
 method jugadores()= jugadores
 	 	
 method habilidadPromedio()= jugadores.map({unJugador=>unJugador.habilidad()}).sum()/7.0
 	
	
 method asignarEquipo(){jugadores.forEach({unJugador=>unJugador.asignarEquipo(self)})}
 	
 method alguienTieneQuaffle()=jugadores.any({unJugador=>unJugador.poseeQuaffle()})

 method sacarQuaffle(_equipo){self.portadores().forEach({unJugador=>unJugador.perderQuaffle(_equipo)})}
 	
 method quienTieneLaQuaffle(){return jugadores.find({unJugador=>unJugador.poseeQuaffle()})}
 method aumentarPuntaje(_puntos){puntaje+=_puntos}
 method puntaje()=puntaje
 method ganarQuaffle(){self.cazadorMasRapido().portarQuaffle()}
 method buscarBloqueadores(unJugador)=jugadores.filter({otroJugador=>!otroJugador.esBuscador()})
 method buscarBloqueadores(unJugador,_suerte)=jugadores.filter({otroJugador=>otroJugador.puedeBloquear(unJugador,_suerte)})
 method mejorBloqueadorTest(unJugador,_suerte){if(self.buscarBloqueadores(unJugador,_suerte).size()>0){return self.buscarBloqueadores(unJugador,_suerte).max({jugador=>jugador.velocidad()})}
 												else return []
 }

 method bloquear(unJugador){ if (self.buscarBloqueadores(unJugador).size()>0)
 												{self.buscarBloqueadores(unJugador).forEach({jugador=>jugador.bloquear(unJugador)})
 													if(unJugador.poseeQuaffle()){unJugador.anotar(self)}
 												}
 										else {unJugador.anotar(self) }		
 										}
 								
 method bloquearTest(unJugador,_suerte){ if (self.buscarBloqueadores(unJugador,_suerte).size()>0)
 												{self.buscarBloqueadores(unJugador).forEach({jugador=>jugador.bloquearTest(unJugador,_suerte)})
 													if(unJugador.poseeQuaffle()){unJugador.anotar(self)}
 												}
 												else {unJugador.anotar(self) }	}
 																		
 		
 
}
