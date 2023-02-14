-module(concurrency_exercise).
%%-export([start/2, test/0, send_ring_message/3]).
%%
%%
%%start(AnAtom, Fun) ->
%%  case whereis(AnAtom) of
%%    undefined -> register(AnAtom, spawn(Fun));
%%    _Pid -> already_exist
%%  end.
%%
%%
%%
%%test() ->
%%  receive
%%    Any ->
%%      io:format("Got ~p~n", [Any]),
%%      test()
%%  end.
%%
%%
%%
%%send_ring_message(0, _RingCount, _Message) ->
%%  the_end;
%%send_ring_message(M, RingCount, Message) ->
%%  ring(RingCount, Message),
%%  send_ring_message(M - 1, RingCount, Message).
%%
%%ring(0, _M) ->
%%  finished;
%%ring(N, M) ->
%%  P = spawn(fun test_ring/0),
%%  P ! M,
%%  ring(N - 1, M).
%%
%%test_ring() ->
%%  receive
%%    Any -> io:format("Got ~p~n", [Any])
%%  end.



-export([start/0, ring_loop/1]).

start() ->
  N = 4,
  Pid = self(),
  spawn_ring(N, Pid, Pid).

spawn_ring(0, Right, _) ->
  {ok, Right};
spawn_ring(N, Left, Pid) ->
  Right = spawn(concurrency_exercise, ring_loop, [Left]),
  spawn_ring(N - 1, Right, Pid).

ring_loop(Left) ->
  receive
    {ring, Message} ->
      io:format("Process ~w received message: ~w~n", [self(), Message]),
      Left ! {ring, Message},
      ring_loop(Left);
    stop ->
      ok
  end.

