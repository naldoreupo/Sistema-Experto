%%
%% Sistema experto
%%

%
% Base de conocimiento
%
funciona_mal(X) :- necesita(X, Y), funciona_mal(Y).
funciona_mal(X) :- sintoma(_, X).
necesita(carro, sistema-de-combustible).
necesita(carro, sistema-de-ignicion).
necesita(carro, sistema-electrico).
necesita(sistema-de-combustible, bomba-del-combustible).
necesita(bomba-del-combustible, combustible).
necesita(sistema-de-ignicion, arranque-del-motor).
necesita(sistema-de-ignicion, bujias).
necesita(arranque-del-motor, bateria).
necesita(bujias, bateria).
necesita(sistema-electrico, fusible).
necesita(sistema-electrico, bateria).
%:- dynamic sintoma/2.
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
preguntar(desgastado, bujias) :- write('�Hay alguna buj�a que no est� chispeando?').
preguntar(malogrado, arranque-del-motor) :- write('�El arranque del motor est� en silencio?').
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
