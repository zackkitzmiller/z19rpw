defmodule Z19rpw.Blog do
  @moduledoc false
  import Ecto.Query, warn: false

  use Z19rpw.Cachier

  alias Z19rpw.Repo
  alias Z19rpw.Blog.{Post, Post.Like}
  alias Z19rpw.Users.User

  require Logger

  @decorate write_through()
  def list_posts do
    scoped_posts(Integer.to_string(DateTime.utc_now().year))
  end

  @decorate write_through()
  def list_posts(%{"year" => year}) do
    scoped_posts(year)
  end

  def get_post!(id), do: Repo.get!(Post, id) |> Repo.preload([:likes, :user])

  @decorate write_through()
  def get_post_by_slug!(slug) do
    Repo.one!(from p in Post, where: p.slug == ^slug) |> Repo.preload([:likes, :user])
  end

  def create_post(attrs \\ %{}, %User{} = current_user) do
    %Post{:user => current_user}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:post_created)
  end

  def update_post(%Post{}, nil), do: {:error, :unauthorized}

  def update_post(%Post{} = post, attrs, %User{} = current_user) do
    case post.user_id == current_user.id do
      false ->
        {:error, :unauthorized}

      _ ->
        post
        |> Post.changeset(attrs)
        |> Repo.update()
        |> broadcast(:post_updated)
    end
  end

  def delete_post(%Post{}, nil), do: {:error, :unauthorized}

  def delete_post(%Post{} = post, %User{} = current_user) do
    case post.user_id == current_user.id do
      false ->
        {:error, :unauthorized}

      _ ->
        Repo.delete(post)
        |> broadcast(:post_deleted)
    end
  end

  def like_post(%Post{} = post, %User{} = user) do
    case Repo.one(
           from l in Like,
             where: l.user_id == ^user.id and l.post_id == ^post.id
         ) do
      nil ->
        Repo.insert!(%Like{post: post, user: user})

      %Like{} = like ->
        Repo.delete!(like)
    end

    broadcast({:ok, post |> Repo.preload(:likes, force: true)}, :post_updated)
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
    Phoenix.PubSub.broadcast(Z19rpw.PubSub, "blog", {event, post |> Repo.preload(:likes)})
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
    |> Repo.preload([:likes, :user])
  end
end
