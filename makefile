all: delete
	ocamlc -I bin -o bin/abstractSyntax.cmo -c src/abstractSyntax.ml
	ocamlc -I bin -o bin/staticScoping.cmo -c src/staticScoping.ml
	ocamlc -I bin -o bin/printAST.cmo -c src/printAST.ml
	ocamlc -I bin -o bin/semanticDomain.cmo -c src/semanticDomain.ml
	ocamlc -I bin -o bin/printSemantics.cmo -c src/printSemantics.ml
	ocamlc -I bin -o bin/operationalSemantics.cmo -c src/operationalSemantics.ml

	ocamlyacc -bbin/parser src/parser.mly
	ocamlc -I bin -o bin/parser.cmi -c bin/parser.mli
	ocamlc -I bin -o bin/parser.cmo -c bin/parser.ml

	ocamllex  -o bin/lexer.ml src/lexer.mll
	ocamlc -I bin -o bin/lexer.cmo -c bin/lexer.ml

	ocamlc -I bin -o bin/miniool.cmo -c src/miniool.ml
	ocamlc -I bin -o miniool bin/abstractSyntax.cmo bin/staticScoping.cmo bin/printAST.cmo \
					bin/semanticDomain.cmo bin/printSemantics.cmo bin/operationalSemantics.cmo\
			    	bin/parser.cmo bin/lexer.cmo bin/miniool.cmo


delete:
	/bin/rm -f makefile~
	/bin/rm -f bin/*.cmi bin/*.cmo bin/lexer.ml bin/parser.ml bin/parser.mli


example1:
	# Check the static Scoping Rules
	@echo "var X; Y = 1"
	@echo "var X; Y = 1" | ./miniool
	
example2:
	# Pretty Print AST and Configurations
	@echo "var X; X = 1"
	@echo "var X; X = 1" | ./miniool


example3:	
	#  Recursive Procedure
	@echo "var P; {P = proc Y: if Y<1 P=1 else P(Y-1); P(1)}"
	@echo "var P; {P = proc Y: if Y<1 P=1 else P(Y-1); P(1)}" | ./miniool

example4:	
	# Object Creation
	@echo "var X; {malloc(X); X.f = 5}"
	@echo "var X; {malloc(X); X.f = 5}" | ./miniool

example5:
	# Parallelism 
	@echo "var X; {{X = 0; {X = X + 1; X = X + 1}} ||| X = 0}"
	@echo "var X; {{X = 0; {X = X + 1; X = X + 1}} ||| X = 0}" | ./miniool

example6:
	# Atomicity
	@echo "var X; {{X = 0; atom({X = X + 1; X = X + 1})} ||| X = 0}"
	@echo "var X; {{X = 0; atom({X = X + 1; X = X + 1})} ||| X = 0}" | ./miniool
