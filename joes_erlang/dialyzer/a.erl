-module(a).
-export([client/0]).

-spec client() -> OK when
  OK :: b:response().

client() ->
  Response = b:request("http://www.example.com"),
%%  {responses, [_, _, _, _Failed]} = Response,
  Response.


