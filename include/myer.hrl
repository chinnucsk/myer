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

%% == ~/include/mysql_com.h ==

%% -- define --
-define(NOT_NULL_FLAG,                          (1 bsl  0)).
-define(PRI_KEY_FLAG,                           (1 bsl  1)).
-define(UNIQUE_KEY_FLAG,                        (1 bsl  2)).
-define(MULTIPLE_KEY_FLAG,                      (1 bsl  3)).
-define(BLOB_FLAG,                              (1 bsl  4)).
-define(UNSIGNED_FLAG,                          (1 bsl  5)).
-define(ZEROFILL_FLAG,                          (1 bsl  6)).
-define(BINARY_FLAG,                            (1 bsl  7)).
-define(ENUM_FLAG,                              (1 bsl  8)).
-define(AUTO_INCREMENT_FLAG,                    (1 bsl  9)).
-define(TIMESTAMP_FLAG,                         (1 bsl 10)).
-define(SET_FLAG,                               (1 bsl 11)).
-define(NO_DEFAULT_VALUE_FLAG,                  (1 bsl 12)).
-define(ON_UPDATE_NOW_FLAG,                     (1 bsl 13)).
%%efine(NUM_FLAG,                               (1 bsl 15)).
-define(PART_KEY_FLAG,                          (1 bsl 14)).
-define(GROUP_FLAG,                             (1 bsl 15)).
-define(UNIQUE_FLAG,                            (1 bsl 16)).
-define(BINCMP_FLAG,                            (1 bsl 17)).
-define(GET_FIXED_FIELDS_FLAG,                  (1 bsl 18)).
-define(FIELD_IN_PART_FUNC_FLAG,                (1 bsl 19)).

-define(REFRESH_GRANT,                          (1 bsl  0)).
-define(REFRESH_LOG,                            (1 bsl  1)).
-define(REFRESH_TABLES,                         (1 bsl  2)).
-define(REFRESH_HOSTS,                          (1 bsl  3)).
-define(REFRESH_STATUS,                         (1 bsl  4)).
-define(REFRESH_THREADS,                        (1 bsl  5)).
-define(REFRESH_SLAVE,                          (1 bsl  6)).
-define(REFRESH_MASTER,                         (1 bsl  7)).
-define(REFRESH_ERROR_LOG,                      (1 bsl  8)).
-define(REFRESH_ENGINE_LOG,                     (1 bsl  9)).
-define(REFRESH_BINARY_LOG,                     (1 bsl 10)).
-define(REFRESH_RELAY_LOG,                      (1 bsl 11)).
-define(REFRESH_GENERAL_LOG,                    (1 bsl 12)).
-define(REFRESH_SLOW_LOG,                       (1 bsl 13)).

%% -- enum: enum_cursor_type --
-define(CURSOR_TYPE_NO_CURSOR,  0).
-define(CURSOR_TYPE_READ_ONLY,  1).
%%efine(CURSOR_TYPE_FOR_UPDATE, 2).
%%efine(CURSOR_TYPE_SCROLLABLE, 4).

%% == ~/include/mysql.h ==

%% -- enum: enum_stmt_attr_type --
%%efine(STMT_ATTR_UPDATE_MAX_LENGTH, 0).
-define(STMT_ATTR_CURSOR_TYPE,       1).
-define(STMT_ATTR_PREFETCH_ROWS,     2).

%% == ~/strings/* ==

%% @see "SELECT * FROM information_schema.collations ORDER BY id"

%% -- ~/strings/ctype-binary.c --
-define(CHARSET_binary,                    63). % default?
%% -- ~/strings/ctype-latin1.c --
-define(CHARSET_latin1_swedish_ci,          8).
-define(CHARSET_latin1_bin,                47).
%% -- ~/strings/ctype-utf8.c --
-define(CHARSET_utf8_general_ci,           33).
-define(CHARSET_utf8_general_mysql500_ci, 223).
-define(CHARSET_utf8_bin,                  83).
%% -- ~/strings/ctype-ucs2.c --
-define(CHARSET_utf16_general_ci,          54).
-define(CHARSET_utf16_bin,                 55).
%%efine(CHARSET_utf16le_general_ci,        56). > 5.6
%%efine(CHARSET_utf16le_bin,               62). > 5.6
-define(CHARSET_utf32_general_ci,          60).
-define(CHARSET_utf32_bin,                 61).

%% == record ==

-record(field, {
	  catalog :: binary(),
	  db :: binary(),
          table :: binary(),
	  org_table :: binary(),
          name :: binary(),
	  org_name :: binary(),
	  charsetnr :: non_neg_integer(),
          length :: non_neg_integer(),
	  type :: integer(),
          flags :: integer(),
          decimals :: non_neg_integer()
	 }).

-type(field() :: #field{}).
