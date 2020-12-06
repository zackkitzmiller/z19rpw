defmodule Z19rpw.Repo.Migrations.DropUsers do
  @moduledoc """
  recreate the barely used users table to add a binary id support. brutalist,
  but worth the struggles of actually recreating it.
  """
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    drop table("users")

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string, null: false
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
