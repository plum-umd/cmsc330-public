# Binary Search Trees (Extra Credit)

Introduction
------------
In this extra-credit assignment you will implement a binary search tree in Prolog. The set of binary search trees is defined inductively as follows: `leaf` is a binary search tree; and `node(X,L,R)` is a binary search tree with key `X` whenever `X` is a positive integer, `L` is a binary search tree with `Y < X` for every key `Y` in `L`, and `R` is a binary search tree with `Y > X` for every key `Y` in `R`. Note that binary search trees have unique keys according to this definition. Your implementation of binary search trees will likely resemble your implementation from [Project 2(b)](../projects/p2b#part-2-integer-bst).

Ground Rules
-----------
You may use any [built-in](http://www.swi-prolog.org/pldoc/man?section=builtin) or [library](http://www.swi-prolog.org/pldoc/man?section=libpl) predicate. You are not allowed to use any syntactic extensions to Prolog such as definite clause grammars. We encourage you to explore more advanced libraries to make your implementation more versatile and declarative.

Requirements
-----------
You are not required to implement every predicate described below in order to receive extra credit. Rather, you must implement enough to pass at least half the tests. We recommend implementing at least `card/2`, `height/2`, `elem/2`, `insert/3`, `inorder/2` and `bst/1`. The most challenging predicate is `enumerate/2`, which has multiple elegant solutions whose expression you should find more natural in Prolog than imperative languages. There are no public tests for extra-credit assignments. If you feel there is a mistake in grading, please talk to an instructor.

Binary Search Trees
-------------------

- **Predicate:** `card(Bst,Card)`
- **Description:** `Card` is the number of elements in `Bst`
- **Usage:** If `Bst` is a binary search tree, then `card(Bst,Card)` succeeds with one solution for `Card`.

```
?- card(leaf,Card).
Card = 0.

?- card(node(1,leaf,leaf),Card).
Card = 1.

?- card(node(2,node(1,leaf,leaf),node(3,leaf,leaf)),Card).
Card = 3.
```

- **Predicate:** `height(Bst,Height)`
- **Description:** `Height` is the height of `Bst`.
- **Usage:** If `Bst` is a binary search tree, then `height(Bst,Height)` succeeds with one solution for `Height`.

```
?- height(leaf,Height).
Height = 0.

?- height(node(3,leaf,leaf),Height).
Height = 1.

?- height(node(3,leaf,node(5,leaf,leaf)),Height).
Height = 2.
```

- **Predicate:** `elem(Bst,Elem)`
- **Description:** `Elem` is an element of `Bst`
- **Usage:** If `Bst` is a binary search tree and `Elem` a positive integer, then `elem(Bst,Elem)` succeeds iff `Elem` is an element of `Bst`.

```
?- elem(leaf,_).
false.

?- elem(node(3,node(2,leaf,leaf),node(5,leaf,leaf)),2).
true.

?- elem(node(3,node(1,leaf,leaf),node(5,leaf,leaf)),2).
false.

```

- **Predicate:** `insert(Bst,Elem,New)`
- **Description:** `New` is the result of adding `X` to `Bst`.
- **Usage:** If `Bst` is a binary search tree and `Elem` a positive integer, then `insert(Bst,Elem,New)` succeeds with one solution for `New`.

```
?- insert(leaf,1,T).
T = node(1, leaf, leaf).

?- insert(node(1,leaf,leaf),5,New).
New = node(1, leaf, node(5, leaf, leaf)).

?- insert(node(1,leaf,node(5,leaf,leaf)),3,New).
New = node(1, leaf, node(5, node(3, leaf, leaf), leaf)).
```

- **Predicate:** `inorder(Bst,Elems)`
- **Description:** `Elems` is an inorder traversal of `Bst`.
- **Usage:** If `Bst` is a binary search tree, then `inorder(Bst,Elems)` succeeds with one solution for `Elems`

```
?- inorder(leaf,Inorder).
Inorder = [].

?- inorder(node(3,leaf,node(5,leaf,leaf)),Inorder).
Inorder = [3, 5].

?- inorder(node(3,node(1,leaf,leaf),node(5,leaf,leaf)),Inorder).
Inorder = [1, 3, 5].
```

- **Predicate:** `bst(Bst)`
- **Description:** `Bst` is a binary search tree.
- **Usage:** `bst(Bst)` succeeds iff `Bst` is a binary search tree.

```
?- bst(leaf).
true.

?- bst(node(3,node(5,leaf,leaf),node(1,leaf,leaf))).
false.

?- bst(node(3,node(1,leaf,leaf),node(5,leaf,leaf)))
true.
```

- **Predicate:** `delete(Bst,Elem,New)`
- **Description:** `New` is the result of removing `Elem` from `Bst`
- **Usage:** If `Bst` is a binary search tree and `Elem` a positive integer, then `delete(Bst,Elem,New)` succeeds with one solution for `New`.

```
?- delete(leaf,_,New).
New = leaf.

?- delete(node(3,node(1,leaf,leaf),leaf),1,New).
New = node(3, leaf, leaf).

?- delete(node(3,node(1,leaf,leaf),node(5,node(4,leaf,leaf),node(6,leaf,leaf))),5,New), inorder(New,Inorder).
Inorder = [1, 3, 4, 6].
```

- **Predicate:** `enumerate_bst(Elems,Bst)`
- **Description:** `Elems` is an inorder traversal of `Bst`.
- **Notes:** The number of binary search trees with `N` keys is the `N`th [Catalan number](https://en.wikipedia.org/wiki/Catalan_number).
- **Usage:** If `Elems` is an inorder traversal of a binary search tree, then `enumerate_bst(Elems,Bst)` succeeds with all solutions for `Bst`.
- **Hints:** To find the shortest solution, ask yourself why calling `inorder/2` with `Bst` uninstantiated fails to terminate.

```
?- setof(Bst,enumerate_bst([],Bst),Enum).
Enum = [leaf].

?- setof(Bst,enumerate_bst([1,2],Bst),Enum).
Enum = [
    node(1, leaf, node(2, leaf, leaf)),
    node(2, node(1, leaf, leaf), leaf)
].

?- setof(Bst,enumerate_bst([1,2,3],Bst),Enum).
Enum = [
    node(1, leaf, node(2, leaf, node(3, leaf, leaf))),
    node(1, leaf, node(3, node(2, leaf, leaf), leaf)),
    node(2, node(1, leaf, leaf), node(3, leaf, leaf)),
    node(3, node(1, leaf, node(2, leaf, leaf)), leaf),
    node(3, node(2, node(1, leaf, leaf), leaf), leaf)
].
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
