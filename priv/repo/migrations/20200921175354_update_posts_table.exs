defmodule Z19rpw.Repo.Migrations.UpdatePostsTable do
  use Ecto.Migration

  def change do
    alter table("posts") do
      add :status, :string, default: "draft"
      add :slug, :string
    end
  end
end
