:- op( 100, xfx,[tiene, entrega, jamas, come, pone, 'es un']).
:- op( 100, xf,[nada, vuela]).

%Base conocimiento
Animal 'es un' mamifero :-
Animal tiene pelo;
Animal entrega leche.

Animal 'es un' ave :-
Animal tiene alas;
Animal vuela,
Animal pone huevos.

Animal 'es un' carnivoro :-
Animal 'es un' mamifero,
Animal come carne.

Animal 'es un' carnivoro :-
Animal tiene 'dientes punteados',
Animal tiene garras,
Animal tiene 'forward pointing eyes'.

Animal 'es un' chita :-
Animal 'es un' carnivoro,
Animal tiene 'tawny colour',
Animal tiene 'dark spots'.

Animal 'es un' carnivoro :-
Animal 'es un' mamifero,
Animal come carne.

Animal 'es un' tigre :-
Animal 'es un' carnivoro ,
Animal tiene 'tawny colour' ,
Animal tiene 'black stripes'.

Animal 'es un' pinguino :-
Animal 'es un' ave,
Animal jamas fly ;
Animal nada.

Animal 'es un' albatro :-
Animal 'es un' ave ,
Animal 'es un' 'buen volador'.

X 'es un' animal :-
member(X,[chita, tigre, pinguino, albatro]).


%:- dynamic caracteristica/2.
% sintoma(luz-de-bateria-en-alerta, bateria).
% sintoma(carro-no-enciende, bateria).

%
% Recolectar las pruebas
%
solve(true, void) :- !.
solve((X, Y), (Px, Py)) :- 
	!,
	solve(X, Px),
	solve(Y, Py). 
solve(sintoma(X, Y), sintoma(X, Y)) :-
	!,
	consultar(X, Y).
solve(X, proof(X, Py)) :-
	clause(X, Y),
	solve(Y, Py).

%	
% Consultar al usuario
%
% sintoma(X, Y) :- 
% 	consultar(X, Y).

:-  dynamic(conocido/3).
consultar(A, B) :- conocido(A, B, true).
consultar(A, B) :- 
	\+(conocido(A, B, _)), 
	nl, 
	preguntar(A, B), 
	write(' (si./no.)'),
	read(Z), 
	recordar(A, B, Z), 
	Z = si.

%
% Preguntas
%
preguntar(come, carne) :- write('¿Come carne?').
preguntar(pone, huevos) :- write('¿pone huevos?').
preguntar(no-funciona, bomba-del-combustible) :- write('�La bomba de combustible tiene problemas para bombear combustible?').
preguntar(falta, combustible) :- write('�El medidor de combustible indica que el tanque est� vac�o?').
preguntar(roto, fusible) :- write('�Est� el fusible roto?').
preguntar(descargada, bateria) :- write('�El voltaje de la bater�a es menor a 11 voltios?').


%
% Recordar respuesta a preguntas
%
recordar(X, Y, si) :- assertz(conocido(X, Y, true)).
recordar(X, Y, no) :- assertz(conocido(X, Y, false)).

%
% Explicaciones
%
% Explanations 
escribe_prueba(void).

escribe_prueba((X, Y)) :- 
	escribe_prueba(X),
	nl, 
	escribe_prueba(Y).
escribe_prueba(proof(X, void)) :- 
	write(X),
	nl.
escribe_prueba(proof(X, sintoma(Y, Z))) :- 
	write(X),
	write(' PORQUE'),
	nl, 
	tab(8),
	write(sintoma(Y, Z)),
	nl,
	!.
escribe_prueba(proof(X, Y)) :- 
	!,
	Y \= void,
	write(X),
	write(' PORQUE'),
	nl, 
	escribe_indentado(Y),
	nl, 
	escribe_prueba(Y).

escribe_indentado((proof(X, _), Z)) :-
	tab(8),
	write(X),
	write(' Y'),
	nl, 
	escribe_indentado(Z).
escribe_indentado(proof(X,_)) :-
	tab(8),
	write(X),
	nl.

%
% Rutina de entrada
%
expert :-
	retractall(conocido(_,_,_)), 
	solve(funciona_mal(carro), X), 
	nl,
	escribe_prueba(X).


