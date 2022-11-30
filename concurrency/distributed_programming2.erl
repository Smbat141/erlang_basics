-module(distributed_programming2).
-export([start_ping/1, start_pong/0, start_pass/0, ping/2, pong/0, pass/0]).

ping(0, Pong_Node) ->
  {pong, Pong_Node} ! finished,
  io:format("ping finished~n", []);

ping(N, Pong_Node) ->
  {pong, Pong_Node} ! {ping, self()},
  receive
    {pong, Pong_Pid} ->
      io:format("Ping received pong process id ~w~n", [Pong_Pid]),
      if
        N > 1 ->
          pass ! {from_ping, N, 'Heey'};
        N == 1 ->
          pass ! finish_from_ping
      end
  end,
  ping(N - 1, Pong_Node).

pong() ->
  receive
    finished ->
      io:format("Pong finished~n", []);
    {ping, Ping_PID} ->
      io:format("Pong received ping~n", []),
      Ping_PID ! {pong, self()},
      pong()
  end.

pass() ->
  receive
    {from_ping, Attempt, Message} ->
      io:format("Get from ping message ~w ~w~n", [Attempt, Message]),
      pass();
    finish_from_ping ->
      io:format("Buuy from pass ~n", [])
  end.


start_pong() ->
  register(pong, spawn(distributed_programming2, pong, [])).

start_ping(Pong_Node) ->
  spawn(distributed_programming2, ping, [3, Pong_Node]).

start_pass() ->
  register(pass, spawn(distributed_programming2, pass, [])).
