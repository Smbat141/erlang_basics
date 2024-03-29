-module(phofs).
-export([mapreduce/4]).

-import(lists, [foreach/2]).

%% F1(Pid, X) -> sends {Key,Val} messages to Pid
%% F2(Key, [Val], AccIn) -> AccOut

mapreduce(F1, F2, Acc0, L) ->
  S = self(),
  Pid = spawn(fun() -> reduce(S, F1, F2, Acc0, L) end),
  io:format("start map reduce ~n"),
  receive
    {Pid, Result} ->
      io:format("got something ~n"),
      Result
  end.

reduce(Parent, F1, F2, Acc0, L) ->
  process_flag(trap_exit, true),
  ReducePid = self(),
  %% Create the Map processes
  %%   One for each element X in L
  io:format("reduce 1~n"),

  foreach(fun(X) ->
    spawn_link(fun() -> do_job(ReducePid, F1, X) end)
          end, L),
  N = length(L),
  %% make a dictionary to store the Keys
  Dict0 = dict:new(),
  %% Wait for N Map processes to terminate
  Dict1 = collect_replies(N, Dict0),
  io:format("reduce 2~n"),
  Acc = dict:fold(F2, Acc0, Dict1),
  io:format("sending parent ~n"),
  Parent ! {self(), Acc}.

%% collect_replies(N, Dict)
%%     collect and merge {Key, Value} messages from N processes.
%%     When N processes have terminated return a dictionary
%%     of {Key, [Value]} pairs

collect_replies(5, Dict) ->
  Dict;
collect_replies(N, Dict) ->
  io:format("collect_replies ~p ~n", [N]),
  receive
    {Key, Val} ->
      case dict:is_key(Key, Dict) of
        true ->
          Dict1 = dict:append(Key, Val, Dict),
          collect_replies(N, Dict1);
        false ->
          Dict1 = dict:store(Key, [Val], Dict),
          collect_replies(N, Dict1)
      end;
    {'EXIT', _, _Why} ->
      collect_replies(N - 1, Dict)
  end.

%% Call F(Pid, X)
%%   F must send {Key, Value} messsages to Pid
%%     and then terminate

do_job(ReducePid, F, X) ->
  F(ReducePid, X).
