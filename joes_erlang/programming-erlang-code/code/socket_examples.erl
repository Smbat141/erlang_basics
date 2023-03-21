-module(socket_examples).
-compile(export_all).
-import(lists, [reverse/1]).


nano_get_url() ->
  nano_get_url("www.google.com").

nano_get_url(Host) ->
  {ok, Socket} = gen_tcp:connect(Host, 443, [binary, {packet, 0}]), %% (1)
  Request = "GET / HTTP/1.1\r\nHost: " ++ Host ++ "\r\n\r\n",
  ok = gen_tcp:send(Socket, Request),  %% (2)
  receive_data(Socket, []).

receive_data(Socket, SoFar) ->
  receive
    {tcp, Socket, Bin} ->    %% (3)
      receive_data(Socket, [Bin | SoFar]);
    {tcp_closed, Socket} -> %% (4)
      io:format("******************************************** THE END *********************************************~n"),
      list_to_binary(reverse(SoFar)) %% (5)
  end.


%%nano_client_eval(Str) ->
%%  {ok, Socket} = gen_tcp:connect("localhost", 2345, [binary, {packet, 4}]),
%%  ok = gen_tcp:send(Socket, term_to_binary(Str)),
%%  receive
%%    {tcp, Socket, Bin} ->
%%      io:format("Client received binary = ~p~n", [Bin]),
%%      Val = binary_to_term(Bin),
%%      io:format("Client result = ~p~n", [Val]),
%%      gen_tcp:close(Socket)
%%  end.

%%start_nano_server() ->
%%  {ok, Listen} = gen_tcp:listen(2345, [binary, {packet, 4},  %% (6)
%%    {reuseaddr, true},
%%    {active, true}]),
%%  {ok, Socket} = gen_tcp:accept(Listen),  %% (7)
%%  gen_tcp:close(Listen),  %% (8)
%%  loop(Socket).


%%start_seq_server() ->
%%  {ok, Listen} = gen_tcp:listen(2345, [binary, {packet, 4}, {reuseaddr, true}, {active, true}]),
%%  seq_loop(Listen).
%%seq_loop(Listen) ->
%%  {ok, Socket} = gen_tcp:accept(Listen),
%%  loop(Socket),
%%  seq_loop(Listen).


%%start_parallel_server() ->
%%  {ok, Listen} = gen_tcp:listen(2345, [binary, {packet, 4}, {active, true}, {reuseaddr, true}]),
%%  spawn(fun() -> par_connect(Listen) end).
%%
%%par_connect(Listen) ->
%%  {ok, Socket} = gen_tcp:accept(Listen),
%%  spawn(fun() -> par_connect(Listen) end),
%%  loop(Socket).


%%loop(Socket) ->
%%  receive
%%    {tcp, Socket, Bin} ->
%%      io:format("Server received binary = ~p~n", [Bin]),
%%      Str = binary_to_term(Bin),  %% (9)
%%      io:format("Server (unpacked)  ~p~n", [Str]),
%%      Reply = lib_misc:string2value(Str),  %% (10)
%%      io:format("Server replying = ~p~n", [Reply]),
%%      gen_tcp:send(Socket, term_to_binary(Reply)),  %% (11)
%%      loop(Socket);
%%    {tcp_closed, Socket} ->
%%      io:format("Server socket closed~n")
%%  end.
%% ################################################### EXERCISE ########################################################

start_email_server() ->
  {ok, Listen} = gen_tcp:listen(1212, [binary, {packet, 0}, {reuseaddr, true}, {active, true}]),
  {ok, Socket} = gen_tcp:accept(Listen),
  gen_tcp:close(Listen),
  loop(Socket).

loop(Socket) ->
  receive
    {tcp, Socket, Bin} ->
      io:format("Server received binary = ~p~n", [binary_to_term(Bin)]),
      case binary_to_term(Bin) of
        {send, {From, To, Subject, Message}} ->
          save_email(From, To, Subject, Message),
          gen_tcp:send(Socket, term_to_binary("Email Sent"));
        get_all ->
          gen_tcp:send(Socket, term_to_binary(file:consult("email_db.tmp")))
      end,
      spawn(fun() -> start_email_server() end);
    {tcp_closed, Socket} ->
      io:format("Server socket closed~n")
  end.


send_email(From, To, Subject, Message) ->
  {ok, Socket} = gen_tcp:connect("localhost", 1212, [binary, {packet, 0}]),
  gen_tcp:send(Socket, term_to_binary({send, {From, To, Subject, Message}})),
  receive_client_response(Socket).


get_all_emails() ->
  {ok, Socket} = gen_tcp:connect("localhost", 1212, [binary, {packet, 0}]),
  gen_tcp:send(Socket, term_to_binary(get_all)),
  receive_client_response(Socket).

save_email(From, To, Subject, Message) ->
  Email = {from, From, to, To, subject, Subject, message, Message},
  {ok, S} = file:open("email_db.tmp", [append]),
  io:format(S, "~p.~n", [Email]),
  file:close(S).


