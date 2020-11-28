open PrintAST;;
open SemanticDomain;;
open PrintSemantics;;
exception Error of string;;


let rec transfer_command_to_control cmd = match cmd with
  | AbstractSyntax.Var_declaration(x, c) -> Var_declaration(x, transfer_command_to_control(c))
  | AbstractSyntax.Proc_call(e1, e2) -> Proc_call(e1, e2)
  | AbstractSyntax.Allocation(x) -> Allocation(x)
  | AbstractSyntax.Var_assignment(x, e) -> Var_assignment(x, e)
  | AbstractSyntax.Field_assignment(e1, e2, e3) -> Field_assignment(e1, e2, e3)
  | AbstractSyntax.Skip -> Skip
  | AbstractSyntax.Seq(c1, c2) -> Seq(transfer_command_to_control(c1), transfer_command_to_control(c2))
  | AbstractSyntax.While(b, c) -> While(b, transfer_command_to_control(c))
  | AbstractSyntax.If_else(b, c1, c2) -> If_else(b, transfer_command_to_control(c1), transfer_command_to_control(c2))
  | AbstractSyntax.Parallel(c1, c2) -> Parallel(transfer_command_to_control(c1), transfer_command_to_control(c2))
  | AbstractSyntax.Atom(c) -> Atom(transfer_command_to_control(c))
;;

(* AbstractSyntax.variable -> obj -> environment *)
let empty_env_func x l = 
  let env = Hashtbl.create 1 in
    Hashtbl.replace env x l;
    env
;;

(* frame -> AbstractSyntax.variable -> location *)
let frame_func f x = 
  let env = match f with
  | Decl(env) -> env 
  | Call(env, _) -> env 
  in if Hashtbl.mem env x then Object(Hashtbl.find env x) else Null
;;

(* stack -> AbstractSyntax.variable -> obj *)
let rec stack_func s x =
  match s with 
  | f::tail -> 
    (match frame_func f x with
    | Object(o) -> o
    | Null -> stack_func tail x)
  | [] -> raise (Error("variable `"^x^"` is not found in stack."))
;;

let initialize_fields_in_heap h l fields = 
  Hashtbl.iter (fun f _ -> Hashtbl.replace h (l, f) (Val(Loc(Null)))) fields
;;

(* heap -> obj -> field -> tainted_value *)
let heap_func h obj f = 
  if Hashtbl.mem h (obj, f) then Hashtbl.find h (obj, f) else TvaError("`<l"^string_of_int(obj)^", "^f^">` is not found in heap.")
;;

(* expr -> state -> Tva *)
let rec eval e (s, h) = match e with
  (* f -- Field *)
  | AbstractSyntax.Field(f) -> Val(Field(f))
  (* 1 -- Num *)
  | Num(n) -> Val(Int(n))
  (* x -- Var *)
  | Var(x) -> (heap_func h (stack_func s x) "val")
  (* e + e -- Addition *)
  | Addition(e1, e2) -> 
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 + v2))
    | TvaError(err) as tva_err, _ -> tva_err
    | _, (TvaError(err) as tva_err) -> tva_err
    | Val(Int(_)), _ -> TvaError("the right operand `"^(print_expr e2)^"` of Addition is not a number.")
    | _ -> TvaError("the left operand `"^(print_expr e1)^"` of Addition is not a number."))
  (* e - e -- Subtraction *)
  | Subtraction(e1, e2) -> 
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 - v2))
    | TvaError(err) as tva_err, _ -> tva_err
    | _, (TvaError(err) as tva_err) -> tva_err
    | Val(Int(_)), _ -> TvaError("the right operand `"^(print_expr e2)^"` of Subtraction is not a number.")
    | _ -> TvaError("the left operand `"^(print_expr e1)^"` of Subtraction is not a number."))
  (* e * e -- Multiplication *)
  | Multiplication(e1, e2) ->
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 * v2))
    | TvaError(err) as tva_err, _ -> tva_err
    | _, (TvaError(err) as tva_err) -> tva_err
    | Val(Int(_)), _ -> TvaError("the right operand `"^(print_expr e2)^"` of Multiplication is not a number.")
    | _ -> TvaError("the left operand `"^(print_expr e1)^"` of Multiplication is not a number."))
  (* e / e -- Division *)
  | Division(e1, e2) ->
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 / v2))
    | TvaError(err) as tva_err, _ -> tva_err
    | _, (TvaError(err) as tva_err) -> tva_err
    | Val(Int(_)), _ -> TvaError("the right operand `"^(print_expr e2)^"` of Division is not a number.")
    | _ -> TvaError("the left operand `"^(print_expr e1)^"` of Division is not a number."))
  (* null -- Null *)
  | Null -> Val(Loc(Null))
  (* e.e -- Field Selection *)
  | Field_selection(e1, e2) ->
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Loc(Object(obj))), Val(Field(f)) -> heap_func h obj f
    | TvaError(err) as tva_err, _ -> tva_err
    | _, (TvaError(err) as tva_err) -> tva_err
    | Val(Loc(Object(_))), _ -> TvaError("the right operand `"^(print_expr e2)^"` of Field Selection is not a field.")
    | _  -> TvaError("the left operand of Field Selection `"^(print_expr e1)^"` is not an object."))
  (* proc y:C -- Procedure *)
  | Procedure(x, c) -> Val(Clo(x, c, s))
  ;;

