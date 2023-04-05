%%-module(exercises).
%%-export([get_all_exported_modules/0]).
%%
%%
%%
%%save_exported_modules_ets() ->
%%  TableId = ets:new(exported_modules, [set]),
%%  lists:foreach(fun({Module, Arity}) -> ets:insert(TableId, {Module, Arity}) end, get_all_exported_modules()).
%%
%%%%fetch_ets() ->
%%%%  ets:tab2list(TableId).
%%%%
%%%%
%%%%save_exported_modules_dets() ->
%%%%  5.
%%
%%get_all_exported_modules() ->
%%  SysLibs = lists:map(fun({ModuleName, _, _}) -> ModuleName end, application:which_applications()),
%%  lists:map(fun(ModuleName) -> ModuleName:module_info(exports) end, SysLibs).



-module(exercises).
-export([test/0]).

test() ->
  Factorial = fun Fun(N) ->
    if N == 0 ->
      1;
      true ->
        N * Fun(N - 1)
    end
              end,

  Result = Factorial(5),
  io:format("Factorial of 5 is ~w~n", [Result]).