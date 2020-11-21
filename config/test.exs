use Mix.Config

config :z19rpw, Z19rpw.Repo,
  username: System.get_env("POSTGRES_USER", "zackkitzmiller"),
  password: System.get_env("POSTGRES_PASSWORD", ""),
  database: "z19rpw_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  port: System.get_env("POSTGRES_PORT", "5432"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :z19rpw, Z19rpwWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
