-module(websocket_graphics_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
-export([terminate/3]).

init(Req, State) ->
  io:format("websocket connection initiated ~n"),
  io:format("websocket connection STATE ~p ~n", [State]),
  io:format("websocket connection REQUEST ~p ~n", [Req]),
  io:format("websocket connection SELF ~p ~n", [self()]),
  {cowboy_websocket, Req, [State], #{idle_timeout => 300000}}.

websocket_init(State) ->
  io:format("webscoket init State ~p~n", [State]),
  Canvas = spawn(svg_pad4, start, [self()]),
  {ok, [{canvas, Canvas} | State]}.

websocket_handle(Data, State) ->
  io:format("webscoket handle Info ~p~n: State ~p~n", [Data, State]),
  {canvas, Canvas} = lists:keyfind(canvas, 1, State),
  {text, Action} = Data,
  Canvas ! {self(), {struct, jiffy:decode(Action)}},
  {ok, State}.

websocket_info(Info, State) ->
  io:format("webscoket info Info ~p~n: State ~p~n", [Info, State]),
  {send, Action} = Info,
  [{Cmd}] = jiffy:decode(Action),
%%  [[{Cmd}]] = [{<<"cmd">>,<<"SVG.init1">>},{<<"id">>,<<"svg">>},{<<"parent">>,<<"here">>},{<<"width">>,800},{<<"ht">>,400},{<<"color">>,<<"#ddebdd">>}]
%%  {reply, {text, jiffy:encode(maps:from_list(Cmd))}, State}.
  {reply, {text, Action}, State}.

terminate(_Reason, Req, _State) ->
  io:format("websocket connection terminated~n~p~n", [maps:get(peer, Req)]),
  ok.