(* expr -> state -> boolean *)
let rec bool_eval e (s, h) = match e with
  (* true -- True*)
  | AbstractSyntax.True -> True
  (* false -- False*)
  | AbstractSyntax.False -> False
  (* e == e -- Equal To *)
  | Equal_to(e1, e2) ->
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> if v1=v2 then True else False
    | Val(Int(_)), _ -> BoolError("the right operand `"^(print_expr e2)^"` of Equal To is not a number.")
    | Val(Loc(v1)), Val(Loc(v2)) -> if v1=v2 then True else False
    | Val(Loc(_)), _ -> BoolError("the right operand `"^(print_expr e2)^"` of Equal To is not a location.")
    | Val(Clo(v1)), Val(Clo(v2)) -> if v1=v2 then True else False
    | Val(Clo(_)), _ -> BoolError("the right operand `"^(print_expr e2)^"` of Equal To is not a closure.")
    | TvaError(err), _ -> BoolError("the left operand `"^(print_expr e1)^"` of Equal To is not valid: "^err)
    | _, TvaError(err) ->  BoolError("the right operand `"^(print_expr e2)^"` of Equal To is not valid: "^err)
    | _ -> BoolError("Equal To is not applied on the left operand `"^(print_expr e1)^"`, which is not number, location or closure."))
  (* e < e -- Less Than *)
  | Less_than(e1, e2) ->
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> if v1<v2 then True else False
    | TvaError(err), _ -> BoolError("the left operand `"^(print_expr e1)^"` of Equal To is not valid: "^err)
    | _, TvaError(err) ->  BoolError("the right operand `"^(print_expr e2)^"` of Equal To is not valid: "^err)
    | Val(Int(_)), _ -> BoolError("the right operand `"^(print_expr e2)^"` of Less Than is not a number.")
    | _ -> BoolError("the left operand `"^(print_expr e1)^"` of Less Than is not a number."))
;;

let rec execute_prog prog fields = 
  let initial_config = ExecutedConfig(transfer_command_to_control(prog), ([], (Hashtbl.create 10))) in
    let state = execute_config initial_config fields in
      print_config (TerminatedConfig(state))

(* config -> state *)
and execute_config config fields =
  print_config config;
  print_endline("\x1B[0;96m>>======>\x1B[0m");
  match proceed_transition_relation config fields with
  | ExecutedConfig(_, _) as config -> execute_config config fields
  | TerminatedConfig(state) -> state
  | ConfigError err -> raise (Error(err))


