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

config :ueberauth, Ueberauth,
  base_path: "/api/auth",
  providers: [
    identity: {Ueberauth.Strategy.Identity, [
      callback_methods: ["POST"],
      nickname_field: :username,
      param_nesting: "user",
      uid_field: :username
    ]}
  ]

config :z19rpw, Z19rpw.Guardian,
  issuer: "Z19rpw",
  secret_key: "9M0XLa4Mu8HIf8heiPYCAheu0LGg24K2oWzVj4Or7KNa+2sUaJUZtvMMCIOwzfL5",
  permissions: %{
    default: [:read_users, :write_users]
  }

config :z19rpw, Z19rpwWeb.Plug.AuthAccessPipeline,
  module: Z19rpw.Guardian,
  error_handler: Z19rpwWeb.Plug.AuthErrorHandler


config :libcluster, topologies: [
    z19rpw: [
      strategy: Elixir.Cluster.Strategy.Gossip]]
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
