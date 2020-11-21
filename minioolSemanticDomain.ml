open MinioolAST;;
exception Error;;
exception Error1;;
exception Error2;;
exception Error3;;
exception Error4;;
exception Error5;;


type integer = int
and boolean = True | False | BoolError
and obj = int 
and location = Object of obj | Null
and closure = MinioolAST.variable * MinioolAST.command * stack
and value = Field of MinioolAST.field
          | Int of integer
          | Loc of location
          | Clo of closure
and tainted_value = Val of value | TvaError
and environment = (MinioolAST.variable, obj) Hashtbl.t
and frame = Decl of environment
          | Call of environment * stack
and stack = frame list
and heap = (obj * MinioolAST.field, tainted_value) Hashtbl.t
and state = stack * heap
and control = Var_declaration of variable * control
              | Proc_call of expr * expr
              | Allocation of variable 
              | Var_assignment of variable * expr
              | Field_assignment of expr * expr * expr
              | Skip
              | Seq of control * control
              | While of bexpr * control
              | If_else of bexpr * control * control
              | Parallel of control * control
              | Atom of control
              | Block of control
and configuration = ExecutedConfig of control * state
                  | TerminatedConfig of state
                  | ConfigError
;;

(* MinioolAST.variable -> obj -> environment *)
let empty_env_func x l = 
  let env = Hashtbl.create 1 in
    Hashtbl.replace env x l;
    env
;;

(* frame -> MinioolAST.variable -> location *)
let frame_func f x = 
  let env = match f with
  | Decl(env) -> env 
  | Call(env, _) -> env 
  in if Hashtbl.mem env x then Object(Hashtbl.find env x) else Null
;;

(* stack -> MinioolAST.variable -> obj *)
let rec stack_func s x =
  match s with 
  | f::tail -> 
    (match frame_func f x with
    | Object(o) -> o
    | Null -> stack_func tail x)
  | [] -> raise Error1
;;

(* let add_all_fields_to_heap (h:heap) ol =  
  let add_l_f f _= Hashtbl.replace 
  h (ol, Field(f)) (ValTV (LocVal NullLoc)) in
  Hashtbl.iter add_l_f allFields
let initialize_fields_in_heap h l = Hashtbl.iter (fun  *)

(* heap -> obj -> field -> tainted_value *)
let heap_func h obj f = 
  if Hashtbl.mem h (obj, f) then Hashtbl.find h (obj, f) else TvaError
;;

let print_env env = 
  Hashtbl.iter (fun x obj -> Printf.printf "[%s -> l%d]" x obj) env
;;

let rec print_stack s = 
  match s with
  | Decl(env)::s' -> 
    Printf.printf "\tdecl<"; print_env env; Printf.printf ">\n%!"; print_stack s'
  | Call(env, stack)::s' ->
    Printf.printf "\tcall<"; print_env env; Printf.printf ">\n%!"; print_stack s'
  | [] -> ()
;;
let print_heap h = 
  Hashtbl.iter (fun (obj, field) tva -> Printf.printf "\t[<l%d, %s> -> %s]\n%!" obj field 
                                        (match tva with
                                        | TvaError -> "error"
                                        | Val(Field(f)) -> f 
                                        | Val(Int(n)) -> string_of_int(n)
                                        | Val(Loc(Object(o))) -> "l"^string_of_int(o)
                                        | Val(Loc(Null)) -> "null"
                                        | Val(Clo((x, c, s))) -> "Clo"^x
                                        )) h
;;

let print_config config = 
  print_endline("Configuration");
  match config with
  | ExecutedConfig(_, (s, h)) -> print_endline("\tStack:"); print_stack s; print_endline("\tHeap:"); print_heap h
  | TerminatedConfig((s, h)) -> print_endline("\tStack:"); print_stack s; print_endline("\tHeap:"); print_heap h
  | ConfigError -> Printf.fprintf stdout "ConfigError\n%!"

(* expr -> state -> Tva *)
let rec eval e (s, h) = match e with
  (* f -- Field *)
  | MinioolAST.Field(f) -> Val(Field(f))
  (* 1 -- Num *)
  | Num(n) -> Val(Int(n))
  (* x -- Var *)
  | Var(x) -> (heap_func h (stack_func s x) "val")
  (* e + e -- Addition *)
  | Addition(e1, e2) -> 
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 + v2))
    | _ -> TvaError)
  (* e - e -- Subtraction *)
  | Subtraction(e1, e2) -> 
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 - v2))
    | _ -> TvaError)
  (* e * e -- Multiplication *)
  | Multiplication(e1, e2) ->
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 + v2))
    | _ -> TvaError)
  (* e / e -- Division *)
  | Division(e1, e2) ->
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 + v2))
    | _ -> TvaError)
  (* null -- Null *)
  | Null -> Val(Loc(Null))
  (* e.e -- Field Selection *)
  | Field_selection(e1, e2) ->
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Loc(Object(obj))), Val(Field(f)) -> (heap_func h obj f)
    | _ -> TvaError)
  (* proc y:C -- Procedure *)
  | Procedure(x, c) -> Val(Clo(x, c, s))
;;

(* expr -> state -> boolean *)
let rec bool_eval e (s, h) = match e with
  (* true -- True*)
  | MinioolAST.True -> True
  (* false -- False*)
  | MinioolAST.False -> False
  (* e == e -- Equal To *)
  | Equal_to(e1, e2) ->
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> if v1=v2 then True else False
    | Val(Loc(v1)), Val(Loc(v2)) -> if v1=v2 then True else False
    | Val(Clo(v1)), Val(Clo(v2)) -> if v1=v2 then True else False
    | _ -> BoolError)
  (* e < e -- Less Than *)
  | Less_than(e1, e2) ->
    (match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> if v1<v2 then True else False
    | _ -> BoolError)
