(*
 * Complete the following functions. No library functions are allowed except for fold_left
 * and map. Helper functions are allowed.
 *)

(**************** Lists, Tuples, and Records ******************)

(*
 * append l n : 'a list -> 'a list -> 'a list
 *      Appends list n to the end of list l
 *)

let rec append l n = failwith "unimplemented"
;; 


(*
 * runlength l : 'a list -> ('a * int) list
 *      Returns the run length encoding of list l
 *
 *      Ex: runlength [1;1;2;2;1;3;3] [] -> [(1,2);(2,2);(1,1);(3,2)]
 *)

let rec runlength l = failwith "unimplemented"
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

let rec dests g n = failwith "unimplemented"
;; 


(***************** Higher Order Functions *****************)

(*
 * squaresum l : int list -> int list
 *      Returns the sum of the squares of every integer in
*       list l
 *
 *)

let squaresum l = failwith "unimplemented"
;;


(*
 * compose fl x : (int -> int) list -> int -> int
 *      Returns the composition of all functions in fl
 *      applied to x in reverse order, i.e., h(g(f(x)))
 *)

let compose fl x = failwith "unimplemented"
;;


(*
 * doublesquare l : int list list -> int list
 *      Returns a list containing the squaresums of every
 *      list in l
 *)

let doublesquare l = failwith "unimplemented"
;;


(*
 * positives l : int list -> bool list
 *      Returns a list containing true for all positive
 *      elements, and false for negatives (0 is positive
 *      in this case)
 *)

let positives l = failwith "unimplemented"
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

let area s = failwith "unimplemented"
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

let rec insert l x = failwith "unimplemented"
;;


(*
 * size l : 'a linkedlist -> int
 *      Returns the size of list l
 *)

let rec size l = failwith "unimplemented"
;;


(*
 * map f l : ('a -> 'b) -> 'a linkedlist -> 'b linkedlist
 *      Returns the parameter list l with the function f
 *      having been applied to each element
 *)

let rec map f l = failwith "unimplemented"
;;


(*
 * fold f a l : ('a -> 'b -> 'a) -> 'a -> 'b linkedlist -> 'a
 *      Accumulates the list l with starting value a 
 *      using function f
 *)

let rec fold f a l = failwith "unimplemented"
;;
