type variable = string
(* Expressions e ::= *)
and 'a expr = 
  (* f -- Field *)
  | Field of string * 'a
  (* 1 -- Num *)
  | Num of int * 'a
  (* x -- Var *)
  | Var of string * 'a
  (* e + e -- Addition *)
  | Addition of 'a expr * 'a expr * 'a
  (* e - e -- Subtraction *)
  | Subtraction of 'a expr * 'a expr * 'a
  (* e * e -- Multiplication *)
  | Multiplication of 'a expr * 'a expr * 'a
  (* e / e -- Division *)
  | Division of 'a expr * 'a expr * 'a
  (* null -- Null *)
  | Null of 'a
  (* e.e -- Field Selection *)
  | Field_selection of 'a expr * 'a expr * 'a
  (* proc y:C -- Procedure *)
  | Procedure of variable * 'a tree * 'a
(* Boolean Expressions b ::= *)
and 'a bexpr = 
  (* true -- True*)
  | True of 'a
  (* false -- False*)
  | False of 'a
  (* e == e -- Equal To *)
  | Equal_to of 'a expr * 'a expr * 'a
  (* e < e -- Less Than *)
  | Less_than of 'a expr * 'a expr * 'a
(* Commands C ::= *)
and 'a tree = 
  (* var x;C -- Variable Delcaration *)
  | Var_declaration of variable * 'a tree * 'a
  (* e(e) -- Procedure Call *)
  | Proc_call of 'a expr * 'a expr * 'a
  (* malloc(x) -- Allocation *)
  | Allocation of variable  * 'a
  (* x = e -- Varaible Assignment *)
  | Var_assignment of variable * 'a expr * 'a
  (* e.e = e -- Field Assignment *)
  | Field_assignment of 'a expr * 'a expr * 'a expr * 'a
  (* skip -- Skip *)
  | Skip of 'a
  (* {C:C} -- Sequential Control *)
  | Seq of 'a tree * 'a tree * 'a
  (* while b C -- While Loop *)
  | While of 'a bexpr * 'a tree * 'a
  (* if b C else C -- If Statement *)
  | If_else of 'a bexpr * 'a tree * 'a tree * 'a
  (* {C|||C} -- Parallelism *)
  | Parallel of 'a tree * 'a tree * 'a
  (* atom(C) -- Atomicity *)
  | Atom of 'a tree * 'a
;;



let rec print_var v vars is_used = 
  if (Hashtbl.mem !vars v)
    then
      let index = (string_of_int (List.length (Hashtbl.find_all !vars v))) in 
        if is_used
        then Hashtbl.replace !vars v true;
        print_endline("Variable "^(green_text (v^index)))
    else 
      print_endline ("Symbol: "^v^" undefined.")

and print_expr e vars ind is_last = 
  print_prefix ind is_last; 
  let next_ind = 
    if (String.equal ind "START") then ""
    else if not is_last then (ind^"│   ") 
    else (ind^"    ") in
  match e with
  (* f -- Field *)
  | Field(f, ()) -> 
    print_endline("Field "^(green_text f))
  (* 1 -- Num *)
  | Num(n, ()) -> 
    print_endline("Num "^(green_text (string_of_int n)))
  (* x -- Var *)
  | Var(v, ()) -> 
    print_var v vars true
  (* e + e -- Addition *)
  | Addition(e1, e2, ()) -> 
    print_endline("Addition");
    print_expr e1 vars next_ind false;
    print_token "+" next_ind false;
    print_expr e2 vars next_ind true
  (* e - e -- Subtraction *)
  | Subtraction(e1, e2, ()) -> 
    print_endline("Subtraction");
    print_expr e1 vars next_ind false;
    print_token "-" next_ind false;
    print_expr e2 vars next_ind true
  (* e * e -- Multiplication *)
  | Multiplication(e1, e2, ()) -> 
    print_endline("Multiplication");
    print_expr e1 vars next_ind false;
    print_token "*" next_ind false;
    print_expr e2 vars next_ind true
  (* e / e -- Division *)
  | Division(e1, e2, ()) -> 
    print_endline("Division");
    print_expr e1 vars next_ind false;
    print_token "/" next_ind false;
    print_expr e2 vars next_ind true
  (* null -- Null *)
  | Null(()) -> 
  print_endline("Null "^(green_text "null"))
  (* e.e -- Field Selection *)
  | Field_selection(e1, e2, ()) -> 
    print_endline("Field Selection");
    print_expr e1 vars next_ind false;
    print_token "." next_ind false;
    print_expr e2 vars next_ind true
  (* proc y:C -- Procedure *)
  | Procedure(v, t, ()) -> 
    Hashtbl.add !vars v false;
    print_endline("Procedure");
    print_token "proc" next_ind false;
    print_string(next_ind^"├── "); print_var v vars false;
    print_token ":" next_ind false;
    print_command t vars next_ind true;
    if not (Hashtbl.find !vars v)
    then print_endline ("Symbol: "^v^" unused.");
    Hashtbl.remove !vars v

