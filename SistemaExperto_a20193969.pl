:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- pce_image_directory('./imagenes').
:- dynamic color/2.

resource(portada, image, image('portada.jpg')).
resource(guepardo, image, image('guepardo.jpg')).
resource(tigre, image, image('tigre.jpg')).
resource(pinguino, image, image('pinguino.jpg')).
resource(albatro, image, image('albatro.jpg')).

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
	new(@texto, label(nombre, 'Segun la respuestas dadas tendra su resultado : ',font('times','roman',20))),
	new(@respl, label(nombre, '',font('times','roman',24))),
	new(Salir, button('Salir', and(message(Menu,destroy), message(Menu, free)))),
	new(@boton_comenzar, button('Comenzar', message(@prolog, boton_comenzares))),
	new(@boton_extincion, button('En extinción?', message(@prolog, boton_comenzares2))),
	send(Menu, append(L)), new(@btncarrera, button('¿Animal?')),
    new(@lblExp1, label(nombre,'',font('times','roman',14))),
	send(Menu,display,L,point(100,20)),
	send(Menu,display,@boton_comenzar,point(300,500)),
	send(Menu,display,@boton_extincion,point(450,500)),
	send(Menu,display,@texto,point(300,300)),
	send(Menu,display,Salir,point(900,600)),
	send(Menu,display,@respl,point(300,350)),
	send(Menu,open_centered).

animales(guepardo):- 
	guepardo,!.	
	
animales(tigre):- 
	tigre,!.
	
animales(pinguino):-pinguino,!.
animales(albatro):-albatro,!.
animales('No estoy entrenado para darte ese diagnostico').

guepardo :-
	es_guepardo,
	pregunta('Es carnívoro?'),
	pregunta('Es un animal solitario?'),
	pregunta('Es mamifero?').

tigre :-
	es_tigre,
	pregunta('Tiene rayas en la piel?'),
	pregunta('Tiene hambre excesiva?'),
	pregunta('Tiene perdida de peso inexplicable?').

pinguino :-
	es_pinguino,
	pregunta('Es Carnívoro?'),
	pregunta('Vive en clima frio?'),
	pregunta('Suele permanecer en grupos ?'),
	pregunta('Mide 1,20 centímetros de alto?'),
	pregunta('Pesa unos 40 kg?').

albatro :-
	es_albatro,
	pregunta('¿Es un ave?'),
	pregunta('¿Es un buen volador?'),
	pregunta('¿color rojizo?'),
	pregunta('¿Presenta heces de color negro o con sangrado?'),
	pregunta('¿Tiene náuseas?').

%Base de datos de extincion
extincion :-
	peligro_extincion,
	pregunta('¿Menos de 500  individuos?'),
	pregunta('¿Es un ave?').
	

es_guepardo:- pregunta("Es veloz?"),!.
es_tigre:- pregunta("come carne?"),!.
es_pinguino:- pregunta('Tiene plumas?'),!.
es_albatro:-pregunta('Es un ave?'),!.

:-dynamic si/1,no/1.

preguntar(Problema):-new(Di, dialog('Examen')),
	new(L2, label(texto,'Responde las siguientes preguntas')),
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
                          send(@tratam, display,@lblExp1,point(70,51)),
						  send(@lblExp1, selection(X)),
                          adivinar_animal(X),
                          send(@tratam, open_centered).
						  
adivinar_animal(X):- send(@lblExp1,selection('El animal es:')),
                 mostrar_imagen_animal(@tratam,X).
				 
						  
boton_comenzares :-lim,
	send(@boton_comenzar,free),
	send(@btncarrera,free),
	animales(Enter),
	send(@texto, selection('De acuerdo con sus respuestas,el animal es :')),
	send(@respl, selection(Enter)),	
	mostrar_animal(Enter),
	limpiar.
	
boton_comenzares2 :-lim,
	send(@boton_extincion,free),
	send(@btncarrera,free),
	animales(Enter),
	send(@texto, selection('De acuerdo con sus respuestas,el riesgo de extincion es :')),
	send(@respl, selection(Enter)),
	limpiar.


lim:- send(@respl, selection('')).

limpiar2:-
	send(@texto,free),
	send(@respl,free),
	send(@boton_extincion,free),
	send(@boton_comenzar,free).

:-crea_interfaz_inicio.