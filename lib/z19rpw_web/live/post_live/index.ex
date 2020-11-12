defmodule Z19rpwWeb.PostLive.Index do
  use Z19rpwWeb, :live_view

  alias Z19rpwWeb.Credentials
  alias Z19rpw.Blog
  alias Z19rpw.Blog.Post

  @impl true
  def mount(params, session, socket) do
    if connected?(socket), do: Blog.subscribe()
    current_user = Credentials.get_user(socket, session)

    year = Map.get(params, "year", "2020")
    skip_cache = Map.get(params, "skip_cache", false)

    socket =
      socket
      |> assign(:posts, list_posts(year, skip_cache))
      |> assign(:current_user, current_user)
      |> assign(:years, Blog.publication_years())
      |> assign(:selected_year, year)

    {:ok, socket, temporary_assigns: [posts: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Blog.get_post!(id))
    |> assign(:current_user, socket.assigns.current_user)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
    |> assign(:current_user, socket.assigns.current_user)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
    |> assign(:current_user, socket.assigns.current_user)
  end

  @impl true
  def handle_event("delete", %{"slug" => slug}, socket) do
    post = Blog.get_post_by_slug!(slug)
    {:ok, _} = Blog.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts())}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  defp list_posts(year \\ "2020", skip_cache \\ false) do
    Blog.list_posts(year, skip_cache)
  end
end
