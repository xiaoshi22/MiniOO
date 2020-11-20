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
and control = Command of MinioolAST.command | Block of control
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
    begin
    match frame_func f x with
    | Object(o) -> o
    | Null -> stack_func tail x
    end
  | [] -> raise Error1
;;


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
    begin
    match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 + v2))
    | _ -> TvaError
    end
  (* e - e -- Subtraction *)
  | Subtraction(e1, e2) -> 
    begin
    match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 - v2))
    | _ -> TvaError
    end
  (* e * e -- Multiplication *)
  | Multiplication(e1, e2) ->
    begin
    match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 + v2))
    | _ -> TvaError
    end
  (* e / e -- Division *)
  | Division(e1, e2) ->
    begin
    match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> Val(Int(v1 + v2))
    | _ -> TvaError
    end
  (* null -- Null *)
  | Null -> Val(Loc(Null))
  (* e.e -- Field Selection *)
  | Field_selection(e1, e2) ->
    begin
    match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Loc(Object(obj))), Val(Field(f)) -> (heap_func h obj f)
    | _ -> TvaError
    end
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
    begin
    match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> if v1=v2 then True else False
    | Val(Loc(v1)), Val(Loc(v2)) -> if v1=v2 then True else False
    | Val(Clo(v1)), Val(Clo(v2)) -> if v1=v2 then True else False
    | _ -> BoolError
    end
  (* e < e -- Less Than *)
  | Less_than(e1, e2) ->
    begin
    match (eval e1 (s, h)), (eval e2 (s, h)) with
    | Val(Int(v1)), Val(Int(v2)) -> if v1<v2 then True else False
    | _ -> BoolError
    end
;;

let rec execute_prog prog = 
  let initial_config = ExecutedConfig(Command(prog), ([], (Hashtbl.create 10))) in
    let state = execute_config initial_config in
      print_config (TerminatedConfig(state))

(* config -> config *)
and execute_config config =
  print_config config;
  match proceed_transition_relation config with
  | ExecutedConfig(_, _) as config -> execute_config config
  | TerminatedConfig(state) -> state
  | ConfigError -> raise Error

(* config -> config *)
and proceed_transition_relation config = 
  match config with
  | ExecutedConfig(Command(cmd), (s, h)) -> 
    begin
      match cmd with
      (* var x;C -- Variable Delcaration *)
      | Var_declaration(x, c) -> 
        let l = (Hashtbl.length h) in
        let s' = Decl(empty_env_func x l)::s 
        and h' = Hashtbl.copy h in
        Hashtbl.replace h' (l, "val") (Val(Loc(Null)));
        ExecutedConfig(Block(Command(c)), (s', h'))
      (* x = e -- Varaible Assignment *)
      | Var_assignment(x, e) ->
        begin
        match eval e (s, h) with
        | TvaError -> ConfigError
        | Val(v) ->
          let h' = Hashtbl.copy h 
          and o = stack_func s x in 
            Hashtbl.replace h' (o, "val") (Val(v)); 
            TerminatedConfig((s, h'))
        end
      (* skip -- Skip *)
      | Skip -> TerminatedConfig((s, h))
      (* {C:C} -- Sequential Control *)
      | Seq(c1, c2) ->
        (match proceed_transition_relation (ExecutedConfig(Command(c1), (s, h))) with
        | ExecutedConfig(Command(c1'), state') -> ExecutedConfig(Command(Seq(c1', c2)), state')
        | ExecutedConfig(Block(c1'), _) -> raise Error2
        | TerminatedConfig(state') -> ExecutedConfig(Command(c2), state')
        | ConfigError -> ConfigError)
      (* while b C -- While Loop *)
      | While(b, c) ->
        (match bool_eval b (s, h) with
        | True -> ExecutedConfig(Command(Seq(c, While(b, c))), (s, h))
        | False -> TerminatedConfig((s, h))
        | BoolError -> ConfigError)
      (* if b C else C -- If Statement *)
      | If_else(b, c1, c2) ->
        (match bool_eval b (s, h) with
        | True -> ExecutedConfig(Command(c1), (s, h))
        | False -> ExecutedConfig(Command(c2), (s, h))
        | BoolError -> ConfigError)
      | _ -> ConfigError
      
    end
  | ExecutedConfig(Block(c), state) ->
    begin 
    match proceed_transition_relation (ExecutedConfig(c, state)) with
    | ExecutedConfig(control, state') -> ExecutedConfig(Block(control), state')
    | TerminatedConfig((Decl(env)::prev_s, h)) -> TerminatedConfig((prev_s, h))
    | TerminatedConfig((Call(env, prev_s)::decl_s, h)) -> TerminatedConfig((prev_s, h))
    | TerminatedConfig([], _) as config' -> config'
    | ConfigError -> ConfigError
    end
  | TerminatedConfig(_) -> ConfigError
  | ConfigError -> ConfigError
;;
