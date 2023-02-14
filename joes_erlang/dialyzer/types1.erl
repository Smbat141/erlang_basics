-module(types1).
%%-export([f1/1, f2/1, f3/1]).
%%
%%
%%f1({H, M, S}) ->
%%  (H + M * 60) * 60 + S.
%%
%%f2({H, M, S}) when is_integer(H) ->
%%  (H + M * 60) * 60 + S.
%%
%%f3({H, M, S}) when is_float(H) ->
%%  print(H, M, S),
%%  (H + M * 60) * 60 + S.
%%
%%print(H, M, S) ->
%%  Str = integer_to_list(H) ++ ":" ++ integer_to_list(M) ++ ":" ++
%%    integer_to_list(S),
%%  io:format("~s", [Str]).

%%
%%myand1(true, true) -> true;
%%myand1(false, _) -> false;
%%myand1(_, false) -> false.
%%
%%bug1(X, Y) ->
%%  case myand1(X, Y) of
%%    true ->
%%      X + Y
%%  end.

-export([f1/2]).

f1(X, Y) ->
  io:format("This is X ~s, this is Y ~s~n", [X, Y]),
  X + Y.