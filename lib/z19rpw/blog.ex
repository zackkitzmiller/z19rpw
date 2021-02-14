defmodule Z19rpw.Blog do
  @moduledoc false
  import Ecto.Query, warn: false

  use Z19rpw.Cachier

  alias Z19rpw.Repo
  alias Z19rpw.Blog.{Post, Post.Like}
  alias Z19rpw.Users.User

  require Logger

  @decorate write_through()
  def list_posts() do
    filter(%{})
  end

  @decorate write_through()
  def list_posts(params) do
    filter(params)
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

  def subscribe do
    Phoenix.PubSub.subscribe(Z19rpw.PubSub, "blog")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(Z19rpw.PubSub, "blog", {event, post |> Repo.preload(:likes)})
    Memcachir.flush()
    {:ok, post}
  end

  defp filter(params) do
    Post
    |> join(:inner, [p], assoc(p, :user), as: :user)
    |> where([p], p.status != "draft")
    |> where(^filter_where(params))
    |> order_by(^filter_order_by("inserted_at"))
    |> preload([:likes, :user])
    |> Repo.all()
  end

  defp filter_order_by("inserted_at"),
    do: [desc: dynamic([p], p.inserted_at)]

  defp filter_where(params) do
    Enum.reduce(params, dynamic(true), fn
      {"username", value}, dynamic ->
        dynamic([user: u], ^dynamic and u.username == ^value)

      {_, _}, dynamic ->
        # Not a where parameter
        dynamic
    end)
  end
end
