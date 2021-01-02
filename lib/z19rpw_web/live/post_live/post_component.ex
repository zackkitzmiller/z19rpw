defmodule Z19rpwWeb.PostLive.PostComponent do
  @moduledoc false

  use Z19rpwWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="card article" id="post-<%= @post.id %>">
      <div class="card-content">
        <div class="media">
          <div class="media-content has-text-centered">
            <p class="title article-title"><%= live_patch @post.title, to: Routes.post_show_path(@socket, :show, @post.slug) %></p>
            <div class="tags has-addons level-item">
              <span class="tag is-rounded is-info">@<%= @post.user.username %></span>
                <a href="#" phx-click="like" phx-value-slug="<%= @post.slug %>" phx-target="<%= @myself %>">
                  <span class="tag">
                    <i class="far fa-heart"></i>
                    &nbsp;<%= length(@post.likes) %>
                  </span>
                </a>
              <span class="tag is-rounded"><%= @post.inserted_at |> Timex.format!("%Y-%m-%d %H:%I", :strftime) %></span>
            </div>
          </div>
        </div>
        <div class="content article-body">
          <%=  raw @post.body |> Earmark.as_html!  %>
        </div>
          <div class="container">
            <span><%= live_redirect "<i class=\"fas fa-chevron-circle-left\"></i>" |> raw, to: Routes.post_index_path(@socket, :index) %></span>
              <%= if !is_nil(@current_user) and @current_user.id == @post.user_id do %>
                <%= link to: "#", phx_click: "delete", phx_value_slug: @post.slug, phx_target: @myself do %>
                  <span class="icon is-pulled-right">
                    <i class="far fa-trash-alt"></i>
                  </span>
                <% end %>
                <span class="is-pulled-right"><%= live_patch "<i class=\"fas fa-edit\"></i>" |> raw, to: Routes.post_show_path(@socket, :edit, @post.slug) %></span>
              <% end %>
            </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("delete", %{"slug" => slug}, socket) do
    post = Z19rpw.Blog.get_post_by_slug!(slug)

    case Z19rpw.Blog.delete_post(post, socket.assigns.current_user) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "post deleted. sure as fuck hope you meant that.")
         |> push_redirect(to: Routes.post_index_path(socket, :index))}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "broooo.. not your post. Not cool.")
         |> push_redirect(to: Routes.post_show_path(socket, :show, slug))}
    end
  end

  def handle_event("like", %{"slug" => slug}, socket) do
    require Logger

    case socket.assigns.current_user do
      nil ->
        Logger.info("no user")

        {:noreply,
         socket
         |> put_flash(:error, "Login to like this post")
         |> push_redirect(
           to:
             Routes.pow_session_path(socket, :new) <>
               URI.encode("?request_path=" <> Routes.post_show_path(socket, :show, slug))
         )}

      %Z19rpw.Users.User{} ->
        Logger.info("ok")

        {:ok, _} =
          Z19rpw.Blog.like_post(Z19rpw.Blog.get_post_by_slug!(slug), socket.assigns.current_user)

        {:noreply, socket}
    end
  end
end
