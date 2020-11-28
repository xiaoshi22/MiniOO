open AbstractSyntax;;


type integer = int
and boolean = True | False | BoolError of string
and obj = int 
and location = Object of obj | Null
and closure = AbstractSyntax.variable * AbstractSyntax.command * stack
and value = Field of AbstractSyntax.field
          | Int of integer
          | Loc of location
          | Clo of closure
and tainted_value = Val of value | TvaError of string
and environment = (AbstractSyntax.variable, obj) Hashtbl.t
and frame = Decl of environment
          | Call of environment * stack
and stack = frame list
and heap = (obj * AbstractSyntax.field, tainted_value) Hashtbl.t
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
                  | ConfigError of string
;;
