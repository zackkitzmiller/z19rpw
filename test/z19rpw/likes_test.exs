defmodule Z19rpw.LikeTest do
  @moduledoc """
  Test module for Like Functionality
  """
  use Z19rpw.DataCase

  alias Z19rpw.{Blog, Blog.Post.Like}
  alias Z19rpw.Users.User

  @password "secret1234"

  setup do
    user =
      %User{}
      |> User.changeset(%{
        email: "test@example.com",
        password: @password,
        username: "zebracakez",
        password_confirmation: @password
      })
      |> Repo.insert!()

    {:ok, user: user}
  end

  describe "posts" do
    @valid_attrs %{
      body: "some body",
      title: "some title"
    }

    def post_fixture(attrs \\ %{}, user) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_post(user)

      post
    end

    test "default posts have no likes", state do
      post = post_fixture(state[:user]) |> Z19rpw.Repo.preload(:likes)
      assert post.likes == []
    end

    test "like_post/2 creates a like when no like exists", state do
      post = post_fixture(state[:user]) |> Z19rpw.Repo.preload(:likes)
      user = Z19rpw.Repo.insert!(%Z19rpw.Users.User{email: "test2@example.com"})
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

    test "like_post/2 deletes a like when a like exists", state do
      post = post_fixture(state[:user]) |> Z19rpw.Repo.preload(:likes)
      user = Z19rpw.Repo.insert!(%Z19rpw.Users.User{email: "test3@example.com"})
      {:ok, post} = Blog.like_post(post, user)
      {:ok, post} = Blog.like_post(post, user)

      assert [] = post.likes
    end
  end
end
