defmodule Z19rpw.Users.User do
  @moduledoc false

  use Ecto.Schema
  use Pow.Ecto.Schema

  use Pow.Extension.Ecto.Schema,
    extensions: [PowEmailConfirmation, PowResetPassword]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    pow_user_fields()

    has_many :posts, Z19rpw.Blog.Post, on_delete: :delete_all
    has_many :likes, Z19rpw.Blog.Post.Like, on_delete: :delete_all

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end
end
