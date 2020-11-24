defmodule Z19rpwWeb.PostControllerTest do
  use Z19rpwWeb.ConnCase

  alias Z19rpw.Blog
  alias Z19rpw.Blog.Post

  @create_attrs %{
    author: 1,
    body: "some body",
    title: "this is a great computer machine"
  }
  @update_attrs %{
    author: 1,
    body: "some updated body",
    title: "fuck this computer i cant make it work"
  }
  @invalid_attrs %{author: "", body: "", slug: "", status: "", title: ""}

  def fixture(:post) do
    {:ok, post} = Blog.create_post(@create_attrs)
    post
  end

  setup %{conn: conn} do
    user = %Z19rpw.Users.User{email: "test@example.com", id: 1}
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
      assert_raise Ecto.NoResultsError, fn -> get(conn, Routes.api_post_path(conn, :show, 1)) end
    end

    test "renders post json with a good post", %{conn: conn} do
      {_, post} = Blog.create_post(@create_attrs)
      conn = get(conn, Routes.api_post_path(conn, :show, post.id))

      assert %{
               "id" => _,
               "author" => 1,
               "body" => "some body",
               "slug" => "this-is-a-great-computer-machine",
               "status" => "active",
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
               "author" => 1,
               "body" => "some body",
               "slug" => "this-is-a-great-computer-machine",
               "status" => "active",
               "title" => "this is a great computer machine"
             } = json_response(authed_conn, 200)["data"]
    end

    test "renders errors when data is invalid when authed", %{authed_conn: authed_conn} do
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

    test "renders updated post when data is valid and user authenticated", %{
      authed_conn: authed_conn,
      post: %Post{id: id} = post
    } do
      authed_conn =
        put(authed_conn, Routes.api_post_path(authed_conn, :update, post), post: @update_attrs)

      id = Integer.to_string(id)

      assert %{"id" => ^id} = json_response(authed_conn, 200)["data"]

      authed_conn = get(authed_conn, Routes.api_post_path(authed_conn, :show, id))

      assert %{
               "id" => _,
               "author" => 1,
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
        put(authed_conn, Routes.api_post_path(authed_conn, :update, %Post{id: 188_827_177}),
          post: @update_attrs
        )
      end
    end

    test "errors when data is invalid and user authenticated", %{
      authed_conn: authed_conn,
      post: post
    } do
      authed_conn =
        put(authed_conn, Routes.api_post_path(authed_conn, :update, post), post: @invalid_attrs)

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

    test "deletes post when user authenticated", %{authed_conn: authed_conn, post: post} do
      authed_conn = delete(authed_conn, Routes.api_post_path(authed_conn, :delete, post))
      assert response(authed_conn, 204)

      assert_error_sent 404, fn ->
        get(authed_conn, Routes.api_post_path(authed_conn, :show, post))
      end
    end

    test "errors when post does not exist and user authenticated", %{
      authed_conn: authed_conn
    } do
      assert_error_sent :not_found, fn ->
        delete(authed_conn, Routes.api_post_path(authed_conn, :delete, %Post{id: 188_827_177}),
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
