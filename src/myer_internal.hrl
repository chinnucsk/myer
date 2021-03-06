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

-include_lib("myer/include/myer.hrl").

%% == ~/include/mysql_com.h ==

%% -- define --
-define(SERVER_STATUS_IN_TRANS,                 (1 bsl  0)).
-define(SERVER_STATUS_AUTOCOMMIT,               (1 bsl  1)).
-define(SERVER_MORE_RESULTS_EXISTS,             (1 bsl  3)).
-define(SERVER_QUERY_NO_GOOD_INDEX_USED,        (1 bsl  4)).
-define(SERVER_QUERY_NO_INDEX_USED,             (1 bsl  5)).
-define(SERVER_STATUS_CURSOR_EXISTS,            (1 bsl  6)).
-define(SERVER_STATUS_LAST_ROW_SENT,            (1 bsl  7)).
-define(SERVER_STATUS_DB_DROPPED,               (1 bsl  8)).
-define(SERVER_STATUS_NO_BACKSLASH_ESCAPES,     (1 bsl  9)).
-define(SERVER_STATUS_METADATA_CHANGED,         (1 bsl 10)).
-define(SERVER_QUERY_WAS_SLOW,                  (1 bsl 11)).
-define(SERVER_PS_OUT_PARAMS,                   (1 bsl 12)).
-define(SERVER_STATUS_IN_TRANS_READONLY,        (1 bsl 13)).

-define(CLIENT_LONG_PASSWORD,                   (1 bsl  0)).
-define(CLIENT_FOUND_ROWS,                      (1 bsl  1)).
-define(CLIENT_LONG_FLAG,                       (1 bsl  2)).
-define(CLIENT_CONNECT_WITH_DB,                 (1 bsl  3)).
-define(CLIENT_NO_SCHEMA,                       (1 bsl  4)).
-define(CLIENT_COMPRESS,                        (1 bsl  5)).
-define(CLIENT_ODBC,                            (1 bsl  6)).
-define(CLIENT_LOCAL_FILES,                     (1 bsl  7)).
-define(CLIENT_IGNORE_SPACE,                    (1 bsl  8)).
-define(CLIENT_PROTOCOL_41,                     (1 bsl  9)).
-define(CLIENT_INTERACTIVE,                     (1 bsl 10)).
-define(CLIENT_SSL,                             (1 bsl 11)).
-define(CLIENT_IGNORE_SIGPIPE,                  (1 bsl 12)).
-define(CLIENT_TRANSACTIONS,                    (1 bsl 13)).
-define(CLIENT_RESERVED,                        (1 bsl 14)).
-define(CLIENT_SECURE_CONNECTION,               (1 bsl 15)).
-define(CLIENT_MULTI_STATEMENTS,                (1 bsl 16)).
-define(CLIENT_MULTI_RESULTS,                   (1 bsl 17)).
-define(CLIENT_PS_MULTI_RESULTS,                (1 bsl 18)).
-define(CLIENT_PLUGIN_AUTH,                     (1 bsl 19)).
-define(CLIENT_CONNECT_ATTRS,                   (1 bsl 20)).
-define(CLIENT_PLUGIN_AUTH_LENENC_CLIENT_DATA,  (1 bsl 21)).
-define(CLIENT_CAN_HANDLE_EXPIRED_PASSWORDS,    (1 bsl 22)).
-define(CLIENT_SSL_VERIFY_SERVER_CERT,          (1 bsl 30)).
-define(CLIENT_REMEMBER_OPTIONS,                (1 bsl 31)).

%% -- enum: enum_server_command --
%%efine(COM_SLEEP,                0). % internal
-define(COM_QUIT,                 1).
-define(COM_INIT_DB,              2).
-define(COM_QUERY,                3).
%%efine(COM_FIELD_LIST,           4).
%%efine(COM_CREATE_DB,            5). % deprecated
%%efine(COM_DROP_DB,              6). % deprecated
-define(COM_REFRESH,              7).
%%efine(COM_SHUTDOWN,             8).
-define(COM_STATISTICS,           9).
%%efine(COM_PROCESS_INFO,        10).
%%efine(COM_CONNECT,             11). % internal
%%efine(COM_PROCESS_KILL,        12).
%%efine(COM_DEBUG,               13).
-define(COM_PING,                14).
%%efine(COM_TIME,                15). % internal
%%efine(COM_DELAYED_INSERT,      16). % internal
%%efine(COM_CHANGE_USER,         17).
%%efine(COM_BINLOG_DUMP,         18). % internal
%%efine(COM_TABLE_DUMP,          19). % internal
%%efine(COM_CONNECT_OUT,         20). % internal
%%efine(COM_REGISTER_SLAVE,      21). % internal?
-define(COM_STMT_PREPARE,        22).
-define(COM_STMT_EXECUTE,        23).
-define(COM_STMT_SEND_LONG_DATA, 24).
-define(COM_STMT_CLOSE,          25).
-define(COM_STMT_RESET,          26).
%%efine(COM_SET_OPTION,          27).
-define(COM_STMT_FETCH,          28).

