BDIR = build

all: delete
	ocamlc -c minioolAST.ml

	ocamlyacc minioolYACC.mly
	ocamlc -c minioolYACC.mli
	ocamlc -c minioolYACC.ml

	ocamllex minioolLEX.mll
	ocamlc -c minioolLEX.ml

	ocamlc -c miniool.ml
	ocamlc -o miniool minioolAST.cmo minioolYACC.cmo minioolLEX.cmo miniool.cmo

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

test2:
	echo "x = proc y: x = 1" | ./miniool
	# @echo "{{{var x; x = null}; x=z.y};proc y:C}" 
	# @echo "{{{var x; x = null}; x=z.y};proc y:C}" | ./miniool
	# @echo "{x(x); malloc(x)}" 
	# @echo "{x(x); malloc(x)}" | ./miniool
	# @echo "{x.y=z; {skip|||skip}}"
	# @echo "{x.y=z; {skip|||skip}}" | ./miniool
	# @echo "atom(skip)" 
	# @echo "atom(skip)" | ./miniool
	
delete:
	/bin/rm -f miniool miniool.cmi miniool.cmo  minioolAST.cmi minioolAST.cmo minioolLEX.cmi minioolLEX.cmo minioolLEX.ml minioolYACC.cmi minioolYACC.cmo minioolYACC.ml minioolYACC.mli makefile~
