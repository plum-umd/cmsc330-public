# Puzzle Solver (Extra Credit)

Introduction
------------
In this extra-credit assignment you will implement two solvers for the [sliding eight-puzzle](https://en.wikipedia.org/wiki/Sliding_puzzle), a classic combinatorial problem. The first solver explores the state space using bounded depth-first search. The second uses an informed best-first search algorithm called A\* to find optimal solutions efficiently. The puzzle and solvers are described in detail below.

Ground Rules
------------
You may use any [built-in](http://www.swi-prolog.org/pldoc/man?section=builtin) or [library](http://www.swi-prolog.org/pldoc/man?section=libpl) predicate. To implement the efficient solver, we recommend using [`library(heaps)`](http://www.swi-prolog.org/pldoc/doc/swi/library/heaps.pl) for priority queues and [`library(assoc)`](http://www.swi-prolog.org/pldoc/man?section=assoc) for finite maps, which can be used to implement sets. Note that `library(heaps)` doesn't implement an efficient decrease-key operation, but is fast enough for our purposes. Our solution spends nearly half its running time performing `O(N)` delete-key operations.

Requirements
------------
You are not required to implement every predicate described below in order to receive extra credit. Rather, you must implement enough to pass at least half the tests. We recommend implementing at least `move/2`, `inversions/2`, `solvable/2`, `hamming/3`, `coordinate/4` and `manhattan/3`. Implementing `solve_bounded/4` requires performing depth-first search with a depth bound, and should be familiar from the project. The most challenging predicate is the efficient solver, `solve/4`, which is worth one quarter of the allocated points. There are no public tests for extra-credit assignments. If you feel there is a mistake in grading, please talk to an instructor.

Problem Description
-------------------
An eight-puzzle is a three-by-three board containing tiles numbered one through eight in addition to one blank position. The objective is to move tiles into the blank position until the goal state is reached. In this assignment, boards are represented as permutations of `[1,2,3,4,5,6,7,8,0]` where zero represents the blank position and numbers one through eight the tiles. This list represents the board

```
1 | 2 | 3
---------
4 | 5 | 6
---------
7 | 8 | 0
```

which we take as the goal state. A solution to an eight-puzzle is a sequence of distinct boards beginning with the initial board and ending with the goal, where every non-initial board follows from the immediately preceding board via one move. We define the length of a solution as the number of moves required to reach the goal. If you imagine boards as states and moves as transitions, then solutions are simple paths from the initial to the final state in the transition graph. Your first task is to generate legal moves.

- **Predicate:** `move(Board,Move)`
- **Description:** `Move` can be obtained from `Board` in one move.
- **Usage:** If `Board` is a board, then `move(Board,Move)` succeeds with all solutions for `Move`.

```
?- findall(Move,move([0,3,2,4,5,1,7,8,6],Move),Moves).
Moves = [
    [3, 0, 2, 4, 5, 1, 7, 8, 6],
    [4, 3, 2, 0, 5, 1, 7, 8, 6]
].

?- findall(Move,move([1,3,2,4,5,0,7,8,6],Move),Moves).
Moves = [
    [1, 3, 0, 4, 5, 2, 7, 8, 6],
    [1, 3, 2, 4, 0, 5, 7, 8, 6],
    [1, 3, 2, 4, 5, 6, 7, 8, 0]
].
```

Solvability
-----------
Not every eight-puzzle is solvable. Fortunately, there is a simple algorithm to determine whether a puzzle has a solution. An inversion is a pair `(I,J)` of tiles such that `J > I` and `I` occurs before `J` when the board is represented as a list. You can check that every move preserves the [parity](https://en.wikipedia.org/wiki/Parity_(mathematics)) of the number of inversions in a board. In particular, the goal board has no inversions and therefore is not reachable from any board having an odd number of inversions. Conversely, one can show that every board having an even number of inversions is solvable. The following predicates implement the solvability check.

- **Predicate:** `inversions(Board,N)`
- **Description:** `N` is the number of inversions in `Board`.
- **Usage:** If `Board` is a board, then `inversions(Board,N)` succeeds with one solution for `N`.
- **Hints:** There are efficient algorithms to count inversions. Give a quadratic solution.

```
- inversions([1,2,3,4,0,5,6,7,8],N).
N = 0.

?- inversions([1,2,3,0,4,6,8,5,7],N).
N = 3.

?- inversions([1,3,4,2,5,0,7,8,6],N).
N = 4.
```

- **Predicate:** `solvable(Board)`
- **Description:** `Board` is solvable.
- **Usage:** `solvable(Board)` succeeds iff `Board` is solvable.

```
?- solvable([1,2,3,4,0,5,6,7,8]).
true.

?- solvable([1,2,3,0,4,6,8,5,7]).
false.
```

Depth-Bounded Search
--------------------
The first solver implements depth-first search with a depth bound. The depth bound is necessary to prevent the solver from exploring the entire state space, which grows exponentially. Given a board `Board` and bound `Bound`, the solver should report all solutions of length `Bound` or less. Since solutions are simple paths from `Board` to the goal state, you must check for cycles while traversing the state graph. Your implementation should not report duplicate solutions. The order in which solutions are discovered may differ from the examples below.

- **Predicate:** `solve_bounded(Board,Bound,Solution)`
- **Description:** `Solution` is a solution to `Board` of length not exceeding `Bound`.
- **Usage:** If `Board` is a board and `Bound` a nonnegative integer, then `solve_bounded(Board,Bound,Solution)` succeeds with all solutions for `Solution`.
- **Notes**: Do not report duplicate solutions. Solutions should not contain cycles.

```
?- solve_bounded([1,2,0,3,4,5,6,7,8],4,Sol).
Sol = [[1, 2, 0, 3, 4, 5, 6, 7, 8],
       [1, 0, 2, 3, 4, 5, 6, 7, 8],
       [0, 1, 2, 3, 4, 5, 6, 7, 8]].

?- solve_bounded([4,3,2,1,0,5,6,7,8],6,Sol).
Sol = [[4, 3, 2, 1, 0, 5, 6, 7, 8],
       [4, 0, 2, 1, 3, 5, 6, 7, 8],
       [0, 4, 2, 1, 3, 5, 6, 7, 8],
       [1, 4, 2, 0, 3, 5, 6, 7, 8],
       [1, 4, 2, 3, 0, 5, 6, 7, 8],
       [1, 0, 2, 3, 4, 5, 6, 7, 8],
       [0, 1, 2, 3, 4, 5, 6, 7, 8]] ;
Sol = [[4, 3, 2, 1, 0, 5, 6, 7, 8],
       [4, 3, 2, 0, 1, 5, 6, 7, 8],
       [0, 3, 2, 4, 1, 5, 6, 7, 8],
       [3, 0, 2, 4, 1, 5, 6, 7, 8],
       [3, 1, 2, 4, 0, 5, 6, 7, 8],
       [3, 1, 2, 0, 4, 5, 6, 7, 8],
       [0, 1, 2, 3, 4, 5, 6, 7, 8]].
```

Informed Search
---------------
Informed search requires information. The basic approach is as follows. With each board `Board` we associate three values: `G(Board)` is the actual cost of `Board`, defined as the length of the optimal path to `Board` from the initial board; `H(Board)` is the estimated cost of `Board`, defined by a heuristic function; and `F(Board)` is the combined cost of `Board`, defined as the sum of `G(Board)` and `H(Board)`. Note that `G(Board)` depends only on the state graph, while `H(Board)` and `F(Board)` depend on the heuristic function.

Our algorithm will be parameterized by a heuristic function. The heuristics we consider are [consistent](https://en.wikipedia.org/wiki/Consistent_heuristic) in the following sense: they never overestimate the number of moves required to reach the goal; and the estimated cost of a board never exceeds the estimated cost of any board obtained by moving one tile, plus the cost of moving the tile. Using consistent heuristics ensures that the algorithm we implement always discovers optimal solutions, and boards are never explored twice. This is a crucial optimization.

You will implement the Hamming and Manhattan distance heuristics. The Hamming distance between two boards `Board` and `Goal` is the number of misplaced tiles in `Board` with respect to `Goal` (in other words, the number of tiles that do not match). The blank position is not included when computing Hamming distance. Note that the Hamming distance between any board and itself is zero.

- **Predicate:** `hamming(Board,Goal,H)`
- **Description:** `H` is the Hamming distance between `Board` and `Goal`.
- **Usage:** If `Board` and `Goal` are boards, then `hamming(Board,Goal)` succeeds with one solution for `H`.

```
?- hamming([1,2,3,8,0,4,7,6,5],[1,2,3,8,0,4,7,6,5],H).
H = 0.

?- hamming([1,2,3,4,0,8,7,6,5],[1,2,3,8,0,4,7,6,5],H).
H = 2.

?- hamming([1,2,0,4,3,8,7,6,5],[1,2,3,8,0,4,7,6,5],H).
H = 3.
```

The Manhattan distance between `Board` and `Goal` is the sum of the Manhattan distances between tiles in `Board` with respect to their positions in `Goal`. If tile `N` occurs at position `(A,B)` in `Board` and `(C,D)` in `Goal`, then the Manhattan distance between `N` in `Board` with respect to `Goal` is `|A - C| + |B - D|`. The blank position is not included when computing Manhattan distance. Note that the Manhattan distance between any board and itself is zero. You will find the predicate `coordinate/4` useful when implementing `manhattan/4`.

- **Predicate:** `coordinate(Board,A,X,Y)`
- **Description:** `A` occurs at position `(X,Y)` in `Board`.
- **Usage:** If `Board` is a board, then `coordinate(Board,A,X,Y)` succeeds with all solutions for `A`, `X` and `Y`.
- **Notes:** `A` can be a tile or the blank position.

```
?- coordinate([1,2,0,4,3,8,7,6,5],2,X,Y).
X = 1,
Y = 0 .

?- coordinate([1,2,0,4,3,8,7,6,5],Tile,1,2).
Tile = 6.

?- findall(Tile-X,coordinate([1,2,0,4,3,8,7,6,5],Tile,X,2),Tiles).
Tiles = [7-0, 6-1, 5-2].
```

- **Predicate:** `manhattan(Board,Goal,H)`
- **Description:** `H` is the `Manhattan` distance between `Board` and `Goal`.
- **Usage:** If `Board` and `Goal` are boards, then `manhattan(Board,Goal,H)` succeeds with one solution for `H`.

```
?- manhattan([1,2,3,8,0,4,7,6,5],[1,2,3,8,0,4,7,6,5],H).
H = 0.

?- manhattan([1,2,3,4,0,8,7,6,5],[1,2,3,8,0,4,7,6,5],H).
H = 4.

?- manhattan([1,2,0,4,3,8,7,6,5],[1,2,3,8,0,4,7,6,5],H).
H = 6.
```

Informed Search
---------------
Now that you have heuristics, you can implement the _informed best-first search_ algorithm called A\*. The A\* algorithm maintains two sets, called `Open` and `Closed`. The `Closed` set contains boards that have been visited. Since the heuristics you implemented are consistent, the actual cost of every board in the `Closed` set is known. The `Open` set contains boards that haven't been visited. The actual costs of these boards are unknown and may be revised as the state space is explored. At each step, the algorithm chooses the board `Board` from `open` whose combined cost estimate is minimum. If `Board` is the `Goal` state, terminate with an optimal solution. Otherwise, add `Board` to the `Closed` set, explore all boards reachable from `Board` in one move, and update `Open` to reflect the current best cost estimates. The following pseudocode should be used to update the `Open` set:

```
For each Child of Board do:
    If Child in Closed do:
        Continue
    If Child not in Open or G(Board) + 1 < G(Child) do:
        G(Child) := G(Board) + 1
        F(Child) := G(Child) + Heuristic(Child,Goal)
        If Child not in Open do:
            Open := Open + {Child}
```

The first conditional simply ignores every board in the `Closed` set. Since the heuristics you implemented are consistent, the actual costs of these boards are known. With inconsistent heuristics, the `Child` must be moved from the `Closed` to the `Open` set whenever better paths are discovered. In the second conditional, we either place the `Child` in the `Open` set or update the `Open` set to reflect that a better path has been discovered. Since costs are measured in terms of path length, the distance between a `Board` and its `Child` is one. In more complex search problems, this would be replaced by a distance measure. Note that the A\* algorithm with consistent heuristics is guaranteed to find an optimal solution using the update procedure given above, provided one exists.

The challenge is translating the imperative pseudocode into Prolog and managing the appropriate data structures. Your implementation is parameterized by a heuristic. In order to call the heuristic, use the meta-predicate [`call/4`](http://www.swi-prolog.org/pldoc/doc_for?object=call/2). We suggest initializing all relevant data structures in `solve/4` and passing control to an auxiliary predicate that handles the iteration. As above, you are not required to check that the input board is solvable. You should not attempt to enumerate solutions. Your implementation will be tested by checking that your solutions are optimal and correct. Depending on your implementation, your output might differ from the examples below. The last examples show worst-case puzzles that require a minimum of 31 moves to solve.

You may search the Internet for information about the A\* algorithm and eight-puzzles. However, please document this in your source code. You may also implement other search algorithms, however they must be efficient enough to pass our tests. 

- **Predicate:** `solve(Board,Heuristic,Solution)`
- **Description:** `Solution` is an optimal solution to `Board`.
- **Usage:** If `Board` is a board and `Heuristic` a heuristic, then `solve(Board,Heuristic,Solution)` succeeds with one solution for `Solution`.
- **Notes:** You must terminate deterministically with precisely one solution. This solution must be optimal.

```
?- solve([0,1,3,4,2,5,7,8,6],manhattan,Solution).
Sol = [
    [0, 1, 3, 4, 2, 5, 7, 8, 6],
    [1, 0, 3, 4, 2, 5, 7, 8, 6],
    [1, 2, 3, 4, 0, 5, 7, 8, 6],
    [1, 2, 3, 4, 5, 0, 7, 8, 6],
    [1, 2, 3, 4, 5, 6, 7, 8, 0]
].

?- time(solve([8,6,7,2,5,4,3,0,1],manhattan,Solution)).
% 12,732,734 inferences, 4.756 CPU in 4.757 seconds (100% CPU, 2676991 Lips)
Solution = [...].

?- time(solve([8,6,7,2,5,4,3,0,1],hamming,Solution)).
% 525,610,594 inferences, 274.189 CPU in 274.241 seconds (100% CPU, 1916965 Lips)
Solution = [...].
```

Project Submission and Grading
------------------
Be sure to follow the project description exactly! Your solution will be graded automatically, so any deviation from the specification will result in lost points.

You can submit your project in two ways:
- Submit your files directly to the [submit server][submit server] as a zip file by clicking on the submit link in the column "web submission".
![Where to find the web submission link][web submit link]
Then, use the submit dialog to submit your zip file containing all of your source files directly.
![Where to upload the file][web upload example]
Select your file using the "Browse" button, then press the "Submit project!" button. You will need to put it in a zip file since there are several component files. We provide a script `pack_submission.sh` which you can run to make a zip file containing all of the necessary files.
- Submit directly by executing a the submission script on a computer with Java and network access. Included in this project are the submission scripts and related files listed under **Project Files**. These files should be in the directory containing your project. From there you can either execute submit.rb or run the command `java -jar submit.jar` directly (this is all submit.rb does).

No matter how you choose to submit your project, make sure that your submission is received by checking the [submit server][submit server] after submitting.

Academic Integrity
------------------
Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

[git instructions]: ../git_cheatsheet.md
[submit server]: submit.cs.umd.edu
[web submit link]: ../common-images/web_submit.jpg
[web upload example]: ../common-images/web_upload.jpg
