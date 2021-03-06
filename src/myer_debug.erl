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

-module(myer_debug).

-include("myer_internal.hrl").

%% -- public --
-export([stat/1, caps/1, flags/1, type/1]).
-export([md5/1]).

%% -- private --
-define(BCHECK(B,K,V), (case B band K of 0 -> ""; _ -> V end)).

%% == public ==

-spec stat(integer()) -> string().
stat(S)
  when is_integer(S) ->
    L = [
         ?BCHECK(S,?SERVER_STATUS_IN_TRANS, "SERVER_STATUS_IN_TRANS"),
         ?BCHECK(S,?SERVER_STATUS_AUTOCOMMIT, "SERVER_STATUS_AUTOCOMMIT"),
         ?BCHECK(S,?SERVER_MORE_RESULTS_EXISTS, "SERVER_MORE_RESULTS_EXISTS"),
         ?BCHECK(S,?SERVER_QUERY_NO_GOOD_INDEX_USED, "SERVER_QUERY_NO_GOOD_INDEX_USED"),
         ?BCHECK(S,?SERVER_QUERY_NO_INDEX_USED, "SERVER_QUERY_NO_INDEX_USED"),
         ?BCHECK(S,?SERVER_STATUS_CURSOR_EXISTS, "SERVER_STATUS_CURSOR_EXISTS"),
         ?BCHECK(S,?SERVER_STATUS_LAST_ROW_SENT, "SERVER_STATUS_LAST_ROW_SENT"),
         ?BCHECK(S,?SERVER_STATUS_DB_DROPPED, "SERVER_STATUS_DB_DROPPED"),
         ?BCHECK(S,?SERVER_STATUS_NO_BACKSLASH_ESCAPES, "SERVER_STATUS_NO_BACKSLASH_ESCAPES"),
         ?BCHECK(S,?SERVER_STATUS_METADATA_CHANGED, "SERVER_STATUS_METADATA_CHANGED"),
         ?BCHECK(S,?SERVER_QUERY_WAS_SLOW, "SERVER_QUERY_WAS_SLOW"),
         ?BCHECK(S,?SERVER_PS_OUT_PARAMS, "SERVER_PS_OUT_PARAMS"),
         ?BCHECK(S,?SERVER_STATUS_IN_TRANS_READONLY, "SERVER_STATUS_IN_TRANS_READONLY")
        ],
    string:join([ E || E <- L, length(E) > 0 ], ",");
stat(_) ->
    "?".

-spec caps(integer()) -> string().
caps(C)
  when is_integer(C) ->
    L = [
         ?BCHECK(C,?CLIENT_LONG_PASSWORD, "CLIENT_LONG_PASSWORD"),
         ?BCHECK(C,?CLIENT_FOUND_ROWS, "CLIENT_FOUND_ROWS"),
         ?BCHECK(C,?CLIENT_LONG_FLAG, "CLIENT_LONG_FLAG"),
         ?BCHECK(C,?CLIENT_CONNECT_WITH_DB, "CLIENT_CONNECT_WITH_DB"),
         ?BCHECK(C,?CLIENT_NO_SCHEMA, "CLIENT_NO_SCHEMA"),
         ?BCHECK(C,?CLIENT_COMPRESS, "CLIENT_COMPRESS"),
         ?BCHECK(C,?CLIENT_ODBC, "CLIENT_ODBC"),
         ?BCHECK(C,?CLIENT_LOCAL_FILES, "CLIENT_LOCAL_FILES"),
         ?BCHECK(C,?CLIENT_IGNORE_SPACE, "CLIENT_IGNORE_SPACE"),
         ?BCHECK(C,?CLIENT_PROTOCOL_41, "CLIENT_PROTOCOL_41"),
         ?BCHECK(C,?CLIENT_INTERACTIVE, "CLIENT_INTERACTIVE"),
         ?BCHECK(C,?CLIENT_SSL, "CLIENT_SSL"),
         ?BCHECK(C,?CLIENT_IGNORE_SIGPIPE, "CLIENT_IGNORE_SIGPIPE"),
         ?BCHECK(C,?CLIENT_TRANSACTIONS, "CLIENT_TRANSACTIONS"),
         ?BCHECK(C,?CLIENT_RESERVED, "CLIENT_RESERVED"),
         ?BCHECK(C,?CLIENT_SECURE_CONNECTION, "CLIENT_SECURE_CONNECTION"),
         ?BCHECK(C,?CLIENT_MULTI_STATEMENTS, "CLIENT_MULTI_STATEMENTS"),
         ?BCHECK(C,?CLIENT_MULTI_RESULTS, "CLIENT_MULTI_RESULTS"),
         ?BCHECK(C,?CLIENT_PS_MULTI_RESULTS, "CLIENT_PS_MULTI_RESULTS"),
         ?BCHECK(C,?CLIENT_PLUGIN_AUTH, "CLIENT_PLUGIN_AUTH"),
         ?BCHECK(C,?CLIENT_CONNECT_ATTRS, "CLIENT_CONNECT_ATTRS"),
         ?BCHECK(C,?CLIENT_PLUGIN_AUTH_LENENC_CLIENT_DATA, "CLIENT_PLUGIN_AUTH_LENENC_CLIENT_DATA"),
         ?BCHECK(C,?CLIENT_CAN_HANDLE_EXPIRED_PASSWORDS, "CLIENT_CAN_HANDLE_EXPIRED_PASSWORDS"),
         ?BCHECK(C,?CLIENT_SSL_VERIFY_SERVER_CERT, "CLIENT_SSL_VERIFY_SERVER_CERT"),
         ?BCHECK(C,?CLIENT_REMEMBER_OPTIONS, "CLIENT_REMEMBER_OPTIONS")
        ],
    string:join([ E || E <- L, length(E) > 0 ], ",");
