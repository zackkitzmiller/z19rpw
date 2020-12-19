defmodule Z19rpw.Blog.Post.Like do
  @moduledoc false
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "likes" do
    belongs_to :post, Z19rpw.Blog.Post
    belongs_to :user, Z19rpw.Users.User

    timestamps()
  end
end
