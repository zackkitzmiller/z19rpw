defmodule Z19rpw.LikeTest do
  use Z19rpw.DataCase

  alias Z19rpw.{Blog, Blog.Post, Blog.Post.Like}

  describe "posts" do
    @valid_attrs %{author: 42, body: "some body", title: "some title"}
    @update_attrs %{author: 43, body: "some updated body", title: "some updated title"}
    @invalid_attrs %{author: nil, body: "", title: ""}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_post()

      post
    end

    test "default posts have no likes" do
      post = post_fixture() |> Z19rpw.Repo.preload(:likes)
      assert post.likes == []
    end

    test "liking a post creates a like" do
      post = post_fixture() |> Z19rpw.Repo.preload(:likes)
      user = Z19rpw.Repo.insert!(%Z19rpw.Users.User{email: "test@example.com"})
      like = Z19rpw.Repo.insert!(%Like{post: post, user: user})

      liked_post = Blog.get_post!(post.id) |> Z19rpw.Repo.preload(:likes)
      post_like = Repo.get!(Like, like.id)
      assert liked_post.likes == [post_like]
    end
  end
end