caps(_) ->
    "?".

-spec flags(integer()) -> string().
flags(C)
  when is_integer(C) ->
    L = [
         ?BCHECK(C,?NOT_NULL_FLAG, "NOT_NULL_FLAG"),
         ?BCHECK(C,?PRI_KEY_FLAG, "PRI_KEY_FLAG"),
         ?BCHECK(C,?UNIQUE_KEY_FLAG, "UNIQUE_KEY_FLAG"),
         ?BCHECK(C,?MULTIPLE_KEY_FLAG, "MULTIPLE_KEY_FLAG"),
         ?BCHECK(C,?BLOB_FLAG, "BLOB_FLAG"),
         ?BCHECK(C,?UNSIGNED_FLAG, "UNSIGNED_FLAG"),
         ?BCHECK(C,?ZEROFILL_FLAG, "ZEROFILL_FLAG"),
         ?BCHECK(C,?BINARY_FLAG, "BINARY_FLAG"),
         ?BCHECK(C,?ENUM_FLAG, "ENUM_FLAG"),
         ?BCHECK(C,?AUTO_INCREMENT_FLAG, "AUTO_INCREMENT_FLAG"),
         ?BCHECK(C,?TIMESTAMP_FLAG, "TIMESTAMP_FLAG"),
         ?BCHECK(C,?SET_FLAG, "SET_FLAG"),
         ?BCHECK(C,?NO_DEFAULT_VALUE_FLAG, "NO_DEFAULT_VALUE_FLAG"),
         ?BCHECK(C,?ON_UPDATE_NOW_FLAG, "ON_UPDATE_NOW_FLAG"),
         ?BCHECK(C,?PART_KEY_FLAG, "PART_KEY_FLAG"),
         ?BCHECK(C,?GROUP_FLAG, "GROUP_FLAG"),
         ?BCHECK(C,?UNIQUE_FLAG, "UNIQUE_FLAG"),
         ?BCHECK(C,?BINCMP_FLAG, "BINCMP_FLAG"),
         ?BCHECK(C,?GET_FIXED_FIELDS_FLAG, "GET_FIXED_FIELDS_FLAG"),
         ?BCHECK(C,?FIELD_IN_PART_FUNC_FLAG, "FIELD_IN_PART_FUNC_FLAG")
        ],
    string:join([ E || E <- L, length(E) > 0 ], ",");
flags(_) ->
    "?".

-spec type(integer()) -> string().
type(T)
  when is_integer(T), T > 0 ->
    L = [
	 {?MYSQL_TYPE_DECIMAL, "MYSQL_TYPE_DECIMAL"},
	 {?MYSQL_TYPE_TINY, "MYSQL_TYPE_TINY"},
	 {?MYSQL_TYPE_SHORT, "MYSQL_TYPE_SHORT"},
	 {?MYSQL_TYPE_LONG, "MYSQL_TYPE_LONG"},
	 {?MYSQL_TYPE_FLOAT, "MYSQL_TYPE_FLOAT"},
	 {?MYSQL_TYPE_DOUBLE, "MYSQL_TYPE_DOUBLE"},
	 {?MYSQL_TYPE_NULL, "MYSQL_TYPE_NULL"},
	 {?MYSQL_TYPE_TIMESTAMP, "MYSQL_TYPE_TIMESTAMP"},
	 {?MYSQL_TYPE_LONGLONG, "MYSQL_TYPE_LONGLONG"},
	 {?MYSQL_TYPE_INT24, "MYSQL_TYPE_INT24"},
	 {?MYSQL_TYPE_DATE, "MYSQL_TYPE_DATE"},
	 {?MYSQL_TYPE_TIME, "MYSQL_TYPE_TIME"},
	 {?MYSQL_TYPE_DATETIME, "MYSQL_TYPE_DATETIME"},
	 {?MYSQL_TYPE_YEAR, "MYSQL_TYPE_YEAR"},
	 {?MYSQL_TYPE_NEWDATE, "MYSQL_TYPE_NEWDATE"},
	 {?MYSQL_TYPE_VARCHAR, "MYSQL_TYPE_VARCHAR"},
	 {?MYSQL_TYPE_BIT, "MYSQL_TYPE_BIT"},
	 {?MYSQL_TYPE_NEWDECIMAL, "MYSQL_TYPE_NEWDECIMAL"},
	 {?MYSQL_TYPE_ENUM, "MYSQL_TYPE_ENUM"},
	 {?MYSQL_TYPE_SET, "MYSQL_TYPE_SET"},
	 {?MYSQL_TYPE_TINY_BLOB, "MYSQL_TYPE_TINY_BLOB"},
	 {?MYSQL_TYPE_MEDIUM_BLOB, "MYSQL_TYPE_MEDIUM_BLOB"},
	 {?MYSQL_TYPE_LONG_BLOB, "MYSQL_TYPE_LONG_BLOB"},
	 {?MYSQL_TYPE_BLOB, "MYSQL_TYPE_BLOB"},
	 {?MYSQL_TYPE_VAR_STRING, "MYSQL_TYPE_VAR_STRING"},
	 {?MYSQL_TYPE_STRING, "MYSQL_TYPE_STRING"},
	 {?MYSQL_TYPE_GEOMETRY, "MYSQL_TYPE_GEOMETRY"}
	],
    proplists:get_value(T, L, "unknown");
type(_) ->
    "?".

-spec md5(binary()) -> binary().
md5(Binary)
  when is_binary(Binary) ->
    list_to_binary([ io_lib:format("~2.16.0b",[E]) || <<E>> <= crypto:md5(Binary) ]).
