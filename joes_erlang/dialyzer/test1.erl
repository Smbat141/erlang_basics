-module(test1).


%%-export([f1/0]).


%%f1() ->
%%  X = erlang:time(),
%%  seconds(X).
%%
%%
%%
%%seconds({_Year, _Month, _Day, Hour, Min, Sec}) ->
%%  (Hour * 60 + Min) * 60 + Sec.
%%


%%f1() ->
%%  tuple_size(list_to_tuple({a, b, c})).

-export([test/0, factorial/1]).
test() -> factorial(-5).

factorial(0) -> 1;
factorial(N) -> N * factorial(N - 1).
