(* File minioolLEX.mll *)
{
open MinioolYACC;; (* Type token defined in miniYACC.mli *)
exception Eof;;
}
rule token = parse
    [' ' '\t'] { token lexbuf } (* skip blanks and tabs *)
  | ['\n' ]    { EOL }
  | (['a'-'z'] | ['A'-'Z'])(['a'-'z'] | ['A'-'Z'] | ['0'-'9'])* as var
               { VAR var }
  | ['0'-'9']+ as num
               { NUM (int_of_string num) }
  | ';'        { SEMICOLON }
  | ':' '='    { ASSIGN }
  | '+'        { PLUS }
  | '-'        { MINUS }
  | '*'        { TIMES }
  | '/'        { DIV }
  | '('        { LPAREN }
  | ')'        { RPAREN }
  | eof        { raise Eof }
