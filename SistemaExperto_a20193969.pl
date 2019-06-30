:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- pce_image_directory('./imagenes').
:- dynamic color/2.
:- encoding(utf8).

resource(portada, image, image('portada.jpg')).
resource(guepardo, image, image('guepardo.jpg')).
resource(tigre, image, image('tigre.jpg')).
resource(pinguino, image, image('pinguino.jpg')).
resource(albatro, image, image('albatro.jpg')).
resource(oso_panda, image, image('oso_panda.jpg')).

mostrar_imagen(Pantalla, Imagen) :- new(Figura, figure),
								 new(Bitmap, bitmap(resource(Imagen),@on)),
								 send(Bitmap, name, 1),
								 send(Figura, display, Bitmap),
								 send(Figura, status, 1),
								 send(Pantalla, display,Figura,point(100,80)).
								 
mostrar_imagen_animal(Pantalla, Imagen) :-new(Figura, figure),
                                     new(Bitmap, bitmap(resource(Imagen),@on)),
                                     send(Bitmap, name, 1),
                                     send(Figura, display, Bitmap),
                                     send(Figura, status, 1),		
                                     send(Pantalla, display,Figura,point(20,100)).					 
							 
crea_interfaz_inicio:-
	new(Menu, dialog('Averigua si el animal se encuentra en peligro de extinción', size(1000,1000))),	
	mostrar_imagen(Menu, portada),		
	new(L, label(nombre, '')),
	new(@texto_mostrar_animal, label(nombre, 'Según la respuestas dadas tendra su resultado ',font('times','roman',26))),
	new(@texto_mostrar_situacion, label(nombre, ' ',font('times','roman',26))),
	new(@respl, label(nombre, '',font('times','roman',26))),
	new(@resp2, label(nombre, '',font('times','roman',26))),
	new(Salir, button('Salir', and(message(Menu,destroy), message(Menu, free)))),
	new(@boton_comenzar, button('Comenzar', message(@prolog, boton_comenzares))),
	new(@boton_extincion, button('', message(@prolog, boton_comenzares2))),
    new(@lblExp1, label(nombre,'',font('times','roman',24))),
    new(@lblExp2, label(nombre,'',font('times','roman',24))),
	
	send(Menu, append(L)), new(@btncarrera, button('¿Animal?')),
	send(Menu,display,L,point(100,20)),
	send(Menu,display,@texto_mostrar_animal,point(300,150)),
	send(Menu,display,@respl,point(300,200)),	
	send(Menu,display,@texto_mostrar_situacion,point(300,250)),
	send(Menu,display,@resp2,point(300,300)),
	send(Menu,display,@boton_extincion,point(300,400)),
	send(Menu,display,@boton_comenzar,point(300,400)),
	send(Menu,display,Salir,point(900,600)),
	send(Menu,open_centered).

animales(guepardo):- guepardo,!.
animales(tigre):- tigre,!.	
animales(pinguino):-pinguino,!.
animales(albatro):-albatro,!.
animales(oso_panda):-oso_panda,!.
animales('No puedo reconocer el animal descrito').

guepardo :-
	es_guepardo,
	pregunta('¿Vive en África?'),
	pregunta('¿Es carnívoro?'),
	pregunta('¿Tiene manchas negras en la piel?'),
	pregunta('¿Es polígamo?').

tigre :-
	es_tigre,
	pregunta('¿Vive en Asia?'),
	pregunta('¿Es un animal solitario?'),
	pregunta('¿Es el felino más grande del mundo?').

pinguino :-
	es_pinguino,
	pregunta('¿Vive en todos los continentes?'),
	pregunta('¿Es carnívoro?'),
	pregunta('¿Suele permanecer en grupos?'),
	pregunta('¿Mide 1,20 centímetros de alto?'),
	pregunta('¿Pesa unos 40 kg?').

albatro :-
	es_albatro,
	pregunta('¿Viven en el hemisferio Sur?'),
	pregunta('¿Es un ave acuática?'),
	pregunta('¿Tiene plumaje blanco?'),
	pregunta('¿Las alas presentan una gran cantidad de plumas negras?').
	
