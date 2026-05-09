%%%-------------------------------------------------------------------
%% @doc iotserv public API
%% @end
%%%-------------------------------------------------------------------

-module(iotserv_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    iotserv_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
