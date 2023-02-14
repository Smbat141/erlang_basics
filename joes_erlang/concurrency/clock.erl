-module(clock).
-export([start/1, stop/0, tick/2]).


start(Fun) ->
  register(clock, spawn(fun() -> tick(1, Fun) end)).

stop() -> clock ! stop.

tick(Time, Fun) when Time >= 1, Time =< 60 ->
  receive
    stop ->
      void
  after Time ->
    Fun(Time),
    case Time >= 60 of
      true -> tick(1, Fun);
      false -> tick(Time + 1, Fun)
    end
  end.