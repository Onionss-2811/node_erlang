%% @author tukna
%% @doc @todo Add description to node2.


-module(node2).
-behaviour(gen_server).

-export([start/0, send/3, m_receive/3]).
-export([init/1, handle_call/3, handle_cast/2]).

start() ->
    Return = gen_server:start_link({global, node2}, node2, [], []),
    io:format("start_node2: ~p~n", [Return]),
    Return.

m_receive(M_from, M_to, Mess) ->
	gen_server:call({global,M_to}, {m_receive,M_from, M_to, Mess}).

send(M_from, M_to, Mess) -> 
	gen_server:call({global,M_from}, {send,M_from, M_to, Mess}).


init([]) ->
    State = [],
    Return = {ok, State},
    io:format("init: ~p~n", [State]),
    Return.



handle_call({send,M_from, M_to, Mess}, _From, State) ->
	io:format("You send to ~p: ~p ~n",[M_to, Mess]),
	node1:m_receive(M_from, M_to, Mess),
    {reply, ok, State};

handle_call({m_receive,M_from, _M_to, Mess}, _From, State) ->
    io:format("Message from ~p: ~p ~n",[M_from, Mess]),
    {reply, ok, State}.



handle_cast({send,Mess}, State) ->
    io:format("Receive msg from handle_cast: ~p~n", [Mess]),
    {noreply, State}.