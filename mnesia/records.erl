-module(records).
-export([lookup/2, find_phone/2]).

-record(person, {name, phone, address}).


lookup(Name, List) ->
  lists:keysearch(Name, #person.name, List).

find_phone([#person{name=Name, phone=Phone} | _], Name) ->
    {found,  Phone};
find_phone([_| T], Name) ->
    find_phone(T, Name);
find_phone([], Name) ->
    not_found.