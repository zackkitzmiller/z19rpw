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
  @invalid_attrs %{author: nil, body: nil, slug: nil, status: nil, title: nil}

  def fixture(:post) do
    {:ok, post} = Blog.create_post(@create_attrs)
    post
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show post" do
    test "renders error when post dne", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn -> get(conn, Routes.post_path(conn, :show, 1)) end
    end

    test "renders post json with a good post", %{conn: conn} do
      {_, post} = Blog.create_post(@create_attrs)
      conn = get(conn, Routes.post_path(conn, :show, post.id))

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
    test "renders post when data is valid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.post_path(conn, :show, id))

      assert %{
               "id" => _,
               "author" => 1,
               "body" => "some body",
               "slug" => "this-is-a-great-computer-machine",
               "status" => "active",
               "title" => "this is a great computer machine"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update post" do
    setup [:create_post]

    test "renders post when data is valid", %{conn: conn, post: %Post{id: id} = post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.post_path(conn, :show, id))

      assert %{
               "id" => _,
               "author" => 1,
               "body" => "some updated body",
               "slug" => "fuck-this-computer-i-cant-make-it-work",
               "status" => "active",
               "title" => "fuck this computer i cant make it work"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    %{post: post}
  end
end
