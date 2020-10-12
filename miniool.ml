(* File miniool.ml *)
open Parsing;;
try
  let lexbuf = Lexing.from_channel stdin in
  while true do
    try
      MinioolYACC.prog MinioolLEX.token lexbuf
    with Parse_error ->
      (print_string "Syntax error ..." ; print_newline ()) ;
    clear_parser ()
  done
with MinioolLEX.Eof ->
  ()
let lexbuf = Lexing.from_channel stdin in
  try
    print_tree (MinioolYACC.prog MinioolLEX.token lexbuf);
  with 
    | MinioolLEX.Error ->
      Printf.fprintf stderr "At offset %d: unexpected character.\n%!"(Lexing.lexeme_start lexbuf)
    |Parse_error ->
      Printf.fprintf stderr "At offset %d: syntax error.\n%!"(Lexing.lexeme_start lexbuf)
;;
