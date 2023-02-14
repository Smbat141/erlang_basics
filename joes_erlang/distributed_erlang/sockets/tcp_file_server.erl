-module(tcp_file_server).
-export([run_server/0, read_file/1, write_file/2, list_dir/0]).


run_server() ->
  {ok, Socket} = gen_tcp:listen(8808, [binary, {reuseaddr, true}, {active, false}]),
  accept_connection(Socket).

accept_connection(Socket) ->
  {ok, AcceptedSocket} = gen_tcp:accept(Socket),
  {ok, Data} = gen_tcp:recv(AcceptedSocket, 0),
  io:format("Data is ~p~n", [Data]),
  case binary_to_term(Data) of
    {read, FileFullPath} ->
      gen_tcp:send(AcceptedSocket, term_to_binary(file:read_file(FileFullPath)));
    {write, FileFullPath, Bytes} ->
      gen_tcp:send(AcceptedSocket, term_to_binary(file:write_file(FileFullPath, Bytes)));
    list ->
      gen_tcp:send(AcceptedSocket, term_to_binary(file:list_dir(".")));
    _Else ->
      io:format("Not Supported opperation~n")
  end,
  gen_tcp:close(AcceptedSocket),
  accept_connection(Socket).

read_file(FileFullPath) ->
  Socket = connect_file_server(),
  gen_tcp:send(Socket, term_to_binary({read, FileFullPath})),
  wait_server_response(Socket).


write_file(FileFullPath, Bytes) ->
  Socket = connect_file_server(),
  gen_tcp:send(Socket, term_to_binary({write, FileFullPath, Bytes})),
  wait_server_response(Socket).


list_dir() ->
  Socket = connect_file_server(),
  gen_tcp:send(Socket, term_to_binary(list)),
  wait_server_response(Socket).

wait_server_response(Socket) ->
  receive
    {tcp, Socket, Data} ->
      io:format("Received data: ~p~n", [binary_to_term(Data)]),
      gen_tcp:close(Socket);
    Else ->
      io:format("Received not suppreted data: ~p~n", [Else])
  end.


connect_file_server() ->
  {ok, Socket} = gen_tcp:connect("localhost", 8808, [binary, {active, true}, {packet, 0}]),
  Socket.

