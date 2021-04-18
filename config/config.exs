# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :crowdsourcing,
  ecto_repos: [Crowdsourcing.Repo]

# Configures the endpoint
config :crowdsourcing, CrowdsourcingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M1SEHuTKXsR0OqTacn9NL+FLhKjvBaresZLEbtiDo1DhowMpCLhw3h+ML1z5mkZf",
  render_errors: [view: CrowdsourcingWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Crowdsourcing.PubSub,
  live_view: [signing_salt: "MYfrzBS1"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
