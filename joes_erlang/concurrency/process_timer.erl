-module(process_timer).

%% API
-export([priority_receive/0, start/2, cancel/1, test/0]).


priority_receive() ->
  receive
    {Pid, alarm, X} ->
      Pid ! {alarm, X, response}
  after 0 ->
    receive
      {Pid, Any} ->
        Pid ! {Any, after_response}
    end
  end.

start(Time, Fun) -> spawn(fun() -> timer(Time, Fun) end).

cancel(Pid) -> Pid ! cancel.

timer(Time, Fun) ->
  receive
    cancel ->
      void
  after Time ->
    Fun()
  end.

test() ->
  receive
    cancel -> io:format("Bye!");
    Any ->
      io:format("Got from you ~p~n", [Any]),
      test()
  end.