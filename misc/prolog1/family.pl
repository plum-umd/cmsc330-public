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

% grandfather(X,Y) :- X is the grandfather of Y.

% female(X) :- X is a female person.

% married(X,Y) :- X and Y are married to each other.

% ancestor(X,Y) :- X is an ancestor of Y.

% relatives(X,Y) :- X and Y are relatives (related by blood to each other).

% descendants(Ds,X) :- Ds is the set of all (known) descendants of X.
