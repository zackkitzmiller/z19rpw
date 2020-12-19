defmodule Z19rpw.Blog do
  @moduledoc false
  import Ecto.Query, warn: false

  use Z19rpw.Cachier

  alias Z19rpw.Repo
  alias Z19rpw.Blog.Post

  require Logger

  @decorate write_through()
  def list_posts do
    scoped_posts("2020")
  end

  @decorate write_through()
  def list_posts(%{"year" => year}) do
    scoped_posts(year)
  end

  def get_post!(id), do: Repo.get!(Post, id) |> Repo.preload(:likes)

  @decorate write_through()
  def get_post_by_slug!(slug) do
    Repo.one!(from p in Post, where: p.slug == ^slug) |> Repo.preload(:likes)
  end

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:post_created)
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
    |> broadcast(:post_updated)
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
    |> broadcast(:post_deleted)

    Memcachir.flush()
    {:ok, post}
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  @decorate write_through()
  def publication_years do
    Post
    |> select(fragment("extract(year from inserted_at) as year"))
    |> where([p], p.status == "active")
    |> group_by(fragment("year"))
    |> having(count("id") > 0)
    |> Repo.all()
    |> Enum.sort()
    |> Enum.map(&floor/1)
    |> Enum.map(&to_string/1)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Z19rpw.PubSub, "blog")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(Z19rpw.PubSub, "blog", {event, post})
    Memcachir.flush()
    {:ok, post}
  end

  defp scoped_posts(year) do
    Repo.all(
      from p in Post,
        where:
          fragment(
            "status != 'draft' and extract(year from inserted_at)::text = ?",
            ^year
          ),
        order_by: [desc: p.inserted_at]
    )
    |> Repo.preload(:likes)
  end
end
