%% =============================================================================
%% Copyright 2013 Tomohiko Aono
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%% http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%% =============================================================================

-module(myer_protocol_binary).

-include("myer_internal.hrl").

%% -- public --
-export([recv_row/3]).

%% -- private --
-import(myer_protocol, [binary_to_float/2,
                        recv/2, recv_packed_binary/1]).

%% @see sql/protocol.cc : Protocol_binary::store*
%%
%% +---+------+------+---------------------+
%% | k | v    | d    | t                   | k:integer, v:varchar, d:decimal, t:timestamp
%% +---+------+------+---------------------+
%% | 1 | aaa  | NULL | NULL                |
%% | 2 | NULL | NULL | NULL                |
%% | 3 |      | NULL | NULL                |
%% | 4 | NULL | 3.14 | NULL                |
%% | 5 | NULL | NULL | 2012-01-30 16:36:00 |
%% +---+------+------+---------------------+
%% uint offset= (field_pos+2)/8+1, bit= (1 << ((field_pos+2) & 7));
%%            k={ (0+2)/8+1=1, 1<<2=(0+2)&7=  4=0000 0100 }
%%            v={ (1+2)/8+1=1, 1<<3=(1+2)&7=  8=0000 1000 }
%%            d={ (2+2)/8+1=1, 1<<4=(2+2)&7= 16=0001 0000 }
%%            t={ (3+2)/8+1=1, 1<<5=(3+2)&7= 32=0010 0000 }
%% field_count=4, null_field=(4+7+2)/8=1        td vk
%% 1=<<0,48,1,0,0,0,3,97,97,97>>           0, 0011-0000, 1,0,0,0, 3,97,97,97
%% 2=<<0,56,2,0,0,0>>                      0, 0011-1000, 2,0,0,0
%% 3=<<0,48,3,0,0,0,0>>                    0, 0011-0000, 3,0,0,0, 0
%% 4=<<0,40,4,0,0,0,4,51,46,49,52>>        0, 0010-1000, 4,0,0,0, 4,51,46,49,52
%% 5=<<0,24,5,0,0,0,7,220,7,1,30,16,36,0>> 0, 0001-1000, 5,0,0,0, 7,220,7,1,30,16,36,0,
%%                                                              len   Y=2 M  D  H, M S,second_part=4 (7->11)
%%
%% +---+------+------+---------------------+------+------+------+
%% | k | v    | d    | t                   | a    | b    | c    |
%% +---+------+------+---------------------+------+------+------+
%% | 1 | aaa  | NULL | NULL                | NULL | NULL | NULL |
%% | 2 | NULL | NULL | NULL                | NULL | NULL | NULL |
%% | 3 |      | NULL | NULL                | NULL | NULL | NULL |
%% | 4 | NULL | 3.14 | NULL                | NULL | NULL | NULL |
%% | 5 | NULL | NULL | 2012-02-02 17:10:52 | NULL | NULL | NULL |
%% +---+------+------+---------------------+------+------+------+
%% fc=7, nf=(7+7+2)/8=2                         batd vk            c
%%            a={ (4+2)/8+1=1, 1<<6=(4+2)&7= 64=0100 0000, 0000 0000 }
%%            b={ (5+2)/8+1=1, 1<<7=(5+2)&7=128=1000 0000, 0000 0000 }
%%            c={ (6+2)/8+1=2, 1<<0=(6+2)&7=  1=0000 0000, 0000 0001 }
%% 1=<<0,240,1,1,0,0,0,3,97,97,97>> 0, 1111-0000,0000-0001, 1,0,0,0, 3,97,97,97

%% == public ==

