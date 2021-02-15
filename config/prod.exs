use Mix.Config

config :z19rpw, Z19rpwWeb.Endpoint,
  url: [host: "z19r.pw", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  debug_errors: false,
  code_reloader: false

config :logger, level: :debug

config :libcluster,
  topologies: [
    z19rpw: [
      strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: "z19rpw-headless-service",
        application_name: "z19rpw",
        polling_interval: 10_000
      ]
    ]
  ],
  debug: true

config :logger,
  backends: [:console, Sentry.LoggerBackend]

import_config "prod.secret.exs"
