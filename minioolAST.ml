type variable = string
and 'a expr = 
  | Field of string * 'a
  | Num of int * 'a
  | Var of string * 'a
  | Minus of 'a expr * 'a expr * 'a
  | Null of 'a
  | Field_select of 'a expr * 'a expr * 'a
  | Proc_y of 'a tree * 'a
and 'a bexpr = 
  | True of 'a
  | False of 'a
  | Equal_to of 'a expr * 'a expr * 'a
  | Less_than of 'a expr * 'a expr * 'a
and 'a tree = 
  | Var_decl of variable * 'a tree * 'a
  | Proc_call of 'a expr * 'a expr * 'a
  | Alloc of variable  * 'a
  | Var_assign of variable * 'a expr * 'a
  | Field_assign of 'a expr * 'a expr * 'a expr * 'a
  | Skip of 'a
  | Seq of 'a tree * 'a tree * 'a
  | While of 'a bexpr * 'a tree * 'a
  | If_else of 'a bexpr * 'a tree * 'a tree * 'a
  | Parallel of 'a tree * 'a tree * 'a
  | Atom of 'a tree * 'a
