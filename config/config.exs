# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api,
  ecto_repos: [Api.Repo]

# Configures the endpoint
config :api, Api.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ev6l6ZEIopFoesbTDEMOXLBxNMCIdHed4+4BqBU1n0bvl1fHh1mm9heFcf90lWiE",
  render_errors: [view: Api.ErrorView, accepts: ~w(json)],
  pubsub: [name: Api.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Guardian config
config :guardian, Guardian,
 hooks: GuardianDb,
 allowed_algos: ["HS512"],
 verify_module: Guardian.JWT,
 issuer: "Api",
 ttl: { 7, :days },
 verify_issuer: true,
 secret_key: %{
   "k" => "3NmPoChAVHDduHkJ4d9xZk8eJTjxAYjZBvbA4VuAj1YTNFCj8JCt4vbvZReWcqkj",
   "kty" => "oct"
 },
 serializer: Api.GuardianSerializer

config :guardian_db, GuardianDb,
 repo: Api.Repo,
 sweep_interval: 1440 # 24hx60min=1440 minutes (once a day)

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
