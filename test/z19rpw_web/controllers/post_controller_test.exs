defmodule Z19rpwWeb.PostControllerTest do
  @moduledoc """
  Test module for the Post Controller
  """
  use Z19rpwWeb.ConnCase

  alias Z19rpw.Blog
  alias Z19rpw.Blog.Post
  alias Z19rpw.Users.User
  alias Z19rpw.Repo

  @create_attrs %{
    body: "some body",
    title: "this is a great computer machine"
  }
  @update_attrs %{
    body: "some updated body",
    title: "fuck this computer i cant make it work"
  }
  @invalid_attrs %{body: "", slug: "", status: "", title: ""}

  @password "secret1234"

  def user_fixture do
    user =
      %User{}
      |> User.changeset(%{
        email: "test@example.com",
        password: @password,
        password_confirmation: @password
      })
      |> Repo.insert!()

    user |> struct(%{password: nil})
  end

  def fixture(:post) do
    {:ok, post} = Blog.create_post(@create_attrs, user_fixture())

    post |> Repo.preload([:likes, :user])
  end

  setup %{conn: conn} do
    user = %User{email: "test@example.com", id: Ecto.UUID.generate()}
    authed_conn = Pow.Plug.assign_current_user(conn, user, [])

    {:ok, conn: put_req_header(conn, "accept", "application/json"), authed_conn: authed_conn}
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.api_post_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show post" do
    test "renders error when post dne", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        get(conn, Routes.api_post_path(conn, :show, Ecto.UUID.generate()))
      end
    end

    test "renders post json with a good post", %{conn: conn} do
      {_, post} = Blog.create_post(@create_attrs, user_fixture())
      conn = get(conn, Routes.api_post_path(conn, :show, post.id))

      assert %{
               "id" => _,
               "body" => "some body",
               "slug" => "this-is-a-great-computer-machine",
               "status" => "active",
               "user" => _,
               "title" => "this is a great computer machine"
             } = json_response(conn, 200)["data"]
    end
  end

  describe "create post" do
    test "renders post when data is valid authed", %{authed_conn: authed_conn} do
      authed_conn =
        post(authed_conn, Routes.api_post_path(authed_conn, :create), post: @create_attrs)

      assert %{"id" => id} = json_response(authed_conn, 201)["data"]

      authed_conn = get(authed_conn, Routes.api_post_path(authed_conn, :show, id))

      assert %{
               "id" => _,
               "body" => "some body",
               "slug" => "this-is-a-great-computer-machine",
               "status" => "active",
               "title" => "this is a great computer machine"
             } = json_response(authed_conn, 200)["data"]
    end

    test "renders errors when data is invalid when authed with correct user", %{
      authed_conn: authed_conn
    } do
      authed_conn =
        post(authed_conn, Routes.api_post_path(authed_conn, :create), post: @invalid_attrs)

      assert json_response(authed_conn, 422)["errors"] != %{}
    end

    test "errors when unauthenticated", %{conn: conn} do
      conn = post(conn, Routes.api_post_path(conn, :create), post: @create_attrs)

      assert %{"message" => "uh uh uh. you didnt say the magic word"} =
               json_response(conn, 401)["error"]
    end
  end

  describe "update post" do
    setup [:create_post]

    test "failure on incorrect or invalid user", %{
      authed_conn: authed_conn,
      post: %Post{id: id} = post
    } do
      authed_conn =
        put(authed_conn, Routes.api_post_path(authed_conn, :update, post), post: @update_attrs)

      assert %{"errors" => %{"detail" => "Forbidden"}} = json_response(authed_conn, 401)

      authed_conn = get(authed_conn, Routes.api_post_path(authed_conn, :show, id))

      assert %{
               "id" => _,
               "body" => "some body",
               "slug" => "this-is-a-great-computer-machine",
               "status" => "active",
               "title" => "this is a great computer machine"
             } = json_response(authed_conn, 200)["data"]
    end

    test "renders updated post when data is valid and user authenticated", %{
      authed_conn: authed_conn,
      post: %Post{id: id} = post
    } do
      authed_conn =
        put(
          Pow.Plug.assign_current_user(authed_conn, post.user, []),
          Routes.api_post_path(authed_conn, :update, post),
          post: @update_attrs
        )

      assert %{"id" => ^id} = json_response(authed_conn, 200)["data"]

      authed_conn = get(authed_conn, Routes.api_post_path(authed_conn, :show, id))

      assert %{
               "id" => _,
               "body" => "some updated body",
               "slug" => "fuck-this-computer-i-cant-make-it-work",
               "status" => "active",
               "title" => "fuck this computer i cant make it work"
             } = json_response(authed_conn, 200)["data"]
    end

    test "errors when post does not exist and user authenticated", %{
      authed_conn: authed_conn
    } do
      assert_error_sent :not_found, fn ->
        put(
          authed_conn,
          Routes.api_post_path(authed_conn, :update, %Post{id: Ecto.UUID.generate()}),
          post: @update_attrs
        )
      end
    end

    test "errors when data is invalid and user authenticated", %{
      authed_conn: authed_conn,
      post: post
    } do
      authed_conn =
        put(
          Pow.Plug.assign_current_user(authed_conn, post.user, []),
          Routes.api_post_path(authed_conn, :update, post),
          post: @invalid_attrs
        )

      assert json_response(authed_conn, 422)["errors"] != %{}
    end

    test "errors when unauthenticated", %{
      conn: conn,
      post: %Post{} = post
    } do
      conn = put(conn, Routes.api_post_path(conn, :update, post), post: @update_attrs)

      assert %{"message" => "uh uh uh. you didnt say the magic word"} =
               json_response(conn, 401)["error"]
    end
  end

  describe "delete existing post" do
    setup [:create_post]

    test "failed when user incorrect", %{authed_conn: authed_conn, post: post} do
      authed_conn = delete(authed_conn, Routes.api_post_path(authed_conn, :delete, post))
      assert response(authed_conn, 401)

      authed_conn = get(authed_conn, Routes.api_post_path(authed_conn, :show, post))
      assert response(authed_conn, 200)
    end

    test "deletes post when user authenticated", %{authed_conn: authed_conn, post: post} do
      authed_conn =
        delete(
          Pow.Plug.assign_current_user(authed_conn, post.user, []),
          Routes.api_post_path(authed_conn, :delete, post)
        )

      assert response(authed_conn, 204)

      assert_error_sent 404, fn ->
        get(authed_conn, Routes.api_post_path(authed_conn, :show, post))
      end
    end

    test "errors when post does not exist and user authenticated", %{
      authed_conn: authed_conn
    } do
      assert_error_sent :not_found, fn ->
        delete(
          authed_conn,
          Routes.api_post_path(authed_conn, :delete, %Post{id: Ecto.UUID.generate()}),
          post: @update_attrs
        )
      end
    end

    test "errors when unauthenticated", %{conn: conn, post: post} do
      conn = delete(conn, Routes.api_post_path(conn, :delete, post))

      assert %{"message" => "uh uh uh. you didnt say the magic word"} =
               json_response(conn, 401)["error"]
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    %{post: post}
  end
end
