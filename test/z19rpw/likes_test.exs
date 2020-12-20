defmodule Z19rpw.LikeTest do
  @moduledoc """
  Test module for Like Functionality
  """
  use Z19rpw.DataCase

  alias Z19rpw.{Blog, Blog.Post.Like}

  describe "posts" do
    @valid_attrs %{author: 42, body: "some body", title: "some title"}

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

    test "like_post/2 creates a like when no like exists" do
      post = post_fixture() |> Z19rpw.Repo.preload(:likes)
      user = Z19rpw.Repo.insert!(%Z19rpw.Users.User{email: "test@example.com"})
      {:ok, post} = Blog.like_post(post, user)

      user_id = user.id
      post_id = post.id

      assert [
               %Like{
                 :id => _,
                 :user_id => ^user_id,
                 :post_id => ^post_id
               }
             ] = post.likes
    end

    test "like_post/2 deletes a like when a like exists" do
      post = post_fixture() |> Z19rpw.Repo.preload(:likes)
      user = Z19rpw.Repo.insert!(%Z19rpw.Users.User{email: "test@example.com"})
      {:ok, post} = Blog.like_post(post, user)
      {:ok, post} = Blog.like_post(post, user)

      assert [] = post.likes
    end
  end
end
