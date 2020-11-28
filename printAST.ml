open AbstractSyntax;;

let info_text s = "\x1B[0;96m"^s^"\x1B[0m"
;;

let rec pretty_print_prog prog =
  let vars = ref(Hashtbl.create 10) in
  pretty_print_command prog vars "START" false

and pretty_print_var v vars = 
  if (Hashtbl.mem !vars v)
  then
    let index = (string_of_int (List.length (Hashtbl.find_all !vars v))) in 
      print_endline("variable "^(info_text (v^index)))

and pretty_print_expr e vars ind is_last = 
  pretty_print_prefix ind is_last; 
  let next_ind = 
    if (String.equal ind "START") then ""
    else if not is_last then (ind^"│   ") 
    else (ind^"    ") in
  match e with
  (* f -- Field *)
  | Field(f) -> 
    print_endline("Field "^(info_text f))
  (* 1 -- Num *)
  | Num(n) -> 
    print_endline("Num "^(info_text (string_of_int n)))
  (* x -- Var *)
  | Var(v) -> 
    pretty_print_var v vars
  (* e + e -- Addition *)
  | Addition(e1, e2) -> 
    print_endline("Addition");
    pretty_print_expr e1 vars next_ind false;
    pretty_print_token "+" next_ind false;
    pretty_print_expr e2 vars next_ind true
  (* e - e -- Subtraction *)
  | Subtraction(e1, e2) -> 
    print_endline("Subtraction");
    pretty_print_expr e1 vars next_ind false;
    pretty_print_token "-" next_ind false;
    pretty_print_expr e2 vars next_ind true
  (* e * e -- Multiplication *)
  | Multiplication(e1, e2) -> 
    print_endline("Multiplication");
    pretty_print_expr e1 vars next_ind false;
    pretty_print_token "*" next_ind false;
    pretty_print_expr e2 vars next_ind true
  (* e / e -- Division *)
  | Division(e1, e2) -> 
    print_endline("Division");
    pretty_print_expr e1 vars next_ind false;
    pretty_print_token "/" next_ind false;
    pretty_print_expr e2 vars next_ind true
  (* null -- Null *)
  | Null -> 
  print_endline("Null "^(info_text "null"))
  (* e.e -- Field Selection *)
  | Field_selection(e1, e2) -> 
    print_endline("Field Selection");
    pretty_print_expr e1 vars next_ind false;
    pretty_print_token "." next_ind false;
    pretty_print_expr e2 vars next_ind true
  (* proc y:C -- Procedure *)
  | Procedure(v, t) -> 
    Hashtbl.add !vars v false;
    print_endline("Procedure");
    pretty_print_token "proc" next_ind false;
    print_string(next_ind^"├── "); pretty_print_var v vars;
    pretty_print_token ":" next_ind false;
    pretty_print_command t vars next_ind true;
    Hashtbl.remove !vars v

and pretty_print_bexpr b vars ind is_last = 
  pretty_print_prefix ind is_last; 
  let next_ind = 
    if (String.equal ind "START") then ""
    else if not is_last then (ind^"│   ") 
    else (ind^"    ") in
  match b with
  (* true -- True*)
  | True -> 
    print_endline("True "^(info_text "true"))
  (* false -- False*)
  | False -> 
    print_endline("False "^(info_text "false"))
  (* e == e -- Equal To *)
  | Equal_to(e1, e2) -> 
    print_endline("Equal To");
    pretty_print_expr e1 vars next_ind false;
    pretty_print_token "==" next_ind false;
    pretty_print_expr e2 vars next_ind true
  (* e < e -- Less Than *)
  | Less_than(e1, e2) -> 
    print_endline("Less Than");
    pretty_print_expr e1 vars next_ind false;
    pretty_print_token "<" next_ind false;
    pretty_print_expr e2 vars next_ind true

