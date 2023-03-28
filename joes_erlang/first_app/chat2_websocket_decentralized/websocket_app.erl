-module(websocket_app).
-behaviour(application).


%% Application callbacks
-export([start/2, stop/1]).


start(_StartType, _StartArgs) ->

  Dispatch = cowboy_router:compile([
    {'_', [
      {"/websocket/chat2", websocket_chat_handler, []}
    ]}
  ]),
  {ok, _} = cowboy:start_clear(http, [{port, 1456}], #{env => #{dispatch => Dispatch}}),
  run_predefined_chats(),
  websocket_sup:start_link().

stop(_State) ->
  ok.

run_predefined_chats() ->
  io:format("Starting predifined groups~n"),
  irc:start(smb_namespace),
  irc:start(eva_namespace),
  irc:start(general).