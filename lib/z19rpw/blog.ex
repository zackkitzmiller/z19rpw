defmodule Z19rpw.Blog do
  import Ecto.Query, warn: false
  alias Z19rpw.Repo

  alias Z19rpw.Blog.Post
  require Logger

  def list_posts do
    scoped_posts("2020")
  end

  def list_posts(year \\ 2020, skip_cache) do
    if skip_cache do
      Logger.info("skipping cache and returning posts")
      scoped_posts(year)
    end

    case Memcachir.get("z19rpw:blog:posts_by_year:" <> year) do
      {:ok, resp} ->
        resp

      {:error, message} ->
        Logger.info(message)
        posts = scoped_posts(year)
        Memcachir.set("z19rpw:blog:posts_by_year:" <> year, posts, ttl: 300)
        posts
    end
  end

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
    Memcachir.flush()
  end

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

  defp scoped_posts(year) do
    Repo.all(
      from p in Post,
        where:
          fragment(
            "status != 'draft' and extract(year from inserted_at)::string = ?",
            ^year
          ),
        order_by: [desc: p.id]
    )
  end
end
