defmodule Z19rpwWeb.PostLive.Index do
  @moduledoc false

  use Z19rpwWeb, :live_view

  alias Z19rpwWeb.Credentials
  alias Z19rpw.Blog
  alias Z19rpw.Blog.Post

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Blog.subscribe()
    current_user = Credentials.get_user(socket, session)

    socket =
      socket
      |> assign(:posts, Blog.list_posts())
      |> assign(:current_user, current_user)
      |> assign(:page_title, "blog")

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "write your thoughts bitch")
    |> assign(:post, %Post{})
    |> assign(:current_user, socket.assigns.current_user)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "blog")
    |> assign(:current_user, socket.assigns.current_user)
  end

  defp apply_action(socket, :user, %{"username" => username}) do
    socket
    |> assign(:page_title, "user")
    |> assign(:posts, Blog.list_posts(%{"username" => username}))
    |> assign(:current_user, socket.assigns.current_user)
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  def handle_info({:post_updated, updated_post}, socket) do
    {:noreply,
     update(socket, :posts, fn posts ->
       for post <- posts do
         case post.id == updated_post.id do
           true -> updated_post
           _ -> post
         end
       end
     end)}
  end

  def handle_info({:post_deleted, deleted_post}, socket) do
    {:noreply,
     update(socket, :posts, fn posts ->
       posts
       |> Enum.reject(fn post ->
         post.id == deleted_post.id
       end)
     end)}
  end
end
