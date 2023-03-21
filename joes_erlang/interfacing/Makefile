.SUFFIXES: .erl .beam .yrl

.erl.beam:
	docker run -it -w /home -v $(shell pwd):/home erlang bash -c "erlc -W $<"

MODS = example example_lid unit_test

all: ${MODS:%=%.beam} example example_drv.so
	docker run -it -w /home -v $(shell pwd):/home erlang bash -c "erl -noshell -s unit_test start"

example: example.c erl_comm.c example_driver.c
	gcc -o example example.c erl_comm.c example_driver.c

example_drv.so: example_lid.c example.c
	gcc -I /usr/local/lib/erlang/usr/include -o example_drv.so -fPIC -bundle -flat_namespace -undefined suppress example.c example_lid.c

clean:
	rm example example_drv.so *.beam
