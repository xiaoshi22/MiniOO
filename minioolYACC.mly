/* File MinioolYACC.mly */

%{ (* header *) 
  open MinioolAST
%} /* declarations */

%token END SEMICOLON ASSIGN VAR /* lexer tokens */
%token MINUS LBRACE RBRACE NULL PROCY DOT
%token TRUE FALSE EQUALTO LESSTHAN 
%token SKIP WHILE IF ELSE MALLOC ATOM PARALLEL LPAREN RPAREN
%token <string> VARIABLE
%token <string> FIELD
%token <int> NUM

%left MINUS 
%left EQUALTO LESSTHAN

%start prog                   /* the entry point */
%type <unit MinioolAST.tree> prog  
%type <unit MinioolAST.tree> cmd
%type <unit expr> expr
%type <unit bexpr> bexpr

%% /* rules */
prog :
    cmd END  { $1 }

cmd :
    VAR VARIABLE SEMICOLON cmd      { Var_decl($2, $4, ()) }
  | expr LPAREN expr RPAREN         { Proc_call($1, $3, ()) }
  | MALLOC LPAREN VARIABLE RPAREN   { Alloc($3, ()) }
  | VARIABLE ASSIGN expr            { Var_assign($1, $3, ()) }
  | expr DOT expr ASSIGN expr       { Field_assign($1, $3, $5, ()) } 
  | SKIP                            { Skip(()) }
  | LBRACE cmd SEMICOLON cmd RBRACE { Seq($2, $4, ()) }
  | WHILE bexpr cmd                 { While($2, $3, ()) }
  | IF bexpr cmd ELSE cmd           { If_else($2, $3, $5, ())}
  | LBRACE cmd PARALLEL cmd RBRACE  { Parallel($2, $4, ()) }
  | ATOM LPAREN cmd RPAREN          { Atom($3, ()) }

expr :
    FIELD                           { Field($1, ()) }
  | NUM                             { Num($1, ()) }
  | VARIABLE                        { Var($1, ()) }
  | expr MINUS expr                 { Minus($1, $3, ()) }
  | NULL                            { Null(()) }
  | expr DOT expr                   { Field_select($1, $3, ()) }
  | PROCY cmd                       { Proc_y($2, ()) } 

bexpr: 
  | TRUE                            { True(()) }
  | FALSE                           { False(()) }
  | expr EQUALTO expr               { Equal_to($1, $3, ()) }
  | expr LESSTHAN expr              { Less_than($1, $3, ()) }
%% (* trailer *)
