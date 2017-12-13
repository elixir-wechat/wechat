# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :wechat, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:wechat, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
config :wechat, Wechat,
  appid: {:system, "WECHAT_APPID"},
  secret: {:system, "WECHAT_SECRET"},
  token: {:system, "WECHAT_TOKEN"},
  encoding_aes_key: {:system, "WECHAT_ENCODING_AES_KEY"}

# To define your own method to fetch the access token, you can provide
# a `access_token_fetcher` here. This is useful when you are sharing
# access_token among multiple applications and you pull access_token
# from a center storage or other service.
#
# The syntax is: {Module, method, [args]}
#
#     config :wechat, Wechat,
#       access_token_fetcher: {Wechat.API, :access_token, []},
#
#       # set refresh interval
#       access_token_refresh_interval: :timer.minutes(30)