%% -- enum: enum_field_types --
-define(MYSQL_TYPE_DECIMAL,       0). %
-define(MYSQL_TYPE_TINY,          1). % TINYINT
-define(MYSQL_TYPE_SHORT,         2). % SMALLINT
-define(MYSQL_TYPE_LONG,          3). % INT,INTEGER
-define(MYSQL_TYPE_FLOAT,         4). % FLOAT
-define(MYSQL_TYPE_DOUBLE,        5). % DOUBLE,REAL
-define(MYSQL_TYPE_NULL,          6). %
-define(MYSQL_TYPE_TIMESTAMP,     7). % TIMESTAMP
-define(MYSQL_TYPE_LONGLONG,      8). % BIGINT
-define(MYSQL_TYPE_INT24,         9). % MEDIUMINT
-define(MYSQL_TYPE_DATE,         10). % DATE
-define(MYSQL_TYPE_TIME,         11). % TIME
-define(MYSQL_TYPE_DATETIME,     12). % DATETIME
-define(MYSQL_TYPE_YEAR,         13). % YEAR
-define(MYSQL_TYPE_NEWDATE,      14). %
-define(MYSQL_TYPE_VARCHAR,      15). %
-define(MYSQL_TYPE_BIT,          16). % BIT
-define(MYSQL_TYPE_TIMESTAMP2,   17). % internal
-define(MYSQL_TYPE_DATETIME2,    18). % internal
-define(MYSQL_TYPE_TIME2,        19). % internal
-define(MYSQL_TYPE_NEWDECIMAL,  246). % DECIMAL,NUMERIC
-define(MYSQL_TYPE_ENUM,        247). %
-define(MYSQL_TYPE_SET,         248). %
-define(MYSQL_TYPE_TINY_BLOB,   249). %
-define(MYSQL_TYPE_MEDIUM_BLOB, 250). %
-define(MYSQL_TYPE_LONG_BLOB,   251). %
-define(MYSQL_TYPE_BLOB,        252). % *BLOB,*TEXT
-define(MYSQL_TYPE_VAR_STRING,  253). % VARCHAR,VARBINARY,ENUM,SET
-define(MYSQL_TYPE_STRING,      254). % CHAR,BINARY
-define(MYSQL_TYPE_GEOMETRY,    255). %

%% -- --
-define(ISSET(A,B), A band B =/= 0).

%% == record ==

-record(result, {
	  affected_rows :: non_neg_integer(),
	  insert_id :: non_neg_integer(),
	  status :: integer(),
	  warning_count :: non_neg_integer(),
	  message :: binary()
	 }).

-type(result() :: #result{}).

-record(reason, {
	  errno :: non_neg_integer(),
	  state :: binary(),
	  message :: binary()
	 }).

-type(reason() :: #reason{}).

-record(protocol, {
          handle :: tuple(),
          maxlength :: non_neg_integer(),
          compress :: boolean(),
          version :: [integer()],
          seed :: binary(),
          caps :: integer(),
          charset :: non_neg_integer(),
          plugin :: binary()
         }).

-type(protocol() :: #protocol{}).

-record(prepare, {
	  stmt_id :: non_neg_integer(),
	  field_count :: non_neg_integer(),
	  fields :: list(),
	  param_count :: non_neg_integer(),
	  params :: list(),
	  warning_count :: non_neg_integer(),
          flags :: non_neg_integer(),
          prefetch_rows :: non_neg_integer(),
          result :: tuple(),
          execute :: non_neg_integer()
	 }).

-type(prepare() :: #prepare{}).


-type(hostname() :: inet:hostname()).
-type(ip_address() :: inet:ip_address()).
-type(port_number() :: inet:port_number()).
-type(property() :: proplists:property()).
-type(socket() :: port()).                      % gen_tcp:socket()
