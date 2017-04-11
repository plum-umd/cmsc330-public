nfa_suffix(nfa(Q,A,D,S,F)) :-
	Q = [0,1,2,3,4,5,6],
	A = [a,b],
	D = [(0,epsilon,1),(0,epsilon,2),(0,epsilon,5),(1,a,3),(2,b,4),(3,epsilon,5),(4,epsilon,5),(5,epsilon,0),(5,a,6)],
	S = 0,
	F = [6].