(* config -> config *)
and proceed_transition_relation config fields = 
  match config with
  | ExecutedConfig(ctrl, (s, h)) -> 
      (match ctrl with
      (* var x;C -- Variable Delcaration *)
      | Var_declaration(x, c) -> 
        let l = (Hashtbl.length h) in
        let s' = Decl(empty_env_func x l)::s 
        and h' = Hashtbl.copy h in
        Hashtbl.replace h' (l, "val") (Val(Loc(Null)));
        ExecutedConfig(Block(c), (s', h'))
      (* e(e) -- Procedure Call *)
      | Proc_call(e, e') ->
      (match eval e (s, h) with
      | Val(Clo((x, c, s'))) -> 
        let l = (Hashtbl.length h) in
        let h' = Hashtbl.copy h 
        and s'' = Call((empty_env_func x l), s)::s' in
        Hashtbl.replace h' (l, "val") (eval e' (s, h));
        ExecutedConfig(Block(transfer_command_to_control(c)), (s'', h'))
      | TvaError(err) -> ConfigError("In the Procedure Call, "^err)
      | _ -> ConfigError("In the Procedure Call, `"^(print_expr e)^"` is not a procedure."))
      (* malloc(x) -- Allocation *)
      | Allocation(x) ->
        let l = (Hashtbl.length h) in
        let h' = Hashtbl.copy h in
        Hashtbl.replace h' (stack_func s x, "val") (Val(Loc(Object(l))));
        initialize_fields_in_heap h' l fields;
        TerminatedConfig((s, h'))
      (* x = e -- Varaible Assignment *)
      | Var_assignment(x, e) ->
        (match eval e (s, h) with
        | TvaError(err) -> ConfigError("on the right side of Variable Assignment, "^err)
        | Val(v) ->
          let h' = Hashtbl.copy h 
          and o = stack_func s x in 
            Hashtbl.replace h' (o, "val") (Val(v)); 
            TerminatedConfig((s, h')))
      (* e.e = e -- Field Assignment *)
      | Field_assignment(e, e', e'') ->
        (match eval e (s, h), eval e' (s, h) with
        | Val(Loc(Object(l))), Val(Field(f)) -> 
          let h' = Hashtbl.copy h in
          Hashtbl.replace h' (l, f) (eval e'' (s, h)); 
          TerminatedConfig((s, h'))
        | TvaError(err), _ ->  ConfigError("In the Field Assignment, "^err)
        | _, TvaError(err) -> ConfigError("In the Field Assignment, "^err)
        | _, Val(Field(f)) -> ConfigError("on the left side of Field Assignment, the right operand `"^(print_expr e')^"` of Field Selection is not a field.")
        | _  -> ConfigError("on the left side of Field Assignment, the left operand of Field Selection `"^(print_expr e)^"` is not an object."))
        (* skip -- Skip *)
      | Skip -> TerminatedConfig((s, h))
      (* {C:C} -- Sequential Control *)
      | Seq(c1, c2) ->
        (match proceed_transition_relation (ExecutedConfig(c1, (s, h))) fields with
        | ExecutedConfig(c1', state') -> ExecutedConfig(Seq(c1', c2), state')
        | TerminatedConfig(state') -> ExecutedConfig(c2, state')
        | ConfigError(err) -> ConfigError(err))
      (* while b C -- While Loop *)
      | While(b, c) ->
        (match bool_eval b (s, h) with
        | True -> ExecutedConfig(Seq(c, While(b, c)), (s, h))
        | False -> TerminatedConfig((s, h))
        | BoolError(err) -> ConfigError("In the condition of While Loop, "^err))
      (* if b C else C -- If Statement *)
      | If_else(b, c1, c2) ->
        (match bool_eval b (s, h) with
        | True -> ExecutedConfig(c1, (s, h))
        | False -> ExecutedConfig(c2, (s, h))
        | BoolError(err) -> ConfigError("In the condition of If Statement, "^err))
      (* {C|||C} -- Parallelism *)
      | Parallel(c1, c2) -> Random.self_init ();if Random.bool()
      then 
      (match proceed_transition_relation (ExecutedConfig(c1, (s, h))) fields with
      | ExecutedConfig(c1', state') -> ExecutedConfig(Parallel(c1', c2), state')
      | TerminatedConfig(state') -> ExecutedConfig(c2, state')
      | ConfigError(err) -> ConfigError(err))
      else 
      (match proceed_transition_relation (ExecutedConfig(c2, (s, h))) fields with
      | ExecutedConfig(c2', state') -> ExecutedConfig(Parallel(c1, c2'), state')
      | TerminatedConfig(state') -> ExecutedConfig(c1, state')
      | ConfigError(err) -> ConfigError(err))
      (* atom(C) -- Atomicity *)
      | Atom(c) -> TerminatedConfig(execute_config (ExecutedConfig(c, (s, h))) fields)
      (* Block(C) -- Blcok *)
      | Block(c) ->
        (match proceed_transition_relation (ExecutedConfig(c, (s, h))) fields with
        | ExecutedConfig(control, state') -> ExecutedConfig(Block(control), state')
        | TerminatedConfig((Decl(env)::prev_s, h)) -> TerminatedConfig((prev_s, h))
        | TerminatedConfig((Call(env, prev_s)::decl_s, h)) -> TerminatedConfig((prev_s, h))
        | TerminatedConfig([], _) as config' -> config'
        | ConfigError(err) -> ConfigError(err)))
  | TerminatedConfig(_) -> ConfigError("The terminated configuration should not be executed.")
  | ConfigError(err) as config_err -> config_err
;;
