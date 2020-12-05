defmodule Z19rpw.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post_id, references(:posts, on_delete: :nothing, type: :integer)
      add :user_id, references(:users, on_delete: :nothing, type: :integer)

      timestamps()
    end

    create index(:likes, [:post_id])
    create index(:likes, [:user_id])
  end
end
