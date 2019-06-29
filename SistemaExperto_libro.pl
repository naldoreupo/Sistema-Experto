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

askable( _ entrega _, 'Animal' entrega 'Que')  :- write('¿Qué entrega el animal?').
askable( _ vuela, 'Animal' vuela).
askable( _ pone huevos, 'Animal' pone huevos).
askable( _ come _, 'Animal' come 'Que').
askable( _ tiene _, 'Animal' tiene 'Algo').
askable( _ jamas _, 'Animal' jamas 'hace algo').



:- op( 900, xfx, :).
:- op( 800, xfx, was).
:- op( 870, fx, if).
:- op( 880, xfx, then).
:- op( 550, xfy, or).
:- op( 540, xfy, and).
:- op( 300, fx, 'derived by').
:- op( 600, xfx, from).
:- op( 600, xfx, by).

explore( Goal, Trace, Goal is true was 'found as a fact') :-
fact : Goal.

%Assume only one rule about each type of goal.

explore( Goal, Trace,Goal is TruthValue was 'derived by' Rule from Answer) :-
	Rule : if Condition then Goal, % Rule relevant to Goal
	explore( Condition, [Goal by Rule | Trace], Answer),
	truth( Answer, TruthValue).

explore( Goal1 and Goal2, Trace, Answer) :- !,
	explore( Goal1, Trace, Answer1),
	continue( Answer1, Goal1 and Goal2, Trace, Answer).

explore( Goal1 or Goal2, Trace, Answer) :-
	exploreyes( Goal1, Trace, Answer); % Positive answer to Goal1
	exploreyes( Goal2, Trace, Answer). % Positive answer to Goal2

explore( Goal1 or Goal2, Trace, Answer1 and Answer2) :- !,
    not	exploreyes(Goal1, Trace, _),
	not exploreyes(Goal2, Trace, _), % No positive answer
	explore(Goal1, Trace, Answer1), % Answer1 must be negative
	explore(Goal2, Trace, Answer2). % Answer2 must be negative

explore( Goal, Trace, Goal is Answer was told) :-
	useranswer(Goal, Trace, Answer). % ser-supplieda nswer

exploreyes(Goal, Trace, Answer) :-
	explore( Goal, Trace, Answer),
	positive( Answer).

continue( Answer1, Goal1 and Goal2, Trace, Answer) :-
	positive( Answer1),
	explore( Goal2, Trace, Answer2),
	( positive( Answer2), Answer = Answer1 and Answer2;
	negative( Answer2), Answer = Answer2).

continue( Answer1, Goal1 and Goal2, _, Answer1) :-
	negative( Answer1).

truth( Question is TruthValue was Found, TruthValue) :- !.

truth( Answer1 and Answer2, TruthValue) :-
	truth( Answer1, true),
	truth( Answer2, true),!,
	TruthValue = true;
	TruthValue = false.

positive( Answer) :-
	truth( Answer, true).

negative( Answer) :-
	truth( Answer, false).

getreply( Reply) :-
	read( Answer),
	means( Answer, Meaning), !, % Answer means something?
	Reply = Meaning; %yes
	nl, write( 'Answer unknowr, try again please'), nl, % No
	getreply( Reply).	% Try again

means( yes, Yes).
means( Y, Yes).
means( no, no).
means( n, no).
means( why, why).
means( w, why).

useranswer( Goal, Trace, Answer) :-
	askable( Goal), %Can Goal be asked of the user?
	ask( Goal, Trace, Answer). %Ask user about Goal
	
ask( Goal, Trace, Answer) :-
	introduce( Goal),
	getreply( Reply),
	process( Reply, Goal, Trace, Answer).
	
process( why, Goal, Trace, Answer) :-
	showtrace( Trace),
	ask( Goal, Trace, Answer).

process( yes, Goal, Trace, Answer) :-
	Answer = true,
	askvars( Goal);
	ask( Goal, Trace, Answer).

process( no, Goal, Trace, false).

introduce( Goal) :-
	nl, write( 'Is it true: '),
	write( Goal), write(?), nl.

askvars( Term) :-
	var( Term), !,
	nl, write( Term), write(' = '),
	read( Term).

askvars( Term) :-
	Term =.. [Functor | Args],
	askarglist( Args).

askarglist([]).

askarglist( [Term | Terms] ) :-
	askvars(Term),
	askarglist(Terms).

askable(X come Y).



% Procedure
%
% useranswer( Goal, Trace, Answer)
%
% Eeneratest,h rough backtracking,u ser-supplieds olutionst o Goal.
% Trac,e is a chain of ancestor goals and rules used for 'why'
% explanation.
useranswer( Goal, Trace, Answer) :-
	askable( Goal, _), % May be asked of the user
	freshcopy( Goal, Copy), % Variables in Goal renamed
	useranswer( Goal, Copy, Trace, Answer,1).

useranswer( Goal, _, _, _, N) :-
	N > 1, % Repeated question?
	instantiated( Goal), !,
	fail.
	
useranswer( Goal, copy, _, Answer, _) :-
	wastold( Copy, Answer, _),
	instance_of( Copy, Goal), !.
	
useranswer( Goal, _, _, true, N) :-
	wastold( Goal, true, M),
	M >=N.