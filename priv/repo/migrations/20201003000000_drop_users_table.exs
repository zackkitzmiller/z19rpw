defmodule Z19rpw.Repo.Migrations.DropUsersTable do
  use Ecto.Migration

  def change do
    drop table("users")
  end
end
