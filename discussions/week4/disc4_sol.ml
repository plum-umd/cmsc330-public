(*
 * Complete the following functions. No library functions are allowed. 
 * Helper functions are allowed.
 *)

(**************** Lists, Tuples, and Records ******************)

(*
 * append l n : 'a list -> 'a list -> 'a list
 *      Appends list n to the end of list l
 *)

let rec append l n = match l with
    [] -> n
    | h::t -> h::(append t n)
;; 


(*
 * runlength l : 'a list -> ('a * int) list
 *      Returns the run length encoding of list l
 *
 *      Ex: runlength [1;1;2;2;1;3;3] [] -> [(1,2);(2,2);(1,1);(3,2)]
 *)

let rec runlength l = 
    runaux l [] 0

and runaux l a i = match l with
    [] -> a
    | h1::h2::t -> if h1 = h2 then runaux (h2::t) a (i+1)
                    else runaux (h2::t) (append a [(h1, (i+1))]) 0 
    | h::t -> runaux t (append a [(h, (i+1))]) 0
;;


(*
 * This type represents an edge in a graph
 *)
type edge = { src : int; dst : int }
;;

(*
 * dests g n : edge list -> int -> int list
 *      Returns a list of all of the nodes to which node n
 *      has an edge
 *)

let rec dests g n = match g with
    [] -> []
    | h::t -> if h.src = n then (h.dst)::(dests t n)
                else dests t n
;; 


(***************** Higher Order Functions *****************)

(*
 * squaresum l : int list -> int list
 *      Returns the sum of the squares of every integer in
*       list l
 *
 *)

let squaresum l = List.fold_left (fun a h -> (h*h) + a) 0 l
;;


(*
 * compose fl x : (int -> int) list -> int -> int
 *      Returns the composition of all functions in fl
 *      applied to x in reverse order, i.e., f(g(h(x))
 *)

let compose fl x = List.fold_left (fun a h -> h a) x fl
;;


(*
 * doublesquare l : int list list -> int list
 *      Returns a list containing the squaresums of every
 *      list in l
 *)

let doublesquare l = List.map squaresum l
;;


(*
 * positives l : int list -> bool list
 *      Returns a list containing true for all positive
 *      elements, and false for negatives (0 is positive
 *      in this case)
 *)

let positives l = List.map (fun x -> if x < 0 then false
                        else true) l
;;


(****************** Variant Types ******************)

(*
 * Defines a shape type to be used for area
 *)
type shape = 
    Square of float
    | Rectangle of (float * float)
    | Circle of float
;;

(*
 * area s : shape -> int
 *      Returns the area of the given shape
 *)

let area s = match s with
    Square (i) -> i *. i
    | Rectangle (x,y) -> x *. y
    | Circle (r) -> r *. r *. 3.1415962
;;


(*
 * Defines a list type to be used in the following functions
 *)
type 'a linkedlist = 
    Node of ('a * 'a linkedlist)
    | EndNode
;;

(*
 * insert l x : 'a linkedlist -> 'a -> 'a linkedlist
 *      Inserts x at the end of linkedlist l
 *)

let rec insert l x = match l with
    EndNode -> Node (x, EndNode)
    | Node (v, n) -> Node (v, insert n x)
;;


(*
 * size l : 'a linkedlist -> int
 *      Returns the size of list l
 *)

let rec size l = match l with
    Node (_, r) -> 1 + size r
    | EndNode -> 0
;;


(*
 * map f l : ('a -> 'b) -> 'a linkedlist -> 'b linkedlist
 *      Returns the parameter list l with the function f
 *      having been applied to each element
 *)

let rec map f l = match l with
    EndNode -> EndNode
    | Node (v, n) -> Node ((f v), (map f n))
;;


(*
 * fold f a l : ('a -> 'b -> 'a) -> 'a -> 'b linkedlist -> 'a
 *      Accumulates the list l with starting value a 
 *      using function f
 *)

let rec fold f a l = match l with 
    EndNode -> a
    | Node (v, n) -> fold f (f a v) n
;;
