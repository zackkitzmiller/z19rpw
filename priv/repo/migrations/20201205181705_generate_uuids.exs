defmodule Z19rpw.Repo.Migrations.GenerateUuidsAndMigrate do
  @moduledoc """
  Actually run the database imgration
  """
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    Ecto.Adapters.SQL.query!(
      Z19rpw.Repo,
      "UPDATE posts SET uuid = gen_random_uuid();"
    )

    flush()

    Ecto.Adapters.SQL.query!(
      Z19rpw.Repo,
      "ALTER TABLE posts ALTER COLUMN uuid SET NOT NULL;"
    )

    flush()

    Ecto.Adapters.SQL.query!(
      Z19rpw.Repo,
      "ALTER TABLE posts ALTER COLUMN uuid SET DEFAULT gen_random_uuid();"
    )
  end
end
