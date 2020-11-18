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
