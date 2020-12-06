defmodule Z19rpw.Repo.Migrations.AddUuidToPosts do
  @moduledoc """
  Add the new UUID column for our int -> uuid migration
  """
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :uuid, :binary_id
    end
  end
end
