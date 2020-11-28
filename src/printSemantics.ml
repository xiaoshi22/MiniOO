open PrintAST;;
open SemanticDomain;;

let print_env env = 
  Hashtbl.iter (fun x obj -> Printf.printf "[%s -> l%d]" x obj) env
;;

let rec print_stack s = 
  match s with
  | Decl(env)::s' -> 
    Printf.printf "decl<"; print_env env; Printf.printf ">\n%!"; print_stack s'
  | Call(env, stack)::s' ->
    Printf.printf "call<"; print_env env; Printf.printf ">\n%!"; print_stack s'
  | [] -> ()
;;

let print_tva tva =
  match tva with
  | TvaError(err) -> err
  | Val(Field(f)) -> f
  | Val(Int(n)) -> string_of_int(n)
  | Val(Loc(Object(o))) -> "l"^string_of_int(o)
  | Val(Loc(Null)) -> "null"
  | Val(Clo((x, c, s))) -> "Clo<"^x^", "^(print_command c)^">"
;;

let print_heap h = 
  Hashtbl.iter (fun (obj, field) tva -> Printf.printf "[<l%d, %s> -> %s]\n%!" obj field (print_tva tva)) h
;;

let print_state (s, h) =     
  print_endline(info_text "Stack:"); 
  print_stack s; 
  print_endline(info_text "Heap:"); 
  print_heap h
;;

let rec print_control control = 
  match control with
  | Var_declaration(x, c) -> "var "^(print_variable x)^"; "^(print_control c)
  | Proc_call(e1, e2) -> (print_expr e1)^"("^(print_expr e2)^")"
  | Allocation(x) -> "malloc("^x^")"
  | Var_assignment(x, e) -> (print_variable x)^" = "^(print_expr e)
  | Field_assignment(e1, e2, e3) -> (print_expr e1)^"."^(print_expr e2)^" = "^(print_expr e3)
  | Skip -> "skip"
  | Seq(c1, c2) -> "{"^(print_control c1)^"; "^(print_control c2)^"}"
  | While(b, c) -> "while "^(print_bexpr b)^" "^(print_control c)
  | If_else(b, c1, c2) -> "if "^(print_bexpr b)^" "^(print_control c1)^" else "^(print_control c2)
  | Parallel(c1, c2) -> "{"^(print_control c1)^" ||| "^(print_control c2)^"}"
  | Atom(c) ->"atom("^(print_control c)^")"
  | Block(c) -> "block("^(print_control c)^")"
;;

let print_config config = 
  match config with
  | ExecutedConfig(control, (s, h)) -> 
    print_string(info_text "Control:\n"); 
    print_endline(print_control control); 
    print_state (s, h)
  | TerminatedConfig((s, h)) -> print_state (s, h)
  | ConfigError(err) -> print_endline(info_text "Configuration Error")
  ;;
