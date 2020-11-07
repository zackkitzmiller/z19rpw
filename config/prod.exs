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

config :sentry,
  dsn: "https://398fd199b5e749159ed2ad90687a3123@o473296.ingest.sentry.io/5508084",
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [:prod]

config :logger,
  backends: [:console, Sentry.LoggerBackend]

import_config "prod.secret.exs"
