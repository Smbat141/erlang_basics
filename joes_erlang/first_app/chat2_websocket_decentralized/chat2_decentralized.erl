-module(chat2_decentralized).
-export([start/1]).

start(Browser) ->
  idle(Browser).

idle(Browser) ->
  receive
    {Browser, {struct, {[{<<"join">>, Who}, {<<"group_name">>, GroupName}]}}} ->
      case whereis(binary_to_atom(GroupName)) of
        undefined ->
          Browser ! [#{cmd => fill_div, id => errors, txt => <<"Group does not exists">>}],
          Browser ! [#{cmd => show_div, id => errors}];
        _Pid ->
          binary_to_atom(GroupName) ! {join, self(), Who},
          idle(Browser)
      end;
    {join, GroupName, Who} ->
      Browser ! [#{cmd => hide_div, id => idle}],
      Browser ! [#{cmd => hide_div, id => errors}],
      Browser ! [#{cmd => show_div, id => running}],
      running(GroupName, Browser, Who);
    X ->
      io:format("chat idle received:~p~n", [X]),
      idle(Browser)
  end.

running(GroupName, Browser, Who) ->
  receive
    {Browser, {struct, {[{<<"entry">>, <<"tell">>}, {<<"txt">>, Txt}]}}} ->
      GroupName ! {broadcast, Who, Txt},
      running(GroupName, Browser, Who);
    {Browser, {struct, {[{<<"share_mp3">>, MP3}]}}} ->
      GroupName ! {broadcast_mp3, Who, MP3},
      running(GroupName, Browser, Who);
    {Browser, {struct, {[{<<"clicked">>, <<"Leave">>}]}}} ->
      GroupName ! {leave, Who},
      Browser ! [#{cmd => hide_div, id => running}],
      Browser ! [#{cmd => show_div, id => idle}],
      idle(Browser);
    {irc, scroll, Bin} ->
      Browser ! [#{cmd => append_div, id => scroll, txt => Bin}],
      running(GroupName, Browser, Who);
    {irc, broadcast_mp3, Bin} ->
      Browser ! [#{cmd => append_mp3, id => scroll, txt => Bin}],
      running(GroupName, Browser, Who);
    {irc, groups, Bin} ->
      Browser ! [#{cmd => fill_div, id => users, txt => Bin}],
      running(GroupName, Browser, Who);
    X ->
      io:format("chat running received:~p~n", [X]),
      running(GroupName, Browser, Who)
  end.

