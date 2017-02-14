(*
 * Determine the types of the following variables without entering them into the OCaml top-level
 *)

let x = [1;2;3];;
(* int list *)
let y = [1;2]::[];;
(* int list list *)
let w = 1.0;;
(* float *)
let s = ["hello"; "there"];;
(* string list *)

(*
 * Complete all of the following functions. Helper functions are allowed, but internal
 * let statements are not.
 *)

(*
 * first ls : `a list -> `a
 *      Returns the first element of the list 
 *)
let first ls = match ls with
    h::_ -> h
    | _ -> failwith "I didn't think this far ahead"
;;

(*
 * sumthree ls : int list -> int
 *      Returns the sum of the first three elements of the list, or 0 if the list
 *      has fewer than three elements
 *)
let sumthree ls = match ls with
    h1::h2::h3::_ -> h1 + h2 + h3
    | _ -> 0 
;;

(*
 * len ls : 'a list -> int
 *      Returns the length of the list
 *)
let rec len ls = match ls with
    [] -> 0
    | h::t -> 1 + len t
;;

(*
 * add_to_list ls n : int list -> int -> int list
 *      Returns ls with n added to every element
 *)
let rec add_to_list ls n = match ls with
    [] -> []
    | h::t -> (h + n)::(add_to_list t n)
;;

(*
 * remove_greater ls n : int list -> int -> int list
 *      Removes all elements greater than n from ls
 *)
let rec remove_greater ls n = match ls with
    [] -> []
    | h::t -> if h > n then remove_greater t n else h::(remove_greater t n)
;;

(**
 * CHALLENGE PROBLEM
 *
 * reverse ls : 'a list -> 'a list
 *      Returns ls, reversed
 **)
let rec reverse ls = reverse_aux ls []

and reverse_aux ls ns = match ls with
    [] -> ns
    | h::t -> reverse_aux t (h::ns)
;;



