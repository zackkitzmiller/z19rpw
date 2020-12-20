defmodule Z19rpwWeb.PostLive.Show do
  @moduledoc false
  use Z19rpwWeb, :live_view

  alias Z19rpw.Blog
  alias Z19rpwWeb.Credentials
  require Logger

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Blog.subscribe()

    current_user = Credentials.get_user(socket, session)

    {:ok, socket |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_params(%{"slug" => slug}, _, socket) do
    post = Blog.get_post_by_slug!(slug)

    {:noreply,
     socket
     |> assign(:post, post)
     |> assign(:page_title, post.title)}
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    {:noreply, update(socket, :post, fn _ -> post end)}
  end
end
