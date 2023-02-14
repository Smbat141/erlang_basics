.SUFFIXES: .erl .beam

.erl.beam:
	docker run -it -w /home -v $(shell pwd):/home erlang bash -c "erlc -W $<"

ERL = docker run -it -w /home -v $(shell pwd):/home erlang bash -c
MODS = fac

all: compile
	${ERL}  "erl -noshell -s fac main 5 -s init stop"

compile: ${MODS:%=%.beam}

clean:
	rm -rf *.beam erl_crash.dump

debug:
	@echo ${MODS:%=%.beam}

run_test:
	docker run -it -w /home -v $(shell pwd):/home erlang bash -c "erl -noshell -s fac tests -s init stop"