defmodule Z19rpw.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :author, :integer, default: 1
    field :body, :string
    field :title, :string, default: ""
    field :status, :string, default: "active"
    field :slug, :string, default: ""

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> generate_slug()
  end

  def generate_slug(changeset) do
    title = get_field(changeset, :title)

    slug =
      title
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9\s-]/, "")
      |> String.replace(~r/(\s|-)+/, "-")

    put_change(changeset, :slug, slug)
  end
end
