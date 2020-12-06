defmodule Z19rpw.Repo.Migrations.CreateLikes do
  @moduledoc """
  Migration for adding likes table. This migration relies on Posts and Users
  migrating to a UUID for a primary key.
  """
  use Ecto.Migration

  def change do
    create table(:likes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post_id, references(:posts, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:likes, [:post_id])
    create index(:likes, [:user_id])
  end
end
