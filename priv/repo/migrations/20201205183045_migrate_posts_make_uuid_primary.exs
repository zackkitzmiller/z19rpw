defmodule Z19rpw.Repo.Migrations.MigratePostsMakeUuidPrimary do
  @moduledoc """
  Rename UUID table
  """
  use Ecto.Migration

  def change do
    execute "ALTER TABLE posts DROP CONSTRAINT \"primary\";"
    execute "ALTER TABLE posts ADD CONSTRAINT \"primary\" PRIMARY KEY (uuid);"
  end
end
