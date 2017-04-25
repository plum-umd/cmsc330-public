:- module(solver,[
       move/2,
       inversions/2,
       solvable/1,
       solve_bounded/3,
       hamming/3,
       coordinate/4,
       manhattan/3,
       solve/3
   ]).

% Predicate: goal(Board)
% Description: Board is the goal state.
% Usage: goal(Board) succeeds iff Board is the goal state.

goal([1,2,3,4,5,6,7,8,0]).

% Predicate: move(Board,Move)
% Description: Move can be obtained from Board in one move.
% Usage: If Board is a board, then move(Board,Move) succeeds with all solutions for Move.

move(Board,Move) :-
	fail.

% Predicate: inversions(Board,N)
% Description: N is the number of inversions in Board.
% Usage: If Board is a board, then inversions(Board,N) succeeds with one solution for N.
% Notes: There are efficient algorithms to count inversions. Give a quadratic solution.

inversions(Board,N) :-
	fail.

% Predicate: solvable(Board,Goal)
% Description: Board is solvable.
% Usage: solvable(Board) succeeds iff Board is solvable.

solvable(Board) :-
	fail.

% Predicate: solve_bounded(Board,Bound,Solution).
% Description: Solution is a solution Board of length not exceeding Bound.
% Usage: If Board is a board and Bound a nonnegative integer, then solve_bounded(Board,Bound,Solution) succeeds with all solutions for Solution.
% Notes: Do not report duplicate solutions. Solutions should not contain cycles.

solve_bounded(Board,Bound,Solution) :-
	fail.

% Predicate: hamming(Board,Goal,H)
% Description: H is the Hamming distance between Board and Goal
% Usage: If Board and Goal are boards, then hamming(Board,Goal) succeeds with one solution for H.

hamming(Board,Goal,H) :-
	fail.

% Predicate: coordinate(Board,A,X,Y)
% Description: Tile occurs at position (X,Y) in Board.
% Usage: If Board is a board, then coordinate(Board,A,X,Y) succeeds with all solutions for A, X and Y.

coordinate(Board,A,X,Y) :-
	fail.

% Predicate: manhattan(Board,Goal,H)
% Description: H is the Manhattan distance between Board and Goal.
% Usage: If (Board,Goal) is a problem, then manhattan(Board,Goal,H) succeeds with one solution for H.

manhattan(Board,Goal,H) :-
	fail.

% Predicate: solve(Board,Heuristic,Solution)
% Description: Solution is an optimal solution to Board.
% Usage: If Board is a board and Heuristic a heuristic, then solve(Board,Heuristic,Solution) succeeds with one solution for Solution.
% Notes: You must terminate with precisely one solution. This solution must be optimal.

solve(Board,Heuristic,Solution) :-
	fail.
