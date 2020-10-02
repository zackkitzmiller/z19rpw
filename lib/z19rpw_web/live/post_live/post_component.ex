defmodule Z19rpwWeb.PostLive.PostComponent do
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
              <span class="tag is-rounded">May 10, 2018</span>
            </div>
          </div>
        </div>
        <div class="content article-body">
          <%=  raw @post.body |> Earmark.as_html!  %>
        </div>
      </div>
    </div>
    """
  end
end
