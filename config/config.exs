import Config

config :todo, http_port: 5454
config :todo, todo_item_expiry: :timer.minutes(1)
config :todo, :database, pool_size: 3, folder: "./persist"

import_config "#{Mix.env()}.exs"
