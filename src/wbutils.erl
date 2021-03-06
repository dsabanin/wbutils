%%%-------------------------------------------------------------------
%%% @author dsabanin
%%% @copyright (C) 2014, Wildbit, LLC
%%% @doc
%%%
%%% @end
%%% Created : 17. Jun 2014 12:22
%%%-------------------------------------------------------------------
-module(wbutils).
-author("dsabanin").

-define(TMP, "/tmp").

%% API
-export([epoch_now_utc/0,
         create_tmp_dir/0,
         create_tmp_dir/1,
         random_uuid/0,
         delete_dir/1,
         md5_hex/1,
         template/2,
         binary_template/2,
         with_temp_dir/2]).

-spec epoch_now_utc() -> integer().
epoch_now_utc() ->
  {M, S, _} = now(),
  M*1000000 + S.

-spec create_tmp_dir() -> {ok, string()}.
create_tmp_dir() ->
  create_tmp_dir("wbutils").

-spec random_uuid() -> string().
random_uuid() ->
  uuid:to_string(uuid:uuid4()).

-spec create_tmp_dir(Base :: string()) -> {ok, string()}.
create_tmp_dir(Base) ->
  UUID = random_uuid(),
  Path = filename:join([?TMP, Base ++ UUID]),
  ok = ec_file:mkdir_p(Path),
  {ok, Path}.

-spec delete_dir(Path :: string()) -> {error, forbidden} | {ok, Path :: string()}.
delete_dir("/") ->
  {error, forbidden};

delete_dir(Path) ->
  ok = ec_file:remove(Path, [recursive]),
  {ok, Path}.

-spec md5_hex(Content :: binary() | string()) -> string().
md5_hex(Content) ->
  ec_file:md5sum(Content).

-spec template(Tpl :: string(), Vals :: proplists:proplist()) -> string().
template(Tpl, Vals) ->
  Ctx = dict:from_list(Vals),
  mustache:render(Tpl, Ctx).

-spec binary_template(Tpl :: string(), Vals :: proplists:proplist()) -> binary().
binary_template(Tpl, Vals) ->
  erlang:iolist_to_binary(template(Tpl, Vals)).

-spec with_temp_dir(Scope :: string(), Fn :: fun()) -> any().
with_temp_dir(Scope, Fn) ->
  {ok, TmpPath} = create_tmp_dir(Scope),
  try
    Fn(TmpPath)
  after
    delete_dir(TmpPath)
  end.
