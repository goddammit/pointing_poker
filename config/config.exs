# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pointing_poker,
  ecto_repos: [PointingPoker.Repo]

# Configures the endpoint
config :pointing_poker, PointingPokerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GpeSfQgy2HTT/oss4fbRg3NruesyAeg1Rb2rYkpFJNlLrCn18I2moMV5wDY8EqzM",
  render_errors: [view: PointingPokerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PointingPoker.PubSub,
  live_view: [signing_salt: "eRi86UVl"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
