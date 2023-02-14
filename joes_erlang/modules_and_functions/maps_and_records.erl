-module(maps_and_records).
-author("collab06").

%% API
-export([count_characters/1, map_search_pred/2]).


count_characters(Str) ->
  count_characters(Str, #{}).



count_characters([H | T], M) when is_map(M) ->
  HasKey = maps:is_key(H, M),
  case HasKey of
    true -> count_characters(T, M#{H := maps:get(H, M) + 1});
    false -> count_characters(T, M#{H => 1})
  end;
count_characters([], X) ->
  X.



map_search_pred(Map, Pred) ->
  MapList = maps:to_list(Map),
  search_in_map_list(MapList, Pred).


search_in_map_list([H | T], Pred) ->
  {Key, Value} = H,
  Result = Pred(Key, Value),
  if Result -> H;
    true ->
      search_in_map_list(T, Pred)
  end;
search_in_map_list([], _) ->
  [].