and print_bexpr b vars ind is_last = 
  print_prefix ind is_last; 
  let next_ind = 
    if (String.equal ind "START") then ""
    else if not is_last then (ind^"│   ") 
    else (ind^"    ") in
  match b with
  (* true -- True*)
  | True(()) -> 
    print_endline("True "^(green_text "true"))
  (* false -- False*)
  | False(()) -> 
    print_endline("False "^(green_text "false"))
  (* e == e -- Equal To *)
  | Equal_to(e1, e2, ()) -> 
    print_endline("Equal To");
    print_expr e1 vars next_ind false;
    print_token "==" next_ind false;
    print_expr e2 vars next_ind true
  (* e < e -- Less Than *)
  | Less_than(e1, e2, ()) -> 
    print_endline("Less Than");
    print_expr e1 vars next_ind false;
    print_token "<" next_ind false;
    print_expr e2 vars next_ind true

and print_command t vars ind is_last = 
  print_prefix ind is_last; 
  let next_ind = 
    if (String.equal ind "START") then ""
    else if not is_last then (ind^"│   ") 
    else (ind^"    ") in
  match t with
  (* var x;C -- Variable Delcaration *)
  | Var_declaration(v, t, ()) -> 
    Hashtbl.add !vars v false;
    print_endline("Variable Delcaration");
    print_token "var" next_ind false;
    print_string(next_ind^"├── "); print_var v vars false;
    print_token ";" next_ind false;
    print_command t vars next_ind true;
    if not (Hashtbl.find !vars v)
    then print_endline ("Symbol: "^v^" unused.");
    Hashtbl.remove !vars v
  (* e(e) -- Procedure Call *)
  | Proc_call(e1, e2, ()) -> 
    print_endline("Procedure Call");
    print_expr e1 vars next_ind false;
    print_token "(" next_ind false;
    print_expr e2 vars next_ind false;
    print_token ")" next_ind true
  (* malloc(x) -- Allocation *)
  | Allocation(v, ()) ->
    print_endline("Allocation");
    print_token "malloc" next_ind false;
    print_string(next_ind^"├── "); print_var v vars true;
  (* x = e -- Varaible Assignment *)
  | Var_assignment(v, e, ()) -> 
    print_endline("Varaible Assignment");
    print_string(next_ind^"├── "); print_var v vars true;
    print_token "=" next_ind false;
    print_expr e vars next_ind true
  (* e.e = e -- Field Assignment *)
  | Field_assignment(e1, e2, e3, ()) ->
  print_endline("Field Assignment");
    print_expr e1 vars next_ind false;
    print_token "." next_ind false;
    print_expr e2 vars next_ind false;
    print_token "=" next_ind false;
    print_expr e3 vars next_ind true
  (* skip -- Skip *)
  | Skip(()) -> 
    print_endline("Skip "^(green_text "skip"))
  (* {C:C} -- Sequential Control *)
  | Seq(t1, t2, ()) -> 
    print_endline("Sequential Control");
    print_token "{" next_ind false;
    print_command t1 vars next_ind false;
    print_token ";" next_ind false;
    print_command t2 vars next_ind false;
    print_token "}" next_ind true;
  (* while b C -- While Loop *)
  | While(b, t, ()) -> 
    print_endline("While Loop");
    print_token "while" next_ind false;
    print_bexpr b vars next_ind false;
    print_command t vars next_ind true
  (* if b C else C -- If Statement *)
  | If_else(b, t1, t2, ()) -> 
    print_endline("If Statement");
    print_token "if" next_ind false;
    print_bexpr b vars next_ind false;
    print_command t1 vars next_ind false;
    print_token "else" next_ind false;
    print_command t2 vars next_ind true
  (* {C|||C} -- Parallelism *)
  | Parallel(t1, t2, ()) -> 
    print_endline("Parallelism");
    print_token "{" next_ind false;
    print_command t1 vars next_ind false;
    print_token "|||" next_ind false;
    print_command t2 vars next_ind false;
    print_token "}" next_ind true;
  (* atom(C) -- Atomicity *)
  | Atom(t, ()) -> 
    print_endline("Atomicity");
    print_token "atom" next_ind false;
    print_token "(" next_ind false;
    print_command t vars next_ind false;
    print_token ")" next_ind true;

and print_prog prog =
  let vars = ref(Hashtbl.create 10) in
  print_command prog vars "START" false

and green_text s = "\x1B[0;32m"^s^"\x1B[0m"

and print_token t ind is_last = 
  if not is_last then print_endline(ind^"├── "^(green_text t)) 
  else print_endline (ind^"└── "^(green_text t));

and print_prefix ind is_last = 
  if not (String.equal ind "START") then
    if not is_last 
    then print_string (ind^"├── ")
    else print_string(ind^"└── ");
;;

