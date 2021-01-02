defmodule Z19rpw.Blog.Post do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Z19rpw.{Repo, Blog.Post}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :body, :string
    field :title, :string, default: ""
    field :status, :string, default: "active"
    field :slug, :string, default: ""

    belongs_to :user, Z19rpw.Users.User
    has_many :likes, Z19rpw.Blog.Post.Like, on_delete: :delete_all

    timestamps()
  end

  @spec changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :title, :slug])
    |> generate_slug
    |> validate_required([:body, :slug, :title])
  end

  def generate_slug(changeset) do
    case get_change(changeset, :title) |> slug_title do
      :error ->
        changeset

      {:ok, slug} ->
        put_change(changeset, :slug, slug)
    end
  end

  def slug_title(nil), do: :error

  def slug_title(title) do
    case Slug.slugify(title) do
      nil ->
        :error

      slug ->
        case Repo.one(from p in Post, where: p.slug == ^slug) do
          %Post{} ->
            slug =
              slug <>
                "-" <> (:crypto.strong_rand_bytes(6) |> Base.url_encode64() |> binary_part(0, 6))

            {:ok, slug |> Slug.slugify()}

          nil ->
            {:ok, slug}
        end
    end
  end
end
