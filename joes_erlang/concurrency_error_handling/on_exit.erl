-module(on_exit).

%% API
-export([run/2, start/1]).


run(Pid, Fun) ->
  spawn(fun() ->
    Ref = monitor(process, Pid),
    receive
      {'DOWN', Ref, process, Pid, Why} ->
        Fun(Why)
    end
        end).

start(Fs) ->
  spawn(fun() ->
    [spawn_link(F) || F <- Fs],
    receive
    after infinity ->
      true
    end
        end).



