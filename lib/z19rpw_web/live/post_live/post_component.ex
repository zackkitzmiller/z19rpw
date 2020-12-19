defmodule Z19rpwWeb.PostLive.PostComponent do
  @moduledoc false

  use Z19rpwWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="card article" id="post-<%= @post.id %>">
      <div class="card-content">
        <div class="media">
          <div class="media-content has-text-centered">
            <p class="title article-title"><%= live_patch @post.title, to: Routes.post_show_path(@socket, :show, @post.slug) %></p>
            <div class="tags has-addons level-item">
              <span class="tag is-rounded is-info">@zackkitzmiller</span>
                <a href="#" phx-click="like" phx-value-slug="<%= @post.slug %>">
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
        <%= if @current_user do %>
          <div class="container">
            <span><%= live_redirect "<i class=\"fas fa-chevron-circle-left\"></i>" |> raw, to: Routes.post_index_path(@socket, :index) %></span>
            <%= link to: "#", phx_click: "delete", phx_value_slug: @post.slug do %>
              <span class="icon is-pulled-right">
                <i class="far fa-trash-alt"></i>
              </span>
            <% end %>
            <span class="is-pulled-right"><%= live_patch "<i class=\"fas fa-edit\"></i>" |> raw, to: Routes.post_show_path(@socket, :edit, @post.slug) %></span>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
