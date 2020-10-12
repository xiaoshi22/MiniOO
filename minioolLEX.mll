(* File minioolLEX.mll *)
{
open MinioolYACC;; (* Type token defined in miniYACC.mli *)
exception Error;;
}

rule token = parse
    [' ' '\t' '\n'] { token lexbuf } (* skip blanks, tabs and newlines *)
  | "var"           { VAR }
  | "true"          { TRUE }
  | "false"         { FALSE }  
  | "while"         { WHILE }  
  | "if"            { IF }  
  | "else"          { ELSE } 
  | "skip"          { SKIP }
  | "null"          { NULL }
  | "proc y:"       { PROCY }
  | "malloc"        { MALLOC }
  | "atom"          { ATOM }
  | (['a'-'z'] | ['A'-'Z'])(['a'-'z'] | ['A'-'Z'] | ['0'-'9'])* as variable
                    { VARIABLE variable }
  | (['A'-'Z'] | ['A'-'Z'])(['a'-'z'] | ['A'-'Z'] | ['0'-'9'])* as field
                    { FIELD field }
  | ['0'-'9']+ as num
                    { NUM (int_of_string num) }
  | ';'             { SEMICOLON }
  | '='             { ASSIGN }
  | '-'             { MINUS }
  | '{'             { LBRACE }
  | '}'             { RBRACE }
  | '('             { LPAREN }
  | ')'             { RPAREN }
  | "=="            { EQUALTO }
  | '<'             { LESSTHAN }
  | '.'             { DOT }
  | "|||"           { PARALLEL }
  | eof             { END }
  |_                { raise Error }
  