-module(bit_exercises).

%% API
-export([reverse_binary/1, term_to_packet/1, packet_to_term/1, tests/0, reverse_bits/1, just_do_it/1]).

tests() ->
  Term = "abc",
  packet_to_term(term_to_packet(Term)) =:= Term.


reverse_binary(Bin) ->
  Bin_List = binary_to_list(Bin),
  List_Bin = lists:reverse(Bin_List),
  list_to_binary(List_Bin).


term_to_packet(Term) ->
  Data = term_to_binary(Term),
  Length = byte_size(Data),
  <<Length:32, Data/binary>>.


packet_to_term(Packet) ->
  <<_:32, Data/binary>> = Packet,
  binary_to_term(Data).


reverse_bits(Binary) ->
  reverse_bits(Binary, 0).

reverse_bits(Binary, N) when N >= byte_size(Binary) ->
  Binary;
reverse_bits(Binary, N) ->
  <<_:N, Rest/binary>> = Binary,
  reverse_bits(<<Rest/binary, 0:N>>, N + 1).

just_do_it(X) ->
  lists:partition(fun(X) ->
    case X > 5 of
    true -> true
    end end, [1,2,3,5,6,7]).