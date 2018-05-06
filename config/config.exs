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
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Api",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "UZ2IbrDisIedds3yW6wGN2v8XTkeZ6yXyywWP+4ajPJK4ugejf8Xa3MsZYJddzkj", # Insert previously generated secret key!
  serializer: Api.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
