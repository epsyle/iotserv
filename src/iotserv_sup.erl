-module(iotserv_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Child = #{
        id => iotserv,
        start => {iotserv, start_link, []},
        restart => permanent,
        shutdown => 5000,
        type => worker,
        modules => [iotserv]
    },
    {ok, {{one_for_one, 5, 10}, [Child]}}.
