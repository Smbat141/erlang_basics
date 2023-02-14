-module(err_handling).
-compile([export_all]).

my_spawn(Module, Fun, Args) ->
  Start = erlang:monotonic_time(second),
  Pid = spawn_link(Module, Fun, Args),

  spawn(fun() ->
    Ref = monitor(process, Pid),
    receive
      {'DOWN', Ref, process, Pid, Why} ->
        io:format("Died because of ~w~n", [Why]),
        End = erlang:monotonic_time(second),
        io:format("Exist ~w seconds ~n", [End - Start])
    end end),

  Pid.


my_spawn_with_on_exit(Module, Fun, Args) ->
  Start = erlang:monotonic_time(second),
  Pid = spawn_link(Module, Fun, Args),

  on_exit:run(Pid, fun(Why) ->
    io:format("Died because of ~w~n", [Why]),
    End = erlang:monotonic_time(second),
    io:format("Exist ~w seconds ~n", [End - Start]) end),

  Pid.

my_spawn_with_timer(Module, Fun, Args, Time) ->
  Pid = spawn_link(Module, Fun, Args),

  spawn(fun() ->
    receive
    after Time ->
      exit(Pid, time_out_error)
    end end),
  Pid.


every_5_second() ->
  Process_name = five_seconder,
  register(Process_name, spawn(err_handling, every_n_second, [5])),
  Process_name.

every_n_second(Time) ->
  io:format("I am still running~n"),
  receive
    exit -> io:format("You made me exit!~n"), exit(you_made_me)
  after Time * 1000 ->
    every_n_second(Time)
  end.

restart_every_5_seconds() ->
  spawn(fun() ->
    Ref = erlang:monitor(process, whereis(five_seconder)),
    receive
      {'DOWN', Ref, process, _Pid, _Why} ->
        every_5_second(),
        io:format("restarted every_5_minute~n"),
        restart_every_5_seconds()
    end
        end).


test() ->
  timer:sleep(5000),
  io:format("about to die~n").


run_workers() ->
  [spawn(err_handling, start_worker, [fun restart_worker/0]) || _ <- lists:seq(1, 5)].

start_worker(ExitCallback) ->
  {Pid, Ref} = erlang:spawn_monitor(err_handling, worker, []),
  io:format("Start Worker with Pid ~w~n", [Pid]),

  receive
    {'DOWN', Ref, process, Pid, _Why} ->
      io:format("Pid was killed ~w ~n", [Pid]),
      io:format("Restarting new one ~n"),
      ExitCallback()
  end.

restart_worker() ->
  start_worker(fun restart_worker/0).


run_linked_workers(Count) ->
  spawn(err_handling, start_liked_workers, [Count, fun(_Why) -> run_linked_workers(Count) end]),
  ok.

start_liked_workers(Count, ErrCallback) ->
  {Pid, Ref} = spawn_monitor(err_handling, spawn_link_workers, [Count]),
  receive
    {'DOWN', Ref, process, Pid, Why} ->
      io:format("All linked workers must be killed at this moment~n"),
      ErrCallback(Why)
  end.


spawn_link_workers(Count) when Count >= 1 ->
  Pids = [spawn_link(err_handling, worker, []) || _ <- lists:seq(1, Count)],
  io:format("Start Linked Workers with Pids ~w ~n", [Pids]),

  receive
  %just leave empty%
  after infinity -> true
  end.

worker() ->
  receive
    Any ->
      io:format("Working on ~w~n", [Any]),
      worker()
  end.



