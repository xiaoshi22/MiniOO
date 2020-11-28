(* File miniool.ml *)
open Parsing;;
open AbstractSyntax;;
open PrintAST;;
open StaticScoping;;
open SemanticDomain;;
try
  let lexbuf = Lexing.from_channel stdin in
    while true do
      (try
        Parser.prog Lexer.token lexbuf
      with 
        | Lexer.Error ->
          Printf.fprintf stderr "\x1B[1;91mError\x1B[0m: At offset %d: unexpected character.\n%!"(Lexing.lexeme_start lexbuf)
        | Parse_error ->
          Printf.fprintf stderr "\x1B[1;91mError\x1B[0m: At offset %d: syntax error.\n%!"(Lexing.lexeme_start lexbuf));
      Lexing.flush_input lexbuf
    done
with Lexer.Eof -> ()
;;
