-module(websocket_chat_handler).

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
  Chat = spawn(chat2_with_auth, start, [self()]),
  {ok, [{chat, Chat} | State]}.

websocket_handle(Data, State) ->
  io:format("webscoket handle Info ~p~n: State ~p~n", [Data, State]),
  {chat, Chat} = lists:keyfind(chat, 1, State),
  {text, Action} = Data,
  Chat ! {self(), {struct, jiffy:decode(Action)}},
  {ok, State}.

websocket_info(Info, State) ->
  io:format("webscoket info Info ~p~n: State ~p~n", [Info, State]),
  {reply, {text, jiffy:encode(Info)}, State}.

terminate(_Reason, Req, _State) ->
  io:format("websocket connection terminated~n~p~n", [maps:get(peer, Req)]),
  ok.
