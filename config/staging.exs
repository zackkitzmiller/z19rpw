use Mix.Config

config :z19rpw, Z19rpw.Repo,
  username: "app",
  password: "",
  database: "z19rpw_staging",
  port: 26257,
  hostname: "cockroachdb.default.svc.cluster.local",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :z19rpw, Z19rpwWeb.Endpoint,
  url: [host: "z19rpw.stag", port: 80],
  http: [port: "4000"],
  debug_errors: true,
  code_reloader: false,
  check_origin: false

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
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger, level: :debug
config :phoenix, :stacktrace_depth, 20
config :z19rpw, Z19rpwWeb.Endpoint, server: true
