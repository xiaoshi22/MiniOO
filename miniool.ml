(* File miniool.ml *)
open Parsing;;
open MinioolAST;;

(* sprintf *)
let print_var v = Printf.fprintf stdout "Variable [ %s ]\n%!" v;;
let print_field f = Printf.fprintf stdout "Field [ %s ]\n%!" f;;


let rec print_expr e = match e with
| Field(f, ()) -> print_field(f)
| Num(n, ()) -> print_int(n); print_endline("")
| Var(v, ()) -> print_var(v)
| Minus(e1, e2, ()) -> print_expr(e1); print_endline("-");print_expr(e2)
| Null(()) -> print_endline("null")
| Field_select(e1, e2, ()) -> print_expr(e1); print_endline(".");print_expr(e2)
| Proc_y(t, ()) -> print_endline("proc y:");print_tree(t)
and print_bexpr b = match b with
  | True(()) -> print_endline("true")
  | False(()) -> print_endline("false")
  | Equal_to(e1, e2, ()) -> print_expr(e1); print_endline("==");print_expr(e2)
  | Less_than(e1, e2, ()) -> print_expr(e1); print_endline("<");print_expr(e2)
and print_tree t = match t with
  | Var_decl(v, t, ()) -> print_var(v); print_tree(t)
  | Proc_call(e1, e2, ()) -> print_expr(e1);print_expr(e2)
  | Alloc(v, ()) -> print_endline("malloc"); print_var(v)
  | Var_assign(v, e, ()) -> print_var(v); print_endline("Assign"); print_expr(e)
  | Field_assign(e1, e2, e3, ()) -> print_expr(e1);print_expr(e2);print_expr(e3)
  | Skip(()) -> print_endline("Skip")
  | Seq(t1, t2, ()) -> print_tree(t1);print_tree(t2)
  | While(b, t, ()) -> print_endline("while");print_bexpr(b);print_tree(t)
  | If_else(b, t1, t2, ()) -> print_endline("if");print_bexpr(b);print_tree(t1);print_endline("else");print_tree(t2);
  | Parallel(t1, t2, ()) -> print_tree(t1);print_endline("parallel");print_tree(t2);
  | Atom(t, ()) -> print_endline("atom");print_tree(t);
and print_indentaion n = if n = 0 then print_string("") else print_string("\t");print_indentaion(n-1)
;;

let lexbuf = Lexing.from_channel stdin in
  try
    print_tree (MinioolYACC.prog MinioolLEX.token lexbuf);
  with 
    | MinioolLEX.Error ->
      Printf.fprintf stderr "At offset %d: unexpected character.\n%!"(Lexing.lexeme_start lexbuf)
    |Parse_error ->
      Printf.fprintf stderr "At offset %d: syntax error.\n%!"(Lexing.lexeme_start lexbuf)
;;
