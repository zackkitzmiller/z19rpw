use Mix.Config

config :z19rpw, Z19rpw.Repo,
  username: "root",
  password: "",
  database: "defaultdb",
  hostname: "localhost",
  port: 26257,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :z19rpw, Z19rpwWeb.Endpoint,
  url: [host: "http://z19rpw.stag"],
  http: [port: String.to_integer(System.get_env("PORT") || "4000"],
  debug_errors: true,
  code_reloader: false,
  check_origin: false

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :z19rpw, Z19rpwWeb.Endpoint, server: true
