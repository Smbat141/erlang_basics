-module(registered_process_names).
-export([start/0, ping/1, pong/0]).

ping(0) ->
    pong ! finished,
    io:format("Ping finished~n", []);

ping(N) ->
    pong ! ok,
    receive
        pong ->
            io:format("Ping received pong~n", [])
    end,
    ping(N - 1).

pong() ->
    receive
        finished ->
            io:format("Pong finished~n", []);
        ok ->
            io:format("Pong received ping~n", []),
            ping ! pong,
            pong()
    end.

start() ->
    register(pong, spawn(registered_process_names, pong, [])),
    register(ping, spawn(registered_process_names, ping, [3])).
