-module(erlzma).

-export([compress/1, compress/2, decompress/1]).

-export([load/0]).
-on_load(load/0).

-type level() :: 1..9.

-spec compress(binary()) ->
  binary().
compress(Data) ->
  compress(Data, 5).

-spec compress(binary(), level()) ->
  binary().
compress(_Data, _Level) ->
  not_loaded(?LINE).

-spec decompress(binary()) ->
  binary().
decompress(_Data) ->
  not_loaded(?LINE).

%%

load() ->
  erlang:load_nif(filename:join(priv(), "liberlzma"), none).

not_loaded(Line) ->
  erlang:nif_error({error, {not_loaded, [{module, ?MODULE}, {line, Line}]}}).

priv() ->
  case code:priv_dir(?MODULE) of
    {error, _} ->
      EbinDir = filename:dirname(code:which(?MODULE)),
      AppPath = filename:dirname(EbinDir),
      filename:join(AppPath, "priv");
    Path ->
      Path
  end.
