/* File MinioolYACC.mly */

%{ (* header *) 
  open AbstractSyntax;;
  open StaticScoping;;
  open PrintAST;;
  open SemanticDomain;;
  open OperationalSemantics;;

  let run_prog ast =
    try
      Printf.fprintf stdout "\x1B[1;96mChecking static scoping rules...\x1B[0m\n%!";
      let fields = StaticScoping.check_prog ast in
        Printf.fprintf stdout "\x1B[0;96mAll static scoping checking passed.\x1B[0m\n \n%!";
        Printf.fprintf stdout "\x1B[1;96mPrinting AST...\x1B[0m\n%!";
        PrintAST.pretty_print_prog ast;
        print_newline();
        Printf.fprintf stdout "\x1B[1;96mExecuting program...\x1B[0m\n%!";
        OperationalSemantics.execute_prog ast !fields;
  with
    | StaticScoping.Error v ->
      Printf.fprintf stderr "\x1B[1;91mError\x1B[0m: Variable %s is not declared.\n%!" v
    | OperationalSemantics.Error err ->
      Printf.fprintf stderr "\x1B[1;91mError\x1B[0m: %s\n%!" err
      ;;
%} /* declarations */

%token EOL SEMICOLON ASSIGN VAR /* lexer tokens */
%token ADD MINUS TIMES DIV LBRACE RBRACE NULL PROC COLON DOT
%token TRUE FALSE EQUALTO LESSTHAN 
%token SKIP WHILE IF ELSE MALLOC ATOM PARALLEL LPAREN RPAREN
%token <string> VARIABLE
%token <string> FIELD
%token <int> NUM

%right ASSIGN
%left ADD MINUS 
%left TIMES DIV
%left DOT
%left EQUALTO LESSTHAN

%start prog                   /* the entry point */
%type <unit> prog  
%type <AbstractSyntax.command> cmd
%type <AbstractSyntax.expr> expr
%type <AbstractSyntax.bexpr> bexpr

%% /* rules */
prog :
    cmd EOL                         { run_prog($1) }

cmd :
    VAR VARIABLE SEMICOLON cmd      { Var_declaration($2, $4) }
  | expr LPAREN expr RPAREN         { Proc_call($1, $3) }
  | MALLOC LPAREN VARIABLE RPAREN   { Allocation($3) }
  | VARIABLE ASSIGN expr            { Var_assignment($1, $3) }
  | expr DOT expr ASSIGN expr       { Field_assignment($1, $3, $5) } 
  | SKIP                            { Skip }
  | LBRACE cmd SEMICOLON cmd RBRACE { Seq($2, $4) }
  | WHILE bexpr cmd                 { While($2, $3) }
  | IF bexpr cmd ELSE cmd           { If_else($2, $3, $5)}
  | LBRACE cmd PARALLEL cmd RBRACE  { Parallel($2, $4) }
  | ATOM LPAREN cmd RPAREN          { Atom($3) }

expr :
    FIELD                           { Field($1) }
  | NUM                             { Num($1) }
  | VARIABLE                        { Var($1) }
  | expr ADD expr                   { Addition($1, $3) }
  | expr MINUS expr                 { Subtraction($1, $3) }
  | expr TIMES expr                 { Multiplication($1, $3) }
  | expr DIV expr                   { Division($1, $3) }
  | NULL                            { Null }
  | expr DOT expr                   { Field_selection($1, $3) }
  | PROC VARIABLE COLON cmd         { Procedure($2, $4) } 

bexpr: 
  | TRUE                            { True }
  | FALSE                           { False }
  | expr EQUALTO expr               { Equal_to($1, $3) }
  | expr LESSTHAN expr              { Less_than($1, $3) }
%% (* trailer *)
