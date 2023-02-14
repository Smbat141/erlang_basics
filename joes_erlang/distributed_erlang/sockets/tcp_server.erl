-module(tcp_server).
-export([start/0]).

start() ->
    {ok, ListenSocket} = gen_tcp:listen(1234, [binary, {reuseaddr, true}, {active, false}]),
    accept(ListenSocket).

accept(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    spawn(fun() -> handle_client(Socket) end),
    accept(ListenSocket).

handle_client(Socket) ->
    {ok, Data} = gen_tcp:recv(Socket, 0),
    io:format("Received data: ~s~n", [Data]),
    gen_tcp:send(Socket, "ACK\n"),
    gen_tcp:close(Socket).

