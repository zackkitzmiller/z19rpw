defmodule Z19rpw.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :author, :integer, default: 1
    field :body, :string
    field :title, :string
    field :status, :string, default: "draft"
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
