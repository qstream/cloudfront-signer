use Mix.Config

config :cloudfront_signer, :json_codec, Poison

import_config "#{Mix.env}.exs"
