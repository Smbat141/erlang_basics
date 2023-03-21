-module(websocket_interaction_app).
-behaviour(application).

%%-export([start/2]).
%%-export([stop/1]).
%%
%%start(_Type, _Args) ->
%%  Dispatch = cowboy_router:compile([{'_', [{"/", websocket_handler, []}]}]),
%%
%%  {ok, _} = cowboy:start_clear(my_http_listener,
%%    [{port, 8080}],
%%    #{env => #{dispatch => Dispatch}}),
%%  websocket_sup:start_link().
%%
%%stop(_State) ->
%%  ok.
%%


%% Application callbacks
-export([start/2, stop/1, database_handler/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->

  Dispatch = cowboy_router:compile([
    {'_', [
      {"/websocket/clock1", websocket_clock_handler, []},
      {"/websocket/interact1", websocket_interaction_handler, []}
    ]}
  ]),
  {ok, _} = cowboy:start_clear(http, [{port, 1456}], #{env => #{dispatch => Dispatch}}),
  start_database_handler(),
  websocket_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
  ok.


start_database_handler() ->
  io:format("Database Handler Started ~n"),
  register(db_handler, spawn(websocket_app, database_handler, [[]])).

database_handler(DB) ->
  receive
    {append, InteractionPid, ClientPid} ->
      io:format("Database Handler received Append ~p --- ~p ~n", [InteractionPid, ClientPid]),
      Participants = [{InteractionPid, ClientPid} | DB],
      database_handler(Participants);
    {get_all, ClientPid} ->
      io:format("Database Handler received get_all ~p~n", [ClientPid]),
      ClientPid ! {participants, DB},
      database_handler(DB)
  end.
