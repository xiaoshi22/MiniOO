(* File miniool.ml *)
open Parsing;;
open MinioolAST;;

(* sprintf *)
let rec print_var v prefix = 
    print_endline(prefix ^ "Variable " ^ (green_text v))

and print_field f prefix = 
    print_endline(prefix ^ "Field " ^ (green_text f))

and print_expr e prefix ind = match e with
  (* f -- Field *)
  | Field(f, ()) -> 
    print_field f prefix
  (* 1 -- Num *)
  | Num(n, ()) -> 
    print_endline(prefix ^ "Num " ^ (green_text (string_of_int n)))
  (* x -- Var *)
  | Var(v, ()) -> 
    print_var v prefix
  | Minus(e1, e2, ()) -> print_expr e1 prefix ind; print_endline("-");print_expr e2 prefix ind
  | Null(()) -> print_endline("null")
  | Field_selection(e1, e2, ()) -> print_expr e1 prefix ind; print_endline(".");print_expr e2 prefix ind
  | Procedure(v, t, ()) -> print_endline("proc ");print_var v prefix;print_tree t prefix ind

and print_bexpr b prefix ind = 
  print_string(prefix);
  match b with
  (* true -- True*)
  | True(()) -> 
    print_endline("True " ^ (green_text "true"))
  (* false -- False*)
  | False(()) -> 
    print_endline("False " ^ (green_text "false"))
  (* e == e -- Equal To *)
  | Equal_to(e1, e2, ()) -> 
    print_endline("Equal To");
    print_expr e1 (ind ^ "├── ") (ind ^ "│   ");
    print_token "==" ind false;
    print_expr e2 (ind ^ "└── ") (ind ^ "    ")
  (* e < e -- Less Than *)
  | Less_than(e1, e2, ()) -> 
    print_endline("Less Than");
    print_expr e1 (ind ^ "├── ") (ind ^ "│   ");
    print_token "<" ind false;
    print_expr e2 (ind ^ "└── ") (ind ^ "    ")

and print_tree t prefix ind = 
  print_string(prefix);
  match t with
  (* var x;C -- Variable Delcaration *)
  | Var_declaration(v, t, ()) -> 
    print_endline("Variable Delcaration");
    print_token "var" ind false;
    print_var v (ind ^ "├── "); 
    print_token ";" ind false;
    print_tree t (ind ^ "└── ") (ind ^ "    ");
  | Proc_call(e1, e2, ()) -> print_expr e1 prefix ind;print_expr e2 prefix ind
  | Allocation(v, ()) -> print_endline("malloc"); print_var v prefix
  (* x = e -- Varaible Assignment *)
  | Var_assignment(v, e, ()) -> 
    print_endline("Varaible Assignment");
    print_var v (ind ^ "├── "); 
    print_endline("Assign");
    print_token "=" ind false;
    print_expr e (ind ^ "└── ") (ind ^ "    ")
  (* e.e = e -- Field Assignment *)
  | Field_assignment(e1, e2, e3, ()) ->
  print_endline("Field Assignment");
    print_expr e1 (ind ^ "├── ") (ind ^ "│   ");
    print_token "." ind false;
    print_expr e2 (ind ^ "├── ") (ind ^ "│   ");
    print_token "=" ind false;
    print_expr e3 (ind ^ "└── ") (ind ^ "    ")
  (* skip -- Skip *)
  | Skip(()) -> 
    print_endline("Skip " ^ (green_text "skip"))
  (* {C:C} -- Sequential Control *)
  | Seq(t1, t2, ()) -> 
    print_endline("Sequential Control");
    print_token "{" ind false;
    print_tree t1 (ind ^ "├── ") (ind ^ "│   ");
    print_token ";" ind false;
    print_tree t2 (ind ^ "├── ") (ind ^ "│   ");
    print_token "}" ind false;
  (* while b C -- While Loop *)
  | While(b, t, ()) -> 
    print_endline("While Loop");
    print_token "while" ind false;
    print_bexpr b (ind ^ "├── ") (ind ^ "│   ");
    print_tree t (ind ^ "└── ") (ind ^ "    ")
  (* if b C else C -- If Statement *)
  | If_else(b, t1, t2, ()) -> 
    print_endline("If Statement");
    print_token "if" ind false;
    print_bexpr b (ind ^ "├── ") (ind ^ "│   ");
    print_tree t1 (ind ^ "├── ") (ind ^ "│   ");
    print_token "else" ind false;
    print_tree t2 (ind ^ "└── ") (ind ^ "    ")
  (* {C|||C} -- Parallelism *)
  | Parallel(t1, t2, ()) -> 
    print_endline("Parallelism");
    print_token "{" ind false;
    print_tree t1 (ind ^ "├── ") (ind ^ "│   ");
    print_token "|||" ind false;
    print_tree t2 (ind ^ "├── ") (ind ^ "│   ");
    print_token "}" ind false;
  (* atom(C) -- Atomicity *)
  | Atom(t, ()) -> 
    print_endline("Atomicity");
    print_token "atom" ind false;
    print_token "(" ind false;
    print_tree t (ind ^ "├── ") (ind ^ "│   ");
    print_token ")" ind true;

and green_text s = "\x1B[0;32m" ^ s ^ "\x1B[0m"
and print_token t ind is_last = 
  if not is_last then print_endline(ind ^ "├── " ^ (green_text t)) 
  else print_endline (ind ^ "└── " ^ (green_text t));
;;

let lexbuf = Lexing.from_channel stdin in
  try
    print_tree (MinioolYACC.prog MinioolLEX.token lexbuf) "" "";
  with 
    | MinioolLEX.Error ->
      Printf.fprintf stderr "At offset %d: unexpected character.\n%!"(Lexing.lexeme_start lexbuf)
    |Parse_error ->
      Printf.fprintf stderr "At offset %d: syntax error.\n%!"(Lexing.lexeme_start lexbuf)
;;
