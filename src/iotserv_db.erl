-module(iotserv_db).

-export([
    init/1,
    stop/0,
    add/1,
    delete/1,
    update/1,
    lookup/1,
    load_all/0
]).

-include("iotserv.hrl").

-define(ETS_TAB, iotserv_ets).
-define(DETS_TAB, iotserv_dets).

init(DetsPath) ->
    case ets:info(?ETS_TAB) of
        undefined ->
            ets:new(?ETS_TAB, [named_table, public, set, {keypos, 2}]);
        _ ->
            ok
    end,
    {ok, _} = dets:open_file(?DETS_TAB, [{file, DetsPath}, {type, set}]),
    load_all().

load_all() ->
    Records = dets:foldl(fun(Elem, Acc) -> [Elem | Acc] end, [], ?DETS_TAB),
    lists:foreach(fun(R) -> ets:insert(?ETS_TAB, R) end, Records),
    ok.

stop() ->
    catch dets:close(?DETS_TAB),
    ok.

add(Device = #device{}) ->
    ets:insert(?ETS_TAB, Device),
    dets:insert(?DETS_TAB, Device),
    {ok, Device#device.id}.

delete(Id) ->
    ets:delete(?ETS_TAB, Id),
    dets:delete(?DETS_TAB, Id),
    ok.

update(Device = #device{}) ->
    ets:insert(?ETS_TAB, Device),
    dets:insert(?DETS_TAB, Device),
    {ok, Device#device.id}.

lookup(Id) ->
    case ets:lookup(?ETS_TAB, Id) of
        [Device] -> {ok, Device};
        [] -> {error, not_found}
    end.