;;

let rec transfer_command_to_control cmd = match cmd with
  | MinioolAST.Var_declaration(x, c) -> Var_declaration(x, transfer_command_to_control(c))
  | MinioolAST.Proc_call(e1, e2) -> Proc_call(e1, e2)
  | MinioolAST.Allocation(x) -> Allocation(x)
  | MinioolAST.Var_assignment(x, e) -> Var_assignment(x, e)
  | MinioolAST.Field_assignment(e1, e2, e3) -> Field_assignment(e1, e2, e3)
  | MinioolAST.Skip -> Skip
  | MinioolAST.Seq(c1, c2) -> Seq(transfer_command_to_control(c1), transfer_command_to_control(c2))
  | MinioolAST.While(b, c) -> While(b, transfer_command_to_control(c))
  | MinioolAST.If_else(b, c1, c2) -> If_else(b, transfer_command_to_control(c1), transfer_command_to_control(c2))
  | MinioolAST.Parallel(c1, c2) -> Parallel(transfer_command_to_control(c1), transfer_command_to_control(c2))
  | MinioolAST.Atom(c) -> Atom(transfer_command_to_control(c))

let rec execute_prog prog = 
  let initial_config = ExecutedConfig(transfer_command_to_control(prog), ([], (Hashtbl.create 10))) in
    let state = execute_config initial_config in
      print_config (TerminatedConfig(state))

(* config -> state *)
and execute_config config =
  print_config config;
  match proceed_transition_relation config with
  | ExecutedConfig(_, _) as config -> execute_config config
  | TerminatedConfig(state) -> state
  | ConfigError -> raise Error

(* config -> config *)
and proceed_transition_relation config = 
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
      | _ -> ConfigError)
      (* malloc(x) -- Allocation *)
      (* | Allocation(x) ->
        let l = (Hashtbl.length h) in
        let h' = Hashtbl.copy h in
        Hashtbl.replace h' (stack_func s x, "val") (Val(Loc(Object(l))));
        initialize_fields_in_heap h' l;
        TerminatedConfig((s, h')) *)
      (* x = e -- Varaible Assignment *)
      | Var_assignment(x, e) ->
        (match eval e (s, h) with
        | TvaError -> ConfigError
        | Val(v) ->
          let h' = Hashtbl.copy h 
          and o = stack_func s x in 
            Hashtbl.replace h' (o, "val") (Val(v)); 
            TerminatedConfig((s, h')))
      (* e.e = e -- Field Assignment *)
      (* | Field_assignment(e, e', e'') ->
        (match eval e (s, h), eval e' (s, h) with
        | -> TerminatedConfig(s, heap_func h )
        |_ -> ConfigError) *)
      (* skip -- Skip *)
      | Skip -> TerminatedConfig((s, h))
      (* {C:C} -- Sequential Control *)
      | Seq(c1, c2) ->
        (match proceed_transition_relation (ExecutedConfig(c1, (s, h))) with
        | ExecutedConfig(c1', state') -> ExecutedConfig(Seq(c1', c2), state')
        | TerminatedConfig(state') -> ExecutedConfig(c2, state')
        | ConfigError -> ConfigError)
      (* while b C -- While Loop *)
      | While(b, c) ->
        (match bool_eval b (s, h) with
        | True -> ExecutedConfig(Seq(c, While(b, c)), (s, h))
        | False -> TerminatedConfig((s, h))
        | BoolError -> ConfigError)
      (* if b C else C -- If Statement *)
      | If_else(b, c1, c2) ->
        (match bool_eval b (s, h) with
        | True -> ExecutedConfig(c1, (s, h))
        | False -> ExecutedConfig(c2, (s, h))
        | BoolError -> ConfigError)
      (* {C|||C} -- Parallelism *)
      | Parallel(c1, c2) -> Random.self_init ();if Random.bool()
      then 
      (match proceed_transition_relation (ExecutedConfig(c1, (s, h))) with
      | ExecutedConfig(c1', state') -> ExecutedConfig(Parallel(c1', c2), state')
      | TerminatedConfig(state') -> ExecutedConfig(c2, state')
      | ConfigError -> ConfigError)
      else 
      (match proceed_transition_relation (ExecutedConfig(c2, (s, h))) with
      | ExecutedConfig(c2', state') -> ExecutedConfig(Parallel(c1, c2'), state')
      | TerminatedConfig(state') -> ExecutedConfig(c1, state')
      | ConfigError -> ConfigError)
      (* atom(C) -- Atomicity *)
      | Atom(c) -> TerminatedConfig(execute_config (ExecutedConfig(c, (s, h))))
      (* Block(C) -- Blcok *)
      | Block(c) ->
        (match proceed_transition_relation (ExecutedConfig(c, (s, h))) with
        | ExecutedConfig(control, state') -> ExecutedConfig(Block(control), state')
        | TerminatedConfig((Decl(env)::prev_s, h)) -> TerminatedConfig((prev_s, h))
        | TerminatedConfig((Call(env, prev_s)::decl_s, h)) -> TerminatedConfig((prev_s, h))
        | TerminatedConfig([], _) as config' -> config'
        | ConfigError -> ConfigError)
      | _ -> ConfigError)
  | TerminatedConfig(_) -> ConfigError
  | ConfigError -> ConfigError
;;
