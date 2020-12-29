defmodule Z19rpw.BlogTest do
  @moduledoc """
  Test module for the Pure blog functionality
  """
  use Z19rpw.DataCase

  alias Z19rpw.Blog
  alias Z19rpw.Users.User

  @password "secret1234"

  setup do
    user =
      %User{}
      |> User.changeset(%{
        email: "test@example.com",
        password: @password,
        password_confirmation: @password
      })
      |> Repo.insert!()

    {:ok, user: user |> struct(%{password: nil})}
  end

  describe "posts" do
    alias Z19rpw.Blog.Post

    @valid_attrs %{body: "some body", title: "some title"}
    @update_attrs %{body: "some updated body", title: "some updated title"}
    @invalid_attrs %{body: "", title: ""}

    def post_fixture(attrs \\ %{}, %User{} = user) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_post(user)

      post |> Z19rpw.Repo.preload([:likes, :user])
    end

    test "list_posts/0 returns all posts", %{:user => user} do
      post = post_fixture(user) |> Z19rpw.Repo.preload([:likes, :user])
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id", %{:user => user} do
      post = post_fixture(user) |> Z19rpw.Repo.preload(:likes)
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post", %{:user => user} do
      assert {:ok, %Post{} = post} = Blog.create_post(@valid_attrs, user)
      assert post.body == "some body"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset", %{:user => user} do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs, user)
    end

    test "update_post/2 with valid data updates the post", %{:user => user} do
      post = post_fixture(user)
      assert {:ok, %Post{} = post} = Blog.update_post(post, @update_attrs)
      assert post.body == "some updated body"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset", %{:user => user} do
      post = post_fixture(user) |> Z19rpw.Repo.preload([:likes, :user])
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post", %{:user => user} do
      post = post_fixture(user)
      assert {:ok, _} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset", %{:user => user} do
      post = post_fixture(user)
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end
