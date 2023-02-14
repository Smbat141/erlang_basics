-module(fac).
-export([fac/1, tests/0, main/1]).


main([Arg]) ->
  F = fac(list_to_integer(atom_to_list(Arg))),
  io:format("Factorial of ~w is ~w ~n", [Arg, F]).


fac(0) ->
  1;
fac(N) ->
  N * fac(N - 1).

tests() ->
  io:format("~w ~n", [fac(5) =:= 120]).