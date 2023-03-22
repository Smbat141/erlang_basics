-module(websocket_app).
-behaviour(application).


%% Application callbacks
-export([start/2, stop/1]).


start(_StartType, _StartArgs) ->

  Dispatch = cowboy_router:compile([
    {'_', [
      {"/websocket/shell1", websocket_shell_handler, []}
    ]}
  ]),
  {ok, _} = cowboy:start_clear(http, [{port, 1456}], #{env => #{dispatch => Dispatch}}),
  websocket_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
  ok.
