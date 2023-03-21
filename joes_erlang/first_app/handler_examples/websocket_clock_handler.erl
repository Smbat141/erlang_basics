%%WARNING: YOU NEED TO PUT THIS MODULE CODE TO THE HANDLER FILE(eg WEBSOCKET_HANDLER)

-module(websocket_clock_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
-export([terminate/3]).

init(Req, State) ->
  io:format("websocket connection initiated~n~p~n~nstate: ~p~n", [Req, State]),
  {cowboy_websocket, Req, State, #{idle_timeout => 300000}}.

websocket_init(State) ->
  Self = self(),
  io:format("***************************** websocket_init State ~p~n: Self ~p~n", [State, Self]),
  {ok, State}.

websocket_handle(Data, State) ->
  io:format("websocket data from client: ~p~n", [Data]),
  {text, Action} = Data,
  case jiffy:decode(binary_to_list(Action)) of
    {[{<<"clicked">>, <<"stop">>}]} ->
      [Self, ClockPid] = State,
      ClockPid ! {Self, {struct, [{clicked, <<"stop">>}]}},
      {ok, State};
    {[{<<"clicked">>, <<"start">>}]} ->
      Self = self(),
      ClockPid = spawn(clock1, start, [Self]),
      NewState = [Self, ClockPid | State],
      {ok, NewState}
  end.

websocket_info(Info, State) ->
  io:format("***************************** webscoket info Info ~p~n: State ~p~n", [Info, State]),
  {reply, {text, jiffy:encode(Info)}, State}.

terminate(_Reason, Req, _State) ->
  io:format("websocket connection terminated~n~p~n", [maps:get(peer, Req)]),
  ok.

