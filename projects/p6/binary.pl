:- module(binary,[
       card/2,
       height/2,
       elem/2,
       insert/3,
       inorder/2,
       bst/1,
       delete/3,
       enumerate_bst/2
   ]).

% Predicate: card(Bst,Card)
% Description: Card is the number of elements in Bst.
% Usage: If Bst is a binary search tree, then card(Bst,Card) succeeds with one solution for Card.

card(Bst,Card) :-
    fail.

% Predicate: height(Bst,Height)
% Description: Height is the height of Bst.
% Usage: If Bst is a binary search tree, then height(Bst,Height) succeeds with one solution for Height.

height(Bst,Height) :-
    fail.

% Predicate: elem(Bst,Elem)
% Description: Elem is an element of Bst
% Usage: If Bst is a binary search tree and Elem a positive integer, then elem(Bst,X) succeeds iff Elem is an element of Bst.

elem(Bst,Elem) :-
    fail.

% Predicate: insert(Bst,Elem,New)
% Description: New is the result of adding Elem to Bst.
% Usage: Is Bst is a binary search tree and Elem a positive integer, then insert(Bst,Elem,New) succeeds with one solution for New.

insert(Bst,Elem,New) :-
    fail.

% Predicate: inorder(Bst,Elems)
% Description: Elems in an inorder traversal of Bst.
% Usage: If Bst is a binary search tree, then inorder(Bst,Elems) succeeds with one solution for Elems.

inorder(Bst,Elems) :-
    fail.

% Predicate: bst(Bst)
% Description: Bst is a binary search tree.
% Usage: bst(Bst) succeeds iff Bst is a binary search tree.

bst(Bst) :-
    fail.

% Predicate: delete(Bst,Elem,New)
% Description: New is the result of removing Elem from Bst.
% Usage: If Bst is a binary search tree and Elem a positive integer, then delete(Bst,Elem,New) succeeds with one solution for New.

delete(Bst,Elem,New) :-
    fail.

% Predicate: enumerate_bst(Elems,Bst)
% Description: Elems is an inorder traversal of Bst.
% Usage: If Elems is an inorder traversal of a binary search tree, then enumerate_bst(Elems,Bst) succeeds with all solutions for Bst.
% Notes: The number of binary search trees with n keys is the nth Catalan number.
% Hints: What happens when you run inorder/2 with Bst uninstantiated? Why does this happen?

enumerate_bst(Elems,Bst) :-
    fail.
