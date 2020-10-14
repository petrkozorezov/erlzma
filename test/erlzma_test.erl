-module(erlzma_test).

-include_lib("eunit/include/eunit.hrl").

-define(PLAIN, <<
  "Why I Must Write GNU"

  "I consider that the Golden Rule requires that if I like a program I must share it with other people who like it."
  "Software sellers want to divide the users and conquer them, making each user agree not to share with others."
  "I refuse to break solidarity with other users in this way."
  "I cannot in good conscience sign a nondisclosure agreement or a software license agreement."
  "For years I worked within the Artificial Intelligence Lab to resist such tendencies and other inhospitalities,"
  "but eventually they had gone too far: I could not remain in an institution where such things are done for me against my will."
>>).

comress_test() ->
  Compressed = erlzma:compress(?PLAIN, 4),
  Decompressed = erlzma:decompress(Compressed),
  ?assertEqual(Decompressed, ?PLAIN).

decompress_error() ->
  ?assertMatch(todo, erlzma:decompress(?PLAIN)).
