module Vertex = struct
  type t = int * bool
  let compare = Pervasives.compare
  let hash = Hashtbl.hash
  let equal = (=)
end

module Edge = struct
  type t = string * bool
  let compare = Pervasives.compare
  let equal = (=)
  let default = ("", false)
end

module G = Graph.Persistent.Digraph.ConcreteBidirectionalLabeled(Vertex)(Edge)
module Dot = Graph.Graphviz.Dot(struct
    include G
    let edge_attributes ((s1, _), (e, pair), (s2, _)) =
      let ports =
        if pair then
          if s1 > s2 then
            [`Headport `S ; `Tailport `S]
          else
            [`Headport `N ; `Tailport `N]
        else [] in
      ports @ [`Label e]
    let default_edge_attributes _ = []
    let get_subgraph _ = None
    let vertex_attributes (s, a) =
      if s = -1 then
        [`Style `Invis]
      else if a then
        [`Shape `Doublecircle]
      else
        [`Shape `Circle]
    let vertex_name (s, _) = string_of_int s
    let default_vertex_attributes _ = []
    let graph_attributes _ = [`Rankdir `LeftToRight]
  end)

let write_nfa_to_graphviz (nfa : Nfa.nfa_t) : bool =
  let name = "output.viz" in
  let ss, fs, ts = Nfa.get_start nfa, Nfa.get_finals nfa, Nfa.get_transitions nfa in
  let g = List.fold_left (fun g (v1,c,v2) ->
      let v1' = (v1, List.mem v1 fs) in
      let v2' = (v2, List.mem v2 fs) in
      let c' = match c with
        | None -> "ε"
        | Some x -> String.make 1 x in
      let pair = List.mem (v2, c, v1) ts in
      G.add_edge_e g (G.E.create v1' (c', pair) v2')) G.empty ts in
  let start_e = G.E.create (-1, false) ("", false) (ss, List.mem ss fs) in
  let g = G.add_edge_e g start_e in
  let file = open_out_bin name in
  Dot.output_graph file g;
  Sys.command (Printf.sprintf "dot %s -Tpng -o output.png && rm %s" name name) = 0
;;

print_string "Type regexp to visualize: ";;
let line = read_line ();;
let nfa = Regexp.string_to_nfa line;;
if write_nfa_to_graphviz nfa then
  print_string "Success! Open 'output.png' to see your visualized NFA.\n"
else
  print_string "Failure! Are you sure you have graphviz installed on your machine?\n"