oso_panda :-
	es_oso_panda,
	pregunta('¿Es nativo de China?'),
	pregunta('¿Tiene pelaje negro y blanco?'),
	pregunta('¿Es un buen trepador?').

es_guepardo:- pregunta("¿Es muy veloz?"),!.
es_tigre:- pregunta("¿Tiene rayas negras en la piel?"),!.
es_pinguino:- pregunta('¿Vive en clima frío?'),!.
es_albatro:-pregunta('¿Es un buen volador?'),!.
es_oso_panda:-pregunta('¿Su comida favorita es el bambú?'),!.

%Base de datos de extincion
extincion(riesgo_bajo):-riesgo_bajo,!.
extincion(anemazado):-anemazado,!.
extincion(en_peligro):-en_peligro,!.
extincion(extinto):-extinto,!.
extincion('No puedo determinar la situación del animal').

riesgo_bajo :-
	esta_riesgo_bajo,
	pregunta('¿En común encontralo en estado salvaje?'),
	pregunta('¿Crecimiento de la población sin la ayuda del hombre?').
	
anemazado :-
	esta_anemazado,
	pregunta('¿Población menor a 5000 individuos? '),
	pregunta('¿Pocos en estado salvaje?').
	
en_peligro :-
	esta_en_peligro,
	pregunta('¿Población menor a 400 individuos?'),
	pregunta('¿Hábitat destruido?').
	
extinto :-
	es_extinto,
	pregunta('¿Han pasado cincuenta años sin que una haya sido vista?').
	
esta_riesgo_bajo:- pregunta("¿Crecimiento constante de su población?"),!.
esta_anemazado:- pregunta('¿La actividad humana merma su población?'),!.
esta_en_peligro:- pregunta("¿Solo se puede ver en cautiverio?"),!.
es_extinto:- pregunta("¿No se puede encontrar especies?"),!.

:-dynamic si/1,no/1.

preguntar(Problema):-new(Di, dialog('Examen')),
	new(L2, label(texto_mostrar_animal,'Responde las siguientes preguntas')),
	new(La, label(prob,Problema)),

	new(B1,button(si,and(message(Di,return,si)))),
	new(B2,button(no,and(message(Di,return,no)))),

	send(Di,append(L2)),
	send(Di,append(La)),
	send(Di,append(B1)),
	send(Di,append(B2)),

	send(Di,default_button,si),
	send(Di,open_centered),
	get(Di,confirm,Answer),
	write(Answer),send(Di,destroy),	

	((Answer==si)->assert(si(Problema)); assert(no(Problema)),fail).

pregunta(S):- (si(S)->true; (no(S)->fail;preguntar(S))).
limpiar:- retract(si(_)),fail.
limpiar:- retract(no(_)),fail.
limpiar.

mostrar_animal(X):-new(@tratam, dialog('Sistema experto', size(500,500))),
                          send(@tratam, display,@lblExp1,point(70,10)),
                          send(@tratam, display,@lblExp2,point(70,60)),
						  send(@lblExp1, selection(X)),
						  send(@lblExp2, selection(X)),
                          adivinar_animal(X),
                          send(@tratam, open_centered).
						  
adivinar_animal(X):- 
				send(@lblExp1,selection('El animal es : ')),
				send(@lblExp2,selection(X)),
                mostrar_imagen_animal(@tratam,X).
				 
						  
boton_comenzares :-lim,
	send(@boton_comenzar,free),
	send(@btncarrera,free),
	animales(Enter),
	send(@texto_mostrar_animal, selection('De acuerdo con sus respuestas,el animal es :')),
	send(@respl, selection(Enter)),	
	mostrar_animal(Enter),
	send(@boton_extincion, selection('¿En extinción?')),
	limpiar.
	
boton_comenzares2 :-
	send(@boton_extincion,free),
	extincion(Enter),
	send(@resp2, selection(Enter)),	
	send(@texto_mostrar_situacion, selection('La situación de la especie es : ')),
	limpiar.

lim:- send(@respl, selection('')).

limpiar2:-
	send(@texto_mostrar_animal,free),
	send(@texto_mostrar_situacion,free),
	send(@respl,free),
	send(@resp2,free),
	send(@boton_extincion,free),
	send(@boton_comenzar,free).

:-crea_interfaz_inicio.