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

open Parsing;;
let _ = parse_error;;
# 3 "minioolYACC.mly"
 (* h *) 
  open MinioolAST
# 35 "minioolYACC.ml"
let yytransl_const = [|
  257 (* END *);
  258 (* SEMICOLON *);
  259 (* ASSIGN *);
  260 (* VAR *);
  261 (* MINUS *);
  262 (* LBRACE *);
  263 (* RBRACE *);
  264 (* NULL *);
  265 (* PROCY *);
  266 (* DOT *);
  267 (* TRUE *);
  268 (* FALSE *);
  269 (* EQUALTO *);
  270 (* LESSTHAN *);
  271 (* SKIP *);
  272 (* WHILE *);
  273 (* IF *);
  274 (* ELSE *);
  275 (* MALLOC *);
  276 (* ATOM *);
  277 (* PARALLEL *);
  278 (* LPAREN *);
  279 (* RPAREN *);
    0|]

let yytransl_block = [|
  280 (* VARIABLE *);
  281 (* FIELD *);
  282 (* NUM *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\002\000\002\000\002\000\002\000\
\002\000\002\000\002\000\002\000\003\000\003\000\003\000\003\000\
\003\000\003\000\003\000\004\000\004\000\004\000\004\000\000\000"

let yylen = "\002\000\
\002\000\004\000\004\000\004\000\003\000\005\000\001\000\005\000\
\003\000\005\000\005\000\004\000\001\000\001\000\001\000\003\000\
\001\000\003\000\002\000\001\000\001\000\003\000\003\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\017\000\000\000\007\000\000\000\
\000\000\000\000\000\000\000\000\013\000\014\000\024\000\000\000\
\000\000\000\000\000\000\019\000\020\000\021\000\015\000\000\000\
\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\009\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\002\000\
\000\000\000\000\000\000\000\000\000\000\000\000\004\000\012\000\
\000\000\003\000\008\000\011\000\010\000\000\000"

let yydgoto = "\002\000\
\015\000\016\000\017\000\025\000"

let yysindex = "\003\000\
\151\255\000\000\237\254\151\255\000\000\151\255\000\000\216\255\
\216\255\240\254\241\254\011\255\000\000\000\000\000\000\014\255\
\018\255\015\255\255\254\000\000\000\000\000\000\000\000\034\255\
\151\255\151\255\250\254\151\255\001\255\000\000\001\255\001\255\
\001\255\151\255\151\255\151\255\001\255\001\255\001\255\000\000\
\016\255\252\254\022\255\254\254\028\255\153\255\006\255\000\000\
\039\255\042\255\254\254\254\254\254\254\151\255\000\000\000\000\
\001\255\000\000\000\000\000\000\000\000\254\254"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\159\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\076\255\050\255\038\255\000\000\000\000\
\000\000\000\000\102\255\174\255\197\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\128\255"

let yygindex = "\000\000\
\000\000\252\255\004\000\053\000"

let yytablesize = 242
let yytable = "\019\000\
\035\000\020\000\031\000\001\000\018\000\027\000\028\000\037\000\
\005\000\006\000\031\000\024\000\024\000\029\000\030\000\037\000\
\034\000\042\000\055\000\036\000\040\000\041\000\031\000\043\000\
\023\000\013\000\014\000\032\000\058\000\048\000\049\000\050\000\
\044\000\054\000\045\000\046\000\047\000\037\000\031\000\033\000\
\051\000\052\000\053\000\037\000\056\000\059\000\038\000\039\000\
\060\000\061\000\016\000\016\000\016\000\016\000\016\000\016\000\
\016\000\016\000\016\000\018\000\062\000\026\000\016\000\016\000\
\016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
\016\000\016\000\016\000\016\000\005\000\005\000\005\000\005\000\
\000\000\005\000\005\000\005\000\005\000\000\000\000\000\000\000\
\005\000\005\000\005\000\005\000\005\000\005\000\005\000\005\000\
\005\000\005\000\005\000\005\000\005\000\005\000\018\000\018\000\
\018\000\018\000\000\000\018\000\018\000\018\000\018\000\000\000\
\000\000\000\000\018\000\018\000\018\000\018\000\018\000\018\000\
\018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
\006\000\006\000\006\000\006\000\000\000\006\000\006\000\006\000\
\006\000\000\000\000\000\000\000\006\000\006\000\006\000\006\000\
\006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
\006\000\006\000\003\000\057\000\004\000\031\000\005\000\006\000\
\000\000\000\000\037\000\015\000\000\000\007\000\008\000\009\000\
\015\000\010\000\011\000\000\000\000\000\000\000\012\000\013\000\
\014\000\022\000\000\000\022\000\015\000\022\000\022\000\000\000\
\000\000\000\000\000\000\000\000\022\000\022\000\022\000\000\000\
\022\000\022\000\000\000\000\000\000\000\022\000\022\000\022\000\
\023\000\000\000\023\000\000\000\023\000\023\000\000\000\000\000\
\000\000\000\000\000\000\023\000\023\000\023\000\000\000\023\000\
\023\000\000\000\000\000\000\000\023\000\023\000\023\000\005\000\
\006\000\000\000\021\000\022\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\023\000\
\013\000\014\000"

let yycheck = "\004\000\
\002\001\006\000\005\001\001\000\024\001\022\001\022\001\010\001\
\008\001\009\001\005\001\008\000\009\000\003\001\001\001\010\001\
\002\001\024\001\023\001\021\001\025\000\026\000\005\001\028\000\
\024\001\025\001\026\001\010\001\023\001\034\000\035\000\036\000\
\029\000\018\001\031\000\032\000\033\000\010\001\005\001\022\001\
\037\000\038\000\039\000\010\001\023\001\007\001\013\001\014\001\
\007\001\054\000\001\001\002\001\003\001\004\001\005\001\006\001\
\007\001\008\001\009\001\022\001\057\000\009\000\013\001\014\001\
\015\001\016\001\017\001\018\001\019\001\020\001\021\001\022\001\
\023\001\024\001\025\001\026\001\001\001\002\001\003\001\004\001\
\255\255\006\001\007\001\008\001\009\001\255\255\255\255\255\255\
\013\001\014\001\015\001\016\001\017\001\018\001\019\001\020\001\
\021\001\022\001\023\001\024\001\025\001\026\001\001\001\002\001\
\003\001\004\001\255\255\006\001\007\001\008\001\009\001\255\255\
\255\255\255\255\013\001\014\001\015\001\016\001\017\001\018\001\
\019\001\020\001\021\001\022\001\023\001\024\001\025\001\026\001\
\001\001\002\001\003\001\004\001\255\255\006\001\007\001\008\001\
\009\001\255\255\255\255\255\255\013\001\014\001\015\001\016\001\
\017\001\018\001\019\001\020\001\021\001\022\001\023\001\024\001\
\025\001\026\001\004\001\003\001\006\001\005\001\008\001\009\001\
\255\255\255\255\010\001\005\001\255\255\015\001\016\001\017\001\
\010\001\019\001\020\001\255\255\255\255\255\255\024\001\025\001\
\026\001\004\001\255\255\006\001\022\001\008\001\009\001\255\255\
\255\255\255\255\255\255\255\255\015\001\016\001\017\001\255\255\
\019\001\020\001\255\255\255\255\255\255\024\001\025\001\026\001\
\004\001\255\255\006\001\255\255\008\001\009\001\255\255\255\255\
\255\255\255\255\255\255\015\001\016\001\017\001\255\255\019\001\
\020\001\255\255\255\255\255\255\024\001\025\001\026\001\008\001\
\009\001\255\255\011\001\012\001\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\024\001\
\025\001\026\001"

let yynames_const = "\
  END\000\
  SEMICOLON\000\
  ASSIGN\000\
  VAR\000\
  MINUS\000\
  LBRACE\000\
  RBRACE\000\
  NULL\000\
  PROCY\000\
  DOT\000\
  TRUE\000\
  FALSE\000\
  EQUALTO\000\
  LESSTHAN\000\
  SKIP\000\
  WHILE\000\
  IF\000\
  ELSE\000\
  MALLOC\000\
  ATOM\000\
  PARALLEL\000\
  LPAREN\000\
  RPAREN\000\
  "

let yynames_block = "\
  VARIABLE\000\
  FIELD\000\
  NUM\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit MinioolAST.tree) in
    Obj.repr(
# 26 "minioolYACC.mly"
             ( _1 )
# 220 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit MinioolAST.tree) in
    Obj.repr(
# 29 "minioolYACC.mly"
                                    ( Var_decl(_2, _4, ()) )
# 228 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : unit expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : unit expr) in
    Obj.repr(
# 30 "minioolYACC.mly"
                                    ( Proc_call(_1, _3, ()) )
# 236 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 31 "minioolYACC.mly"
                                    ( Alloc(_3, ()) )
# 243 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit expr) in
    Obj.repr(
# 32 "minioolYACC.mly"
                                    ( Var_assign(_1, _3, ()) )
# 251 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : unit expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : unit expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : unit expr) in
    Obj.repr(
# 33 "minioolYACC.mly"
                                    ( Field_assign(_1, _3, _5, ()) )
# 260 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    Obj.repr(
# 34 "minioolYACC.mly"
                                    ( Skip(()) )
# 266 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : unit MinioolAST.tree) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : unit MinioolAST.tree) in
    Obj.repr(
# 35 "minioolYACC.mly"
                                    ( Seq(_2, _4, ()) )
# 274 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit bexpr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit MinioolAST.tree) in
    Obj.repr(
# 36 "minioolYACC.mly"
                                    ( While(_2, _3, ()) )
# 282 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : unit bexpr) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : unit MinioolAST.tree) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : unit MinioolAST.tree) in
    Obj.repr(
# 37 "minioolYACC.mly"
                                    ( If_else(_2, _3, _5, ()))
# 291 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : unit MinioolAST.tree) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : unit MinioolAST.tree) in
    Obj.repr(
# 38 "minioolYACC.mly"
                                    ( Parallel(_2, _4, ()) )
# 299 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : unit MinioolAST.tree) in
    Obj.repr(
# 39 "minioolYACC.mly"
                                    ( Atom(_3, ()) )
# 306 "minioolYACC.ml"
               : unit MinioolAST.tree))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 42 "minioolYACC.mly"
                                    ( Field(_1, ()) )
# 313 "minioolYACC.ml"
               : unit expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 43 "minioolYACC.mly"
                                    ( Num(_1, ()) )
# 320 "minioolYACC.ml"
               : unit expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 44 "minioolYACC.mly"
                                    ( Var(_1, ()) )
# 327 "minioolYACC.ml"
               : unit expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit expr) in
    Obj.repr(
# 45 "minioolYACC.mly"
                                    ( Minus(_1, _3, ()) )
# 335 "minioolYACC.ml"
               : unit expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 46 "minioolYACC.mly"
                                    ( Null(()) )
# 341 "minioolYACC.ml"
               : unit expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit expr) in
    Obj.repr(
# 47 "minioolYACC.mly"
                                    ( Field_select(_1, _3, ()) )
# 349 "minioolYACC.ml"
               : unit expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit MinioolAST.tree) in
    Obj.repr(
# 48 "minioolYACC.mly"
                                    ( Proc_y(_2, ()) )
# 356 "minioolYACC.ml"
               : unit expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 51 "minioolYACC.mly"
                                    ( True(()) )
# 362 "minioolYACC.ml"
               : unit bexpr))
; (fun __caml_parser_env ->
    Obj.repr(
# 52 "minioolYACC.mly"
                                    ( False(()) )
# 368 "minioolYACC.ml"
               : unit bexpr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit expr) in
    Obj.repr(
# 53 "minioolYACC.mly"
                                    ( Equal_to(_1, _3, ()) )
# 376 "minioolYACC.ml"
               : unit bexpr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit expr) in
    Obj.repr(
# 54 "minioolYACC.mly"
                                    ( Less_than(_1, _3, ()) )
# 384 "minioolYACC.ml"
               : unit bexpr))
(* Entry prog *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let prog (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : unit MinioolAST.tree)
;;
# 55 "minioolYACC.mly"
 (* trailer *)
# 411 "minioolYACC.ml"
