-module(hello).
-export([start/0]).


start() ->
  1 / 0,
  io:format("Hello world~n").