defmodule Z19rpw.Blog.Post.Like do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :integer
  schema "likes" do
    # field :post_id, :integer
    # field :user_id, :integer

    belongs_to :post, Z19rpw.Blog.Post
    belongs_to :user, Z19rpw.Users.User

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [])
    |> validate_required([])
  end
end
