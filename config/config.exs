# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :z19rpw,
  ecto_repos: [Z19rpw.Repo],
  generators: [binary_id: true]

config :z19rpw, Z19rpw.Repo,
  migration_primary_key: [name: :id, type: :binary_id],
  migration_foreign_key: [column: :id, type: :binary_id]

config :z19rpw, env: Mix.env()

# Configures the endpoint
config :z19rpw, Z19rpwWeb.Endpoint,
  url: [host: "127.0.0.1"],
  secret_key_base: "QM/B52O3HH0VhIN+6ENj1rh/kkBP3/LQdC/zNhTTicdnsQphALeKyFVIW3/KmCiR",
  render_errors: [view: Z19rpwWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Z19rpw.PubSub,
  live_view: [signing_salt: "EZFfpWSw"],
  instrumenters: [NewRelic.Phoenix.Instrumenter]

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

config :memcachir,
  hosts: "localhost",
  coder: {Memcache.Coder.Erlang, []}

config :new_relic_agent,
  app_name: "z19r",
  license_key: "a88f416e4194549112fdb31f4fd650193f59NRAL"

config :ex_aws, :s3,
  scheme: "https://",
  host: "contentdeliverynetwork.z19r.pw",
  port: 443
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
