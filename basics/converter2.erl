-module(converter2).
-export([format_temps/1]).

format_temps(List_of_cities) ->
  convert_list_to_c(List_of_cities).

convert_list_to_c([{Name, {f, F}} | Rest]) ->
  Converted_City = {Name, {c, (F - 32) * 5 / 9}},
  [Converted_City | convert_list_to_c(Rest)];

convert_list_to_c([{Name, {c, C}} | Rest]) ->
  [{Name, {c, C}} | convert_list_to_c(Rest)];

convert_list_to_c([]) ->
  [].


