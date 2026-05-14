-module(iotserv_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
    {ok, Bin} = file:read_file("config/iotserv.json"),
    Conf = jsx:decode(Bin, [return_maps]),
    DetsPath = maps:get(<<"dets_path">>, Conf),
    application:set_env(iotserv, dets_path, binary_to_list(DetsPath)),
    iotserv_sup:start_link().

stop(_State) ->
    ok.
