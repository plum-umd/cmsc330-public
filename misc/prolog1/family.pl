parent(alex,julia).
parent(alex,rosa).
parent(lina,julia).
parent(lina,rosa).
parent(romeo,peter).
parent(julia,peter).
parent(rosa,silvia).
parent(oscar,ida).
parent(eva,ida).
parent(eva,bruno).
parent(peter,bruno).
parent(peter,georg).
parent(peter,irma).
parent(ruth,georg).
parent(ruth,irma).
parent(silvia,otto).
parent(silvia,pascal).
parent(irma,olga).
parent(irma,jean).
parent(otto,olga).
parent(otto,jean).
parent(jean,tina).
parent(marie,tina).

male(alex).
male(romeo).
male(oscar).
male(peter).
male(bruno).
male(georg).
male(otto).
male(pascal).
male(jean).

husband(alex,lina).
husband(romeo,julia).
husband(oscar,eva).
husband(peter,ruth).
husband(otto,irma).
husband(jean,marie).

% father(X,Y) :- X is the father of Y
father(X,Y) :- male(X), parent(X,Y).

% grandfather(X,Y) :- X is the grandfather of Y.
grandfather(X,Y) :- father(X,P), parent(P,Y).

% female(X) :- X is a female person.
female(X) :- setof(Y, female_h(Y), Ys), member(X, Ys).
female_h(X) :- parent(X,_), \+ male(X).
female_h(X) :- parent(_,X), \+ male(X).

% married(X,Y) :- X and Y are married to each other.
married(X,Y) :- husband(X,Y).
married(X,Y) :- husband(Y,X).

% ancestor(X,Y) :- X is an ancestor of Y.
ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(X,P), ancestor(P,Y).

% relatives(X,Y) :- X and Y are relatives (related by blood to each other).

relatives(X,X).
relatives(X,Y) :- ancestor(Z,X), ancestor(Z,Y).

% descendants(Ds,X) :- Ds is the set of all (known) descendants of X.
