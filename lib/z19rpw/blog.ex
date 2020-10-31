defmodule Z19rpw.Blog do
  @moduledoc """
  The Blog context.
  """
  import Ecto.Query, warn: false
  alias Z19rpw.Repo

  alias Z19rpw.Blog.Post
  require Logger

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts(year \\ 2020) do
    case Memcachir.get("z19rpw:blog:posts_by_year:" <> year) do
      {:ok, resp} ->
        resp

      {:error, message} ->
        Logger.info(message)

        posts =
          Repo.all(
            from p in Post,
              where:
                fragment(
                  "status != 'draft' and extract(year from inserted_at)::string = ?",
                  ^year
                ),
              order_by: [desc: p.id]
          )

        Memcachir.set("z19rpw:blog:posts_by_year:" <> year, posts, ttl: 300)
        posts
    end
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  def get_post_by_slug!(slug) do
    case Memcachir.get("z19rpw:blog:post_by_slug:" <> slug) do
      {:ok, resp} ->
        resp

      {:error, message} ->
        Logger.info(message)

        post = Repo.one!(from p in Post, where: p.slug == ^slug)

        Memcachir.set("z19rpw:blog:post_by_slug:" <> slug, post, ttl: 500)
        post
    end
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:post_created)
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
    |> broadcast(:post_updated)
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
    Memcachir.flush()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def publication_years do
    case Memcachir.get("z19rpw:bl0g:publication_years") do
      {:ok, resp} ->
        resp

      {:error, message} ->
        Logger.info(message)

        years =
          Post
          |> select(fragment("extract(year from inserted_at) as year"))
          |> where([p], p.status == "active")
          |> group_by(fragment("year"))
          |> having(count("id") > 0)
          |> Repo.all()
          |> Enum.sort()
          |> Enum.map(&floor/1)
          |> Enum.map(&to_string/1)

        Memcachir.set("z19rpw:bl0g:publication_years", years, ttl: 24 * 60 * 60)
        years
    end
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
end
