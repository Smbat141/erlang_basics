-module(keep_alive).
-export([process/2, test/0]).

process(Name, Fun) ->
  register(Name, Pid = spawn(Fun)),
  io:format("Started~n"),
  on_exit:run(Pid, fun(_Why) -> process(Name, Fun) end).


test() ->
  receive
    exit -> exit(you_made_me);
    Any ->
      io:format(Any),
      test()
  end.