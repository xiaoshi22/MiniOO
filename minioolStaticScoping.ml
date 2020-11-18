open MinioolAST;;
exception Error of string;;

let rec check_prog prog =
  let vars = ref(Hashtbl.create 10) in
  check_command prog vars

and check_var v vars is_used = 
  if (Hashtbl.mem !vars v)
  then (if is_used then Hashtbl.replace !vars v true)
  else 
    raise (Error(v))

and check_expr e vars = 
  match e with
  (* f -- Field *)
  | Field(f, ()) -> ()
  (* 1 -- Num *)
  | Num(n, ()) -> ()
  (* x -- Var *)
  | Var(v, ()) -> 
    check_var v vars true
  (* e + e -- Addition *)
  | Addition(e1, e2, ()) -> 
    check_expr e1 vars;
    check_expr e2 vars
  (* e - e -- Subtraction *)
  | Subtraction(e1, e2, ()) -> 
    check_expr e1 vars;
    check_expr e2 vars
  (* e * e -- Multiplication *)
  | Multiplication(e1, e2, ()) -> 
    check_expr e1 vars;
    check_expr e2 vars
  (* e / e -- Division *)
  | Division(e1, e2, ()) -> 
    check_expr e1 vars;
    check_expr e2 vars
  (* null -- Null *)
  | Null(()) -> ()
  (* e.e -- Field Selection *)
  | Field_selection(e1, e2, ()) -> 
    check_expr e1 vars;
    check_expr e2 vars
  (* proc y:C -- Procedure *)
  | Procedure(v, t, ()) -> 
    Hashtbl.add !vars v false;
    check_var v vars false;
    check_command t vars;
    if not (Hashtbl.find !vars v)
    then print_endline ("\x1B[0;93mwarning: variable "^v^" is declared but not used.\x1B[0m");
    Hashtbl.remove !vars v

and check_bexpr b vars = 
  match b with
  (* true -- True*)
  | True(()) -> ()
  (* false -- False*)
  | False(()) -> ()
  (* e == e -- Equal To *)
  | Equal_to(e1, e2, ()) -> 
    check_expr e1 vars;
    check_expr e2 vars
  (* e < e -- Less Than *)
  | Less_than(e1, e2, ()) -> 
    check_expr e1 vars;
    check_expr e2 vars

and check_command t vars = 
  match t with
  (* var x;C -- Variable Delcaration *)
  | Var_declaration(v, t, ()) -> 
    Hashtbl.add !vars v false;
    check_var v vars false;
    check_command t vars;
    if not (Hashtbl.find !vars v)
    then print_endline ("\x1B[0;93mWarning: variable "^v^" is declared but not used.\x1B[0m");
    Hashtbl.remove !vars v
  (* e(e) -- Procedure Call *)
  | Proc_call(e1, e2, ()) -> 
    check_expr e1 vars;
    check_expr e2 vars
  (* malloc(x) -- Allocation *)
  | Allocation(v, ()) -> 
    check_var v vars true;
  (* x = e -- Varaible Assignment *)
  | Var_assignment(v, e, ()) -> 
    check_var v vars true;
    check_expr e vars
  (* e.e = e -- Field Assignment *)
  | Field_assignment(e1, e2, e3, ()) ->
    check_expr e1 vars;
    check_expr e2 vars;
    check_expr e3 vars
  (* skip -- Skip *)
  | Skip(()) -> ()
  (* {C:C} -- Sequential Control *)
  | Seq(t1, t2, ()) ->
    check_command t1 vars;
    check_command t2 vars
  (* while b C -- While Loop *)
  | While(b, t, ()) -> 
    check_bexpr b vars;
    check_command t vars
  (* if b C else C -- If Statement *)
  | If_else(b, t1, t2, ()) -> 
    check_bexpr b vars;
    check_command t1 vars;
    check_command t2 vars
  (* {C|||C} -- Parallelism *)
  | Parallel(t1, t2, ()) -> 
    check_command t1 vars;
    check_command t2 vars
  (* atom(C) -- Atomicity *)
  | Atom(t, ()) -> 
    check_command t vars
;;