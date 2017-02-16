open Funs

(* Part 1: Higher order functions *)

let count e lst = failwith "unimplemented"

let divisible_by n lst =  failwith "unimplemented"

let divisible_by_first lst = failwith "unimplemented"

let pairup lst1 lst2 = failwith "unimplemented"

let concat_lists lst = failwith "unimplemented"

(* Part 2: Programming with datatypes *)

type int_tree =
    IntLeaf
  | IntNode of int * int_tree * int_tree

let empty_int_tree = IntLeaf

let rec int_insert x t =
    match t with
      IntLeaf -> IntNode(x,IntLeaf,IntLeaf)
    | IntNode (y,l,r) when x > y -> IntNode (y,l,int_insert x r)
    | IntNode (y,l,r) when x = y -> t
    | IntNode (y,l,r) -> IntNode(y,int_insert x l,r)

let rec int_mem x t =
    match t with
      IntLeaf -> false
    | IntNode (y,l,r) when x > y -> int_mem x r
    | IntNode (y,l,r) when x = y -> true
    | IntNode (y,l,r) -> int_mem x l

    (* Problem 0: implement various functions on int_trees *)

let rec int_size t = failwith "unimplemented"

let rec int_max t = failwith "unimplemented"

let rec int_insert_all lst t = failwith "unimplemented"

let rec int_as_list t = failwith "unimplemented"

let rec int_common t x y = failwith "unimplemented"


(* Problem 1: Make the tree polymorphic, parameterized by a comparison function *)

type 'a atree =
    Leaf
  | Node of 'a * 'a atree * 'a atree
type 'a compfn = 'a -> 'a -> int
type 'a ptree = 'a compfn * 'a atree

let empty_ptree f : 'a ptree = (f,Leaf)

let pinsert x t = failwith "unimplemented"

let pmem x t = failwith "unimplemented"

(* Part 3: Graphs *)

type node = int
type edge = { src : node; dst : node; }
type graph = { nodes : int_tree; edges : edge list; }

let empty_graph = {nodes = empty_int_tree; edges = [] }

let add_edge e { nodes = ns; edges = es } =
    let { src = s; dst = d } = e in
    let ns' = int_insert s ns in
    let ns'' = int_insert d ns' in
    let es' = e::es in
    { nodes = ns''; edges = es' }

let add_edges es g = fold (fun g e -> add_edge e g) g es

(* The following are implemented by students *)

let graph_empty g = failwith "unimplemented"

let graph_size g = failwith "unimplemented"

let is_dst n e = failwith "unimplemented"

let src_edges n g = failwith "unimplemented"

let reachable n g = failwith "unimplemented"
