:- op( 100, xfx,[tiene, entrega, no, come, pone, 'es un']).
:- op( 100, xf,[nada, vuela]).

%Reglas
Animal 'es un' mamifero :-
Animal tiene pelo;
Animal entrega leche.

Animal 'es un' ave :-
Animal tiene alas;
Animal vuela,
Animal pone huevos.

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
Animal no fly ;
Animal nada.

Animal 'es un' albatro :-
Animal 'es un' ave ,
Animal 'es un' 'buen volador'.

X 'es un' animal :-
member(X,[chita, tigre, pinguino, albatro]).

askable( _ entrega _, 'Animal' entrega 'Que').
askable( _ vuela, 'Animal' vuela).
askable( _ pone huevos, 'Animal' pone huevos).
askable( _ come _, 'Animal' come 'Que').
askable( _ tiene _, 'Animal' tiene 'Algo').
askable( _ no _, 'Animal' no 'hace algo').

peter tiene pelo.
peter tiene 'tawny colour'.
peter tiene 'black stripes'.
peter come carne.
peter entrega leche.