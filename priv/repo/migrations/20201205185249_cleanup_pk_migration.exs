defmodule Z19rpw.Repo.Migrations.CleanupPkMigration do
  @moduledoc """
  migration to move the columns around
  """
  use Ecto.Migration
  require Logger

  def change do
    Logger.info("waiting for CockroachDB to finish PK changes...")
    :timer.sleep(:timer.seconds(5))
    Logger.info("ok..")
    alter table(:posts) do
      remove(:id)
    end
  end

end
