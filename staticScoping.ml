open AbstractSyntax;;
exception Error of string;;

let rec check_prog prog =
  let vars = ref(Hashtbl.create 10) 
  and fields = ref(Hashtbl.create 10) in
  check_command prog vars fields;
  fields;

and check_var v vars is_used = 
  if (Hashtbl.mem !vars v)
  then (if is_used then Hashtbl.replace !vars v true)
  else 
    raise (Error(v))

and check_expr e vars fields = 
  match e with
  (* f -- Field *)
  | Field(f) -> 
    Hashtbl.replace !fields f true
  (* 1 -- Num *)
  | Num(n) -> ()
  (* x -- Var *)
  | Var(v) -> 
    check_var v vars true
  (* e + e -- Addition *)
  | Addition(e1, e2) -> 
    check_expr e1 vars fields;
    check_expr e2 vars fields
  (* e - e -- Subtraction *)
  | Subtraction(e1, e2) -> 
    check_expr e1 vars fields;
    check_expr e2 vars fields
  (* e * e -- Multiplication *)
  | Multiplication(e1, e2) -> 
    check_expr e1 vars fields;
    check_expr e2 vars fields
  (* e / e -- Division *)
  | Division(e1, e2) -> 
    check_expr e1 vars fields;
    check_expr e2 vars fields
  (* null -- Null *)
  | Null -> ()
  (* e.e -- Field Selection *)
  | Field_selection(e1, e2) -> 
    check_expr e1 vars fields;
    check_expr e2 vars fields;
  (* proc y:C -- Procedure *)
  | Procedure(v, c) -> 
    Hashtbl.add !vars v false;
    check_var v vars false;
    check_command c vars fields;
    if not (Hashtbl.find !vars v)
    then print_endline ("\x1B[1;93mwarning\x1B[0m: variable "^v^" is declared but not used.");
    Hashtbl.remove !vars v

and check_bexpr b vars fields = 
  match b with
  (* true -- True*)
  | True -> ()
  (* false -- False*)
  | False -> ()
  (* e == e -- Equal To *)
  | Equal_to(e1, e2) -> 
    check_expr e1 vars fields;
    check_expr e2 vars fields
  (* e < e -- Less Than *)
  | Less_than(e1, e2) -> 
    check_expr e1 vars fields;
    check_expr e2 vars fields

and check_command c vars fields = 
  match c with
  (* var x;C -- Variable Delcaration *)
  | Var_declaration(v, c) -> 
    Hashtbl.add !vars v false;
    check_var v vars false;
    check_command c vars fields;
    if not (Hashtbl.find !vars v)
    then print_endline ("\x1B[1;93mWarning\x1B[0m: variable "^v^" is declared but not used.");
    Hashtbl.remove !vars v
  (* e(e) -- Procedure Call *)
  | Proc_call(e1, e2) -> 
    check_expr e1 vars fields;
    check_expr e2 vars fields
  (* malloc(x) -- Allocation *)
  | Allocation(v) -> 
    check_var v vars true;
  (* x = e -- Varaible Assignment *)
  | Var_assignment(v, e) -> 
    check_var v vars true;
    check_expr e vars fields
  (* e.e = e -- Field Assignment *)
  | Field_assignment(e1, e2, e3) ->
    check_expr e1 vars fields;
    check_expr e2 vars fields;
    check_expr e3 vars fields
  (* skip -- Skip *)
  | Skip -> ()
  (* {C;C} -- Sequential Control *)
  | Seq(c1, c2) ->
    check_command c1 vars fields;
    check_command c2 vars fields
  (* while b C -- While Loop *)
  | While(b, c) -> 
    check_bexpr b vars fields;
    check_command c vars fields
  (* if b C else C -- If Statement *)
  | If_else(b, c1, c2) -> 
    check_bexpr b vars fields;
    check_command c1 vars fields;
    check_command c2 vars fields
  (* {C|||C} -- Parallelism *)
  | Parallel(c1, c2) -> 
    check_command c1 vars fields;
    check_command c2 vars fields
  (* atom(C) -- Atomicity *)
  | Atom(c) -> 
    check_command c vars fields
;;
