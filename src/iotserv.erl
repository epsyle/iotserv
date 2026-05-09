-module(iotserv).
-behaviour(gen_server).

-export([
    start_link/0,
    stop/0,
    add/1,
    delete/1,
    change/1,
    lookup/1
]).

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-include("iotserv.hrl").

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:call(?MODULE, stop).

add(Device) ->
    gen_server:call(?MODULE, {add, Device}).

delete(Id) ->
    gen_server:call(?MODULE, {delete, Id}).

change(Device) ->
    gen_server:call(?MODULE, {change, Device}).

lookup(Id) ->
    gen_server:call(?MODULE, {lookup, Id}).

init([]) ->
    {ok, Path} = application:get_env(iotserv, dets_path),
    ok = iotserv_db:init(Path),
    {ok, #{}}.

handle_call({add, Device}, _From, State) ->
    {reply, iotserv_db:add(Device), State};

handle_call({delete, Id}, _From, State) ->
    {reply, iotserv_db:delete(Id), State};

handle_call({change, Device}, _From, State) ->
    {reply, iotserv_db:update(Device), State};

handle_call({lookup, Id}, _From, State) ->
    {reply, iotserv_db:lookup(Id), State};

handle_call(stop, _From, State) ->
    {stop, normal, ok, State};

handle_call(_, _From, State) ->
    {reply, {error, bad_request}, State}.

handle_cast(_, State) ->
    {noreply, State}.

handle_info(_, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    iotserv_db:stop(),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
