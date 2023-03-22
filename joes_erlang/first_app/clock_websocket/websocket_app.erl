-module(websocket_app).
-behaviour(application).


%% Application callbacks
-export([start/2, stop/1]).


start(_StartType, _StartArgs) ->

  Dispatch = cowboy_router:compile([
    {'_', [
      {"/websocket/clock1", websocket_clock_handler, []}
    ]}
  ]),
  {ok, _} = cowboy:start_clear(http, [{port, 1456}], #{env => #{dispatch => Dispatch}}),
  websocket_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
  ok.
