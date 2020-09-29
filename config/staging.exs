use Mix.Config

config :z19rpw, Z19rpw.Repo,
  username: "app",
  password: "",
  database: "z19rpw_staging",
  hostname: "cockroachdb-public.default.svc.cluster.local",
  port: 26257,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :z19rpw, Z19rpwWeb.Endpoint,
  url: [host: "z19rpw.stag", port: 80],
  http: [port: "4000"],
  debug_errors: true,
  code_reloader: false,
  check_origin: false

config :logger, :console, format: "[$level] $message\n"
config :logger, level: :debug
config :phoenix, :stacktrace_depth, 20
config :z19rpw, Z19rpwWeb.Endpoint, server: true
