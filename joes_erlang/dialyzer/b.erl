-module(b).
-export([request/1]).
-export_type([response/0]).

-opaque response() :: {responses, [failed | ok, ...]}.
%%-type response() :: {responses, [failed | ok, ...]}.

-spec request(Url) -> Response when
  Url :: string(),
  Response :: response().


request(Url) ->
  io:format("Request to the ~s~n", [Url]),
  {responses, [ok, ok, ok, failed]}.

