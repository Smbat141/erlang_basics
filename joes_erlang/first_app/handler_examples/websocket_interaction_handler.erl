-module(websocket_interaction_handler).

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
  Self = self(),
  InteractionPid = spawn(interact1, start, [Self]),
  db_handler ! {append, InteractionPid, Self},
%%  io:format("############################# websocket_init State ~p~n: Self ~p~n", [State, Self]),
  {ok, State}.

websocket_handle(Data, State) ->
%%  io:format("***************************** websocket data from client: ~p~n", [Data]),
  {text, Action} = Data,
  {[{<<"entry">>, Id}, {<<"txt">>, Message}]} = jiffy:decode(binary_to_list(Action)),
  db_handler ! {get_all, self()},
  receive
    {participants, DB} ->
      io:format("Client get response from DB handler ~p~n", [DB]),
      lists:foreach(fun({InteractionPid, ClientPid}) ->
        InteractionPid ! {ClientPid, {struct, [{entry, Id}, {txt, Message}]}} end, DB)
  after 3000 ->
    io:format("No response from Database Handler ~n")
  end,

  {ok, State}.

websocket_info(Info, State) ->
  io:format("***************************** webscoket info Info ~p~n: State ~p~n", [Info, State]),
  {reply, {text, jiffy:encode(Info)}, State}.

terminate(_Reason, Req, _State) ->
  io:format("websocket connection terminated~n~p~n", [maps:get(peer, Req)]),
  ok.
