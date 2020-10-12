type token =
  | END
  | SEMICOLON
  | ASSIGN
  | VAR
  | MINUS
  | LBRACE
  | RBRACE
  | NULL
  | PROCY
  | DOT
  | TRUE
  | FALSE
  | EQUALTO
  | LESSTHAN
  | SKIP
  | WHILE
  | IF
  | ELSE
  | MALLOC
  | ATOM
  | PARALLEL
  | LPAREN
  | RPAREN
  | VARIABLE of (string)
  | FIELD of (string)
  | NUM of (int)

val prog :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> unit MinioolAST.tree
