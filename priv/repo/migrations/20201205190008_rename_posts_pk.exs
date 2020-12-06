defmodule Z19rpw.Repo.Migrations.RenamePostsPk do
  @moduledoc """
  Finally rename the column from UUID to ID
  """
  use Ecto.Migration

  def change do
    rename(table(:posts), :uuid, to: :id)
  end
end