and pretty_print_command t vars ind is_last = 
  pretty_print_prefix ind is_last; 
  let next_ind = 
    if (String.equal ind "START") then ""
    else if not is_last then (ind^"│   ") 
    else (ind^"    ") in
  match t with
  (* var x;C -- Variable Delcaration *)
  | Var_declaration(v, t) -> 
    Hashtbl.add !vars v false;
    print_endline("Variable Delcaration");
    pretty_print_token "var" next_ind false;
    print_string(next_ind^"├── "); pretty_print_var v vars;
    pretty_print_token ";" next_ind false;
    pretty_print_command t vars next_ind true;
    Hashtbl.remove !vars v
  (* e(e) -- Procedure Call *)
  | Proc_call(e1, e2) -> 
    print_endline("Procedure Call");
    pretty_print_expr e1 vars next_ind false;
    pretty_print_token "(" next_ind false;
    pretty_print_expr e2 vars next_ind false;
    pretty_print_token ")" next_ind true
  (* malloc(x) -- Allocation *)
  | Allocation(v) ->
    print_endline("Allocation");
    pretty_print_token "malloc" next_ind false;
    print_string(next_ind^"├── "); pretty_print_var v vars;
  (* x = e -- Varaible Assignment *)
  | Var_assignment(v, e) -> 
    print_endline("Varaible Assignment");
    print_string(next_ind^"├── "); pretty_print_var v vars;
    pretty_print_token "=" next_ind false;
    pretty_print_expr e vars next_ind true
  (* e.e = e -- Field Assignment *)
  | Field_assignment(e1, e2, e3) ->
  print_endline("Field Assignment");
    pretty_print_expr e1 vars next_ind false;
    pretty_print_token "." next_ind false;
    pretty_print_expr e2 vars next_ind false;
    pretty_print_token "=" next_ind false;
    pretty_print_expr e3 vars next_ind true
  (* skip -- Skip *)
  | Skip -> 
    print_endline("Skip "^(info_text "skip"))
  (* {C;C} -- Sequential Control *)
  | Seq(t1, t2) -> 
    print_endline("Sequential Control");
    pretty_print_token "{" next_ind false;
    pretty_print_command t1 vars next_ind false;
    pretty_print_token ";" next_ind false;
    pretty_print_command t2 vars next_ind false;
    pretty_print_token "}" next_ind true;
  (* while b C -- While Loop *)
  | While(b, t) -> 
    print_endline("While Loop");
    pretty_print_token "while" next_ind false;
    pretty_print_bexpr b vars next_ind false;
    pretty_print_command t vars next_ind true
  (* if b C else C -- If Statement *)
  | If_else(b, t1, t2) -> 
    print_endline("If Statement");
    pretty_print_token "if" next_ind false;
    pretty_print_bexpr b vars next_ind false;
    pretty_print_command t1 vars next_ind false;
    pretty_print_token "else" next_ind false;
    pretty_print_command t2 vars next_ind true
  (* {C|||C} -- Parallelism *)
  | Parallel(t1, t2) -> 
    print_endline("Parallelism");
    pretty_print_token "{" next_ind false;
    pretty_print_command t1 vars next_ind false;
    pretty_print_token "|||" next_ind false;
    pretty_print_command t2 vars next_ind false;
    pretty_print_token "}" next_ind true;
  (* atom(C) -- Atomicity *)
  | Atom(t) -> 
    print_endline("Atomicity");
    pretty_print_token "atom" next_ind false;
    pretty_print_token "(" next_ind false;
    pretty_print_command t vars next_ind false;
    pretty_print_token ")" next_ind true

and pretty_print_token t ind is_last = 
  if not is_last then print_endline(ind^"├── "^(info_text t)) 
  else print_endline (ind^"└── "^(info_text t));

and pretty_print_prefix ind is_last = 
  if not (String.equal ind "START") then
    if not is_last 
    then print_string (ind^"├── ")
    else print_string(ind^"└── ");
;;


let rec print_command command = 
  match command with
  | Var_declaration(x, c) -> "var "^(print_variable x)^"; "^(print_command c)
  | Proc_call(e1, e2) -> (print_expr e1)^"("^(print_expr e2)^")"
  | Allocation(x) -> "malloc("^x^")"
  | Var_assignment(x, e) -> (print_variable x)^" = "^(print_expr e)
  | Field_assignment(e1, e2, e3) -> (print_expr e1)^"."^(print_expr e2)^" = "^(print_expr e3)
  | Skip -> "skip"
  | Seq(c1, c2) -> "{"^(print_command c1)^"; "^(print_command c2)^"}"
  | While(b, c) -> "while "^(print_bexpr b)^" "^(print_command c)
  | If_else(b, c1, c2) -> "if "^(print_bexpr b)^" "^(print_command c1)^" else "^(print_command c2)
  | Parallel(c1, c2) -> "{"^(print_command c1)^" ||| "^(print_command c2)^"}"
  | Atom(c) ->"atom("^(print_command c)^")"

and print_expr e = 
  match e with
  | Field(f) -> print_field f
  | Num(n) -> string_of_int(n)
  | Var(v) -> print_variable v
  | Addition(e1, e2) -> (print_expr e1)^" + "^(print_expr e2)
  | Subtraction(e1, e2) -> (print_expr e1)^" - "^(print_expr e2)
  | Multiplication(e1, e2) -> (print_expr e1)^" * "^(print_expr e2)
  | Division(e1, e2) -> (print_expr e1)^" / "^(print_expr e2)
  | Null -> "null"
  | Field_selection(e1, e2) -> (print_expr e1)^"."^(print_expr e2)
  | Procedure(v, c) -> "proc "^(print_variable v)^": "^(print_command c)
  
and print_bexpr b = 
  match b with
  | True -> "true"
  | False -> "false"
  | Equal_to(e1, e2) -> (print_expr e1)^" == "^(print_expr e2)
  | Less_than(e1, e2) -> (print_expr e1)^" < "^(print_expr e2)

and print_variable x = x
and print_field f = f
;;
