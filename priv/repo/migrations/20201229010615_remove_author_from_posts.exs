defmodule Z19rpw.Repo.Migrations.RemoveAuthorFromPosts do
  @moduledoc """
  remove author column
  """
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :author
    end
  end
end
