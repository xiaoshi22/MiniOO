type variable = string
type field = string
(* Expressions e ::= *)
and expr = 
  (* f -- Field *)
  | Field of field
  (* 1 -- Num *)
  | Num of int
  (* x -- Var *)
  | Var of variable
  (* e + e -- Addition *)
  | Addition of expr * expr
  (* e - e -- Subtraction *)
  | Subtraction of expr * expr
  (* e * e -- Multiplication *)
  | Multiplication of expr * expr
  (* e / e -- Division *)
  | Division of expr * expr
  (* null -- Null *)
  | Null
  (* e.e -- Field Selection *)
  | Field_selection of expr * expr
  (* proc y:C -- Procedure *)
  | Procedure of variable * command
(* Boolean Expressions b ::= *)
and bexpr = 
  (* true -- True*)
  | True
  (* false -- False*)
  | False
  (* e == e -- Equal To *)
  | Equal_to of expr * expr
  (* e < e -- Less Than *)
  | Less_than of expr * expr
(* Commands C ::= *)
and command = 
  (* var x;C -- Variable Delcaration *)
  | Var_declaration of variable * command
  (* e(e) -- Procedure Call *)
  | Proc_call of expr * expr
  (* malloc(x) -- Allocation *)
  | Allocation of variable 
  (* x = e -- Varaible Assignment *)
  | Var_assignment of variable * expr
  (* e.e = e -- Field Assignment *)
  | Field_assignment of expr * expr * expr
  (* skip -- Skip *)
  | Skip
  (* {C;C} -- Sequential Control *)
  | Seq of command * command
  (* while b C -- While Loop *)
  | While of bexpr * command
  (* if b C else C -- If Statement *)
  | If_else of bexpr * command * command
  (* {C|||C} -- Parallelism *)
  | Parallel of command * command
  (* atom(C) -- Atomicity *)
  | Atom of command
;;
