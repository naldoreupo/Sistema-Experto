:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
main:-
	new(Menu, dialog('Averigua si el animal se encuentra en peligro de extinción', size(500,500))),
	new(L, label(nombre, 'Bienvenidos a su sistema')),
	new(@texto, label(nombre, 'Segun la respuestas dadas tendra su resultado: ')),
	new(@respl, label(nombre, '')),
	new(Salir, button('Salir', and(message(Menu,destroy), message(Menu, free)))),
	new(@boton, button('¿Que animal es?', message(@prolog, botones))),
	new(@boton2, button('¿En extinción?', message(@prolog, botones2))),
	send(Menu, append(L)), new(@btncarrera, button('¿Diagnotico?')),
	send(Menu,display,L,point(100,20)),
	send(Menu,display,@boton,point(30,150)),
	send(Menu,display,@boton2,point(180,150)),
	send(Menu,display,@texto,point(50,100)),
	send(Menu,display,Salir,point(20,400)),
	send(Menu,display,@respl,point(20,130)),
	send(Menu,open_centered).

enfermedades(guepardo):- guepardo,!.
enfermedades(tigre):- tigre,!.
enfermedades(pinguino):-pinguino,!.
enfermedades(albatro):-albatro,!.
enfermedades('No estoy entrenado para darte ese diagnostico').


guepardo :-
	es_guepardo,
	pregunta('¿Es carnívoro?'),
	pregunta('¿Es un animal solitario?'),
	pregunta('¿Es mamifero?'),

tigre :-
	es_tigre,
	pregunta('Tiene rayas en la piel?'),
	pregunta('Tiene hambre excesiva?'),
	pregunta('Tiene perdida de peso inexplicable?'),
	pregunta('Se siente fatigado?'),
	pregunta('Tiene irritabilidad?'),
	pregunta('Tiene vision borrosa?').

pinguino :-
	es_pinguino,
	pregunta('Es Carnívoro?'),
	pregunta('Vive en clima frío?'),
	pregunta('¿Suele permanecer en grupos ?'),
	pregunta('¿Mide 1,20 centímetros de alto?'),
	pregunta('¿Pesa unos 40 kg?').

albatro :-
	es_albatro,
	pregunta('¿Es un ave?'),
	pregunta('¿Es un buen volador?'),
	pregunta('¿color rojizo?'),
	pregunta('¿Presenta heces de color negro o con sangrado?'),
	pregunta('¿Tiene náuseas?').

%
extincion :-
	peligro_extincion,
	pregunta('¿Menos de 500  individuos?'),
	pregunta('¿Es un ave?').
	

%desconocido :- se_desconoce_enfermedad.

es_guepardo:- pregunta("¿Es rápido?"),!.
es_tigre:- pregunta("¿Es carnivoro?"),!.
es_pinguino:- pregunta('¿ Tiene plumas?'),!.
es_albatro:-pregunta('¿ Es un ave ?'),!.

:-dynamic si/1,no/1.

preguntar(Problema):-new(Di, dialog('Examen ')),
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


botones :-lim,
	send(@boton,free),
	send(@btncarrera,free),
	enfermedades(Enter),
	send(@texto, selection('De acuerdo con sus respuestas,el animal es :')),
	send(@respl, selection(Enter)),
	new(@boton, button('Iniciar su evaluación', message(@prolog, botones))),
	send(Menu,display,@boton,point(40,50)),
	send(Menu,display,@btncarrera,point(20,50)),
	limpiar.
	
botones2 :-lim,
	send(@boton2,free),
	send(@btncarrera,free),
	enfermedades(Enter),
	send(@texto, selection('De acuerdo con sus respuestas,el riesgo de extincion es :')),
	send(@respl, selection(Enter)),
	new(@boton2, button('Iniciar su evaluación', message(@prolog, botones2))),
	send(Menu,display,@boton2,point(40,50)),
	send(Menu,display,@btncarrera,point(20,50)),
	limpiar.


lim:- send(@respl, selection('')).

limpiar2:-
	send(@texto,free),
	send(@respl,free),
	%send(@btncarrera,free),
	send(@boton2,free),
	send(@boton,free).