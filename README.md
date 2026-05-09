iotserv
=====
OTP-приложение для управления сервером IoT-устройств.

Пример
-----
```erl
elyspe@elyspe:~/Документы/hw09/iotserv$ rebar3 shell
===> Verifying dependencies...
===> Analyzing applications...
===> Compiling iotserv
Erlang/OTP 26 [erts-14.2.5.13] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit:ns]

Eshell V14.2.5.13 (press Ctrl+G to abort, type help(). for help)
1> application:ensure_all_started(iotserv).
{ok,[jsx,iotserv]}
2> rr("include/iotserv.hrl").
[device]
3> D1 = #device{id = 1, name = <<"sensor-1">>, address = <<"A1">>, temperature = 23, metrics =
[{temp, 43}]}.
#device{id = 1,name = <<"sensor-1">>,address = <<"A1">>,
        temperature = 23,
        metrics = [{temp,43}]}
4> iotserv:add(D1).
{ok,1}
5> iotserv:lookup(1).
{ok,#device{id = 1,name = <<"sensor-1">>,address = <<"A1">>,
        temperature = 23,
        metrics = [{temp,43}]}}
6> D2 = #device{id = 1, name = <<"sensor-1">>, address = <<"A2">>, temperature = 25, metrics = [{temp, 45}]}.
#device{id = 1,name = <<"sensor-1">>,address = <<"A2">>,
        temperature = 25,
        metrics = [{temp,45}]}
7> iotserv:change(D2).
{ok,1}
8> iotserv:lookup(1).
{ok,#device{id = 1,name = <<"sensor-1">>,address = <<"A2">>,
            temperature = 25,
            metrics = [{temp,45}]}}
9> iotserv:delete(1).
ok
10> iotserv:lookup(1).
{error,not_found}
11> whereis(iotserv).
<0.208.0>
12> exit(whereis(iotserv), kill).
true
=SUPERVISOR REPORT==== 9-May-2026::22:15:08.810335 ===
    supervisor: {local,iotserv_sup}
    errorContext: child_terminated
    reason: killed
    offender: [{pid,<0.208.0>},
               {id,iotserv},
               {mfargs,{iotserv,start_link,[]}},
               {restart_type,permanent},
               {significant,false},
               {shutdown,5000},
               {child_type,worker}]

13> whereis(iotserv).
<0.229.0>

