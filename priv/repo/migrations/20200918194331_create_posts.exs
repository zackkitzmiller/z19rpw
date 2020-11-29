defmodule Z19rpw.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :author, :integer
      add :body, :text

      timestamps()
    end
  end
end
