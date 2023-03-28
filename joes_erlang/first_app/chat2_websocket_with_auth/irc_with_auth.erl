-module(irc_with_auth).
-export([start/0]).

start() ->
  register(irc, spawn(fun() -> start1() end)).

start1() ->
  process_flag(trap_exit, true),
  loop([]).

loop(L) ->
  receive
    {join, Pid, Who, Password} ->
      case authenticate(Who, Password) of
        true ->
          L1 = L ++ [{Who, Pid}],
          Pid ! {irc, welcome, Who},
          Msg = [Who, <<" joined the chat<br>">>],
          broadcast(L1, scroll, list_to_binary(Msg)),
          broadcast(L1, groups, list_users(L1)),
          loop(L1);
        false ->
          Pid ! {irc, not_authenticated, Who},
          loop(L)
      end;
    {leave, Who} ->
      case lists:keysearch(Who, 1, L) of
        false ->
          loop(L);
        {value, {Who, Pid}} ->
          L1 = L -- [{Who, Pid}],
          Msg = [Who, <<" left the chat<br>">>],
          broadcast(L1, scroll, list_to_binary(Msg)),
          broadcast(L1, groups, list_users(L1)),
          loop(L1)
      end;
    {broadcast, Who, Txt} ->
      broadcast(L, scroll,
        list_to_binary([" > ", Who, " >> ", Txt, "<br>"])),
      loop(L);
    X ->
      io:format("irc:received:~p~n", [X]),
      loop(L)
  end.

broadcast(L, Tag, B) ->
  [Pid ! {irc, Tag, B} || {_, Pid} <- L].

list_users(L) ->
  L1 = [[Who, "<br>"] || {Who, _} <- L],
  list_to_binary(L1).


%% passwords can be decoded with RSA or other crypto ways
users_db() ->
  [{smb, "14521996"}, {eva, "19961452"}].

-spec authenticate(Who, Password) -> Response when
  Who :: atom(),
  Password :: string(),
  Response :: boolean().

authenticate(Who, Password) ->
  io:format("Authenticating ~p with password ~p ~n", [Who, Password]),
  lists:member({binary_to_atom(Who), binary_to_list(Password)}, users_db()).