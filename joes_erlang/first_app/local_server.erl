-module(local_server).
-compile(export_all).

start() ->
  {ok, Listen} = gen_tcp:listen(1234, [{packet, 0}, {reuseaddr, true}, {active, true}]),
  spawn(fun() -> par_connect(Listen) end).

par_connect(Listen) ->
  {ok, Socket} = gen_tcp:accept(Listen),
  spawn(fun() -> par_connect(Listen) end),
  wait(Socket).

wait(Socket) ->
  receive
    {tcp, Socket, Data} ->
      io:format("***************************** Socket:~p~n", [Socket]),
      io:format("received:~p~n", [Data]),
      Msg = prefix() ++
        "WebSocket-Origin: http://localhost:63342\r\n" ++
        "WebSocket-Location: ws://localhost:1234\r\n\r\n",
      gen_tcp:send(Socket, Msg),
      loop(Socket);
    Any ->
      io:format("Received:~p~n", [Any]),
      wait(Socket)
  end.

prefix() ->
  "HTTP/1.1 101 Web Socket Protocol Handshake\r\nUpgrade:WebSocket\r\nConnection: Upgrade\r\n".

loop(Socket) ->
  receive
    {tcp, Socket, Data} ->
      io:format("received:~p~n", [Data]),
      loop(Socket);
    Any ->
      io:format("Received:~p~n", [Any]),
      loop(Socket)
  end.



GET / HTTP/1.1
Host: localhost:1234

Connection: Upgrade

Pragma: no-cache

Cache-Control: no-cache
User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36
Upgrade: websocket
Origin: http://localhost:63342
Sec-WebSocket-Version: 13
Accept-Encoding: gzip, deflate, br
Accept-Language: ru,en-US;q=0.9,en;q=0.8
Cookie: __profilin=p%3Dt; _regroup_mdp_session=jxEcgNpk%2BZWCbN3ZOeN%2FqhlTHuhM50Zkd6NFSKhR8HO64Spaozm4thW3O8MpBWjHXY0NSEHbPzhfNFMId20c4ikmfmNeycrUH%2Fdk5zwOt9Wvs8MR249BmxcFvHYQJEurKznvjfnrLfEvjPHqUnhFM%2BIwOWVnC9ZwAvMBsgDoct99gR7LGiMhXcSO2YRX3Ni0N0oWFZP0TobNpL%2BhoUd%2B4LRxg%2BQvAPERLOznETgIFlKgJkQG1RZtwHOGTQu%2B6FsaHvDlpBOAzYdT1oS3eCsErpE9muIeIkPk4%2BJosJXyJjgrDqVUlmvU3I0uE4UmV79AW3crJVOp3Ab5iIfYH0T4bzblzACv2u6l6%2FUqnDeEpzEIlwHnAvAUt3h8IMhXK%2FT4KFz%2BJEGbDByNVDsMOOSqWZwDZ1Q%3D--nuR4eTP9sYedxbqM--0MTgy2c%2B5sKNufYIxfbGRw%3D%3D; Pycharm-a2a0121d=3c158b04-b7da-4d8a-9291-06cafcc8a9a1; _rails-regroup2_session_key=86b6d2d6db6350e88e7576755221d360
Sec-WebSocket-Key: E/e8P+AL7e+61AeSTK0S8g==
Sec-WebSocket-Extensions: permessage-deflate; client_max_window_bits









Msg = "HTTP/1.1 101 Switching Protocols\r\n
Upgrade: websocket\r\n
Connection: Upgrade\r\n
%%Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=\r\n
WebSocket-Origin: http://localhost:63342\r\n
Sec-WebSocket-Version: 13\r\n
WebSocket-Location: ws://localhost:1456/websocket/clock1\r\n\r\n"




M = "HTTP/1.1 101 Switching Protocols\r\n\n
Upgrade: websocket\r\n\n
Connection: Upgrade\r\n\n
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=\r\n\n
WebSocket-Origin: http://localhost:63342\r\n\n
Sec-WebSocket-Version: 13\r\n\n
WebSocket-Location: ws://localhost:1456/websocket/clock1
\r\n\r\n".














