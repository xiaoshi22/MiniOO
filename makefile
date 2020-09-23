all: delete
	ls
	@echo "# Lexer specification:"
	cat minioolLEX.mll
	ocamllex minioolLEX.mll
	ls
	@echo "# Parser specification:"
	cat minioolYACC.mly
	@echo "# Parser creation:"
	ocamlyacc minioolYACC.mly
	ls
	@echo "# types of values returned by lexems:"
	cat minioolYACC.mli
	@echo "# Compilation of the lexer and parser:"
	ocamlc -c minioolYACC.mli
	ocamlc -c minioolLEX.ml
	ocamlc -c minioolYACC.ml
	@echo "# Specification of the miniool:"
	cat miniool.ml 
	@echo "# compilation of the miniool:"
	ocamlc -c miniool.ml
	@echo "# linking of the lexer, parser & miniool:"
	ocamlc -o miniool minioolLEX.cmo minioolYACC.cmo miniool.cmo
	ls
	@echo "# using the miniool:"
	@echo "X:=1; Y:=2; Z:= 3; (X+Y)*Z+4" | ./miniool
	@echo "X:=1; Y:=2; *X; X" | ./miniool
	@echo "# the end."

delete:
	/bin/rm -f miniool miniool.cmi miniool.cmo minioolLEX.cmi minioolLEX.cmo minioolLEX.ml minioolYACC.cmi minioolYACC.cmo minioolYACC.ml minioolYACC.mli makefile~
