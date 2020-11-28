BDIR = build

all: delete
	ocamlc -c abstractSyntax.ml
	ocamlc -c staticScoping.ml
	ocamlc -c printAST.ml
	ocamlc -c semanticDomain.ml
	ocamlc -c printSemantics.ml
	ocamlc -c operationalSemantics.ml

	ocamlyacc parser.mly
	ocamlc -c parser.mli
	ocamlc -c parser.ml

	ocamllex lexer.mll
	ocamlc -c lexer.ml

	ocamlc -c miniool.ml
	ocamlc -o miniool abstractSyntax.cmo staticScoping.cmo printAST.cmo \
					semanticDomain.cmo printSemantics.cmo operationalSemantics.cmo\
			    	parser.cmo lexer.cmo miniool.cmo

test:
	@echo "---------------------------------------------------"
	@echo "# using the miniool:"
	@echo "{var X; X = proc K:skip;var Y; skip}"
	@echo "{var X; X = proc K:skip;var Y; skip}" | ./miniool
	@echo "{while true skip ||| if false skip else skip}"
	@echo "{while true skip ||| if false skip else skip}" | ./miniool
	@echo "{atom(while X.f == null X = Y);atom(if 3 - 1 < 2 skip else X.f = K)}"
	@echo "{atom(while X.f == null X = Y);atom(if 3 - 1 < 2 skip else X.f = K)}" | ./miniool

testSkip:
	@echo "{skip;skip}"
	@echo "{skip;skip}" | ./miniool

testStaticScoping:
	@echo "var X; skip"	
	@echo "var X; skip" | ./miniool
	@echo "var X; Y=1"
	@echo "var X; Y=1" | ./miniool

test2:
	@echo "var X; X = 1"
	@echo "var X; X = 1" | ./miniool
	@echo "var X; if 1 + 1 == 2 X = 1 else X = 2"
	@echo "var X; if 1 + 1 == 2 X = 1 else X = 2" | ./miniool
	@echo "var X; while false X = 1"
	@echo "var X; while false X = 1" | ./miniool
	@echo "var X; {X=1; var P; {P = proc X: X=2; P(0)}}"
	@echo "var X; {X=1; var P; {P = proc X: X=2; P(0)}}" | ./miniool

test3:
	@echo "var X; {{X = 0; {X = X+1; X = X+1}} ||| X = 0}"
	@echo "var X; {{X = 0; {X = X+1; X = X+1}} ||| X = 0}" | ./miniool
	@echo "var X; {{X = 0; atom({X = X+1; X = X+1})} ||| X = 0}"
	@echo "var X; {{X = 0; atom({X = X+1; X = X+1})} ||| X = 0}" | ./miniool
	@echo "var X; {malloc(X);{X.f=2;while X.f<30 X.f=X.f+X.f}}"
	@echo "var X; {malloc(X);{X.f=2;while X.f<30 X.f=X.f+X.f}}" | ./miniool
	# @echo "var X; {malloc(X); {X.f=1; X.t = 2}}"| ./miniool


delete:
	/bin/rm -f miniool *.cmi *.cmo lexer.ml parser.ml parser.mli makefile~

example1:
	# Field and loop
	@echo "var X; {malloc(X);{X.f=1;while X.f<30 X.f=X.f+X.f}}" | ./miniool
example2:
	# If else
	@echo "var X; {X=1; if X<2 X=3 else X=88}" | ./miniool
example3:	
	# Procedure Call
	@echo "var X; var Y;{X = proc X: Y=X; X(1)}" | ./miniool
example4:	
	# Call itself
	@echo "var X; var Y;{X = proc X: Y=X; X(X)}" | ./miniool
example5:
	# If else
	@echo "var P; {P = proc Y: if Y<1 P=1 else P(Y-1); P(1)}" | ./miniool
example6:
	# atom to avoid block
	@echo "{atom(var X; X=1); var Y; Y=1}" | ./miniool
	@echo "var X; var Y;{X = proc X: Y=X; {atom(X(X));Y(2)}}" | ./miniool
example7:
	# Parity
	@echo "var Parity; {Parity = proc X: if X/2*2==X X=0 else X=1; Parity(100)}" | ./miniool
example8:
	# Parallel
	@echo "var X; {X=4|||X=2}" | ./miniool
	@echo "var X; {X=4;while X==4 {skip||| X=3}}" | ./miniool
example9:
	# Fibonacci
	@echo "var A; var B; var C; var X;{X=20;{B=1;{A=0;var I; {I=0;while I<X {I=I+1;{C=B;{B = A+B; A = C}}}}}}}" | ./miniool

