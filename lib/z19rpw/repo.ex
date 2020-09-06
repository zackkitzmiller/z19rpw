defmodule Z19rpw.Repo do
  use Ecto.Repo,
    otp_app: :z19rpw,
    adapter: Ecto.Adapters.Postgres
end
