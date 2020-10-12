all: delete
	ls
	ocamlc -i minioolAST.ml > minioolAST.mli
	ocamlc -c minioolAST.mli
	ocamlc -c minioolAST.ml
	@echo "# Lexer specification:"
	# cat minioolLEX.mll
	ocamllex minioolLEX.mll
	ls
	@echo "# Parser specification:"
	# cat minioolYACC.mly
	@echo "# Parser creation:"
	ocamlyacc minioolYACC.mly
	ls
	@echo "# types of values returned by lexems:"
	# cat minioolYACC.mli
	@echo "# Compilation of the lexer and parser:"
	ocamlc -c minioolYACC.mli
	ocamlc -c minioolLEX.ml
	ocamlc -c minioolYACC.ml
	@echo "# Specification of the miniool:"
	# cat miniool.ml 
	@echo "# compilation of the miniool:"
	ocamlc -i minioolAST.ml > minioolAST.mli
	ocamlc -c minioolAST.mli
	ocamlc -c miniool.ml
	@echo "# linking of the lexer, parser & miniool:"
	ocamlc -o miniool minioolAST.cmo minioolLEX.cmo minioolYACC.cmo miniool.cmo
	ls
	@echo "---------------------------------------------------"
	@echo "# using the miniool:"
	@echo "var x; x =2-1" 
	@echo "{var x; x =2-1;var y; y = x - 1}" | ./miniool
	@echo "{{{var x; x = null}; x=z.y};proc y:C}" 
	@echo "{{{var x; x = null}; x=z.y};proc y:C}" | ./miniool
	@echo "{x(x); malloc(x)}" 
	@echo "{x(x); malloc(x)}" | ./miniool
	@echo "{x.y=z; {skip|||skip}}"
	@echo "{x.y=z; {skip|||skip}}" | ./miniool
	@echo "atom(skip)" 
	@echo "atom(skip)" | ./miniool

delete:
	/bin/rm -f miniool miniool.cmi miniool.cmo minioolLEX.cmi minioolLEX.cmo minioolLEX.ml minioolYACC.cmi minioolYACC.cmo minioolYACC.ml minioolYACC.mli makefile~
