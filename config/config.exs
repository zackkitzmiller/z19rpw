# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :z19rpw,
  ecto_repos: [Z19rpw.Repo]

# Configures the endpoint
config :z19rpw, Z19rpwWeb.Endpoint,
  url: [host: "127.0.0.1"],
  secret_key_base: "QM/B52O3HH0VhIN+6ENj1rh/kkBP3/LQdC/zNhTTicdnsQphALeKyFVIW3/KmCiR",
  render_errors: [view: Z19rpwWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Z19rpw.PubSub,
  live_view: [signing_salt: "EZFfpWSw"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :libcluster,
  topologies: [
    z19rpw: [
      strategy: Elixir.Cluster.Strategy.Gossip
    ]
  ]

config :z19rpw, :pow,
  user: Z19rpw.Users.User,
  repo: Z19rpw.Repo,
  web_module: Z19rpwWeb,
  cache_store_backend: Pow.Store.Backend.MnesiaCache,
  entensions: PowPersistentSession

config :mnesia, dir: to_charlist(File.cwd!()) ++ '/priv/mnesia'

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