receive_client_response(Socket) ->
  receive
    {tcp, Socket, Bin} ->
      io:format("Client received binary = ~p~n", [Bin]),
      Val = binary_to_term(Bin),
      io:format("Client result = ~p~n", [Val]),
      gen_tcp:close(Socket)
  end.


%%start_nano_server() ->
%%  {ok, Socket} = gen_udp:open(2345, [binary]),
%%  loop(Socket).
%%
%%loop(Socket) ->
%%  receive
%%    {udp, Socket, Host, Port, Bin} ->
%%      io:format("Server received binary = ~p~n", [Bin]),
%%      {CipherText, Tag} = binary_to_term(Bin),  %% (9)
%%      {Mod, Func, Args} = binary_to_term(decrypt_via_aes(CipherText, Tag)),
%%      io:format("Server (unpacked)  ~p~n", [{Mod, Func, Args}]),
%%      Reply = apply(Mod, Func, Args),  %% (10)
%%      io:format("Server replying = ~p~n", [Reply]),
%%      gen_udp:send(Socket, Host, Port, term_to_binary(Reply)),
%%      loop(Socket)
%%  end.
%%
%%nano_client_eval(Mod, Func, Args) ->
%%  {ok, Socket} = gen_udp:open(0, [binary]),
%%  B = term_to_binary({Mod, Func, Args}),
%%  ok = gen_udp:send(Socket, "localhost", 2345, term_to_binary(encrypt_via_aes(B))),
%%  receive
%%    {udp, Socket, _, _, Bin} ->
%%      io:format("Client received binary = ~p~n", [Bin]),
%%      Val = binary_to_term(Bin),
%%      io:format("Client result = ~p~n", [Val]),
%%      gen_udp:close(Socket)
%%  end.
%%
%%encrypt_via_aes(TextOrBin) ->
%%  Key = <<1:256>>,
%%  IV = <<0:128>>,
%%  AAD = <<>>,
%%  crypto:crypto_one_time_aead(aes_256_gcm, Key, IV, TextOrBin, AAD, true).
%%
%%decrypt_via_aes(CipherText, Tag) ->
%%  Key = <<1:256>>,
%%  IV = <<0:128>>,
%%  AAD = <<>>,
%%  crypto:crypto_one_time_aead(aes_256_gcm, Key, IV, CipherText, AAD, Tag, false).

%% #####################################################################################################################
%%start_blocking_server() ->
%%  {ok, Listen} = gen_tcp:listen(2345, [binary, {packet, 4}, {active, false}, {reuseaddr, true}]),
%%  {ok, Socket} = gen_tcp:accept(Listen),
%%  loop(Socket).
%%
%%loop(Socket) ->
%%  case gen_tcp:recv(Socket, 0) of
%%    {ok, B} ->
%%      io:format("Received  ~p~n", [B]),
%%      gen_tcp:send(Socket, term_to_binary(B));
%%    {error, closed} ->
%%      io:format("OOPS ERROR")
%%  end,
%%  loop(Socket).


%%start_hybrid_server() ->
%%  {ok, Listen} = gen_tcp:listen(2345, [binary, {packet, 4}, {active, once}, {reuseaddr, true}]),
%%  loop(Listen).
%%
%%loop(Listen) ->
%%  {ok, Socket} = gen_tcp:accept(Listen),
%%  io:format("Request From ~p~n", [inet:peername(Socket)]),
%%  receive
%%    {tcp, Socket, Data} ->
%%      io:format("Processing the data ~p~n", [Data]),
%%      gen_tcp:send(Socket, term_to_binary(Data)),
%%      inet:setopts(Socket, [{active, once}]),
%%      loop(Listen);
%%    {tcp_closed, Socket} ->
%%      io:format("OOPS CLOSED~n")
%%  end.


error_test() ->
  spawn(fun() -> error_test_server() end),
  lib_misc:sleep(2000),
  {ok, Socket} = gen_tcp:connect("localhost", 4321, [binary, {packet, 2}]),
  io:format("connected to:~p~n", [Socket]),
  gen_tcp:send(Socket, <<"123">>),
  receive
    Any ->
      io:format("Any=~p~n", [Any])
  end.

error_test_server() ->
  {ok, Listen} = gen_tcp:listen(4321, [binary, {packet, 2}]),
  {ok, Socket} = gen_tcp:accept(Listen),
  error_test_server_loop(Socket).

error_test_server_loop(Socket) ->
  receive
    {tcp, Socket, Data} ->
      io:format("received:~p~n", [Data]),
      _ = atom_to_list(Data),
      error_test_server_loop(Socket)
  end.


start_udp_server() ->
  {ok, Socket} = gen_udp:open(4000, [binary]),
  udp_loop(Socket).

udp_loop(Socket) ->
  receive
    {udp, Socket, Host, Port, _Bin} ->
      gen_udp:send(Socket, Host, Port, _Bin),
      udp_loop(Socket)
  end.


udp_client(Request) ->
  {ok, Socket} = gen_udp:open(0, [binary]),
  ok = gen_udp:send(Socket, "localhost", 4000, Request),
  Value = receive
            {udp, Socket, _, _, Bin} ->
              {ok, Bin}
          after 2000 -> error
          end,
  gen_udp:close(Socket),
  Value.