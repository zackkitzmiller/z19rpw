defmodule Z19rpwWeb.PostView do
  use Z19rpwWeb, :view
  alias Z19rpwWeb.PostView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      title: post.title,
      author: post.author,
      body: post.body,
      status: post.status,
      slug: post.slug
    }
  end
end
