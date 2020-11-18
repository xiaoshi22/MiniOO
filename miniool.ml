(* File miniool.ml *)
open Parsing;;
open MinioolAST;;
open MinioolPrintAST;;
open MinioolStaticScoping;;

type color = Info | Error | Warning | Success;;
(* let print_colored text color = 
  match color with
    | Info -> print_endline("\x1B[1;96m"^text^"\x1B[0m")
    | Error -> print_endline("\x1B[1;91m"^text^"\x1B[0m")
    | Warning -> print_endline("\x1B[1;93m"^text^"\x1B[0m")
    | Success -> print_endline("\x1B[1;92m"^text^"\x1B[0m") *)
    

let lexbuf = Lexing.from_channel stdin in
  try
    let ast = MinioolYACC.prog MinioolLEX.token lexbuf in
      Printf.fprintf stdout "\x1B[1;96mChecking static scoping rules...\x1B[0m\n%!";
      MinioolStaticScoping.check_prog ast;
      Printf.fprintf stdout "\x1B[1;96mPrinting AST...\x1B[0m\n%!";
      MinioolPrintAST.print_prog ast;
  with 
    | MinioolLEX.Error ->
      Printf.fprintf stderr "\x1B[0;91mError: At offset %d: unexpected character.\x1B[0m\n%!"(Lexing.lexeme_start lexbuf)
    | Parse_error ->
      Printf.fprintf stderr "\x1B[0;91mError: At offset %d: syntax error.\x1B[0m\n%!"(Lexing.lexeme_start lexbuf)
    | MinioolStaticScoping.Error v ->
      Printf.fprintf stderr "\x1B[0;91mError: Variable %s is not declared.\x1B[0m\n%!" v
      ;;
