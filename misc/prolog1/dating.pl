likes(alice, bob).
likes(bob, cat).
likes(bob, alice).
likes(cat, alice).
likes(bob,david).
likes(david,ethan).

dating(X,Y) :- likes(X,Y),likes(Y,X).
friendship(X,Y) :- likes(X,Y);likes(Y,X).
