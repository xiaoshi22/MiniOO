BDIR = build

all: delete
	ocamlc -c minioolAST.ml
	ocamlc -c minioolStaticScoping.ml
	ocamlc -c minioolPrintAST.ml
	ocamlc -c minioolSemanticDomain.ml

	ocamlyacc minioolYACC.mly
	ocamlc -c minioolYACC.mli
	ocamlc -c minioolYACC.ml

	ocamllex minioolLEX.mll
	ocamlc -c minioolLEX.ml

	ocamlc -c miniool.ml
	ocamlc -o miniool minioolAST.cmo minioolStaticScoping.cmo minioolPrintAST.cmo minioolSemanticDomain.cmo \
			 minioolYACC.cmo minioolLEX.cmo miniool.cmo

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

test4:
	# @echo "{{{var x; x = null}; x=z.y};proc y:C}" 
	# @echo "{{{var x; x = null}; x=z.y};proc y:C}" | ./miniool
	# @echo "{x(x); malloc(x)}" 
	# @echo "{x(x); malloc(x)}" | ./miniool
	# @echo "{x.y=z; {skip|||skip}}"
	# @echo "{x.y=z; {skip|||skip}}" | ./miniool
	# @echo "atom(skip)" 
	# @echo "atom(skip)" | ./miniool

delete:
	/bin/rm -f miniool miniool.cmi miniool.cmo \
				 minioolAST.cmi minioolAST.cmo \
				 minioolStaticScoping.cmi minioolStaticScoping.cmo \
				 minioolPrintAST.cmi minioolPrintAST.cmo \
				 minioolSemanticDomain.cmi minioolSemanticDomain.cmo \
				 minioolLEX.cmi minioolLEX.cmo minioolLEX.ml \
				 minioolYACC.cmi minioolYACC.cmo minioolYACC.ml minioolYACC.mli \
				 makefile~

example:
	# Field and loop
	@echo "var X; {malloc(X);{X.f=1;while X.f<30 X.f=X.f+X.f}}" | ./miniool
	# If else
	@echo "var X; {X=1; if X>2 X=3 else X=88}" | ./miniool
	# Procedure Call
	@echo "var X; var Y;{X = proc X: Y=X; X(1)}" | ./miniool
	# Call itself
	@echo "var X; var Y;{X = proc X: Y=X; X(X)}" | ./miniool

	# If else
	@echo "var P; {P = proc Y: if Y<1 P=1 else P(Y-1); P(1)}" | ./miniool

	# atom to avoid block
	@echo "{atom(var X; X=1); var Y; Y=1}" | ./miniool
	@echo "var X; var Y;{X = proc X: Y=X; {atom(X(X));Y(2)}}" | ./miniool

	# Parity
	@echo "var Parity; {Parity = proc X: if X/2*2==X X=0 else X=1; Parity(100)}" | ./miniool

	# Parallel
	@echo "var X; {X=4|||X=2}" | ./miniool
	@echo "var X; {X=4;while X==4 {skip||| X=3}}" | ./miniool

	# Fibonacci
	@echo "var A; var B; var C; var X;{X=20;{B=1;{A=0;var I; {I=0;while I<X {I=I+1;{C=B;{B = A+B; A = C}}}}}}}" | ./miniool

