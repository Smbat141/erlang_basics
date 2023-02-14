-module(geometry_server).
%%-export([loop/0, rpc/2]).

%%loop() ->
%%  receive
%%    {rectangle, Width, Ht} ->
%%      io:format("Area of rectangle is ~p~n", [Width * Ht]),
%%      loop();
%%    {square, Side} ->
%%      io:format("Area of square is ~p~n", [Side * Side]),
%%      loop()
%%  end.


%%loop() ->
%%  receive
%%    {From, {rectangle, Width, Ht}} ->
%%      From ! {self(), Width * Ht},
%%      loop();
%%    {From, {square, Side}} ->
%%      From ! {self(), Side * Side},
%%      loop();
%%    {From, Other} ->
%%      From ! {self(), {error, Other}},
%%      loop()
%%  end.
%%
%%
%%rpc(Pid, Request) ->
%%  Pid ! {self(), Request},
%%  receive
%%    {Pid, Response} ->
%%      Response
%%  end.

-export([start/0, area/2, loop/0]).

start() -> spawn(geometry_server, loop, []).

area(Pid, What) ->
  rpc(Pid, What).

rpc(Pid, Request) ->
  Pid ! {self(), Request},
  receive
    {Pid, Response} ->
      Response
  end.

loop() ->
  receive
    {From, {rectangle, Width, Ht}} ->
      From ! {self(), Width * Ht},
      loop();
    {From, {circle, R}} ->
      From ! {self(), 3.14159 * R * R},
      loop();
    {From, Other} ->
      From ! {self(), {error, Other}},
      loop()
  end.