-module(customs).
-export([for/3, sum/1, map/2, quick_sort/1, pythag/1, perms/1,
  permutations/1, filter/2, odds_and_evens/1,
  my_tuple_to_list/1, my_time_func/1, my_date_string/0, read_file/1, funcs_info/0, modules_most_common_function/0]).

for(Max, Max, F) -> [F(Max)];
for(I, Max, F) -> [F(I) | for(I + 1, Max, F)].

sum([H | T]) -> H + sum(T);
sum([]) -> 0.


map(_, []) -> [];
map(F, [H | T]) -> [F(H) | map(F, T)].


quick_sort([Pivot | T]) ->
  quick_sort([X || X <- T, X =< Pivot]) ++ [Pivot] ++ quick_sort([X || X <- T, X > Pivot]);
quick_sort([]) ->
  [].


pythag(N) ->
  [{A, B, C} ||
    A <- lists:seq(1, N),
    B <- lists:seq(1, N),
    C <- lists:seq(1, N),
    A + B + C =< N,
    A * A + B * B =:= C * C
  ].


perms([]) -> [[]];
perms(L) ->
  [[H | T] || H <- L, T <- perms(L--[H])].

permutations([H]) -> [H];
permutations([H1, H2 | T]) ->
  Rest = [H1] ++ T,
  [H2] ++ permutations(Rest).
%%
%%filter(P, [H | T]) ->
%%  case P(H) of
%%    true -> [H | filter(P, T)];
%%    false -> filter(P, T)
%%  end;
%%filter(_, []) ->
%%  [].
%%

filter(P, [H | T]) -> filter1(P(H), H, P, T);
filter(_, []) -> [].

filter1(true, H, P, T) -> [H | filter(P, T)];
filter1(false, _, P, T) -> filter(P, T).


odds_and_evens(L) ->
  odds_and_evens_acc(L, [], []).
odds_and_evens_acc([H | T], Odds, Evens) ->
  case (H rem 2) of
    1 -> odds_and_evens_acc(T, [H | Odds], Evens);
    0 -> odds_and_evens_acc(T, Odds, [H | Evens])
  end;
odds_and_evens_acc([], Odds, Evens) ->
  {Odds, Evens}.



my_tuple_to_list(T) when is_tuple(T) ->
  TupleLength = size(T),
  lists:reverse(fetch_tuples_from_list(T, [], TupleLength)).

fetch_tuples_from_list(_, _, 0) ->
  [];
fetch_tuples_from_list(T, L, TupleElementNumber) ->
  Fetch = element(TupleElementNumber, T),
  [Fetch | fetch_tuples_from_list(T, L, TupleElementNumber - 1)].


my_time_func(F) ->
  {_, Start, _} = os:timestamp(),
  F(),
  {_, End, _} = os:timestamp(),
  End - Start.

my_date_string() ->
  {Year, Month, Day} = date(),
  {Hour, Minute, Second} = time(),
  MonthName = case Month of
                1 -> "January";
                2 -> "February";
                3 -> "March";
                4 -> "April";
                5 -> "May";
                6 -> "June";
                7 -> "July";
                8 -> "August";
                9 -> "September";
                10 -> "October";
                11 -> "November";
                12 -> "December"
              end,

  Is_rd = lists:member(Day, [1, 2, 21, 22, 31]),

  if Is_rd ->
    EndingOfDay = "rd";
    true ->
      EndingOfDay = "th"
  end,


  Result = io_lib:format("Today is ~p~s of the ~s of ~p at ~p:~p:~p ~n", [Day, EndingOfDay, MonthName, Year, Hour, Minute, Second]),
  io:fwrite(Result).


read_file(FileName) ->
  case file:read_file(FileName) of
    {ok, Result} -> {ok, Result};
    {error, _} -> error(file_exception)
  end.


funcs_info() ->
  FuncLengths = lists:map(fun module_fun_len/1, code:all_loaded()),
  [Max | _] = lists:sort(fun({_, Len1}, {_, Len2}) -> Len1 >= Len2 end, FuncLengths),
  AllFuncCounted = modules_most_common_function(),
  OnceUsedFuncNames = lists:filter(fun({_, Count}) -> Count =:= 1 end, AllFuncCounted),
  [MostCommonFunc | _] = AllFuncCounted,
  #{max_func_module => Max, most_common_func => MostCommonFunc, used_once => OnceUsedFuncNames}.

module_fun_len({Module, _}) ->
  [{module, _}, {exports, ModuleFuncs} | _] = Module:module_info(),
  {Module, length(ModuleFuncs)}.


modules_most_common_function() ->
  All_Funcs = modules_most_common_function(code:all_loaded()),
  CountedFuncs = maps_and_records:count_characters(All_Funcs),
  lists:sort(fun({_FuncName, OccurrenceCount}, {_FuncName2, OccurrenceCount2}) ->
    OccurrenceCount >= OccurrenceCount2 end,
    maps:to_list(CountedFuncs)).
modules_most_common_function([{Module, _} | T]) ->
  [{module, _}, {exports, ModuleFuncs} | _] = Module:module_info(),
  ModuleFuncNames = lists:map(fun({FName, _}) -> FName end, ModuleFuncs),
  UniqModuleFuncNames = lists:uniq(ModuleFuncNames),
  UniqModuleFuncNames ++ modules_most_common_function(T);
modules_most_common_function([]) ->
  [].