-spec recv_row(protocol(),binary(),[field()]) -> {ok, [term()], protocol()}.
recv_row(Protocol, <<0>>, Fields) ->
    Size = (length(Fields) + (8+1)) div 8,
    case recv(Protocol, Size) of
        {ok, Binary, #protocol{}=P} ->
            recv_row(P, Fields, null_fields(Binary), [])
    end.

recv_row(Protocol, [], _NullFields, List) ->
    {ok, lists:reverse(List), Protocol};
recv_row(Protocol, [_|T], <<1:1,B/bits>>, List) ->
    recv_row(Protocol, T, B, [null|List]);
recv_row(Protocol, [H|T], <<0:1,B/bits>>, List) ->
    case restore(Protocol, type(H#field.type), H) of
        {ok, Value, #protocol{}=P} ->
            recv_row(P, T, B, [Value|List])
    end.

%% == private ==

cast(Binary, binary, _Field) ->
    Binary;
cast(Binary, decimal, #field{decimals=D}) ->
    binary_to_float(Binary, D);
cast(Binary, datetime, _Field) ->
    case Binary of
        <<Year:16/little,Month,Day,Hour,Minute,Second>> ->
            {{Year,Month,Day},{Hour,Minute,Second}};
        _ ->
            undefined % TODO: second_part, 7->11?
    end;
cast(Binary, date, _Field) ->
    <<Year:16/little,Month,Day>> = Binary,
    {Year,Month,Day};
cast(Binary, time, _Field) ->
    case Binary of
        <<_Neg,_Day:32/little,Hour,Minute,Second>> ->
            {Hour,Minute,Second};
        _ ->
            undefined % TODO: second_part, 8->12?
    end;
cast(Binary, bit, _Field) ->
    binary:decode_unsigned(Binary, big);
cast(_Binary, undefined, _Field) ->
    undefined.

null_fields(Binary) ->
    null_fields(Binary, <<>>).

null_fields(<<>>, Binary) ->
    <<0:2,B/bits>> = Binary,
    B;
null_fields(<<B8:1,B7:1,B6:1,B5:1,B4:1,B3:1,B2:1,B1:1,Rest/binary>>, B) ->
    null_fields(Rest, <<B/binary,B1:1,B2:1,B3:1,B4:1,B5:1,B6:1,B7:1,B8:1>>).

restore(Protocol, {integer,Size}, #field{flags=F})
  when ?ISSET(F,?UNSIGNED_FLAG) ->
    case recv(Protocol,Size) of
        {ok, <<Data:Size/integer-unsigned-little-unit:8>>, #protocol{}=P} ->
            {ok, Data, P}
    end;
restore(Protocol, {integer,Size}, _Field) ->
    case recv(Protocol,Size) of
        {ok, <<Data:Size/integer-signed-little-unit:8>>, #protocol{}=P} ->
            {ok, Data, P}
    end;
restore(Protocol, {float,Size}, #field{flags=F})
  when ?ISSET(F,?UNSIGNED_FLAG) ->
    case recv(Protocol,Size) of
        {ok, <<Data:Size/float-unsigned-little-unit:8>>, #protocol{}=P} ->
            {ok, Data, P}
    end;
restore(Protocol, {float,Size}, _Field) ->
    case recv(Protocol,Size) of
        {ok, <<Data:Size/float-signed-little-unit:8>>, #protocol{}=P} ->
            {ok, Data, P}
    end;
restore(Protocol, Type, Field) ->
    case recv_packed_binary(Protocol) of
        {ok, Binary, #protocol{}=P} ->
            {ok, cast(Binary,Type,Field), P}
    end.

%%pe(?MYSQL_TYPE_DECIMAL)     -> undefined;
type(?MYSQL_TYPE_TINY)        -> {integer,1};
type(?MYSQL_TYPE_SHORT)       -> {integer,2};
type(?MYSQL_TYPE_LONG)        -> {integer,4};
type(?MYSQL_TYPE_FLOAT)       -> {float,4};
type(?MYSQL_TYPE_DOUBLE)      -> {float,8};
%%pe(?MYSQL_TYPE_NULL)        -> undefined;
type(?MYSQL_TYPE_TIMESTAMP)   -> datetime;
type(?MYSQL_TYPE_LONGLONG)    -> {integer,8};
type(?MYSQL_TYPE_INT24)       -> {integer,4};
type(?MYSQL_TYPE_DATE)        -> date;
type(?MYSQL_TYPE_TIME)        -> time;
type(?MYSQL_TYPE_DATETIME)    -> datetime;
type(?MYSQL_TYPE_YEAR)        -> {integer,2};
%%pe(?MYSQL_TYPE_NEWDATE)     -> undefined;
%%pe(?MYSQL_TYPE_VARCHAR)     -> undefined;
type(?MYSQL_TYPE_BIT)         -> bit;
%%pe(?MYSQL_TYPE_TIMESTAMP2)  -> undefined;
%%pe(?MYSQL_TYPE_DATETIME2)   -> undefined;
%%pe(?MYSQL_TYPE_TIME2)       -> undefined;
type(?MYSQL_TYPE_NEWDECIMAL)  -> decimal;
%%pe(?MYSQL_TYPE_ENUM)        -> undefined;
%%pe(?MYSQL_TYPE_SET)         -> undefined;
%%pe(?MYSQL_TYPE_TINY_BLOB)   -> undefined;
%%pe(?MYSQL_TYPE_MEDIUM_BLOB) -> undefined;
%%pe(?MYSQL_TYPE_LONG_BLOB)   -> undefined;
type(?MYSQL_TYPE_BLOB)        -> binary;
type(?MYSQL_TYPE_VAR_STRING)  -> binary;
type(?MYSQL_TYPE_STRING)      -> binary;
%%pe(?MYSQL_TYPE_GEOMETRY)    -> undefined;
type(_)                       -> undefined.
