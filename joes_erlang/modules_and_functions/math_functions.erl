-module(math_functions).
-export([odd/1, even/1, filter/2, split_with_filter/1, split_with_accumulator/1]).

odd(X) -> (X rem 2) =:= 1.
even(X) -> (X rem 2) =:= 0.


filter(_, []) -> [];
filter(F, L) ->
  [H | T] = L,
  case F(H) of
    true -> [H | filter(F, T)];
    false -> filter(F, T)
  end.


split_with_filter(L) ->
  Even = filter(fun even/1, L),
  Odd = filter(fun odd/1, L),
  {Even, Odd}.


split_with_accumulator(L) ->
  split_acc(L, [], []).

split_acc([], Evens, Odds) ->
  {Evens, Odds};
split_acc(L, Evens, Odds) ->
  [H | T] = L,
  IsOdd = odd(H),
  IsEven = even(H),

  if IsOdd ->
    split_acc(T, Evens, [H | Odds]);
    IsEven ->
      split_acc(T, [H | Evens], Odds)
  end.



