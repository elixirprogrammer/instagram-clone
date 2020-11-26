# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :instagram,
  ecto_repos: [Instagram.Repo]

# Configures the endpoint
config :instagram, InstagramWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ygAfyFIbQtQQkagu+qnSDC91NlpYxpmzH2srYhwhlChhC3x0yarW9+o5Nq2+XDPn",
  render_errors: [view: InstagramWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Instagram.PubSub,
  live_view: [signing_salt: "FTgZHMqD"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
